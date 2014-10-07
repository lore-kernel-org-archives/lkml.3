Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbaJGU2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 16:28:40 -0400
Received: from mail-bn1bon0069.outbound.protection.outlook.com ([157.56.111.69]:1664
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753381AbaJGU2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 16:28:38 -0400
Date: Tue, 7 Oct 2014 13:28:32 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH RESEND] gpio: lib-sysfs: Add 'wakeup' attribute
References: <1409853506-26279-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409853506-26279-1-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21000.005
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <f931db7ac1184254ba87b8abdba2a13a@BN1BFFO11FD013.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(51694002)(199003)(164054003)(51704005)(24454002)(53754006)(377424004)(85306004)(108616004)(50466002)(80022003)(46102003)(23676002)(33646002)(107046002)(76482002)(31966008)(74316001)(85202003)(120916001)(106466001)(99396003)(54356999)(86362001)(95666004)(85852003)(87936001)(76176999)(47776003)(85182001)(19580405001)(20776003)(44976005)(4396001)(77096002)(53416004)(19580395003)(83506001)(102836001)(92566001)(104016003)(50986999)(64706001)(15975445006)(21056001)(6806004)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB061;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB061;
X-Forefront-PRVS: 035748864E
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

just wanted to check on the status of this patch?

	Thanks,
	Sören

On Thu, 2014-09-04 at 10:58AM -0700, Soren Brinkmann wrote:
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
> ---
> Hi all,
> 
> I originally submitted this patch with a few fixes for Zynq's GPIO driver
> (https://lkml.org/lkml/2014/8/29/391). Since this change is not just
> Zynq-related and has broader impact, Linus asked me to post this again, separate
> from the Zynq series.
> 
> Let me just quote myself from the original submission:
> "I'm still not fully convinced that the gpio_keys are the best
> replacement for the sysfs interface when it comes to inputs. For that
> reason and to have a way to do some quick wake testing, I'd like to
> propose adding the ability to control wake through the sysfs interface
> (patch 3)."
> 
> 	Thanks,
> 	Sören
> 
>  drivers/gpio/gpiolib-sysfs.c | 75 ++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 69 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
> index 5f2150b619a7..aaf021eaaff5 100644
> --- a/drivers/gpio/gpiolib-sysfs.c
> +++ b/drivers/gpio/gpiolib-sysfs.c
> @@ -286,6 +286,56 @@ found:
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
> +	if (sysfs_streq("enabled", buf))
> +		on = true;
> +	else if (sysfs_streq("disabled", buf))
> +		on = false;
> +	else
> +		return -EINVAL;
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
> @@ -526,7 +576,7 @@ static struct class gpio_class = {
>  int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
>  {
>  	unsigned long		flags;
> -	int			status;
> +	int			status, irq;
>  	const char		*ioname = NULL;
>  	struct device		*dev;
>  	int			offset;
> @@ -582,11 +632,24 @@ int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
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
> 2.1.0.1.g27b9230
> 
