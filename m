Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbaICJ5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:57:18 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57394 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932184AbaICJ5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:57:14 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Vrabel <david.vrabel@citrix.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 55/56] x86/xen: resume timer irqs early
Date: Wed,  3 Sep 2014 11:27:14 +0200
Message-Id: <b15a46084b814a29038739c27b78977637354602.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/xen/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index ee365895b06b..90bfa524b11c 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -445,7 +445,7 @@ void xen_setup_timer(int cpu)
 	irq = bind_virq_to_irqhandler(VIRQ_TIMER, cpu, xen_timer_interrupt,
 				      IRQF_DISABLED|IRQF_PERCPU|
 				      IRQF_NOBALANCING|IRQF_TIMER|
-				      IRQF_FORCE_RESUME,
+				      IRQF_FORCE_RESUME|IRQF_EARLY_RESUME,
 				      name, NULL);
 
 	memcpy(evt, xen_clockevent, sizeof(*evt));
-- 
2.1.0

