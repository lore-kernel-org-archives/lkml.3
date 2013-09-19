Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab3ISUpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 16:45:17 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8721 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab3ISUpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 16:45:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 19 Sep 2013 13:45:13 -0700
Message-ID: <523B6257.4040302@nvidia.com>
Date: Thu, 19 Sep 2013 16:45:11 -0400
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Manish Badarkhe <badarkhe.manish@gmail.com>,
        Darbha Sriharsha <dsriharsha@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [Patch V2] drivers: power: Add support for bq24735 charger
References: <1379607514-11200-1-git-send-email-rklein@nvidia.com> <20130919202706.GB4470@ulmo>
In-Reply-To: <20130919202706.GB4470@ulmo>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/19/2013 4:27 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Thu, Sep 19, 2013 at 12:18:33PM -0400, Rhyland Klein wrote:
>> From: Darbha Sriharsha <dsriharsha@nvidia.com>
>>
>> Adding driver support for bq24735 charger chipset.
...snip
> 
>> +             return -ENOMEM;
>> +     }
>> +
>> +     charger_device->pdata = client->dev.platform_data;
>> +
>> +     if (!charger_device->pdata && client->dev.of_node)
> 
> If you use IS_ENABLED(CONFIG_OF) here, the compiler will see that it
> evaluates to 0 if OF is not selected, in which case it will be clever
> enough to see that bq24735_parse_dt_data() is not used and just discard
> it (because it is static). Then the #ifdefery above is not needed and
> you will get compile coverage whether or not OF has been selected. Which
> is a good thing.
> 
> That said, I've mentioned before that you may want to not support the
> non-DT at all since there's no immediate need, so this may not even be
> an issue.

The main reason I don't want to break non-DT support (or just not
implement it) is that this driver is going to be used in our downstream
kernels, and I prefer to minimize the patches they will have on top of
it so we don't diverge.

> 
>> +     name = charger_device->pdata->name;
>> +     if (!name) {
>> +             name = kasprintf(GFP_KERNEL, "bq24735-%s",
>> +                              dev_name(&client->dev));
> 
> Won't the device name already include bq24735 because of the driver
> name?

In my experience this comes up with a name like "bq24735-5-0009". Thats
why I added the bq24735 in the beginning, so the name is more descriptive.

> 
>> +             if (!name) {
>> +                     dev_err(&client->dev, "Failed to alloc device name\n");
> 
> Again, no need for the error message.
> 
>> +     charger->supplied_to = charger_device->pdata->supplied_to;
>> +     charger->num_supplicants = charger_device->pdata->num_supplicants;
> 
> I think these are never filled in in the DT case.

No. With DT there is a different mechanism for creating these linkages.
It uses phandles and so is doesn't overlap with these. This is here to
support non-DT init.

> 
>> +     ret = bq24735_read_word(charger_device->client,
> 
> You can just use client directly here.
> 
>> +                             BQ24735_MANUFACTURER_ID_REG);
>> +     if (ret != BQ24735_MANUFACTURER_ID) {
>> +             dev_err(charger_device->dev,
>> +             "manufacturer id mismatch..exiting driver..\n");
> 
> This should be reformatted. It's just weird.
> 
>> +             ret = -ENODEV;
> 
> Perhaps differentiate between the original error (ret, instead of
> overwriting it) and the case where the manufacturer ID doesn't match?
> 
>> +             goto err_free_name;
>> +     }
>> +
>> +     if (client->irq) {
>> +             ret = devm_request_threaded_irq(&client->dev, client->irq,
> 
> devm_request_threaded_irq() can be dangerous here. You seem to handle it
> properly in remove, but the ISR could be run at any point from here on
> in. And automatic removal will happen rather late.
> 
> The ISR could still be run at any point from here on in if you used the
> non-devm variant, so it's probably safer to call this much later. Since
> you'd call power_supply_changed() on an unregistered power_supply.

Thats a good point. I think using the non-devm version seems safer, will
switch to in in next version.

> 
>> +                     NULL, bq24735_charger_isr,
>> +                     IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING |
>> +                     IRQF_ONESHOT,
>> +                     charger->name, charger);
> 
> Parameter indentation again.
> 
>> +             if (ret) {
>> +                     dev_err(&client->dev,
>> +                             "Unable to register irq %d err %d\n",
> 
> "IRQ"
> 
>> +     if (charger_device->pdata->status_gpio) {
>> +             if (!gpio_is_valid(charger_device->pdata->status_gpio)) {
> 
> Why not make the first if check for gpio_is_valid()? Also, 0 is a valid
> GPIO number.

Will do.

> 
>> +                     dev_err(&client->dev, "Invalid gpio pin\n");
> 
> "GPIO". And would it make sense to continue with degraded functionality
> if no GPIO is specified? It seems like it given the initial check for a
> non-zero GPIO.

Yes. I'll fix that up.

> 
>> +     ret = bq24735_config_charger(charger_device);
>> +     if (ret < 0) {
>> +             dev_err(&client->dev, "failed in configuring charger");
>> +             goto err_free_name;
>> +     }
>> +
>> +     /* check for AC adapter presence */
>> +     ret = bq24735_read_word(charger_device->client, BQ24735_CHG_OPT_REG);
>> +     if (ret < 0)
>> +             goto err_free_name;
>> +     else if (ret & BQ24735_CHG_OPT_AC_PRESENT) {
>> +             /* enable charging */
>> +             ret = bq24735_enable_charging(charger_device);
>> +             if (ret < 0)
>> +                     goto err_free_name;
>> +     }
> 
> I think you already had code for this (in the one property accessor?),
> so perhaps it should be factored out.

Will do.

> 
> Also I don't see where charging is disabled. Or enabled when AC power is
> plugged after the device has been probed. How does that work?

I believe charging is auto-disabled when the adapter is unplugged, but I
will verify and if that doesn't seem to be the case. This is something
that should likely be added to the ISR (enable/disable).

> 
>> +err_free_name:
>> +     if (name && name != charger_device->pdata->name)
>> +             kfree(name);
> 
> kfree() can handle NULL pointers, so the check for name is unnecessary.

ok.

> 
>> diff --git a/include/linux/power/bq24735-charger.h b/include/linux/power/bq24735-charger.h
> [...]
>> +#ifndef __CHARGER_BQ24735_H_
>> +#define __CHARGER_BQ24735_H_
> 
> I would hope that we can get rid of this file. As I already mentioned,
> unless you're actually going to use platform data, there's little sense
> in adding support for it.
> 
>> +#define BQ24735_CHG_OPT_REG          0x12
>> +#define BQ24735_CHG_OPT_CHARGE_ENABLE        (1 << 0)
>> +#define BQ24735_ENABLE_CHARGING              0
>> +#define BQ24735_DISABLE_CHARGING     1
> 
> I don't think these are really useful. The field is already named
> CHARGE_ENABLE, so it should be pretty clear what you're supposed to put
> in here. For that matter, I'm not a huge fan of the whole "update bits"
> API because it encourages these things and they are just confusing.

The only thing about the enable bit is that isn't kind of inverted what
what you might expect. 1 is disabling. Thats why I think the bit
definitions for enable/disable make sense. What would you suggest to
replace the "update bits" API?

> 
>> +#define BQ24735_CHG_OPT_ACOC_THRESHOLD       (1 << 1)
>> +#define BQ24735_CHG_OPT_BOOST_MODE   (1 << 2)
>> +#define BQ24735_CHG_OPT_BOOST_ENABLE (1 << 3)
>> +#define BQ24735_CHG_OPT_AC_PRESENT   (1 << 4)
>> +#define BQ24735_CHG_OPT_IOUT_SELECTION       (1 << 5)
>> +#define BQ24735_CHG_OPT_LEARN_ENABLE (1 << 6)
>> +#define BQ24735_CHG_OPT_IFAULT_LOW   (1 << 7)
>> +#define BQ24735_CHG_OPT_IFAULT_HIGH  (1 << 8)
>> +#define BQ24735_CHG_OPT_EMI_SW_FREQ_EN       (1 << 9)
>> +#define BQ24735_CHG_OPT_EMI_SW_FREQ_ADJ      (1 << 10)
>> +#define BQ24735_CHG_OPT_BAT_DEPLETION        (3 << 11)
>> +#define BQ24735_CHG_OPT_WATCHDOG_TIMER       (3 << 13)
>> +#define BQ24735_CHG_OPT_ACOK_DEGLITCH        (1 << 15)
> 
> Most (if not all) of these fields are unused, so I'm not sure if it
> makes sense to list them here.

I had considered the same. I will remove them.

> 
>> +#define BQ24735_CHARGE_CURRENT_REG   0x14
>> +#define BQ24735_CHARGE_CURRENT_MASK  0x1fc0
>> +#define BQ24735_CHARGE_VOLTAGE_REG   0x15
>> +#define BQ24735_CHARGE_VOLTAGE_MASK  0x7ff0
>> +#define BQ24735_INPUT_CURRENT_REG    0x3f
>> +#define BQ24735_INPUT_CURRENT_MASK   0x1f80
>> +#define BQ24735_MANUFACTURER_ID_REG  0xfe
>> +#define BQ24735_DEVICE_ID_REG                0xff
> 
> I think I'd drop the _REG suffix. Also perhaps these register
> definitions should go into the driver source file.
> 
>> +#define BQ24735_MANUFACTURER_ID              0x0040
>> +#define BQ24735_DEVICE_ID            0x000B
> 
> I think these could actually be used literally, since you read out a
> register and compare the value to this one, it is immediately clear from
> the context that they are the reference manufacturer and device IDs that
> you expect for this driver.

Ok.

> 
>> +struct bq24735_platform {
>> +     uint32_t charge_current;
>> +     uint32_t charge_voltage;
>> +     uint32_t input_current;
>> +
>> +     const char *name;
>> +
>> +     int status_gpio;
>> +     int gpio_active_low;
> 
> This is somewhat unfortunate. Perhaps status_gpio_active_low. That makes
> it clear that it relates to the status_gpio, but it's also rather long.
> Fortunately there's some good work being done to the GPIO core that will
> hopefully make this unnecessary in the future.
> 
>> +
>> +     char **supplied_to;
>> +     size_t num_supplicants;
>> +};
> 
> If you don't implement platform data support, you can get rid of this.
> Move the registers to the driver source file and you don't need this
> header file at all anymore.
> 
> Thierry
> 
> * Unknown Key
> * 0x7F3EB3A1
> 

Thanks for the review, I'll take care of all the comments, and
investigate anything whose fix wasn't immediately apparent.

-rhyland

-- 
nvpublic
