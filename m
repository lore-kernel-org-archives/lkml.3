Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab3IMRrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 13:47:16 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:47872 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab3IMRrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 13:47:14 -0400
MIME-Version: 1.0
In-Reply-To: <20130902081625.GB12341@lee--X1>
References: <1378065614-18094-1-git-send-email-linus.walleij@linaro.org>
	<20130902081625.GB12341@lee--X1>
Date: Fri, 13 Sep 2013 19:47:13 +0200
Message-ID: <CACRpkdZO-i+mULNpkSzNAnqwL+2C+FYL1Pbc-uTU-6B9R3FHxw@mail.gmail.com>
Subject: Re: [PATCH 1/4] mfd: add STw481x driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 2, 2013 at 10:16 AM, Lee Jones <lee.jones@linaro.org> wrote:
> [Me]

>> This adds a driver for the STw481x PMICs found in the Nomadik
>> family of platforms. This one uses pure device tree probing.
>> Print some of the OTP registers on boot and register a regulator
>> MFD child.
(...)

> Please see to the checkpatch.pl pointed out by Wang.

Fixed these.

>> +config MFD_STW481X
>> +     bool "Support for ST Microelectronics STw481x"
>> +     depends on I2C && ARCH_NOMADIK
>
> I believe this chip is commercially available, therefore it's surely
> possible that they 'could' appear on !NOMADIK platforms? What are the
> dependencies on the Nomadik platform?

It is basically a chipset and only appear together, but removing the
ARCH_NOMADIK dependency gives better coverage on other platforms
so I would prefer to remove it, but IIRC it blew up on the S390 (!)
platform, but I'll try it again without.

>> +     ret = regmap_write(stw481x->map, 0x1f, msb);
>
> Any chance in replacing the register param #defined?

Fixed this.

> I still don't know what this function is doing. I'm taking a guess
> that we're fetching the power control registers as opposed to some
> kind of pinctrl?

Its a set of set of registers which can be written once at
manufacturing, then they cannot be changed. So it's something
of a set of power ROM values.

> With the variables used in the function and in the map, coupled with
> the !#defined register values is making it really hard to see exactly
> what we're doing here.

I'm adding a piece of kerneldoc to the function to hash things out...

>> +static int stw481x_startup(struct stw481x *stw481x)
>> +{
>> +     u8 vcore_val[] = { 100, 105, 110, 115, 120, 122, 124, 126, 128,
>> +                        130, 132, 134, 136, 138, 140, 145 };
>> +     u8 vpll_val[] = { 105, 120, 130, 180 };
>> +     u8 vaux_val[] = { 15, 18, 25, 28 };
>
> I had to look further down to see that these were voltages*100. Any
> chance of a small comment here to allude to the fact?

OK fixed it.

>> +static int stw481x_probe(struct i2c_client *client,
>> +                      const struct i2c_device_id *id)
>> +{
>> +     struct stw481x                  *stw481x;
>> +     struct stw481x_platform_data    *pdata = client->dev.platform_data;
>
> If this is a DT only won't this always be NULL, or does the I2C
> subsystem populate it using some automagic routine?

No spot on, what kind of crap is this... just development cruft
lying around in the corners ... :-/ deleted it.

>> +     stw481x = devm_kzalloc(&client->dev, sizeof(*stw481x), GFP_KERNEL);
>> +     if (!stw481x)
>> +             return -ENOMEM;
>
> This is a question, rather than a statement; can *alloc ever return
> anything other than a pointer or -ENOMEM? If so, you should probably
> return stw481x here, if not, just ignore me.

It doesn't ever return a negative return code, it returns a valid pointer
or NULL if the *alloc failed. This is to mimic the behaviour of POSIX
malloc() I think, so we check if it's NULL then return the error code.

>> +fail:
>> +     devm_kfree(&client->dev, stw481x);
>
> Does this device carry on living after this probe function? I don't
> think it does, so you can omit any freeing of memory if you're using
> managed resources.

Good point, another copypaste bug.

>> +     devm_kfree(&client->dev, stw481x);
>
> ... same here.

Fixed this too.

>> +/*
>> + * This ID table is completely unused, as this is a pure
>> + * device-tree probed driver, but it has to be here due to
>> + * the structure of the I2C core.
>> + */
>
> That's not true. It will be used if anyone decides not to use the
> of_device_id table. As this is an I2C device you can register it via
> Device Tree by (in this case) putting 'dummy' as the node name, so
> it's almost certainly not good to use that name here.

Sorry I don't get it. Whatever string I put in there can be abused
instead of using the proper compatible string (which is the proper way
to probe DT I2C devices), I've tried to fix this for DT-only I2C devices
but a tiresome regression due to drivers relying on this
i2c_device_id not being NULL and inability to remove it from the I2C
core without refactoring the world ensued, see:
http://marc.info/?l=linux-i2c&m=136847631009831&w=2

>> +static const struct i2c_device_id dummy_id[] = {
>> +     { "dummy", 0 },
>> +     { }
>> +};

I can rename it to
"dummy-node-do-not-match-dt-node-to-i2c-device-id-damn-it"
if you wish ;-)

>> +static const struct of_device_id stw481x_match[] = {
>> +     { .compatible = "st,stw4810", },
>> +     { .compatible = "st,stw4811", },
>> +        {},
>
> Funny spacing here.

OK fixed this.

>> +static int __init stw481x_init(void)
>> +{
>> +     return i2c_add_driver(&stw481x_driver);
>> +}
>> +module_init(stw481x_init);
>> +
>> +static void __exit stw481x_exit(void)
>> +{
>> +     i2c_del_driver(&stw481x_driver);
>> +}
>> +module_exit(stw481x_exit);
>
> Better to remove all this boiler plate and replace with module_i2c_driver().

Good point. Fixed it.

Yours,
Linus Walleij
