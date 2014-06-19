Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbaFSPVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:21:43 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:61049 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543AbaFSPVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:21:31 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-ca-53a2fff8d8f2
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v1 3/3] ima: provide double buffering for hash calculation
Date: Thu, 19 Jun 2014 18:20:40 +0300
Message-id: <ce794ff88aeda05b6b41264d64903d204c1a008b.1403191191.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1403191191.git.d.kasatkin@samsung.com>
References: <cover.1403191191.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1403191191.git.d.kasatkin@samsung.com>
References: <cover.1403191191.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e/4Nd0f/xcFG1zbr2xx6+9eZosvS+ss
	7t/7yWTxcsY8dovLu+awWXzoecRm8WnFJGYHdo+ds+6yezw4tJnFY/eCz0wefVtWMXp83iQX
	wBrFZZOSmpNZllqkb5fAlfH39GGWgn6pivuLLzA1MB4R6WLk5JAQMJGYOO86M4QtJnHh3nq2
	LkYuDiGBpYwSP8/tYYdwOpkkJt48xQhSxSagJ7Gh+Qc7iC0i0MUocfGZMojNLJAu8WlSL1hc
	WMBLYmLXarB6FgFViae/GphAbF6BOIkz79vYILbJSZw8NpkVxOYUsJK4NPcGWL2QgKXE/kk7
	GXGJT2DkX8DIsIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJAi/7GBcfMzqEKMAB6MSD++H
	twuChVgTy4orcw8xSnAwK4nw7v66KFiINyWxsiq1KD++qDQntfgQIxMHp1QDo8Ceoh3fHRft
	/7P1bUfELZU01l5Gbt94x56f8uf+q8cpfXivxfSL4ekJPw2NttibPv4nORIzvyvMctl/rajo
	lE9TX+MSizilV5a3nNNv6gVqb23ynTZpym2jY+euTpw3R3xS5jade161Bbvn/5lz96DV+n57
	xn5OpY37LrtwSNWluXEG25xsVmIpzkg01GIuKk4EABvndlcgAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Asynchronous hash API allows initiate hash calculation and perform
other tasks while hash is calculated.

This patch introduces usage of double buffering for simultenous
hashing and reading of the next chunk of data from the storage.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_crypto.c | 59 +++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 16 deletions(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 9e9414e..e6bef4b 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -244,12 +244,12 @@ static int ima_calc_file_hash_atfm(struct file *file,
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
 
@@ -275,36 +275,63 @@ static int ima_calc_file_hash_atfm(struct file *file,
 	 * Try to allocate maximum size of memory, fail if not even single
 	 * page cannot be allocated.
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
+		 * Try to allocate secondary buffer if that fails fallback to
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
+		if (offset && !rbuf[1]) {
+			/* wait for completion of previous request */
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
+		if (offset && rbuf[1]) {
+			/* wait for completion of previous request */
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
+			active = !active; /* swap buffers. */
 	}
+	/* wait for the last request to complete */
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

