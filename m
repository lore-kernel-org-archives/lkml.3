Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab3BETXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 14:23:15 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:61022 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437Ab3BETXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 14:23:11 -0500
MIME-Version: 1.0
In-Reply-To: <1360078091.4485.32.camel@rhapsody>
References: <20130204115246.5569.85829.stgit@zurg> <20130204115557.5569.9748.stgit@zurg>
 <1360016458.4485.11.camel@rhapsody> <CAErSpo7k96noiCtGYUFyuUQhE2GQA8ro5-9WC-JU_1HOWKUGvg@mail.gmail.com>
 <1360078091.4485.32.camel@rhapsody>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 5 Feb 2013 12:22:49 -0700
Message-ID: <CAErSpo7sYCmfd0X7PBfYS_ZK5sijxS3mpmhkrQ6UqO_xDry69Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] PCI: don't touch enable_cnt in pci_device_shutdown()
To: Khalid Aziz <khalid@gonehiking.org>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        e1000-devel@lists.sourceforge.net, linux-pci@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg@redhat.com>,
        khalid.aziz@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 8:28 AM, Khalid Aziz <khalid@gonehiking.org> wrote:
> On Mon, 2013-02-04 at 16:13 -0700, Bjorn Helgaas wrote:
>> On Mon, Feb 4, 2013 at 3:20 PM, Khalid Aziz <khalid@gonehiking.org> wrote:
>> > On Mon, 2013-02-04 at 15:55 +0400, Konstantin Khlebnikov wrote:
>> >> Matthew Garrett and Alan Cox said (see LKML link below) that clearing bus-master
>> >> for all PCI devices may lead to unpredictable consequences, some devices ignores
>> >> this bit and continues DMA, some of them hang after that or crash whole system.
>> >> Probably we should leave here only warning and disable bus-mastering for each
>> >> driver individually in ->shutdown() callback.
>> >
>> > Agreed that the right place for shutting down a PCI device properly and
>> > clearing its Bus Master bit, is the driver shutdown routine, if only all
>> > drivers supplied a shutdown routine. As it is today, there are too many
>> > drivers that do not provide a shutdown routine, ata_piix, Marvell SATA
>> > driver, ATI AGP driver just to name a few among a large number of them.
>> > Yet kexec is expected to work inspite of these drivers especially since
>> > kdump depends on it. So until all PCI drivers supply a shutdown routine,
>> > this is just a band-aid to disable interrupt and Bus Master bit in
>> > pci_device_shutdown(). Most drivers do seem to supply a suspend and
>> > resume function and it was discussed many years ago if it is feasible to
>> > use the suspend() routine for drivers to shut devices down cleanly.
>> > Maybe it is time to revisit that discussion.
>>
>> This patch as posted doesn't do anything with IRQs.  It only clears
>> PCI_COMMAND_MASTER.
>>
>> I'm open to considering something with IRQs, but I don't understand
>> exactly what we should do.  In your response to the previous version
>> (https://lkml.org/lkml/2013/1/28/720) you suggested this:
>>
>>   pci_clear_master(pci_dev);
>>   pcibios_disable_device(pci_dev);
>>
>> Did you figure out specifically why pcibios_disable_device() helps?
>> Using pcibios_disable_device() doesn't seem like the ideal solution
>> because on most architectures, it is an empty function with no obvious
>> connection to IRQs.  On x86 with ACPI, it cleans up some ACPI PCI IRQ
>> stuff, but as far as I can tell, it doesn't actually touch the PCI
>> device itself or even the IOAPIC to which it's connected, so I'm not
>> sure how this would help kexec.
>
> My reading of the code was that pcibios_disable_device() does clear the
> interrupt on x86 and ia64. I am not deeply familiar with the ACPI code
> and I might be interpreting it incorrectly, so please do correct me if I
> am reading it incorrectly. Here is the code sequence I see:
>
> pcibios_disable_device() ->
>    pcibios_disable_irq() ->
>        acpi_pci_irq_disable() ->
>            acpi_pci_link_free_irq() ->
>               acpi_evaluate_object(link->device->handle, "_DIS", NULL,
> NULL);
>
> My understanding is the evaluation of ACPI _DIS method will disable the
> interrupt from the device. Does that sound reasonable?

I see the code you're looking at in acpi_pci_link_free_irq(), but we
only evaluate _DIS if link->refcnt == 0, and I don't think refcnt is
ever zero at that point.

refcnt starts out at zero in acpi_pci_link_add() (called when we find
PNP0C0F devices), and it's incremented in acpi_pci_link_allocate_irq()
(called in the pci_enable_device() path), but as far as I can tell,
it's never decremented, so I doubt that _DIS is ever evaluated.

If we did evaluate _DIS, it would act on an "interrupt link" device,
not on the PCI device itself.  I guess that could help, but only for
devices connected to such a link device.  For others, I guess we might
be able to accomplish something similar by updating local APIC and/or
IOAPIC config.  I don't think we do that today, at least not in the
pci_disable_device() path, but it might be something interesting to
explore.  There is also the INTx Disable bit, though it's obviously
only on new PCI devices.

> ... The two ways I can think of are to stop
> DMA by clearing Bus Master bit and turn off the interrupt, which have
> been shown to get kexec (and thus kdump) working on machines it didn't
> work on before.

I was just curious if you had actually verified that _DIS was being
evaluated and making a difference here, or if the Bus Master bit was
really the important part.

Bjorn
