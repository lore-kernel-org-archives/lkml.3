Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbaKYLf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:35:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58461 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaKYKlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:36 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 093/254] evm: properly handle INTEGRITY_NOXATTRS EVM status
Date: Tue, 25 Nov 2014 10:37:23 +0000
Message-Id: <1416912004-5928-94-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Kasatkin <d.kasatkin@samsung.com>

commit 3dcbad52cf18c3c379e96b992d22815439ebbe53 upstream.

Unless an LSM labels a file during d_instantiate(), newly created
files are not labeled with an initial security.evm xattr, until
the file closes.  EVM, before allowing a protected, security xattr
to be written, verifies the existing 'security.evm' value is good.
For newly created files without a security.evm label, this
verification prevents writing any protected, security xattrs,
until the file closes.

Following is the example when this happens:
fd = open("foo", O_CREAT | O_WRONLY, 0644);
setxattr("foo", "security.SMACK64", value, sizeof(value), 0);
close(fd);

While INTEGRITY_NOXATTRS status is handled in other places, such
as evm_inode_setattr(), it does not handle it in all cases in
evm_protect_xattr().  By limiting the use of INTEGRITY_NOXATTRS to
newly created files, we can now allow setting "protected" xattrs.

Changelog:
- limit the use of INTEGRITY_NOXATTRS to IMA identified new files

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 security/integrity/evm/evm_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 9f5f923f7bfd..970772c731ff 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -284,6 +284,13 @@ static int evm_protect_xattr(struct dentry *dentry, const char *xattr_name,
 		goto out;
 	}
 	evm_status = evm_verify_current_integrity(dentry);
+	if (evm_status == INTEGRITY_NOXATTRS) {
+		struct integrity_iint_cache *iint;
+
+		iint = integrity_iint_find(dentry->d_inode);
+		if (iint && (iint->flags & IMA_NEW_FILE))
+			return 0;
+	}
 out:
 	if (evm_status != INTEGRITY_PASS)
 		integrity_audit_msg(AUDIT_INTEGRITY_METADATA, dentry->d_inode,
-- 
2.1.0

