Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454Ab3HNHQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 03:16:55 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:45546 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227Ab3HNHQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 03:16:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAK5ve-+rJ81pNR6g3gn4N7FG-Xwbbz8=148HS5Z9y1O5iF9M1g@mail.gmail.com>
References: <1376030744-22645-1-git-send-email-ricardo.ribalda@gmail.com>
 <1376030744-22645-2-git-send-email-ricardo.ribalda@gmail.com>
 <CAPybu_1D0mywdj9xhCRfg95J9SRMGnGeUJ9YG-=QKYgnQhFvdw@mail.gmail.com> <CAK5ve-+rJ81pNR6g3gn4N7FG-Xwbbz8=148HS5Z9y1O5iF9M1g@mail.gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 14 Aug 2013 09:16:30 +0200
Message-ID: <CAPybu_1xWb8ZO9_JZRhm=HDYMpbyvnE=btDE1OnLEkhK2aamsg@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] leds-pca9633: Add support for PCA9634
To: Bryan Wu <cooloney@gmail.com>
Cc: Peter Meerwald <p.meerwald@bct-electronic.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bryan

I have sent a new series (v4). Beware that there is a new patch
appended to the series, I think I found some problems while dt parsing

Best regards!

On Tue, Aug 13, 2013 at 7:12 PM, Bryan Wu <cooloney@gmail.com> wrote:
> On Tue, Aug 13, 2013 at 7:49 AM, Ricardo Ribalda Delgado
> <ricardo.ribalda@gmail.com> wrote:
>> Hello Bryan
>>
>> Did you have a chance to look at the new series?
>>
>
> Sorry for the delay. I have no problem for this series. Could you
> please rebase to my tree's for-next branch [1]? And post again?
> Because recently there were several pca9533 driver changes merged,
> your patches can't be applied cleanly.
>
> Thanks,
> -Bryan
>
> [1]: http://git.kernel.org/cgit/linux/kernel/git/cooloney/linux-leds.git
>>
>> On Fri, Aug 9, 2013 at 8:45 AM, Ricardo Ribalda Delgado
>> <ricardo.ribalda@gmail.com> wrote:
>>> Add support for PCA9634 chip, which belongs to the same family as the
>>> 9633 but with support for 8 outputs instead of 4.
>>>
>>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>>> ---
>>>  drivers/leds/Kconfig        |    7 ++--
>>>  drivers/leds/leds-pca9633.c |   74 +++++++++++++++++++++++++++++++------------
>>>  2 files changed, 58 insertions(+), 23 deletions(-)
>>>
>>> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
>>> index e43402d..023af58 100644
>>> --- a/drivers/leds/Kconfig
>>> +++ b/drivers/leds/Kconfig
>>> @@ -280,12 +280,13 @@ config LEDS_PCA955X
>>>           devices include PCA9550, PCA9551, PCA9552, and PCA9553.
>>>
>>>  config LEDS_PCA9633
>>> -       tristate "LED support for PCA9633 I2C chip"
>>> +       tristate "LED support for PCA963x I2C chip"
>>>         depends on LEDS_CLASS
>>>         depends on I2C
>>>         help
>>> -         This option enables support for LEDs connected to the PCA9633
>>> -         LED driver chip accessed via the I2C bus.
>>> +         This option enables support for LEDs connected to the PCA963x
>>> +         LED driver chip accessed via the I2C bus. Supported
>>> +         devices include PCA9633 and PCA9634
>>>
>>>  config LEDS_WM831X_STATUS
>>>         tristate "LED support for status LEDs on WM831x PMICs"
>>> diff --git a/drivers/leds/leds-pca9633.c b/drivers/leds/leds-pca9633.c
>>> index 9aae567..070358a 100644
>>> --- a/drivers/leds/leds-pca9633.c
>>> +++ b/drivers/leds/leds-pca9633.c
>>> @@ -1,7 +1,9 @@
>>>  /*
>>>   * Copyright 2011 bct electronic GmbH
>>> + * Copyright 2013 Qtechnology/AS
>>>   *
>>>   * Author: Peter Meerwald <p.meerwald@bct-electronic.com>
>>> + * Author: Ricardo Ribalda <ricardo.ribalda@gmail.com>
>>>   *
>>>   * Based on leds-pca955x.c
>>>   *
>>> @@ -10,6 +12,7 @@
>>>   * directory of this archive for more details.
>>>   *
>>>   * LED driver for the PCA9633 I2C LED driver (7-bit slave address 0x62)
>>> + * LED driver for the PCA9634 I2C LED driver (7-bit slave address set by hw.)
>>>   *
>>>   */
>>>
>>> @@ -33,20 +36,42 @@
>>>  #define PCA9633_MODE1          0x00
>>>  #define PCA9633_MODE2          0x01
>>>  #define PCA9633_PWM_BASE       0x02
>>> -#define PCA9633_LEDOUT         0x08
>>> +
>>> +enum pca9633_type {
>>> +       pca9633,
>>> +       pca9634,
>>> +};
>>> +
>>> +struct pca9633_chipdef {
>>> +       u8                      ledout_base;
>>> +       int                     n_leds;
>>> +};
>>> +
>>> +static struct pca9633_chipdef pca9633_chipdefs[] = {
>>> +       [pca9633] = {
>>> +               .ledout_base    = 0x8,
>>> +               .n_leds         = 4,
>>> +       },
>>> +       [pca9634] = {
>>> +               .ledout_base    = 0xc,
>>> +               .n_leds         = 8,
>>> +       },
>>> +};
>>>
>>>  static const struct i2c_device_id pca9633_id[] = {
>>> -       { "pca9633", 0 },
>>> +       { "pca9633", pca9633 },
>>> +       { "pca9634", pca9634 },
>>>         { }
>>>  };
>>>  MODULE_DEVICE_TABLE(i2c, pca9633_id);
>>>
>>>  struct pca9633_led {
>>>         struct i2c_client *client;
>>> +       struct pca9633_chipdef *chipdef;
>>>         struct work_struct work;
>>>         enum led_brightness brightness;
>>>         struct led_classdev led_cdev;
>>> -       int led_num; /* 0 .. 3 potentially */
>>> +       int led_num; /* 0 .. 7 potentially */
>>>         char name[32];
>>>  };
>>>
>>> @@ -54,24 +79,26 @@ static void pca9633_led_work(struct work_struct *work)
>>>  {
>>>         struct pca9633_led *pca9633 = container_of(work,
>>>                 struct pca9633_led, work);
>>> -       u8 ledout = i2c_smbus_read_byte_data(pca9633->client, PCA9633_LEDOUT);
>>> -       int shift = 2 * pca9633->led_num;
>>> +       u8 ledout_addr = pca9633->chipdef->ledout_base + (pca9633->led_num / 4);
>>> +       u8 ledout;
>>> +       int shift = 2 * (pca9633->led_num % 4);
>>>         u8 mask = 0x3 << shift;
>>>
>>> +       ledout = i2c_smbus_read_byte_data(pca9633->client, ledout_addr);
>>>         switch (pca9633->brightness) {
>>>         case LED_FULL:
>>> -               i2c_smbus_write_byte_data(pca9633->client, PCA9633_LEDOUT,
>>> +               i2c_smbus_write_byte_data(pca9633->client, ledout_addr,
>>>                         (ledout & ~mask) | (PCA9633_LED_ON << shift));
>>>                 break;
>>>         case LED_OFF:
>>> -               i2c_smbus_write_byte_data(pca9633->client, PCA9633_LEDOUT,
>>> +               i2c_smbus_write_byte_data(pca9633->client, ledout_addr,
>>>                         ledout & ~mask);
>>>                 break;
>>>         default:
>>>                 i2c_smbus_write_byte_data(pca9633->client,
>>>                         PCA9633_PWM_BASE + pca9633->led_num,
>>>                         pca9633->brightness);
>>> -               i2c_smbus_write_byte_data(pca9633->client, PCA9633_LEDOUT,
>>> +               i2c_smbus_write_byte_data(pca9633->client, ledout_addr,
>>>                         (ledout & ~mask) | (PCA9633_LED_PWM << shift));
>>>                 break;
>>>         }
>>> @@ -98,26 +125,30 @@ static int pca9633_probe(struct i2c_client *client,
>>>  {
>>>         struct pca9633_led *pca9633;
>>>         struct pca9633_platform_data *pdata;
>>> +       struct pca9633_chipdef *chip;
>>>         int i, err;
>>>
>>> +       chip = &pca9633_chipdefs[id->driver_data];
>>>         pdata = client->dev.platform_data;
>>>
>>> -       if (pdata) {
>>> -               if (pdata->leds.num_leds <= 0 || pdata->leds.num_leds > 4) {
>>> -                       dev_err(&client->dev, "board info must claim at most 4 LEDs");
>>> -                       return -EINVAL;
>>> -               }
>>> +       if (pdata && (pdata->leds.num_leds < 1 ||
>>> +                                pdata->leds.num_leds > chip->n_leds)) {
>>> +               dev_err(&client->dev, "board info must claim 1-%d LEDs",
>>> +                                                               chip->n_leds);
>>> +               return -EINVAL;
>>>         }
>>>
>>> -       pca9633 = devm_kzalloc(&client->dev, 4 * sizeof(*pca9633), GFP_KERNEL);
>>> +       pca9633 = devm_kzalloc(&client->dev, chip->n_leds * sizeof(*pca9633),
>>> +                                                               GFP_KERNEL);
>>>         if (!pca9633)
>>>                 return -ENOMEM;
>>>
>>>         i2c_set_clientdata(client, pca9633);
>>>
>>> -       for (i = 0; i < 4; i++) {
>>> +       for (i = 0; i < chip->n_leds; i++) {
>>>                 pca9633[i].client = client;
>>>                 pca9633[i].led_num = i;
>>> +               pca9633[i].chipdef = chip;
>>>
>>>                 /* Platform data can specify LED names and default triggers */
>>>                 if (pdata && i < pdata->leds.num_leds) {
>>> @@ -151,7 +182,9 @@ static int pca9633_probe(struct i2c_client *client,
>>>                 i2c_smbus_write_byte_data(client, PCA9633_MODE2, 0x01);
>>>
>>>         /* Turn off LEDs */
>>> -       i2c_smbus_write_byte_data(client, PCA9633_LEDOUT, 0x00);
>>> +       i2c_smbus_write_byte_data(client, chip->ledout_base, 0x00);
>>> +       if (chip->n_leds > 4)
>>> +               i2c_smbus_write_byte_data(client, chip->ledout_base + 1, 0x00);
>>>
>>>         return 0;
>>>
>>> @@ -169,10 +202,11 @@ static int pca9633_remove(struct i2c_client *client)
>>>         struct pca9633_led *pca9633 = i2c_get_clientdata(client);
>>>         int i;
>>>
>>> -       for (i = 0; i < 4; i++) {
>>> -               led_classdev_unregister(&pca9633[i].led_cdev);
>>> -               cancel_work_sync(&pca9633[i].work);
>>> -       }
>>> +       for (i = 0; i < pca9633->chipdef->n_leds; i++)
>>> +               if (pca9633[i].client != NULL) {
>>> +                       led_classdev_unregister(&pca9633[i].led_cdev);
>>> +                       cancel_work_sync(&pca9633[i].work);
>>> +               }
>>>
>>>         return 0;
>>>  }
>>> --
>>> 1.7.10.4
>>>
>>
>>
>>
>> --
>> Ricardo Ribalda



-- 
Ricardo Ribalda
