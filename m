Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbaIKMje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:39:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51683 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755455AbaIKMeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:09 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David Vrabel" <david.vrabel@citrix.com>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.279914844@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 060/131] x86/xen: resume timer irqs early
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit 8d5999df35314607c38fbd6bdd709e25c3a4eeab upstream.

If the timer irqs are resumed during device resume it is possible in
certain circumstances for the resume to hang early on, before device
interrupts are resumed.  For an Ubuntu 14.04 PVHVM guest this would
occur in ~0.5% of resume attempts.

It is not entirely clear what is occuring the point of the hang but I
think a task necessary for the resume calls schedule_timeout(),
waiting for a timer interrupt (which never arrives).  This failure may
require specific tasks to be running on the other VCPUs to trigger
(processes are not frozen during a suspend/resume if PREEMPT is
disabled).

Add IRQF_EARLY_RESUME to the timer interrupts so they are resumed in
syscore_resume().

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/xen/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -397,7 +397,7 @@ void xen_setup_timer(int cpu)
 	irq = bind_virq_to_irqhandler(VIRQ_TIMER, cpu, xen_timer_interrupt,
 				      IRQF_DISABLED|IRQF_PERCPU|
 				      IRQF_NOBALANCING|IRQF_TIMER|
-				      IRQF_FORCE_RESUME,
+				      IRQF_FORCE_RESUME|IRQF_EARLY_RESUME,
 				      name, NULL);
 
 	evt = &per_cpu(xen_clock_events, cpu);

