Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935052Ab3GWWw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:52:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41542 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934542Ab3GWW1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 018/103] powerpc/perf: Freeze PMC5/6 if were not using them
Date: Tue, 23 Jul 2013 15:25:29 -0700
Message-Id: <20130723220420.590938892@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <michael@ellerman.id.au>

commit 7a7a41f9d5b28ac3a916b057a7d3cd3f435ee9a6 upstream.

On Power8 we can freeze PMC5 and 6 if we're not using them. Normally they
run all the time.

As noticed by Anshuman, we should unfreeze them when we disable the PMU
as there are legacy tools which expect them to run all the time.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/reg.h  |    1 +
 arch/powerpc/perf/core-book3s.c |    5 +++--
 arch/powerpc/perf/power8-pmu.c  |    4 ++++
 3 files changed, 8 insertions(+), 2 deletions(-)

--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -626,6 +626,7 @@
 #define   MMCR0_TRIGGER	0x00002000UL /* TRIGGER enable */
 #define   MMCR0_PMAO	0x00000080UL /* performance monitor alert has occurred, set to 0 after handling exception */
 #define   MMCR0_SHRFC	0x00000040UL /* SHRre freeze conditions between threads */
+#define   MMCR0_FC56	0x00000010UL /* freeze counters 5 and 6 */
 #define   MMCR0_FCTI	0x00000008UL /* freeze counters in tags inactive mode */
 #define   MMCR0_FCTA	0x00000004UL /* freeze counters in tags active mode */
 #define   MMCR0_FCWAIT	0x00000002UL /* freeze counter in WAIT state */
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -75,6 +75,7 @@ static unsigned int freeze_events_kernel
 
 #define MMCR0_FCHV		0
 #define MMCR0_PMCjCE		MMCR0_PMCnCE
+#define MMCR0_FC56		0
 #define MMCR0_PMAO		0
 
 #define SPRN_MMCRA		SPRN_MMCR2
@@ -870,11 +871,11 @@ static void power_pmu_disable(struct pmu
 		}
 
 		/*
-		 * Set the 'freeze counters' bit, clear PMAO.
+		 * Set the 'freeze counters' bit, clear PMAO/FC56.
 		 */
 		val  = mfspr(SPRN_MMCR0);
 		val |= MMCR0_FC;
-		val &= ~MMCR0_PMAO;
+		val &= ~(MMCR0_PMAO | MMCR0_FC56);
 
 		/*
 		 * The barrier is to make sure the mtspr has been
--- a/arch/powerpc/perf/power8-pmu.c
+++ b/arch/powerpc/perf/power8-pmu.c
@@ -391,6 +391,10 @@ static int power8_compute_mmcr(u64 event
 	if (pmc_inuse & 0x7c)
 		mmcr[0] |= MMCR0_PMCjCE;
 
+	/* If we're not using PMC 5 or 6, freeze them */
+	if (!(pmc_inuse & 0x60))
+		mmcr[0] |= MMCR0_FC56;
+
 	mmcr[1] = mmcr1;
 	mmcr[2] = mmcra;
 


