Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbaF3G7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:59:32 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:48451 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbaF3G7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:59:31 -0400
Date: Mon, 30 Jun 2014 15:58:24 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: himangi774@gmail.com, sachin.kamat@linaro.org, fempsci@gmail.com,
        weo@weo1.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3 V2] staging: cxt1e1: count fragmented packet properly.
Message-ID: <20140630065824.GA28957@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OS_mem_token_tlen() is same return value as OS_mem_token_len().
That means packet count is always 1. So OS_mem_token_tlen()
must be total length of packet and OS_mem_token_len() has a
length of fragmented packet. And then it can count total
count of fragmented packets properly.

And OS_mem_token_next() returns NULL, it will be dereferencing
a NULL pointer. So it must return next fragmented packet buffer as
sk_buff.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
V2: rebased on changes in the first one.

 drivers/staging/cxt1e1/musycc.c              |   52 +++++++++++++++-----------
 drivers/staging/cxt1e1/sbecom_inline_linux.h |    4 +-
 2 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/cxt1e1/musycc.c b/drivers/staging/cxt1e1/musycc.c
index 0ae62b3..5ddab02 100644
--- a/drivers/staging/cxt1e1/musycc.c
+++ b/drivers/staging/cxt1e1/musycc.c
@@ -1579,8 +1579,8 @@ musycc_start_xmit(ci_t *ci, int channum, void *mem_token)
 	mch_t      *ch;
 	struct mdesc *md;
 	void       *m2;
-	int         txd_need_cnt;
-	u_int32_t   len;
+	int         txd_need_cnt = 0;
+	u_int32_t   len, data_len;
 
 	ch = sd_find_chan(ci, channum);
 	if (!ch)
@@ -1611,13 +1611,16 @@ musycc_start_xmit(ci_t *ci, int channum, void *mem_token)
 	/** Determine total amount of data to be sent **/
 	/***********************************************/
 	m2 = mem_token;
-	txd_need_cnt = 0;
-	for (len = OS_mem_token_tlen(m2); len > 0;
-	     m2 = (void *) OS_mem_token_next(m2)) {
-		if (!OS_mem_token_len(m2))
-			continue;
-		txd_need_cnt++;
-		len -= OS_mem_token_len(m2);
+	len = OS_mem_token_tlen(m2);
+
+	while (m2 && len > 0) {
+		data_len = OS_mem_token_len(m2);
+		if (data_len) {
+			len -= data_len;
+			txd_need_cnt++;
+		}
+
+		m2 = OS_mem_token_next(m2);
 	}
 
 	if (txd_need_cnt == 0) {
@@ -1658,13 +1661,18 @@ musycc_start_xmit(ci_t *ci, int channum, void *mem_token)
 	/**************************************************/
 	m2 = mem_token;
 	md = ch->txd_usr_add;           /* get current available descriptor */
+	len = OS_mem_token_tlen(m2);
 
-	for (len = OS_mem_token_tlen(m2); len > 0; m2 = OS_mem_token_next(m2)) {
-		int         u = OS_mem_token_len(m2);
+	while (m2 && len > 0) {
+		u_int32_t data_len = OS_mem_token_len(m2);
+		u_int32_t status = 0;
 
-		if (!u)
+		if (!data_len) {
+			m2 = OS_mem_token_next(m2);
 			continue;
-		len -= u;
+		}
+
+		len -= data_len;
 
 		/*
 		 * Enable following chunks, yet wait to enable the FIRST chunk until
@@ -1672,25 +1680,24 @@ musycc_start_xmit(ci_t *ci, int channum, void *mem_token)
 		 */
 		if (md != ch->txd_usr_add)  /* not first chunk */
 			/* transfer ownership from HOST to MUSYCC */
-			u |= MUSYCC_TX_OWNED;
+			status |= MUSYCC_TX_OWNED;
 
 		if (len)                    /* not last chunk */
-			u |= EOBIRQ_ENABLE;
+			status |= EOBIRQ_ENABLE;
 		else if (ch->p.chan_mode == CFG_CH_PROTO_TRANS) {
 			/*
 			 * Per MUSYCC Ref 6.4.9 for Transparent Mode, the host must
 			 * always clear EOMIRQ_ENABLE in every Transmit Buffer Descriptor
 			 * (IE. don't set herein).
 			 */
-			u |= EOBIRQ_ENABLE;
+			status |= EOBIRQ_ENABLE;
 		} else
-			u |= EOMIRQ_ENABLE;     /* EOM, last HDLC chunk */
-
+			status |= EOMIRQ_ENABLE;     /* EOM, last HDLC chunk */
 
 		/* last chunk in hdlc mode */
-		u |= (ch->p.idlecode << IDLE_CODE);
+		status |= (ch->p.idlecode << IDLE_CODE);
 		if (ch->p.pad_fill_count) {
-			u |= (PADFILL_ENABLE | (ch->p.pad_fill_count << EXTRA_FLAGS));
+			status |= (PADFILL_ENABLE | (ch->p.pad_fill_count << EXTRA_FLAGS));
 		}
 		/* Fill in mds on last segment, others set ZERO
 		 * so that entire token is removed ONLY when ALL
@@ -1700,13 +1707,14 @@ musycc_start_xmit(ci_t *ci, int channum, void *mem_token)
 
 		md->data = cpu_to_le32(virt_to_phys(OS_mem_token_data(m2)));
 		FLUSH_MEM_WRITE();
-		md->status = cpu_to_le32(u);
+		md->status = cpu_to_le32(status);
 		--ch->txd_free;
 		md = md->snext;
+
+		m2 = OS_mem_token_next(m2);
 	}
 	FLUSH_MEM_WRITE();
 
-
 	/*
 	 * Now transfer ownership of first chunk from HOST to MUSYCC in order to
 	 * fire-off this XMIT.
diff --git a/drivers/staging/cxt1e1/sbecom_inline_linux.h b/drivers/staging/cxt1e1/sbecom_inline_linux.h
index af2bffe..a99073b 100644
--- a/drivers/staging/cxt1e1/sbecom_inline_linux.h
+++ b/drivers/staging/cxt1e1/sbecom_inline_linux.h
@@ -82,14 +82,14 @@ OS_mem_token_data (void *token)
 static inline void *
 OS_mem_token_next (void *token)
 {
-    return NULL;
+    return ((struct sk_buff*)token)->next;
 }
 
 
 static inline int
 OS_mem_token_len (void *token)
 {
-    return ((struct sk_buff *) token)->len;
+    return ((struct sk_buff *) token)->data_len;
 }
 
 
-- 
1.7.1

