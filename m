Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaDXIw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:52:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46313 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbaDXIwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:52:23 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 020/182] fs: NULL dereference in posix_acl_to_xattr()
Date: Thu, 24 Apr 2014 09:49:05 +0100
Message-Id: <1398329507-5911-21-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 47ba9734403770a4c5e685b01f0a72b835dd4fff upstream.

This patch moves the dereference of "buffer" after the check for NULL.
The only place which passes a NULL parameter is gfs2_set_acl().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
[ luis: backported to 3.11:
  - posix_acl_to_xattr() is defined in xattr_acl.c, not in posix_acl.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/xattr_acl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xattr_acl.c b/fs/xattr_acl.c
index 9fbea87..cd1147c 100644
--- a/fs/xattr_acl.c
+++ b/fs/xattr_acl.c
@@ -146,7 +146,7 @@ posix_acl_to_xattr(struct user_namespace *user_ns, const struct posix_acl *acl,
 		   void *buffer, size_t size)
 {
 	posix_acl_xattr_header *ext_acl = (posix_acl_xattr_header *)buffer;
-	posix_acl_xattr_entry *ext_entry = ext_acl->a_entries;
+	posix_acl_xattr_entry *ext_entry;
 	int real_size, n;
 
 	real_size = posix_acl_xattr_size(acl->a_count);
@@ -154,7 +154,8 @@ posix_acl_to_xattr(struct user_namespace *user_ns, const struct posix_acl *acl,
 		return real_size;
 	if (real_size > size)
 		return -ERANGE;
-	
+
+	ext_entry = ext_acl->a_entries;
 	ext_acl->a_version = cpu_to_le32(POSIX_ACL_XATTR_VERSION);
 
 	for (n=0; n < acl->a_count; n++, ext_entry++) {
-- 
1.9.1

