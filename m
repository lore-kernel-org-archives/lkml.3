Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbaICXCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:02:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933862AbaICWSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 3.16 081/125] x86/xen: resume timer irqs early
Date: Wed,  3 Sep 2014 15:07:18 -0700
Message-Id: <20140903220626.102604805@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -444,7 +444,7 @@ void xen_setup_timer(int cpu)
 
 	irq = bind_virq_to_irqhandler(VIRQ_TIMER, cpu, xen_timer_interrupt,
 				      IRQF_PERCPU|IRQF_NOBALANCING|IRQF_TIMER|
-				      IRQF_FORCE_RESUME,
+				      IRQF_FORCE_RESUME|IRQF_EARLY_RESUME,
 				      name, NULL);
 	(void)xen_set_irq_priority(irq, XEN_IRQ_PRIORITY_MAX);
 


