Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbaDCLtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 07:49:06 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49904 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbaDCLsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 07:48:51 -0400
From: =?UTF-8?q?Jos=C3=A9=20Bollo?= <jose.bollo@open.eurogiciel.org>
To: Casey Schaufler <casey@schaufler-ca.com>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jobol@nonadev.net,
        =?UTF-8?q?Jos=C3=A9=20Bollo?= <jose.bollo@open.eurogiciel.org>
Subject: [PATCH 1/1] SMACK: Fix handling value==NULL in post setxattr
Date: Thu,  3 Apr 2014 13:48:41 +0200
Message-Id: <1396525721-17307-1-git-send-email-jose.bollo@open.eurogiciel.org>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function `smack_inode_post_setxattr` is called each
time that a setxattr is done, for any value of name.
The kernel allow to put value==NULL when size==0
to set an empty attribute value. The systematic
call to smk_import_entry was causing the dereference
of a NULL pointer hence a KERNEL PANIC!

The problem can be produced easily by issuing the
command `setfattr -n user.data file` under bash prompt
when SMACK is active.

Moving the call to smk_import_entry as proposed by this
patch is correcting the behaviour because the function
smack_inode_post_setxattr is called for the SMACK's
attributes only if the function smack_inode_setxattr validated
the value and its size (what will not be the case when size==0).

It also has a benefical effect to not fill the smack hash
with garbage values coming from any extended attribute
write.

Change-Id: Iaf0039c2be9bccb6cee11c24a3b44d209101fe47
Signed-off-by: José Bollo <jose.bollo@open.eurogiciel.org>
---
 security/smack/smack_lsm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 3f01cf5..28d482c 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -893,18 +893,20 @@ static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
 		return;
 	}
 
-	skp = smk_import_entry(value, size);
 	if (strcmp(name, XATTR_NAME_SMACK) == 0) {
+		skp = smk_import_entry(value, size);
 		if (skp != NULL)
 			isp->smk_inode = skp->smk_known;
 		else
 			isp->smk_inode = smack_known_invalid.smk_known;
 	} else if (strcmp(name, XATTR_NAME_SMACKEXEC) == 0) {
+		skp = smk_import_entry(value, size);
 		if (skp != NULL)
 			isp->smk_task = skp;
 		else
 			isp->smk_task = &smack_known_invalid;
 	} else if (strcmp(name, XATTR_NAME_SMACKMMAP) == 0) {
+		skp = smk_import_entry(value, size);
 		if (skp != NULL)
 			isp->smk_mmap = skp;
 		else
-- 
1.8.1.4

