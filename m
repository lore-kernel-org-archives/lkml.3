Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751061AbaKYPaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 10:30:00 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:39021 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaKYP36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:29:58 -0500
Date: Tue, 25 Nov 2014 15:29:54 +0000
From: Will Deacon <will.deacon@arm.com>
To: Andre Przywara <andre.przywara@arm.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] arm64: alternatives runtime patching
Message-ID: <20141125152954.GF8541@arm.com>
References: <1415980452-20366-1-git-send-email-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415980452-20366-1-git-send-email-andre.przywara@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andre,

On Fri, Nov 14, 2014 at 03:54:06PM +0000, Andre Przywara wrote:
> This series introduces alternatives runtime patching to arm64.
> This allows to patch assembly instruction at runtime to either
> fix hardware bugs or optimize for certain hardware features. Look
> at patch 5/6 for an example on how to use this.
> 
> The code is heavily based on the x86 implementation.
> Currently this is focussed on fixing CPU errata, but in the future
> runtime optimizations for new CPU features are planned.
> 
> Patch 1/6 introduces a new cpu_hwcaps bitmap, which holds kernel
> internal CPU feature flags. Since elf_hwcaps is also a userspace ABI,
> I refrained from tinkering with this (tried this, gets messy).
> 
> Based on bits in this bitmap, in patch 2/6 we provide a macro to
> replace (inline) assembly instructions at runtime with alternative
> instructions. As on x86, those bits go into separate ELF sections.
> The patching is done using stop_machine() to avoid mayhem in SMP.
> 
> Patch 3/6 introduces means to set cpu_hwcaps bits based on detecting
> a certain CPU revision. Currently this is based on the architectural
> bits in the MIDR register, but the code is flexible enough to easily
> introduce more advanced criteria.
> To support a heterogenous CPU setup (e.g. big.LITTLE), we scan all
> CPUs in the system.
> 
> Patch 4 and 5 use the new framework to introduce workarounds for two
> ARM-Cortex errata. Patch 4 introduces some more framework for the
> detection, while patch 5 should be used as a blueprint for how to add
> workarounds for CPU errata in the future.
> 
> Patch 6/6 finally introduces Kconfig entries for the bugs.
> Those are meant to
> a) document the errata and workarounds and
> b) to allow system vendors to remove certain workarounds for custom
> build kernels.
> Though this shouldn't be strictly necessary, experience shows that
> people will do b) anyway and I deem it better to provide official
> means rather than provoking random hacks.

I just merged this and encountered a couple of issues in my testing:

  (1) If patching occurs in a section that is discarded at compile time
      (e.g. .exit.text) then we will fail to link:

      `.exit.text' referenced in section `.altinstructions' of
      drivers/built-in.o: defined in discarded section `.exit.text' of
      drivers/built-in.o

  (2) No patching occurs for modules

Please can you send me some additional patches on top of your series
to address these problems? The first issue can easily be solved by adding
a new Kconfig entry for the alternative framework, which causes
ARM_EXIT_{KEEP,DISCARD} to change their definitions. The second patch
needs a call from the module loader, in a similar manner to the SMP_ON_UP
patching in arch/arm/.

In the meantime, I've applied the diff below to keep allyesconfig happy.

Thanks,

Will

--->8

diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 3236727be2b9..9965ec87cbec 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -11,8 +11,9 @@
 
 #include "image.h"
 
-#define ARM_EXIT_KEEP(x)
-#define ARM_EXIT_DISCARD(x)    x
+/* .exit.text needed in case of alternative patching */
+#define ARM_EXIT_KEEP(x)       x
+#define ARM_EXIT_DISCARD(x)
 
 OUTPUT_ARCH(aarch64)
 ENTRY(_text)

