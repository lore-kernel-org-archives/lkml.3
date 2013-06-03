Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab3FCMCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 08:02:43 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40072 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3FCMCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 08:02:41 -0400
Date: Mon, 3 Jun 2013 08:02:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Please backport bee980d9e9642e96351fa3ca9077b853ecf62f57
 (xen/events: Handle VIRQ_TIMER before any other hardirq in event loop.) to
 earlier kernels v3.8...and so on
Message-ID: <20130603120232.GA6893@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Greg,

I hadn't (by mistake) put the CC: stable@vger.kernel.org on said patch
(Which is in the Linux kernel).

If possible please back-port said patch to the existing stable trees.
Attached is a version that applies to some of the earlier trees easily.


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-xen-events-Handle-VIRQ_TIMER-before-any-other-hardir.patch"

>From e525951e780c533209b0102ad91de6acc46db6b2 Mon Sep 17 00:00:00 2001
From: Keir Fraser <keir.fraser@citrix.com>
Date: Thu, 28 Mar 2013 10:03:36 -0400
Subject: [PATCH] xen/events: Handle VIRQ_TIMER before any other hardirq in
 event loop.

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
(cherry picked from commit bee980d9e9642e96351fa3ca9077b853ecf62f57)
---
 drivers/xen/events.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 74d77df..0f1d1ba 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1288,7 +1288,7 @@ static void __xen_evtchn_do_upcall(void)
 {
 	int start_word_idx, start_bit_idx;
 	int word_idx, bit_idx;
-	int i;
+	int i, irq;
 	int cpu = get_cpu();
 	struct shared_info *s = HYPERVISOR_shared_info;
 	struct vcpu_info *vcpu_info = __this_cpu_read(xen_vcpu);
@@ -1296,6 +1296,8 @@ static void __xen_evtchn_do_upcall(void)
 
 	do {
 		unsigned long pending_words;
+		unsigned long pending_bits;
+		struct irq_desc *desc;
 
 		vcpu_info->evtchn_upcall_pending = 0;
 
@@ -1306,6 +1308,17 @@ static void __xen_evtchn_do_upcall(void)
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
@@ -1314,7 +1327,6 @@ static void __xen_evtchn_do_upcall(void)
 		word_idx = start_word_idx;
 
 		for (i = 0; pending_words != 0; i++) {
-			unsigned long pending_bits;
 			unsigned long words;
 
 			words = MASK_LSBS(pending_words, word_idx);
@@ -1343,8 +1355,7 @@ static void __xen_evtchn_do_upcall(void)
 
 			do {
 				unsigned long bits;
-				int port, irq;
-				struct irq_desc *desc;
+				int port;
 
 				bits = MASK_LSBS(pending_bits, bit_idx);
 
-- 
1.8.1.4


--Qxx1br4bt0+wmkIi--
