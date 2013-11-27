Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637Ab3K0B4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:56:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521Ab3K0A5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        Petr Matousek <pmatouse@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.10 08/80] crypto: ansi_cprng - Fix off by one error in non-block size request
Date: Tue, 26 Nov 2013 16:56:37 -0800
Message-Id: <20131127005641.517265159@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/ansi_cprng.c |    4 ++--
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


