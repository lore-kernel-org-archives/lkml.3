Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaB1PCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:02:36 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27750 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaB1PBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:01:38 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-ef-5310a4d0c890
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org, casey.schaufler@intel.com,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 5/8] ima: skip memory allocation for empty files
Date: Fri, 28 Feb 2014 16:59:29 +0200
Message-id: <3402bee04915e67f3d6c9db797edef0616d64d56.1393599538.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1393599538.git.d.kasatkin@samsung.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1393599538.git.d.kasatkin@samsung.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xa7oXlggEG7zaLmBxY8UCJotbf/cy
	W3xZWmexbv1iJovLu+awWXzoecRm8WnFJGYHdo+ds+6yeyze85LJ48GhzSwePd+TPfq2rGL0
	+LxJLoAtissmJTUnsyy1SN8ugStj//VPLAWfuCpOfX7P1sB4m6OLkZNDQsBEYvPbVkYIW0zi
	wr31bF2MXBxCAksZJdqffmSFcDqZJN6ducYEUsUmoCexofkHO4gtIuAssehWO1gRs8BURolX
	t6axgCSEBRwkHs6aCTaWRUBVovf4BqA4BwevQJzE1bVKENsUJJZ9WcsMYnMKWElsuXyPFcQW
	ErCUuPpsLhsu8QmM/AsYGVYxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihATjlx2Mi49ZHWIU
	4GBU4uGVWCQQLMSaWFZcmXuIUYKDWUmEd/p8oBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZG2yX7
	j57n2nw2xkiwN4TlksZkWbv1xTxVLy6cWhby6pSY3toj6ROcuSuFP+7izKyx+i/yb4ZefOF/
	RcEq/4nu9ZmbdS8v/8E3Y9vjg9bxNZ/+S8xTkr/90Zq7Ort5uUzbs09TIrQe8S37p315w9km
	4x0v/mrv9XpkbMhxzt1a5uH3S0+6dzFnKbEUZyQaajEXFScCAJvOed4kAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory allocation is unnecessary for empty files.
This patch finalize the hash without memory allocation.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_crypto.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index d257e36..1bde8e6 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -87,16 +87,20 @@ static int ima_calc_file_hash_tfm(struct file *file,
 	if (rc != 0)
 		return rc;
 
-	rbuf = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!rbuf) {
-		rc = -ENOMEM;
+	i_size = i_size_read(file_inode(file));
+
+	if (i_size == 0)
 		goto out;
-	}
+
+	rbuf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!rbuf)
+		return -ENOMEM;
+
 	if (!(file->f_mode & FMODE_READ)) {
 		file->f_mode |= FMODE_READ;
 		read = 1;
 	}
-	i_size = i_size_read(file_inode(file));
+
 	while (offset < i_size) {
 		int rbuf_len;
 
@@ -113,12 +117,12 @@ static int ima_calc_file_hash_tfm(struct file *file,
 		if (rc)
 			break;
 	}
-	kfree(rbuf);
-	if (!rc)
-		rc = crypto_shash_final(&desc.shash, hash->digest);
 	if (read)
 		file->f_mode &= ~FMODE_READ;
+	kfree(rbuf);
 out:
+	if (!rc)
+		rc = crypto_shash_final(&desc.shash, hash->digest);
 	return rc;
 }
 
-- 
1.8.3.2

