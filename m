Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbaB1PBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:01:44 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:27975 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaB1PBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:01:38 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-0a-5310a4ce0a8c
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org, casey.schaufler@intel.com,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 3/8] ima: return d_name.name if d_path fails
Date: Fri, 28 Feb 2014 16:59:27 +0200
Message-id: <16a69bfbb1b120e0f9520fdbc5422bc6e2f811c3.1393599538.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1393599538.git.d.kasatkin@samsung.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1393599538.git.d.kasatkin@samsung.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xa7rnlggEG8x8rmFxY8UCJotbf/cy
	W3xZWmexbv1iJovLu+awWXzoecRm8WnFJGYHdo+ds+6yeyze85LJ48GhzSwePd+TPfq2rGL0
	+LxJLoAtissmJTUnsyy1SN8ugSuj8fMuloIvvBWvpj1nb2C8yt3FyMkhIWAicej+PRYIW0zi
	wr31bF2MXBxCAksZJZY0rWSCcDqZJN5sPsUGUsUmoCexofkHO4gtIuAssehWOytIEbPAVEaJ
	V7emgY0SFrCRWHnyMDOIzSKgKrF+Zw9YnFcgTuLKlgOsEOsUJJZ9WQtWwylgJbHl8j2wuJCA
	pcTVZ3PZcIlPYORfwMiwilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMkHL/uYFx6zOoQowAH
	oxIPr8QigWAh1sSy4srcQ4wSHMxKIryXFgOFeFMSK6tSi/Lji0pzUosPMTJxcEo1MO6tmcna
	/fF2eMaF1c/XV7zSCl2VUBFbL2r3zvdw6dajER9XXfbQ6fuqe+fK65r7LzKZ9xz9eneNXi+r
	uHDupO/qsY56PvYnrhdkd9TwzMvadfbRxFrFIJPD2xLtq96tZd10V+ziQ7HJMscEGQ91fLfK
	7PM8sPPT58SQOWeEJi9dOMHz195V+uxKLMUZiYZazEXFiQC/vvM/JQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_api.c  | 2 +-
 security/integrity/ima/ima_main.c | 7 +------
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index c6b4a73..ba9e4d7 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -332,5 +332,5 @@ const char *ima_d_path(struct path *path, char **pathbuf)
 			pathname = NULL;
 		}
 	}
-	return pathname;
+	return pathname ?: (const char *)path->dentry->d_name.name;
 }
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 50413d0..52ac6cf 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -79,7 +79,6 @@ __setup("ima_hash=", hash_setup);
  */
 static void ima_rdwr_violation_check(struct file *file)
 {
-	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = file_inode(file);
 	fmode_t mode = file->f_mode;
 	int must_measure;
@@ -111,8 +110,6 @@ out:
 		return;
 
 	pathname = ima_d_path(&file->f_path, &pathbuf);
-	if (!pathname || strlen(pathname) > IMA_EVENT_NAME_LEN_MAX)
-		pathname = dentry->d_name.name;
 
 	if (send_tomtou)
 		ima_add_violation(file, pathname, "invalid_pcr", "ToMToU");
@@ -220,9 +217,7 @@ static int process_measurement(struct file *file, const char *filename,
 	if (rc != 0)
 		goto out_digsig;
 
-	pathname = !filename ? ima_d_path(&file->f_path, &pathbuf) : filename;
-	if (!pathname)
-		pathname = (const char *)file->f_dentry->d_name.name;
+	pathname = filename ?: ima_d_path(&file->f_path, &pathbuf);
 
 	if (action & IMA_MEASURE)
 		ima_store_measurement(iint, file, pathname,
-- 
1.8.3.2

