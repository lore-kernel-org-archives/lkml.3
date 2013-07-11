Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383Ab3GKWcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:32:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:44306 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756356Ab3GKWcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:32:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,647,1367996400"; 
   d="scan'208";a="363943658"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Alex Shi <alex.shi@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH, RESEND] x86/tlb_info: detect more tlb configuration
Date: Fri, 12 Jul 2013 01:34:06 +0300
Message-Id: <1373582046-10108-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Software Developer’s Manual covers two more TLB configurations:

63H Data TLB: 1 GByte pages, 4-way set associative, 4 entries
76H Instruction TLB: 2M/4M pages, fully associative, 8 entries

Let's detect them as well.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/include/asm/processor.h | 1 +
 arch/x86/kernel/cpu/common.c     | 7 ++++---
 arch/x86/kernel/cpu/intel.c      | 6 ++++++
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 29937c4..595ec48 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -72,6 +72,7 @@ extern u16 __read_mostly tlb_lli_4m[NR_INFO];
 extern u16 __read_mostly tlb_lld_4k[NR_INFO];
 extern u16 __read_mostly tlb_lld_2m[NR_INFO];
 extern u16 __read_mostly tlb_lld_4m[NR_INFO];
+extern u16 __read_mostly tlb_lld_1g[NR_INFO];
 extern s8  __read_mostly tlb_flushall_shift;
 
 /*
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 548bd03..884da88 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -470,6 +470,7 @@ u16 __read_mostly tlb_lli_4m[NR_INFO];
 u16 __read_mostly tlb_lld_4k[NR_INFO];
 u16 __read_mostly tlb_lld_2m[NR_INFO];
 u16 __read_mostly tlb_lld_4m[NR_INFO];
+u16 __read_mostly tlb_lld_1g[NR_INFO];
 
 /*
  * tlb_flushall_shift shows the balance point in replacing cr3 write
@@ -484,13 +485,13 @@ void __cpuinit cpu_detect_tlb(struct cpuinfo_x86 *c)
 	if (this_cpu->c_detect_tlb)
 		this_cpu->c_detect_tlb(c);
 
-	printk(KERN_INFO "Last level iTLB entries: 4KB %d, 2MB %d, 4MB %d\n" \
-		"Last level dTLB entries: 4KB %d, 2MB %d, 4MB %d\n"	     \
+	printk(KERN_INFO "Last level iTLB entries: 4KB %d, 2MB %d, 4MB %d\n"
+		"Last level dTLB entries: 4KB %d, 2MB %d, 4MB %d, 1GB %d\n"
 		"tlb_flushall_shift: %d\n",
 		tlb_lli_4k[ENTRIES], tlb_lli_2m[ENTRIES],
 		tlb_lli_4m[ENTRIES], tlb_lld_4k[ENTRIES],
 		tlb_lld_2m[ENTRIES], tlb_lld_4m[ENTRIES],
-		tlb_flushall_shift);
+		tlb_lld_1g[ENTRIES], tlb_flushall_shift);
 }
 
 void __cpuinit detect_ht(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 9b0c441..8f5c193 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -525,6 +525,8 @@ static const struct _tlb_table intel_tlb_table[] __cpuinitconst = {
 	{ 0x5b, TLB_DATA_4K_4M,		64,	" TLB_DATA 4 KByte and 4 MByte pages" },
 	{ 0x5c, TLB_DATA_4K_4M,		128,	" TLB_DATA 4 KByte and 4 MByte pages" },
 	{ 0x5d, TLB_DATA_4K_4M,		256,	" TLB_DATA 4 KByte and 4 MByte pages" },
+	{ 0x63, TLB_DATA_1G,		4,	" TLB_DATA 1 GByte pages, 4-way set associative" },
+	{ 0x76, TLB_INST_2M_4M,		8,	" TLB_INST 2-MByte or 4-MByte pages, fully associative" },
 	{ 0xb0, TLB_INST_4K,		128,	" TLB_INST 4 KByte pages, 4-way set associative" },
 	{ 0xb1, TLB_INST_2M_4M,		4,	" TLB_INST 2M pages, 4-way, 8 entries or 4M pages, 4-way entries" },
 	{ 0xb2, TLB_INST_4K,		64,	" TLB_INST 4KByte pages, 4-way set associative" },
@@ -602,6 +604,10 @@ static void __cpuinit intel_tlb_lookup(const unsigned char desc)
 		if (tlb_lld_4m[ENTRIES] < intel_tlb_table[k].entries)
 			tlb_lld_4m[ENTRIES] = intel_tlb_table[k].entries;
 		break;
+	case TLB_DATA_1G:
+		if (tlb_lld_1g[ENTRIES] < intel_tlb_table[k].entries)
+			tlb_lld_1g[ENTRIES] = intel_tlb_table[k].entries;
+		break;
 	}
 }
 
-- 
1.8.3.2

