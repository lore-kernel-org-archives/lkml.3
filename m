Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965554AbaGRLpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:45:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755971AbaGRLpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:45:09 -0400
Date: Fri, 18 Jul 2014 13:45:06 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Alex Elder <elder@linaro.org>
Cc: akpm@linux-foundation.org, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/6] printk: insert newline in devkmsg_read()
Message-ID: <20140718114506.GA6774@pathway.suse.cz>
References: <1405606151-19875-1-git-send-email-elder@linaro.org>
 <1405606151-19875-6-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405606151-19875-6-git-send-email-elder@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-07-17 09:09:10, Alex Elder wrote:
> If a log record has LOG_PREFIX set, its predecessor record should be
> terminated if it was marked LOG_CONT.  In devkmsg_read(), this
> condition was being ignored, which would lead to such records
> showing up combined when reading /dev/kmsg.  Fix this oversight.
>
> Reported-by: Petr Mládek <pmladek@suse.cz>
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  kernel/printk/printk.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index e5ee1cb..3174ba9 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -575,6 +575,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
>  	char cont;
>  	size_t len;
>  	ssize_t ret;
> +	bool insert_newline;
>  
>  	if (!user)
>  		return -EBADF;
> @@ -626,7 +627,10 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
>  	else
>  		cont = '-';
>  
> -	len = sprintf(user->buf, "%u,%llu,%llu,%c;",
> +	/* Insert a newline if we're terminating the previous record
> early */

More correct description would be:

	/* Insert a newline if the previous line was not terminated properly */

> +	insert_newline = (user->prev & LOG_CONT) && (msg->flags & LOG_PREFIX);
> +	len = sprintf(user->buf, "%s%u,%llu,%llu,%c;",
> +		      insert_newline ? "\n" : "",
>  		      (msg->facility << 3) | msg->level,
>  		      user->seq, ts_usec, cont);
>  	user->prev = msg->flags;

Please, do similar change also in msg_print_text() that would fix also
syslog(). Note that syslog is the place where we stopped to disable
prefix when there was continuous line before.

Best Regards.
Petr
