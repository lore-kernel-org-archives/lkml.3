Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbaJ1Lck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:32:40 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24440 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbaJ1LcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:32:15 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-8a-544f7ebca1a4
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, jmorris@namei.org,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v3 2/3] ima: limit file hash setting by user to fix and log
 modes
Date: Tue, 28 Oct 2014 13:31:23 +0200
Message-id: <cbeced22716ee43c9381539ffe34b4f7ff037247.1414494901.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1414494901.git.d.kasatkin@samsung.com>
References: <cover.1414494901.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1414494901.git.d.kasatkin@samsung.com>
References: <cover.1414494901.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t/xy7p76vxDDHrOclnc+ruX2eLL0jqL
	2dObmSzWrV/MZPFyxjx2i8u75rBZfOh5xGbxacUkZgcOj52z7rJ7PDi0mcVj94LPTB4935M9
	+rasYvQ4s+AIu8fnTXIB7FFcNimpOZllqUX6dglcGd/2HWYpmMhZsfbnOtYGxjPsXYycHBIC
	JhJ/L7xhg7DFJC7cWw9kc3EICSxllGj5sowVwulkkvj8+QYTSBWbgJ7EhuYfYN0iAjkSj/68
	ZgcpYhboYJTY+OM6WJGwQLDE985HjF2MHBwsAqoSu355g4R5BeIkJv46zwSxTU7i5LHJrCA2
	p4CVRNeUVkYQW0jAUmLqvR84xScw8i9gZFjFKJpamlxQnJSea6RXnJhbXJqXrpecn7uJERKg
	X3cwLj1mdYhRgINRiYc3gsU/RIg1say4MvcQowQHs5IIb0QMUIg3JbGyKrUoP76oNCe1+BAj
	EwenVAOjecKjFHf9ZsWAmOSZStGtO/V3+95z2LphkvuuCYLVFy9P12j5LrBRi8fxwdInE5bw
	JwZ2+20Xutu7YqPkhq0lDzod327Lq3ne5z3n+pzofuF97V8t5t3Zy71MnCtXPe/loqoUq7dz
	SpUtQ8Ruzxa0/W38VP+WmfQ9Fqsvrsy3vvN+uVwlpLtLiaU4I9FQi7moOBEA4HJPDy4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File hashes are automatically set and updated and should not be
manually set. This patch limits file hash setting to fix and log
modes.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_appraise.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 7c8f41e..8549787 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -378,10 +378,14 @@ int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
 	result = ima_protect_xattr(dentry, xattr_name, xattr_value,
 				   xattr_value_len);
 	if (result == 1) {
+		bool digsig;
+
 		if (!xattr_value_len || (xvalue->type >= IMA_XATTR_LAST))
 			return -EINVAL;
-		ima_reset_appraise_flags(dentry->d_inode,
-			 (xvalue->type == EVM_IMA_XATTR_DIGSIG) ? 1 : 0);
+		digsig = (xvalue->type == EVM_IMA_XATTR_DIGSIG);
+		if (!digsig && (ima_appraise & IMA_APPRAISE_ENFORCE))
+			return -EPERM;
+		ima_reset_appraise_flags(dentry->d_inode, digsig);
 		result = 0;
 	}
 	return result;
-- 
1.9.1

