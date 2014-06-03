Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbaFCT4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 15:56:22 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:52329 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251AbaFCT4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 15:56:20 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnsOAJMljlNbsmtf/2dsb2JhbABZgweBJ6o3BAMBAQEFAZgcgQ4XdIJTLyOBGjeIRgHRHReFVYh9hEcEj0uKP4sdiBaBeIFCOy8
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH V2 1/2] drivers/s390/cio/qdio_main.c: use unsigned int for count everywhere
Date: Tue,  3 Jun 2014 21:54:48 +0200
Message-Id: <1401825288-5766-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

count was used unsigned int and int.

Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
This is untested.

V2:
   -count int -> unsigned int (suggested by Joe Perches)

 drivers/s390/cio/qdio_main.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 77466c4..9fda160 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -124,10 +124,11 @@ static inline int qdio_check_ccq(struct qdio_q *q, unsigned int ccq)
  * Stops processing if a state is different from the last buffers state.
  */
 static int qdio_do_eqbs(struct qdio_q *q, unsigned char *state,
-			int start, int count, int auto_ack)
+			int start, unsigned int count, int auto_ack)
 {
-	int rc, tmp_count = count, tmp_start = start, nr = q->nr, retried = 0;
+	int rc, tmp_start = start, nr = q->nr, retried = 0;
 	unsigned int ccq = 0;
+	unsigned tmp_count = count;
 
 	qperf_inc(q, eqbs);
 
@@ -178,10 +179,11 @@ again:
  * error occurs.
  */
 static int qdio_do_sqbs(struct qdio_q *q, unsigned char state, int start,
-			int count)
+			unsigned int count)
 {
 	unsigned int ccq = 0;
-	int tmp_count = count, tmp_start = start;
+	unsigned int tmp_count = count;
+	int tmp_start = start;
 	int nr = q->nr;
 	int rc;
 
@@ -247,7 +249,7 @@ static inline int get_buf_state(struct qdio_q *q, unsigned int bufnr,
 
 /* wrap-around safe setting of slsb states, returns number of changed buffers */
 static inline int set_buf_states(struct qdio_q *q, int bufnr,
-				 unsigned char state, int count)
+				 unsigned char state, unsigned int count)
 {
 	int i;
 
@@ -409,7 +411,7 @@ static inline void qdio_stop_polling(struct qdio_q *q)
 		set_buf_state(q, q->u.in.ack_start, SLSB_P_INPUT_NOT_INIT);
 }
 
-static inline void account_sbals(struct qdio_q *q, int count)
+static inline void account_sbals(struct qdio_q *q, unsigned int count)
 {
 	int pos = 0;
 
@@ -423,7 +425,7 @@ static inline void account_sbals(struct qdio_q *q, int count)
 	q->q_stats.nr_sbals[pos]++;
 }
 
-static void process_buffer_error(struct qdio_q *q, int count)
+static void process_buffer_error(struct qdio_q *q, unsigned int count)
 {
 	unsigned char state = (q->is_input_q) ? SLSB_P_INPUT_NOT_INIT :
 					SLSB_P_OUTPUT_NOT_INIT;
@@ -454,7 +456,7 @@ set:
 	set_buf_states(q, q->first_to_check, state, count);
 }
 
-static inline void inbound_primed(struct qdio_q *q, int count)
+static inline void inbound_primed(struct qdio_q *q, unsigned int count)
 {
 	int new;
 
@@ -501,7 +503,8 @@ static inline void inbound_primed(struct qdio_q *q, int count)
 
 static int get_inbound_buffer_frontier(struct qdio_q *q)
 {
-	int count, stop;
+	unsigned int count;
+	int stop;
 	unsigned char state = 0;
 
 	q->timestamp = get_tod_clock_fast();
@@ -608,7 +611,7 @@ static inline int contains_aobs(struct qdio_q *q)
 	return !q->is_input_q && q->u.out.use_cq;
 }
 
-static inline void qdio_handle_aobs(struct qdio_q *q, int start, int count)
+static inline void qdio_handle_aobs(struct qdio_q *q, int start, unsigned int count)
 {
 	unsigned char state = 0;
 	int j, b = start;
@@ -661,7 +664,7 @@ static void qdio_kick_handler(struct qdio_q *q)
 {
 	int start = q->first_to_kick;
 	int end = q->first_to_check;
-	int count;
+	unsigned int count;
 
 	if (unlikely(q->irq_ptr->state != QDIO_IRQ_STATE_ACTIVE))
 		return;
@@ -725,7 +728,8 @@ void qdio_inbound_processing(unsigned long data)
 
 static int get_outbound_buffer_frontier(struct qdio_q *q)
 {
-	int count, stop;
+	int stop;
+	unsigned int count;
 	unsigned char state = 0;
 
 	q->timestamp = get_tod_clock_fast();
@@ -1013,7 +1017,7 @@ static void qdio_handle_activate_check(struct ccw_device *cdev,
 {
 	struct qdio_irq *irq_ptr = cdev->private->qdio_data;
 	struct qdio_q *q;
-	int count;
+	unsigned int count;
 
 	DBF_ERROR("%4x ACT CHECK", irq_ptr->schid.sch_no);
 	DBF_ERROR("intp :%lx", intparm);
@@ -1468,7 +1472,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(qdio_activate);
 
-static inline int buf_in_between(int bufnr, int start, int count)
+static inline int buf_in_between(int bufnr, int start, unsigned int count)
 {
 	int end = add_buf(start, count);
 
-- 
1.8.4.5

