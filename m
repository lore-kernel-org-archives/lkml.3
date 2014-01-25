Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaAYO0q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 09:26:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52576 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbaAYO0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 09:26:09 -0500
Date: Sat, 25 Jan 2014 06:25:28 -0800
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-b9a3b4c976c1209957326537ad5c0bb633dfd764@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        alex.shi@linaro.org, akpm@linux-foundation.org, mgorman@suse.de,
        tglx@linutronix.de, davidlohr@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        alex.shi@linaro.org, akpm@linux-foundation.org, mgorman@suse.de,
        tglx@linutronix.de, davidlohr@hp.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] mm, x86:
  Revisit tlb_flushall_shift tuning for page flushes except on IvyBridge
Git-Commit-ID: b9a3b4c976c1209957326537ad5c0bb633dfd764
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 25 Jan 2014 06:25:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b9a3b4c976c1209957326537ad5c0bb633dfd764
Gitweb:     http://git.kernel.org/tip/b9a3b4c976c1209957326537ad5c0bb633dfd764
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Tue, 21 Jan 2014 14:33:22 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 25 Jan 2014 09:10:44 +0100

mm, x86: Revisit tlb_flushall_shift tuning for page flushes except on IvyBridge

There was a large ebizzy performance regression that was
bisected to commit 611ae8e3 (x86/tlb: enable tlb flush range
support for x86).  The problem was related to the
tlb_flushall_shift tuning for IvyBridge which was altered.  The
problem is that it is not clear if the tuning values for each
CPU family is correct as the methodology used to tune the values
is unclear.

This patch uses a conservative tlb_flushall_shift value for all
CPU families except IvyBridge so the decision can be revisited
if any regression is found as a result of this change.
IvyBridge is an exception as testing with one methodology
determined that the value of 2 is acceptable.  Details are in
the changelog for the patch "x86: mm: Change tlb_flushall_shift
for IvyBridge".

One important aspect of this to watch out for is Xen.  The
original commit log mentioned large performance gains on Xen.
It's possible Xen is more sensitive to this value if it flushes
small ranges of pages more frequently than workloads on bare
metal typically do.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Tested-by: Davidlohr Bueso <davidlohr@hp.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Shi <alex.shi@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-dyzMww3fqugnhbhgo6Gxmtkw@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/amd.c   |  5 +----
 arch/x86/kernel/cpu/intel.c | 10 +++-------
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 59bfebc..96abcca 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -768,10 +768,7 @@ static unsigned int amd_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 
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
