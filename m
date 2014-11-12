Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964796AbaKLBit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:38:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59974 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932661AbaKLBiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:38:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH 3.14 036/203] evm: properly handle INTEGRITY_NOXATTRS EVM status
Date: Wed, 12 Nov 2014 10:15:06 +0900
Message-Id: <20141112011544.371799546@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/integrity/evm/evm_main.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -269,6 +269,13 @@ static int evm_protect_xattr(struct dent
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


