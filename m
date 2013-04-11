Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab3DKEIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 00:08:37 -0400
Received: from ozlabs.org ([203.10.76.45]:44351 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab3DKEIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 00:08:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Chen Gang <gang.chen@asianux.com>, Stephen Boyd <sboyd@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: kallsyms: memory override issue, need check destination buffer length
In-Reply-To: <51662AC7.1090004@asianux.com>
References: <51662AC7.1090004@asianux.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 11 Apr 2013 13:38:15 +0930
Message-ID: <87eheh4sls.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang <gang.chen@asianux.com> writes:
>   We don't export any symbols > 128 characters, but if we did then
>   kallsyms_expand_symbol() would overflow the buffer handed to it.
>   So we need check destination buffer length when copying.
>
>   the related test:
>     if we define an EXPORT function which name more than 128.
>     will panic when call kallsyms_lookup_name by init_kprobes on booting.
>     after check the length (provide this patch), it is ok.
>
>   Implementaion:
>     add additional destination buffer length parameter (maxlen)
>     if uncompressed string is too long (>= maxlen), it will be truncated.
>     not check the parameters whether valid, since it is a static function.
>
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

??!!!  I never signed this off!  I've never seen it before!

Minor comments below:

> -static unsigned int kallsyms_expand_symbol(unsigned int off, char *result)
> +static unsigned int kallsyms_expand_symbol(unsigned int off,
> +					   char *result, int maxlen)

'size_t maxlen' would be more explicit.

>  {
>  	int len, skipped_first = 0;
>  	const u8 *tptr, *data;
> +	char *begin = result;
>   	/* Get the compressed symbol length from the first symbol byte. */
>  	data = &kallsyms_names[off];
> @@ -113,14 +116,16 @@ static unsigned int kallsyms_expand_symbol(unsigned int off, char *result)
>   		while (*tptr) {
>  			if (skipped_first) {
> -				*result = *tptr;
> -				result++;
> +				*result++ = *tptr;
> +				if (result - begin == maxlen - 1)
> +					goto tail;

You could just decrement maxlen instead, and handle maxlen == 0 at the
same time:

                if (maxlen <= 1)
                        goto tail;
                *result = *tptr;
                result++;
                maxlen--;

> @@ -176,7 +181,7 @@ unsigned long kallsyms_lookup_name(const char *name)
>  	unsigned int off;
>   	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
> -		off = kallsyms_expand_symbol(off, namebuf);
> +		off = kallsyms_expand_symbol(off, namebuf, sizeof(namebuf));
>   		if (strcmp(namebuf, name) == 0)
>  			return kallsyms_addresses[i];

I prefer to use ARRAY_SIZE(namebuf) instead of sizeof(namebuf).  That
way we break compile if the declaration is changed from an array to a
pointer one day.

Same for the others.

Thanks,
Rusty.
