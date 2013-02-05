Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab3BEPf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:35:29 -0500
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:40841 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755624Ab3BEPfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:35:21 -0500
Message-ID: <1360078091.4485.32.camel@rhapsody>
Subject: Re: [PATCH v2 2/7] PCI: don't touch enable_cnt in
 pci_device_shutdown()
From: Khalid Aziz <khalid@gonehiking.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        e1000-devel@lists.sourceforge.net, linux-pci@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg@redhat.com>,
        khalid.aziz@oracle.com
Date: Tue, 05 Feb 2013 08:28:11 -0700
In-Reply-To: <CAErSpo7k96noiCtGYUFyuUQhE2GQA8ro5-9WC-JU_1HOWKUGvg@mail.gmail.com>
References: <20130204115246.5569.85829.stgit@zurg>
	 <20130204115557.5569.9748.stgit@zurg> <1360016458.4485.11.camel@rhapsody>
	 <CAErSpo7k96noiCtGYUFyuUQhE2GQA8ro5-9WC-JU_1HOWKUGvg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-04 at 16:13 -0700, Bjorn Helgaas wrote:
> On Mon, Feb 4, 2013 at 3:20 PM, Khalid Aziz <khalid@gonehiking.org> wrote:
> > On Mon, 2013-02-04 at 15:55 +0400, Konstantin Khlebnikov wrote:
> >> Matthew Garrett and Alan Cox said (see LKML link below) that clearing bus-master
> >> for all PCI devices may lead to unpredictable consequences, some devices ignores
> >> this bit and continues DMA, some of them hang after that or crash whole system.
> >> Probably we should leave here only warning and disable bus-mastering for each
> >> driver individually in ->shutdown() callback.
> >
> > Agreed that the right place for shutting down a PCI device properly and
> > clearing its Bus Master bit, is the driver shutdown routine, if only all
> > drivers supplied a shutdown routine. As it is today, there are too many
> > drivers that do not provide a shutdown routine, ata_piix, Marvell SATA
> > driver, ATI AGP driver just to name a few among a large number of them.
> > Yet kexec is expected to work inspite of these drivers especially since
> > kdump depends on it. So until all PCI drivers supply a shutdown routine,
> > this is just a band-aid to disable interrupt and Bus Master bit in
> > pci_device_shutdown(). Most drivers do seem to supply a suspend and
> > resume function and it was discussed many years ago if it is feasible to
> > use the suspend() routine for drivers to shut devices down cleanly.
> > Maybe it is time to revisit that discussion.
> 
> This patch as posted doesn't do anything with IRQs.  It only clears
> PCI_COMMAND_MASTER.
> 
> I'm open to considering something with IRQs, but I don't understand
> exactly what we should do.  In your response to the previous version
> (https://lkml.org/lkml/2013/1/28/720) you suggested this:
> 
>   pci_clear_master(pci_dev);
>   pcibios_disable_device(pci_dev);
> 
> Did you figure out specifically why pcibios_disable_device() helps?
> Using pcibios_disable_device() doesn't seem like the ideal solution
> because on most architectures, it is an empty function with no obvious
> connection to IRQs.  On x86 with ACPI, it cleans up some ACPI PCI IRQ
> stuff, but as far as I can tell, it doesn't actually touch the PCI
> device itself or even the IOAPIC to which it's connected, so I'm not
> sure how this would help kexec.
> 
> Bjorn

Hi Bjorn,

My reading of the code was that pcibios_disable_device() does clear the
interrupt on x86 and ia64. I am not deeply familiar with the ACPI code
and I might be interpreting it incorrectly, so please do correct me if I
am reading it incorrectly. Here is the code sequence I see:

pcibios_disable_device() ->
   pcibios_disable_irq() ->
       acpi_pci_irq_disable() -> 
           acpi_pci_link_free_irq() ->
              acpi_evaluate_object(link->device->handle, "_DIS", NULL,
NULL);

My understanding is the evaluation of ACPI _DIS method will disable the
interrupt from the device. Does that sound reasonable?

The problem this code attempts to solve is I/O devices continuing to be
active as we start to boot a kexec'd kernel. That activity can come from
DMA (has been seen with NICs for sure, but can happen from a SATA/IDE
controller as well when a pending read completes). When a DMA activity
overwrites a section of memory area in use by the new kexec'd kernel, it
takes lot of work to narrow that memory corruption down. The right way
to quiesce I/O devices is to call shutdown() function for every active
driver, which pci_device_shutdown() does today. If every driver provided
a proper shutdown() function, we would be done. Since that is not the
case, we need to stop potentially active devices from interfering with
kexec'd kernel. Too many drivers rely upon firmware reinitializing the
device when system is shut down. The two ways I can think of are to stop
DMA by clearing Bus Master bit and turn off the interrupt, which have
been shown to get kexec (and thus kdump) working on machines it didn't
work on before. 

This is a non-trivial problem to solve and I am very open to better
ideas.

--
Khalid

