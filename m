Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab3FRMDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:03:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56018 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab3FRLoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Keir Fraser <keir.fraser@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 28/93] xen/events: Handle VIRQ_TIMER before any other hardirq in event loop.
Date: Tue, 18 Jun 2013 12:42:36 +0100
Message-Id: <1371555821-12820-29-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keir Fraser <keir.fraser@citrix.com>

commit bee980d9e9642e96351fa3ca9077b853ecf62f57 upstream.

This avoids any other hardirq handler seeing a very stale jiffies
value immediately after wakeup from a long idle period. The one
observable symptom of this was a USB keyboard, with software keyboard
repeat, which would always repeat a key immediately that it was
pressed. This is due to the key press waking the guest, the key
handler immediately runs, sees an old jiffies value, and then that
jiffies value significantly updated, before the key is unpressed.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Keir Fraser <keir.fraser@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
[ luis: backported to 3.5:
  - replaced xen_ulong_t by unsigned long ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/xen/events.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 99c5345..b5b559a 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1267,7 +1267,7 @@ static void __xen_evtchn_do_upcall(void)
 {
 	int start_word_idx, start_bit_idx;
 	int word_idx, bit_idx;
-	int i;
+	int i, irq;
 	int cpu = get_cpu();
 	struct shared_info *s = HYPERVISOR_shared_info;
 	struct vcpu_info *vcpu_info = __this_cpu_read(xen_vcpu);
@@ -1275,6 +1275,8 @@ static void __xen_evtchn_do_upcall(void)
 
 	do {
 		unsigned long pending_words;
+		unsigned long pending_bits;
+		struct irq_desc *desc;
 
 		vcpu_info->evtchn_upcall_pending = 0;
 
@@ -1285,6 +1287,17 @@ static void __xen_evtchn_do_upcall(void)
 		/* Clear master flag /before/ clearing selector flag. */
 		wmb();
 #endif
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
 		pending_words = xchg(&vcpu_info->evtchn_pending_sel, 0);
 
 		start_word_idx = __this_cpu_read(current_word_idx);
@@ -1293,7 +1306,6 @@ static void __xen_evtchn_do_upcall(void)
 		word_idx = start_word_idx;
 
 		for (i = 0; pending_words != 0; i++) {
-			unsigned long pending_bits;
 			unsigned long words;
 
 			words = MASK_LSBS(pending_words, word_idx);
@@ -1322,8 +1334,7 @@ static void __xen_evtchn_do_upcall(void)
 
 			do {
 				unsigned long bits;
-				int port, irq;
-				struct irq_desc *desc;
+				int port;
 
 				bits = MASK_LSBS(pending_bits, bit_idx);
 
-- 
1.8.1.2

