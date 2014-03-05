Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbaCEOdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:33:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41272 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757707AbaCEO1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:27:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: James Hogan <james.hogan@imgtec.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-metag@vger.kernel.org,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 114/131] irq-metag*: stop set_affinity vectoring to offline cpus
Date: Wed,  5 Mar 2014 14:23:58 +0000
Message-Id: <1394029455-23128-115-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/irqchip/irq-metag-ext.c | 2 +-
 drivers/irqchip/irq-metag.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-metag-ext.c b/drivers/irqchip/irq-metag-ext.c
index 92c41ab..2cb474a 100644
--- a/drivers/irqchip/irq-metag-ext.c
+++ b/drivers/irqchip/irq-metag-ext.c
@@ -515,7 +515,7 @@ static int meta_intc_set_affinity(struct irq_data *data,
 	 * one cpu (the interrupt code doesn't support it), so we just
 	 * pick the first cpu we find in 'cpumask'.
 	 */
-	cpu = cpumask_any(cpumask);
+	cpu = cpumask_any_and(cpumask, cpu_online_mask);
 	thread = cpu_2_hwthread_id[cpu];
 
 	metag_out32(TBI_TRIG_VEC(TBID_SIGNUM_TR2(thread)), vec_addr);
diff --git a/drivers/irqchip/irq-metag.c b/drivers/irqchip/irq-metag.c
index 8e94d7a..c16c186 100644
--- a/drivers/irqchip/irq-metag.c
+++ b/drivers/irqchip/irq-metag.c
@@ -201,7 +201,7 @@ static int metag_internal_irq_set_affinity(struct irq_data *data,
 	 * one cpu (the interrupt code doesn't support it), so we just
 	 * pick the first cpu we find in 'cpumask'.
 	 */
-	cpu = cpumask_any(cpumask);
+	cpu = cpumask_any_and(cpumask, cpu_online_mask);
 	thread = cpu_2_hwthread_id[cpu];
 
 	metag_out32(TBI_TRIG_VEC(TBID_SIGNUM_TR1(thread)),
-- 
1.9.0

