Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaIVA2J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 20:28:09 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:47652 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaIVA2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 20:28:07 -0400
MIME-Version: 1.0
In-Reply-To: <541EA149.5000408@zonque.org>
References: <1411268469-21283-1-git-send-email-mranostay@gmail.com>
	<1411268469-21283-2-git-send-email-mranostay@gmail.com>
	<541EA149.5000408@zonque.org>
Date: Sun, 21 Sep 2014 17:28:05 -0700
Message-ID: <CAKzfze-3gmQX6oPKZvXPAqC1WxvPKS9QW1omXNA9+CSPW50BXw@mail.gmail.com>
Subject: Re: [PATCH 1/3] cap1106: Add support for various cap11xx devices
From: Matt Ranostay <mranostay@gmail.com>
To: Daniel Mack <daniel@zonque.org>
Cc: Kumar Gala <galak@codeaurora.org>, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2014 at 2:58 AM, Daniel Mack <daniel@zonque.org> wrote:
> Hi,
>
> On 09/21/2014 05:01 AM, Matt Ranostay wrote:
>> Several other variants of the cap11xx device exists with a varying
>> number of capacitance detection channels. Add support for creating
>> the channels dynamically.
>
> Thanks for the patches!
>
>>
>> Signed-off-by: Matt Ranostay <mranostay@gmail.com>
>> ---
>>  drivers/input/keyboard/cap1106.c | 54 +++++++++++++++++++---------------------
>
> Please also add a patch to rename the file to cap11xx.c, and make sure
> to export the patch with 'git format-patch -M' to detect the rename.
>
>> diff --git a/drivers/input/keyboard/cap1106.c b/drivers/input/keyboard/cap1106.c
>> index d70b65a..b9c43b5 100644
>> --- a/drivers/input/keyboard/cap1106.c
>> +++ b/drivers/input/keyboard/cap1106.c
>> @@ -55,8 +55,6 @@
>>  #define CAP1106_REG_MANUFACTURER_ID  0xfe
>>  #define CAP1106_REG_REVISION         0xff
>>
>> -#define CAP1106_NUM_CHN 6
>> -#define CAP1106_PRODUCT_ID   0x55
>>  #define CAP1106_MANUFACTURER_ID      0x5d
>>
>>  struct cap1106_priv {
>> @@ -64,7 +62,8 @@ struct cap1106_priv {
>>       struct input_dev *idev;
>>
>>       /* config */
>> -     unsigned short keycodes[CAP1106_NUM_CHN];
>> +     u32 *keycodes;
>
> unsigned short *, please. See below.
>
>> @@ -189,27 +188,23 @@ static int cap1106_i2c_probe(struct i2c_client *i2c_client,
>>       struct cap1106_priv *priv;
>>       struct device_node *node;
>>       int i, error, irq, gain = 0;
>> -     unsigned int val, rev;
>> -     u32 gain32, keycodes[CAP1106_NUM_CHN];
>> +     unsigned int val, prod, rev;
>> +     u32 gain32;
>>
>>       priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
>>       if (!priv)
>>               return -ENOMEM;
>>
>> +     priv->num_channels = (unsigned long) id->driver_data;
>
> priv->num_channels is unsigned int.
>
> Also, a BUG_ON(!priv->num_channels) wouldn't harm.
>
>> +     priv->keycodes = devm_kzalloc(dev,
>> +             sizeof(u32) * priv->num_channels, GFP_KERNEL);
>
> Use devm_kcalloc() to allocate an array.
>
>> @@ -235,17 +234,12 @@ static int cap1106_i2c_probe(struct i2c_client *i2c_client,
>>                       dev_err(dev, "Invalid sensor-gain value %d\n", gain32);
>>       }
>>
>> -     BUILD_BUG_ON(ARRAY_SIZE(keycodes) != ARRAY_SIZE(priv->keycodes));
>> -
>>       /* Provide some useful defaults */
>> -     for (i = 0; i < ARRAY_SIZE(keycodes); i++)
>> -             keycodes[i] = KEY_A + i;
>> +     for (i = 0; i < priv->num_channels; i++)
>> +             priv->keycodes[i] = KEY_A + i;
>>
>>       of_property_read_u32_array(node, "linux,keycodes",
>> -                                keycodes, ARRAY_SIZE(keycodes));
>> -
>> -     for (i = 0; i < ARRAY_SIZE(keycodes); i++)
>> -             priv->keycodes[i] = keycodes[i];
>> +                               priv->keycodes, priv->num_channels);
>
> Hmm, no. Internally, you have to store the keycodes as unsigned short,
> otherwise EVIOC{G|S}KEYCODE from usespace doesn't work.
>
> of_property_read_u16_array() should work here for unsigned short, I
> guess. Otherwise, you'd have to open-code the routine.
>
Problem with u16 is you'll to mark it */bits/ 16* in the device tree
entry.. I doubt that is acceptable


>> @@ -313,12 +307,16 @@ static int cap1106_i2c_probe(struct i2c_client *i2c_client,
>>
>>  static const struct of_device_id cap1106_dt_ids[] = {
>>       { .compatible = "microchip,cap1106", },
>> +     { .compatible = "microchip,cap1126", },
>> +     { .compatible = "microchip,cap1188", },
>
> Hmm, how can that work unless you set .data to the number of channels
> here? Did you test that with a DT-enabled board?
>
>
> Thanks,
> Daniel
