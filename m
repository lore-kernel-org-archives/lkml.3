Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640AbaHHVc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:32:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40630 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758063AbaHHUr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:47:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 184/259] powerpc/perf: Fix MMCR2 handling for EBB
Date: Fri,  8 Aug 2014 13:40:07 -0700
Message-Id: <1407530482-4483-185-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/perf/core-book3s.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 57a8ff9..36a8bdd 100644
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

