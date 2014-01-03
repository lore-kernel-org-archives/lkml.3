Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaACXtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 18:49:35 -0500
Received: from [198.137.202.10] ([198.137.202.10]:34469 "EHLO
	terminus.zytor.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbaACXtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 18:49:33 -0500
Date: Fri, 3 Jan 2014 15:48:46 -0800
From: "tip-bot for Kirill A. Shutemov" <tipbot@zytor.com>
Message-ID: <tip-dd360393f4d948eb518372316e52101cf3b44212@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kirill.shutemov@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kirill.shutemov@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1387801018-14499-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1387801018-14499-1-git-send-email-kirill.shutemov@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Detect more TLB configuration
Git-Commit-ID: dd360393f4d948eb518372316e52101cf3b44212
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 03 Jan 2014 15:48:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd360393f4d948eb518372316e52101cf3b44212
Gitweb:     http://git.kernel.org/tip/dd360393f4d948eb518372316e52101cf3b44212
Author:     Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
AuthorDate: Mon, 23 Dec 2013 14:16:58 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 3 Jan 2014 14:35:42 -0800

x86, cpu: Detect more TLB configuration

The Intel Software Developer’s Manual covers few more TLB
configurations exposed as CPUID 2 descriptors:

61H Instruction TLB: 4 KByte pages, fully associative, 48 entries
63H Data TLB: 1 GByte pages, 4-way set associative, 4 entries
76H Instruction TLB: 2M/4M pages, fully associative, 8 entries
B5H Instruction TLB: 4KByte pages, 8-way set associative, 64 entries
B6H Instruction TLB: 4KByte pages, 8-way set associative, 128 entries
C1H Shared 2nd-Level TLB: 4 KByte/2MByte pages, 8-way associative, 1024 entries
C2H DTLB DTLB: 2 MByte/$MByte pages, 4-way associative, 16 entries

Let's detect them as well.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Link: http://lkml.kernel.org/r/1387801018-14499-1-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/processor.h |  1 +
 arch/x86/kernel/cpu/common.c     |  7 ++++---
 arch/x86/kernel/cpu/intel.c      | 26 ++++++++++++++++++++++++++
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7b034a4..1dd6260 100644
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
index 6abc172..24b6fd1 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -472,6 +472,7 @@ u16 __read_mostly tlb_lli_4m[NR_INFO];
 u16 __read_mostly tlb_lld_4k[NR_INFO];
 u16 __read_mostly tlb_lld_2m[NR_INFO];
 u16 __read_mostly tlb_lld_4m[NR_INFO];
+u16 __read_mostly tlb_lld_1g[NR_INFO];
 
 /*
  * tlb_flushall_shift shows the balance point in replacing cr3 write
@@ -486,13 +487,13 @@ void cpu_detect_tlb(struct cpuinfo_x86 *c)
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
 
 void detect_ht(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index ea04b34..5eb7ea5 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -506,6 +506,7 @@ static unsigned int intel_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 #define TLB_DATA0_2M_4M	0x23
 
 #define STLB_4K		0x41
+#define STLB_4K_2M	0x42
 
 static const struct _tlb_table intel_tlb_table[] = {
 	{ 0x01, TLB_INST_4K,		32,	" TLB_INST 4 KByte pages, 4-way set associative" },
@@ -526,13 +527,20 @@ static const struct _tlb_table intel_tlb_table[] = {
 	{ 0x5b, TLB_DATA_4K_4M,		64,	" TLB_DATA 4 KByte and 4 MByte pages" },
 	{ 0x5c, TLB_DATA_4K_4M,		128,	" TLB_DATA 4 KByte and 4 MByte pages" },
 	{ 0x5d, TLB_DATA_4K_4M,		256,	" TLB_DATA 4 KByte and 4 MByte pages" },
+	{ 0x61, TLB_INST_4K,		48,	" TLB_INST 4 KByte pages, full associative" },
+	{ 0x63, TLB_DATA_1G,		4,	" TLB_DATA 1 GByte pages, 4-way set associative" },
+	{ 0x76, TLB_INST_2M_4M,		8,	" TLB_INST 2-MByte or 4-MByte pages, fully associative" },
 	{ 0xb0, TLB_INST_4K,		128,	" TLB_INST 4 KByte pages, 4-way set associative" },
 	{ 0xb1, TLB_INST_2M_4M,		4,	" TLB_INST 2M pages, 4-way, 8 entries or 4M pages, 4-way entries" },
 	{ 0xb2, TLB_INST_4K,		64,	" TLB_INST 4KByte pages, 4-way set associative" },
 	{ 0xb3, TLB_DATA_4K,		128,	" TLB_DATA 4 KByte pages, 4-way set associative" },
 	{ 0xb4, TLB_DATA_4K,		256,	" TLB_DATA 4 KByte pages, 4-way associative" },
+	{ 0xb5, TLB_INST_4K,		64,	" TLB_INST 4 KByte pages, 8-way set ssociative" },
+	{ 0xb6, TLB_INST_4K,		128,	" TLB_INST 4 KByte pages, 8-way set ssociative" },
 	{ 0xba, TLB_DATA_4K,		64,	" TLB_DATA 4 KByte pages, 4-way associative" },
 	{ 0xc0, TLB_DATA_4K_4M,		8,	" TLB_DATA 4 KByte and 4 MByte pages, 4-way associative" },
+	{ 0xc1, STLB_4K_2M,		1024,	" STLB 4 KByte and 2 MByte pages, 8-way associative" },
+	{ 0xc2, TLB_DATA_2M_4M,		16,	" DTLB 2 MByte/4MByte pages, 4-way associative" },
 	{ 0xca, STLB_4K,		512,	" STLB 4 KByte pages, 4-way associative" },
 	{ 0x00, 0, 0 }
 };
@@ -558,6 +566,20 @@ static void intel_tlb_lookup(const unsigned char desc)
 		if (tlb_lld_4k[ENTRIES] < intel_tlb_table[k].entries)
 			tlb_lld_4k[ENTRIES] = intel_tlb_table[k].entries;
 		break;
+	case STLB_4K_2M:
+		if (tlb_lli_4k[ENTRIES] < intel_tlb_table[k].entries)
+			tlb_lli_4k[ENTRIES] = intel_tlb_table[k].entries;
+		if (tlb_lld_4k[ENTRIES] < intel_tlb_table[k].entries)
+			tlb_lld_4k[ENTRIES] = intel_tlb_table[k].entries;
+		if (tlb_lli_2m[ENTRIES] < intel_tlb_table[k].entries)
+			tlb_lli_2m[ENTRIES] = intel_tlb_table[k].entries;
+		if (tlb_lld_2m[ENTRIES] < intel_tlb_table[k].entries)
+			tlb_lld_2m[ENTRIES] = intel_tlb_table[k].entries;
+		if (tlb_lli_4m[ENTRIES] < intel_tlb_table[k].entries)
+			tlb_lli_4m[ENTRIES] = intel_tlb_table[k].entries;
+		if (tlb_lld_4m[ENTRIES] < intel_tlb_table[k].entries)
+			tlb_lld_4m[ENTRIES] = intel_tlb_table[k].entries;
+		break;
 	case TLB_INST_ALL:
 		if (tlb_lli_4k[ENTRIES] < intel_tlb_table[k].entries)
 			tlb_lli_4k[ENTRIES] = intel_tlb_table[k].entries;
@@ -603,6 +625,10 @@ static void intel_tlb_lookup(const unsigned char desc)
 		if (tlb_lld_4m[ENTRIES] < intel_tlb_table[k].entries)
 			tlb_lld_4m[ENTRIES] = intel_tlb_table[k].entries;
 		break;
+	case TLB_DATA_1G:
+		if (tlb_lld_1g[ENTRIES] < intel_tlb_table[k].entries)
+			tlb_lld_1g[ENTRIES] = intel_tlb_table[k].entries;
+		break;
 	}
 }
 
