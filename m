Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbaFDMq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 08:46:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305AbaFDMqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 08:46:55 -0400
Message-ID: <538F1535.3080500@redhat.com>
Date: Wed, 04 Jun 2014 14:46:45 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: davem@davemloft.net, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/3] lib: crc32: Greatly shrink CRC combining code
References: <20140530053505.18155.qmail@ns.horizon.com>
In-Reply-To: <20140530053505.18155.qmail@ns.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late answer, this slipped somehow through ...

I think you might want to cc Andrew Morton <akpm@linux-foundation.org>
to let this go via akpm's tree for misc changes, perhaps?

The work from my side went via Dave's net-next tree as it had some
follow-up SCTP work that depended on these below bits.

No objections from my side if you really want this to go through
<netdev@vger.kernel.org>, though.

Anyway, some more comments inline:

On 05/30/2014 07:35 AM, George Spelvin wrote:
> There's no need for a full 32x32 matrix, when rows before the last are
> just shifted copies of the rows after them.
>
> There's still room for improvement (especially on X86 processors with
> CRC32 and PCLMUL instructions), but this is a large step in the
> right direction.
>
> The internal primitive is now called crc32_generic_shift and takes one
> less argument; the XOR with crc2 is done in inline wrappers.
>
> Signed-off-by: George Spelvin <linux@horizon.com>
> ---
> This is the significant patch; there other two patches are minor
> cleanups that I did while in the area.
>
> Tested extensively in user-space (the "power" variable is identical
> to the last row of the current even/odd matrix in the previous code)
> and with CONFIG_CRC32_SELFTEST:
>
> [    0.587152] crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
> [    0.587186] crc32: self tests passed, processed 225944 bytes in 115727 nsec
> [    0.587341] crc32c: CRC_LE_BITS = 64
> [    0.587373] crc32c: self tests passed, processed 225944 bytes in 59505 nsec
> [    0.596827] crc32_combine: 8373 self tests passed
> [    0.606259] crc32c_combine: 8373 self tests passed
>
> Code shrunk; comments increased to match.
> Pulling 2x32x32 bits = 256 bytes off the stack is a nice bonus.

Looks good to me! Do you have any performance numbers to share?

Some very minor nit-picking:

>   include/linux/crc32.h |  12 ++++-
>   lib/crc32.c           | 142 +++++++++++++++++++++++---------------------------
>   2 files changed, 76 insertions(+), 78 deletions(-)
>
> diff --git a/include/linux/crc32.h b/include/linux/crc32.h
> index 7d275c4f..bcb8e9d3 100644
> --- a/include/linux/crc32.h
> +++ b/include/linux/crc32.h
> @@ -29,7 +29,11 @@ extern u32  crc32_be(u32 crc, unsigned char const *p, size_t len);
>    * 	   with the same initializer as crc1, and crc2 seed was 0. See
>    * 	   also crc32_combine_test().
>    */
> -extern u32  crc32_le_combine(u32 crc1, u32 crc2, size_t len2);
> +u32  crc32_le_shift(u32 crc, size_t len) __attribute_const__;

Perhaps a newline here.

> +static inline u32  crc32_le_combine(u32 crc1, u32 crc2, size_t len2)
> +{
> +	return crc32_le_shift(crc1, len2) ^ crc2;
> +}
>
>   extern u32  __crc32c_le(u32 crc, unsigned char const *p, size_t len);
>
> @@ -51,7 +55,11 @@ extern u32  __crc32c_le(u32 crc, unsigned char const *p, size_t len);
>    * 	   seeded with the same initializer as crc1, and crc2 seed
>    * 	   was 0. See also crc32c_combine_test().
>    */
> -extern u32  __crc32c_le_combine(u32 crc1, u32 crc2, size_t len2);
> +u32  __crc32c_le_shift(u32 crc, size_t len) __attribute_const__;

Ditto. Or, put both *_shift() helper signatures before the crc32_le_combine
kdoc comment.

> +static inline u32  __crc32c_le_combine(u32 crc1, u32 crc2, size_t len2)
> +{
> +	return __crc32c_le_shift(crc1, len2) ^ crc2;
> +}
>
>   #define crc32(seed, data, length)  crc32_le(seed, (unsigned char const *)(data), length)
>
> diff --git a/lib/crc32.c b/lib/crc32.c
> index 70f00ca5..a4a576f3 100644
...
>
> -u32 __pure __crc32c_le_combine(u32 crc1, u32 crc2, size_t len2)
> +/**
> + * crc32_generic_shift - Append len 0 bytes to crc, in logarithmic time
> + * @crc: The original little-endian CRC (i.e. lsbit is x^31 coefficient)
> + * @len: The number of bytes.  @crc is multiplied by x^(8*@len)
> + # @polynomial: The modulus used to reduce the result to 32 bits.

     ^^ seems this should have been a '*'

> + *
> + * It's possible to parallelize CRC computations by computing a CRC
> + * over separate ranges of a buffer, then summing them.
> + * This shifts the given CRC by 8*len bits (i.e. produces the same effect
> + * as appending len bytes of zero to the data), in time proportional
> + * to log(len).
> + */
> +static u32 __attribute_const__ crc32_generic_shift(u32 crc, size_t len,
> +				 u32 polynomial)

u32 polynomial is not correctly aligned to the opening '(' from the previous line.

>   {
> -	return crc32_generic_combine(crc1, crc2, len2, CRC32C_POLY_LE);
> +	u32 power = polynomial;	/* CRC of x^32 */
> +	int i;
> +
> +	/* Shift up to 32 bits in the simple linear way */
...

The other two patches are fine, imho. Thanks George! :)
