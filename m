Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbaAUN2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 08:28:54 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:42661 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbaAUN2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 08:28:47 -0500
MIME-Version: 1.0
In-Reply-To: <20131126023431.GC31517@core.coreip.homeip.net>
References: <1384270261-15889-1-git-send-email-linus.walleij@linaro.org>
	<20131126023431.GC31517@core.coreip.homeip.net>
Date: Tue, 21 Jan 2014 14:28:46 +0100
Message-ID: <CACRpkdZW-Nay-wOywq4SG1bwQf_+J4tqYuS=tQmzTHOtBskGVw@mail.gmail.com>
Subject: Re: [PATCH 4/5 v3] input: tc3589x-keypad: support probing from device tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 3:34 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Tue, Nov 12, 2013 at 04:31:01PM +0100, Linus Walleij wrote:
>> Implement device tree probing for the tc3589x keypad driver.
>> This is modeled on the STMPE keypad driver and tested on the
>> Ux500 TVK1281618 UIB.
>>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> ---
>> ChangeLog v2->v3:
>> - Use two local u32 variables to avoid weirdness in u8 casting
>>   of the resulting values to the pointers.
>> ChangeLog v1->v2:
>> - Fix rows/columns binding to read two u32's insead of two
>>   u8 /bits/ as noted by Mark Rutland.
>> ---
>>  drivers/input/keyboard/tc3589x-keypad.c | 66 ++++++++++++++++++++++++++++++++-
>>  1 file changed, 64 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/input/keyboard/tc3589x-keypad.c b/drivers/input/keyboard/tc3589x-keypad.c
>> index 208de7cbb7fa..7f36e7addb86 100644
>> --- a/drivers/input/keyboard/tc3589x-keypad.c
>> +++ b/drivers/input/keyboard/tc3589x-keypad.c
>> @@ -297,6 +297,65 @@ static void tc3589x_keypad_close(struct input_dev *input)
>>       tc3589x_keypad_disable(keypad);
>>  }
>>
>> +#ifdef CONFIG_OF
>> +static const struct tc3589x_keypad_platform_data *
>> +tc3589x_keypad_of_probe(struct device *dev)
>> +{
>> +     struct device_node *np = dev->of_node;
>> +     struct tc3589x_keypad_platform_data *plat;
>> +     u32 cols, rows;
>> +     u32 debounce_ms;
>> +     int proplen;
>> +
>> +     if (!np)
>> +             return ERR_PTR(-ENODEV);
>> +
>> +     plat = devm_kzalloc(dev, sizeof(*plat), GFP_KERNEL);
>> +     if (!plat)
>> +             return ERR_PTR(-ENOMEM);
>> +
>> +     of_property_read_u32(np, "keypad,num-columns", &cols);
>> +     of_property_read_u32(np, "keypad,num-rows", &rows);
>> +     plat->kcol = (u8) cols;
>> +     plat->krow = (u8) rows;
>> +     if (!plat->krow || !plat->kcol ||
>> +          plat->krow > TC_KPD_ROWS || plat->kcol > TC_KPD_COLUMNS) {
>> +             dev_err(dev,
>> +                     "keypad columns/rows not properly specified (%ux%u)\n",
>> +                     plat->kcol, plat->krow);
>> +             return ERR_PTR(-EINVAL);
>> +     }
>> +
>> +     if (!of_get_property(np, "linux,keymap", &proplen)) {
>> +             dev_err(dev, "property linux,keymap not found\n");
>> +             return ERR_PTR(-ENOENT);
>> +     }
>> +
>> +     plat->no_autorepeat = of_property_read_bool(np, "linux,no-autorepeat");
>
> So, have DT overlords settled on the autorepeat property?

Yeah, what is happening here? Shall we delay this patch set perpetually
due to inability to get some clear indication on this, or shall we just merge
it?

>>       irq = platform_get_irq(pdev, 0);
>> --
>
> Don't you also want to add MODULE_DEVICE_TABLE entry?

Probably, but that'd be a separate subject though, I think?
I'll make a patch for this so you get something you can
actually merge.

Yours,
Linus Walleij
