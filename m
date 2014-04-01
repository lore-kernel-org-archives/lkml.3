Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaDALRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:17:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42359 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaDALRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:17:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Neuling <mikey@neuling.org>,
        Adhemerval Zanella Neto <azanella@br.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 056/144] powerpc/tm: Fix crash when forking inside a transaction
Date: Tue,  1 Apr 2014 12:14:20 +0100
Message-Id: <1396350948-29910-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit 621b5060e823301d0cba4cb52a7ee3491922d291 upstream.

When we fork/clone we currently don't copy any of the TM state to the new
thread.  This results in a TM bad thing (program check) when the new process is
switched in as the kernel does a tmrechkpt with TEXASR FS not set.  Also, since
R1 is from userspace, we trigger the bad kernel stack pointer detection.  So we
end up with something like this:

   Bad kernel stack pointer 0 at c0000000000404fc
   cpu 0x2: Vector: 700 (Program Check) at [c00000003ffefd40]
       pc: c0000000000404fc: restore_gprs+0xc0/0x148
       lr: 0000000000000000
       sp: 0
      msr: 9000000100201030
     current = 0xc000001dd1417c30
     paca    = 0xc00000000fe00800   softe: 0        irq_happened: 0x01
       pid   = 0, comm = swapper/2
   WARNING: exception is not recoverable, can't continue

The below fixes this by flushing the TM state before we copy the task_struct to
the clone.  To do this we go through the tmreclaim patch, which removes the
checkpointed registers from the CPU and transitions the CPU out of TM suspend
mode.  Hence we need to call tmrechkpt after to restore the checkpointed state
and the TM mode for the current task.

To make this fail from userspace is simply:
	tbegin
	li	r0, 2
	sc
	<boom>

Kudos to Adhemerval Zanella Neto for finding this.

Signed-off-by: Michael Neuling <mikey@neuling.org>
cc: Adhemerval Zanella Neto <azanella@br.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/process.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 8083be2..273e9ab 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -926,6 +926,15 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 	flush_altivec_to_thread(src);
 	flush_vsx_to_thread(src);
 	flush_spe_to_thread(src);
+	/*
+	 * Flush TM state out so we can copy it.  __switch_to_tm() does this
+	 * flush but it removes the checkpointed state from the current CPU and
+	 * transitions the CPU out of TM mode.  Hence we need to call
+	 * tm_recheckpoint_new_task() (on the same task) to restore the
+	 * checkpointed state back and the TM mode.
+	 */
+	__switch_to_tm(src);
+	tm_recheckpoint_new_task(src);
 
 	*dst = *src;
 
-- 
1.9.1

