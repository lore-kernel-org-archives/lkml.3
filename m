Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539Ab3J1PGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:06:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51058 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab3J1Osu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:48:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Helge Deller <deller@gmx.de>, John David Anglin <dave.anglin@bell.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 13/64] parisc: fix interruption handler to respect pagefault_disable()
Date: Mon, 28 Oct 2013 14:47:32 +0000
Message-Id: <1382971703-17393-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 59b33f148cc08fb33cbe823fca1e34f7f023765e upstream.

Running an "echo t > /proc/sysrq-trigger" crashes the parisc kernel.  The
problem is, that in print_worker_info() we try to read the workqueue info via
the probe_kernel_read() functions which use pagefault_disable() to avoid
crashes like this:
    probe_kernel_read(&pwq, &worker->current_pwq, sizeof(pwq));
    probe_kernel_read(&wq, &pwq->wq, sizeof(wq));
    probe_kernel_read(name, wq->name, sizeof(name) - 1);

The problem here is, that the first probe_kernel_read(&pwq) might return zero
in pwq and as such the following probe_kernel_reads() try to access contents of
the page zero which is read protected and generate a kernel segfault.

With this patch we fix the interruption handler to call parisc_terminate()
directly only if pagefault_disable() was not called (in which case
preempt_count()==0).  Otherwise we hand over to the pagefault handler which
will try to look up the faulting address in the fixup tables.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: John David Anglin  <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/parisc/kernel/traps.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
index 45ba99f..71d7d72 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -810,14 +810,14 @@ void notrace handle_interruption(int code, struct pt_regs *regs)
 	else {
 
 	    /*
-	     * The kernel should never fault on its own address space.
+	     * The kernel should never fault on its own address space,
+	     * unless pagefault_disable() was called before.
 	     */
 
-	    if (fault_space == 0) 
+	    if (fault_space == 0 && !in_atomic())
 	    {
 		pdc_chassis_send_status(PDC_CHASSIS_DIRECT_PANIC);
 		parisc_terminate("Kernel Fault", regs, code, fault_address);
-	
 	    }
 	}
 
-- 
1.8.3.2

