Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbaGAUOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 16:14:11 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:64384 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758656AbaGAUOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 16:14:08 -0400
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
X-Google-Original-From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v2 3/3] ima: provide double buffering for hash calculation
Date: Tue,  1 Jul 2014 23:12:51 +0300
Message-Id: <6ea50cc1ab984b5dd98e61be0c709a0b82d89dfb.1404245510.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1404245510.git.d.kasatkin@samsung.com>
References: <cover.1404245510.git.d.kasatkin@samsung.com>
In-Reply-To: <cover.1404245510.git.d.kasatkin@samsung.com>
References: <cover.1404245510.git.d.kasatkin@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Asynchronous hash API allows initiate hash calculation and perform
other tasks while hash is calculated.

This patch introduces usage of double buffering for simultaneous
hashing and reading of the next chunk of data from the storage.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_crypto.c | 63 +++++++++++++++++++++++++++----------
 1 file changed, 47 insertions(+), 16 deletions(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 41f2695..69d55a7 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -239,12 +239,12 @@ static int ima_calc_file_hash_atfm(struct file *file,
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
 
@@ -270,36 +270,67 @@ static int ima_calc_file_hash_atfm(struct file *file,
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
+		if (!rbuf[1] && offset) {
+			/* if we do not use second buffer and it is not the
+			 * the first read/request, then wait for completion
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
+			/* if we use second buffer and it is not the the first
+			 * read/request, then wait for completion
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

