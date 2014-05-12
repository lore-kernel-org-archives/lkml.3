Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546AbaELCHH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:07:07 -0400
Received: from 1wt.eu ([62.212.114.60]:34541 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbaELBm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:26 -0400
Message-Id: <20140512003206.181991224@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:34:12 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        Petr Matousek <pmatouse@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 132/143] crypto: ansi_cprng - Fix off by one error in non-block size request
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

commit 714b33d15130cbb5ab426456d4e3de842d6c5b8a upstream

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 crypto/ansi_cprng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 3aa6e38..0ffd5995 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -232,11 +232,11 @@ remainder:
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
1.7.12.2.21.g234cd45.dirty



