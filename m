Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbaFDX2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:28:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbaFDXYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:24:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.vnet.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3.10 097/103] crypto: s390 - fix aes,des ctr mode concurrency finding.
Date: Wed,  4 Jun 2014 16:26:00 -0700
Message-Id: <20140604232549.996740205@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232546.704156131@linuxfoundation.org>
References: <20140604232546.704156131@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/crypto/aes_s390.c |    3 +++
 arch/s390/crypto/des_s390.c |    3 +++
 2 files changed, 6 insertions(+)

--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -818,6 +818,9 @@ static int ctr_aes_crypt(struct blkciphe
 		else
 			memcpy(walk->iv, ctrptr, AES_BLOCK_SIZE);
 		spin_unlock(&ctrblk_lock);
+	} else {
+		if (!nbytes)
+			memcpy(walk->iv, ctrptr, AES_BLOCK_SIZE);
 	}
 	/*
 	 * final block may be < AES_BLOCK_SIZE, copy only nbytes
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -429,6 +429,9 @@ static int ctr_desall_crypt(struct blkci
 		else
 			memcpy(walk->iv, ctrptr, DES_BLOCK_SIZE);
 		spin_unlock(&ctrblk_lock);
+	} else {
+		if (!nbytes)
+			memcpy(walk->iv, ctrptr, DES_BLOCK_SIZE);
 	}
 	/* final block may be < DES_BLOCK_SIZE, copy only nbytes */
 	if (nbytes) {


