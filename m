Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbaENQjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:39:52 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:42049 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753279AbaENQjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:39:51 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuUNAASbc1NXQ68k/2dsb2JhbABZgwasaQQBAQEBAQEFAZodgSMXdIJTExwjGIECJBOIRQHRPoVUiHqERwEDjyqKJgGLDYgHgzg7
Date: Wed, 14 May 2014 18:39:48 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
        Christine Caulfield <ccaulfie@redhat.com>
Subject: [PATCH 1/1] fs/dlm/config.c: convert simple_str to kstr
Message-Id: <20140514183948.4e52dead864c2cdb3537628c@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace obsolete functions

simple_strtoul/kstrtouint
simple_strtol/kstrtoint
(kstr __must_check requires the right function to be applied)

Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/dlm/config.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 76feb4b..d521bdd 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -157,11 +157,13 @@ static ssize_t cluster_set(struct dlm_cluster *cl, unsigned int *cl_field,
 			   const char *buf, size_t len)
 {
 	unsigned int x;
+	int rc;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-
-	x = simple_strtoul(buf, NULL, 0);
+	rc = kstrtouint(buf, 0, &x);
+	if (rc)
+		return rc;
 
 	if (check_zero && !x)
 		return -EINVAL;
@@ -730,7 +732,10 @@ static ssize_t comm_nodeid_read(struct dlm_comm *cm, char *buf)
 static ssize_t comm_nodeid_write(struct dlm_comm *cm, const char *buf,
 				 size_t len)
 {
-	cm->nodeid = simple_strtol(buf, NULL, 0);
+	int rc = kstrtoint(buf, 0, &cm->nodeid);
+
+	if (rc)
+		return rc;
 	return len;
 }
 
@@ -742,7 +747,10 @@ static ssize_t comm_local_read(struct dlm_comm *cm, char *buf)
 static ssize_t comm_local_write(struct dlm_comm *cm, const char *buf,
 				size_t len)
 {
-	cm->local= simple_strtol(buf, NULL, 0);
+	int rc = kstrtoint(buf, 0, &cm->local);
+
+	if (rc)
+		return rc;
 	if (cm->local && !local_comm)
 		local_comm = cm;
 	return len;
@@ -846,7 +854,10 @@ static ssize_t node_nodeid_write(struct dlm_node *nd, const char *buf,
 				 size_t len)
 {
 	uint32_t seq = 0;
-	nd->nodeid = simple_strtol(buf, NULL, 0);
+	int rc = kstrtoint(buf, 0, &nd->nodeid);
+
+	if (rc)
+		return rc;
 	dlm_comm_seq(nd->nodeid, &seq);
 	nd->comm_seq = seq;
 	return len;
@@ -860,7 +871,10 @@ static ssize_t node_weight_read(struct dlm_node *nd, char *buf)
 static ssize_t node_weight_write(struct dlm_node *nd, const char *buf,
 				 size_t len)
 {
-	nd->weight = simple_strtol(buf, NULL, 0);
+	int rc = kstrtoint(buf, 0, &nd->weight);
+
+	if (rc)
+		return rc;
 	return len;
 }
 
-- 
1.9.1
