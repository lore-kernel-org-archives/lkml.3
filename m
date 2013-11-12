Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab3KLRjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:39:33 -0500
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:40995
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932116Ab3KLRj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:39:28 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(z579ehzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h1155h)
X-WSS-ID: 0MW5VNN-08-4TM-02
X-M-MSG: 
Subject: [PATCH 02/10] crypto: scatterwalk - Set the chain pointer indication
 bit
To: <davem@davemloft.net>, <linux-crytpo@vger.kernel.org>,
        <herbert@gondor.hengli.com.au>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Tue, 12 Nov 2013 11:39:12 -0600
Message-ID: <20131112173912.18862.13846.stgit@tlendack-t1.amdoffice.net>
In-Reply-To: <20131112173900.18862.68623.stgit@tlendack-t1.amdoffice.net>
References: <20131112173900.18862.68623.stgit@tlendack-t1.amdoffice.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scatterwalk_crypto_chain function invokes the scatterwalk_sg_chain
function to chain two scatterlists, but the chain pointer indication
bit is not set.  When the resulting scatterlist is used, for example,
by sg_nents to count the number of scatterlist entries, a segfault occurs
because sg_nents does not follow the chain pointer to the chained scatterlist.

Update scatterwalk_sg_chain to set the chain pointer indication bit as is
done by the sg_chain function.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 include/crypto/scatterwalk.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 13621cc..64ebede 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -36,6 +36,7 @@ static inline void scatterwalk_sg_chain(struct scatterlist *sg1, int num,
 {
 	sg_set_page(&sg1[num - 1], (void *)sg2, 0, 0);
 	sg1[num - 1].page_link &= ~0x02;
+	sg1[num - 1].page_link |= 0x01;
 }
 
 static inline struct scatterlist *scatterwalk_sg_next(struct scatterlist *sg)


