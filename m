Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbaLOO2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:28:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38735 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaLOO2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:36 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Burton <paul.burton@imgtec.com>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 108/168] MIPS: fix EVA & non-SMP non-FPU FP context signal handling
Date: Mon, 15 Dec 2014 14:26:02 +0000
Message-Id: <1418653622-21105-109-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Burton <paul.burton@imgtec.com>

commit 14fa12df1d6bc1d3389a0fa842e0ebd8e8a9af26 upstream.

The save_fp_context & restore_fp_context pointers were being assigned
to the wrong variables if either:

  - The kernel is configured for UP & runs on a system without an FPU,
    since b2ead5282885 "MIPS: Move & rename
    fpu_emulator_{save,restore}_context".

  - The kernel is configured for EVA, since ca750649e08c "MIPS: kernel:
    signal: Prevent save/restore FPU context in user memory".

This would lead to FP context being clobbered incorrectly when setting
up a sigcontext, then the garbage values being saved uselessly when
returning from the signal.

Fix by swapping the pointer assignments appropriately.

Signed-off-by: Paul Burton <paul.burton@imgtec.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/8230/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/mips/kernel/signal.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/mips/kernel/signal.c b/arch/mips/kernel/signal.c
index 9e60d117e41e..394e2b12a3ba 100644
--- a/arch/mips/kernel/signal.c
+++ b/arch/mips/kernel/signal.c
@@ -676,13 +676,13 @@ static int signal_setup(void)
 		save_fp_context = _save_fp_context;
 		restore_fp_context = _restore_fp_context;
 	} else {
-		save_fp_context = copy_fp_from_sigcontext;
-		restore_fp_context = copy_fp_to_sigcontext;
+		save_fp_context = copy_fp_to_sigcontext;
+		restore_fp_context = copy_fp_from_sigcontext;
 	}
 #endif /* CONFIG_SMP */
 #else
-	save_fp_context = copy_fp_from_sigcontext;;
-	restore_fp_context = copy_fp_to_sigcontext;
+	save_fp_context = copy_fp_to_sigcontext;
+	restore_fp_context = copy_fp_from_sigcontext;
 #endif
 
 	return 0;
-- 
2.1.3

