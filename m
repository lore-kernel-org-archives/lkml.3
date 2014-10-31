Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761128AbaJaGuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 02:50:22 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:53915 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760901AbaJaGuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 02:50:20 -0400
Subject: [PATCH] hwrng: pseries - port to new read API and fix stack
 corruption
From: Greg Kurz <gkurz@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        Herbert Xu <herbert@gondor.apana.org.au>, stable@vger.kernel.org
Date: Fri, 31 Oct 2014 07:50:11 +0100
Message-ID: <20141031063233.1884.86309.stgit@bahia.local>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14103106-0041-0000-0000-000001E254B6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---

Cc'ing stable as I could reproduce back to 3.15.10

 drivers/char/hw_random/pseries-rng.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/pseries-rng.c b/drivers/char/hw_random/pseries-rng.c
index 6226aa0..bcf86f9 100644
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

