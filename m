Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaJ1RwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:52:01 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:60967 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaJ1Rv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:51:59 -0400
Date: Tue, 28 Oct 2014 15:51:54 -0200
From: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
To: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org,
        Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
        Fionnuala Gunter <fin@linux.vnet.ibm.com>
Subject: [PATCH 9/9] Disable ccm and ccm4309 in fips mod
Message-ID: <20141028175146.GA18467@bluepex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102817-0005-0000-0000-000000E80EBB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NX CCM has not support to keys larger than 128 neither our hardware.
In cases where a system is running in fips mode enabled a tcrypt test will
crash the system in a kernel panic call.
This patch disable, for now, CCM's algorithms in fips mode to avoid this.

Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx.c |   32 ++++++++++++++++++++++----------
 1 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index aa8c38d..a32239c 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -35,6 +35,7 @@
 #include <linux/of.h>
 #include <asm/hvcall.h>
 #include <asm/vio.h>
+#include <linux/fips.h>
 
 #include "nx_csbcpb.h"
 #include "nx.h"
@@ -566,13 +567,15 @@ static int nx_register_algs(void)
 	if (rc)
 		goto out_unreg_gcm;
 
-	rc = crypto_register_alg(&nx_ccm_aes_alg);
-	if (rc)
-		goto out_unreg_gcm4106;
+	if (!fips_enabled) {
+		rc = crypto_register_alg(&nx_ccm_aes_alg);
+		if (rc)
+			goto out_unreg_gcm4106;
 
-	rc = crypto_register_alg(&nx_ccm4309_aes_alg);
-	if (rc)
-		goto out_unreg_ccm;
+		rc = crypto_register_alg(&nx_ccm4309_aes_alg);
+		if (rc)
+			goto out_unreg_ccm;
+	}
 
 	rc = crypto_register_shash(&nx_shash_sha256_alg);
 	if (rc)
@@ -593,9 +596,11 @@ out_unreg_s512:
 out_unreg_s256:
 	crypto_unregister_shash(&nx_shash_sha256_alg);
 out_unreg_ccm4309:
-	crypto_unregister_alg(&nx_ccm4309_aes_alg);
+	if (!fips_enabled)
+		crypto_unregister_alg(&nx_ccm4309_aes_alg);
 out_unreg_ccm:
-	crypto_unregister_alg(&nx_ccm_aes_alg);
+	if (fips_enabled)
+		crypto_unregister_alg(&nx_ccm_aes_alg);
 out_unreg_gcm4106:
 	crypto_unregister_alg(&nx_gcm4106_aes_alg);
 out_unreg_gcm:
@@ -746,8 +751,15 @@ static int nx_remove(struct vio_dev *viodev)
 	if (nx_driver.of.status == NX_OKAY) {
 		NX_DEBUGFS_FINI(&nx_driver);
 
-		crypto_unregister_alg(&nx_ccm_aes_alg);
-		crypto_unregister_alg(&nx_ccm4309_aes_alg);
+		/* CCM algorithm has not support to keys larger than 128
+		 * however tcrypt test uses key larger than. If a system
+		 * runs with fips enabled it'll crash. For now we need to
+		 * disable this two algorithms in fips mode.
+		 */
+		if (!fips_enabled) {
+			crypto_unregister_alg(&nx_ccm_aes_alg);
+			crypto_unregister_alg(&nx_ccm4309_aes_alg);
+		}
 		crypto_unregister_alg(&nx_gcm_aes_alg);
 		crypto_unregister_alg(&nx_gcm4106_aes_alg);
 		crypto_unregister_alg(&nx_ctr_aes_alg);
-- 
1.7.1

