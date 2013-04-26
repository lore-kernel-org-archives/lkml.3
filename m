Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006Ab3DZBYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 21:24:44 -0400
Received: from mail.us.es ([193.147.175.20]:33383 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758903Ab3DZBYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 21:24:43 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus1 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.97.7/17093. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-96.4/7.5):. 
 Processed in 2.289127 secs); 26 Apr 2013 01:24:41 -0000
X-Envelope-From: pneira@us.es
Date: Fri, 26 Apr 2013 03:24:38 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: dmitry pervushin <dmitry.pervushin@linaro.org>
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, dmitry pervushin <dpervushin@gmail.com>,
        Ashish Sharma <ashishsharma@google.com>, JP Abgrall <jpa@google.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 1/2] netfilter: idletimers - fix the case of already
 expired timer
Message-ID: <20130426012438.GA4486@localhost>
References: <1366537994-19511-1-git-send-email-dmitry.pervushin@linaro.org>
 <1366537994-19511-2-git-send-email-dmitry.pervushin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366537994-19511-2-git-send-email-dmitry.pervushin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Same thing with this patch:

https://patchwork.kernel.org/patch/2333841/

Regards.

On Sun, Apr 21, 2013 at 11:53:13AM +0200, dmitry pervushin wrote:
> From: dmitry pervushin <dpervushin@gmail.com>
> 
> Fix the case in which timer has expired and we refresh it without
> sending the notification
> 
> Signed-off-by: Ashish Sharma <ashishsharma@google.com>
> Signed-off-by: JP Abgrall <jpa@google.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> Signed-off-by: dmitry pervushin <dmitry.pervushin@linaro.org>
> ---
>  net/netfilter/xt_IDLETIMER.c |   18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
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
> +
> +	/* TODO: Avoid modifying timers on each packet */
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
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
