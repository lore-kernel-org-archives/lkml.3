Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbaDWNu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:50:58 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55980 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700AbaDWN3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:29:53 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-80-5357c05168a2
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jmorris@namei.org
Cc: roberto.sassu@polito.it, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 12/20] ima: provide buffer hash calculation function
Date: Wed, 23 Apr 2014 16:30:30 +0300
Message-id: <1b9253e91b214bb67d4fdd9297f9734d7c4cb6cc.1398259638.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1398259638.git.d.kasatkin@samsung.com>
References: <cover.1398259638.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xq7qBB8KDDd6dYLW49Xcvs8W7pt8s
	FuvWL2ayuLxrDpvFh55HbBYvd31jt/i0YhKzA7vHg0ObWTx6vid7nF5Z7PF+31U2j74tqxg9
	Pm+SC2CL4rJJSc3JLEst0rdL4Mo4cf0Ae8ErwYrJKyeyNjDe5eti5OCQEDCRON7J1cXICWSK
	SVy4t56ti5GLQ0hgKaPE6bMtjBBOJ5PEjI0/mUGq2AT0JDY0/2AHsUUEXCR2z+ljAiliFuhh
	lNj9ZzFYkTBQYs7hz6wgNouAqkTLx6NgDbwCcRI7T89ihFinILHsy1qwek4BK4k/zdPBaoQE
	LCW+T5qMU3wCI/8CRoZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCHB+GUH4+JjVocYBTgY
	lXh4JZaHBQuxJpYVV+YeYpTgYFYS4V2yKDxYiDclsbIqtSg/vqg0J7X4ECMTB6dUAyO3lCHf
	jp/zvzlN0mPT3fKn1Lvlymwnu4/XK2WXHhGcuzNyUvz+L8qWLinM57xYNe/kylu9n7nYeZ12
	kddbe1bFTU/6dn1++v/M3OzXW78ucv77MCZn1Y1kjlKeoI1Xsycxta0q0oq5XObJuUXXvUtn
	v6Zq5KmyTRsnV91fUl4uMotlhs7ZeTOVWIozEg21mIuKEwHp5UK0JAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides convenient buffer hash calculation function.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima.h        |  1 +
 security/integrity/ima/ima_crypto.c | 11 +++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index f4c1e8dd..a5d5ccb 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -98,6 +98,7 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 			   const char *op, struct inode *inode,
 			   const unsigned char *filename);
 int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash);
+int ima_calc_buffer_hash(const void *buf, int len, struct ima_digest_data *hash);
 int ima_calc_field_array_hash(struct ima_field_data *field_data,
 			      struct ima_template_desc *desc, int num_fields,
 			      struct ima_digest_data *hash);
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 139e7f7..50c78c0 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -434,13 +434,13 @@ static int ima_calc_field_array_hash_tfm(struct ima_field_data *field_data,
 		u8 *data_to_hash = field_data[i].data;
 		u32 datalen = field_data[i].len;
 
-		if (strcmp(td->name, IMA_TEMPLATE_IMA_NAME) != 0) {
+		if (td && strcmp(td->name, IMA_TEMPLATE_IMA_NAME) != 0) {
 			rc = crypto_shash_update(&desc.shash,
 						(const u8 *) &field_data[i].len,
 						sizeof(field_data[i].len));
 			if (rc)
 				break;
-		} else if (strcmp(td->fields[i]->field_id, "n") == 0) {
+		} else if (td && strcmp(td->fields[i]->field_id, "n") == 0) {
 			memcpy(buffer, data_to_hash, datalen);
 			data_to_hash = buffer;
 			datalen = IMA_EVENT_NAME_LEN_MAX + 1;
@@ -475,6 +475,13 @@ int ima_calc_field_array_hash(struct ima_field_data *field_data,
 	return rc;
 }
 
+int ima_calc_buffer_hash(const void *buf, int len, struct ima_digest_data *hash)
+{
+	struct ima_field_data fd = { .data = (u8 *)buf, .len = len };
+
+	return ima_calc_field_array_hash(&fd, NULL, 1, hash);
+}
+
 static void __init ima_pcrread(int idx, u8 *pcr)
 {
 	if (!ima_used_chip)
-- 
1.8.3.2

