Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbaGNB4D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 21:56:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34423 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaGNBzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 21:55:54 -0400
Date: Sun, 13 Jul 2014 18:55:14 -0700
From: tip-bot for Oren Twaig <tipbot@zytor.com>
Message-ID: <tip-411cf9ee2946492c0ac7eca48422fcf94a723ce5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        shai@scalemp.com, oren@scalemp.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        shai@scalemp.com, oren@scalemp.com, tglx@linutronix.de
In-Reply-To: <1404036068-11674-1-git-send-email-oren@scalemp.com>
References: <1404036068-11674-1-git-send-email-oren@scalemp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, vsmp: Remove is_vsmp_box()
  from apic_is_clustered_box()
Git-Commit-ID: 411cf9ee2946492c0ac7eca48422fcf94a723ce5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  411cf9ee2946492c0ac7eca48422fcf94a723ce5
Gitweb:     http://git.kernel.org/tip/411cf9ee2946492c0ac7eca48422fcf94a723ce5
Author:     Oren Twaig <oren@scalemp.com>
AuthorDate: Sun, 29 Jun 2014 13:01:08 +0300
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sun, 13 Jul 2014 17:48:03 -0700

x86, vsmp: Remove is_vsmp_box() from apic_is_clustered_box()

When a vSMP Foundation box is detected, the function apic_cluster_num() counts
the number of APIC clusters found. If more than one found, a multi board
configuration is assumed, and TSC marked as unstable. This behavior is
incorrect as vSMP Foundation may use processors from single node only, attached
to memory of other nodes - and such node may have more than one APIC cluster
(typically any recent intel box has more than single APIC_CLUSTERID(x)).

To fix this, we simply remove the code which detects a vSMP Foundation box and
affects apic_is_clusted_box() return value. This can be done because later the
kernel checks by itself if the TSC is stable using the
check_tsc_sync_[source|target]() functions and marks TSC as unstable if needed.

Acked-by: Shai Fultheim <shai@scalemp.com>
Signed-off-by: Oren Twaig <oren@scalemp.com>
Link: http://lkml.kernel.org/r/1404036068-11674-1-git-send-email-oren@scalemp.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/apic.h |  8 ------
 arch/x86/kernel/apic/apic.c | 60 +--------------------------------------------
 2 files changed, 1 insertion(+), 67 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 69ed79a..b40ea7e 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -85,14 +85,6 @@ static inline bool apic_from_smp_config(void)
 #include <asm/paravirt.h>
 #endif
 
-#ifdef CONFIG_X86_64
-extern int is_vsmp_box(void);
-#else
-static inline int is_vsmp_box(void)
-{
-	return 0;
-}
-#endif
 extern int setup_profiling_timer(unsigned int);
 
 static inline void native_apic_mem_write(u32 reg, u32 v)
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index ca1bd75..6b35d30 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2451,51 +2451,6 @@ static void apic_pm_activate(void) { }
 
 #ifdef CONFIG_X86_64
 
-static int apic_cluster_num(void)
-{
-	int i, clusters, zeros;
-	unsigned id;
-	u16 *bios_cpu_apicid;
-	DECLARE_BITMAP(clustermap, NUM_APIC_CLUSTERS);
-
-	bios_cpu_apicid = early_per_cpu_ptr(x86_bios_cpu_apicid);
-	bitmap_zero(clustermap, NUM_APIC_CLUSTERS);
-
-	for (i = 0; i < nr_cpu_ids; i++) {
-		/* are we being called early in kernel startup? */
-		if (bios_cpu_apicid) {
-			id = bios_cpu_apicid[i];
-		} else if (i < nr_cpu_ids) {
-			if (cpu_present(i))
-				id = per_cpu(x86_bios_cpu_apicid, i);
-			else
-				continue;
-		} else
-			break;
-
-		if (id != BAD_APICID)
-			__set_bit(APIC_CLUSTERID(id), clustermap);
-	}
-
-	/* Problem:  Partially populated chassis may not have CPUs in some of
-	 * the APIC clusters they have been allocated.  Only present CPUs have
-	 * x86_bios_cpu_apicid entries, thus causing zeroes in the bitmap.
-	 * Since clusters are allocated sequentially, count zeros only if
-	 * they are bounded by ones.
-	 */
-	clusters = 0;
-	zeros = 0;
-	for (i = 0; i < NUM_APIC_CLUSTERS; i++) {
-		if (test_bit(i, clustermap)) {
-			clusters += 1 + zeros;
-			zeros = 0;
-		} else
-			++zeros;
-	}
-
-	return clusters;
-}
-
 static int multi_checked;
 static int multi;
 
@@ -2540,20 +2495,7 @@ static void dmi_check_multi(void)
 int apic_is_clustered_box(void)
 {
 	dmi_check_multi();
-	if (multi)
-		return 1;
-
-	if (!is_vsmp_box())
-		return 0;
-
-	/*
-	 * ScaleMP vSMPowered boxes have one cluster per board and TSCs are
-	 * not guaranteed to be synced between boards
-	 */
-	if (apic_cluster_num() > 1)
-		return 1;
-
-	return 0;
+	return multi;
 }
 #endif
 
