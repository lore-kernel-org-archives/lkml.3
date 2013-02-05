Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab3BESNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 13:13:13 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:45804 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab3BESNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 13:13:10 -0500
Date: Tue, 5 Feb 2013 13:13:06 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Rob Herring <robherring2@gmail.com>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>, js1304@gmail.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 3/3] ARM: mm: use static_vm for managing static mapped
 areas
In-Reply-To: <51114134.4070503@gmail.com>
Message-ID: <alpine.LFD.2.02.1302051304530.6300@xanadu.home>
References: <1360024314-1895-1-git-send-email-iamjoonsoo.kim@lge.com> <1360024314-1895-4-git-send-email-iamjoonsoo.kim@lge.com> <alpine.LFD.2.02.1302042308220.6300@xanadu.home> <51114134.4070503@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013, Rob Herring wrote:

> On 02/04/2013 10:44 PM, Nicolas Pitre wrote:
> > On Tue, 5 Feb 2013, Joonsoo Kim wrote:
> > 
> >> A static mapped area is ARM-specific, so it is better not to use
> >> generic vmalloc data structure, that is, vmlist and vmlist_lock
> >> for managing static mapped area. And it causes some needless overhead and
> >> reducing this overhead is better idea.
> >>
> >> Now, we have newly introduced static_vm infrastructure.
> >> With it, we don't need to iterate all mapped areas. Instead, we just
> >> iterate static mapped areas. It helps to reduce an overhead of finding
> >> matched area. And architecture dependency on vmalloc layer is removed,
> >> so it will help to maintainability for vmalloc layer.
> >>
> >> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> [snip]
> 
> >> @@ -859,17 +864,12 @@ static void __init pci_reserve_io(void)
> >>  {
> >>  	struct vm_struct *vm;
> >>  	unsigned long addr;
> >> +	struct static_vm *svm;
> >>  
> >> -	/* we're still single threaded hence no lock needed here */
> >> -	for (vm = vmlist; vm; vm = vm->next) {
> >> -		if (!(vm->flags & VM_ARM_STATIC_MAPPING))
> >> -			continue;
> >> -		addr = (unsigned long)vm->addr;
> >> -		addr &= ~(SZ_2M - 1);
> >> -		if (addr == PCI_IO_VIRT_BASE)
> >> -			return;
> >> +	svm = find_static_vm_vaddr((void *)PCI_IO_VIRT_BASE);
> >> +	if (svm)
> >> +		return;
> >>
> >> -	}
> >>  
> >>  	vm_reserve_area_early(PCI_IO_VIRT_BASE, SZ_2M, pci_reserve_io);
> >>  }
> > 
> > The replacement code is not equivalent.  I can't recall why the original 
> > is as it is, but it doesn't look right to me.  The 2MB round down 
> > certainly looks suspicious.
> 
> The PCI mapping is at a fixed, aligned 2MB mapping. If we find any
> virtual address within that region already mapped, it is an error.

Ah, OK.  This wasn't clear looking at the code.

> We probably should have had a WARN here.

Indeed.

> > 
> > The replacement code should be better.  However I'd like you to get an 
> > ACK from Rob Herring as well for this patch.
> 
> It doesn't appear to me the above case is handled. The virt addr is
> checked whether it is within an existing mapping, but not whether the
> new mapping would overlap an existing mapping. It would be good to check
> for this generically rather than specifically for the PCI i/o mapping.

Agreed.  However that is checked already in vm_area_add_early().  
Therefore the overlap test here is redundant.


Nicolas
