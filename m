Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3JFOEo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 10:04:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46644 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab3JFOEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 10:04:42 -0400
Date: Sun, 6 Oct 2013 07:04:29 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-38901f1c1cae241fd4e3c5e63fcc690b921734b1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, bp@suse.de
In-Reply-To: <1380922676-23007-1-git-send-email-andi@firstfloor.org>
References: <1380922676-23007-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/iommu] x86/iommu: Don'
 t make AMD_GART depend on EXPERT and default y
Git-Commit-ID: 38901f1c1cae241fd4e3c5e63fcc690b921734b1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 06 Oct 2013 07:04:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  38901f1c1cae241fd4e3c5e63fcc690b921734b1
Gitweb:     http://git.kernel.org/tip/38901f1c1cae241fd4e3c5e63fcc690b921734b1
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Fri, 4 Oct 2013 14:37:56 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 6 Oct 2013 11:47:04 +0200

x86/iommu: Don't make AMD_GART depend on EXPERT and default y

The AMD_GART driver was made EXPERT/EMBEDDED a long time
ago to avoid unbootable 64bit systems with 32bit only devices.

This was before swiotlb was there, which does the job
of this fallback today. SWIOTLB is always on, so systems
should always boot.

The drawback is that every system has to compile that
driver in (it cannot be a module).

Also:
 - Newer AMD CPUs (the APUs) don't seem to have AMD_GART support
   at all anymore.

 - Newer AMD platforms have a much better real IOMMU

 - The AMD GART driver was never very good (lots of overhead,
   e.g. in flushing due to some workarounds) and it's doubtful it's
   really better than SWIOTLB.

 - On older K8 systems it didn't even work with all chipsets.

 - The 32bit device bounce buffer case should be rare/
   non performance critical these days anyways.

 - On non AMD systems it is not needed at all.

So drop the EXPERT dependency on AMD_GART and remove the
default y. The driver can be still compiled in, just
it's an explicit decision now, and people who don't want
it can unselect it.

I also clarified the description a bit.

This allows to save ~8K text on most modern x86-64 systems.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1380922676-23007-1-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ee2fb9d..c9d2b81 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -756,17 +756,16 @@ config DMI
 	  BIOS code.
 
 config GART_IOMMU
-	bool "GART IOMMU support" if EXPERT
-	default y
+	bool "Old AMD GART IOMMU support"
 	select SWIOTLB
 	depends on X86_64 && PCI && AMD_NB
 	---help---
 	  Support for full DMA access of devices with 32bit memory access only
 	  on systems with more than 3GB. This is usually needed for USB,
 	  sound, many IDE/SATA chipsets and some other devices.
-	  Provides a driver for the AMD Athlon64/Opteron/Turion/Sempron GART
-	  based hardware IOMMU and a software bounce buffer based IOMMU used
-	  on Intel systems and as fallback.
+	  Provides a driver for the older AMD Athlon64/Opteron/Turion/Sempron GART
+	  based hardware IOMMU.
+	  Newer systems typically have a better AMD IOMMU.
 	  The code is only active when needed (enough memory and limited
 	  device) unless CONFIG_IOMMU_DEBUG or iommu=force is specified
 	  too.
