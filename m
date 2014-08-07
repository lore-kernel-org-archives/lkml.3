Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135AbaHGQwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:52:45 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23666 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbaHGQwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:52:43 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-c4-53e3aed8b658
Subject: [PATCH 1/3] Smack: fix behavior of smack_inode_listsecurity
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Date: Thu, 07 Aug 2014 20:52:33 +0400
Message-id: <20140807165233.13463.55258.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t/xK7o31j0ONpjwVM7i3rZfbBZ9j4Ms
	fuzsZbW4vGsOm8WHnkdsFucvnGN3YPO4tjvS4+PTWywefVtWMXoc3b+IzePzJrkA1igum5TU
	nMyy1CJ9uwSujMYjbxgLFnNVLOjex9zAuIWji5GTQ0LAROLquRXsELaYxIV769m6GLk4hASW
	Mkp8OXSSEcJpZJLo27kMrEpYwEWia91zFhCbTcBMYtu+24wgtoiAjsS+Pc/ZQRqYBWYySmxd
	f4qpi5GDg0VAVWL1GUWQGl4BY4mL+7qYQWxRATmJlZdbWCHighI/Jt9jASlnFlCXmDIlFyTM
	LCAvsXnNW+YJjHyzkFTNQqiahaRqASPzKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQIP2y
	g3HxMatDjAIcjEo8vAan7wYLsSaWFVfmHmKU4GBWEuHV7X4cLMSbklhZlVqUH19UmpNafIiR
	iYNTqoFRZqvFf++6kqPf1NJLf2jPvtxd+iGzw9Jdszs1g3m589kl8zlvT7FZcXES06yWW0X3
	P97nOqz3w1uGpfy30MrZ9qvSllh/3PtxxtXw72ZXPonJhtTu3fbQUTkwxnrizjNdJV2hzb+v
	r2eyMnrsccZNKpqjOvEf19fLu95X5kRa5ZpbnlKfG/lRiaU4I9FQi7moOBEA0vNglzACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Security operation ->inode_listsecurity is used for generating list of
available extended attributes for syscall listxattr. Currently it's used
only in nfs4 or if filesystem doesn't provide i_op->listxattr.

The list is the set of NULL-terminated names, one after the other.
This method must include zero byte at the and into result.

Also this function must return length even if string does not fit into
output buffer or it is NULL, see similar method in selinux and man listxattr.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
---
 security/smack/smack_lsm.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index e6ab307..b11ab23 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1122,13 +1122,12 @@ static int smack_inode_getsecurity(const struct inode *inode,
 static int smack_inode_listsecurity(struct inode *inode, char *buffer,
 				    size_t buffer_size)
 {
-	int len = strlen(XATTR_NAME_SMACK);
+	int len = sizeof(XATTR_NAME_SMACK);
 
-	if (buffer != NULL && len <= buffer_size) {
+	if (buffer != NULL && len <= buffer_size)
 		memcpy(buffer, XATTR_NAME_SMACK, len);
-		return len;
-	}
-	return -EINVAL;
+
+	return len;
 }
 
 /**

