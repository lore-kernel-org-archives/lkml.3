Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab3FKRtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:49:22 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:56725 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666Ab3FKRtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:49:21 -0400
Message-ID: <51B76204.1000204@schinagl.nl>
Date: Tue, 11 Jun 2013 19:44:36 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: "maxime.ripard" <maxime.ripard@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses;
 Unanswered comments
References: <1370185130-15332-1-git-send-email-oliver+list@schinagl.nl> <1370185130-15332-2-git-send-email-oliver+list@schinagl.nl> <CAHp75Vdqc9xiPBvQUB3Hfb4EBFUsoVxyuH8MK=9spJ4+rieoDQ@mail.gmail.com> <51B64877.4040908@schinagl.nl> <CAHp75Vf8-JRjTHjoUDQPXA3LK3SQSeCzyroF=J4ZLmHMzy6jvw@mail.gmail.com>
In-Reply-To: <CAHp75Vf8-JRjTHjoUDQPXA3LK3SQSeCzyroF=J4ZLmHMzy6jvw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

While waiting/working in comments I realized/was reminded that there 
where a few things I hadn't addressed. I'll try to go over all the 
missing bits to be sure to answer all questions before submitting the 
hopefully final version. This because I wouldn't want anybody to think 
I'm ungrateful, because I am very much so.


 > On 05/17/13 23:18, Maxime Ripard wrote:
>> +
>> +struct sid_priv {
>> +	void __iomem *sid_base;
>> +};
>> +
>> +struct sid_priv *p;
>
> What's the point of having a structure here? And why putting a global
> value, !static, with a generic name, while you could have an
> instance-specific one?

and related (with the struct killed and the mem* renamed)

 > On 02-06-13 17:09, Russell King - ARM Linux wrote:
> So what happens if you have two of these devices?  Maybe you want to check
> whether p_sid_reg_base is already set?

I had to think a while about it, as my first answer was 'i don't know'. 
But yeah you can't without some smart trick that I don't yet know.

 > On 06-06-13 21:16, Andy Shevchenko wrote:
 >> +static void __iomem *p_sid_reg_base;
 > So, why it's global?
 >

The idea behind the global pointer is, to have sunxi_sid_read_byte() be 
usable without anything other then a memory offset/address of what byte 
you want to read. The idea behind that is that you can use it from 
within the kernel directly. I'll admit it's a future-proofing thing, 
it's not exported now as there is no user for it yet. I talked to Maxime 
about it and we (he) decided it's best to remove it for now, as we can 
always add it back later when we find a user for it.

Having two SID's however is almost impossible too, since you get 1 per 
SoC, and only 1 SoC per kernel? I added a guard in .probe() which only 
loads the driver if the pointer is NULL.

 > On 02-06-13 17:09, Russell King - ARM Linux wrote:
>> +	if (likely((SID_SIZE))) {
>> +		sid_key = ioread32be(p_sid_reg_base + round_down(offset, 4));
>> +		sid_key >>= (offset % 4) * 8;
>> +		ret = sid_key & 0xff;
>> +	}
>
> What happens if you unbind the device in sysfs and then try and use
> this function?
>
It goes kaboom. Again, i had no idea naturally. I think what you meant 
was, if you unbind and p_sid_reg_base points to 'somewhere' and we just 
randomly read bytes. I added p_sid_reg_base to the guard above to at 
least check if it's not NULL.

 > On 02-06-13 17:09, Russell King - ARM Linux wrote:
>> +static int sunxi_sid_remove(struct platform_device *pdev)
>> +{
>> +	device_remove_bin_file(&pdev->dev, &sid_bin_attr);
>> +	dev_info(&pdev->dev, "Sunxi SID driver unloaded successfully.\n");
>
> Maybe you want to set p_sid_reg_base to NULL here?
>
Yeah, that made even more sense to the above thing and added it. When we 
unbind or unload the driver, we point to NULL and a) can check for it 
above and don't have nasty things dangling around. I think it was save 
to assume, that when the driver is unloaded/unbound, the devm_set_data() 
private data gets cleaned and the pointer set to NULL? I think that's 
what Maxime/Emilio said, by using the devm stuff, those should get 
cleaned up properly.

 > On 02-06-13 17:09, Russell King - ARM Linux wrote:
>> +	platform_set_drvdata(pdev, sid_reg_base);
>> +	p_sid_reg_base = sid_reg_base;
>
> So what happens if you have two of these devices?  Maybe you want to check
> whether p_sid_reg_base is already set?
>
Even that hint didn't trigger me as to why this could cause problems. 
Userspace guy here, every driver has its own memory space right? So I've 
added a guard that we only load this driver once and only if 
p_sid_reg_base is NULL.

 > On 02-06-13 17:09, Russell King - ARM Linux wrote:
>> +	dev_info(dev, "Sunxi SID driver loaded successfully.\n");
>
> Do we really need to report that the driver "loaded successfully" ?
> Do we need lots of lines in the kernel log telling us simply that
> random driver X was built into the kernel or the module was loaded?
Don't we do that already though? I made the string more informative by 
adding version information, but yeah I see tons of 'all is ok' rolling 
by, isn't that a good thing? Isn't that only printed if we actually have 
a SID onboard, so the user knows 'sid is available'. I know I often 
scroll through dmesg to see if things got brought up nicely.

> On 06-06-13 21:16, Andy Shevchenko wrote:
>> +       if (likely((SID_SIZE))) {
> Extra braces.
> Use antipattern here.
While this is a really small function, I guess if that's the normal 
course of things; why not.


> On 06-06-13 21:16, Andy Shevchenko wrote:
>> +               ret = sid_key & 0xff;
> No need to do & 0xff, since return type is byte.
>
With ret removed, I assume having return (u8)sid_key; is okay? Does that 
typecast only return the last byte? Or do we still want & 0xff in the 
return added for clarity?

 > On 06-06-13 21:16, Andy Shevchenko wrote
>> +static int __init sunxi_sid_probe(struct platform_device *pdev)
>> +{
>> +       int entropy[SID_SIZE], i, ret;
>
> Usually ret variable is located at the end of definition block.
> Moreover, there is no relationship between those three. It means one
> line per variable.
>
That's a good rule to group variables with, I should have known. Done.

> On 06-06-13 21:16, Andy Shevchenko wrote:
>> +       dev = &pdev->dev;
> Please, be consistent, somewhere you still use &pdev->dev.
> I recomend to use &pdev->dev everywhere in probe(), since we don't
> know if the device will be probed successfully.
>
I would have thought that 'dev' would that it would be the same and valid,
but yes, I should have been consistent throughout. What bothers me here,
is that I actually managed to overlook it.



