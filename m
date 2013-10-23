Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab3JWXx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 19:53:58 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:53640 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab3JWXx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 19:53:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAMxnaaV1DhaxKo6h85Upa8sPQz2jSYSaW1OJ7+JtvR5F9sAYZw@mail.gmail.com>
References: <CAMxnaaUim-MCDpaTiLmBqN3wfxjn9V6XE_n4SMfuO=vqeT6rVA@mail.gmail.com>
 <CAErSpo4KU9VAC=SnKuYH3EPz8NuozixAhUQBKv+=Y=76wywdTg@mail.gmail.com>
 <20131015024452.GA31951@srcf.ucam.org> <20131016202123.GA17866@google.com> <CAMxnaaV1DhaxKo6h85Upa8sPQz2jSYSaW1OJ7+JtvR5F9sAYZw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 23 Oct 2013 17:53:34 -0600
Message-ID: <CAErSpo7x7ym=Lp=UmsQ=JM7QaALoouShnv366EthRTwr=eAMYg@mail.gmail.com>
Subject: Re: [3.11.4] Thunderbolt/PCI unplug oops in pci_pme_list_scan
To: Andreas Noever <andreas.noever@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 7:59 AM, Andreas Noever
<andreas.noever@gmail.com> wrote:
> On Wed, Oct 16, 2013 at 10:21 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Tue, Oct 15, 2013 at 03:44:52AM +0100, Matthew Garrett wrote:
>>> On Mon, Oct 14, 2013 at 05:50:38PM -0600, Bjorn Helgaas wrote:
>>> > [+cc Rafael, Mika, Kirill, linux-pci]
>>> >
>>> > On Mon, Oct 14, 2013 at 4:47 PM, Andreas Noever
>>> > <andreas.noever@gmail.com> wrote:
>>> > > When I unplug the Thunderbolt ethernet adapter on my MacBookPro Linux
>>> > > crashes a few seconds later. Using
>>> > > echo 1 > /sys/bus/pci/devices/0000:08:00.0/remove
>>> > > to remove a bridge two levels above the device triggers the fault immediately:
>>> >
>>> > There have been significant changes in acpiphp related to Thunderbolt
>>> > since v3.11.
>>>
>>> Apple don't expose Thunderbolt via ACPI, so it appears as native PCIe.
>>> I'd be surprised if acpiphp makes a difference here.
>>
>> Yeah, you're right; I wasn't paying attention.
>>
>> We save a pci_dev pointer in the pci_pme_list, which of course has a
>> longer lifetime than the pci_dev itself, but we don't acquire a reference
>> on it, so I suspect the pci_dev got released before we got around to
>> doing the pci_pme_list_scan().
>>
>> Andreas, can you try the patch below?  It's against v3.12-rc2, but it
>> should apply to v3.11, too.
>
> I have tested your patch against 3.11 where it solves the problem. Thanks!

Hi Andreas, sorry for the delay here.  I'm still trying to understand
exactly why my patch fixes the problem, since I don't see a relevant
refcounting change between v3.11 and v3.12-rc5.  And I don't actually
see the hole yet from inspection.  It seems like we should be safe
even without my patch.

But maybe it's a case of releasing the pci_bus before releasing a
pci_dev on the bus.  I thought we recently fixed a hole there, but
maybe not.  I'll look more carefully at that path.

Can I trouble you to collect a complete dmesg log from v3.11 without
my patch?  Maybe if I stare long enough at that and the lspci you
supplied, I can figure out what's going on.  If you were really
gung-ho, you could add instrumentation to print out the pci_dev and
pci_bus pointers as we enumerate them.  My guess is that we'd see one
of those pointers in the GPF register dump.

Bjorn
