Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbbA2NLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:11:00 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:60132 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbbA2NKq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:10:46 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mathias Krause <minipli@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] lib/string_helpers.c: Refactor string_escape_mem
Organization: D03
References: <1422451543-12401-1-git-send-email-linux@rasmusvillemoes.dk>
	<1422525801-26560-1-git-send-email-linux@rasmusvillemoes.dk>
	<1422525801-26560-3-git-send-email-linux@rasmusvillemoes.dk>
	<1422533541.31903.314.camel@linux.intel.com>
X-Hashcash: 1:20:150129:minipli@googlemail.com::dNeb2P4SnqiW7uY1:0000000000000000000000000000000000000000KCu
X-Hashcash: 1:20:150129:akpm@linux-foundation.org::Vs8xCPLIqzcQxzdw:0000000000000000000000000000000000001ZnQ
X-Hashcash: 1:20:150129:linux-kernel@vger.kernel.org::JrlGJLzkCeDYVFN7:0000000000000000000000000000000007UyI
X-Hashcash: 1:20:150129:andriy.shevchenko@linux.intel.com::uTAE7d1bB2QCeCEg:0000000000000000000000000000AFQu
Date: Thu, 29 Jan 2015 14:10:42 +0100
In-Reply-To: <1422533541.31903.314.camel@linux.intel.com> (Andy Shevchenko's
	message of "Thu, 29 Jan 2015 14:12:21 +0200")
Message-ID: <87sietbulp.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29 2015, Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

>>  
>> -static int escape_space(unsigned char c, char **dst, size_t *osz)
>> +static bool escape_space(unsigned char c, char **dst, char *end)
>>  {
>>  	char *out = *dst;
>>  	unsigned char to;
>>  
>> -	if (*osz < 2)
>> -		return -ENOMEM;
>> -
>>  	switch (c) {
>>  	case '\n':
>>  		to = 'n';
>> @@ -283,26 +275,23 @@ static int escape_space(unsigned char c, char **dst, size_t *osz)
>>  		to = 'f';
>>  		break;
>>  	default:
>> -		return 0;
>> +		return false;
>>  	}
>>  
>> -	*out++ = '\\';
>> -	*out++ = to;
>> +	if (out + 0 < end)
>> +		out[0] = '\\';
>> +	if (out + 1 < end)
>> +		out[1] = to;
>
> Could we do this in the same way like for hex_string, i.e.
>
> if (out < end)
>  *out = '\\';
> ++out;
>
> …
>
> *dst = out;
> return true;
>
> ?

We could, but I don't think either is more readable than the
other. Hence I chose the one requiring 2n+1 lines instead of 3n+1
lines. Had this been in vsprintf.c I would stick to the pattern you
suggest.


>> @@ -440,9 +424,10 @@ static int escape_hex(unsigned char c, char **dst, size_t *osz)
>>  int string_escape_mem(const char *src, size_t isz, char **dst, size_t osz,
>>  		      unsigned int flags, const char *esc)
>>  {
>> -	char *out = *dst, *p = out;
>> +	char *p = *dst;
>
> Leave 'out' here and…
>
>> +	char *end = p + osz;
>>  	bool is_dict = esc && *esc;
>> -	int ret = 0;
>> +	int ret;
>>  
>>  	while (isz--) {
>>  		unsigned char c = *src++;
>> @@ -462,55 +447,32 @@ int string_escape_mem(const char *src, size_t isz, char **dst, size_t osz,
>>  		    (is_dict && !strchr(esc, c))) {
>>  			/* do nothing */
>>  		} else {
>> -			if (flags & ESCAPE_SPACE) {
>> -				ret = escape_space(c, &p, &osz);
>> -				if (ret < 0)
>> -					break;
>> -				if (ret > 0)
>> -					continue;
>> -			}
>> -
>> -			if (flags & ESCAPE_SPECIAL) {
>> -				ret = escape_special(c, &p, &osz);
>> -				if (ret < 0)
>> -					break;
>> -				if (ret > 0)
>> -					continue;
>> -			}
>> -
>> -			if (flags & ESCAPE_NULL) {
>> -				ret = escape_null(c, &p, &osz);
>> -				if (ret < 0)
>> -					break;
>> -				if (ret > 0)
>> -					continue;
>> -			}
>> +			if (flags & ESCAPE_SPACE && escape_space(c, &p, end))
>> +				continue;
>> +
>> +			if (flags & ESCAPE_SPECIAL && escape_special(c, &p, end))
>> +				continue;
>> +
>> +			if (flags & ESCAPE_NULL && escape_null(c, &p, end))
>> +				continue;
>>  
>>  			/* ESCAPE_OCTAL and ESCAPE_HEX always go last */
>> -			if (flags & ESCAPE_OCTAL) {
>> -				ret = escape_octal(c, &p, &osz);
>> -				if (ret < 0)
>> -					break;
>> +			if (flags & ESCAPE_OCTAL && escape_octal(c, &p, end))
>>  				continue;
>> -			}
>> -			if (flags & ESCAPE_HEX) {
>> -				ret = escape_hex(c, &p, &osz);
>> -				if (ret < 0)
>> -					break;
>> +
>> +			if (flags & ESCAPE_HEX && escape_hex(c, &p, end))
>>  				continue;
>> -			}
>>  		}
>>  
>> -		ret = escape_passthrough(c, &p, &osz);
>> -		if (ret < 0)
>> -			break;
>> +		escape_passthrough(c, &p, end);
>> +	}
>
> + black line.
>
>> +	if (p > end) {
>> +		*dst = end;
>> +		return -ENOMEM;
>>  	}
>>  
>> +	ret = p - *dst;
>>  	*dst = p;
>> -
>> -	if (ret < 0)
>> -		return ret;
>> -
>> -	return p - out;
>
> …and do not change the logic right now. Just substitute if (ret < 0) by
> above if (p > end).
>

I'm not sure I follow. How does this change the logic? We return -ENOMEM
if and only if the entire output didn't fit, while still updating *dst
to point to one past the last output character. If the output did fit,
we return the size of the output.

One thing that only occured to me now is that we may now leave a partial
escape sequence at the end of the buffer. I can't see how this can
reasonably be avoided while still doing a meaningful refactorization
preparing it for the next patch.

Rasmus
