Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbaIOT11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:27:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024AbaIOT1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Smith <alex@alex-smith.me.uk>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 3.16 064/158] MIPS: ptrace: Avoid smp_processor_id() when retrieving FPU IR
Date: Mon, 15 Sep 2014 12:25:03 -0700
Message-Id: <20140915192544.816172080@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Smith <alex@alex-smith.me.uk>

commit 656ff9bef08c19a6471b49528dacb4cbbeb1e537 upstream.

Whenever ptrace attempts to retrieve the FPU implementation register it
accesses it through current_cpu_data, which calls smp_processor_id().
Since the code may execute with preemption enabled, this can trigger
a warning. Fix this by using boot_cpu_data to get the IR instead.

Signed-off-by: Alex Smith <alex@alex-smith.me.uk>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/7449/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/ptrace.c   |    4 ++--
 arch/mips/kernel/ptrace32.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -129,7 +129,7 @@ int ptrace_getfpregs(struct task_struct
 	}
 
 	__put_user(child->thread.fpu.fcr31, data + 64);
-	__put_user(current_cpu_data.fpu_id, data + 65);
+	__put_user(boot_cpu_data.fpu_id, data + 65);
 
 	return 0;
 }
@@ -611,7 +611,7 @@ long arch_ptrace(struct task_struct *chi
 			break;
 		case FPC_EIR:
 			/* implementation / version register */
-			tmp = current_cpu_data.fpu_id;
+			tmp = boot_cpu_data.fpu_id;
 			break;
 		case DSP_BASE ... DSP_BASE + 5: {
 			dspreg_t *dregs;
--- a/arch/mips/kernel/ptrace32.c
+++ b/arch/mips/kernel/ptrace32.c
@@ -129,7 +129,7 @@ long compat_arch_ptrace(struct task_stru
 			break;
 		case FPC_EIR:
 			/* implementation / version register */
-			tmp = current_cpu_data.fpu_id;
+			tmp = boot_cpu_data.fpu_id;
 			break;
 		case DSP_BASE ... DSP_BASE + 5: {
 			dspreg_t *dregs;


