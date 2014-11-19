Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964837AbaKSWRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:17:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932635AbaKSUyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Greg Kurz <gkurz@linux.vnet.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3.17 038/141] hwrng: pseries - port to new read API and fix stack corruption
Date: Wed, 19 Nov 2014 12:51:01 -0800
Message-Id: <20141119205151.917364551@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/hw_random/pseries-rng.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

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
@@ -55,7 +58,7 @@ static unsigned long pseries_rng_get_des
 
 static struct hwrng pseries_rng = {
 	.name		= KBUILD_MODNAME,
-	.data_read	= pseries_rng_data_read,
+	.read		= pseries_rng_read,
 };
 
 static int __init pseries_rng_probe(struct vio_dev *dev,


