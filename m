Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbaE1VJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:09:51 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:48024 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbaE1VJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:09:49 -0400
Message-ID: <53865071.5060501@ahsoftware.de>
Date: Wed, 28 May 2014 23:09:05 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 01/27] mtd: nand: introduce function to fix a common bug
 in most nand-drivers not showing a device in sysfs
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de> <1401142372-14148-2-git-send-email-holler@ahsoftware.de> <20140528084344.GB4285@norris-Latitude-E6410> <53863056.2070405@ahsoftware.de> <20140528201018.GA3599@ld-irv-0074>
In-Reply-To: <20140528201018.GA3599@ld-irv-0074>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 28.05.2014 22:10, schrieb Brian Norris:
> On Wed, May 28, 2014 at 08:52:06PM +0200, Alexander Holler wrote:
>> Am 28.05.2014 10:43, schrieb Brian Norris:
>>> On Tue, May 27, 2014 at 12:12:26AM +0200, Alexander Holler wrote:
>>>> +{
>>>> +	mtd->priv	= priv;
>>>
>>> I don't think you should hide this one here. It will be quite obvious if
>>> a driver didn't stash its private data but tries to access it later. Are
>>> there any drivers that missed this?
>>
>> No, it just saves a line of source in all drivers and I think it
>> fits there. I don't understand why do you think it is hidden.
>
> The function name doesn't make it obvious what it's doing. So all code
> readers will have to follow the definition to see what it's doing. But
> this point is not that important, so I won't argue.

So you think every function does hide important things? How's about C?
It hides which registers are used. Maybe we should go back to assembler.
But I prefer to just press ctrl-} in vim.

>>>> +	mtd->owner	= pdev->dev.driver->owner;
>>>> +	mtd->dev.parent	= &pdev->dev;
>>>> +	mtd->name	= pdev->dev.driver->name;
>>>
>>> I think this is a little dangerous. You're potentially clobbering the
>>> name that a driver already chose here. And why did you pick to use the

It's a dangerous world. And ordering sometimes matters. Feel free to
post another patch where you add an if() or an if (). I don't care which
style you prefer, but checkpatch would want the second one.

And as I currently don't see your argument to use the driver instead of
the platform device, here's an argument why I prefer to use pdev:
someone might want to use the upper layer (here the platform device) in
that silly function in the future. A very personal decision I did., but...

>>> driver name? This gives non-unique names if there is more than one
>>> device instantiated for a driver. That's why some drivers already use
>>> the device name, not the driver name:
>>>
>>> 	mtd->name = dev_name(&pev->dev);
>>>
>>> And in fact, if any drivers are missing mtd->name, perhaps it's best to
>>> just modify the MTD registration to give them a default:
>>>
>>> 	if (!mtd->name)
>>> 		mtd->name = dev_name(&pdev->dev);
>>>
>>>> +}
>>
>> I don't clobber any name. The name is set as default before drivers
>> might do this.

BTW. I don't like what dev_name produces. E.g. on one box I use here
devname would produce f4000000.nand instead orion_nand. So I would have
to name partitons with f4000000.nand. I don't understand why someone
would prefer f4000000.nand instead of orion_nand, but I accept that
other people do so. I don't have to understand everything.

> At the moment this is true, but the ordering is somewhat subtle if you
> don't examine the details of mtd_setup_common_members() to see that it
> is assigning a name. I can easily imagine some new driver in which
> someone does:
>
> 	mtd->name = ...;
> 	[...]
> 	mtd_setup_common_members(mtd, priv, pdev);
>
> And doesn't notice that the ordering matters.
>
> You could make this simpler by either
> (1) making mtd_setup_common_members() check for mtd->name==NULL first
> (2) just move the (default) name assignment to the common MTD
>     registration, like I suggested
>
>>>> +
>>>>  extern int mtd_device_parse_register(struct mtd_info *mtd,
>>>>  				     const char * const *part_probe_types,
>>>>  				     struct mtd_part_parser_data *parser_data,
>>>
>>> How about we rethink the "helper" approach, and instead just do
>>> validation in the core code? This would cover most of the important
>>> parts of your helper, I think:
>>
>> Feel free to change all drivers. I like my approach with fixing 21
>> bugs by reducing code by 44 lines.
>
> I appreciate the bug fixes. I am just questioning the approach. Reduced
> (source) code doesn't help anyone if it makes the code less
> maintainable. My suggestions can probably make this more maintainable,
> fix the same bugs, and reduce the source by a similar (albeit smaller)
> number of lines.
>
>> And it offers a common function where future similiarities can be
>> put into too. Of course you can just add 21 lines, but that is not
>> how I do such stuff.
>
> I don't see how your common location helps much more than putting it in
> mtdcore.c like I suggested, without the extra function.
>
>> And I did the patches. If you don't like them, feel free to ignore
>> them. I'm not playing remote keyboard but I do patches like I would
>> do them, not like some arbitrary maintainer would do them. Sorry for
>> the harsh words.
>
> Arbitrary maintainer, eh? I'm simply suggesting that this could be
> accomplished in a better way. If you don't want to take part in the
> review process, then I have no obligation to engage either.

TIMTOWTDI. Humans are different, they think different, they write
different code, they see code different and they prefer different
styles. And what you think is a better way, isn't one in my point of
view. And I prefer to not discuss such silly things like this simple 4
line function.

I'm very sorry, but I find such discussions extremly tiresome.

If you just would have suggested that one if to prevent that someone who
doesn't c&p existing code would end up with a clobbered name (which he
obviously can't miss if he ever would test his new or changed driver),
than I maybe would have send a v2 with that if. But all the other noise
just made me to want I never had send (again) a patch to LKML. It is
almost impossible to avoid such answers and it turns every patch posting
into a endless story where people do want to discuss every line or even
character of totally silly things.

Alexander Holler
