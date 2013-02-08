Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947219Ab3BHV1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 16:27:08 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:40468 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947146Ab3BHV1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 16:27:05 -0500
Message-ID: <51156DA3.2080006@gmail.com>
Date: Fri, 08 Feb 2013 22:26:59 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Benoit Thebaudeau <benoit.thebaudeau@advansee.com>,
        David Hardeman <david@hardeman.nu>, Trilok Soni <tsoni@codeaurora.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Matus Ujhelyi <ujhelyi.m@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2] media: rc: gpio-ir-recv: add support for device tree
 parsing
References: <1360137832-13086-1-git-send-email-sebastian.hesselbarth@gmail.com> <1360355887-19973-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1360355887-19973-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2013 09:38 PM, Sebastian Hesselbarth wrote:
> This patch adds device tree parsing for gpio_ir_recv platform_data and
> the mandatory binding documentation. It basically follows what we already
> have for e.g. gpio_keys. All required device tree properties are OS
> independent but an optional property allow linux specific support for rc
> maps.
>
> There was a similar patch sent by Matus Ujhelyi but that discussion
> died after the first reviews.
>
> Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
> ---
> Changelog
>
> v1->v2:
> - get rid of ptr returned by _get_devtree_pdata()
> - check for of_node instead for NULL pdata
> - remove unneccessary double check for gpios property
> - remove unneccessary #ifdef CONFIG_OF around match table
>
> Cc: Grant Likely<grant.likely@secretlab.ca>
> Cc: Rob Herring<rob.herring@calxeda.com>
> Cc: Rob Landley<rob@landley.net>
> Cc: Mauro Carvalho Chehab<mchehab@redhat.com>
> Cc: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
> Cc: Benoit Thebaudeau<benoit.thebaudeau@advansee.com>
> Cc: David Hardeman<david@hardeman.nu>
> Cc: Trilok Soni<tsoni@codeaurora.org>
> Cc: Sylwester Nawrocki<s.nawrocki@samsung.com>
> Cc: Matus Ujhelyi<ujhelyi.m@gmail.com>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> ---
>   .../devicetree/bindings/media/gpio-ir-receiver.txt |   16 ++++++
>   drivers/media/rc/gpio-ir-recv.c                    |   57 ++++++++++++++++++++
>   2 files changed, 73 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/media/gpio-ir-receiver.txt
>
> diff --git a/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt b/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt
> new file mode 100644
> index 0000000..8589f30
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt
> @@ -0,0 +1,16 @@
> +Device-Tree bindings for GPIO IR receiver
> +
> +Required properties:
> +	- compatible = "gpio-ir-receiver";
> +	- gpios: OF device-tree gpio specification.

Perhaps:
	- compatible: should be "gpio-ir-receiver";
	- gpios: specifies GPIO used for IR signal reception.
?
> +
> +Optional properties:
> +	- linux,rc-map-name: Linux specific remote control map name.
> +
> +Example node:
> +
> +	ir: ir-receiver {
> +		compatible = "gpio-ir-receiver";
> +		gpios =<&gpio0 19 1>;
> +		linux,rc-map-name = "rc-rc6-mce";
> +	};
> diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
> index 4f71a7d..3c62006 100644
> --- a/drivers/media/rc/gpio-ir-recv.c
> +++ b/drivers/media/rc/gpio-ir-recv.c
> @@ -16,6 +16,7 @@
>   #include<linux/interrupt.h>
>   #include<linux/gpio.h>
>   #include<linux/slab.h>
> +#include<linux/of_gpio.h>
>   #include<linux/platform_device.h>
>   #include<linux/irq.h>
>   #include<media/rc-core.h>
> @@ -30,6 +31,50 @@ struct gpio_rc_dev {
>   	bool active_low;
>   };
>
> +#ifdef CONFIG_OF
> +/*
> + * Translate OpenFirmware node properties into platform_data
> + */
> +static int gpio_ir_recv_get_devtree_pdata(struct device *dev,
> +				  struct gpio_ir_recv_platform_data *pdata)
> +{
> +	struct device_node *np = dev->of_node;
> +	enum of_gpio_flags flags;
> +	int gpio;
> +
> +	gpio = of_get_gpio_flags(np, 0,&flags);
> +	if (gpio<  0) {
> +		if (gpio != -EPROBE_DEFER)
> +			dev_err(dev, "Failed to get gpio flags, error: %d\n",
> +				gpio);

			dev_err(dev, "Failed to get gpio flags (%d)\n",	gpio);
?
> +		return gpio;
> +	}
> +
> +	pdata->gpio_nr = gpio;
> +	pdata->active_low = (flags&  OF_GPIO_ACTIVE_LOW) ? true : false;

This could be simplified to:

	pdata->active_low = (flags & OF_GPIO_ACTIVE_LOW);

> +	/* probe() takes care of map_name == NULL or allowed_protos == 0 */
> +	pdata->map_name = of_get_property(np, "linux,rc-map-name", NULL);
> +	pdata->allowed_protos = 0;
> +
> +	return 0;
> +}
> +
> +static struct of_device_id gpio_ir_recv_of_match[] = {
> +	{ .compatible = "gpio-ir-receiver", },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, gpio_ir_recv_of_match);
> +
> +#else /* !CONFIG_OF */
> +
> +static inline struct gpio_ir_recv_platform_data *
> +gpio_ir_recv_get_devtree_pdata(struct device *dev)

Please check how it compiles with CONFIG_OF disabled ;)

You could also make it:

#define gpio_ir_recv_get_devtree_pdata  (-ENOSYS)

> +{
> +	return ERR_PTR(-ENODEV);
> +}
> +
> +#endif
> +
>   static irqreturn_t gpio_ir_recv_irq(int irq, void *dev_id)
>   {
>   	struct gpio_rc_dev *gpio_dev = dev_id;
> @@ -66,6 +111,17 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
>   					pdev->dev.platform_data;
>   	int rc;
>
> +	if (pdev->dev.of_node) {
> +		struct gpio_ir_recv_platform_data *dtpdata =

I think you could use pdata here instead, as previously. But I'm fine with
as it is now as well.

> +			devm_kzalloc(&pdev->dev, sizeof(*dtpdata), GFP_KERNEL);
> +		if (!dtpdata)
> +			return -ENOMEM;
> +		rc = gpio_ir_recv_get_devtree_pdata(&pdev->dev, dtpdata);
> +		if (rc)
> +			return rc;
> +		pdata = dtpdata;
> +	}
> +
>   	if (!pdata)
>   		return -EINVAL;
>
> @@ -192,6 +248,7 @@ static struct platform_driver gpio_ir_recv_driver = {
>   	.driver = {
>   		.name   = GPIO_IR_DRIVER_NAME,
>   		.owner  = THIS_MODULE,
> +		.of_match_table = of_match_ptr(gpio_ir_recv_of_match),
>   #ifdef CONFIG_PM
>   		.pm	=&gpio_ir_recv_pm_ops,
>   #endif

The patch looks good to me in general, after fixing the empty function
declaration please feel free to add:

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--

Thanks,
Sylwester


