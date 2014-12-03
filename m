Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbaLCLoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:44:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbaLCL1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:31 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Greg Kurz <gkurz@linux.vnet.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 020/101] hwrng: pseries - port to new read API and fix stack corruption
Date: Wed,  3 Dec 2014 12:25:42 +0100
Message-Id: <50e52368e667f2a8d5a43c0c9f60b4391a5bc715.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kurz <gkurz@linux.vnet.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 24c65bc7037e7d0f362c0df70d17dd72ee64b8b9 upstream.

The add_early_randomness() function in drivers/char/hw_random/core.c passes
a 16-byte buffer to pseries_rng_data_read(). Unfortunately, plpar_hcall()
returns four 64-bit values and trashes 16 bytes on the stack.

This bug has been lying around for a long time. It got unveiled by:

commit d3cc7996473a7bdd33256029988ea690754e4e2a
Author: Amit Shah <amit.shah@redhat.com>
Date:   Thu Jul 10 15:42:34 2014 +0530

    hwrng: fetch randomness only after device init

It may trig a oops while loading or unloading the pseries-rng module for both
PowerVM and PowerKVM guests.

This patch does two things:
- pass an intermediate well sized buffer to plpar_hcall(). This is acceptalbe
  since we're not on a hot path.
- move to the new read API so that we know the return buffer size for sure.

Signed-off-by: Greg Kurz <gkurz@linux.vnet.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/char/hw_random/pseries-rng.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/pseries-rng.c b/drivers/char/hw_random/pseries-rng.c
index b761459a3436..ab11c16352f8 100644
--- a/drivers/char/hw_random/pseries-rng.c
+++ b/drivers/char/hw_random/pseries-rng.c
@@ -26,18 +26,21 @@
 
 #define MODULE_NAME "pseries-rng"
 
-static int pseries_rng_data_read(struct hwrng *rng, u32 *data)
+static int pseries_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 {
+	u64 buffer[PLPAR_HCALL_BUFSIZE];
+	size_t size = max < 8 ? max : 8;
 	int rc;
 
-	rc = plpar_hcall(H_RANDOM, (unsigned long *)data);
+	rc = plpar_hcall(H_RANDOM, (unsigned long *)buffer);
 	if (rc != H_SUCCESS) {
 		pr_err_ratelimited("H_RANDOM call failed %d\n", rc);
 		return -EIO;
 	}
+	memcpy(data, buffer, size);
 
 	/* The hypervisor interface returns 64 bits */
-	return 8;
+	return size;
 }
 
 /**
@@ -56,7 +59,7 @@ static unsigned long pseries_rng_get_desired_dma(struct vio_dev *vdev)
 
 static struct hwrng pseries_rng = {
 	.name		= MODULE_NAME,
-	.data_read	= pseries_rng_data_read,
+	.read		= pseries_rng_read,
 };
 
 static int __init pseries_rng_probe(struct vio_dev *dev,
-- 
2.1.3

