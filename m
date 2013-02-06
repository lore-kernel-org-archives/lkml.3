Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab3BFAVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 19:21:18 -0500
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:60825
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034Ab3BFAVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 19:21:17 -0500
Message-ID: <1360110073.4485.40.camel@rhapsody>
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
Date: Tue, 05 Feb 2013 17:21:13 -0700
In-Reply-To: <CAErSpo7sYCmfd0X7PBfYS_ZK5sijxS3mpmhkrQ6UqO_xDry69Q@mail.gmail.com>
References: <20130204115246.5569.85829.stgit@zurg>
	 <20130204115557.5569.9748.stgit@zurg> <1360016458.4485.11.camel@rhapsody>
	 <CAErSpo7k96noiCtGYUFyuUQhE2GQA8ro5-9WC-JU_1HOWKUGvg@mail.gmail.com>
	 <1360078091.4485.32.camel@rhapsody>
	 <CAErSpo7sYCmfd0X7PBfYS_ZK5sijxS3mpmhkrQ6UqO_xDry69Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-05 at 12:22 -0700, Bjorn Helgaas wrote:
> On Tue, Feb 5, 2013 at 8:28 AM, Khalid Aziz <khalid@gonehiking.org> wrote:
> > On Mon, 2013-02-04 at 16:13 -0700, Bjorn Helgaas wrote:
> >> Did you figure out specifically why pcibios_disable_device() helps?
> >> Using pcibios_disable_device() doesn't seem like the ideal solution
> >> because on most architectures, it is an empty function with no obvious
> >> connection to IRQs.  On x86 with ACPI, it cleans up some ACPI PCI IRQ
> >> stuff, but as far as I can tell, it doesn't actually touch the PCI
> >> device itself or even the IOAPIC to which it's connected, so I'm not
> >> sure how this would help kexec.
> >
> > My reading of the code was that pcibios_disable_device() does clear the
> > interrupt on x86 and ia64. I am not deeply familiar with the ACPI code
> > and I might be interpreting it incorrectly, so please do correct me if I
> > am reading it incorrectly. Here is the code sequence I see:
> >
> > pcibios_disable_device() ->
> >    pcibios_disable_irq() ->
> >        acpi_pci_irq_disable() ->
> >            acpi_pci_link_free_irq() ->
> >               acpi_evaluate_object(link->device->handle, "_DIS", NULL,
> > NULL);
> >
> > My understanding is the evaluation of ACPI _DIS method will disable the
> > interrupt from the device. Does that sound reasonable?
> 
> I see the code you're looking at in acpi_pci_link_free_irq(), but we
> only evaluate _DIS if link->refcnt == 0, and I don't think refcnt is
> ever zero at that point.
> 
> refcnt starts out at zero in acpi_pci_link_add() (called when we find
> PNP0C0F devices), and it's incremented in acpi_pci_link_allocate_irq()
> (called in the pci_enable_device() path), but as far as I can tell,
> it's never decremented, so I doubt that _DIS is ever evaluated.

Ah, that is interesting. I was assuming as we disable PCI devices, the
refcnt would have been decremented and if no one was using the IRQ, we
would evaluate _DIS method and disable the interrupt link.

> 
> If we did evaluate _DIS, it would act on an "interrupt link" device,
> not on the PCI device itself.  

Right, it should be the shutdown() routine for the device driver that
disables interrupt on the device itself. We want to turn interrupt off
one level higher in pci_device_shutdown().

> I guess that could help, but only for
> devices connected to such a link device.  For others, I guess we might
> be able to accomplish something similar by updating local APIC and/or
> IOAPIC config.  I don't think we do that today, at least not in the
> pci_disable_device() path, but it might be something interesting to
> explore.  There is also the INTx Disable bit, though it's obviously
> only on new PCI devices.

Turning interrupt of at local APIC or IOAPIC level sounds like more
reliable thing to do.

> 
> > ... The two ways I can think of are to stop
> > DMA by clearing Bus Master bit and turn off the interrupt, which have
> > been shown to get kexec (and thus kdump) working on machines it didn't
> > work on before.
> 
> I was just curious if you had actually verified that _DIS was being
> evaluated and making a difference here, or if the Bus Master bit was
> really the important part.
> 
> Bjorn

I have been able to reproduce the kexec problem caused by active PCI
devices only in limited cases and in those cases it was really the Bus
Master bit that was important. Keeping interrupts from errant devices
from reaching the kernel until newly kexc'd kernel is initialized is
additional safety measure.

--
Khalid

