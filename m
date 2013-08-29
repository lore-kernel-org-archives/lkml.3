Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab3H2Ohh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:37:37 -0400
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:35419 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab3H2Ohb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:37:31 -0400
From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
To: herbert@gondor.hengli.com.au
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org,
        Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Subject: [PATCH v2 10/10] crypto: nx - fix SHA-2 for chunks bigger than block size
Date: Thu, 29 Aug 2013 11:36:40 -0300
Message-Id: <1377787000-4966-11-git-send-email-mhcerri@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1377787000-4966-1-git-send-email-mhcerri@linux.vnet.ibm.com>
References: <1377787000-4966-1-git-send-email-mhcerri@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082914-1524-0000-0000-0000072C1278
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each call to the co-processor, with exception of the last call, needs to
send data that is multiple of block size. As consequence, any remaining
data is kept in the internal NX context.

This patch fixes a bug in the driver that causes it to save incorrect
data into the context when data is bigger than the block size.

Reviewed-by: Joy Latten <jmlatten@linux.vnet.ibm.com>
Signed-off-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx-sha256.c | 2 +-
 drivers/crypto/nx/nx-sha512.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/nx/nx-sha256.c b/drivers/crypto/nx/nx-sha256.c
index 6547a71..da0b24a 100644
--- a/drivers/crypto/nx/nx-sha256.c
+++ b/drivers/crypto/nx/nx-sha256.c
@@ -129,7 +129,7 @@ static int nx_sha256_update(struct shash_desc *desc, const u8 *data,
 		NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
 
 		total -= to_process;
-		data += to_process;
+		data += to_process - sctx->count;
 		sctx->count = 0;
 		in_sg = nx_ctx->in_sg;
 	} while (leftover >= SHA256_BLOCK_SIZE);
diff --git a/drivers/crypto/nx/nx-sha512.c b/drivers/crypto/nx/nx-sha512.c
index 236e6af..4ae5b0f 100644
--- a/drivers/crypto/nx/nx-sha512.c
+++ b/drivers/crypto/nx/nx-sha512.c
@@ -131,7 +131,7 @@ static int nx_sha512_update(struct shash_desc *desc, const u8 *data,
 		NX_CPB_FDM(csbcpb) |= NX_FDM_CONTINUATION;
 
 		total -= to_process;
-		data += to_process;
+		data += to_process - sctx->count[0];
 		sctx->count[0] = 0;
 		in_sg = nx_ctx->in_sg;
 	} while (leftover >= SHA512_BLOCK_SIZE);
-- 
1.7.12

