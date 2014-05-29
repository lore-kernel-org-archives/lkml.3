Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934693AbaE2FhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:37:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57690 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225AbaE2Ee4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:34:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vladimir Murzin <murzin.v@gmail.com>,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH 3.14 026/140] xen/events/fifo: correctly align bitops
Date: Wed, 28 May 2014 21:32:45 -0700
Message-Id: <20140529043052.740955605@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Murzin <murzin.v@gmail.com>

commit 05a812ac474d0d6aef6d54b66bb08b81abde79c6 upstream.

FIFO event channels require bitops on 32-bit aligned values (the event
words).  Linux's bitops require unsigned long alignment which may be
64-bits.

On arm64 an incorrectly unaligned access will fault.

Fix this by aligning the bitops along with an adjustment for bit
position and using an unsigned long for the local copy of the ready
word.

Signed-off-by: Vladimir Murzin <murzin.v@gmail.com>
Tested-by: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Reviewed-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/events/events_fifo.c |   41 ++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

--- a/drivers/xen/events/events_fifo.c
+++ b/drivers/xen/events/events_fifo.c
@@ -66,7 +66,22 @@ static DEFINE_PER_CPU(struct evtchn_fifo
 static event_word_t *event_array[MAX_EVENT_ARRAY_PAGES] __read_mostly;
 static unsigned event_array_pages __read_mostly;
 
+/*
+ * sync_set_bit() and friends must be unsigned long aligned on non-x86
+ * platforms.
+ */
+#if !defined(CONFIG_X86) && BITS_PER_LONG > 32
+
+#define BM(w) (unsigned long *)((unsigned long)w & ~0x7UL)
+#define EVTCHN_FIFO_BIT(b, w) \
+    (((unsigned long)w & 0x4UL) ? (EVTCHN_FIFO_ ##b + 32) : EVTCHN_FIFO_ ##b)
+
+#else
+
 #define BM(w) ((unsigned long *)(w))
+#define EVTCHN_FIFO_BIT(b, w) EVTCHN_FIFO_ ##b
+
+#endif
 
 static inline event_word_t *event_word_from_port(unsigned port)
 {
@@ -161,33 +176,38 @@ static void evtchn_fifo_bind_to_cpu(stru
 static void evtchn_fifo_clear_pending(unsigned port)
 {
 	event_word_t *word = event_word_from_port(port);
-	sync_clear_bit(EVTCHN_FIFO_PENDING, BM(word));
+	sync_clear_bit(EVTCHN_FIFO_BIT(PENDING, word), BM(word));
 }
 
 static void evtchn_fifo_set_pending(unsigned port)
 {
 	event_word_t *word = event_word_from_port(port);
-	sync_set_bit(EVTCHN_FIFO_PENDING, BM(word));
+	sync_set_bit(EVTCHN_FIFO_BIT(PENDING, word), BM(word));
 }
 
 static bool evtchn_fifo_is_pending(unsigned port)
 {
 	event_word_t *word = event_word_from_port(port);
-	return sync_test_bit(EVTCHN_FIFO_PENDING, BM(word));
+	return sync_test_bit(EVTCHN_FIFO_BIT(PENDING, word), BM(word));
 }
 
 static bool evtchn_fifo_test_and_set_mask(unsigned port)
 {
 	event_word_t *word = event_word_from_port(port);
-	return sync_test_and_set_bit(EVTCHN_FIFO_MASKED, BM(word));
+	return sync_test_and_set_bit(EVTCHN_FIFO_BIT(MASKED, word), BM(word));
 }
 
 static void evtchn_fifo_mask(unsigned port)
 {
 	event_word_t *word = event_word_from_port(port);
-	sync_set_bit(EVTCHN_FIFO_MASKED, BM(word));
+	sync_set_bit(EVTCHN_FIFO_BIT(MASKED, word), BM(word));
 }
 
+static bool evtchn_fifo_is_masked(unsigned port)
+{
+	event_word_t *word = event_word_from_port(port);
+	return sync_test_bit(EVTCHN_FIFO_BIT(MASKED, word), BM(word));
+}
 /*
  * Clear MASKED, spinning if BUSY is set.
  */
@@ -211,7 +231,7 @@ static void evtchn_fifo_unmask(unsigned
 	BUG_ON(!irqs_disabled());
 
 	clear_masked(word);
-	if (sync_test_bit(EVTCHN_FIFO_PENDING, BM(word))) {
+	if (evtchn_fifo_is_pending(port)) {
 		struct evtchn_unmask unmask = { .port = port };
 		(void)HYPERVISOR_event_channel_op(EVTCHNOP_unmask, &unmask);
 	}
@@ -247,7 +267,7 @@ static void handle_irq_for_port(unsigned
 
 static void consume_one_event(unsigned cpu,
 			      struct evtchn_fifo_control_block *control_block,
-			      unsigned priority, uint32_t *ready)
+			      unsigned priority, unsigned long *ready)
 {
 	struct evtchn_fifo_queue *q = &per_cpu(cpu_queue, cpu);
 	uint32_t head;
@@ -277,10 +297,9 @@ static void consume_one_event(unsigned c
 	 * copy of the ready word.
 	 */
 	if (head == 0)
-		clear_bit(priority, BM(ready));
+		clear_bit(priority, ready);
 
-	if (sync_test_bit(EVTCHN_FIFO_PENDING, BM(word))
-	    && !sync_test_bit(EVTCHN_FIFO_MASKED, BM(word)))
+	if (evtchn_fifo_is_pending(port) && !evtchn_fifo_is_masked(port))
 		handle_irq_for_port(port);
 
 	q->head[priority] = head;
@@ -289,7 +308,7 @@ static void consume_one_event(unsigned c
 static void evtchn_fifo_handle_events(unsigned cpu)
 {
 	struct evtchn_fifo_control_block *control_block;
-	uint32_t ready;
+	unsigned long ready;
 	unsigned q;
 
 	control_block = per_cpu(cpu_control_block, cpu);


