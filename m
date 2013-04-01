Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093Ab3DAOHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 10:07:55 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34057 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757969Ab3DAOHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 10:07:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Keir Fraser <keir.fraser@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/evtchn: Handle VIRQ_TIMER before any other hardirq in event loop.
Date: Mon,  1 Apr 2013 10:07:41 -0400
Message-Id: <1364825261-25324-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keir Fraser <keir.fraser@citrix.com>

This avoids any other hardirq handler seeing a very stale jiffies
value immediately after wakeup from a long idle period. The one
observable symptom of this was a USB keyboard, with software keyboard
repeat, which would always repeat a key immediately that it was
pressed. This is due to the key press waking the guest, the key
handler immediately runs, sees an old jiffies value, and then that
jiffies value significantly updated, before the key is unpressed.

Signed-off-by: Keir Fraser <keir.fraser@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/events.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index aa85881..2647ad8 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1316,7 +1316,7 @@ static void __xen_evtchn_do_upcall(void)
 {
 	int start_word_idx, start_bit_idx;
 	int word_idx, bit_idx;
-	int i;
+	int i, irq;
 	int cpu = get_cpu();
 	struct shared_info *s = HYPERVISOR_shared_info;
 	struct vcpu_info *vcpu_info = __this_cpu_read(xen_vcpu);
@@ -1324,6 +1324,8 @@ static void __xen_evtchn_do_upcall(void)
 
 	do {
 		xen_ulong_t pending_words;
+		xen_ulong_t pending_bits;
+		struct irq_desc *desc;
 
 		vcpu_info->evtchn_upcall_pending = 0;
 
@@ -1335,6 +1337,17 @@ static void __xen_evtchn_do_upcall(void)
 		 * selector flag. xchg_xen_ulong must contain an
 		 * appropriate barrier.
 		 */
+		if ((irq = per_cpu(virq_to_irq, cpu)[VIRQ_TIMER]) != -1) {
+			int evtchn = evtchn_from_irq(irq);
+			word_idx = evtchn / BITS_PER_LONG;
+			pending_bits = evtchn % BITS_PER_LONG;
+			if (active_evtchns(cpu, s, word_idx) & (1ULL << pending_bits)) {
+				desc = irq_to_desc(irq);
+				if (desc)
+					generic_handle_irq_desc(irq, desc);
+			}
+		}
+
 		pending_words = xchg_xen_ulong(&vcpu_info->evtchn_pending_sel, 0);
 
 		start_word_idx = __this_cpu_read(current_word_idx);
@@ -1343,7 +1356,6 @@ static void __xen_evtchn_do_upcall(void)
 		word_idx = start_word_idx;
 
 		for (i = 0; pending_words != 0; i++) {
-			xen_ulong_t pending_bits;
 			xen_ulong_t words;
 
 			words = MASK_LSBS(pending_words, word_idx);
@@ -1372,8 +1384,7 @@ static void __xen_evtchn_do_upcall(void)
 
 			do {
 				xen_ulong_t bits;
-				int port, irq;
-				struct irq_desc *desc;
+				int port;
 
 				bits = MASK_LSBS(pending_bits, bit_idx);
 
-- 
1.8.0.2

