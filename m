Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbaBEVMC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:12:02 -0500
Received: from mail1.windriver.com ([147.11.146.13]:47946 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbaBEUDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:03:55 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Neil Horman <nhorman@tuxdriver.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        Petr Matousek <pmatouse@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 016/213] crypto: ansi_cprng - Fix off by one error in non-block size request
Date: Wed, 5 Feb 2014 14:59:31 -0500
Message-ID: <1391630568-49251-17-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 crypto/ansi_cprng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 2bc332142849..5c565d72d1cc 100644
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
1.8.5.2

