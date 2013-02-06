Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab3BFGUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 01:20:05 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:43961 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3BFGUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 01:20:00 -0500
Date: Wed, 6 Feb 2013 01:19:55 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Rob Herring <robherring2@gmail.com>, Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 3/3] ARM: mm: use static_vm for managing static mapped
 areas
In-Reply-To: <20130206050527.GA8249@lge.com>
Message-ID: <alpine.LFD.2.02.1302060118100.6300@xanadu.home>
References: <1360024314-1895-1-git-send-email-iamjoonsoo.kim@lge.com> <1360024314-1895-4-git-send-email-iamjoonsoo.kim@lge.com> <alpine.LFD.2.02.1302042308220.6300@xanadu.home> <51114134.4070503@gmail.com> <alpine.LFD.2.02.1302051304530.6300@xanadu.home>
 <511159B3.8020000@gmail.com> <20130206020707.GB4325@lge.com> <20130206050527.GA8249@lge.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2013, Joonsoo Kim wrote:

> On Wed, Feb 06, 2013 at 11:07:07AM +0900, Joonsoo Kim wrote:
> > Hello, Rob.
> > 
> > On Tue, Feb 05, 2013 at 01:12:51PM -0600, Rob Herring wrote:
> > > On 02/05/2013 12:13 PM, Nicolas Pitre wrote:
> > > > On Tue, 5 Feb 2013, Rob Herring wrote:
> > > > 
> > > >> On 02/04/2013 10:44 PM, Nicolas Pitre wrote:
> > > >>> On Tue, 5 Feb 2013, Joonsoo Kim wrote:
> > > >>>
> > > >>>> A static mapped area is ARM-specific, so it is better not to use
> > > >>>> generic vmalloc data structure, that is, vmlist and vmlist_lock
> > > >>>> for managing static mapped area. And it causes some needless overhead and
> > > >>>> reducing this overhead is better idea.
> > > >>>>
> > > >>>> Now, we have newly introduced static_vm infrastructure.
> > > >>>> With it, we don't need to iterate all mapped areas. Instead, we just
> > > >>>> iterate static mapped areas. It helps to reduce an overhead of finding
> > > >>>> matched area. And architecture dependency on vmalloc layer is removed,
> > > >>>> so it will help to maintainability for vmalloc layer.
> > > >>>>
> > > >>>> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > > >>
> > > >> [snip]
> > > >>
> > > >>>> @@ -859,17 +864,12 @@ static void __init pci_reserve_io(void)
> > > >>>>  {
> > > >>>>  	struct vm_struct *vm;
> > > >>>>  	unsigned long addr;
> > > >>>> +	struct static_vm *svm;
> > > >>>>  
> > > >>>> -	/* we're still single threaded hence no lock needed here */
> > > >>>> -	for (vm = vmlist; vm; vm = vm->next) {
> > > >>>> -		if (!(vm->flags & VM_ARM_STATIC_MAPPING))
> > > >>>> -			continue;
> > > >>>> -		addr = (unsigned long)vm->addr;
> > > >>>> -		addr &= ~(SZ_2M - 1);
> > > >>>> -		if (addr == PCI_IO_VIRT_BASE)
> > > >>>> -			return;
> > > >>>> +	svm = find_static_vm_vaddr((void *)PCI_IO_VIRT_BASE);
> > > >>>> +	if (svm)
> > > >>>> +		return;
> > > >>>>
> > > >>>> -	}
> > > >>>>  
> > > >>>>  	vm_reserve_area_early(PCI_IO_VIRT_BASE, SZ_2M, pci_reserve_io);
> > > >>>>  }
> > > >>>
> > > >>> The replacement code is not equivalent.  I can't recall why the original 
> > > >>> is as it is, but it doesn't look right to me.  The 2MB round down 
> > > >>> certainly looks suspicious.
> > > >>
> > > >> The PCI mapping is at a fixed, aligned 2MB mapping. If we find any
> > > >> virtual address within that region already mapped, it is an error.
> > > > Ah, OK.  This wasn't clear looking at the code.
> > > >> We probably should have had a WARN here.
> > > > 
> > > > Indeed.
> > > > 
> > 
> > Okay.
> > I should fix it to find any mapping within PCI reserved region.
> 
> Ah...
> Above comment is my mistake.
> 
> If there is a region already mapped within PCI reserved region and
> it is not found by find_static_vm_vaddr(), vm_area_add_early() hit BUG_ON().
> So, to leave find_static_vm_vaddr() is safe.

Yes.  In conclusion, your patch was fine.  You may remove the redundant 
parents and send the whole set to Russell.


Nicolas
