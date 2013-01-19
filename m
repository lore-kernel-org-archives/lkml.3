Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab3ASJEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 04:04:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:64203 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097Ab3ASJDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 04:03:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,498,1355126400"; 
   d="scan'208";a="275794036"
From: Jon Mason <jon.mason@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 11/21] NTB: correct stack usage warning in debugfs_read
Date: Sat, 19 Jan 2013 02:02:25 -0700
Message-Id: <1358586155-23322-12-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358586155-23322-1-git-send-email-jon.mason@intel.com>
References: <1358586155-23322-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct gcc warning of using too much stack debugfs_read.  This is done
by kmallocing the buffer instead of using the char array on stack.
Also, shrinking the buffer to something closer to what is currently
being used.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_transport.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index e11b57e..1bed1ba 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -368,10 +368,14 @@ static ssize_t debugfs_read(struct file *filp, char __user *ubuf, size_t count,
 			    loff_t *offp)
 {
 	struct ntb_transport_qp *qp;
-	char buf[1024];
+	char *buf;
 	ssize_t ret, out_offset, out_count;
 
-	out_count = 1024;
+	out_count = 600;
+
+	buf = kmalloc(out_count, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
 	qp = filp->private_data;
 	out_offset = 0;
@@ -410,10 +414,13 @@ static ssize_t debugfs_read(struct file *filp, char __user *ubuf, size_t count,
 			       "tx_mw_end - \t%p\n", qp->tx_mw_end);
 
 	out_offset += snprintf(buf + out_offset, out_count - out_offset,
-			       "QP Link %s\n", (qp->qp_link == NTB_LINK_UP) ?
+			       "\nQP Link %s\n", (qp->qp_link == NTB_LINK_UP) ?
 			       "Up" : "Down");
+	if (out_offset > out_count)
+		out_offset = out_count;
 
 	ret = simple_read_from_buffer(ubuf, count, offp, buf, out_offset);
+	kfree(buf);
 	return ret;
 }
 
-- 
1.7.9.5

