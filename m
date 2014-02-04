Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbaBDQl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:41:58 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:30968 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752629AbaBDQlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 11:41:55 -0500
Date: Tue, 4 Feb 2014 16:41:14 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: Add architecture support for PCI
Message-ID: <20140204164114.GJ30676@arm.com>
References: <1391453028-23191-1-git-send-email-Liviu.Dudau@arm.com>
 <3808209.DeG1VobanZ@wuerfel>
 <20140203213658.GA24036@e106497-lin.cambridge.arm.com>
 <3277167.UhkSU8Sf56@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3277167.UhkSU8Sf56@wuerfel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 08:44:36AM +0000, Arnd Bergmann wrote:
> On Monday 03 February 2014 21:36:58 Liviu Dudau wrote:
> > On Mon, Feb 03, 2014 at 08:05:56PM +0000, Arnd Bergmann wrote:
> > > 2 MB was a compromise on arm32 to allow up to 32 PCI host bridges but not
> > > take up too much virtual space. On arm64 it should be at least as big.
> > > Could be more than that, although I don't see a reason why it should be,
> > > unless we expect to see systems with tons of host bridges, or buses
> > > that exceed 64KB of I/O space.
> > 
> > I will increase the size to 2MB for v2.
> 
> Thinking about this some more, I'd go a little higher. In case of
> pci_mv, we already register a 1MB region for one logical host
> (which has multiple I/O spaces behind an emulated bridge), so
> going to 16MB or more would let us handle multiple 1MB windows
> for some amount of future proofing.
> 
> Maybe Catalin can assign us some virtual address space to use,
> with the constraints that it should be 16MB or more in an
> area that doesn't require additional kernel page table pages.

See below, 16MB and could be extended further if needed.

------------>8--------------------

>From 00521f109ac8a2589c9089a5feaaaa1be7f26108 Mon Sep 17 00:00:00 2001
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Tue, 4 Feb 2014 16:37:59 +0000
Subject: [PATCH] arm64: Extend the PCI I/O space to 16MB

The patch moves the PCI I/O space (currently at 64K) before the
earlyprintk mapping and extends it to 16MB.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 Documentation/arm64/memory.txt | 16 ++++++++++------
 arch/arm64/include/asm/io.h    |  2 +-
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/Documentation/arm64/memory.txt b/Documentation/arm64/memory.txt
index 5e054bfe4dde..85e24c4f215c 100644
--- a/Documentation/arm64/memory.txt
+++ b/Documentation/arm64/memory.txt
@@ -35,11 +35,13 @@ ffffffbc00000000	ffffffbdffffffff	   8GB		vmemmap
 
 ffffffbe00000000	ffffffbffbbfffff	  ~8GB		[guard, future vmmemap]
 
-ffffffbffbc00000	ffffffbffbdfffff	   2MB		earlyprintk device
+ffffffbffa000000	ffffffbffaffffff	  16MB		PCI I/O space
+
+ffffffbffb000000	ffffffbffbbfffff	  12MB		[guard]
 
-ffffffbffbe00000	ffffffbffbe0ffff	  64KB		PCI I/O space
+ffffffbffbc00000	ffffffbffbdfffff	   2MB		earlyprintk device
 
-ffffffbffbe10000	ffffffbcffffffff	  ~2MB		[guard]
+ffffffbffbe00000	ffffffbffbffffff	   2MB		[guard]
 
 ffffffbffc000000	ffffffbfffffffff	  64MB		modules
 
@@ -60,11 +62,13 @@ fffffdfc00000000	fffffdfdffffffff	   8GB		vmemmap
 
 fffffdfe00000000	fffffdfffbbfffff	  ~8GB		[guard, future vmmemap]
 
-fffffdfffbc00000	fffffdfffbdfffff	   2MB		earlyprintk device
+fffffdfffa000000	fffffdfffaffffff	  16MB		PCI I/O space
+
+fffffdfffb000000	fffffdfffbbfffff	  12MB		[guard]
 
-fffffdfffbe00000	fffffdfffbe0ffff	  64KB		PCI I/O space
+fffffdfffbc00000	fffffdfffbdfffff	   2MB		earlyprintk device
 
-fffffdfffbe10000	fffffdfffbffffff	  ~2MB		[guard]
+fffffdfffbe00000	fffffdfffbffffff	   2MB		[guard]
 
 fffffdfffc000000	fffffdffffffffff	  64MB		modules
 
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 4cc813eddacb..7846a6bb0833 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -121,7 +121,7 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
  *  I/O port access primitives.
  */
 #define IO_SPACE_LIMIT		0xffff
-#define PCI_IOBASE		((void __iomem *)(MODULES_VADDR - SZ_2M))
+#define PCI_IOBASE		((void __iomem *)(MODULES_VADDR - SZ_32M))
 
 static inline u8 inb(unsigned long addr)
 {
