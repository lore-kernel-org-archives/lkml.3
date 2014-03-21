Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaCUUlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 16:41:15 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:52643 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaCUUlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 16:41:13 -0400
MIME-Version: 1.0
In-Reply-To: <532CA02C.40505@oracle.com>
References: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140226193757.10125.81865.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <CACVXFVOqBuCcQC6ku0abqstkgJWGe21ZztB-eTsyDwsvDvXNZw@mail.gmail.com>
 <CAErSpo4ngU60XQCD=DbFJbqNOMkOwwhHB1oau1mmr7rJQQ2+pg@mail.gmail.com>
 <CACVXFVMz+6DaSgT0EHeVfyBOsXfWDYnZQ0wy7pwcey5ahM6rUA@mail.gmail.com>
 <20140318002700.GA22356@google.com> <CACVXFVNbzjYa7dJpH+k-F02Cap7yBBi7TkngjVu_KthXw-WKJA@mail.gmail.com>
 <CACVXFVO2rR+H7X2Xv_d-U0NeikT4dR97ffQ7PuV7+i0fN=_k3w@mail.gmail.com>
 <CAErSpo5qsosqLXdkS2__d2J7sM4T2nBfO1ewKg1=kFri3mcdrQ@mail.gmail.com>
 <CACVXFVPq2nQ8jcn+v424roieO+v_asyfXcHUHv=uSOABYHJ4eg@mail.gmail.com>
 <CAErSpo6zjOA43yrwk-4F8PDGTS-8G4piDBq+z-zv+L6_KkKFHQ@mail.gmail.com> <532CA02C.40505@oracle.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 21 Mar 2014 14:40:52 -0600
Message-ID: <CAErSpo7bpGX1RESwaLY4g4cECXvTKCQ9YjNOPtuEgbfbFwHfbg@mail.gmail.com>
Subject: Re: [PATCH 8/9] PCI: Ignore BAR contents when firmware left decoding disabled
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ming Lei <tom.leiming@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Pekka Enberg <penberg@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 2:25 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> On 03/21/2014 04:07 PM, Bjorn Helgaas wrote:
>>
>> I think I figured out what the problem is.  In virtio_pci__init(), we
>> allocate some address space with pci_get_io_space_block(), save its
>> address in vpci->mmio_addr, and hook that address space up to
>> virtio_pci__io_mmio_callback with kvm__register_mmio().
>>
>> But when we update the BAR value in pci__config_wr(), the address
>> space mapping is never updated.  I think this means that virtio-pci
>> can't tolerate its devices being moved by the OS.
>>
>> In my opinion, this is a bug in linux-kvm.  We've managed to avoid
>> triggering this bug by preventing Linux from moving the BAR (either by
>> me reverting my patch, or by Sasha's linux-kvm change [1]).  But it's
>> not very robust to assume that the OS will never change the BAR, so
>> it's quite possible that you'll trip over this again in the future.
>
>
> The purpose of KVM tool is to implement as much as possible of the KVM
> interface and the virtio spec so that we'll have a good development/testing
> environment with a very simple to understand codebase.
>
> The issue you've mentioned is the "evil" side of the KVM tool. It never
> tried (or claimed) to implement anything close to legacy hardware
> interfaces. This means, for example, that it doesn't run any BIOS, there's
> very lacking APIC support and the kernel is just injected into the virtual
> RAM and gets run from there.
>
> It also means that we went into the PCI spec deep enough to get the code
> to work with the kernel. The only reason we implemented MSI interrupts
> for example is because they provide improved performance with KVM, not
> because we were trying to get a complete implementation of the PCI spec.
>
> So yes, the PCI implementation in the KVM tool is lacking and what we
> have there might be broken by making the kernel conform more closely
> to the spec, but we are always happy to adapt and improve our code to
> work with any changes in the kernel.
>
> To sum it up, If you'll end up adding a change to the kernel that is
> valid according to the spec but breaks the KVM tool we'll just go ahead
> and fix the tool. You really don't need to worry about breaking it.

That makes sense, and I'm glad I had a chance to get acquainted with
the KVM tool.  If I get another problem report related to it, I'll try
to remember that I don't need to worry about breaking it :)

Bjorn
