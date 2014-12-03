Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbaLCLl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:41:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbaLCL1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:37 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michael Ellerman <michael@ellerman.id.au>,
        Herbert Xu <herbert@gondor.apana.org.au>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 016/101] hwrng: pseries - Return errors to upper levels in pseries-rng.c
Date: Wed,  3 Dec 2014 12:25:38 +0100
Message-Id: <b4dc3a3ad9a91453d3d72a6a3e5218d670dfc7dd.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Ellerman <michael@ellerman.id.au>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d319fe2a0af3509f959d5195fb8916accbf14857 upstream.

We don't expect to get errors from the hypervisor when reading the rng,
but if we do we should pass the error up to the hwrng driver. Otherwise
the hwrng driver will continue calling us forever.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/char/hw_random/pseries-rng.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/pseries-rng.c b/drivers/char/hw_random/pseries-rng.c
index 5f1197929f0c..b761459a3436 100644
--- a/drivers/char/hw_random/pseries-rng.c
+++ b/drivers/char/hw_random/pseries-rng.c
@@ -17,6 +17,9 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/hw_random.h>
 #include <asm/vio.h>
@@ -25,10 +28,15 @@
 
 static int pseries_rng_data_read(struct hwrng *rng, u32 *data)
 {
-	if (plpar_hcall(H_RANDOM, (unsigned long *)data) != H_SUCCESS) {
-		printk(KERN_ERR "pseries rng hcall error\n");
-		return 0;
+	int rc;
+
+	rc = plpar_hcall(H_RANDOM, (unsigned long *)data);
+	if (rc != H_SUCCESS) {
+		pr_err_ratelimited("H_RANDOM call failed %d\n", rc);
+		return -EIO;
 	}
+
+	/* The hypervisor interface returns 64 bits */
 	return 8;
 }
 
-- 
2.1.3

