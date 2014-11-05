Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbaKEJs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:48:26 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:43347 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaKEJsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:48:18 -0500
MIME-Version: 1.0
In-Reply-To: <20141105093430.GH22361@norris-Latitude-E6410>
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
	<1401142372-14148-2-git-send-email-holler@ahsoftware.de>
	<20140528084344.GB4285@norris-Latitude-E6410>
	<20141102210353.GA9968@gmail.com>
	<20141105093430.GH22361@norris-Latitude-E6410>
Date: Wed, 5 Nov 2014 10:48:16 +0100
Message-ID: <CAH6sp9NgHAJDFTOznBRD79aj5rPeAVzsSFCpYr6LN_FfNP6_-A@mail.gmail.com>
Subject: Re: [PATCH 01/27] mtd: nand: introduce function to fix a common bug
 in most nand-drivers not showing a device in sysfs
From: Frans Klaver <fransklaver@gmail.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Alexander Holler <holler@ahsoftware.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2014 at 10:34 AM, Brian Norris
<computersforpeace@gmail.com> wrote:
> On Sun, Nov 02, 2014 at 10:03:53PM +0100, Frans Klaver wrote:
>> On Wed, May 28, 2014 at 01:43:44AM -0700, Brian Norris wrote:
>> > And in fact, if any drivers are missing mtd->name, perhaps it's best to
>> > just modify the MTD registration to give them a default:
>> >
>> >     if (!mtd->name)
>> >             mtd->name = dev_name(&pdev->dev);
>> >
>>
>> ...
>>
>> > How about we rethink the "helper" approach, and instead just do
>> > validation in the core code? This would cover most of the important
>> > parts of your helper, I think:
>> >
>> > diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
>> > index d201feeb3ca6..39ba5812a5a3 100644
>> > --- a/drivers/mtd/mtdcore.c
>> > +++ b/drivers/mtd/mtdcore.c
>> > @@ -397,6 +397,11 @@ int add_mtd_device(struct mtd_info *mtd)
>> >     if (device_register(&mtd->dev) != 0)
>> >             goto fail_added;
>> >
>> > +   if (mtd->dev.parent)
>> > +           mtd->owner = mtd->dev.parent->driver->owner;
>> > +   else
>> > +           WARN_ON(1);
>> > +
>>
>> So I've picked this up now. I do largely agree with the suggested
>> approach where the validation and default settings are done in the core
>> code. There is a problem with this, though. There are MTD devices that
>> call mtd_device_parse_register() in the _init() function (such as the
>> maps drivers). These don't have a device ready to be used as parent, and
>> they would always be throwing this warning.
>
> Yeah, I came across the same thing. I think gluebi is another example.
>
>> So either not having a parent device is bad, or it isn't. The comment
>> suggests it is, the existing code suggests it isn't. So we'll need to
>> make a decision about who's right.
>
> I think not having a parent is not really bad. It's helpful for tracking
> the device hierarchy in sysfs, but it's not strictly necessary. So we
> should probably not do anything drastic like WARN_ON() yet.

OK. I'll probably add some sane defaults to add_mtd_device() and have
the mtd drivers make use of that fact. Since this isn't really
critical, I guess fixing the sysfs entry won't need back-porting.


>> >     if (MTD_DEVT(i))
>> >             device_create(&mtd_class, mtd->dev.parent,
>> >                           MTD_DEVT(i) + 1,
>> > diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
>> > index 1ca9aec141ff..9869bbef50cf 100644
>> > --- a/drivers/mtd/mtdpart.c
>> > +++ b/drivers/mtd/mtdpart.c
>> > @@ -370,7 +370,6 @@ static struct mtd_part *allocate_partition(struct mtd_info *master,
>> >     slave->mtd.subpage_sft = master->subpage_sft;
>> >
>> >     slave->mtd.name = name;
>> > -   slave->mtd.owner = master->owner;
>>
>> What would be the purpose of removing this line? Owner is already set?
>> Can we rely on that?
>
> I'm not completely sure why I wrote that, but I think the only call site
> for alloc_partition() is in mtd_add_partition(), which calls
> add_mtd_device().

Alright, I'll have a brief look into that again, then.

Thanks,
Frans
