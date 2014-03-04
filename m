Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684AbaCDUOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:14:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932333AbaCDUFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:05:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        James Hogan <james.hogan@imgtec.com>, linux-metag@vger.kernel.org
Subject: [PATCH 3.10 84/97] irq-metag*: stop set_affinity vectoring to offline cpus
Date: Tue,  4 Mar 2014 12:04:37 -0800
Message-Id: <20140304200348.769489958@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Hogan <james.hogan@imgtec.com>

commit f229006ec6beabf7b844653d92fa61f025fe3dcf upstream.

Fix irq_set_affinity callbacks in the Meta IRQ chip drivers to AND
cpu_online_mask into the cpumask when picking a CPU to vector the
interrupt to.

As Thomas pointed out, the /proc/irq/$N/smp_affinity interface doesn't
filter out offline CPUs, so without this patch if you offline CPU0 and
set an IRQ affinity to 0x3 it vectors the interrupt onto CPU0 even
though it is offline.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-metag@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/irq-metag-ext.c |    2 +-
 drivers/irqchip/irq-metag.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/irqchip/irq-metag-ext.c
+++ b/drivers/irqchip/irq-metag-ext.c
@@ -515,7 +515,7 @@ static int meta_intc_set_affinity(struct
 	 * one cpu (the interrupt code doesn't support it), so we just
 	 * pick the first cpu we find in 'cpumask'.
 	 */
-	cpu = cpumask_any(cpumask);
+	cpu = cpumask_any_and(cpumask, cpu_online_mask);
 	thread = cpu_2_hwthread_id[cpu];
 
 	metag_out32(TBI_TRIG_VEC(TBID_SIGNUM_TR2(thread)), vec_addr);
--- a/drivers/irqchip/irq-metag.c
+++ b/drivers/irqchip/irq-metag.c
@@ -201,7 +201,7 @@ static int metag_internal_irq_set_affini
 	 * one cpu (the interrupt code doesn't support it), so we just
 	 * pick the first cpu we find in 'cpumask'.
 	 */
-	cpu = cpumask_any(cpumask);
+	cpu = cpumask_any_and(cpumask, cpu_online_mask);
 	thread = cpu_2_hwthread_id[cpu];
 
 	metag_out32(TBI_TRIG_VEC(TBID_SIGNUM_TR1(thread)),


