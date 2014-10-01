Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbaJASnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:43:16 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:53430 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbaJASnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:43:12 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
X-Google-Original-From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v2 4/4] ima: use path names cache
Date: Wed,  1 Oct 2014 21:43:10 +0300
Message-Id: <001f215b384c3079ce0d21cceefa527761017856.1412188590.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1412188590.git.d.kasatkin@samsung.com>
References: <cover.1412188590.git.d.kasatkin@samsung.com>
In-Reply-To: <cover.1412188590.git.d.kasatkin@samsung.com>
References: <cover.1412188590.git.d.kasatkin@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__getname() uses slab allocation which is faster than kmalloc.
Make use of it.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_api.c  | 4 ++--
 security/integrity/ima/ima_main.c | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 8688597..a99eb6d 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -325,11 +325,11 @@ const char *ima_d_path(struct path *path, char **pathbuf)
 {
 	char *pathname = NULL;
 
-	*pathbuf = kmalloc(PATH_MAX, GFP_KERNEL);
+	*pathbuf = __getname();
 	if (*pathbuf) {
 		pathname = d_absolute_path(path, *pathbuf, PATH_MAX);
 		if (IS_ERR(pathname)) {
-			kfree(*pathbuf);
+			__putname(*pathbuf);
 			*pathbuf = NULL;
 			pathname = NULL;
 		}
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 87d7df7..003d6b6 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -246,7 +246,8 @@ out_digsig:
 		rc = -EACCES;
 	kfree(xattr_value);
 out_free:
-	kfree(pathbuf);
+	if (pathbuf)
+		__putname(pathbuf);
 out:
 	mutex_unlock(&inode->i_mutex);
 	if ((rc && must_appraise) && (ima_appraise & IMA_APPRAISE_ENFORCE))
-- 
1.9.1

