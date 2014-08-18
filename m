Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaHRJvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:51:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42876 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbaHRJfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:35:31 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 084/137] powerpc/perf: Fix MMCR2 handling for EBB
Date: Mon, 18 Aug 2014 10:32:25 +0100
Message-Id: <1408354398-10226-85-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

commit 8903461c9bc56fcb041fb92d054e2529951770b6 upstream.

In the recent commit b50a6c584bb4 "Clear MMCR2 when enabling PMU", I
screwed up the handling of MMCR2 for tasks using EBB.

We must make sure we set MMCR2 *before* ebb_switch_in(), otherwise we
overwrite the value of MMCR2 that userspace may have written. That
potentially breaks a task that uses EBB and manually uses MMCR2 for
event freezing.

Fixes: b50a6c584bb4 ("powerpc/perf: Clear MMCR2 when enabling PMU")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/perf/core-book3s.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index c05f10e95a9e..d5d7adf6dc50 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -1159,14 +1159,14 @@ static void power_pmu_enable(struct pmu *pmu)
 	cpuhw->mmcr[0] |= MMCR0_PMXE | MMCR0_FCECE;
 
  out_enable:
+	if (ppmu->flags & PPMU_ARCH_207S)
+		mtspr(SPRN_MMCR2, 0);
+
 	mmcr0 = ebb_switch_in(ebb, cpuhw->mmcr[0]);
 
 	mb();
 	write_mmcr0(cpuhw, mmcr0);
 
-	if (ppmu->flags & PPMU_ARCH_207S)
-		mtspr(SPRN_MMCR2, 0);
-
 	/*
 	 * Enable instruction sampling if necessary
 	 */
-- 
1.9.1

