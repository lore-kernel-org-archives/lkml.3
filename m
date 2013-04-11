Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936404Ab3DKVDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:03:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26790 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935750Ab3DKUtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:17 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=AcZ_qLO0usgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=CjJuhXvzU_EA:10 a=drOt6m5kAAAA:8 a=VwQbUJbxAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=jeBq3FmKZ4MA:10 a=ellRqpt3DCn8BW9M:21 a=uzGzzM3IqHY2DRBl:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202602.168619128@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 098/171 ] vt: synchronize_rcu() under spinlock is not nice...
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0098-vt-synchronize_rcu-under-spinlock-is-not-nice.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit e8cd81693bbbb15db57d3c9aa7dd90eda4842874 ]

vcs_poll_data_free() calls unregister_vt_notifier(), which calls
atomic_notifier_chain_unregister(), which calls synchronize_rcu().
Do it *after* we'd dropped ->f_lock.

Cc: stable@vger.kernel.org (all kernels since 2.6.37)
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/tty/vt/vc_screen.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index fa7268a..6abb92c 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -93,7 +93,7 @@ vcs_poll_data_free(struct vcs_poll_data *poll)
 static struct vcs_poll_data *
 vcs_poll_data_get(struct file *file)
 {
-	struct vcs_poll_data *poll = file->private_data;
+	struct vcs_poll_data *poll = file->private_data, *kill = NULL;
 
 	if (poll)
 		return poll;
@@ -122,10 +122,12 @@ vcs_poll_data_get(struct file *file)
 		file->private_data = poll;
 	} else {
 		/* someone else raced ahead of us */
-		vcs_poll_data_free(poll);
+		kill = poll;
 		poll = file->private_data;
 	}
 	spin_unlock(&file->f_lock);
+	if (kill)
+		vcs_poll_data_free(kill);
 
 	return poll;
 }
-- 
1.7.10.4


