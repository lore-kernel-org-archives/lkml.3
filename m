Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbaEIJNb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:13:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042AbaEIJN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:13:29 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kay Sievers <kay@vrfy.org>, Jiri Kosina <jkosina@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [RFC PATCH 04/11] printk: add NMI ring and cont buffers
Date: Fri,  9 May 2014 11:10:58 +0200
Message-Id: <1399626665-29817-5-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
References: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is another preparation patch for NMI safe printk implementation.
It adds a new ring and cont buffers to temporary store messages printed
from NMI context. They are used when the logbuf_lock for the main ring
buffer is already held.

Unfortunately, we need to store the index and the sequence number into
a single "unsigned log". I did not find any better way how to keep them
consistent. Both values are modified when new messages are added in
the NMI context. They are read when the messages are copied to the main
log buffer in the normal context. These two operations cannot be guarded
by a common lock because it would cause the original deadlock.

Anyway, this patch adds a bunch of macros that do the needed bit operations.
It also extends the existing "set/get" functions so that the access will
be transparent.

The ring buffer is allocated during early initialization such as log_buf.
It shares the same length for now but it will get improved in a later patch.

Also it updates messages that are printed when resizing the main ring buffer.
It makes them more explanatory and consistent with the message from the NMI
log buffer.

This patch does not change the existing behavior, except for the printed
messages. The logic for using the NMI buffer will be added in followup patches.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 104 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 91 insertions(+), 13 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index d64533f9e6b2..e8d0df2d3e01 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -265,6 +265,16 @@ struct printk_main_log_pos {
 	u32 next_idx;		/* index of the next record to store */
 };
 
+/*
+ * The "id" has to be read and written atomically. But we do not need other
+ * atomic operations. The value has to be as big as possible. Therefore we
+ * use unsigned long.
+ */
+struct printk_nmi_log_pos {
+	unsigned long first_id;
+	unsigned long next_id;
+};
+
 /* information needed to manipulate the log buffer */
 struct printk_log {
 	struct printk_cont *cont;	/* merging continuous message */
@@ -272,6 +282,7 @@ struct printk_log {
 	u32 buf_len;			/* size of the ring buffer */
 	union {
 		struct printk_main_log_pos main;
+		struct printk_nmi_log_pos nmi;
 	};
 };
 
@@ -304,16 +315,53 @@ static u32 clear_idx;
 #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
 static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char __main_cont_buf[LOG_LINE_MAX];
+static char __nmi_cont_buf[LOG_LINE_MAX];
 
 static struct printk_cont main_cont = {
 	.buf = __main_cont_buf,
 };
 
+static struct printk_cont nmi_cont = {
+	.buf = __nmi_cont_buf,
+};
+
 static struct printk_log main_log = {
 	.buf = __log_buf,
 	.buf_len = __LOG_BUF_LEN,
 	.cont = &main_cont,
 };
+/*
+ * NMI ring buffer must be used if we are in NMI context and the lock for
+ * the main buffer is already in use by code that has been interrupted.
+ * The content of the NMI buffer is moved to the main buffer on the first
+ * occasion.
+ */
+static struct printk_log nmi_log = {
+	.cont = &nmi_cont,
+	.buf_len = __LOG_BUF_LEN,
+};
+
+/*
+ * Byte operations needed to manipulate index and sequence numbers for the NMI
+ * log buffer:
+ *	+ sequence number takes the lower half of the _id variable
+ *	+ index takes the higher half of the _id variable
+ */
+#define NMI_SEQ_BYTES (sizeof(nmi_log.nmi.first_id) * 8 / 2)
+#define NMI_IDX_BYTES NMI_SEQ_BYTES
+#define NMI_SEQ_MASK ((1UL << NMI_SEQ_BYTES) - 1)
+#define NMI_IDX_MASK (~NMI_SEQ_MASK)
+#define idx_from_id(id) ((id & NMI_IDX_MASK) >> NMI_SEQ_BYTES)
+#define seq_from_id(id) (id & NMI_SEQ_MASK)
+#define make_id(idx, seq) (((unsigned long)idx << NMI_SEQ_BYTES) | \
+			   (seq & NMI_SEQ_MASK))
+/*
+ * Maximum length of the allocated buffer. It has to be a power of two.
+ * It can be limited either by the maximum number of indexes or
+ * by the "buf_len" variable size.
+ */
+#define NMI_MAX_LEN_POWER (min(NMI_IDX_BYTES, sizeof(nmi_log.buf_len) * 8 - 1))
+#define NMI_MAX_LEN (1UL << NMI_MAX_LEN_POWER)
 
 /*
  * Define functions needed to get the position values,
@@ -324,7 +372,10 @@ static struct printk_log main_log = {
 #define DEFINE_GET_POS(rettype, funcname, side, pos)		\
 static rettype funcname(const struct printk_log *log)		\
 {								\
-	return log->main.side##_##pos;				\
+	if (log == &main_log)					\
+		return log->main.side##_##pos;			\
+	else							\
+		return pos##_from_id((log)->nmi.side##_id);	\
 }
 
 DEFINE_GET_POS(u32, get_first_idx, first, idx)
@@ -341,8 +392,12 @@ DEFINE_GET_POS(u64, get_next_seq, next, seq)
 #define DEFINE_SET_POS(funcname, side)					\
 static void funcname(struct printk_log *log, u32 idx, u64 seq)		\
 {									\
-	log->main.side##_idx = idx;					\
-	log->main.side##_seq = seq;				\
+	if (log == &main_log) {						\
+		(log)->main.side ## _idx = idx;				\
+		(log)->main.side ## _seq = seq;				\
+	} else {							\
+		(log)->nmi.side ## _id = make_id(idx, seq);		\
+	}								\
 }
 
 DEFINE_SET_POS(set_first_pos, first)
@@ -395,7 +450,10 @@ static u32 inc_idx(struct printk_log *log, u32 idx)
 /* get next sequence number for the given one */
 static u64 inc_seq(struct printk_log *log, u64 seq)
 {
-	return ++seq;
+	if (log == &main_log)
+		return ++seq;
+	else
+		return ++seq & NMI_SEQ_MASK;
 }
 
 /*
@@ -955,22 +1013,42 @@ static int __init log_buf_len_setup(char *str)
 }
 early_param("log_buf_len", log_buf_len_setup);
 
+char * __init alloc_log_buf(int early, unsigned len)
+{
+	if (early)
+		return memblock_virt_alloc(len, PAGE_SIZE);
+
+	return memblock_virt_alloc_nopanic(len, 0);
+}
+
 void __init setup_log_buf(int early)
 {
 	unsigned long flags;
 	char *new_log_buf;
 	int free;
 
+	if (!nmi_log.buf) {
+		/* use the same size that will be used for normal buffer */
+		if (new_log_buf_len > nmi_log.buf_len)
+			nmi_log.buf_len = new_log_buf_len;
+		if (nmi_log.buf_len > NMI_MAX_LEN)
+			nmi_log.buf_len = NMI_MAX_LEN;
+		nmi_log.buf = alloc_log_buf(early, nmi_log.buf_len);
+		if (!nmi_log.buf)
+			pr_err("%d bytes not available for NMI ring buffer\n",
+			       nmi_log.buf_len);
+		else
+			pr_info("NMI ring buffer size: %d\n", nmi_log.buf_len);
+	}
+
+	/*
+	 * The default static buffer is used when the size is not increased
+	 * by the boot parameter.
+	 */
 	if (!new_log_buf_len)
 		return;
 
-	if (early) {
-		new_log_buf =
-			memblock_virt_alloc(new_log_buf_len, PAGE_SIZE);
-	} else {
-		new_log_buf = memblock_virt_alloc_nopanic(new_log_buf_len, 0);
-	}
-
+	new_log_buf = alloc_log_buf(early, new_log_buf_len);
 	if (unlikely(!new_log_buf)) {
 		pr_err("log_buf_len: %ld bytes not available\n",
 			new_log_buf_len);
@@ -985,8 +1063,8 @@ void __init setup_log_buf(int early)
 	memcpy(main_log.buf, __log_buf, __LOG_BUF_LEN);
 	raw_spin_unlock_irqrestore(&main_logbuf_lock, flags);
 
-	pr_info("log_buf_len: %d\n", main_log.buf_len);
-	pr_info("early log buf free: %d(%d%%)\n",
+	pr_info("increased the main ring buffer: %d\n", main_log.buf_len);
+	pr_info("free space before resizing: %d(%d%%)\n",
 		free, (free * 100) / __LOG_BUF_LEN);
 }
 
-- 
1.8.4

