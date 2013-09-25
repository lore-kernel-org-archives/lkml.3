Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab3IYJYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 05:24:38 -0400
Received: from ozlabs.org ([203.10.76.45]:43845 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302Ab3IYJY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 05:24:26 -0400
From: Michael Ellerman <michael@ellerman.id.au>
To: <linuxppc-dev@ozlabs.org>
Cc: <linux-kernel@vger.kernel.org>, mpm@selenic.com,
        herbert@gondor.hengli.com.au
Subject: [PATCH 2/2] hwrng: Return errors to upper levels in pseries-rng.c
Date: Wed, 25 Sep 2013 19:24:17 +1000
Message-Id: <1380101057-29903-2-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380101057-29903-1-git-send-email-michael@ellerman.id.au>
References: <1380101057-29903-1-git-send-email-michael@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't expect to get errors from the hypervisor when reading the rng,
but if we do we should pass the error up to the hwrng driver. Otherwise
the hwrng driver will continue calling us forever.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 drivers/char/hw_random/pseries-rng.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/pseries-rng.c b/drivers/char/hw_random/pseries-rng.c
index 9dbeed3..ab7ffde 100644
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
@@ -24,10 +27,15 @@
 
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
1.8.1.2

