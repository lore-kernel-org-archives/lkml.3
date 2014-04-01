Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaDAJXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:23:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbaDAJQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:24 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>, stable <stable@vger.kernel.org>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/29] fs: NULL dereference in posix_acl_to_xattr()
Date: Tue,  1 Apr 2014 10:15:23 +0100
Message-Id: <1396343741-1524-12-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

This patch moves the dereference of "buffer" after the check for NULL.
The only place which passes a NULL parameter is gfs2_set_acl().

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 38bae5a..202b84f 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -717,7 +717,7 @@ posix_acl_to_xattr(struct user_namespace *user_ns, const struct posix_acl *acl,
 		   void *buffer, size_t size)
 {
 	posix_acl_xattr_header *ext_acl = (posix_acl_xattr_header *)buffer;
-	posix_acl_xattr_entry *ext_entry = ext_acl->a_entries;
+	posix_acl_xattr_entry *ext_entry;
 	int real_size, n;
 
 	real_size = posix_acl_xattr_size(acl->a_count);
@@ -725,7 +725,8 @@ posix_acl_to_xattr(struct user_namespace *user_ns, const struct posix_acl *acl,
 		return real_size;
 	if (real_size > size)
 		return -ERANGE;
-	
+
+	ext_entry = ext_acl->a_entries;
 	ext_acl->a_version = cpu_to_le32(POSIX_ACL_XATTR_VERSION);
 
 	for (n=0; n < acl->a_count; n++, ext_entry++) {
-- 
1.8.3.1

