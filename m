Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab3F1TOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:14:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41681 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab3F1SzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:55:05 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Keir Fraser <keir.fraser@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 031/105] xen/events: Handle VIRQ_TIMER before any other hardirq in event loop.
Date: Fri, 28 Jun 2013 11:50:53 -0700
Message-Id: <1372445527-24414-32-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/xen/events.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 8aa3867..7ae3821 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1298,7 +1298,7 @@ static void __xen_evtchn_do_upcall(void)
 {
 	int start_word_idx, start_bit_idx;
 	int word_idx, bit_idx;
-	int i;
+	int i, irq;
 	int cpu = get_cpu();
 	struct shared_info *s = HYPERVISOR_shared_info;
 	struct vcpu_info *vcpu_info = __this_cpu_read(xen_vcpu);
@@ -1306,6 +1306,8 @@ static void __xen_evtchn_do_upcall(void)
 
 	do {
 		unsigned long pending_words;
+		unsigned long pending_bits;
+		struct irq_desc *desc;
 
 		vcpu_info->evtchn_upcall_pending = 0;
 
@@ -1316,6 +1318,17 @@ static void __xen_evtchn_do_upcall(void)
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
@@ -1324,7 +1337,6 @@ static void __xen_evtchn_do_upcall(void)
 		word_idx = start_word_idx;
 
 		for (i = 0; pending_words != 0; i++) {
-			unsigned long pending_bits;
 			unsigned long words;
 
 			words = MASK_LSBS(pending_words, word_idx);
@@ -1353,8 +1365,7 @@ static void __xen_evtchn_do_upcall(void)
 
 			do {
 				unsigned long bits;
-				int port, irq;
-				struct irq_desc *desc;
+				int port;
 
 				bits = MASK_LSBS(pending_bits, bit_idx);
 
-- 
1.8.1.2

