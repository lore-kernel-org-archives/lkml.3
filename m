Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab3JRTxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 15:53:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54754 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570Ab3JRTwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 15:52:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Helge Deller <deller@gmx.de>, John David Anglin <dave.anglin@bell.net>
Subject: [ 07/11] parisc: fix interruption handler to respect pagefault_disable()
Date: Fri, 18 Oct 2013 12:53:36 -0700
Message-Id: <20131018195049.569779370@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131018195049.069623827@linuxfoundation.org>
References: <20131018195049.069623827@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/kernel/traps.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -810,14 +810,14 @@ void notrace handle_interruption(int cod
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
 


