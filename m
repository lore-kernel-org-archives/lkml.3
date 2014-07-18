Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762044AbaGRTe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 15:34:56 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:48758 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbaGRTez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 15:34:55 -0400
Message-ID: <53C976E1.9040505@linaro.org>
Date: Fri, 18 Jul 2014 14:34:57 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: kay@vrfy.org, pmladek@suse.cz, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/7] printk: LOG_CONT and LOG_NEWLINE are opposites
References: <1405692859-32500-1-git-send-email-elder@linaro.org> <1405692859-32500-4-git-send-email-elder@linaro.org>
In-Reply-To: <1405692859-32500-4-git-send-email-elder@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 09:14 AM, Alex Elder wrote:
> Two log record flags--LOG_CONT and LOG_NEWLINE--are mutually
> exclusive.  That is, one or the other is always set, but they are
> never both set at the same time in a log record flags field.  What
> follows is a great deal of explanation that aims to prove this
> assertion.
> 
> Having that knowledge allows us to simplify a bit of logic, and with
> a little more work (in follow-on patches) it allows us to do without
> some flag values, considerably simplifying things.

And in this patch I inadvertently deleted a hunk.  It
goes at the end, and I've appended it below.

I'm really sorry I screwed these patches up.  I got
sloppy, and tried to send them out in a hurry this
morning.

I'm going to post a new version 4 that will correct these
things.

					-Alex

> Signed-off-by: Alex Elder <elder@linaro.org>
> Reviewed-by: Petr Mládek <pmladek@suse.cz>
> ---
>  kernel/printk/printk.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index f2a069e..00367b5 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -1006,11 +1006,9 @@ static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
>  		prefix = false;
>  
>  	if (msg->flags & LOG_CONT) {
> -		if ((prev & LOG_CONT) && !(prev & LOG_NEWLINE))
> +		if (prev & LOG_CONT)
>  			prefix = false;
> -
> -		if (!(msg->flags & LOG_NEWLINE))
> -			newline = false;
> +		newline = false;
>  	}
>  
>  	do {
> @@ -1639,10 +1637,16 @@ asmlinkage int vprintk_emit(int facility, int level,
>  	text_len += vscnprintf(text + text_len,
>  			       sizeof(textbuf) - text_len, fmt, args);
>  
> -	/* mark and strip a trailing newline */
> +	/*
> +	 * If there's a trailing newline, flag it and strip it off.
> +	 * Otherwise we assume this is a partial log message, to be
> +	 * continued with the next call.
> +	 */
>  	if (text_len && text[text_len-1] == '\n') {
>  		text_len--;
> -		lflags |= LOG_NEWLINE;
> +		lflags = LOG_NEWLINE;
> +	} else {
> +		lflags = LOG_CONT;
>  	}
>  
>  	/* strip kernel syslog prefix and extract log level or control flags */
> @@ -1672,7 +1676,7 @@ asmlinkage int vprintk_emit(int facility, int level,
>  		level = default_message_loglevel;
>  
>  	if (dict)
> -		lflags |= LOG_PREFIX|LOG_NEWLINE;
> +		lflags = LOG_PREFIX|LOG_NEWLINE;
>  
>  	if (!(lflags & LOG_NEWLINE)) {
>  		/*
> 
@@ -1700,8 +1700,7 @@ asmlinkage int vprintk_emit(int facility
                if (cont_add(facility, level, text, text_len))
                        printed_len += text_len;
                else
-                       printed_len += log_store(facility, level,
-                                                lflags | LOG_CONT, 0,
+                       printed_len += log_store(facility, level, lflags, 0,
                                                 dict, dictlen, text,
text_len);
        } else {
                bool stored = false;

