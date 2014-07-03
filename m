Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbaGCIne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:43:34 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:45932 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbaGCInZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:43:25 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 12/23] drbd: debugfs: add in_flight_summary data
Date: Thu,  3 Jul 2014 10:43:04 +0200
Message-Id: <1404376995-4877-13-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
References: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

To help diagnosing "high latency" or "hung" IO situations on DRBD,
present per drbd resource group a summary of operations currently in progress.

First item is a list of oldest drbd_request objects
waiting for various things:
 * still being prepared
 * waiting for activity log transaction
 * waiting for local disk
 * waiting to be sent
 * waiting for peer acknowledgement ("receive ack", "write ack")
 * waiting for peer epoch acknowledgement ("barrier ack")

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_debugfs.c | 196 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 196 insertions(+)

diff --git a/drivers/block/drbd/drbd_debugfs.c b/drivers/block/drbd/drbd_debugfs.c
index 9b120c3..d393aee 100644
--- a/drivers/block/drbd/drbd_debugfs.c
+++ b/drivers/block/drbd/drbd_debugfs.c
@@ -2,7 +2,9 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/debugfs.h>
+#include <linux/seq_file.h>
 #include <linux/stat.h>
+#include <linux/jiffies.h>
 #include <linux/list.h>
 
 #include "drbd_int.h"
@@ -13,6 +15,194 @@ static struct dentry *drbd_debugfs_root;
 static struct dentry *drbd_debugfs_resources;
 static struct dentry *drbd_debugfs_minors;
 
+static void seq_print_age_or_dash(struct seq_file *m, bool valid, unsigned long dt)
+{
+	if (valid)
+		seq_printf(m, "\t%d", jiffies_to_msecs(dt));
+	else
+		seq_printf(m, "\t-");
+}
+
+static void seq_print_rq_state_bit(struct seq_file *m,
+	bool is_set, char *sep, const char *name)
+{
+	if (!is_set)
+		return;
+	seq_putc(m, *sep);
+	seq_puts(m, name);
+	*sep = '|';
+}
+
+/* pretty print enum drbd_req_state_bits req->rq_state */
+static void seq_print_request_state(struct seq_file *m, struct drbd_request *req)
+{
+	unsigned int s = req->rq_state;
+	char sep = ' ';
+	seq_printf(m, "\t0x%08x", s);
+	seq_printf(m, "\tmaster: %s", req->master_bio ? "pending" : "completed");
+
+	/* RQ_WRITE ignored, already reported */
+	seq_puts(m, "\tlocal:");
+	seq_print_rq_state_bit(m, s & RQ_IN_ACT_LOG, &sep, "in-AL");
+	seq_print_rq_state_bit(m, s & RQ_POSTPONED, &sep, "postponed");
+	seq_print_rq_state_bit(m, s & RQ_COMPLETION_SUSP, &sep, "suspended");
+	sep = ' ';
+	seq_print_rq_state_bit(m, s & RQ_LOCAL_PENDING, &sep, "pending");
+	seq_print_rq_state_bit(m, s & RQ_LOCAL_COMPLETED, &sep, "completed");
+	seq_print_rq_state_bit(m, s & RQ_LOCAL_ABORTED, &sep, "aborted");
+	seq_print_rq_state_bit(m, s & RQ_LOCAL_OK, &sep, "ok");
+	if (sep == ' ')
+		seq_puts(m, " -");
+
+	/* for_each_connection ... */
+	seq_printf(m, "\tnet:");
+	sep = ' ';
+	seq_print_rq_state_bit(m, s & RQ_NET_PENDING, &sep, "pending");
+	seq_print_rq_state_bit(m, s & RQ_NET_QUEUED, &sep, "queued");
+	seq_print_rq_state_bit(m, s & RQ_NET_SENT, &sep, "sent");
+	seq_print_rq_state_bit(m, s & RQ_NET_DONE, &sep, "done");
+	seq_print_rq_state_bit(m, s & RQ_NET_SIS, &sep, "sis");
+	seq_print_rq_state_bit(m, s & RQ_NET_OK, &sep, "ok");
+	if (sep == ' ')
+		seq_puts(m, " -");
+
+	seq_printf(m, " :");
+	sep = ' ';
+	seq_print_rq_state_bit(m, s & RQ_EXP_RECEIVE_ACK, &sep, "B");
+	seq_print_rq_state_bit(m, s & RQ_EXP_WRITE_ACK, &sep, "C");
+	seq_print_rq_state_bit(m, s & RQ_EXP_BARR_ACK, &sep, "barr");
+	if (sep == ' ')
+		seq_puts(m, " -");
+	seq_printf(m, "\n");
+}
+
+static void seq_print_one_request(struct seq_file *m, struct drbd_request *req, unsigned long now)
+{
+	/* change anything here, fixup header below! */
+	unsigned int s = req->rq_state;
+
+#define RQ_HDR_1 "epoch\tsector\tsize\trw"
+	seq_printf(m, "0x%x\t%llu\t%u\t%s",
+		req->epoch,
+		(unsigned long long)req->i.sector, req->i.size >> 9,
+		(s & RQ_WRITE) ? "W" : "R");
+
+#define RQ_HDR_2 "\tstart\tin AL\tsubmit"
+	seq_printf(m, "\t%d", jiffies_to_msecs(now - req->start_jif));
+	seq_print_age_or_dash(m, s & RQ_IN_ACT_LOG, now - req->in_actlog_jif);
+	seq_print_age_or_dash(m, s & RQ_LOCAL_PENDING, now - req->pre_submit_jif);
+
+#define RQ_HDR_3 "\tsent\tacked\tdone"
+	seq_print_age_or_dash(m, s & RQ_NET_SENT, now - req->pre_send_jif);
+	seq_print_age_or_dash(m, (s & RQ_NET_SENT) && !(s & RQ_NET_PENDING), now - req->acked_jif);
+	seq_print_age_or_dash(m, s & RQ_NET_DONE, now - req->net_done_jif);
+
+#define RQ_HDR_4 "\tstate\n"
+	seq_print_request_state(m, req);
+}
+#define RQ_HDR RQ_HDR_1 RQ_HDR_2 RQ_HDR_3 RQ_HDR_4
+
+static void seq_print_minor_vnr_req(struct seq_file *m, struct drbd_request *req, unsigned long now)
+{
+	seq_printf(m, "%u\t%u\t", req->device->minor, req->device->vnr);
+	seq_print_one_request(m, req, now);
+}
+
+static void seq_print_resource_transfer_log_summary(struct seq_file *m,
+	struct drbd_resource *resource,
+	struct drbd_connection *connection,
+	unsigned long now)
+{
+	struct drbd_request *req;
+	unsigned int count = 0;
+	unsigned int show_state = 0;
+
+	seq_puts(m, "n\tdevice\tvnr\t" RQ_HDR);
+	spin_lock_irq(&resource->req_lock);
+	list_for_each_entry(req, &connection->transfer_log, tl_requests) {
+		unsigned int tmp = 0;
+		unsigned int s;
+		++count;
+
+		/* don't disable irq "forever" */
+		if (!(count & 0x1ff)) {
+			struct drbd_request *req_next;
+			kref_get(&req->kref);
+			spin_unlock_irq(&resource->req_lock);
+			cond_resched();
+			spin_lock_irq(&resource->req_lock);
+			req_next = list_next_entry(req, tl_requests);
+			if (kref_put(&req->kref, drbd_req_destroy))
+				req = req_next;
+			if (&req->tl_requests == &connection->transfer_log)
+				break;
+		}
+
+		s = req->rq_state;
+
+		/* This is meant to summarize timing issues, to be able to tell
+		 * local disk problems from network problems.
+		 * Skip requests, if we have shown an even older request with
+		 * similar aspects already.  */
+		if (req->master_bio == NULL)
+			tmp |= 1;
+		if ((s & RQ_LOCAL_MASK) && (s & RQ_LOCAL_PENDING))
+			tmp |= 2;
+		if (s & RQ_NET_MASK) {
+			if (!(s & RQ_NET_SENT))
+				tmp |= 4;
+			if (s & RQ_NET_PENDING)
+				tmp |= 8;
+			if (!(s & RQ_NET_DONE))
+				tmp |= 16;
+		}
+		if ((tmp & show_state) == tmp)
+			continue;
+		show_state |= tmp;
+		seq_printf(m, "%u\t", count);
+		seq_print_minor_vnr_req(m, req, now);
+		if (show_state == 0x1f)
+			break;
+	}
+	spin_unlock_irq(&resource->req_lock);
+}
+
+/* TODO: transfer_log and friends should be moved to resource */
+static int in_flight_summary_show(struct seq_file *m, void *pos)
+{
+	struct drbd_resource *resource = m->private;
+	struct drbd_connection *connection;
+	unsigned long jif = jiffies;
+
+	connection = first_connection(resource);
+	/* This does not happen, actually.
+	 * But be robust and prepare for future code changes. */
+	if (!connection)
+		return 0;
+
+	seq_puts(m, "oldest application requests\n");
+	seq_print_resource_transfer_log_summary(m, resource, connection, jif);
+	seq_putc(m, '\n');
+
+	jif = jiffies - jif;
+	if (jif)
+		seq_printf(m, "generated in %d ms\n", jiffies_to_msecs(jif));
+	return 0;
+}
+
+static int in_flight_summary_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, in_flight_summary_show, inode->i_private);
+}
+
+static const struct file_operations in_flight_summary_fops = {
+	.owner		= THIS_MODULE,
+	.open		= in_flight_summary_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 void drbd_debugfs_resource_add(struct drbd_resource *resource)
 {
 	struct dentry *dentry;
@@ -34,6 +224,12 @@ void drbd_debugfs_resource_add(struct drbd_resource *resource)
 		goto fail;
 	resource->debugfs_res_connections = dentry;
 
+	dentry = debugfs_create_file("in_flight_summary", S_IRUSR|S_IRGRP,
+			resource->debugfs_res, resource,
+			&in_flight_summary_fops);
+	if (IS_ERR_OR_NULL(dentry))
+		goto fail;
+	resource->debugfs_res_in_flight_summary = dentry;
 	return;
 
 fail:
-- 
1.9.1

