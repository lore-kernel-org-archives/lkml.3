Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab3JYDeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 23:34:13 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:33894 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab3JYDeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 23:34:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUMKSak4tWiyZ-N1_50M5ytUp-JAhb7GTG29Y1aRBPuSQ@mail.gmail.com>
References: <CAMxnaaUim-MCDpaTiLmBqN3wfxjn9V6XE_n4SMfuO=vqeT6rVA@mail.gmail.com>
 <CAErSpo4KU9VAC=SnKuYH3EPz8NuozixAhUQBKv+=Y=76wywdTg@mail.gmail.com>
 <20131015024452.GA31951@srcf.ucam.org> <20131016202123.GA17866@google.com>
 <CAMxnaaV1DhaxKo6h85Upa8sPQz2jSYSaW1OJ7+JtvR5F9sAYZw@mail.gmail.com>
 <CAErSpo4q0rcvkHX3_L2rcJrwT-Ofu4My8JXxtxH8gyULLxTDEw@mail.gmail.com> <CAE9FiQUMKSak4tWiyZ-N1_50M5ytUp-JAhb7GTG29Y1aRBPuSQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 24 Oct 2013 21:33:50 -0600
Message-ID: <CAErSpo5yhg1EgJmmOtJeh0myd50tJuu6qVMdVnwR276WTxL8kg@mail.gmail.com>
Subject: Re: [3.11.4] Thunderbolt/PCI unplug oops in pci_pme_list_scan
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andreas Noever <andreas.noever@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 11:53 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, Oct 22, 2013 at 8:32 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Thu, Oct 17, 2013 at 7:59 AM, Andreas Noever <andreas.noever@gmail.com> wrote:
>>> On Wed, Oct 16, 2013 at 10:21 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>>> On Tue, Oct 15, 2013 at 03:44:52AM +0100, Matthew Garrett wrote:
>>>>> On Mon, Oct 14, 2013 at 05:50:38PM -0600, Bjorn Helgaas wrote:
>>>>> > On Mon, Oct 14, 2013 at 4:47 PM, Andreas Noever <andreas.noever@gmail.com> wrote:
>>>>> > > When I unplug the Thunderbolt ethernet adapter on my MacBookPro Linux
>>>>> > > crashes a few seconds later. Using
>>>>> > > echo 1 > /sys/bus/pci/devices/0000:08:00.0/remove
>>>>> > > to remove a bridge two levels above the device triggers the fault immediately:

>>>> We save a pci_dev pointer in the pci_pme_list, which of course has a
>>>> longer lifetime than the pci_dev itself, but we don't acquire a reference
>>>> on it, so I suspect the pci_dev got released before we got around to
>>>> doing the pci_pme_list_scan().
>>>>
>>>> Andreas, can you try the patch below?  It's against v3.12-rc2, but it
>>>> should apply to v3.11, too.
>>>
>>> I have tested your patch against 3.11 where it solves the problem. Thanks!
>>>
>>> Unfortunately I could not reproduce the problem in 3.12-rc5. I only
>>> get the following warning (and no crash):
>>>
>>> tg3 0000:0a:00.0: PME# disabled
>>> pcieport 0000:09:00.0: PME# disabled
>>> pciehp 0000:09:00.0:pcie24: unloading service driver pciehp
>>> pci_bus 0000:0a: dev 00, dec refcount to 0
>>> pci_bus 0000:0a: dev 00, released physical slot 9
>>> ------------[ cut here ]------------
>>> WARNING: CPU: 0 PID: 122 at drivers/pci/pci.c:1430
>>> pci_disable_device+0x84/0x90()
>>> Device pcieport
>>> disabling already-disabled device
>>> ...

>>> Bisection points to 928bea964827d7824b548c1f8e06eccbbc4d0d7d .
>>
>> This is "PCI: Delay enabling bridges until they're needed" by Yinghai.
>
> that double disabling should be addressed by:
>
> https://lkml.org/lkml/2013/4/25/608
>
> [PATCH] PCI: Remove duplicate pci_disable_device for pcie port

I'll look at that patch again.  I had some questions about it the
first time, but perhaps it makes more sense after 928bea9648 has been
applied.

Andreas originally reported a GPF oops in pci_pme_list_scan().  I
posted a refcounting patch, which made the problem go away, but I
can't explain why, and I don't want to apply it without understanding
that.  Decoding his oops shows this:

  24: 0f 1f 00             nopl   (%rax)
  27: 48 8b 50 10           mov    0x10(%rax),%rdx
  2b:* 48 8b 52 38           mov    0x38(%rdx),%rdx <-- trapping instruction
  2f: 48 85 d2             test   %rdx,%rdx

%rax is the pci_dev pointer, so 0x10(%rax) is the dev->bus pointer,
which we put in %rdx.  The oops says %rdx = 6b6b6b6b6b6b6b6b, which is
POISON_FREE, so I think we loaded dev->bus out of a struct pci_dev
that has already been freed.

pci_pme_list_scan() holds pci_pme_list_mutex while it traverses
pci_pme_list, and the pci_stop_and_remove_bus_device() path removes
the pci_dev by calling pci_pme_active(), which also holds
pci_pme_list_mutex, so I don't understand how pci_pme_list_scan() can
see a pci_dev that has already been freed.

If I understand Andreas correctly, 928bea9648 also fixes the crash,
even without my refcounting change.  Can you explain why?

Bjorn
