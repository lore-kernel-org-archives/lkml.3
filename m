Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaAXWSC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 17:18:02 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:45799
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752859AbaAXWR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 17:17:56 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(z579ehzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchzz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h1155h)
X-WSS-ID: 0MZXF9R-07-4EE-02
X-M-MSG: 
Subject: [PATCH 0/4] crypto: ccp - selective algorithm registration and
 ipsec-related fixes
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Fri, 24 Jan 2014 16:17:50 -0600
Message-ID: <20140124221750.1894.48517.stgit@tlendack-t1.amdoffice.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1: Allow for selectively disabling the registration of an algorithm
family (sha or aes algorithms) via module parameters.

Patch 2-4: Fix errors/issues that were found during IPSec testing. In
order to prevent deadlocks with the networking code, the crypto callback
was changed to run as a tasklet.  In order for the callback to be run as
a tasklet, the HMAC calculation needed to be moved out of the callback
path (since it sleeps) and into the CCP sha operation logic.  Additionally,
trying to allow concurrency within the tfm while maintaining serialization
of the tfm per CPU was not working properly so a single queue is used now.

This patch series is based on the cryptodev-2.6 kernel tree.

---

Tom Lendacky (4):
      crypto: ccp - Allow for selective disablement of crypto API algorithms
      crypto: ccp - Move HMAC calculation down to ccp ops file
      crypto: ccp - Use a single queue for proper ordering of tfm requests
      crypto: ccp - Perform completion callbacks using a tasklet


 drivers/crypto/ccp/ccp-crypto-main.c |  201 ++++++++++++----------------------
 drivers/crypto/ccp/ccp-crypto-sha.c  |  130 ++++------------------
 drivers/crypto/ccp/ccp-crypto.h      |    8 +
 drivers/crypto/ccp/ccp-dev.c         |   21 +++-
 drivers/crypto/ccp/ccp-ops.c         |  104 +++++++++++++++++-
 include/linux/ccp.h                  |    7 +
 6 files changed, 229 insertions(+), 242 deletions(-)

-- 
Tom Lendacky

