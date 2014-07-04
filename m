Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbaGDMGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 08:06:52 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:59121 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbaGDMGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 08:06:49 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-87-53b698d5b3f1
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v3 3/3] ima: provide double buffering for hash calculation
Date: Fri, 04 Jul 2014 15:05:28 +0300
Message-id: <5fb7d6b759bfdf8bd573872de67e47acfe099b95.1404475462.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1404475462.git.d.kasatkin@samsung.com>
References: <cover.1404475462.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1404475462.git.d.kasatkin@samsung.com>
References: <cover.1404475462.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42I5/e/4Zd1rM7YFG3RzW9z6u5fZ4svSOov7
	934yWbycMY/d4vKuOWwWH3oesVl8WjGJ2YHdY+esu+weDw5tZvHYveAzk0ffllWMHp83yQWw
	RnHZpKTmZJalFunbJXBldF3cylYwVbbi8s6F7A2M98S6GDk5JARMJGY9OMoOYYtJXLi3nq2L
	kYtDSGApo8TzczNYIJxOJom9O5awgFSxCehJbGj+AdYhIpAjMenMBWaQImaBVkaJA4++M4Mk
	hAW8JH5v2MAKYrMIqEqcuNHFBmLzCsRJzJh2nwlinZzEyWOTwWo4BawkFkx8C9TLAbTNUuL0
	4xgcwhMY+RcwMqxiFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECAnALzsYFx+zOsQowMGoxMPb
	uGJDsBBrYllxZe4hRgkOZiUR3gN924KFeFMSK6tSi/Lji0pzUosPMTJxcEo1MHacOrPSKNAh
	rEX+TqvJVavK7S8Pzatl1arvPhYiGz33+qfLs8/tZbZjuhp9zNRMbKPgmpy1RRfFdz9p3ztf
	xZJ3je+De2YfhTapTLy19K/sviPLq8P2iq21kOuIzn9W3W3nVm7+xWPlbs47lpvNH2w4v5xl
	8brAPG8+gz9ef6bNSei+8O/geTMlluKMREMt5qLiRABz+FvyHgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Asynchronous hash API allows initiate hash calculation and perform
other tasks while hash is calculated.

This patch introduces usage of double buffering for simultaneous
hashing and reading of the next chunk of data from the storage.

Changes in v3:
- better comments

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_crypto.c | 67 ++++++++++++++++++++++++++++---------
 1 file changed, 51 insertions(+), 16 deletions(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 2340238..bc79531 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -253,12 +253,12 @@ static int ima_calc_file_hash_atfm(struct file *file,
 				   struct crypto_ahash *tfm)
 {
 	loff_t i_size, offset;
-	char *rbuf;
-	int rc, read = 0, rbuf_len;
+	char *rbuf[2] = { NULL, };
+	int rc, read = 0, rbuf_len, active = 0, ahash_rc = 0;
 	struct ahash_request *req;
 	struct scatterlist sg[1];
 	struct ahash_completion res;
-	size_t rbuf_size;
+	size_t rbuf_size[2];
 
 	hash->length = crypto_ahash_digestsize(tfm);
 
@@ -284,36 +284,71 @@ static int ima_calc_file_hash_atfm(struct file *file,
 	 * Try to allocate maximum size of memory.
 	 * Fail if not even single page cannot be allocated.
 	 */
-	rbuf = ima_alloc_pages(i_size, &rbuf_size, 1);
-	if (!rbuf) {
+	rbuf[0] = ima_alloc_pages(i_size, &rbuf_size[0], 1);
+	if (!rbuf[0]) {
 		rc = -ENOMEM;
 		goto out1;
 	}
 
+	/* Only allocate one buffer if that is enough. */
+	if (i_size > rbuf_size[0]) {
+		/*
+		 * Try to allocate secondary buffer. If that fails fallback to
+		 * using single buffering. Use previous memory allocation size
+		 * as baseline for possible allocation size.
+		 */
+		rbuf[1] = ima_alloc_pages(i_size - rbuf_size[0],
+					  &rbuf_size[1], 0);
+	}
+
 	if (!(file->f_mode & FMODE_READ)) {
 		file->f_mode |= FMODE_READ;
 		read = 1;
 	}
 
 	for (offset = 0; offset < i_size; offset += rbuf_len) {
-		rbuf_len = ima_kernel_read(file, offset, rbuf, PAGE_SIZE);
-		if (rbuf_len < 0) {
-			rc = rbuf_len;
-			break;
+		if (!rbuf[1] && offset) {
+			/* if we do not use second buffer and it is not the
+			 * the first read/request, then wait for completion
+			 * of ahash_update() request from the previous cycle
+			 * before reading to the same buffer
+			 */
+			rc = ahash_wait(ahash_rc, &res);
+			if (rc)
+				goto out3;
+		}
+		/* read buffer */
+		rbuf_len = min_t(loff_t, i_size - offset, rbuf_size[active]);
+		rc = ima_kernel_read(file, offset, rbuf[active], rbuf_len);
+		if (rc != rbuf_len)
+			goto out3;
+
+		if (rbuf[1] && offset) {
+			/* if we use second buffer and it is not the
+			 * first read/request, then wait for completion
+			 * of ahash_update() request from previous the cycle
+			 * before the next ahash_update()
+			 */
+			rc = ahash_wait(ahash_rc, &res);
+			if (rc)
+				goto out3;
 		}
-		if (rbuf_len == 0)
-			break;
 
-		sg_init_one(&sg[0], rbuf, rbuf_len);
+		sg_init_one(&sg[0], rbuf[active], rbuf_len);
 		ahash_request_set_crypt(req, sg, NULL, rbuf_len);
 
-		rc = ahash_wait(crypto_ahash_update(req), &res);
-		if (rc)
-			break;
+		ahash_rc = crypto_ahash_update(req);
+
+		if (rbuf[1])
+			active = !active; /* swap buffers, if we use two */
 	}
+	/* wait for the last update request to complete */
+	rc = ahash_wait(ahash_rc, &res);
+out3:
 	if (read)
 		file->f_mode &= ~FMODE_READ;
-	ima_free_pages(rbuf, rbuf_size);
+	ima_free_pages(rbuf[0], rbuf_size[0]);
+	ima_free_pages(rbuf[1], rbuf_size[1]);
 out2:
 	if (!rc) {
 		ahash_request_set_crypt(req, NULL, hash->digest, 0);
-- 
1.9.1

