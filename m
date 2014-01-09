Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbaAIOgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:36:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54903 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbaAIOfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:35:07 -0500
From: Mel Gorman <mgorman@suse.de>
To: Alex Shi <alex.shi@linaro.org>, Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, H Peter Anvin <hpa@zytor.com>,
        Linux-X86 <x86@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 5/5] mm: x86: Revisit tlb_flushall_shift tuning for page flushes except on IvyBridge
Date: Thu,  9 Jan 2014 14:34:58 +0000
Message-Id: <1389278098-27154-6-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1389278098-27154-1-git-send-email-mgorman@suse.de>
References: <1389278098-27154-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a large ebizzy performance regression that was bisected to commit
611ae8e3 (x86/tlb: enable tlb flush range support for x86). The problem
was related to the tlb_flushall_shift tuning for IvyBridge which was
altered. The problem is that it is not clear if the tuning values for each
CPU family is correct as the methodology used to tune the values is unclear.

This patch uses a conservative tlb_flushall_shift value for all CPU families
except IvyBridge so the decision can be revisited if any regression is found
as a result of this change. IvyBridge is an exception as testing with one
methodology determined that the value of 2 is acceptable. Details are in the
changelog for the patch "x86: mm: Change tlb_flushall_shift for IvyBridge".

One important aspect of this to watch out for is Xen. The original commit
log mentioned large performance gains on Xen. It's possible Xen is more
sensitive to this value if it flushes small ranges of pages more frequently
than workloads on bare metal typically do.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 arch/x86/kernel/cpu/amd.c   |  5 +----
 arch/x86/kernel/cpu/intel.c | 10 +++-------
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index bca023b..7aa2545 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -758,10 +758,7 @@ static unsigned int amd_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 
 static void cpu_set_tlb_flushall_shift(struct cpuinfo_x86 *c)
 {
-	tlb_flushall_shift = 5;
-
-	if (c->x86 <= 0x11)
-		tlb_flushall_shift = 4;
+	tlb_flushall_shift = 6;
 }
 
 static void cpu_detect_tlb_amd(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index bbe1b8b..d358a39 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -615,21 +615,17 @@ static void intel_tlb_flushall_shift_set(struct cpuinfo_x86 *c)
 	case 0x61d: /* six-core 45 nm xeon "Dunnington" */
 		tlb_flushall_shift = -1;
 		break;
+	case 0x63a: /* Ivybridge */
+		tlb_flushall_shift = 2;
+		break;
 	case 0x61a: /* 45 nm nehalem, "Bloomfield" */
 	case 0x61e: /* 45 nm nehalem, "Lynnfield" */
 	case 0x625: /* 32 nm nehalem, "Clarkdale" */
 	case 0x62c: /* 32 nm nehalem, "Gulftown" */
 	case 0x62e: /* 45 nm nehalem-ex, "Beckton" */
 	case 0x62f: /* 32 nm Xeon E7 */
-		tlb_flushall_shift = 6;
-		break;
 	case 0x62a: /* SandyBridge */
 	case 0x62d: /* SandyBridge, "Romely-EP" */
-		tlb_flushall_shift = 5;
-		break;
-	case 0x63a: /* Ivybridge */
-		tlb_flushall_shift = 2;
-		break;
 	default:
 		tlb_flushall_shift = 6;
 	}
-- 
1.8.4

