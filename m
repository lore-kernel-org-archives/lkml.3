Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751099AbaHaFnz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 01:43:55 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:1855 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750837AbaHaFny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 01:43:54 -0400
From: Leo Yan <leoy@marvell.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Leo Yan <leoy@marvell.com>
Subject: [PATCH v1] arm64: fix bug for reloading FPSIMD state after cpu power off
Date: Sun, 31 Aug 2014 13:39:51 +0800
Message-ID: <1409463591-661-1-git-send-email-leoy@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-31_02:2014-08-29,2014-08-31,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1408310074
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now arm64 defers reloading FPSIMD state, but this optimization also
introduces the bug after cpu resume back from low power mode.

The reason is after the cpu has been powered off, s/w need set the
cpu's fpsimd_last_state to NULL so that it will force to reload
FPSIMD state for the thread, otherwise there has the chance to meet
the condition for both the task's fpsimd_state.cpu field contains the
id of the current cpu, and the cpu's fpsimd_last_state per-cpu variable
points to the task's fpsimd_state, so finally kernel will skip to reload
the context during it return back to userland.

Furthermore, this patch also removes the redundant operation for saving
the state for idle thread; this operation is needless due kernel's idle
thread will not use any VFP/NEON instruction. so that this also can
benefit a bit for the latency during cpu's power off.

Signed-off-by: Leo Yan <leoy@marvell.com>
---
 arch/arm64/kernel/fpsimd.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index ad8aebb..4caef93 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -268,13 +268,9 @@ static int fpsimd_cpu_pm_notifier(struct notifier_block *self,
 {
 	switch (cmd) {
 	case CPU_PM_ENTER:
-		if (current->mm && !test_thread_flag(TIF_FOREIGN_FPSTATE))
-			fpsimd_save_state(&current->thread.fpsimd_state);
+		this_cpu_write(fpsimd_last_state, NULL);
 		break;
 	case CPU_PM_EXIT:
-		if (current->mm)
-			set_thread_flag(TIF_FOREIGN_FPSTATE);
-		break;
 	case CPU_PM_ENTER_FAILED:
 	default:
 		return NOTIFY_DONE;
-- 
1.9.1

