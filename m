Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaGKLte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 07:49:34 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:21003 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbaGKLs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 07:48:28 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-39-53bfcf099b2e
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v1 2/3] evm: skip integrity verification for newly created files
Date: Fri, 11 Jul 2014 14:47:00 +0300
Message-id: <5e9ede3ece0eb19bf5468826ea05aed5d8207cf1.1405078844.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1405078844.git.d.kasatkin@samsung.com>
References: <cover.1405078844.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1405078844.git.d.kasatkin@samsung.com>
References: <cover.1405078844.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t/xq7qc5/cHG+w7o2px6+9eZosvS+ss
	9uw9yWLxcsY8dovLu+awWXzoecRmcf7vcVaLTysmMTtweOycdZfd48GhzSweuxd8ZvLo27KK
	0ePzJjmPTU/eMgWwRXHZpKTmZJalFunbJXBlnJqaWLCQq+LqpktMDYznOLoYOTkkBEwkdt/c
	zAxhi0lcuLeerYuRi0NIYCmjxJrN15kgnE4miSe/5rCAVLEJ6ElsaP7BDmKLCORITDpzgRmk
	iFlgIaPE/6lLWUESwgIBEn9mfmUEsVkEVCVa7h8Bi/MKxElM6u1jglgnJ3Hy2GSwOKeAlcSH
	RZ1gtpCApcT6Wd9wik9g5F/AyLCKUTS1NLmgOCk911CvODG3uDQvXS85P3cTIyQwv+xgXHzM
	6hCjAAejEg+vRu3uYCHWxLLiytxDjBIczEoivOZn9wcL8aYkVlalFuXHF5XmpBYfYmTi4JRq
	YFzg+cfo3xY3tuTuPwus9k5S0AutZpvvVH/xsv+Vc3/yZyqWHD9i97necIVNTv/GBettthQf
	tC74I8Wf0J/ntMHa+yhDjbzKhPd3mf/EXX85f3nLrbk7T70peXQlde7JiWsPRh522Xp5Qu+j
	nSfrmXIXljJwsb788Ml75jOj5/8a84r0fwrbPtyqxFKckWioxVxUnAgAFXFSaCoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newly created files do not get initial security.ima until close.
Setting xattr value before close fails because EVM fails to verify
integrity due to missing xattrs. Following is the example when it
happens:
  fd = open("foo", O_CREAT | O_WRONLY, 0644);
  setxattr("foo", "security.SMACK64", value, sizeof(value), 0);
  close(fd);

This patch skips integrity verification if IMA_NEW_FILE flag is set.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/evm/evm_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 3bcb80d..682e640 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -248,10 +248,14 @@ EXPORT_SYMBOL_GPL(evm_verifyxattr);
 static enum integrity_status evm_verify_current_integrity(struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
+	struct integrity_iint_cache *iint;
 
 	if (!evm_initialized || !S_ISREG(inode->i_mode) || evm_fixmode)
 		return 0;
-	return evm_verify_hmac(dentry, NULL, NULL, 0, NULL);
+	iint = integrity_iint_find(inode);
+	if (iint && (iint->flags & IMA_NEW_FILE))
+		return 0;
+	return evm_verify_hmac(dentry, NULL, NULL, 0, iint);
 }
 
 /*
-- 
1.9.1

