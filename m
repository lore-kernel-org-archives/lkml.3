Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbaDXVqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:46:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbaDXVqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:46:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3.14 27/33] fs: NULL dereference in posix_acl_to_xattr()
Date: Thu, 24 Apr 2014 14:48:40 -0700
Message-Id: <20140424214453.581753207@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140424214449.423169713@linuxfoundation.org>
References: <20140424214449.423169713@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 47ba9734403770a4c5e685b01f0a72b835dd4fff upstream.

This patch moves the dereference of "buffer" after the check for NULL.
The only place which passes a NULL parameter is gfs2_set_acl().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/posix_acl.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -723,7 +723,7 @@ posix_acl_to_xattr(struct user_namespace
 		   void *buffer, size_t size)
 {
 	posix_acl_xattr_header *ext_acl = (posix_acl_xattr_header *)buffer;
-	posix_acl_xattr_entry *ext_entry = ext_acl->a_entries;
+	posix_acl_xattr_entry *ext_entry;
 	int real_size, n;
 
 	real_size = posix_acl_xattr_size(acl->a_count);
@@ -731,7 +731,8 @@ posix_acl_to_xattr(struct user_namespace
 		return real_size;
 	if (real_size > size)
 		return -ERANGE;
-	
+
+	ext_entry = ext_acl->a_entries;
 	ext_acl->a_version = cpu_to_le32(POSIX_ACL_XATTR_VERSION);
 
 	for (n=0; n < acl->a_count; n++, ext_entry++) {


