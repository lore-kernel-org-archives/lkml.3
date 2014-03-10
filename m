Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbaCJUoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:44:14 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:63740 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbaCJUoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:44:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAMxnaaVfpJCW7e-b80y4wmVWcRDK5t7qY+pNn71CsLPRN2ojnA@mail.gmail.com>
References: <CAMxnaaXd9-VbxSYa9q1YVT+fwfDFYKGG2Hq-1jkc-awLX-HwtQ@mail.gmail.com>
 <CAErSpo5fkaFNq_qTZ+gTDMV554f4diOXQ7_4bsHqj06iAGTpHg@mail.gmail.com>
 <CAE9FiQVNFqTw+92qy8zcwG1haiSZzU+KE3oh4YnjNc_aE6KUnA@mail.gmail.com>
 <20140308010456.GA30660@google.com> <CAMxnaaVfpJCW7e-b80y4wmVWcRDK5t7qY+pNn71CsLPRN2ojnA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 10 Mar 2014 14:43:44 -0600
Message-ID: <CAErSpo4MQsAer7FM0kU5mMOGRok0oFMWX1FqFijmswutjyNoRg@mail.gmail.com>
Subject: Re: [Bug] PCI: Enable INTx if BIOS left them disabled - triggers
 during rescan
To: Andreas Noever <andreas.noever@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rajat Jain <rajatxjain@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 8, 2014 at 2:55 AM, Andreas Noever <andreas.noever@gmail.com> wrote:
> On Sat, Mar 8, 2014 at 2:04 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:

>> If we did that, INTX_DISABLE would be cleared by the first
>> pci_enable_device() and pci_reenable_device() wouldn't do anything,
>> leaving it cleared.  The resulting state (cleared) would be the same,
>> but the transitions would be gone, and maybe those are important.
> Just a quick note: With pci_intx_for_msi removed no hotplug events are
> ever delivered. Everything else still works though. So it is either a
> problem specific to Thunderbolt bridges or maybe it just affects
> hotplug (and PME?) interrupts.

Interesting.  This is on a MacBook, isn't it?  If you have Mac OS on
it, is there a way you can do the equivalent of lspci on it?  I'm
curious about whether it sets INTx_DISABLE when it enables MSI.

I still haven't found any indication that INTx_DISABLE is intended or
required as part of enabling MSI/MSI-X, so I'm quite dubious about
Linux using it that way.  The references I've seen, e.g.,
http://www.pcisig.com/reflector/msg05301.html,
http://www.pcisig.com/reflector/msg05302.html, say the purpose is to
better manage shared IRQs.

> I also attempted booting with pcie_hp=nomsi and now everything works.
> Interestingly pciehp now also  gets an interrupt from 09 (event though
> that card has just been removed). I suspect this is just pciehp not
> noticing that it itself is gone.
> pciehp 0000:06:03.0:pcie24: Card not present on Slot(3-1)
> pciehp 0000:09:00.0:pcie24: Latch open on Slot(9)
> pciehp 0000:09:00.0:pcie24: Button pressed on Slot(9)
> pciehp 0000:09:00.0:pcie24: Card present on Slot(9)
> pciehp 0000:09:00.0:pcie24: Power fault on slot 9
> pciehp 0000:09:00.0:pcie24: Power fault bit 0 set
> pciehp 0000:09:00.0:pcie24: PCI slot #9 - powering on due to button press.
> pciehp 0000:09:00.0:pcie24: unloading service driver pciehp
> pciehp 0000:09:00.0:pcie24: Link Training Error occurs
> pciehp 0000:09:00.0:pcie24: Failed to check link status

This is a good clue.  I think the portdrv registration thing is a bit
more confusing than necessary.  I'll poke around in there a bit.

Unfortunately, I don't think this is going to lead to a quick easy fix
suitable for -rc7, so we'll probably have to do something simple like
skipping the INTx enable if MSI is already enabled.

Bjorn
