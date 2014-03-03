Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbaCCS47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:56:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55950 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbaCCS4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:56:21 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Neil Horman <nhorman@tuxdriver.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        Petr Matousek <pmatouse@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 02/67] crypto: ansi_cprng - Fix off by one error in non-block size request
Date: Mon,  3 Mar 2014 10:54:50 -0800
Message-Id: <1393872955-28810-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

commit 714b33d15130cbb5ab426456d4e3de842d6c5b8a upstream.

Stephan Mueller reported to me recently a error in random number generation in
the ansi cprng. If several small requests are made that are less than the
instances block size, the remainder for loop code doesn't increment
rand_data_valid in the last iteration, meaning that the last bytes in the
rand_data buffer gets reused on the subsequent smaller-than-a-block request for
random data.

The fix is pretty easy, just re-code the for loop to make sure that
rand_data_valid gets incremented appropriately

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: Stephan Mueller <stephan.mueller@atsec.com>
CC: Stephan Mueller <stephan.mueller@atsec.com>
CC: Petr Matousek <pmatouse@redhat.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ kamal: 3.8-stable for CVE-2013-4345 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 crypto/ansi_cprng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index c0bb377..666f196 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -230,11 +230,11 @@ remainder:
 	 */
 	if (byte_count < DEFAULT_BLK_SZ) {
 empty_rbuf:
-		for (; ctx->rand_data_valid < DEFAULT_BLK_SZ;
-			ctx->rand_data_valid++) {
+		while (ctx->rand_data_valid < DEFAULT_BLK_SZ) {
 			*ptr = ctx->rand_data[ctx->rand_data_valid];
 			ptr++;
 			byte_count--;
+			ctx->rand_data_valid++;
 			if (byte_count == 0)
 				goto done;
 		}
-- 
1.8.3.2

