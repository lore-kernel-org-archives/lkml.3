Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaIADOI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 23:14:08 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:10010 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751681AbaIADOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 23:14:06 -0400
From: Leo Yan <leoy@marvell.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <catalin.marinas@arm.com>, <ard.biesheuvel@linaro.org>
CC: Leo Yan <leoy@marvell.com>
Subject: [PATCH v2] arm64: fix bug for reloading FPSIMD state after cpu power off
Date: Mon, 1 Sep 2014 11:09:51 +0800
Message-ID: <1409540991-7573-1-git-send-email-leoy@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-09-01_01:2014-08-29,2014-08-31,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1409010040
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

Signed-off-by: Leo Yan <leoy@marvell.com>
---
 arch/arm64/kernel/fpsimd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index ad8aebb..3dca156 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -270,6 +270,7 @@ static int fpsimd_cpu_pm_notifier(struct notifier_block *self,
 	case CPU_PM_ENTER:
 		if (current->mm && !test_thread_flag(TIF_FOREIGN_FPSTATE))
 			fpsimd_save_state(&current->thread.fpsimd_state);
+		this_cpu_write(fpsimd_last_state, NULL);
 		break;
 	case CPU_PM_EXIT:
 		if (current->mm)
-- 
1.9.1

