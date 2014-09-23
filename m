Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320AbaIWWFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:05:10 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:33098 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239AbaIWWFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:05:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140923215509.GB15481@roeck-us.net>
References: <1402347812-8059-1-git-send-email-andreas.noever@gmail.com>
 <580c2c85f8424369910b69a8f871f82e@DM2PR05MB671.namprd05.prod.outlook.com> <20140923215509.GB15481@roeck-us.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 23 Sep 2014 16:04:42 -0600
Message-ID: <CAErSpo6dEevVxCS2bqq=+_99uLvN0tccbAdvH2cn12xRVSv2oQ@mail.gmail.com>
Subject: Re: [PATCH] PCI: Prevent NULL dereference during pciehp probe
To: Guenter Roeck <linux@roeck-us.net>
Cc: Rajat Jain <rajatjain@juniper.net>,
        Andreas Noever <andreas.noever@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Guenter Roeck <groeck@juniper.net>,
        "rajatxjain@gmail.com" <rajatxjain@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 3:55 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Mon, Sep 15, 2014 at 10:20:41PM +0000, Rajat Jain wrote:
>> Hello Bjorn,
>>
>> I think this patch needs to be applied to all -stable branches (all the way back to 3.2).
>>
>> I encounter this same issue on my platform that is running 3.14.y.
>>
> Bjorn,
>
> can you send this to -stable, or is it ok if I do it ?

I forgot to mention it, but I did mark it for stable, so it should
happen automatically:

https://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/commit/?h=pci/hotplug&id=bceee4a97eb58bd0e80e39eff11b506ddd9e7ad3

>> > -----Original Message-----
>> > From: linux-pci-owner@vger.kernel.org [mailto:linux-pci-
>> > owner@vger.kernel.org] On Behalf Of Andreas Noever
>> > Sent: Monday, June 09, 2014 2:04 PM
>> > To: linux-kernel@vger.kernel.org; Bjorn Helgaas; linux-pci@vger.kernel.org
>> > Cc: Andreas Noever
>> > Subject: [PATCH] PCI: Prevent NULL dereference during pciehp probe
>> >
>> > pciehp assumes that dev->subordinate exists. But we do not assign a bus if
>> > we run out of bus numbers during enumeration. This leads to a NULL
>> > dereference in init_slot (and other places).
>> >
>> > Change pciehp_probe to return -ENODEV when no subordinate bus is
>> > present.
>> >
>> > Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
>> > ---
>> >  drivers/pci/hotplug/pciehp_core.c | 7 +++++++
>> >  1 file changed, 7 insertions(+)
>> >
>> > diff --git a/drivers/pci/hotplug/pciehp_core.c
>> > b/drivers/pci/hotplug/pciehp_core.c
>> > index 0e0a2ff..e5abcaf 100644
>> > --- a/drivers/pci/hotplug/pciehp_core.c
>> > +++ b/drivers/pci/hotplug/pciehp_core.c
>> > @@ -255,6 +255,13 @@ static int pciehp_probe(struct pcie_device *dev)
>> >     else if (pciehp_acpi_slot_detection_check(dev->port))
>> >             goto err_out_none;
>> >
>> > +   if (!dev->port->subordinate) {
>> > +           /* Can happen if we run out of bus numbers during probe */
>> > +           dev_err(&dev->device,
>> > +                   "Hotplug bridge without secondary bus, ignoring\n");
>> > +           goto err_out_none;
>> > +   }
>> > +
>> >     ctrl = pcie_init(dev);
>> >     if (!ctrl) {
>> >             dev_err(&dev->device, "Controller initialization failed\n");
>> > --
>> > 2.0.0
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-pci" in the
>> > body of a message to majordomo@vger.kernel.org More majordomo info at
>> > http://vger.kernel.org/majordomo-info.html
