Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbbAMVw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:52:26 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:52617 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbbAMVwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:52:25 -0500
Date: Tue, 13 Jan 2015 13:52:12 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v3] gpio_wdt: Add "always_running" feature to GPIO watchdog
Message-ID: <20150113215212.GA12804@roeck-us.net>
References: <1416562828-3978-1-git-send-email-mike.looijmans@topic.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416562828-3978-1-git-send-email-mike.looijmans@topic.nl>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A010202.54B59399.00A1,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
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

On Fri, Nov 21, 2014 at 10:40:28AM +0100, Mike Looijmans wrote:
> On some chips, like the TPS386000, the trigger cannot be disabled
> and the CPU must keep toggling the line at all times. Add a switch
> "always_running" to keep toggling the GPIO line regardless of the
> state of the soft part of the watchdog. The "armed" member keeps
> track of whether a timeout must also cause a reset.
> 
> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
> ---

Actially, my reviewed-by: was to early. See below.

> v3: Indentation adjusted to match
> Fix error path in probe when notification registration fails
> Prevent double assignment of "armed" variable
> 
>  .../devicetree/bindings/watchdog/gpio-wdt.txt      |    5 +++
>  drivers/watchdog/gpio_wdt.c                        |   39 ++++++++++++++++----
>  2 files changed, 36 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt b/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
> index 37afec1..1987949 100644
> --- a/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
> +++ b/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
> @@ -13,6 +13,11 @@ Required Properties:
>      by the GPIO flags.
>  - hw_margin_ms: Maximum time to reset watchdog circuit (milliseconds).
>  
> +Optional Properties:
> +- always-running: If the watchdog timer cannot be disabled, add this flag to
> +  have the driver keep toggling the signal without a client. It will only cease
> +  to toggle the signal when the device is open and the timeout elapsed.
> +
>  Example:
>  	watchdog: watchdog {
>  		/* ADM706 */
> diff --git a/drivers/watchdog/gpio_wdt.c b/drivers/watchdog/gpio_wdt.c
> index 220a9e0..9bfbd73 100644
> --- a/drivers/watchdog/gpio_wdt.c
> +++ b/drivers/watchdog/gpio_wdt.c
> @@ -31,6 +31,8 @@ struct gpio_wdt_priv {
>  	int			gpio;
>  	bool			active_low;
>  	bool			state;
> +	bool			always_running;
> +	bool			armed;
>  	unsigned int		hw_algo;
>  	unsigned int		hw_margin;
>  	unsigned long		last_jiffies;
> @@ -48,10 +50,8 @@ static void gpio_wdt_disable(struct gpio_wdt_priv *priv)
>  		gpio_direction_input(priv->gpio);
>  }
>  
> -static int gpio_wdt_start(struct watchdog_device *wdd)
> +static void gpio_wdt_start_impl(struct gpio_wdt_priv *priv)

This function is now void but still has a return value.

Guenter
