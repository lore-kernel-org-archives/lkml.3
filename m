Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbaGQIjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 04:39:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030AbaGQIjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:39:20 -0400
Date: Thu, 17 Jul 2014 10:39:18 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Alex Elder <elder@linaro.org>
Cc: akpm@linux-foundation.org, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: [PATCH 1/4] printk: LOG_CONT and LOG_NEWLINE are separate
Message-ID: <20140717083918.GP6774@pathway.suse.cz>
References: <1405531620-9983-1-git-send-email-elder@linaro.org>
 <1405531620-9983-2-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405531620-9983-2-git-send-email-elder@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-07-16 12:26:57, Alex Elder wrote:
> Two log record flags--LOG_CONT and LOG_NEWLINE--are never both set
> at the same time in a log record flags field.  What follows is a
> great deal of explanation that aims to prove this assertion.

It makes perfect sense. If you found a situation where both flags were
set together, it would mean a bug. If a record ends with new line, it
is not continuous and vice versa.

[...]

> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  kernel/printk/printk.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 13e839d..301ade3 100644
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

Makes sense. I like it.

>  	do {
> @@ -1642,7 +1640,7 @@ asmlinkage int vprintk_emit(int facility, int level,
>  	/* mark and strip a trailing newline */
>  	if (text_len && text[text_len-1] == '\n') {
>  		text_len--;
> -		lflags |= LOG_NEWLINE;
> +		lflags = LOG_NEWLINE;
>  	}
>  
>  	/* strip kernel syslog prefix and extract log level or control flags */
> @@ -1672,7 +1670,7 @@ asmlinkage int vprintk_emit(int facility, int level,
>  		level = default_message_loglevel;
>  
>  	if (dict)
> -		lflags |= LOG_PREFIX|LOG_NEWLINE;
> +		lflags = LOG_PREFIX|LOG_NEWLINE;
>  
>  	if (!(lflags & LOG_NEWLINE)) {
>  		/*
> @@ -1688,7 +1686,7 @@ asmlinkage int vprintk_emit(int facility, int level,
>  		else
>  			printed_len += log_store(facility, level,
>  						 lflags | LOG_CONT, 0,
> -						 dict, dictlen, text, text_len);
> +						 NULL, 0, text, text_len);
>  	} else {
>  		bool stored = false;
>  

I am not sure that I like the last three changes. The logic is
correct. But I think that these micro-optimizations makes the code less
readable and prone to errors with reordering and other changes.

The original code does not harm. The new code is less obvious and will
force many people to think why it is correct. Even you might be in
doubts if you see it after few months :-)

Well, I do not have strong opinion here. Other people might see it
different. Forcing people to think is not a bad idea after all :-)

Best Regards,
Petr
