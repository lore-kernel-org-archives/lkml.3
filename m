Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab3BPNvT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 08:51:19 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:65342 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab3BPNvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 08:51:18 -0500
Date: Sat, 16 Feb 2013 08:51:14 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-arm-kernel@lists.infradead.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Russell King <linux@arm.linux.org.uk>, js1304@gmail.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v6 3/3] ARM: mm: use static_vm for managing static mapped
 areas
In-Reply-To: <201302161249.08597.arnd@arndb.de>
Message-ID: <alpine.LFD.2.03.1302160850450.6419@syhkavp.arg>
References: <1360142010-10598-1-git-send-email-iamjoonsoo.kim@lge.com> <1360142010-10598-4-git-send-email-iamjoonsoo.kim@lge.com> <201302161249.08597.arnd@arndb.de>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2013, Arnd Bergmann wrote:

> On Wednesday 06 February 2013, Joonsoo Kim wrote:
> > @@ -859,17 +864,12 @@ static void __init pci_reserve_io(void)
> >  {
> >  	struct vm_struct *vm;
> >  	unsigned long addr;
> > +	struct static_vm *svm;
> >  
> > -	/* we're still single threaded hence no lock needed here */
> > -	for (vm = vmlist; vm; vm = vm->next) {
> > -		if (!(vm->flags & VM_ARM_STATIC_MAPPING))
> > -			continue;
> > -		addr = (unsigned long)vm->addr;
> > -		addr &= ~(SZ_2M - 1);
> > -		if (addr == PCI_IO_VIRT_BASE)
> > -			return;
> > +	svm = find_static_vm_vaddr((void *)PCI_IO_VIRT_BASE);
> > +	if (svm)
> > +		return;
> >  
> > -	}
> 
> This is causing build warnings in a bunch of configurations now,
> see patch below.
> 
> 	Arnd
> 
> 8<-----
> ARM: mm: remove unused variables in pci_reserve_io
> 
> Patch "ARM: 7646/1: mm: use static_vm for managing static mapped areas"
> removed code from pci_reserve_io but left variable declarations
> in place that are now unused, as gcc correctly warns.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Nicolas Pitre <nico@linaro.org>


> 
> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
> index c6fe15a..c6d45c8 100644
> --- a/arch/arm/mm/mmu.c
> +++ b/arch/arm/mm/mmu.c
> @@ -901,8 +901,6 @@ static void __init fill_pmd_gaps(void)
>  #if defined(CONFIG_PCI) && !defined(CONFIG_NEED_MACH_IO_H)
>  static void __init pci_reserve_io(void)
>  {
> -	struct vm_struct *vm;
> -	unsigned long addr;
>  	struct static_vm *svm;
>  
>  	svm = find_static_vm_vaddr((void *)PCI_IO_VIRT_BASE);
> 
