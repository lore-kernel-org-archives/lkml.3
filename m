Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab3KYN7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:59:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58964 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753891Ab3KYNxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:55 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "John David Anglin" <dave.anglin@bell.net>,
        "Helge Deller" <deller@gmx.de>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.370888551@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 65/87] parisc: fix interruption handler to respect
 pagefault_disable()
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/parisc/kernel/traps.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -811,14 +811,14 @@ void notrace handle_interruption(int cod
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
 

