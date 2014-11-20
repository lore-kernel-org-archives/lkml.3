Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbaKTRXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 12:23:52 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:55115 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470AbaKTRXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 12:23:47 -0500
Date: Thu, 20 Nov 2014 09:23:29 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio_wdt: Add "always_running" feature to GPIO watchdog
Message-ID: <20141120172329.GA10673@roeck-us.net>
References: <1416489377-13633-1-git-send-email-mike.looijmans@topic.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416489377-13633-1-git-send-email-mike.looijmans@topic.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.546E23A2.02C2,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 8
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 02:16:17PM +0100, Mike Looijmans wrote:
> On some chips, like the TPS386000, the trigger cannot be disabled
> and the CPU must keep toggling the line at all times. Add a switch
> "always_running" to keep toggling the GPIO line regardless of the
> state of the soft part of the watchdog. The "armed" member keeps
> track of whether a timeout must also cause a reset.
> 
> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
> ---
>  drivers/watchdog/gpio_wdt.c |   20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/watchdog/gpio_wdt.c b/drivers/watchdog/gpio_wdt.c
> index 220a9e0..921ee67 100644
> --- a/drivers/watchdog/gpio_wdt.c
> +++ b/drivers/watchdog/gpio_wdt.c
> @@ -31,6 +31,8 @@ struct gpio_wdt_priv {
>  	int			gpio;
>  	bool			active_low;
>  	bool			state;
> +	bool		always_running;
> +	bool		armed;
>  	unsigned int		hw_algo;
>  	unsigned int		hw_margin;
>  	unsigned long		last_jiffies;
> @@ -56,6 +58,7 @@ static int gpio_wdt_start(struct watchdog_device *wdd)
>  	gpio_direction_output(priv->gpio, priv->state);
>  	priv->last_jiffies = jiffies;
>  	mod_timer(&priv->timer, priv->last_jiffies + priv->hw_margin);
> +	priv->armed = true;
>  
>  	return 0;
>  }
> @@ -64,8 +67,11 @@ static int gpio_wdt_stop(struct watchdog_device *wdd)
>  {
>  	struct gpio_wdt_priv *priv = watchdog_get_drvdata(wdd);
>  
> -	mod_timer(&priv->timer, 0);
> -	gpio_wdt_disable(priv);
> +	priv->armed = false;
> +	if (!priv->always_running) {
> +		mod_timer(&priv->timer, 0);
> +		gpio_wdt_disable(priv);
> +	}
>  
>  	return 0;
>  }
> @@ -91,7 +97,7 @@ static void gpio_wdt_hwping(unsigned long data)
>  	struct watchdog_device *wdd = (struct watchdog_device *)data;
>  	struct gpio_wdt_priv *priv = watchdog_get_drvdata(wdd);
>  
> -	if (time_after(jiffies, priv->last_jiffies +
> +	if (priv->armed && time_after(jiffies, priv->last_jiffies +
>  		       msecs_to_jiffies(wdd->timeout * 1000))) {
>  		dev_crit(wdd->dev, "Timer expired. System will reboot soon!\n");
>  		return;
> @@ -197,6 +203,9 @@ static int gpio_wdt_probe(struct platform_device *pdev)
>  	/* Use safe value (1/2 of real timeout) */
>  	priv->hw_margin = msecs_to_jiffies(hw_margin / 2);
>  
> +	priv->always_running = of_property_read_bool(pdev->dev.of_node,
> +				"always_running");

That will need to be documented in a devicetree bindings document, and be
reviewed by the fdt maintainers. I may be wrong, but I think devicetree
properties commonly use '-', not '_'.

Guenter

> +
>  	watchdog_set_drvdata(&priv->wdd, priv);
>  
>  	priv->wdd.info		= &gpio_wdt_ident;
> @@ -218,6 +227,11 @@ static int gpio_wdt_probe(struct platform_device *pdev)
>  	if (ret)
>  		watchdog_unregister_device(&priv->wdd);
>  
> +	if (priv->always_running) {
> +		gpio_wdt_start(&priv->wdd);
> +		priv->armed = false;
> +	}
> +
>  	return ret;
>  }
>  
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
