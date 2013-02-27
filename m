Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab3B0WaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 17:30:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58526 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab3B0WaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 17:30:08 -0500
Date: Wed, 27 Feb 2013 14:28:52 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-oebml055yyfm8yxmria09rja@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dvhart@linux.intel.com, stable@vger.kernel.org, matt.fleming@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dvhart@linux.intel.com, stable@vger.kernel.org, matt.fleming@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86:
  Make sure we can boot in the case the BDA contains pure garbage
Git-Commit-ID: 7c10093692ed2e6f318387d96b829320aa0ca64c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 27 Feb 2013 14:28:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7c10093692ed2e6f318387d96b829320aa0ca64c
Gitweb:     http://git.kernel.org/tip/7c10093692ed2e6f318387d96b829320aa0ca64c
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 27 Feb 2013 12:46:40 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 27 Feb 2013 13:38:57 -0800

x86: Make sure we can boot in the case the BDA contains pure garbage

On non-BIOS platforms it is possible that the BIOS data area contains
garbage instead of being zeroed or something equivalent (firmware
people: we are talking of 1.5K here, so please do the sane thing.)

We need on the order of 20-30K of low memory in order to boot, which
may grow up to < 64K in the future.  We probably want to avoid the
lowest of the low memory.  At the same time, it seems extremely
unlikely that a legitimate EBDA would ever reach down to the 128K
(which would require it to be over half a megabyte in size.)  Thus,
pick 128K as the cutoff for "this is insane, ignore."  We may still
end up reserving a bunch of extra memory on the low megabyte, but that
is not really a major issue these days.  In the worst case we lose
512K of RAM.

This code really should be merged with trim_bios_range() in
arch/x86/kernel/setup.c, but that is a bigger patch for a later merge
window.

Reported-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/n/tip-oebml055yyfm8yxmria09rja@git.kernel.org
---
 arch/x86/kernel/head.c | 53 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/head.c b/arch/x86/kernel/head.c
index 48d9d4e..992f442 100644
--- a/arch/x86/kernel/head.c
+++ b/arch/x86/kernel/head.c
@@ -5,8 +5,6 @@
 #include <asm/setup.h>
 #include <asm/bios_ebda.h>
 
-#define BIOS_LOWMEM_KILOBYTES 0x413
-
 /*
  * The BIOS places the EBDA/XBDA at the top of conventional
  * memory, and usually decreases the reported amount of
@@ -16,17 +14,30 @@
  * chipset: reserve a page before VGA to prevent PCI prefetch
  * into it (errata #56). Usually the page is reserved anyways,
  * unless you have no PS/2 mouse plugged in.
+ *
+ * This functions is deliberately very conservative.  Losing
+ * memory in the bottom megabyte is rarely a problem, as long
+ * as we have enough memory to install the trampoline.  Using
+ * memory that is in use by the BIOS or by some DMA device
+ * the BIOS didn't shut down *is* a big problem.
  */
+
+#define BIOS_LOWMEM_KILOBYTES	0x413
+#define LOWMEM_CAP		0x9f000U	/* Absolute maximum */
+#define INSANE_CUTOFF		0x20000U	/* Less than this = insane */
+
 void __init reserve_ebda_region(void)
 {
 	unsigned int lowmem, ebda_addr;
 
-	/* To determine the position of the EBDA and the */
-	/* end of conventional memory, we need to look at */
-	/* the BIOS data area. In a paravirtual environment */
-	/* that area is absent. We'll just have to assume */
-	/* that the paravirt case can handle memory setup */
-	/* correctly, without our help. */
+	/*
+	 * To determine the position of the EBDA and the
+	 * end of conventional memory, we need to look at
+	 * the BIOS data area. In a paravirtual environment
+	 * that area is absent. We'll just have to assume
+	 * that the paravirt case can handle memory setup
+	 * correctly, without our help.
+	 */
 	if (paravirt_enabled())
 		return;
 
@@ -37,19 +48,23 @@ void __init reserve_ebda_region(void)
 	/* start of EBDA area */
 	ebda_addr = get_bios_ebda();
 
-	/* Fixup: bios puts an EBDA in the top 64K segment */
-	/* of conventional memory, but does not adjust lowmem. */
-	if ((lowmem - ebda_addr) <= 0x10000)
-		lowmem = ebda_addr;
+	/*
+	 * Note: some old Dells seem to need 4k EBDA without
+	 * reporting so, so just consider the memory above 0x9f000
+	 * to be off limits (bugzilla 2990).
+	 */
+
+	/* If the EBDA address is below 128K, assume it is bogus */
+	if (ebda_addr < INSANE_CUTOFF)
+		ebda_addr = LOWMEM_CAP;
 
-	/* Fixup: bios does not report an EBDA at all. */
-	/* Some old Dells seem to need 4k anyhow (bugzilla 2990) */
-	if ((ebda_addr == 0) && (lowmem >= 0x9f000))
-		lowmem = 0x9f000;
+	/* If lowmem is less than 128K, assume it is bogus */
+	if (lowmem < INSANE_CUTOFF)
+		lowmem = LOWMEM_CAP;
 
-	/* Paranoia: should never happen, but... */
-	if ((lowmem == 0) || (lowmem >= 0x100000))
-		lowmem = 0x9f000;
+	/* Use the lower of the lowmem and EBDA markers as the cutoff */
+	lowmem = min(lowmem, ebda_addr);
+	lowmem = min(lowmem, LOWMEM_CAP); /* Absolute cap */
 
 	/* reserve all memory between lowmem and the 1MB mark */
 	memblock_reserve(lowmem, 0x100000 - lowmem);
