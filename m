Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaBXOmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:42:12 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:3127
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752687AbaBXOmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:42:08 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh1de097hz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
X-WSS-ID: 0N1I8U3-07-I4T-02
X-M-MSG: 
Subject: [PATCH 1/3] crypto: ccp - Prevent a possible lost CCP command request
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Mon, 24 Feb 2014 08:42:02 -0600
Message-ID: <20140224144202.16181.68619.stgit@tlendack-t1.amdoffice.net>
In-Reply-To: <20140224144156.16181.81272.stgit@tlendack-t1.amdoffice.net>
References: <20140224144156.16181.81272.stgit@tlendack-t1.amdoffice.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a CCP command has been queued for processing at the
crypto layer then, when dequeueing it for processing, the
"can backlog" flag must be set so that the request isn't
lost if the CCP backlog queue limit is reached.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-main.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
index 010fded..9d30d6f 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -174,6 +174,10 @@ static void ccp_crypto_complete(void *data, int err)
 
 	/* Submit the next cmd */
 	while (held) {
+		/* Since we have already queued the cmd, we must indicate that
+		 * we can backlog so as not to "lose" this request.
+		 */
+		held->cmd->flags |= CCP_CMD_MAY_BACKLOG;
 		ret = ccp_enqueue_cmd(held->cmd);
 		if (ccp_crypto_success(ret))
 			break;


