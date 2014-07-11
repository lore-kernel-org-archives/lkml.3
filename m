Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaGKLsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 07:48:31 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:21003 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaGKLs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 07:48:27 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-e9-53bfcf08e8a8
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v1 1/3] ima: provide flag to identify new empty files
Date: Fri, 11 Jul 2014 14:46:59 +0300
Message-id: <ac60392e0118902ce9b308fdae09d633da1682af.1405078844.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1405078844.git.d.kasatkin@samsung.com>
References: <cover.1405078844.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1405078844.git.d.kasatkin@samsung.com>
References: <cover.1405078844.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t/xq7oc5/cHG0xdp29x6+9eZosvS+ss
	9uw9yWLxcsY8dovLu+awWXzoecRmcf7vcVaLTysmMTtweOycdZfd48GhzSweuxd8ZvLo27KK
	0ePzJjmPTU/eMgWwRXHZpKTmZJalFunbJXBlrL6/hLHgi3DFiZYbjA2MOwS6GDk5JARMJObc
	Xc8KYYtJXLi3ng3EFhJYyiixoi+wi5ELyO5kkpjVMoMZJMEmoCexofkHO4gtIpAjMenMBWaQ
	ImaBhYwS/6cuBZskLOAqcWbvWrAGFgFViTmvr7OA2LwCcRKL1kxlh9gmJ3Hy2GSwek4BK4kP
	izpZITZbSqyf9Q2n+ARG/gWMDKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQgLz6w7Gpces
	DjEKcDAq8fDOSN4fLMSaWFZcmXuIUYKDWUmE1/wsUIg3JbGyKrUoP76oNCe1+BAjEwenVAPj
	bnPOo/skhX9VGdxizuBysWvMeGm0R19HKDB5kZh4W7Lgxepzf5jimxslbsgF5BveZDEz1/DK
	etkqs5xtlbQv5z8rRxZetpI1HFGnXm7LN1gfszRb8oLQ9MxLK4R3XfXdXh6stST/fMGUeffP
	nX0833TZaundKlVJObkOFdcC06oeBjNPWqjEUpyRaKjFXFScCADD1p8uKgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newly created empty files do not get initial security.ima
value because iversion does not change. It can be checked from
the shell as:

  $ (exec >foo)
  $ getfattr -h -e hex -d -m security foo

This patch defines IMA_NEW_FILE flag which is set when IMA detects that new
file is created. It is checked upon ima_file_free hook to set initial
security.ima value.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_appraise.c |  7 +++++--
 security/integrity/ima/ima_main.c     | 12 +++++++-----
 security/integrity/integrity.h        |  1 +
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 9dd18b5..3a4beb3 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -194,8 +194,11 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
 			goto out;
 
 		cause = "missing-hash";
-		status =
-		    (inode->i_size == 0) ? INTEGRITY_PASS : INTEGRITY_NOLABEL;
+		status = INTEGRITY_NOLABEL;
+		if (inode->i_size == 0) {
+			iint->flags |= IMA_NEW_FILE;
+			status = INTEGRITY_PASS;
+		}
 		goto out;
 	}
 
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index e51e0d5..5a870e7 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -124,11 +124,13 @@ static void ima_check_last_writer(struct integrity_iint_cache *iint,
 		return;
 
 	mutex_lock(&iint->mutex);
-	if (atomic_read(&inode->i_writecount) == 1 &&
-	    iint->version != inode->i_version) {
-		iint->flags &= ~IMA_DONE_MASK;
-		if (iint->flags & IMA_APPRAISE)
-			ima_update_xattr(iint, file);
+	if (atomic_read(&inode->i_writecount) == 1) {
+		if ((iint->version != inode->i_version) ||
+		    (iint->flags & IMA_NEW_FILE)) {
+			iint->flags &= ~(IMA_DONE_MASK | IMA_NEW_FILE);
+			if (iint->flags & IMA_APPRAISE)
+				ima_update_xattr(iint, file);
+		}
 	}
 	mutex_unlock(&iint->mutex);
 }
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 92c1083..7656d47 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -30,6 +30,7 @@
 #define IMA_ACTION_FLAGS	0xff000000
 #define IMA_DIGSIG_REQUIRED	0x01000000
 #define IMA_PERMIT_DIRECTIO	0x02000000
+#define IMA_NEW_FILE		0x04000000
 
 #define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT | \
 				 IMA_APPRAISE_SUBMASK)
-- 
1.9.1

