Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369AbaCUUHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 16:07:47 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:36441 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaCUUHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 16:07:42 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVPq2nQ8jcn+v424roieO+v_asyfXcHUHv=uSOABYHJ4eg@mail.gmail.com>
References: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140226193757.10125.81865.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <CACVXFVOqBuCcQC6ku0abqstkgJWGe21ZztB-eTsyDwsvDvXNZw@mail.gmail.com>
 <CAErSpo4ngU60XQCD=DbFJbqNOMkOwwhHB1oau1mmr7rJQQ2+pg@mail.gmail.com>
 <CACVXFVMz+6DaSgT0EHeVfyBOsXfWDYnZQ0wy7pwcey5ahM6rUA@mail.gmail.com>
 <20140318002700.GA22356@google.com> <CACVXFVNbzjYa7dJpH+k-F02Cap7yBBi7TkngjVu_KthXw-WKJA@mail.gmail.com>
 <CACVXFVO2rR+H7X2Xv_d-U0NeikT4dR97ffQ7PuV7+i0fN=_k3w@mail.gmail.com>
 <CAErSpo5qsosqLXdkS2__d2J7sM4T2nBfO1ewKg1=kFri3mcdrQ@mail.gmail.com> <CACVXFVPq2nQ8jcn+v424roieO+v_asyfXcHUHv=uSOABYHJ4eg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 21 Mar 2014 14:07:22 -0600
Message-ID: <CAErSpo6zjOA43yrwk-4F8PDGTS-8G4piDBq+z-zv+L6_KkKFHQ@mail.gmail.com>
Subject: Re: [PATCH 8/9] PCI: Ignore BAR contents when firmware left decoding disabled
To: Ming Lei <tom.leiming@gmail.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Pekka Enberg <penberg@kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc kvm list]

On Wed, Mar 19, 2014 at 7:32 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> On Thu, Mar 20, 2014 at 12:45 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Tue, Mar 18, 2014 at 10:52 PM, Ming Lei <tom.leiming@gmail.com> wrote:
>>> Hi,
>>>
>>> Looks Sasha fixed the problem in lkvm tool[1].
>>>
>>> Sasha, looks we both saw the problem, but from technical
>>> view, I am wondering if the fix is correct, because PCI spec.
>>> requires that the IO/MMIO bits in COMMAND register should
>>> be cleared after reset, maybe there are some potential problem
>>> in lkvm pci emulation.
>>
>> I think I'm going to revert this patch ([2], "Ignore BAR contents when
>> firmware left decoding disabled").  The main reason for that patch was
>> to try for a consistent way of figuring out whether BARs are valid
>> that we could use on all architectures, but I think we can do it in a
>> better way.
>>
>> That said, this kvm change should not be necessary.  We *should* be
>> able to take any PCI device and initialize it from power-on state
>> without any dependencies on what the BIOS left in the BARs or the
>> command register.  As far as I can tell, the PCI core actually worked
>> fine in this case (we assigned valid addresses to the devices), but
>> something else blew up.  If I revert that patch, it will cover up
>> whatever this other bug is, but it would be much better to figure out
>> what it is and fix is.

I think I figured out what the problem is.  In virtio_pci__init(), we
allocate some address space with pci_get_io_space_block(), save its
address in vpci->mmio_addr, and hook that address space up to
virtio_pci__io_mmio_callback with kvm__register_mmio().

But when we update the BAR value in pci__config_wr(), the address
space mapping is never updated.  I think this means that virtio-pci
can't tolerate its devices being moved by the OS.

In my opinion, this is a bug in linux-kvm.  We've managed to avoid
triggering this bug by preventing Linux from moving the BAR (either by
me reverting my patch, or by Sasha's linux-kvm change [1]).  But it's
not very robust to assume that the OS will never change the BAR, so
it's quite possible that you'll trip over this again in the future.

Bjorn

[1] 6478ce1416aa kvm tools: mark our PCI card as PIO and MMIO able
