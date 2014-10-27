Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaJ0T0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:26:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52432 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbaJ0S5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:57:44 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Cristian Stoica <cristian.stoica@freescale.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 006/105] crypto: caam - fix addressing of struct member
Date: Mon, 27 Oct 2014 11:55:41 -0700
Message-Id: <1414436240-13879-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Stoica <cristian.stoica@freescale.com>

commit 4451d494b1910bf7b7f8381a637d0fe6d2142467 upstream.

buf_0 and buf_1 in caam_hash_state are not next to each other.
Accessing buf_1 is incorrect from &buf_0 with an offset of only
size_of(buf_0). The same issue is also with buflen_0 and buflen_1

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/crypto/caam/caamhash.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 0378328..a412745 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1348,9 +1348,9 @@ static int ahash_update_first(struct ahash_request *req)
 	struct device *jrdev = ctx->jrdev;
 	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
 		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
-	u8 *next_buf = state->buf_0 + state->current_buf *
-		       CAAM_MAX_HASH_BLOCK_SIZE;
-	int *next_buflen = &state->buflen_0 + state->current_buf;
+	u8 *next_buf = state->current_buf ? state->buf_1 : state->buf_0;
+	int *next_buflen = state->current_buf ?
+		&state->buflen_1 : &state->buflen_0;
 	int to_hash;
 	u32 *sh_desc = ctx->sh_desc_update_first, *desc;
 	dma_addr_t ptr = ctx->sh_desc_update_first_dma;
-- 
1.9.1

