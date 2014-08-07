Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbaHGGnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 02:43:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:45618 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbaHGGnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:43:52 -0400
Message-ID: <53E32022.2090006@infradead.org>
Date: Wed, 06 Aug 2014 23:43:46 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tile: avoid errors from truncating long strings in
 mpipe gxio
References: <1406383386-1400-1-git-send-email-rickard_strandqvist@spectrumdigital.se>  <53E13D78.6000903@tilera.com>  <CAFo99gZ1rOqD-RFN7Shx4mWO4kfVLCXpuxUWqOwK5uY6uwAh3Q@mail.gmail.com> <201408061838.s76Ic6lV014201@farm-0039.internal.tilera.com>
In-Reply-To: <201408061838.s76Ic6lV014201@farm-0039.internal.tilera.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/14 11:16, Chris Metcalf wrote:
> Using strncpy() will just silently truncate long strings; we should
> instead return an appropriate error.  Using strlcpy() would suffer from
> the same problem.  Instead, use strnlen()+memcpy(), and add an
> error-checking step to make sure the lengths are reasonable.
> 
> I called the convenience wrapper strscpy(), and a case could be made for
> making it more generic (possibly with a better name), but that seems
> outside the scope of this initial commit.

Well, having looked at the function before I read this comment, my first
thought was that it should be added to lib/string.c for general
availability.

> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
> v2: use strnlen instead of strlen
> 
>  arch/tile/gxio/mpipe.c | 30 +++++++++++++++++++++++++-----
>  1 file changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/tile/gxio/mpipe.c b/arch/tile/gxio/mpipe.c
> index 5301a9ffbae1..27a56be8d583 100644
> --- a/arch/tile/gxio/mpipe.c
> +++ b/arch/tile/gxio/mpipe.c
> @@ -29,6 +29,25 @@
>  /* HACK: Avoid pointless "shadow" warnings. */
>  #define link link_shadow
>  
> +/*
> + * Use this routine to avoid copying too-long strings.  Unlike strncpy
> + * or strlcpy, we don't enable programmers who don't check return codes;
> + * partially-copied strings can be problematic.  The routine returns
> + * the total number of bytes copied (including the trailing NUL) or
> + * zero if the buffer wasn't big enough.
> + */
> +static size_t strscpy(char *dest, const char *src, size_t size)
> +{
> +	size_t ret = strnlen(src, size) + 1;
> +	if (ret > size) {
> +		if (size)
> +			dest[0] = '\0';
> +		return 0;
> +	}
> +	memcpy(dest, src, ret);
> +	return ret;
> +}

-- 
~Randy
