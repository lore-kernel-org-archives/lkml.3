Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528Ab3CZMp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 08:45:58 -0400
Received: from mail.us.es ([193.147.175.20]:54127 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758136Ab3CZMp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 08:45:57 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus1 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.97.7/16905. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-97.2/7.5):. 
 Processed in 1.912218 secs); 26 Mar 2013 12:45:55 -0000
X-Envelope-From: pneira@us.es
Date: Tue, 26 Mar 2013 13:45:52 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: dmitry pervushin <dpervushin@gmail.com>
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: Android netfilter patches (xt_IDLETIMER) [1/3]
Message-ID: <20130326124552.GA5434@localhost>
References: <5150CB02.2090105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5150CB02.2090105@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Mon, Mar 25, 2013 at 11:09:06PM +0100, dmitry pervushin wrote:
> Fix the case in which timer has expired and we refresh it without
> sending the notification
>
> Signed-off-by: Ashish Sharma <ashishsharma@google.com>
> Signed-off-by: JP Abgrall <jpa@google.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> Signed-off-by: dmitry pervushin <dpervushin@gmail.com>
>
> diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
> index f407ebc1..3540c04 100644
> --- a/net/netfilter/xt_IDLETIMER.c
> +++ b/net/netfilter/xt_IDLETIMER.c
> @@ -168,14 +168,22 @@ static unsigned int idletimer_tg_target(struct sk_buff *skb,
>  					 const struct xt_action_param *par)
>  {
>  	const struct idletimer_tg_info *info = par->targinfo;
> +	unsigned long now = jiffies;
>
>  	pr_debug("resetting timer %s, timeout period %u\n",
>  		 info->label, info->timeout);
>
>  	BUG_ON(!info->timer);
>
> +	if (time_before(info->timer->timer.expires, now)) {
> +		schedule_work(&info->timer->work);
> +		pr_debug("Starting timer %s (Expired, Jiffies): %lu, %lu\n",
> +			 info->label, info->timer->timer.expires, now);
> +	}

Hm, this seems to me like a new feature. With this change, IDLETIMER
is sending notifications once the timer becomes active again.

> +
> +	/* TODO: Avoid modifying timers on each packet */

Regarding this TODO, you can adapt this code snippet for this:

unsigned long newtime = jiffies + extra_jiffies;

/* Only update the timeout if the new timeout is at
 * least HZ jiffies from the old timeout. Need del_timer
 * for race avoidance (may already be dying).
 */
if (newtime - ct->timeout.expires >= HZ)
        mod_timer_pending(&ct->timeout, newtime);

We're using it in nf_conntrack.

This should come in a separate patch.

>  	mod_timer(&info->timer->timer,
> -		  msecs_to_jiffies(info->timeout * 1000) + jiffies);
> +		  msecs_to_jiffies(info->timeout * 1000) + now);
>
>  	return XT_CONTINUE;
>  }
> @@ -184,6 +192,7 @@ static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
>  {
>  	struct idletimer_tg_info *info = par->targinfo;
>  	int ret;
> +	unsigned long now = jiffies;
>
>  	pr_debug("checkentry targinfo%s\n", info->label);
>
> @@ -204,8 +213,13 @@ static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
>  	info->timer = __idletimer_tg_find_by_label(info->label);
>  	if (info->timer) {
>  		info->timer->refcnt++;
> +		if (time_before(info->timer->timer.expires, now)) {
> +			schedule_work(&info->timer->work);
> +			pr_debug("Starting Checkentry timer (Expired, Jiffies): %lu, %lu\n",
> +				info->timer->timer.expires, now);
> +		}
>  		mod_timer(&info->timer->timer,
> -			  msecs_to_jiffies(info->timeout * 1000) + jiffies);
> +			  msecs_to_jiffies(info->timeout * 1000) + now);
>
>  		pr_debug("increased refcnt of timer %s to %u\n",
>  			 info->label, info->timer->refcnt);
