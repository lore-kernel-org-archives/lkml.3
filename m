Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbaFWNUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:20:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37007 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbaFWNEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:04:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Harald Freudenberger <freude@linux.vnet.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 51/93] crypto: s390 - fix aes,des ctr mode concurrency finding.
Date: Mon, 23 Jun 2014 14:02:30 +0100
Message-Id: <1403528592-2163-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.vnet.ibm.com>

commit 3901c1124ec5099254a9396085f7798153a7293f upstream.

An additional testcase found an issue with the last
series of patches applied: the fallback solution may
not save the iv value after operation. This very small
fix just makes sure the iv is copied back to the
walk/desc struct.

Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/s390/crypto/aes_s390.c | 3 +++
 arch/s390/crypto/des_s390.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 2a245b55bb71..fd104db9cea1 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -818,6 +818,9 @@ static int ctr_aes_crypt(struct blkcipher_desc *desc, long func,
 		else
 			memcpy(walk->iv, ctrptr, AES_BLOCK_SIZE);
 		spin_unlock(&ctrblk_lock);
+	} else {
+		if (!nbytes)
+			memcpy(walk->iv, ctrptr, AES_BLOCK_SIZE);
 	}
 	/*
 	 * final block may be < AES_BLOCK_SIZE, copy only nbytes
diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
index 2d96e68febb2..f2d6cccddcf8 100644
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -429,6 +429,9 @@ static int ctr_desall_crypt(struct blkcipher_desc *desc, long func,
 		else
 			memcpy(walk->iv, ctrptr, DES_BLOCK_SIZE);
 		spin_unlock(&ctrblk_lock);
+	} else {
+		if (!nbytes)
+			memcpy(walk->iv, ctrptr, DES_BLOCK_SIZE);
 	}
 	/* final block may be < DES_BLOCK_SIZE, copy only nbytes */
 	if (nbytes) {
-- 
1.9.1

