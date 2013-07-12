Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701Ab3GLJtB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 05:49:01 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:45035 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350Ab3GLJtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 05:49:00 -0400
Date: Fri, 12 Jul 2013 12:48:30 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Yann Collet <yann.collet.73@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Kyungsik Lee <kyungsik.lee@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] LZ4: compression/decompression signedness mismatch
Message-ID: <20130712094830.GA2257@swordfish.minsk.epam.com>
References: <20130712092400.GA2565@swordfish>
 <CADv+DGka4s1xc2UYqu+-EqHW8jA56JrtEE_sMsMOpc6NDmc6Zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADv+DGka4s1xc2UYqu+-EqHW8jA56JrtEE_sMsMOpc6NDmc6Zw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (07/12/13 11:28), Yann Collet wrote:
>    The reference implementation, hosted at :�
>    [1]https://code.google.com/p/lz4/
>    only proposes char* (signed) types as part of the interface contract.
>    I would recommend to keep it that way, to remain consistent.
>    Regards

Crypto lz4 accepts u8 * for both compression and decompression:

 lz4_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
                            unsigned int slen, u8 *dst, unsigned int *dlen)

 lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
                       unsigned int slen, u8 *dst, unsigned int *dlen)


Internally LZ4 may cast unsigned char* to signed char*, the same way you
already do with compression:

	int lz4_compress(const unsigned char *src, size_t src_len,
			unsigned char *dst, size_t *dst_len, void *wrkmem)

		calls:
			lz4_compressctx(void *ctx,
				const char *source, char *dest,
				int isize, int maxoutputsize)



At the moment API is a bit misaligned: unsiged char* for compression and signed char* for
decompression.


My 'real word' use case is, suppose:

	struct foo {
	[..]
		int (*compress)(const unsigned char *src, size_t src_len,
				unsigned char *dst, size_t *dst_len, void *wrkmem);
		int (*decompress)(const unsigned char *src, size_t src_len,
				unsigned char *dst, size_t *dst_len);
	};


and (for example) module also provides sysfs attribute, so user can switch select
LZO or LZ4 compressions depending of his needs:

	->compress = lzo1x_1_compress;
	->decompress = lzo1x_decompress_safe;

to
	->compress = lz4_compress;
	->decompress = lz4_decompress_unknownoutputsize;


the last one produces unneccessary compilation warning.


	-ss

>    2013/7/12 Sergey Senozhatsky <[2]sergey.senozhatsky@gmail.com>
> 
>      LZ4 compression and decompression functions require different
>      in signedness input/output parameters: unsigned char for
>      compression and signed char for decompression.
> 
>      Change decompression API to require unsigned char.
> 
>      Signed-off-by: Sergey Senozhatsky <[3]sergey.senozhatsky@gmail.com>
> 
>      ---
> 
>      �include/linux/lz4.h � � �| 8 ++++----
>      �lib/lz4/lz4_decompress.c | 8 ++++----
>      �2 files changed, 8 insertions(+), 8 deletions(-)
> 
>      diff --git a/include/linux/lz4.h b/include/linux/lz4.h
>      index d21c13f..c13f0bc 100644
>      --- a/include/linux/lz4.h
>      +++ b/include/linux/lz4.h
>      @@ -67,8 +67,8 @@ int lz4hc_compress(const unsigned char *src, size_t
>      src_len,
>      � * � � note : �Destination buffer must be already allocated.
>      � * � � � � � � slightly faster than lz4_decompress_unknownoutputsize()
>      � */
>      -int lz4_decompress(const char *src, size_t *src_len, char *dest,
>      - � � � � � � � size_t actual_dest_len);
>      +int lz4_decompress(unsigned const char *src, size_t *src_len,
>      + � � � � � � � unsigned char *dest, size_t actual_dest_len);
> 
>      �/*
>      � * lz4_decompress_unknownoutputsize()
>      @@ -82,6 +82,6 @@ int lz4_decompress(const char *src, size_t *src_len,
>      char *dest,
>      � * � � � � � � � Error if return (< 0)
>      � * � � note : �Destination buffer must be already allocated.
>      � */
>      -int lz4_decompress_unknownoutputsize(const char *src, size_t src_len,
>      - � � � � � � � char *dest, size_t *dest_len);
>      +int lz4_decompress_unknownoutputsize(unsigned const char *src, size_t
>      src_len,
>      + � � � � � � � unsigned char *dest, size_t *dest_len);
>      �#endif
>      diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
>      index d3414ea..7ceda1f 100644
>      --- a/lib/lz4/lz4_decompress.c
>      +++ b/lib/lz4/lz4_decompress.c
>      @@ -283,8 +283,8 @@ _output_error:
>      � � � � return (int) (-(((char *) ip) - source));
>      �}
> 
>      -int lz4_decompress(const char *src, size_t *src_len, char *dest,
>      - � � � � � � � size_t actual_dest_len)
>      +int lz4_decompress(unsigned const char *src, size_t *src_len,
>      + � � � � � � � unsigned char *dest, size_t actual_dest_len)
>      �{
>      � � � � int ret = -1;
>      � � � � int input_len = 0;
>      @@ -302,8 +302,8 @@ exit_0:
>      �EXPORT_SYMBOL_GPL(lz4_decompress);
>      �#endif
> 
>      -int lz4_decompress_unknownoutputsize(const char *src, size_t src_len,
>      - � � � � � � � char *dest, size_t *dest_len)
>      +int lz4_decompress_unknownoutputsize(unsigned const char *src, size_t
>      src_len,
>      + � � � � � � � unsigned char *dest, size_t *dest_len)
>      �{
>      � � � � int ret = -1;
>      � � � � int out_len = 0;
> 
> References
> 
>    Visible links
>    1. https://code.google.com/p/lz4/
>    2. mailto:sergey.senozhatsky@gmail.com
>    3. mailto:sergey.senozhatsky@gmail.com
