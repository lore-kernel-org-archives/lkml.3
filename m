Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab3B1FqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 00:46:21 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17663 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3B1FqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 00:46:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 27 Feb 2013 21:45:12 -0800
Message-ID: <512EEECF.5090409@nvidia.com>
Date: Thu, 28 Feb 2013 11:14:47 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Ian Lartey <ian@slimlogic.co.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "cooloney@gmail.com" <cooloney@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/2] leds: Add support for Palmas LEDs
References: <1361970800-31460-1-git-send-email-ian@slimlogic.co.uk>
In-Reply-To: <1361970800-31460-1-git-send-email-ian@slimlogic.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 February 2013 06:43 PM, Ian Lartey wrote:
> The Palmas familly of chips has LED support. This is not always muxed
> to output pins so depending on the setting of the mux this driver
> will create the appropriate LED class devices.
>
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
> ---

Patch 1 and 2 can be merged together as this is makefile, Kconfig and 
driver addition.


> +
> +static int palmas_led_read(struct palmas_leds_data *leds, unsigned int reg,
> +               unsigned int *dest)
> +{
> +       unsigned int addr;
> +
> +       addr = PALMAS_BASE_TO_REG(PALMAS_LED_BASE, reg);
This is not require. Infact doing this will not work.

palmas_read already take care of proper offset.
         unsigned int addr =  PALMAS_BASE_TO_REG(base, reg);
         int slave_id = PALMAS_BASE_TO_SLAVE(base);

         return regmap_read(palmas->regmap[slave_id], addr, val);


same for other places also.


>
> +static void palmas_leds_work(struct work_struct *work)
> +{
> +       struct palmas_led *led = container_of(work, struct palmas_led, work);
> +       unsigned int period, ctrl;
> +       unsigned long flags;
> +
> +       mutex_lock(&led->mutex);
> +
> +       palmas_led_read(led->leds_data, PALMAS_LED_CTRL, &ctrl);
> +       palmas_led_read(led->leds_data, PALMAS_LED_PERIOD_CTRL, &period);
> +
> +       spin_lock_irqsave(&led->value_lock, flags);
> +
> +       switch (led->led_no) {
> +       case 1:
> +               ctrl &= ~PALMAS_LED_CTRL_LED_1_ON_TIME_MASK;
> +               period &= ~PALMAS_LED_PERIOD_CTRL_LED_1_PERIOD_MASK;
> +

case 1,2,3 and 4 looks same, jus shift/mask are changed. I think this 
can be rewritten here to reduce code size.


> +static int palmas_leds_probe(struct platform_device *pdev)
> +{
> +       struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
> +       struct palmas_leds_platform_data *pdata = pdev->dev.platform_data;
> +       struct palmas_leds_data *leds_data;
> +       struct device_node *node = pdev->dev.of_node;
> +       int ret, i;
> +       int offset = 0;
> +
> +       if (!palmas->led_muxed && !is_palmas_charger(palmas->product_id)) {
> +               dev_err(&pdev->dev, "there are no LEDs muxed\n");
> +               return -EINVAL;
> +       }
> +
> +       /* Palmas charger requires platform data */
> +       if (is_palmas_charger(palmas->product_id) && node && !pdata) {
> +               pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> +
> +               if (!pdata)
> +                       return -ENOMEM;
> +
> +               ret = palmas_dt_to_pdata(&pdev->dev, node, pdata);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       if (is_palmas_charger(palmas->product_id) && !pdata)
> +               return -EINVAL;
> +
> +       leds_data = kzalloc(sizeof(*leds_data), GFP_KERNEL);

Use devm_kzalloc().


> +
> +static int  palmas_leds_init(void)
> +{
> +       return platform_driver_register(&palmas_leds_driver);
> +}
> +module_init(palmas_leds_init);
> +
> +static void palmas_leds_exit(void)
> +{
> +       platform_driver_unregister(&palmas_leds_driver);
> +}
> +module_exit(palmas_leds_exit);

use Module_platform_driver().

