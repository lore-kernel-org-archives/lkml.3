Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaGVLsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:48:17 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:40472 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaGVLsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:48:15 -0400
Message-ID: <53CE4F86.2000307@linaro.org>
Date: Tue, 22 Jul 2014 06:48:22 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: kay@vrfy.org, pmladek@suse.cz, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/7] printk: initialize syslog_prev and console_prev
References: <1405947761-26004-1-git-send-email-elder@linaro.org> <1405947761-26004-4-git-send-email-elder@linaro.org>
In-Reply-To: <1405947761-26004-4-git-send-email-elder@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2014 08:02 AM, Alex Elder wrote:
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
> One exception is that occasionally we reset our syslog or console
> (etc.) position variables.  In that case the previously-formatted
> record flags value is still valid, so we preserve that information.
> 
> This is being done to support the next patch.  Initializing
> these variables this way makes LOG_NEWLINE and LOG_CONT be
> mutually exclusive, and the next patch uses that fact to simplify
> some logic.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> Reviewed-by: Petr Mládek <pmladek@suse.cz>

I have one change I'd like to suggest on this one.

Petr, could you offer your opinion?


> ---
>  kernel/printk/printk.c | 44 ++++++++++++++++++++++++++++++--------------
>  1 file changed, 30 insertions(+), 14 deletions(-)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 9f11eab..2f43116 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c


. . .

> @@ -2156,10 +2168,14 @@ again:
>  				      "%s** %u printk messages dropped **\n",
>  				      (console_prev & LOG_CONT) ? "\n" : "",
>  				      (unsigned)(log_first_seq - console_seq));
> -			/* messages are gone, move to first one */
> +			/*
> +			 * Messages are gone, move to first one.
> +			 * Don't discard what we know about the
> +			 * previously-formatted record.
> +			 */
>  			console_seq = log_first_seq;
>  			console_idx = log_first_idx;
> -			console_prev = 0;
> +			console_prev &= LOG_NEWLINE|LOG_CONT;

In this one spot, I think console_prev should simply be
initialized with LOG_NEWLINE.

The reason is that the "printk messages dropped" message will
be inserted into the formatted output, and is hence the last
formatted line.  And that message is (now) terminated with
a newline.

					-Alex

>  		} else {
>  			len = 0;
>  		}

. . .

