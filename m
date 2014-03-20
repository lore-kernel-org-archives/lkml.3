Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbaCTBc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 21:32:56 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:38036 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbaCTBcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 21:32:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo5qsosqLXdkS2__d2J7sM4T2nBfO1ewKg1=kFri3mcdrQ@mail.gmail.com>
References: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com>
	<20140226193757.10125.81865.stgit@bhelgaas-glaptop.roam.corp.google.com>
	<CACVXFVOqBuCcQC6ku0abqstkgJWGe21ZztB-eTsyDwsvDvXNZw@mail.gmail.com>
	<CAErSpo4ngU60XQCD=DbFJbqNOMkOwwhHB1oau1mmr7rJQQ2+pg@mail.gmail.com>
	<CACVXFVMz+6DaSgT0EHeVfyBOsXfWDYnZQ0wy7pwcey5ahM6rUA@mail.gmail.com>
	<20140318002700.GA22356@google.com>
	<CACVXFVNbzjYa7dJpH+k-F02Cap7yBBi7TkngjVu_KthXw-WKJA@mail.gmail.com>
	<CACVXFVO2rR+H7X2Xv_d-U0NeikT4dR97ffQ7PuV7+i0fN=_k3w@mail.gmail.com>
	<CAErSpo5qsosqLXdkS2__d2J7sM4T2nBfO1ewKg1=kFri3mcdrQ@mail.gmail.com>
Date: Thu, 20 Mar 2014 09:32:52 +0800
Message-ID: <CACVXFVPq2nQ8jcn+v424roieO+v_asyfXcHUHv=uSOABYHJ4eg@mail.gmail.com>
Subject: Re: [PATCH 8/9] PCI: Ignore BAR contents when firmware left decoding disabled
From: Ming Lei <tom.leiming@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Pekka Enberg <penberg@kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 12:45 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Mar 18, 2014 at 10:52 PM, Ming Lei <tom.leiming@gmail.com> wrote:
>> Hi,
>>
>> Looks Sasha fixed the problem in lkvm tool[1].
>>
>> Sasha, looks we both saw the problem, but from technical
>> view, I am wondering if the fix is correct, because PCI spec.
>> requires that the IO/MMIO bits in COMMAND register should
>> be cleared after reset, maybe there are some potential problem
>> in lkvm pci emulation.
>
> I think I'm going to revert this patch ([2], "Ignore BAR contents when
> firmware left decoding disabled").  The main reason for that patch was
> to try for a consistent way of figuring out whether BARs are valid
> that we could use on all architectures, but I think we can do it in a
> better way.
>
> That said, this kvm change should not be necessary.  We *should* be
> able to take any PCI device and initialize it from power-on state
> without any dependencies on what the BIOS left in the BARs or the
> command register.  As far as I can tell, the PCI core actually worked
> fine in this case (we assigned valid addresses to the devices), but
> something else blew up.  If I revert that patch, it will cover up
> whatever this other bug is, but it would be much better to figure out
> what it is and fix is.
>
> You said earlier that "The memory allocation failure is caused by
> mistaken value read from pci address after the device is failed to
> enable."  Can you elaborate on that?  Are you saying that something

Sorry, that's my take for granted.

> tried to read from a region mapped by a BAR even though
> pci_enable_device() failed?  That would be a programming error, of
> course.  If you have any more details about exactly where this
> happened, that would help a lot in finding the problem.

When I check again, as you saw in the dmesg log after reverting, the
virtio device has been enabled successfully, looks no obvious PCI
failure, and the only problem is that the virtio driver reads zero queue
number from one region mapped by a BAR:

ioread16(vp_dev->ioaddr + VIRTIO_PCI_QUEUE_NUM)
         <- setup_vq(): drivers/virtio/virtio_pci.c

That causes the memory allocation failure.

Thanks,
-- 
Ming Lei
