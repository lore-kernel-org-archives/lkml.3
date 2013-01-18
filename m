Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab3ARKH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 05:07:27 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:52087 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab3ARKHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 05:07:25 -0500
From: abhi.c.pawar@gmail.com
To: akpm@linux-foundation.org, Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        Abhijit Pawar <abhi.c.pawar@gmail.com>
Subject: [PATCH 3/3] fs/dlm: remove obsolete simple_strto<foo>
Date: Fri, 18 Jan 2013 15:36:49 +0530
Message-Id: <50f91edc.a1bd440a.7c49.ffffe23b@mx.google.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijit Pawar <abhi.c.pawar@gmail.com>

This patch replace the obsolete simple_strto<foo> with kstrto<foo>.

Signed-off-by: Abhijit Pawar <abhi.c.pawar@gmail.com>
---
 fs/dlm/config.c    |   25 ++++++++++++++++++++-----
 fs/dlm/lockspace.c |   20 ++++++++++++++++----
 2 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 7d58d5b..1a6293b 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -156,11 +156,14 @@ static ssize_t cluster_set(struct dlm_cluster *cl, unsigned int *cl_field,
 			   const char *buf, size_t len)
 {
 	unsigned int x;
+	int rc;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	x = simple_strtoul(buf, NULL, 0);
+	rc = kstrtouint(buf, 0, &x);
+	if (rc)
+		return rc;
 
 	if (check_zero && !x)
 		return -EINVAL;
@@ -729,7 +732,10 @@ static ssize_t comm_nodeid_read(struct dlm_comm *cm, char *buf)
 static ssize_t comm_nodeid_write(struct dlm_comm *cm, const char *buf,
 				 size_t len)
 {
-	cm->nodeid = simple_strtol(buf, NULL, 0);
+	int rc;
+	rc = kstrtoint(buf, 0, &cm->nodeid);
+	if (rc)
+		return rc;
 	return len;
 }
 
@@ -741,7 +747,10 @@ static ssize_t comm_local_read(struct dlm_comm *cm, char *buf)
 static ssize_t comm_local_write(struct dlm_comm *cm, const char *buf,
 				size_t len)
 {
-	cm->local= simple_strtol(buf, NULL, 0);
+	int rc;
+	rc = kstrtoint(buf, 0, &cm->local);
+	if (rc)
+		return rc;
 	if (cm->local && !local_comm)
 		local_comm = cm;
 	return len;
@@ -845,7 +854,10 @@ static ssize_t node_nodeid_write(struct dlm_node *nd, const char *buf,
 				 size_t len)
 {
 	uint32_t seq = 0;
-	nd->nodeid = simple_strtol(buf, NULL, 0);
+	int rc;
+	rc = kstrtoint(buf, 0, &nd->nodeid);
+	if (rc)
+		return rc;
 	dlm_comm_seq(nd->nodeid, &seq);
 	nd->comm_seq = seq;
 	return len;
@@ -859,7 +871,10 @@ static ssize_t node_weight_read(struct dlm_node *nd, char *buf)
 static ssize_t node_weight_write(struct dlm_node *nd, const char *buf,
 				 size_t len)
 {
-	nd->weight = simple_strtol(buf, NULL, 0);
+	int rc;
+	rc = kstrtoint(buf, 0, &nd->weight);
+	if (rc)
+		return rc;
 	return len;
 }
 
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 2e99fb0..9060c26 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -35,7 +35,10 @@ static struct task_struct *	scand_task;
 static ssize_t dlm_control_store(struct dlm_ls *ls, const char *buf, size_t len)
 {
 	ssize_t ret = len;
-	int n = simple_strtol(buf, NULL, 0);
+	int n, rc;
+	rc = kstrtoint(buf, 0, &n);
+	if (rc)
+		return rc;
 
 	ls = dlm_find_lockspace_local(ls->ls_local_handle);
 	if (!ls)
@@ -57,7 +60,10 @@ static ssize_t dlm_control_store(struct dlm_ls *ls, const char *buf, size_t len)
 
 static ssize_t dlm_event_store(struct dlm_ls *ls, const char *buf, size_t len)
 {
-	ls->ls_uevent_result = simple_strtol(buf, NULL, 0);
+	int rc;
+	rc = kstrtoint(buf, 0, &ls->ls_uevent_result);
+	if (rc)
+		return rc;
 	set_bit(LSFL_UEVENT_WAIT, &ls->ls_flags);
 	wake_up(&ls->ls_uevent_wait);
 	return len;
@@ -70,7 +76,10 @@ static ssize_t dlm_id_show(struct dlm_ls *ls, char *buf)
 
 static ssize_t dlm_id_store(struct dlm_ls *ls, const char *buf, size_t len)
 {
-	ls->ls_global_id = simple_strtoul(buf, NULL, 0);
+	int rc;
+	rc = kstrtouint(buf, 0, &ls->ls_global_id);
+	if (rc)
+		return rc;
 	return len;
 }
 
@@ -81,7 +90,10 @@ static ssize_t dlm_nodir_show(struct dlm_ls *ls, char *buf)
 
 static ssize_t dlm_nodir_store(struct dlm_ls *ls, const char *buf, size_t len)
 {
-	int val = simple_strtoul(buf, NULL, 0);
+	int val, rc;
+	rc = kstrtoint(buf, 0, &val);
+	if (rc)
+		return rc;
 	if (val == 1)
 		set_bit(LSFL_NODIR, &ls->ls_flags);
 	return len;
-- 
1.7.7.6

