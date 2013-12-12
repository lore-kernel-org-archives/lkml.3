Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab3LLXwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 18:52:14 -0500
Received: from smtprelay0012.hostedemail.com ([216.40.44.12]:41018 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752010Ab3LLXrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 18:47:39 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:1:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1605:1730:1747:1777:1792:2198:2199:2393:2559:2562:2639:3138:3139:3140:3141:3142:3865:3867:3868:3871:3872:4321:4605:5007:6119:6261:7903:10004:10026:10394:10848:11026:11232:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12679:12683:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: note51_84c0f3438d16
X-Filterd-Recvd-Size: 14251
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next 1/4] dlm: Use seq_is_buf_full - remove seq_printf returns
Date: Thu, 12 Dec 2013 15:47:28 -0800
Message-Id: <860a2dec4c3e5e590d6a30f655cc78953fb12510.1386891757.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1386819513.git.joe@perches.com>
References: <cover.1386819513.git.joe@perches.com>
In-Reply-To: <cover.1386891757.git.joe@perches.com>
References: <cover.1386891757.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The seq_printf return should be ignored and the
seq_is_buf_full function should be tested instead.

Convert functions returning int to void where
seq_printf is used.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/dlm/debug_fs.c | 248 +++++++++++++++++++++++++-----------------------------
 1 file changed, 116 insertions(+), 132 deletions(-)

diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index b969dee..eb26595 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -48,8 +48,8 @@ static char *print_lockmode(int mode)
 	}
 }
 
-static int print_format1_lock(struct seq_file *s, struct dlm_lkb *lkb,
-			      struct dlm_rsb *res)
+static void print_format1_lock(struct seq_file *s, struct dlm_lkb *lkb,
+			       struct dlm_rsb *res)
 {
 	seq_printf(s, "%08x %s", lkb->lkb_id, print_lockmode(lkb->lkb_grmode));
 
@@ -68,21 +68,17 @@ static int print_format1_lock(struct seq_file *s, struct dlm_lkb *lkb,
 	if (lkb->lkb_wait_type)
 		seq_printf(s, " wait_type: %d", lkb->lkb_wait_type);
 
-	return seq_printf(s, "\n");
+	seq_puts(s, "\n");
 }
 
-static int print_format1(struct dlm_rsb *res, struct seq_file *s)
+static void print_format1(struct dlm_rsb *res, struct seq_file *s)
 {
 	struct dlm_lkb *lkb;
 	int i, lvblen = res->res_ls->ls_lvblen, recover_list, root_list;
-	int rv;
 
 	lock_rsb(res);
 
-	rv = seq_printf(s, "\nResource %p Name (len=%d) \"",
-			res, res->res_length);
-	if (rv)
-		goto out;
+	seq_printf(s, "\nResource %p Name (len=%d) \"", res, res->res_length);
 
 	for (i = 0; i < res->res_length; i++) {
 		if (isprint(res->res_name[i]))
@@ -92,17 +88,16 @@ static int print_format1(struct dlm_rsb *res, struct seq_file *s)
 	}
 
 	if (res->res_nodeid > 0)
-		rv = seq_printf(s, "\"  \nLocal Copy, Master is node %d\n",
-				res->res_nodeid);
+		seq_printf(s, "\" \nLocal Copy, Master is node %d\n",
+			   res->res_nodeid);
 	else if (res->res_nodeid == 0)
-		rv = seq_printf(s, "\"  \nMaster Copy\n");
+		seq_puts(s, "\" \nMaster Copy\n");
 	else if (res->res_nodeid == -1)
-		rv = seq_printf(s, "\"  \nLooking up master (lkid %x)\n",
-			   	res->res_first_lkid);
+		seq_printf(s, "\" \nLooking up master (lkid %x)\n",
+			   res->res_first_lkid);
 	else
-		rv = seq_printf(s, "\"  \nInvalid master %d\n",
-				res->res_nodeid);
-	if (rv)
+		seq_printf(s, "\" \nInvalid master %d\n", res->res_nodeid);
+	if (seq_is_buf_full(s))
 		goto out;
 
 	/* Print the LVB: */
@@ -116,8 +111,8 @@ static int print_format1(struct dlm_rsb *res, struct seq_file *s)
 		}
 		if (rsb_flag(res, RSB_VALNOTVALID))
 			seq_printf(s, " (INVALID)");
-		rv = seq_printf(s, "\n");
-		if (rv)
+		seq_puts(s, "\n");
+		if (seq_is_buf_full(s))
 			goto out;
 	}
 
@@ -125,32 +120,30 @@ static int print_format1(struct dlm_rsb *res, struct seq_file *s)
 	recover_list = !list_empty(&res->res_recover_list);
 
 	if (root_list || recover_list) {
-		rv = seq_printf(s, "Recovery: root %d recover %d flags %lx "
-				"count %d\n", root_list, recover_list,
-			   	res->res_flags, res->res_recover_locks_count);
-		if (rv)
-			goto out;
+		seq_printf(s, "Recovery: root %d recover %d flags %lx count %d\n",
+			   root_list, recover_list,
+			   res->res_flags, res->res_recover_locks_count);
 	}
 
 	/* Print the locks attached to this resource */
 	seq_printf(s, "Granted Queue\n");
 	list_for_each_entry(lkb, &res->res_grantqueue, lkb_statequeue) {
-		rv = print_format1_lock(s, lkb, res);
-		if (rv)
+		print_format1_lock(s, lkb, res);
+		if (seq_is_buf_full(s))
 			goto out;
 	}
 
 	seq_printf(s, "Conversion Queue\n");
 	list_for_each_entry(lkb, &res->res_convertqueue, lkb_statequeue) {
-		rv = print_format1_lock(s, lkb, res);
-		if (rv)
+		print_format1_lock(s, lkb, res);
+		if (seq_is_buf_full(s))
 			goto out;
 	}
 
 	seq_printf(s, "Waiting Queue\n");
 	list_for_each_entry(lkb, &res->res_waitqueue, lkb_statequeue) {
-		rv = print_format1_lock(s, lkb, res);
-		if (rv)
+		print_format1_lock(s, lkb, res);
+		if (seq_is_buf_full(s))
 			goto out;
 	}
 
@@ -159,23 +152,23 @@ static int print_format1(struct dlm_rsb *res, struct seq_file *s)
 
 	seq_printf(s, "Lookup Queue\n");
 	list_for_each_entry(lkb, &res->res_lookup, lkb_rsb_lookup) {
-		rv = seq_printf(s, "%08x %s", lkb->lkb_id,
-				print_lockmode(lkb->lkb_rqmode));
+		seq_printf(s, "%08x %s",
+			   lkb->lkb_id, print_lockmode(lkb->lkb_rqmode));
 		if (lkb->lkb_wait_type)
 			seq_printf(s, " wait_type: %d", lkb->lkb_wait_type);
-		rv = seq_printf(s, "\n");
+		seq_puts(s, "\n");
+		if (seq_is_buf_full(s))
+			goto out;
 	}
  out:
 	unlock_rsb(res);
-	return rv;
 }
 
-static int print_format2_lock(struct seq_file *s, struct dlm_lkb *lkb,
-			      struct dlm_rsb *r)
+static void print_format2_lock(struct seq_file *s, struct dlm_lkb *lkb,
+			       struct dlm_rsb *r)
 {
 	u64 xid = 0;
 	u64 us;
-	int rv;
 
 	if (lkb->lkb_flags & DLM_IFL_USER) {
 		if (lkb->lkb_ua)
@@ -188,103 +181,97 @@ static int print_format2_lock(struct seq_file *s, struct dlm_lkb *lkb,
 	/* id nodeid remid pid xid exflags flags sts grmode rqmode time_us
 	   r_nodeid r_len r_name */
 
-	rv = seq_printf(s, "%x %d %x %u %llu %x %x %d %d %d %llu %u %d \"%s\"\n",
-			lkb->lkb_id,
-			lkb->lkb_nodeid,
-			lkb->lkb_remid,
-			lkb->lkb_ownpid,
-			(unsigned long long)xid,
-			lkb->lkb_exflags,
-			lkb->lkb_flags,
-			lkb->lkb_status,
-			lkb->lkb_grmode,
-			lkb->lkb_rqmode,
-			(unsigned long long)us,
-			r->res_nodeid,
-			r->res_length,
-			r->res_name);
-	return rv;
+	seq_printf(s, "%x %d %x %u %llu %x %x %d %d %d %llu %u %d \"%s\"\n",
+		   lkb->lkb_id,
+		   lkb->lkb_nodeid,
+		   lkb->lkb_remid,
+		   lkb->lkb_ownpid,
+		   (unsigned long long)xid,
+		   lkb->lkb_exflags,
+		   lkb->lkb_flags,
+		   lkb->lkb_status,
+		   lkb->lkb_grmode,
+		   lkb->lkb_rqmode,
+		   (unsigned long long)us,
+		   r->res_nodeid,
+		   r->res_length,
+		   r->res_name);
 }
 
-static int print_format2(struct dlm_rsb *r, struct seq_file *s)
+static void print_format2(struct dlm_rsb *r, struct seq_file *s)
 {
 	struct dlm_lkb *lkb;
-	int rv = 0;
 
 	lock_rsb(r);
 
 	list_for_each_entry(lkb, &r->res_grantqueue, lkb_statequeue) {
-		rv = print_format2_lock(s, lkb, r);
-		if (rv)
+		print_format2_lock(s, lkb, r);
+		if (seq_is_buf_full(s))
 			goto out;
 	}
 
 	list_for_each_entry(lkb, &r->res_convertqueue, lkb_statequeue) {
-		rv = print_format2_lock(s, lkb, r);
-		if (rv)
+		print_format2_lock(s, lkb, r);
+		if (seq_is_buf_full(s))
 			goto out;
 	}
 
 	list_for_each_entry(lkb, &r->res_waitqueue, lkb_statequeue) {
-		rv = print_format2_lock(s, lkb, r);
-		if (rv)
+		print_format2_lock(s, lkb, r);
+		if (seq_is_buf_full(s))
 			goto out;
 	}
  out:
 	unlock_rsb(r);
-	return rv;
 }
 
-static int print_format3_lock(struct seq_file *s, struct dlm_lkb *lkb,
+static void print_format3_lock(struct seq_file *s, struct dlm_lkb *lkb,
 			      int rsb_lookup)
 {
 	u64 xid = 0;
-	int rv;
 
 	if (lkb->lkb_flags & DLM_IFL_USER) {
 		if (lkb->lkb_ua)
 			xid = lkb->lkb_ua->xid;
 	}
 
-	rv = seq_printf(s, "lkb %x %d %x %u %llu %x %x %d %d %d %d %d %d %u %llu %llu\n",
-			lkb->lkb_id,
-			lkb->lkb_nodeid,
-			lkb->lkb_remid,
-			lkb->lkb_ownpid,
-			(unsigned long long)xid,
-			lkb->lkb_exflags,
-			lkb->lkb_flags,
-			lkb->lkb_status,
-			lkb->lkb_grmode,
-			lkb->lkb_rqmode,
-			lkb->lkb_last_bast.mode,
-			rsb_lookup,
-			lkb->lkb_wait_type,
-			lkb->lkb_lvbseq,
-			(unsigned long long)ktime_to_ns(lkb->lkb_timestamp),
-			(unsigned long long)ktime_to_ns(lkb->lkb_last_bast_time));
-	return rv;
+	seq_printf(s, "lkb %x %d %x %u %llu %x %x %d %d %d %d %d %d %u %llu %llu\n",
+		   lkb->lkb_id,
+		   lkb->lkb_nodeid,
+		   lkb->lkb_remid,
+		   lkb->lkb_ownpid,
+		   (unsigned long long)xid,
+		   lkb->lkb_exflags,
+		   lkb->lkb_flags,
+		   lkb->lkb_status,
+		   lkb->lkb_grmode,
+		   lkb->lkb_rqmode,
+		   lkb->lkb_last_bast.mode,
+		   rsb_lookup,
+		   lkb->lkb_wait_type,
+		   lkb->lkb_lvbseq,
+		   (unsigned long long)ktime_to_ns(lkb->lkb_timestamp),
+		   (unsigned long long)ktime_to_ns(lkb->lkb_last_bast_time));
 }
 
-static int print_format3(struct dlm_rsb *r, struct seq_file *s)
+static void print_format3(struct dlm_rsb *r, struct seq_file *s)
 {
 	struct dlm_lkb *lkb;
 	int i, lvblen = r->res_ls->ls_lvblen;
 	int print_name = 1;
-	int rv;
 
 	lock_rsb(r);
 
-	rv = seq_printf(s, "rsb %p %d %x %lx %d %d %u %d ",
-			r,
-			r->res_nodeid,
-			r->res_first_lkid,
-			r->res_flags,
-			!list_empty(&r->res_root_list),
-			!list_empty(&r->res_recover_list),
-			r->res_recover_locks_count,
-			r->res_length);
-	if (rv)
+	seq_printf(s, "rsb %p %d %x %lx %d %d %u %d ",
+		   r,
+		   r->res_nodeid,
+		   r->res_first_lkid,
+		   r->res_flags,
+		   !list_empty(&r->res_root_list),
+		   !list_empty(&r->res_recover_list),
+		   r->res_recover_locks_count,
+		   r->res_length);
+	if (seq_is_buf_full(s))
 		goto out;
 
 	for (i = 0; i < r->res_length; i++) {
@@ -300,8 +287,8 @@ static int print_format3(struct dlm_rsb *r, struct seq_file *s)
 		else
 			seq_printf(s, " %02x", (unsigned char)r->res_name[i]);
 	}
-	rv = seq_printf(s, "\n");
-	if (rv)
+	seq_puts(s, "\n");
+	if (seq_is_buf_full(s))
 		goto out;
 
 	if (!r->res_lvbptr)
@@ -311,58 +298,55 @@ static int print_format3(struct dlm_rsb *r, struct seq_file *s)
 
 	for (i = 0; i < lvblen; i++)
 		seq_printf(s, " %02x", (unsigned char)r->res_lvbptr[i]);
-	rv = seq_printf(s, "\n");
-	if (rv)
+	seq_puts(s, "\n");
+	if (seq_is_buf_full(s))
 		goto out;
 
  do_locks:
 	list_for_each_entry(lkb, &r->res_grantqueue, lkb_statequeue) {
-		rv = print_format3_lock(s, lkb, 0);
-		if (rv)
+		print_format3_lock(s, lkb, 0);
+		if (seq_is_buf_full(s))
 			goto out;
 	}
 
 	list_for_each_entry(lkb, &r->res_convertqueue, lkb_statequeue) {
-		rv = print_format3_lock(s, lkb, 0);
-		if (rv)
+		print_format3_lock(s, lkb, 0);
+		if (seq_is_buf_full(s))
 			goto out;
 	}
 
 	list_for_each_entry(lkb, &r->res_waitqueue, lkb_statequeue) {
-		rv = print_format3_lock(s, lkb, 0);
-		if (rv)
+		print_format3_lock(s, lkb, 0);
+		if (seq_is_buf_full(s))
 			goto out;
 	}
 
 	list_for_each_entry(lkb, &r->res_lookup, lkb_rsb_lookup) {
-		rv = print_format3_lock(s, lkb, 1);
-		if (rv)
+		print_format3_lock(s, lkb, 1);
+		if (seq_is_buf_full(s))
 			goto out;
 	}
  out:
 	unlock_rsb(r);
-	return rv;
 }
 
-static int print_format4(struct dlm_rsb *r, struct seq_file *s)
+static void print_format4(struct dlm_rsb *r, struct seq_file *s)
 {
 	int our_nodeid = dlm_our_nodeid();
 	int print_name = 1;
-	int i, rv;
+	int i;
 
 	lock_rsb(r);
 
-	rv = seq_printf(s, "rsb %p %d %d %d %d %lu %lx %d ",
-			r,
-			r->res_nodeid,
-			r->res_master_nodeid,
-			r->res_dir_nodeid,
-			our_nodeid,
-			r->res_toss_time,
-			r->res_flags,
-			r->res_length);
-	if (rv)
-		goto out;
+	seq_printf(s, "rsb %p %d %d %d %d %lu %lx %d ",
+		   r,
+		   r->res_nodeid,
+		   r->res_master_nodeid,
+		   r->res_dir_nodeid,
+		   our_nodeid,
+		   r->res_toss_time,
+		   r->res_flags,
+		   r->res_length);
 
 	for (i = 0; i < r->res_length; i++) {
 		if (!isascii(r->res_name[i]) || !isprint(r->res_name[i]))
@@ -377,10 +361,9 @@ static int print_format4(struct dlm_rsb *r, struct seq_file *s)
 		else
 			seq_printf(s, " %02x", (unsigned char)r->res_name[i]);
 	}
-	rv = seq_printf(s, "\n");
- out:
+	seq_puts(s, "\n");
+
 	unlock_rsb(r);
-	return rv;
 }
 
 struct rsbtbl_iter {
@@ -390,11 +373,12 @@ struct rsbtbl_iter {
 	int header;
 };
 
-/* seq_printf returns -1 if the buffer is full, and 0 otherwise.
-   If the buffer is full, seq_printf can be called again, but it
-   does nothing and just returns -1.  So, the these printing routines
-   periodically check the return value to avoid wasting too much time
-   trying to print to a full buffer. */
+/*
+ * If the buffer is full, seq_printf can be called again, but it
+ * does nothing.  So, the these printing routines periodically check
+ * seq_is_buf_full to avoid wasting too much time trying to print to
+ * a full buffer.
+ */
 
 static int table_seq_show(struct seq_file *seq, void *iter_ptr)
 {
@@ -403,7 +387,7 @@ static int table_seq_show(struct seq_file *seq, void *iter_ptr)
 
 	switch (ri->format) {
 	case 1:
-		rv = print_format1(ri->rsb, seq);
+		print_format1(ri->rsb, seq);
 		break;
 	case 2:
 		if (ri->header) {
@@ -412,21 +396,21 @@ static int table_seq_show(struct seq_file *seq, void *iter_ptr)
 					"r_nodeid r_len r_name\n");
 			ri->header = 0;
 		}
-		rv = print_format2(ri->rsb, seq);
+		print_format2(ri->rsb, seq);
 		break;
 	case 3:
 		if (ri->header) {
 			seq_printf(seq, "version rsb 1.1 lvb 1.1 lkb 1.1\n");
 			ri->header = 0;
 		}
-		rv = print_format3(ri->rsb, seq);
+		print_format3(ri->rsb, seq);
 		break;
 	case 4:
 		if (ri->header) {
 			seq_printf(seq, "version 4 rsb 2\n");
 			ri->header = 0;
 		}
-		rv = print_format4(ri->rsb, seq);
+		print_format4(ri->rsb, seq);
 		break;
 	}
 
-- 
1.8.1.2.459.gbcd45b4.dirty

