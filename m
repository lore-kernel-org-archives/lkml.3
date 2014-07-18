Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760819AbaGRJCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:02:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33341 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180AbaGRJCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:02:53 -0400
Date: Fri, 18 Jul 2014 11:02:52 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Alex Elder <elder@linaro.org>
Cc: akpm@linux-foundation.org, kay@vrfy.org, bp@suse.de,
        john.stultz@linaro.org, jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] printk: update previous message for LOG_PREFIX
Message-ID: <20140718090251.GV6774@pathway.suse.cz>
References: <1405619953-5475-1-git-send-email-elder@linaro.org>
 <1405619953-5475-3-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405619953-5475-3-git-send-email-elder@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-07-17 12:59:10, Alex Elder wrote:
> If log_store() gets flags containing LOG_PREFIX, it indicates the
> record getting stored should implicitly complete the previous log
> record and start a new one.
> 
> We can also ensure the previous record is completed by keeping
> track of the previously-logged record, and adding the LOG_NEWLINE
> flag to it when log_store() sees a LOG_PREFIX flag.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  kernel/printk/printk.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index e35d91a..6b72a77 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -242,6 +242,9 @@ static size_t syslog_partial;
>  static u64 log_first_seq;
>  static u32 log_first_idx;
>  
> +/* Pointer to the last record written into the log */
> +static struct printk_log *log_last_msg;
> +
>  /* index and sequence number of the next record to store in the buffer */
>  static u64 log_next_seq;
>  static u32 log_next_idx;
> @@ -425,7 +428,13 @@ static int log_store(int facility, int level,
>  		log_next_idx = 0;
>  	}
>  
> -	/* fill message */
> +	/*
> +	 * If we're forcing a new log record, update the flags for
> +	 * the previous one to mark it complete.
> +	 */
> +	if (flags & LOG_PREFIX && log_last_msg)
> +		log_last_msg->flags |= LOG_NEWLINE;

You are not allowed to do this. The previous message might already be
proceed by readers (console, syslog, kmsg).

IMHO, you will not be able to make this safe without adding extra
complexity into the readers. So, I am afraid that there is no win
in vanishing the LOG_PREFIX flag.

Best Regards,
Petr

>  	msg = (struct printk_log *)(log_buf + log_next_idx);
>  	memcpy(log_text(msg), text, text_len);
>  	msg->text_len = text_len;
> @@ -449,6 +458,9 @@ static int log_store(int facility, int level,
>  	log_next_idx += msg->len;
>  	log_next_seq++;
>  
> +	/* Save our previous record address for next time. */
> +	log_last_msg = msg;
> +
>  	return msg->text_len;
>  }
>  
> -- 
> 1.9.1
> 
