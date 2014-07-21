Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbaGUKBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 06:01:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46498 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088AbaGUKBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 06:01:41 -0400
Date: Mon, 21 Jul 2014 12:01:35 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Alex Elder <elder@linaro.org>
Cc: akpm@linux-foundation.org, kay@vrfy.org, bp@suse.de,
        john.stultz@linaro.org, jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/7] printk: initialize syslog_prev and console_prev
Message-ID: <20140721100135.GB20751@pathway.suse.cz>
References: <1405718885-11227-1-git-send-email-elder@linaro.org>
 <1405718885-11227-3-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405718885-11227-3-git-send-email-elder@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-07-18 16:28:00, Alex Elder wrote:
> Two global variables, "syslog_prev" and "console_prev", maintain a
> copy of the flags value used in the log record most recently
> formatted for syslog or the console, respectively.
> 
> Initially there is no previous formatted log record, and these
> variables simply have an initial value 0.  And occasionally log
> records can get consumed at a rate such that syslog or the console
> can't keep up, in which case those variables (along with their
> corresponding position variables) must be reset.  Here too, they're
> reset to 0.
> 
> This patch changes it so the initial value used is LOG_NEWLINE.
> That is, if we know nothing about the prevously-formatted log
> record, we can assume it was complete, and ended with a newline.
> 
> This is being done to support the next patch.  Initializing
> these variables this way makes LOG_NEWLINE and LOG_CONT be
> mutually exclusive, and the next patch uses that fact to simplify
> some logic.

I have decided to double check it and found more locations where the flags were
reset to 0:

      + "prev" variable in syslog_print_all()
      + "prev" variable in kmsg_dump_get_buffer()


Also I think that we should not reset it to LOG_NEWLINE when the
message is gone. I would suggest to do

	&= (LOG_CONT | LOG_NEWLINE);

I mean to preserve the status of the last copied/printed piece. Then
we could put there "\n" when the last proceed piece was continuous and
the next one starts with prefix.

The only exception would be "console_prev" in  console_unlock()
because there we already add "\n" in the "** %u printk messages
dropped **" warning.

How does that sound?


Best Regards,
Petr


> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> Reviewed-by: Petr Mládek <pmladek@suse.cz>
> ---
>  kernel/printk/printk.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index ffc9928..4034a88 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -236,7 +236,7 @@ DECLARE_WAIT_QUEUE_HEAD(log_wait);
>  /* the next printk record to read by syslog(READ) or /proc/kmsg */
>  static u64 syslog_seq;
>  static u32 syslog_idx;
> -static enum log_flags syslog_prev;
> +static enum log_flags syslog_prev = LOG_NEWLINE;
>  static size_t syslog_partial;
>  
>  /* index and sequence number of the first record stored in the buffer */
> @@ -250,7 +250,7 @@ static u32 log_next_idx;
>  /* the next printk record to write to the console */
>  static u64 console_seq;
>  static u32 console_idx;
> -static enum log_flags console_prev;
> +static enum log_flags console_prev = LOG_NEWLINE;
>  
>  /* the next printk record to read after the last 'clear' command */
>  static u64 clear_seq;
> @@ -1071,7 +1071,7 @@ static int syslog_print(char __user *buf, int size)
>  			/* messages are gone, move to first one */
>  			syslog_seq = log_first_seq;
>  			syslog_idx = log_first_idx;
> -			syslog_prev = 0;
> +			syslog_prev = LOG_NEWLINE;
>  			syslog_partial = 0;
>  		}
>  		if (syslog_seq == log_next_seq) {
> @@ -1301,7 +1301,7 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
>  			/* messages are gone, move to first one */
>  			syslog_seq = log_first_seq;
>  			syslog_idx = log_first_idx;
> -			syslog_prev = 0;
> +			syslog_prev = LOG_NEWLINE;
>  			syslog_partial = 0;
>  		}
>  		if (from_file) {
> @@ -2149,7 +2149,7 @@ again:
>  			/* messages are gone, move to first one */
>  			console_seq = log_first_seq;
>  			console_idx = log_first_idx;
> -			console_prev = 0;
> +			console_prev = LOG_NEWLINE;
>  		} else {
>  			len = 0;
>  		}
> -- 
> 1.9.1
> 
