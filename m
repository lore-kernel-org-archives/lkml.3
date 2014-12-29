Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaL2Mvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 07:51:55 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:34436 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaL2Mvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 07:51:52 -0500
Date: Mon, 29 Dec 2014 04:50:23 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>,
        Kamil Debski <k.debski@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        lm-sensors@lm-sensors.org, Linux PM list <linux-pm@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, Lukasz Majewski <l.majewski@majess.pl>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>
Subject: Re: [PATCH v2 7/8] hwmon: thermal: Read PWM FAN configuration from
 device tree
Message-ID: <20141229125023.GA18083@roeck-us.net>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
 <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
 <1419265668-32283-8-git-send-email-l.majewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419265668-32283-8-git-send-email-l.majewski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.54A14E6E.01FD,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 11
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

On Mon, Dec 22, 2014 at 05:27:47PM +0100, Lukasz Majewski wrote:
> Code for reading PWM FAN configuration data via device tree.
> 
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> ---

The headline is quite misleading. Please provide the affected subsystem (hwmon)
and the affected driver (pwm-fan) in the hwmon-customary form
	hwmon: (pwm-fan) Description

The Description should explain what the patch is about.

> Changes for v2:
> - Rename pwm_fan_max_states to pwm_fan_cooling_levels
> - Moving pwm_fan_of_get_cooling_data() call after setting end enabling PWM FAN
> - pwm_fan_of_get_cooling_data() now can fail - preserving old behaviour
> - Remove unnecessary dev_err() call
> ---
>  drivers/hwmon/pwm-fan.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 47 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/hwmon/pwm-fan.c b/drivers/hwmon/pwm-fan.c
> index 870e100..8e68308 100644
> --- a/drivers/hwmon/pwm-fan.c
> +++ b/drivers/hwmon/pwm-fan.c
> @@ -30,7 +30,10 @@
>  struct pwm_fan_ctx {
>  	struct mutex lock;
>  	struct pwm_device *pwm;
> -	unsigned char pwm_value;
> +	unsigned int pwm_value;
> +	unsigned int pwm_fan_state;
> +	unsigned int pwm_fan_max_state;
> +	unsigned int *pwm_fan_cooling_levels;
>  };
>  
>  static int  __set_pwm(struct pwm_fan_ctx *ctx, unsigned long pwm)
> @@ -100,6 +103,47 @@ static struct attribute *pwm_fan_attrs[] = {
>  
>  ATTRIBUTE_GROUPS(pwm_fan);
>  
> +int pwm_fan_of_get_cooling_data(struct device *dev, struct pwm_fan_ctx *ctx)
> +{
> +	struct device_node *np = dev->of_node;
> +	struct property *pp;
> +	int len, num, i;
> +
> +	pp = of_find_property(np, "cooling-levels", &len);
> +	if (!pp) {
> +		dev_err(dev, "Property: 'cooling-levels' not found\n");
> +		return -EINVAL;
> +	}
> +
> +	if (len == 0) {
> +		dev_err(dev, "Length wrong value!\n");

Semantics. "Wrong length" would be better.

> +		return -EINVAL;
> +	}
> +

of_property_count_elems_of_size() might be more appropriate here.

> +	ctx->pwm_fan_cooling_levels = devm_kzalloc(dev, len, GFP_KERNEL);
> +	if (!ctx->pwm_fan_cooling_levels)
> +		return -ENOMEM;
> +
> +	num = len / sizeof(u32);

What if 'num' is 0 ? Is that guaranteed to never happen ?

> +	if (of_property_read_u32_array(np, pp->name,
> +				       ctx->pwm_fan_cooling_levels, num)) {
> +		dev_err(dev, "Property: %s cannot be read!\n", pp->name);

The ':' after 'Property' in those error messages doesn't seem to make much sense
to me.

> +		return -EINVAL;

of_property_read_u32_array() returns an error code. Please use it.

> +	}
> +
> +	for (i = 0; i < num; i++) {
> +		if (ctx->pwm_fan_cooling_levels[i] > MAX_PWM) {
> +			dev_err(dev, "PWM fan state[%d]:%d > %d\n", i,
> +				ctx->pwm_fan_cooling_levels[i], MAX_PWM);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	ctx->pwm_fan_max_state = num - 1;
> +
> +	return 0;
> +}
> +
>  static int pwm_fan_probe(struct platform_device *pdev)
>  {
>  	struct device *hwmon;
> @@ -145,6 +189,8 @@ static int pwm_fan_probe(struct platform_device *pdev)
>  		pwm_disable(ctx->pwm);
>  		return PTR_ERR(hwmon);
>  	}
> +
> +	pwm_fan_of_get_cooling_data(&pdev->dev, ctx);

Now this is odd. Adding a function to return an error code just to ignore it
doesn't make much sense. While it makes sense to ignore errors if there is no
cooling data in the devicetree, errors due to bad devicetree data should not be
ignored.

I am also a bit concerned that you make this call _after_ instantiating the
hwmon device; this may potentially result in a race condition. Please ensure
that this is not the case.

Thanks,
Guenter
