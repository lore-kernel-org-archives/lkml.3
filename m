Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbaIOWT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:19:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51169 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933057AbaIOWTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:19:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Vrabel <david.vrabel@citrix.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 176/187] x86/xen: resume timer irqs early
Date: Mon, 15 Sep 2014 15:09:46 -0700
Message-Id: <1410818997-9432-177-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/xen/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 12a1ca7..f314067 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -444,7 +444,7 @@ void xen_setup_timer(int cpu)
 
 	irq = bind_virq_to_irqhandler(VIRQ_TIMER, cpu, xen_timer_interrupt,
 				      IRQF_PERCPU|IRQF_NOBALANCING|IRQF_TIMER|
-				      IRQF_FORCE_RESUME,
+				      IRQF_FORCE_RESUME|IRQF_EARLY_RESUME,
 				      name, NULL);
 
 	memcpy(evt, xen_clockevent, sizeof(*evt));
-- 
1.9.1

