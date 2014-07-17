Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbaGQKOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:14:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42036 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218AbaGQKOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:14:16 -0400
Date: Thu, 17 Jul 2014 12:14:13 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Alex Elder <elder@linaro.org>
Cc: akpm@linux-foundation.org, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] printk: honor LOG_PREFIX in devkmsg_read()
Message-ID: <20140717101413.GR6774@pathway.suse.cz>
References: <1405531620-9983-1-git-send-email-elder@linaro.org>
 <1405531620-9983-3-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405531620-9983-3-git-send-email-elder@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-07-16 12:26:58, Alex Elder wrote:
> In devkmsg_read(), a variable "cont" holds a character that's used
> to indicate whether a given log line is a "continuation", that is,
> whether a log record should be merged with the one before or after
> it.  If a record should be merged with its successor (but not its
> predecessor) that character is 'c'.  And the line following such a
> 'c' log record is normally marked with a '+' to show it is continues
> its predecessor.  Any other cases are marked '-', indicating the
> log record stands on its own.
> 
> There is an exception.  If a log record is marked LOG_PREFIX, it
> indicates that this record represents a new log entry, implicitly
> terminating the predecessor--even if the predecessor would otherwise
> have been continued.  So a record marked LOG_PREFIX (that is not
> also marked LOG_CONT) should have '-' for its "cont" variable.
> 
> The logic that determines this "continuation" character has a bug
> that gets that exceptional case wrong.
> 
> The specific case that produces the wrong result is when all of
> these conditions are non-zero:
>     user->prev & LOG_CONT
>     msg->flags & LOG_PREFIX
>     msg->flags & LOG_CONT
> The bug is that despite the message's LOG_PREFIX flag, the
> "cont" character is getting set to '+' rather than 'c'.
> 
> The problem is that the message's LOG_PREFIX flag is getting
> ignored if its LOG_CONT flag is also set.  Rearrange the logic
> here to produce the correct result.
> 
> The following table concisely defines the problem:
> 
>      prev | msg  | msg  ||"cont"
>      CONT |PREFIX| CONT || char
>     ------+------+------++------
>      clear| clear| clear||  '-'
>      clear| clear|  set ||  'c'
>      clear|  set | clear||  '-'
>      clear|  set |  set ||  'c'
>       set | clear| clear||  '+'
>       set |  set |  set ||  '+'
	       ^^^ typo, it should be:

       set |  clear |  set ||  '+'

>       set |  set | clear||  '-'
>       set |  set |  set ||  '+'      <-- should be 'c'
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  kernel/printk/printk.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 301ade3..9e9cf93 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -572,7 +572,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
>  	struct printk_log *msg;
>  	u64 ts_usec;
>  	size_t i;
> -	char cont = '-';
> +	char cont;
>  	size_t len;
>  	ssize_t ret;
>  
> @@ -619,11 +619,12 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
>  	 * better readable output. 'c' in the record flags mark the first
>  	 * fragment of a line, '+' the following.
>  	 */
> -	if (msg->flags & LOG_CONT && !(user->prev & LOG_CONT))
> -		cont = 'c';
> -	else if ((msg->flags & LOG_CONT) ||
> -		 ((user->prev & LOG_CONT) && !(msg->flags & LOG_PREFIX)))
> +	if (user->prev & LOG_CONT && !(msg->flags & LOG_PREFIX))
>  		cont = '+';
> +	else if (msg->flags & LOG_CONT)
> +		cont = 'c';
> +	else
> +		cont = '-';

Makes sense. Prefix should be always on a new line.

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Best Regards,
Petr

>  	len = sprintf(user->buf, "%u,%llu,%llu,%c;",
>  		      (msg->facility << 3) | msg->level,
> -- 
> 1.9.1
> 
