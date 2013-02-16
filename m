Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab3BPMt1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 07:49:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54651 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab3BPMt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 07:49:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 3/3] ARM: mm: use static_vm for managing static mapped areas
Date: Sat, 16 Feb 2013 12:49:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Russell King <linux@arm.linux.org.uk>, js1304@gmail.com,
        Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
References: <1360142010-10598-1-git-send-email-iamjoonsoo.kim@lge.com> <1360142010-10598-4-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1360142010-10598-4-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302161249.08597.arnd@arndb.de>
X-Provags-ID: V02:K0:pvR3q79JJIE6Dg/SBl7pcbnS1XgGaUgWt3eyGz5wUNy
 mf83NK4OlGh9YOeA5+m0wllBqvJDZ3RPvddLVW/PMMM4x4ruhv
 I+Q74gLhkGHz4j9BG7qaicIiZ+Fdq/eFlkN9/jOLqMzq1d5UH4
 ef0+MDfdXLX1uPFMvxitBYOSnGpuB+t7S6/wIQKuD2Gh4dci3U
 ktxjlTUV2sxC1m2ksYny+OBpXcu77+cr0CQD1RNiw8tI6BXY56
 P09Bx15usM6o09qA9HJLCh2WV2Hy/Bfi/usdfmWJM/2K6mCRNp
 GQRf3srYJowyR5ln1pxH9iZsZf+fezBcuHz+rqLhhzYUfdDBCA
 nwkgxS4t3UuRbGRJE63U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 February 2013, Joonsoo Kim wrote:
> @@ -859,17 +864,12 @@ static void __init pci_reserve_io(void)
>  {
>  	struct vm_struct *vm;
>  	unsigned long addr;
> +	struct static_vm *svm;
>  
> -	/* we're still single threaded hence no lock needed here */
> -	for (vm = vmlist; vm; vm = vm->next) {
> -		if (!(vm->flags & VM_ARM_STATIC_MAPPING))
> -			continue;
> -		addr = (unsigned long)vm->addr;
> -		addr &= ~(SZ_2M - 1);
> -		if (addr == PCI_IO_VIRT_BASE)
> -			return;
> +	svm = find_static_vm_vaddr((void *)PCI_IO_VIRT_BASE);
> +	if (svm)
> +		return;
>  
> -	}

This is causing build warnings in a bunch of configurations now,
see patch below.

	Arnd

8<-----
ARM: mm: remove unused variables in pci_reserve_io

Patch "ARM: 7646/1: mm: use static_vm for managing static mapped areas"
removed code from pci_reserve_io but left variable declarations
in place that are now unused, as gcc correctly warns.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index c6fe15a..c6d45c8 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -901,8 +901,6 @@ static void __init fill_pmd_gaps(void)
 #if defined(CONFIG_PCI) && !defined(CONFIG_NEED_MACH_IO_H)
 static void __init pci_reserve_io(void)
 {
-	struct vm_struct *vm;
-	unsigned long addr;
 	struct static_vm *svm;
 
 	svm = find_static_vm_vaddr((void *)PCI_IO_VIRT_BASE);
