Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab3B1No2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 08:44:28 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:60124 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab3B1No0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 08:44:26 -0500
Message-ID: <512F5F32.90307@slimlogic.co.uk>
Date: Thu, 28 Feb 2013 13:44:18 +0000
From: Ian Lartey <ian@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
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
References: <1361970800-31460-1-git-send-email-ian@slimlogic.co.uk> <512EEECF.5090409@nvidia.com> <512F44FD.2040104@slimlogic.co.uk>
In-Reply-To: <512F44FD.2040104@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/02/13 11:52, Ian Lartey wrote:
> On 28/02/13 05:44, Laxman Dewangan wrote:
>> On Wednesday 27 February 2013 06:43 PM, Ian Lartey wrote:
>>> The Palmas familly of chips has LED support. This is not always muxed
>>> to output pins so depending on the setting of the mux this driver
>>> will create the appropriate LED class devices.
>>>
>>> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
>>> Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
>>> ---
>>
>> Patch 1 and 2 can be merged together as this is makefile, Kconfig and
>> driver addition.
>
> This could cause a merge conflict for anyone adding files/drivers
> in drivers/leds so it's safer to separate the Kconfig and Makefile
> from the actual drver source code so that can go in conflict free.
>
>>
>>
>>> +
>>> +static int palmas_led_read(struct palmas_leds_data *leds, unsigned
>>> int reg,
>>> +               unsigned int *dest)
>>> +{
>>> +       unsigned int addr;
>>> +
>>> +       addr = PALMAS_BASE_TO_REG(PALMAS_LED_BASE, reg);
>> This is not require. Infact doing this will not work.
>
> Yes, of course, thanks for that.
>>
>> palmas_read already take care of proper offset.
>>          unsigned int addr =  PALMAS_BASE_TO_REG(base, reg);
>>          int slave_id = PALMAS_BASE_TO_SLAVE(base);
>>
>>          return regmap_read(palmas->regmap[slave_id], addr, val);
>>
>>
>> same for other places also.
>
> ditto.
>
>>
>>
>>>
>>> +static void palmas_leds_work(struct work_struct *work)
>>> +{
>>> +       struct palmas_led *led = container_of(work, struct palmas_led,
>>> work);
>>> +       unsigned int period, ctrl;
>>> +       unsigned long flags;
>>> +
>>> +       mutex_lock(&led->mutex);
>>> +
>>> +       palmas_led_read(led->leds_data, PALMAS_LED_CTRL, &ctrl);
>>> +       palmas_led_read(led->leds_data, PALMAS_LED_PERIOD_CTRL,
>>> &period);
>>> +
>>> +       spin_lock_irqsave(&led->value_lock, flags);
>>> +
>>> +       switch (led->led_no) {
>>> +       case 1:
>>> +               ctrl &= ~PALMAS_LED_CTRL_LED_1_ON_TIME_MASK;
>>> +               period &= ~PALMAS_LED_PERIOD_CTRL_LED_1_PERIOD_MASK;
>>> +
>>
>> case 1,2,3 and 4 looks same, jus shift/mask are changed. I think this
>> can be rewritten here to reduce code size.
>
> Will do.

Hi Laxman,

Looking at this again I think the cose is as small as it can be
whilst maintaining readability.
Is is fairly compact as this is setting up the ctrl, period
led->blink, and led->brightness values  that are used in the
next section to actually write to the led control registers.

Ian
>
>>
>>
>>> +static int palmas_leds_probe(struct platform_device *pdev)
>>> +{
>>> +       struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
>>> +       struct palmas_leds_platform_data *pdata =
>>> pdev->dev.platform_data;
>>> +       struct palmas_leds_data *leds_data;
>>> +       struct device_node *node = pdev->dev.of_node;
>>> +       int ret, i;
>>> +       int offset = 0;
>>> +
>>> +       if (!palmas->led_muxed &&
>>> !is_palmas_charger(palmas->product_id)) {
>>> +               dev_err(&pdev->dev, "there are no LEDs muxed\n");
>>> +               return -EINVAL;
>>> +       }
>>> +
>>> +       /* Palmas charger requires platform data */
>>> +       if (is_palmas_charger(palmas->product_id) && node && !pdata) {
>>> +               pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata),
>>> GFP_KERNEL);
>>> +
>>> +               if (!pdata)
>>> +                       return -ENOMEM;
>>> +
>>> +               ret = palmas_dt_to_pdata(&pdev->dev, node, pdata);
>>> +               if (ret)
>>> +                       return ret;
>>> +       }
>>> +
>>> +       if (is_palmas_charger(palmas->product_id) && !pdata)
>>> +               return -EINVAL;
>>> +
>>> +       leds_data = kzalloc(sizeof(*leds_data), GFP_KERNEL);
>>
>> Use devm_kzalloc().
>
> Noted.
>
>>
>>
>>> +
>>> +static int  palmas_leds_init(void)
>>> +{
>>> +       return platform_driver_register(&palmas_leds_driver);
>>> +}
>>> +module_init(palmas_leds_init);
>>> +
>>> +static void palmas_leds_exit(void)
>>> +{
>>> +       platform_driver_unregister(&palmas_leds_driver);
>>> +}
>>> +module_exit(palmas_leds_exit);
>>
>> use Module_platform_driver().
>
> Will do.
>
>>
>
>
> Thanks,
>
> Ian

