Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab3ITQVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:21:35 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15690 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab3ITQVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:21:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 20 Sep 2013 09:18:05 -0700
Message-ID: <523C760A.8060402@nvidia.com>
Date: Fri, 20 Sep 2013 12:21:30 -0400
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
References: <1379607514-11200-1-git-send-email-rklein@nvidia.com> <20130919202706.GB4470@ulmo> <523B6257.4040302@nvidia.com> <20130920075302.GB8575@ulmo>
In-Reply-To: <20130920075302.GB8575@ulmo>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/20/2013 3:53 AM, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Thu, Sep 19, 2013 at 04:45:11PM -0400, Rhyland Klein wrote:
>> On 9/19/2013 4:27 PM, Thierry Reding wrote:
>>>> Old Signed by an unknown key
>>>
>>> On Thu, Sep 19, 2013 at 12:18:33PM -0400, Rhyland Klein wrote:
>>>> From: Darbha Sriharsha <dsriharsha@nvidia.com>
>>>>
>>>> Adding driver support for bq24735 charger chipset.
>> ...snip
>>>
>>>> +             return -ENOMEM;
>>>> +     }
>>>> +
>>>> +     charger_device->pdata = client->dev.platform_data;
>>>> +
>>>> +     if (!charger_device->pdata && client->dev.of_node)
>>>
>>> If you use IS_ENABLED(CONFIG_OF) here, the compiler will see that it
>>> evaluates to 0 if OF is not selected, in which case it will be clever
>>> enough to see that bq24735_parse_dt_data() is not used and just discard
>>> it (because it is static). Then the #ifdefery above is not needed and
>>> you will get compile coverage whether or not OF has been selected. Which
>>> is a good thing.
>>>
>>> That said, I've mentioned before that you may want to not support the
>>> non-DT at all since there's no immediate need, so this may not even be
>>> an issue.
>>
>> The main reason I don't want to break non-DT support (or just not
>> implement it) is that this driver is going to be used in our downstream
>> kernels, and I prefer to minimize the patches they will have on top of
>> it so we don't diverge.
> 
> I was under the impression that our downstream kernels used DT for a lot
> of devices already. This doesn't look like a very special binding, and I
> don't see a reason why we'd have to use platform data in our downstream
> kernels.

Specifically, there is a platform that uses this part where the chip
itself isn't connected to an i2c bus (From what I understand). In that
case, they actually add callbacks into the platform data and then use
them to configure the charger.

> 
>>>> +     name = charger_device->pdata->name;
>>>> +     if (!name) {
>>>> +             name = kasprintf(GFP_KERNEL, "bq24735-%s",
>>>> +                              dev_name(&client->dev));
>>>
>>> Won't the device name already include bq24735 because of the driver
>>> name?
>>
>> In my experience this comes up with a name like "bq24735-5-0009". Thats
>> why I added the bq24735 in the beginning, so the name is more descriptive.
> 
> Yes, you're right. Perhaps in that case it's even easier to just stick
> with a static string such as "bq24735" or "bq24735-charger". It's likely
> to be the only device of that type in a machine. If you want to include
> the device name, perhaps something like "%s/bq24735" (5-0009/bq24735) is
> clearer that 5-0009 is actually the bus-specific name.

I prefer to have the bus identifier included in some way just because in
theory there could be multiple chargers and this will make their names
unique in sysfs. I am fine with either way, I simply followed the model
I saw in other drivers (like the sbs-battery driver). In fact, many
driver seem to just use the dev_name(), but I think either way is fine.
Maybe Anton or David have a preference.

> 
>>> Also I don't see where charging is disabled. Or enabled when AC power is
>>> plugged after the device has been probed. How does that work?
>>
>> I believe charging is auto-disabled when the adapter is unplugged, but I
>> will verify and if that doesn't seem to be the case. This is something
>> that should likely be added to the ISR (enable/disable).
> 
> I can very well imagine that it's auto-disabled when the power supply is
> unplugged, but probably more importantly charging should be reenabled
> when the supply is plugged again.
> 
>>>> +#define BQ24735_CHG_OPT_REG          0x12
>>>> +#define BQ24735_CHG_OPT_CHARGE_ENABLE        (1 << 0)
>>>> +#define BQ24735_ENABLE_CHARGING              0
>>>> +#define BQ24735_DISABLE_CHARGING     1
>>>
>>> I don't think these are really useful. The field is already named
>>> CHARGE_ENABLE, so it should be pretty clear what you're supposed to put
>>> in here. For that matter, I'm not a huge fan of the whole "update bits"
>>> API because it encourages these things and they are just confusing.
>>
>> The only thing about the enable bit is that isn't kind of inverted what
>> what you might expect. 1 is disabling. Thats why I think the bit
>> definitions for enable/disable make sense. What would you suggest to
>> replace the "update bits" API?
> 
> Well, especially for single bits I find it much more intuitive to do
> something like this:
> 
> 	value = read();
> 	value |= ENABLE;
> 	write(value);
> 
> or
> 
> 	value = read();
> 	value &= ~ENABLE;
> 	write(value);
> 
> And if the meaning of the bit is inverted, then you can just rename
> ENABLE to DISABLE. "update bits" might be fine for fields wider than a
> single bit, but even in those cases, I find something like the above
> much easier to read. But perhaps that's just personal preference.

I see your point I think your examples work fine for me. And since we
don't use any of the larger bit fields currently, we don't have to worry
about those cases right now.

> 
> Thierry
> 
> * Unknown Key
> * 0x7F3EB3A1
> 

thanks again,
Rhyland


-- 
nvpublic
