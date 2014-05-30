Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934742AbaE3WAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 18:00:40 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39568 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934403AbaE3WAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 18:00:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140530214643.GL28131@pd.tnic>
References: <1367969371-27414-1-git-send-email-yinghai@kernel.org>
 <20140530170103.GE4607@google.com> <20140530214643.GL28131@pd.tnic>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 30 May 2014 16:00:17 -0600
Message-ID: <CAErSpo4kQViCtaG9Fs_Amyr0pp96fsmdX2puJueK6Jf_XXdm1Q@mail.gmail.com>
Subject: Re: [PATCH] PCI, EDAC: fix ordering assign resource and bus_add
To: Borislav Petkov <bp@alien8.de>
Cc: Yinghai Lu <yinghai@kernel.org>, Doug Thompson <dougthompson@xmission.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-edac@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 3:46 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, May 30, 2014 at 11:01:03AM -0600, Bjorn Helgaas wrote:
>> On Tue, May 07, 2013 at 04:29:31PM -0700, Yinghai Lu wrote:
>> > We should assign unassigned resource before pci_bus_add_device.
>> >
>> > as late one will enable driver and create sysfs file that will need
>> > pci io resources from assign unassigned code.
>> >
>> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> Applied to pci/resource for v3.16, thanks!
>
> This is touching drivers/edac/ and I guess I'm fine with it,
>
> Acked-by: Borislav Petkov <bp@suse.de>

Thanks, I should have waited for you.  I was assuming the merge window
would open on Monday, and I hoped for a day or two in -next, but now
it sounds like we might have an -rc8, so I needn't have been in such a
hurry.

>> > ---
>> >  drivers/edac/i82875p_edac.c |    3 ++-
>> >  1 file changed, 2 insertions(+), 1 deletion(-)
>> >
>> > Index: linux-2.6/drivers/edac/i82875p_edac.c
>> > ===================================================================
>> > --- linux-2.6.orig/drivers/edac/i82875p_edac.c
>> > +++ linux-2.6/drivers/edac/i82875p_edac.c
>> > @@ -293,13 +293,14 @@ static int i82875p_setup_overfl_dev(stru
>> >             if (dev == NULL)
>> >                     return 1;
>> >
>> > +           pci_bus_assign_resources(dev->bus);
>> > +
>> >             err = pci_bus_add_device(dev);
>> >             if (err) {
>> >                     i82875p_printk(KERN_ERR,
>> >                             "%s(): pci_bus_add_device() Failed\n",
>> >                             __func__);
>> >             }
>> > -           pci_bus_assign_resources(dev->bus);a
>
>
> ... one question though: how are people using those pci_bus*
> functions supposed to know that pci_bus_assign_resources needs to
> go before pci_bus_add_device? The comment in pci_bus_add_device()
> mentions something about it but wouldn't it be possible to call
> pci_bus_assign_resources() in pci_bus_add_device() when resources are
> not assigned?

Yeah, this is really a mess.  The pci_bus_*() functions (at least
pci_bus_add_device() and pci_bus_assign_resources()) are not really
intended to be called by drivers at all -- they should only be used by
the arch code that drives PCI enumeration.  Eventually I'd like to
even move them out of the arch code and into the PCI core.

In this i82875p case, it looks like this is basically a quirk that
unhides a device.  I think it's sort of dubious to poke at things the
BIOS has explicitly hidden from the OS, but apart from that, if we
turned this into an actual DECLARE_PCI_FIXUP_CLASS_EARLY() quirk on
the 82875_0 device, I think the normal PCI enumeration process would
find the 82875_6 device, and we could get rid of the whole "if (dev ==
NULL)" chunk.

Bjorn
