Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbaJASoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:44:15 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:61320 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbaJASnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:43:10 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
X-Google-Original-From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v2 2/4] evm: skip replacing EVM signature with HMAC on read-only filesystem
Date: Wed,  1 Oct 2014 21:43:08 +0300
Message-Id: <f4491603beb80e91907a388fcd64f3eb2a8d254a.1412188590.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1412188590.git.d.kasatkin@samsung.com>
References: <cover.1412188590.git.d.kasatkin@samsung.com>
In-Reply-To: <cover.1412188590.git.d.kasatkin@samsung.com>
References: <cover.1412188590.git.d.kasatkin@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If filesystem is mounted read-only or file is immutable, updating
xattr will fail. This is a usual case during early boot until
filesystem is remount read-write. This patch verifies conditions
to skip unnecessary attempt to calculate HMAC and set xattr.

Changes in v2:
* indention changed according to Lindent (requested by Mimi)

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/evm/evm_main.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 9685af3..b392fe6 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -162,9 +162,14 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 					(const char *)xattr_data, xattr_len,
 					calc.digest, sizeof(calc.digest));
 		if (!rc) {
-			/* we probably want to replace rsa with hmac here */
-			evm_update_evmxattr(dentry, xattr_name, xattr_value,
-				   xattr_value_len);
+			/* Replace RSA with HMAC if not mounted readonly and
+			 * not immutable
+			 */
+			if (!IS_RDONLY(dentry->d_inode) &&
+			    !IS_IMMUTABLE(dentry->d_inode))
+				evm_update_evmxattr(dentry, xattr_name,
+						    xattr_value,
+						    xattr_value_len);
 		}
 		break;
 	default:
-- 
1.9.1

