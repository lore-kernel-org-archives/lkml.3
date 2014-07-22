Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbaGVJpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:45:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39683 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164AbaGVJpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:45:02 -0400
Date: Tue, 22 Jul 2014 11:45:01 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Alex Elder <elder@linaro.org>
Cc: akpm@linux-foundation.org, kay@vrfy.org, bp@suse.de,
        john.stultz@linaro.org, jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/7] printk: insert newline for truncated records
Message-ID: <20140722094501.GN20751@pathway.suse.cz>
References: <1405947761-26004-1-git-send-email-elder@linaro.org>
 <1405947761-26004-3-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405947761-26004-3-git-send-email-elder@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-07-21 08:02:36, Alex Elder wrote:
> If a log record has LOG_PREFIX set, its predecessor record should be
> terminated if it was marked LOG_CONT.
> 
> In devkmsg_read(), this condition was being ignored, which would
> lead to such records showing up combined when reading /dev/kmsg.
> Fix this oversight.
> 
> We should similarly insert a newline in msg_print_text() in this
> case, to avoid formatted records getting merged.
> 
> Suggested-by: Petr Mládek <pmladek@suse.cz>
> Signed-off-by: Alex Elder <elder@linaro.org>

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Best Regards,
Petr

> ---
>  kernel/printk/printk.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index ffc9928..9f11eab 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -575,6 +575,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
>  	char cont = '-';
>  	size_t len;
>  	ssize_t ret;
> +	bool insert_newline;
>  
>  	if (!user)
>  		return -EBADF;
> @@ -625,7 +626,10 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
>  		 ((user->prev & LOG_CONT) && !(msg->flags & LOG_PREFIX)))
>  		cont = '+';
>  
> -	len = sprintf(user->buf, "%u,%llu,%llu,%c;",
> +	/* Insert a newline if the previous line was not terminated properly */
> +	insert_newline = (user->prev & LOG_CONT) && (msg->flags & LOG_PREFIX);
> +	len = sprintf(user->buf, "%s%u,%llu,%llu,%c;",
> +		      insert_newline ? "\n" : "",
>  		      (msg->facility << 3) | msg->level,
>  		      user->seq, ts_usec, cont);
>  	user->prev = msg->flags;
> @@ -1013,6 +1017,12 @@ static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
>  			newline = false;
>  	}
>  
> +	if ((prev & LOG_CONT) && (msg->flags & LOG_PREFIX) && len < size) {
> +		if (buf)
> +			buf[len++] = '\n';
> +		else
> +			len++;
> +	}
>  	do {
>  		const char *next = memchr(text, '\n', text_size);
>  		size_t text_len;
> -- 
> 1.9.1
> 
