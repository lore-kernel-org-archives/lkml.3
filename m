Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab3JYFNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 01:13:22 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:35236 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab3JYFNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 01:13:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo5yhg1EgJmmOtJeh0myd50tJuu6qVMdVnwR276WTxL8kg@mail.gmail.com>
References: <CAMxnaaUim-MCDpaTiLmBqN3wfxjn9V6XE_n4SMfuO=vqeT6rVA@mail.gmail.com>
	<CAErSpo4KU9VAC=SnKuYH3EPz8NuozixAhUQBKv+=Y=76wywdTg@mail.gmail.com>
	<20131015024452.GA31951@srcf.ucam.org>
	<20131016202123.GA17866@google.com>
	<CAMxnaaV1DhaxKo6h85Upa8sPQz2jSYSaW1OJ7+JtvR5F9sAYZw@mail.gmail.com>
	<CAErSpo4q0rcvkHX3_L2rcJrwT-Ofu4My8JXxtxH8gyULLxTDEw@mail.gmail.com>
	<CAE9FiQUMKSak4tWiyZ-N1_50M5ytUp-JAhb7GTG29Y1aRBPuSQ@mail.gmail.com>
	<CAErSpo5yhg1EgJmmOtJeh0myd50tJuu6qVMdVnwR276WTxL8kg@mail.gmail.com>
Date: Thu, 24 Oct 2013 22:13:18 -0700
X-Google-Sender-Auth: xd0kflVOzJjJkl3kZbPjBQBx73Q
Message-ID: <CAE9FiQUPgHtQ-p6R3MR+j=gKiQPcW5F2nqB=FwJdEovFLsuXjA@mail.gmail.com>
Subject: Re: [3.11.4] Thunderbolt/PCI unplug oops in pci_pme_list_scan
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
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

On Thu, Oct 24, 2013 at 8:33 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
>>>> Bisection points to 928bea964827d7824b548c1f8e06eccbbc4d0d7d .
>>>
>>> This is "PCI: Delay enabling bridges until they're needed" by Yinghai.
>>
>> that double disabling should be addressed by:
>>
>> https://lkml.org/lkml/2013/4/25/608
>>
>> [PATCH] PCI: Remove duplicate pci_disable_device for pcie port
>
> I'll look at that patch again.  I had some questions about it the
> first time, but perhaps it makes more sense after 928bea9648 has been
> applied.
>
> Andreas originally reported a GPF oops in pci_pme_list_scan().  I
> posted a refcounting patch, which made the problem go away, but I
> can't explain why, and I don't want to apply it without understanding
> that.  Decoding his oops shows this:
>
>   24: 0f 1f 00             nopl   (%rax)
>   27: 48 8b 50 10           mov    0x10(%rax),%rdx
>   2b:* 48 8b 52 38           mov    0x38(%rdx),%rdx <-- trapping instruction
>   2f: 48 85 d2             test   %rdx,%rdx
>
> %rax is the pci_dev pointer, so 0x10(%rax) is the dev->bus pointer,
> which we put in %rdx.  The oops says %rdx = 6b6b6b6b6b6b6b6b, which is
> POISON_FREE, so I think we loaded dev->bus out of a struct pci_dev
> that has already been freed.
>
> pci_pme_list_scan() holds pci_pme_list_mutex while it traverses
> pci_pme_list, and the pci_stop_and_remove_bus_device() path removes
> the pci_dev by calling pci_pme_active(), which also holds
> pci_pme_list_mutex, so I don't understand how pci_pme_list_scan() can
> see a pci_dev that has already been freed.
>
> If I understand Andreas correctly, 928bea9648 also fixes the crash,
> even without my refcounting change.  Can you explain why?

928bea will make the dev->enable_cnt increase wrongly, as we have
pci_enable_device for child
   pci_enable_bridge for parent
     pci_enable_bridge for grandparent
       pci_enable_device for grandparent
   pci_enable_device for parent
       pci_enable_brdige for grandparent
         pci_enable_device for grandparent.
...

in that case grandprent will be enabled two times, and will enable_cnt will have
extra increase.

so later pci_disable_device will not really call do_pci_disable_device
do the really work, as enable_cnt still big.

solution could be:
let pci_enable_bridge call __pci_enable_device.
and __pci_enable_device will not call pci_enable_bridge.

Thanks

Yinghai
