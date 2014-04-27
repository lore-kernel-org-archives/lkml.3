Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbaD0RTo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:19:44 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48034 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099AbaD0RIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:05 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Li Xi <lixi@ddn.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 19/47] staging/lustre: fix permission problem of setfacl
Date: Sun, 27 Apr 2014 13:06:43 -0400
Message-Id: <1398618431-29757-20-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Xi <lixi@ddn.com>

Setxattr does not check the permission when setting ACL xattrs. This
will cause security problem because any user can walk around
permission checking by changing ACL rules.

Signed-off-by: Li Xi <lixi@ddn.com>
Reviewed-on: http://review.whamcloud.com/9473
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4704
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Bob Glossman <bob.glossman@intel.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/llite/xattr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/lustre/lustre/llite/xattr.c b/drivers/staging/lustre/lustre/llite/xattr.c
index b1ed4d9..67a1de4 100644
--- a/drivers/staging/lustre/lustre/llite/xattr.c
+++ b/drivers/staging/lustre/lustre/llite/xattr.c
@@ -124,6 +124,11 @@ int ll_setxattr_common(struct inode *inode, const char *name,
 	if (rc)
 		return rc;
 
+	if ((xattr_type == XATTR_ACL_ACCESS_T ||
+	     xattr_type == XATTR_ACL_DEFAULT_T) &&
+	    !inode_owner_or_capable(inode))
+		return -EPERM;
+
 	/* b10667: ignore lustre special xattr for now */
 	if ((xattr_type == XATTR_TRUSTED_T && strcmp(name, "trusted.lov") == 0) ||
 	    (xattr_type == XATTR_LUSTRE_T && strcmp(name, "lustre.lov") == 0))
-- 
1.8.5.3

