Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbaHNKw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 06:52:58 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:51162
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754686AbaHNKwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 06:52:53 -0400
From: Cristian Stoica <cristian.stoica@freescale.com>
To: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>
Subject: [PATCH 2/2] crypto: caamhash.c: fix addressing of struct member
Date: Thu, 14 Aug 2014 13:51:57 +0300
Message-ID: <1408013517-15526-3-git-send-email-cristian.stoica@freescale.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1408013517-15526-1-git-send-email-cristian.stoica@freescale.com>
References: <1408013517-15526-1-git-send-email-cristian.stoica@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(84676001)(102836001)(31966008)(50466002)(81542001)(81342001)(79102001)(80022001)(48376002)(76482001)(77982001)(46102001)(26826002)(62966002)(86362001)(93916002)(68736004)(104166001)(69596002)(97736001)(4396001)(83322001)(85852003)(74662001)(19580395003)(74502001)(19580405001)(89996001)(88136002)(6806004)(50226001)(44976005)(83072002)(76176999)(36756003)(99396002)(106466001)(33646002)(85306004)(104016003)(20776003)(47776003)(77156001)(64706001)(107046002)(92726001)(50986999)(95666004)(92566001)(229853001)(87286001)(87936001)(105606002)(21056001)(81156004)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB398;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 03030B9493
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=cristian.stoica@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

buf_0 and buf_1 in caam_hash_state are not next to each other.
Accessing buf_1 is incorrect from &buf_0 with an offset of only
size_of(buf_0). The same issue is also with buflen_0 and buflen_1

Cc: <stable@vger.kernel.org> # 3.13+
Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 drivers/crypto/caam/caamhash.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 061f3fb..f347ab7 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1417,9 +1417,9 @@ static int ahash_update_first(struct ahash_request *req)
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
1.8.3.1

