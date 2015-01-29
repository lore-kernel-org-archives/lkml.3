Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbbA2MMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 07:12:48 -0500
Received: from mga03.intel.com ([134.134.136.65]:35481 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbbA2MMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 07:12:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,485,1418112000"; 
   d="scan'208";a="669664237"
Message-ID: <1422533541.31903.314.camel@linux.intel.com>
Subject: Re: [PATCH v2 2/3] lib/string_helpers.c: Refactor string_escape_mem
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mathias Krause <minipli@googlemail.com>, linux-kernel@vger.kernel.org
Date: Thu, 29 Jan 2015 14:12:21 +0200
In-Reply-To: <1422525801-26560-3-git-send-email-linux@rasmusvillemoes.dk>
References: <1422451543-12401-1-git-send-email-linux@rasmusvillemoes.dk>
	 <1422525801-26560-1-git-send-email-linux@rasmusvillemoes.dk>
	 <1422525801-26560-3-git-send-email-linux@rasmusvillemoes.dk>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-29 at 11:03 +0100, Rasmus Villemoes wrote:
> When printf is given the format specifier %pE, it needs a way of
> obtaining the total output size that would be generated if the buffer
> was large enough, and string_escape_mem doesn't easily provide
> that. This is a refactorization of string_escape_mem in preparation of
> changing its external API to provide that information.

Few comments below.

> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  lib/string_helpers.c | 182 ++++++++++++++++++++-------------------------------
>  1 file changed, 72 insertions(+), 110 deletions(-)
> 
> diff --git a/lib/string_helpers.c b/lib/string_helpers.c
> index 58b78ba57439..e14dd8555760 100644
> --- a/lib/string_helpers.c
> +++ b/lib/string_helpers.c
> @@ -243,29 +243,21 @@ int string_unescape(char *src, char *dst, size_t size, unsigned int flags)
>  }
>  EXPORT_SYMBOL(string_unescape);
>  
> -static int escape_passthrough(unsigned char c, char **dst, size_t *osz)
> +static bool escape_passthrough(unsigned char c, char **dst, char *end)
>  {
>  	char *out = *dst;
>  
> -	if (*osz < 1)
> -		return -ENOMEM;
> -
> -	*out++ = c;
> -
> -	*dst = out;
> -	*osz -= 1;
> -
> -	return 1;
> +	if (out < end)
> +		*out = c;
> +	*dst = out + 1;
> +	return true;
>  }
>  
> -static int escape_space(unsigned char c, char **dst, size_t *osz)
> +static bool escape_space(unsigned char c, char **dst, char *end)
>  {
>  	char *out = *dst;
>  	unsigned char to;
>  
> -	if (*osz < 2)
> -		return -ENOMEM;
> -
>  	switch (c) {
>  	case '\n':
>  		to = 'n';
> @@ -283,26 +275,23 @@ static int escape_space(unsigned char c, char **dst, size_t *osz)
>  		to = 'f';
>  		break;
>  	default:
> -		return 0;
> +		return false;
>  	}
>  
> -	*out++ = '\\';
> -	*out++ = to;
> +	if (out + 0 < end)
> +		out[0] = '\\';
> +	if (out + 1 < end)
> +		out[1] = to;

Could we do this in the same way like for hex_string, i.e.

if (out < end)
 *out = '\\';
++out;

…

*dst = out;
return true;

?

>  
> -	*dst = out;
> -	*osz -= 2;
> -
> -	return 1;
> +	*dst = out + 2;
> +	return true;
>  }
>  
> -static int escape_special(unsigned char c, char **dst, size_t *osz)
> +static bool escape_special(unsigned char c, char **dst, char *end)
>  {
>  	char *out = *dst;
>  	unsigned char to;
>  
> -	if (*osz < 2)
> -		return -ENOMEM;
> -
>  	switch (c) {
>  	case '\\':
>  		to = '\\';
> @@ -314,71 +303,66 @@ static int escape_special(unsigned char c, char **dst, size_t *osz)
>  		to = 'e';
>  		break;
>  	default:
> -		return 0;
> +		return false;
>  	}
>  
> -	*out++ = '\\';
> -	*out++ = to;
> +	if (out + 0 < end)
> +		out[0] = '\\';
> +	if (out + 1 < end)
> +		out[1] = to;

Ditto.

>  
> -	*dst = out;
> -	*osz -= 2;
> -
> -	return 1;
> +	*dst = out + 2;
> +	return true;
>  }
>  
> -static int escape_null(unsigned char c, char **dst, size_t *osz)
> +static bool escape_null(unsigned char c, char **dst, char *end)
>  {
>  	char *out = *dst;
>  
> -	if (*osz < 2)
> -		return -ENOMEM;
> -
>  	if (c)
> -		return 0;
> -
> -	*out++ = '\\';
> -	*out++ = '0';
> +		return false;
>  
> -	*dst = out;
> -	*osz -= 2;
> +	if (out + 0 < end)
> +		out[0] = '\\';
> +	if (out + 1 < end)
> +		out[1] = '0';


Ditto.

>  
> -	return 1;
> +	*dst = out + 2;
> +	return true;
>  }
>  
> -static int escape_octal(unsigned char c, char **dst, size_t *osz)
> +static bool escape_octal(unsigned char c, char **dst, char *end)
>  {
>  	char *out = *dst;
>  
> -	if (*osz < 4)
> -		return -ENOMEM;
> -
> -	*out++ = '\\';
> -	*out++ = ((c >> 6) & 0x07) + '0';
> -	*out++ = ((c >> 3) & 0x07) + '0';
> -	*out++ = ((c >> 0) & 0x07) + '0';
> +	if (out + 0 < end)
> +		out[0] = '\\';
> +	if (out + 1 < end)
> +		out[1] = ((c >> 6) & 0x07) + '0';
> +	if (out + 2 < end)
> +		out[2] = ((c >> 3) & 0x07) + '0';
> +	if (out + 3 < end)
> +		out[3] = ((c >> 0) & 0x07) + '0';

Ditto.

>  
> -	*dst = out;
> -	*osz -= 4;
> -
> -	return 1;
> +	*dst = out + 4;
> +	return true;
>  }
>  
> -static int escape_hex(unsigned char c, char **dst, size_t *osz)
> +static bool escape_hex(unsigned char c, char **dst, char *end)
>  {
>  	char *out = *dst;
>  
> -	if (*osz < 4)
> -		return -ENOMEM;
> -
> -	*out++ = '\\';
> -	*out++ = 'x';
> -	*out++ = hex_asc_hi(c);
> -	*out++ = hex_asc_lo(c);
> -
> -	*dst = out;
> -	*osz -= 4;
> +	if (out + 0 < end)
> +		out[0] = '\\';
> +	if (out + 1 < end)
> +		out[1] = 'x';
> +	if (out + 2 < end)
> +		out[2] = hex_asc_hi(c);
> +	if (out + 3 < end)
> +		out[3] = hex_asc_lo(c);


Ditto.

>  
> -	return 1;
> +	*dst = out + 4;
> +	return true;
>  }
>  
>  /**
> @@ -440,9 +424,10 @@ static int escape_hex(unsigned char c, char **dst, size_t *osz)
>  int string_escape_mem(const char *src, size_t isz, char **dst, size_t osz,
>  		      unsigned int flags, const char *esc)
>  {
> -	char *out = *dst, *p = out;
> +	char *p = *dst;

Leave 'out' here and…

> +	char *end = p + osz;
>  	bool is_dict = esc && *esc;
> -	int ret = 0;
> +	int ret;
>  
>  	while (isz--) {
>  		unsigned char c = *src++;
> @@ -462,55 +447,32 @@ int string_escape_mem(const char *src, size_t isz, char **dst, size_t osz,
>  		    (is_dict && !strchr(esc, c))) {
>  			/* do nothing */
>  		} else {
> -			if (flags & ESCAPE_SPACE) {
> -				ret = escape_space(c, &p, &osz);
> -				if (ret < 0)
> -					break;
> -				if (ret > 0)
> -					continue;
> -			}
> -
> -			if (flags & ESCAPE_SPECIAL) {
> -				ret = escape_special(c, &p, &osz);
> -				if (ret < 0)
> -					break;
> -				if (ret > 0)
> -					continue;
> -			}
> -
> -			if (flags & ESCAPE_NULL) {
> -				ret = escape_null(c, &p, &osz);
> -				if (ret < 0)
> -					break;
> -				if (ret > 0)
> -					continue;
> -			}
> +			if (flags & ESCAPE_SPACE && escape_space(c, &p, end))
> +				continue;
> +
> +			if (flags & ESCAPE_SPECIAL && escape_special(c, &p, end))
> +				continue;
> +
> +			if (flags & ESCAPE_NULL && escape_null(c, &p, end))
> +				continue;
>  
>  			/* ESCAPE_OCTAL and ESCAPE_HEX always go last */
> -			if (flags & ESCAPE_OCTAL) {
> -				ret = escape_octal(c, &p, &osz);
> -				if (ret < 0)
> -					break;
> +			if (flags & ESCAPE_OCTAL && escape_octal(c, &p, end))
>  				continue;
> -			}
> -			if (flags & ESCAPE_HEX) {
> -				ret = escape_hex(c, &p, &osz);
> -				if (ret < 0)
> -					break;
> +
> +			if (flags & ESCAPE_HEX && escape_hex(c, &p, end))
>  				continue;
> -			}
>  		}
>  
> -		ret = escape_passthrough(c, &p, &osz);
> -		if (ret < 0)
> -			break;
> +		escape_passthrough(c, &p, end);
> +	}

+ black line.

> +	if (p > end) {
> +		*dst = end;
> +		return -ENOMEM;
>  	}
>  
> +	ret = p - *dst;
>  	*dst = p;
> -
> -	if (ret < 0)
> -		return ret;
> -
> -	return p - out;

…and do not change the logic right now. Just substitute if (ret < 0) by
above if (p > end).

> +	return ret;
>  }
>  EXPORT_SYMBOL(string_escape_mem);


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

