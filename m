Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab3BDXNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 18:13:55 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:59537 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab3BDXNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 18:13:51 -0500
MIME-Version: 1.0
In-Reply-To: <1360016458.4485.11.camel@rhapsody>
References: <20130204115246.5569.85829.stgit@zurg> <20130204115557.5569.9748.stgit@zurg>
 <1360016458.4485.11.camel@rhapsody>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 4 Feb 2013 16:13:30 -0700
Message-ID: <CAErSpo7k96noiCtGYUFyuUQhE2GQA8ro5-9WC-JU_1HOWKUGvg@mail.gmail.com>
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

On Mon, Feb 4, 2013 at 3:20 PM, Khalid Aziz <khalid@gonehiking.org> wrote:
> On Mon, 2013-02-04 at 15:55 +0400, Konstantin Khlebnikov wrote:
>> Matthew Garrett and Alan Cox said (see LKML link below) that clearing bus-master
>> for all PCI devices may lead to unpredictable consequences, some devices ignores
>> this bit and continues DMA, some of them hang after that or crash whole system.
>> Probably we should leave here only warning and disable bus-mastering for each
>> driver individually in ->shutdown() callback.
>
> Agreed that the right place for shutting down a PCI device properly and
> clearing its Bus Master bit, is the driver shutdown routine, if only all
> drivers supplied a shutdown routine. As it is today, there are too many
> drivers that do not provide a shutdown routine, ata_piix, Marvell SATA
> driver, ATI AGP driver just to name a few among a large number of them.
> Yet kexec is expected to work inspite of these drivers especially since
> kdump depends on it. So until all PCI drivers supply a shutdown routine,
> this is just a band-aid to disable interrupt and Bus Master bit in
> pci_device_shutdown(). Most drivers do seem to supply a suspend and
> resume function and it was discussed many years ago if it is feasible to
> use the suspend() routine for drivers to shut devices down cleanly.
> Maybe it is time to revisit that discussion.

This patch as posted doesn't do anything with IRQs.  It only clears
PCI_COMMAND_MASTER.

I'm open to considering something with IRQs, but I don't understand
exactly what we should do.  In your response to the previous version
(https://lkml.org/lkml/2013/1/28/720) you suggested this:

  pci_clear_master(pci_dev);
  pcibios_disable_device(pci_dev);

Did you figure out specifically why pcibios_disable_device() helps?
Using pcibios_disable_device() doesn't seem like the ideal solution
because on most architectures, it is an empty function with no obvious
connection to IRQs.  On x86 with ACPI, it cleans up some ACPI PCI IRQ
stuff, but as far as I can tell, it doesn't actually touch the PCI
device itself or even the IOAPIC to which it's connected, so I'm not
sure how this would help kexec.

Bjorn
