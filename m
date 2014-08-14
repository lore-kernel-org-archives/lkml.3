Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbaHNKxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 06:53:20 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:18663
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754334AbaHNKww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 06:52:52 -0400
From: Cristian Stoica <cristian.stoica@freescale.com>
To: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>
Subject: [PATCH 1/2] crypto: caamhash.c: remove duplicated sg copy functions
Date: Thu, 14 Aug 2014 13:51:56 +0300
Message-ID: <1408013517-15526-2-git-send-email-cristian.stoica@freescale.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1408013517-15526-1-git-send-email-cristian.stoica@freescale.com>
References: <1408013517-15526-1-git-send-email-cristian.stoica@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(26826002)(89996001)(19580395003)(87286001)(47776003)(92726001)(62966002)(81156004)(76482001)(93916002)(50986999)(79102001)(48376002)(85306004)(87936001)(81342001)(19580405001)(76176999)(50466002)(107046002)(104016003)(229853001)(21056001)(83322001)(33646002)(105606002)(84676001)(97736001)(104166001)(77982001)(64706001)(74502001)(6806004)(4396001)(99396002)(68736004)(85852003)(20776003)(50226001)(80022001)(74662001)(36756003)(575784001)(92566001)(88136002)(102836001)(106466001)(95666004)(86362001)(83072002)(44976005)(69596002)(81542001)(77156001)(46102001)(31966008)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB386;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03030B9493
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=cristian.stoica@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace equivalent (and partially incorrect) scatter-gather functions
with ones from crypto-API.

The replacement is motivated by page-faults in sg_copy_part triggered
by successive calls to crypto_hash_update. The following fault appears
after calling crypto_ahash_update twice, first with 13 and then
with 285 bytes:

Unable to handle kernel paging request for data at address 0x00000008
Faulting instruction address: 0xf9bf9a8c
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=8 CoreNet Generic
Modules linked in: tcrypt(+) caamhash caam_jr caam tls
CPU: 6 PID: 1497 Comm: cryptomgr_test Not tainted
3.12.19-rt30-QorIQ-SDK-V1.6+g9fda9f2 #75
task: e9308530 ti: e700e000 task.ti: e700e000
NIP: f9bf9a8c LR: f9bfcf28 CTR: c0019ea0
REGS: e700fb80 TRAP: 0300   Not tainted
(3.12.19-rt30-QorIQ-SDK-V1.6+g9fda9f2)
MSR: 00029002 <CE,EE,ME>  CR: 44f92024  XER: 20000000
DEAR: 00000008, ESR: 00000000

GPR00: f9bfcf28 e700fc30 e9308530 e70b1e55 00000000 ffffffdd e70b1e54 0bebf888
GPR08: 902c7ef5 c0e771e2 00000002 00000888 c0019ea0 00000000 00000000 c07a4154
GPR16: c08d0000 e91a8f9c 00000001 e98fb400 00000100 e9c83028 e70b1e08 e70b1d48
GPR24: e992ce10 e70b1dc8 f9bfe4f4 e70b1e55 ffffffdd e70b1ce0 00000000 00000000
NIP [f9bf9a8c] sg_copy+0x1c/0x100 [caamhash]
LR [f9bfcf28] ahash_update_no_ctx+0x628/0x660 [caamhash]
Call Trace:
[e700fc30] [f9bf9c50] sg_copy_part+0xe0/0x160 [caamhash] (unreliable)
[e700fc50] [f9bfcf28] ahash_update_no_ctx+0x628/0x660 [caamhash]
[e700fcb0] [f954e19c] crypto_tls_genicv+0x13c/0x300 [tls]
[e700fd10] [f954e65c] crypto_tls_encrypt+0x5c/0x260 [tls]
[e700fd40] [c02250ec] __test_aead.constprop.9+0x2bc/0xb70
[e700fe40] [c02259f0] alg_test_aead+0x50/0xc0
[e700fe60] [c02241e4] alg_test+0x114/0x2e0
[e700fee0] [c022276c] cryptomgr_test+0x4c/0x60
[e700fef0] [c004f658] kthread+0x98/0xa0
[e700ff40] [c000fd04] ret_from_kernel_thread+0x5c/0x64
--- Exception: 0 at   (null)
    LR =   (null)
Instruction dump:
bba10014 7c0803a6 38210020 480042b0 60000000 9421ffe0 7c0802a6 bf410008
7c9f2378 90010024 7cbc2b78 7c7b1b78 <83c40008> 7f9e2840 40dc00d0
7fddf378
---[ end trace a4a18a1094a0306c ]---

Cc: <stable@vger.kernel.org> # 3.13+
Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 drivers/crypto/caam/caamhash.c   | 22 ++++++++++------
 drivers/crypto/caam/sg_sw_sec4.h | 54 ----------------------------------------
 2 files changed, 14 insertions(+), 62 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index b464d03..061f3fb 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -836,8 +836,9 @@ static int ahash_update_ctx(struct ahash_request *req)
 					   edesc->sec4_sg + sec4_sg_src_index,
 					   chained);
 			if (*next_buflen) {
-				sg_copy_part(next_buf, req->src, to_hash -
-					     *buflen, req->nbytes);
+				scatterwalk_map_and_copy(next_buf, req->src,
+							 to_hash - *buflen,
+							 *next_buflen, 0);
 				state->current_buf = !state->current_buf;
 			}
 		} else {
@@ -878,7 +879,8 @@ static int ahash_update_ctx(struct ahash_request *req)
 			kfree(edesc);
 		}
 	} else if (*next_buflen) {
-		sg_copy(buf + *buflen, req->src, req->nbytes);
+		scatterwalk_map_and_copy(buf + *buflen, req->src, 0,
+					 req->nbytes, 0);
 		*buflen = *next_buflen;
 		*next_buflen = last_buflen;
 	}
@@ -1262,8 +1264,9 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 		src_map_to_sec4_sg(jrdev, req->src, src_nents,
 				   edesc->sec4_sg + 1, chained);
 		if (*next_buflen) {
-			sg_copy_part(next_buf, req->src, to_hash - *buflen,
-				    req->nbytes);
+			scatterwalk_map_and_copy(next_buf, req->src,
+						 to_hash - *buflen,
+						 *next_buflen, 0);
 			state->current_buf = !state->current_buf;
 		}
 
@@ -1304,7 +1307,8 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 			kfree(edesc);
 		}
 	} else if (*next_buflen) {
-		sg_copy(buf + *buflen, req->src, req->nbytes);
+		scatterwalk_map_and_copy(buf + *buflen, req->src, 0,
+					 req->nbytes, 0);
 		*buflen = *next_buflen;
 		*next_buflen = 0;
 	}
@@ -1476,7 +1480,8 @@ static int ahash_update_first(struct ahash_request *req)
 		}
 
 		if (*next_buflen)
-			sg_copy_part(next_buf, req->src, to_hash, req->nbytes);
+			scatterwalk_map_and_copy(next_buf, req->src, to_hash,
+						 *next_buflen, 0);
 
 		sh_len = desc_len(sh_desc);
 		desc = edesc->hw_desc;
@@ -1511,7 +1516,8 @@ static int ahash_update_first(struct ahash_request *req)
 		state->update = ahash_update_no_ctx;
 		state->finup = ahash_finup_no_ctx;
 		state->final = ahash_final_no_ctx;
-		sg_copy(next_buf, req->src, req->nbytes);
+		scatterwalk_map_and_copy(next_buf, req->src, 0,
+					 req->nbytes, 0);
 	}
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "next buf@"__stringify(__LINE__)": ",
diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_sw_sec4.h
index b12ff85..ce28a56 100644
--- a/drivers/crypto/caam/sg_sw_sec4.h
+++ b/drivers/crypto/caam/sg_sw_sec4.h
@@ -116,57 +116,3 @@ static int dma_unmap_sg_chained(struct device *dev, struct scatterlist *sg,
 	}
 	return nents;
 }
-
-/* Map SG page in kernel virtual address space and copy */
-static inline void sg_map_copy(u8 *dest, struct scatterlist *sg,
-			       int len, int offset)
-{
-	u8 *mapped_addr;
-
-	/*
-	 * Page here can be user-space pinned using get_user_pages
-	 * Same must be kmapped before use and kunmapped subsequently
-	 */
-	mapped_addr = kmap_atomic(sg_page(sg));
-	memcpy(dest, mapped_addr + offset, len);
-	kunmap_atomic(mapped_addr);
-}
-
-/* Copy from len bytes of sg to dest, starting from beginning */
-static inline void sg_copy(u8 *dest, struct scatterlist *sg, unsigned int len)
-{
-	struct scatterlist *current_sg = sg;
-	int cpy_index = 0, next_cpy_index = current_sg->length;
-
-	while (next_cpy_index < len) {
-		sg_map_copy(dest + cpy_index, current_sg, current_sg->length,
-			    current_sg->offset);
-		current_sg = scatterwalk_sg_next(current_sg);
-		cpy_index = next_cpy_index;
-		next_cpy_index += current_sg->length;
-	}
-	if (cpy_index < len)
-		sg_map_copy(dest + cpy_index, current_sg, len-cpy_index,
-			    current_sg->offset);
-}
-
-/* Copy sg data, from to_skip to end, to dest */
-static inline void sg_copy_part(u8 *dest, struct scatterlist *sg,
-				      int to_skip, unsigned int end)
-{
-	struct scatterlist *current_sg = sg;
-	int sg_index, cpy_index, offset;
-
-	sg_index = current_sg->length;
-	while (sg_index <= to_skip) {
-		current_sg = scatterwalk_sg_next(current_sg);
-		sg_index += current_sg->length;
-	}
-	cpy_index = sg_index - to_skip;
-	offset = current_sg->offset + current_sg->length - cpy_index;
-	sg_map_copy(dest, current_sg, cpy_index, offset);
-	if (end - sg_index) {
-		current_sg = scatterwalk_sg_next(current_sg);
-		sg_copy(dest + cpy_index, current_sg, end - sg_index);
-	}
-}
-- 
1.8.3.1

