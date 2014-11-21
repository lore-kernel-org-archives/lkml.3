Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbaKUH2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 02:28:22 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:40042 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbaKUH2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 02:28:21 -0500
Message-ID: <546EE991.1080704@roeck-us.net>
Date: Thu, 20 Nov 2014 23:28:17 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mike Looijmans <mike.looijmans@topic.nl>, wim@iguana.be
CC: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] gpio_wdt: Add "always_running" feature to GPIO watchdog
References: <20141120172329.GA10673@roeck-us.net> <1416552828-3589-1-git-send-email-mike.looijmans@topic.nl>
In-Reply-To: <1416552828-3589-1-git-send-email-mike.looijmans@topic.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.546EE994.0074,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
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

On 11/20/2014 10:53 PM, Mike Looijmans wrote:
> On some chips, like the TPS386000, the trigger cannot be disabled
> and the CPU must keep toggling the line at all times. Add a switch
> "always_running" to keep toggling the GPIO line regardless of the
> state of the soft part of the watchdog. The "armed" member keeps
> track of whether a timeout must also cause a reset.
>
> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
> ---
>
> v2: Rename property "always_running" to "always-running" and add devicetree
> documentation
>
>   .../devicetree/bindings/watchdog/gpio-wdt.txt      |    5 +++++
>   drivers/watchdog/gpio_wdt.c                        |   20 +++++++++++++++++---
>   2 files changed, 22 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt b/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
> index 37afec1..1987949 100644
> --- a/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
> +++ b/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
> @@ -13,6 +13,11 @@ Required Properties:
>       by the GPIO flags.
>   - hw_margin_ms: Maximum time to reset watchdog circuit (milliseconds).
>
> +Optional Properties:
> +- always-running: If the watchdog timer cannot be disabled, add this flag to
> +  have the driver keep toggling the signal without a client. It will only cease
> +  to toggle the signal when the device is open and the timeout elapsed.
> +
>   Example:
>   	watchdog: watchdog {
>   		/* ADM706 */
> diff --git a/drivers/watchdog/gpio_wdt.c b/drivers/watchdog/gpio_wdt.c
> index 220a9e0..3266215 100644
> --- a/drivers/watchdog/gpio_wdt.c
> +++ b/drivers/watchdog/gpio_wdt.c
> @@ -31,6 +31,8 @@ struct gpio_wdt_priv {
>   	int			gpio;
>   	bool			active_low;
>   	bool			state;
> +	bool		always_running;
> +	bool		armed;

Please align columns with the other variables.

>   	unsigned int		hw_algo;
>   	unsigned int		hw_margin;
>   	unsigned long		last_jiffies;
> @@ -56,6 +58,7 @@ static int gpio_wdt_start(struct watchdog_device *wdd)
>   	gpio_direction_output(priv->gpio, priv->state);
>   	priv->last_jiffies = jiffies;
>   	mod_timer(&priv->timer, priv->last_jiffies + priv->hw_margin);
> +	priv->armed = true;
>
>   	return 0;
>   }
> @@ -64,8 +67,11 @@ static int gpio_wdt_stop(struct watchdog_device *wdd)
>   {
>   	struct gpio_wdt_priv *priv = watchdog_get_drvdata(wdd);
>
> -	mod_timer(&priv->timer, 0);
> -	gpio_wdt_disable(priv);
> +	priv->armed = false;
> +	if (!priv->always_running) {
> +		mod_timer(&priv->timer, 0);
> +		gpio_wdt_disable(priv);
> +	}
>
>   	return 0;
>   }
> @@ -91,7 +97,7 @@ static void gpio_wdt_hwping(unsigned long data)
>   	struct watchdog_device *wdd = (struct watchdog_device *)data;
>   	struct gpio_wdt_priv *priv = watchdog_get_drvdata(wdd);
>
> -	if (time_after(jiffies, priv->last_jiffies +
> +	if (priv->armed && time_after(jiffies, priv->last_jiffies +
>   		       msecs_to_jiffies(wdd->timeout * 1000))) {

Please align continuation lines.

>   		dev_crit(wdd->dev, "Timer expired. System will reboot soon!\n");
>   		return;
> @@ -197,6 +203,9 @@ static int gpio_wdt_probe(struct platform_device *pdev)
>   	/* Use safe value (1/2 of real timeout) */
>   	priv->hw_margin = msecs_to_jiffies(hw_margin / 2);
>
> +	priv->always_running = of_property_read_bool(pdev->dev.of_node,
> +				"always-running");
> +
Please align continuation line with '('.

>   	watchdog_set_drvdata(&priv->wdd, priv);
>
>   	priv->wdd.info		= &gpio_wdt_ident;
> @@ -218,6 +227,11 @@ static int gpio_wdt_probe(struct platform_device *pdev)
>   	if (ret)
>   		watchdog_unregister_device(&priv->wdd);
>
> +	if (priv->always_running) {
> +		gpio_wdt_start(&priv->wdd);
> +		priv->armed = false;
> +	}
> +

This won't work if there is an error. The driver won't load but the timer
is started, which will likely cause a crash when the timer fires. You'll
have to fix the error handling.

I also dislike that you first set priv->armed in the start function and
then reset it, but I don't have a better idea right now.

Guenter

>   	return ret;
>   }
>
>

