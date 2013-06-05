Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab3FEVQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:16:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932604Ab3FEVNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:13:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Keir Fraser <keir.fraser@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 37/44] xen/events: Handle VIRQ_TIMER before any other hardirq in event loop.
Date: Wed,  5 Jun 2013 14:12:35 -0700
Message-Id: <20130605211225.711463237@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605211221.858177087@linuxfoundation.org>
References: <20130605211221.858177087@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/events.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1258,7 +1258,7 @@ static void __xen_evtchn_do_upcall(void)
 {
 	int start_word_idx, start_bit_idx;
 	int word_idx, bit_idx;
-	int i;
+	int i, irq;
 	int cpu = get_cpu();
 	struct shared_info *s = HYPERVISOR_shared_info;
 	struct vcpu_info *vcpu_info = __this_cpu_read(xen_vcpu);
@@ -1266,6 +1266,8 @@ static void __xen_evtchn_do_upcall(void)
 
 	do {
 		unsigned long pending_words;
+		unsigned long pending_bits;
+		struct irq_desc *desc;
 
 		vcpu_info->evtchn_upcall_pending = 0;
 
@@ -1276,6 +1278,17 @@ static void __xen_evtchn_do_upcall(void)
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
@@ -1284,7 +1297,6 @@ static void __xen_evtchn_do_upcall(void)
 		word_idx = start_word_idx;
 
 		for (i = 0; pending_words != 0; i++) {
-			unsigned long pending_bits;
 			unsigned long words;
 
 			words = MASK_LSBS(pending_words, word_idx);
@@ -1313,8 +1325,7 @@ static void __xen_evtchn_do_upcall(void)
 
 			do {
 				unsigned long bits;
-				int port, irq;
-				struct irq_desc *desc;
+				int port;
 
 				bits = MASK_LSBS(pending_bits, bit_idx);
 


