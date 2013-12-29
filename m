Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab3L2CKB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:10:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55015 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751987Ab3L2CJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:09:57 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Stephan Mueller" <stephan.mueller@atsec.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Neil Horman" <nhorman@tuxdriver.com>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "Petr Matousek" <pmatouse@redhat.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.764091660@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 173/185] crypto: ansi_cprng - Fix off by one error in
 non-block size request
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 crypto/ansi_cprng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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

