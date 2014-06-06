Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaFFNCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 09:02:45 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:56921 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaFFNCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 09:02:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140604131306.GB28484@ulmo>
References: <1399723210-21569-1-git-send-email-gautam.vivek@samsung.com>
	<1399723210-21569-7-git-send-email-gautam.vivek@samsung.com>
	<CAFp+6iFufCh6SVEF-HQA62ZsJGJGSebDSs28eqcrMy1X8e5vjA@mail.gmail.com>
	<20140604131306.GB28484@ulmo>
Date: Fri, 6 Jun 2014 18:32:42 +0530
X-Google-Sender-Auth: 6ias9Lfkt7oAx6CQlZICehYzQe0
Message-ID: <CAFp+6iEe8fvxboG79=2s=oe4BkQJYAoVUPtYkPdjJHCe+bC=8Q@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] usb: host: ohci-exynos: Use devm_ioremap_resource
 instead of devm_ioremap
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Alexander Shiyan <shc_work@mail.ru>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Wed, Jun 4, 2014 at 6:43 PM, Thierry Reding <thierry.reding@gmail.com> wrote:
> On Wed, Jun 04, 2014 at 03:41:20PM +0530, Vivek Gautam wrote:
>> Hi,
>>
>>
>> On Sat, May 10, 2014 at 5:30 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
>> > Using devm_ioremap_resource() API should actually be preferred over
>> > devm_ioremap(), since the former request the mem region first and then
>> > gives back the ioremap'ed memory pointer.
>> > devm_ioremap_resource() calls request_mem_region(), therby preventing
>> > other drivers to make any overlapping call to the same region.
>> >
>> > Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>>
>> Although this patch and rest in the series are merged.
>> But i have got a doubt, so making this thread alive.
>>
>> > ---
>> >  drivers/usb/host/ohci-exynos.c |    7 +++----
>> >  1 file changed, 3 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
>> > index 9cf80cb..dec691d 100644
>> > --- a/drivers/usb/host/ohci-exynos.c
>> > +++ b/drivers/usb/host/ohci-exynos.c
>> > @@ -120,10 +120,9 @@ skip_phy:
>> >
>> >         hcd->rsrc_start = res->start;
>> >         hcd->rsrc_len = resource_size(res);
>> > -       hcd->regs = devm_ioremap(&pdev->dev, res->start, hcd->rsrc_len);
>> > -       if (!hcd->regs) {
>> > -               dev_err(&pdev->dev, "Failed to remap I/O memory\n");
>> > -               err = -ENOMEM;
>> > +       hcd->regs = devm_ioremap_resource(&pdev->dev, res);
>>
>> Here, we replaced devm_ioremap() call with devm_ioremap_resource(),
>> which internally requests the memory region
>
> I guess this could lead to problems if drivers haven't been written to
> cleanly split the register ranges that they access, since now two
> overlapping regions may be requested and cause the drivers to fail.

Sorry i did not understand completely. Wouldn't the request_mem_region()
fail for an already busy resource ?
So devm_ioremap_resource() will in fact prevent the drivers from requesting
the same memory region twice until the first request frees the region.
Isn't it ?

>
>> and then does a "devm_ioremap()" or "devm_ioremap_nocache()" based on
>> the check for IORESOURCE_CACHEABLE flag.
>>
>> But this flag is not set for the resource of this device.
>> So should we be explicitly setting the flag in driver ?
>
> I don't think it makes much sense to map these registers cached anyway.
> Drivers will likely expect writes to this region to take effect without
> needing any kind of flushing.

These "hcd->regs" are going to be used by the controller, so wouldn't there be a
a performance difference when the requested address space is
cacheable/non-cacheable ?




-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
