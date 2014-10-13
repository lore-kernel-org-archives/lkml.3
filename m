Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaJMCbA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:31:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46250 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbaJMCaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:30:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Cristian Stoica <cristian.stoica@freescale.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3.17 23/25] crypto: caam - fix addressing of struct member
Date: Mon, 13 Oct 2014 04:25:16 +0200
Message-Id: <20141013022455.273569465@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022454.289398272@linuxfoundation.org>
References: <20141013022454.289398272@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Stoica <cristian.stoica@freescale.com>

commit 4451d494b1910bf7b7f8381a637d0fe6d2142467 upstream.

buf_0 and buf_1 in caam_hash_state are not next to each other.
Accessing buf_1 is incorrect from &buf_0 with an offset of only
size_of(buf_0). The same issue is also with buflen_0 and buflen_1

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/caam/caamhash.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1413,9 +1413,9 @@ static int ahash_update_first(struct aha
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


