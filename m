Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbaLASVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 13:21:47 -0500
Received: from mail-bn1on0079.outbound.protection.outlook.com ([157.56.110.79]:27568
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753330AbaLASVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 13:21:45 -0500
Date: Mon, 1 Dec 2014 10:21:40 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
CC: Jonathan Corbet <corbet@lwn.net>, <linux-kernel@vger.kernel.org>,
        <linux-api@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v3] gpio: lib-sysfs: Add 'wakeup' attribute
References: <1414434602-14263-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414434602-14263-1-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21144.001
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <51327750bb694f229ecb1c229cb80b21@BN1AFFO11FD023.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(50944004)(189002)(377424004)(51704005)(164054003)(24454002)(199003)(47776003)(76176999)(108616004)(99396003)(102836001)(120916001)(6806004)(77096004)(50466002)(4396001)(95666004)(50986999)(31966008)(53416004)(19580395003)(74316001)(44976005)(92566001)(87936001)(64706001)(83506001)(20776003)(85182001)(33646002)(106466001)(19580405001)(23676002)(104016003)(107046002)(21056001)(54356999)(46102003)(77156002)(86362001)(62966003)(85202003)(15975445006)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB064;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB064;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB064;
X-Forefront-PRVS: 0412A98A59
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB064;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another month past. Any updates on this?

	Thanks,
	Sören

On Mon, 2014-10-27 at 11:30AM -0700, Soren Brinkmann wrote:
> Add an attribute 'wakeup' to the GPIO sysfs interface which allows
> marking/unmarking a GPIO as wake IRQ.
> The file 'wakeup' is created in each exported GPIOs directory, if an IRQ
> is associated with that GPIO and the irqchip implements set_wake().
> Writing 'enabled' to that file will enable wake for that GPIO, while
> writing 'disabled' will disable wake.
> Reading that file will return either 'disabled' or 'enabled' depening on
> the currently set flag for the GPIO's IRQ.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
> v3:
>  - add documentation
> v2:
>  - fix error path to unlock mutex before return
> 
> As additional reference, these are the email threads of the v2 and v1
> submission:
> https://lkml.org/lkml/2014/10/13/481
> https://lkml.org/lkml/2014/9/4/496
> ---
>  Documentation/ABI/testing/sysfs-gpio |  1 +
>  Documentation/gpio/sysfs.txt         |  8 ++++
>  drivers/gpio/gpiolib-sysfs.c         | 77 +++++++++++++++++++++++++++++++++---
>  3 files changed, 80 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-gpio b/Documentation/ABI/testing/sysfs-gpio
> index 80f4c94c7bef..4cc7f4b3f724 100644
> --- a/Documentation/ABI/testing/sysfs-gpio
> +++ b/Documentation/ABI/testing/sysfs-gpio
> @@ -20,6 +20,7 @@ Description:
>  	    /value ... always readable, writes fail for input GPIOs
>  	    /direction ... r/w as: in, out (default low); write: high, low
>  	    /edge ... r/w as: none, falling, rising, both
> +	    /wakeup ... r/w as: enabled, disabled
>  	/gpiochipN ... for each gpiochip; #N is its first GPIO
>  	    /base ... (r/o) same as N
>  	    /label ... (r/o) descriptive, not necessarily unique
> diff --git a/Documentation/gpio/sysfs.txt b/Documentation/gpio/sysfs.txt
> index c2c3a97f8ff7..f703377d528f 100644
> --- a/Documentation/gpio/sysfs.txt
> +++ b/Documentation/gpio/sysfs.txt
> @@ -97,6 +97,14 @@ and have the following read/write attributes:
>  		for "rising" and "falling" edges will follow this
>  		setting.
>  
> +	"wakeup" ... reads as either "enabled" or "disabled". Write these
> +		strings to set/clear the 'wakeup' flag of the IRQ associated
> +		with this GPIO. If the IRQ has the 'wakeup' flag set, it can
> +		wake the system from sleep states.
> +
> +		This file exists only if the pin can generate interrupts and
> +		the driver implements the required infrastructure.
> +
>  GPIO controllers have paths like /sys/class/gpio/gpiochip42/ (for the
>  controller implementing GPIOs starting at #42) and have the following
>  read-only attributes:
> diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
> index 5f2150b619a7..7588b6d5ba94 100644
> --- a/drivers/gpio/gpiolib-sysfs.c
> +++ b/drivers/gpio/gpiolib-sysfs.c
> @@ -286,6 +286,58 @@ found:
>  
>  static DEVICE_ATTR(edge, 0644, gpio_edge_show, gpio_edge_store);
>  
> +static ssize_t gpio_wakeup_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	ssize_t			status;
> +	const struct gpio_desc	*desc = dev_get_drvdata(dev);
> +	int			irq = gpiod_to_irq(desc);
> +	struct irq_desc		*irq_desc = irq_to_desc(irq);
> +
> +	mutex_lock(&sysfs_lock);
> +
> +	if (irqd_is_wakeup_set(&irq_desc->irq_data))
> +		status = sprintf(buf, "enabled\n");
> +	else
> +		status = sprintf(buf, "disabled\n");
> +
> +	mutex_unlock(&sysfs_lock);
> +
> +	return status;
> +}
> +
> +static ssize_t gpio_wakeup_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t size)
> +{
> +	int			ret;
> +	unsigned int		on;
> +	struct gpio_desc	*desc = dev_get_drvdata(dev);
> +	int			irq = gpiod_to_irq(desc);
> +
> +	mutex_lock(&sysfs_lock);
> +
> +	if (sysfs_streq("enabled", buf)) {
> +		on = true;
> +	} else if (sysfs_streq("disabled", buf)) {
> +		on = false;
> +	} else {
> +		mutex_unlock(&sysfs_lock);
> +		return -EINVAL;
> +	}
> +
> +	ret = irq_set_irq_wake(irq, on);
> +
> +	mutex_unlock(&sysfs_lock);
> +
> +	if (ret)
> +		pr_warn("%s: failed to %s wake\n", __func__,
> +				on ? "enable" : "disable");
> +
> +	return size;
> +}
> +
> +static DEVICE_ATTR(wakeup, 0644, gpio_wakeup_show, gpio_wakeup_store);
> +
>  static int sysfs_set_active_low(struct gpio_desc *desc, struct device *dev,
>  				int value)
>  {
> @@ -526,7 +578,7 @@ static struct class gpio_class = {
>  int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
>  {
>  	unsigned long		flags;
> -	int			status;
> +	int			status, irq;
>  	const char		*ioname = NULL;
>  	struct device		*dev;
>  	int			offset;
> @@ -582,11 +634,24 @@ int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
>  			goto fail_unregister_device;
>  	}
>  
> -	if (gpiod_to_irq(desc) >= 0 && (direction_may_change ||
> -				       !test_bit(FLAG_IS_OUT, &desc->flags))) {
> -		status = device_create_file(dev, &dev_attr_edge);
> -		if (status)
> -			goto fail_unregister_device;
> +	irq = gpiod_to_irq(desc);
> +	if (irq >= 0) {
> +		struct irq_desc *irq_desc = irq_to_desc(irq);
> +		struct irq_chip	*irqchip = irq_desc_get_chip(irq_desc);
> +
> +		if (direction_may_change ||
> +				!test_bit(FLAG_IS_OUT, &desc->flags)) {
> +			status = device_create_file(dev, &dev_attr_edge);
> +			if (status)
> +				goto fail_unregister_device;
> +		}
> +
> +		if (irqchip->flags & IRQCHIP_SKIP_SET_WAKE ||
> +				irqchip->irq_set_wake) {
> +			status = device_create_file(dev, &dev_attr_wakeup);
> +			if (status)
> +				goto fail_unregister_device;
> +		}
>  	}
>  
>  	set_bit(FLAG_EXPORT, &desc->flags);
> -- 
> 2.1.2.1.g5e69ed6
> 
