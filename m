Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbaA3LuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 06:50:07 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34902 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbaA3LuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 06:50:05 -0500
Date: Thu, 30 Jan 2014 14:49:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] hw_random: cleanup in hwrng_register()
Message-ID: <20140130114943.GB12734@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My static checker complains that:

	drivers/char/hw_random/core.c:341 hwrng_register()
	warn: we tested 'old_rng' before and it was 'false'

The problem is that sometimes we test "if (!old_rng)" and sometimes we
test "if (must_register_misc)".  The static checker knows they are
equivalent but a human being reading the code could easily be confused.

I have simplified the code by removing the "must_register_misc" variable
and I have removed the redundant check on "if (!old_rng)".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index b9495a8c05c6..463382036a01 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -301,7 +301,6 @@ err_misc_dereg:
 
 int hwrng_register(struct hwrng *rng)
 {
-	int must_register_misc;
 	int err = -EINVAL;
 	struct hwrng *old_rng, *tmp;
 
@@ -326,7 +325,6 @@ int hwrng_register(struct hwrng *rng)
 			goto out_unlock;
 	}
 
-	must_register_misc = (current_rng == NULL);
 	old_rng = current_rng;
 	if (!old_rng) {
 		err = hwrng_init(rng);
@@ -335,13 +333,11 @@ int hwrng_register(struct hwrng *rng)
 		current_rng = rng;
 	}
 	err = 0;
-	if (must_register_misc) {
+	if (!old_rng) {
 		err = register_miscdev();
 		if (err) {
-			if (!old_rng) {
-				hwrng_cleanup(rng);
-				current_rng = NULL;
-			}
+			hwrng_cleanup(rng);
+			current_rng = NULL;
 			goto out_unlock;
 		}
 	}
