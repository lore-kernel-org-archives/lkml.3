Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933042AbaLBTVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:21:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46553 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144AbaLBTVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:21:31 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Greg Kurz <gkurz@linux.vnet.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 060/121] hwrng: pseries - port to new read API and fix stack corruption
Date: Tue,  2 Dec 2014 11:18:59 -0800
Message-Id: <1417548000-1794-61-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kurz <gkurz@linux.vnet.ibm.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/char/hw_random/pseries-rng.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/pseries-rng.c b/drivers/char/hw_random/pseries-rng.c
index ab7ffde..f38f2c1 100644
--- a/drivers/char/hw_random/pseries-rng.c
+++ b/drivers/char/hw_random/pseries-rng.c
@@ -25,18 +25,21 @@
 #include <asm/vio.h>
 
 
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
@@ -55,7 +58,7 @@ static unsigned long pseries_rng_get_desired_dma(struct vio_dev *vdev)
 
 static struct hwrng pseries_rng = {
 	.name		= KBUILD_MODNAME,
-	.data_read	= pseries_rng_data_read,
+	.read		= pseries_rng_read,
 };
 
 static int __init pseries_rng_probe(struct vio_dev *dev,
-- 
1.9.1

