Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab3LOCBd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 21:01:33 -0500
Received: from dmz-mailsec-scanner-1.mit.edu ([18.9.25.12]:52813 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754334Ab3LOCB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 21:01:29 -0500
X-AuditID: 1209190c-b7f7f6d000000bbd-5f-52ad0d78c365
Date: Sat, 14 Dec 2013 21:01:26 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/14] random: rate-limit reseeding only after properly seeded
Message-ID: <20131215020126.GH27191@athena.dialup.mit.edu>
References: <cover.1387067223.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1387067223.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsUixCmqrVvBuzbIYPovG4vLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJWxdZN6wRT2iq9tbawNjL9Yuxg5OSQETCR69j9ihLDFJC7cW8/W
	xcjFISQwm0liw4evYAkhgY2MEodOFUIkfjFKTDm3kgUkwSKgKrH63h52EJtNQEHix/x1zCC2
	iICyxKqZm5hAbGag+K97m8C2CQv4Saw+fwkszitgJdF4YiU7xAIDifaZDVBxQYmTM5+wQPRq
	Sdz49xIozgFkS0ss/8cBEuYUMJR4t/Aq2G2iAioSU05uY5vAKDgLSfcsJN2zELoXMDKvYpRN
	ya3SzU3MzClOTdYtTk7My0st0jXUy80s0UtNKd3ECA5SSZ4djG8OKh1iFOBgVOLhlWBbGyTE
	mlhWXJl7iFGSg0lJlFeKEyjEl5SfUpmRWJwRX1Sak1p8iFGCg1lJhHfH+TVBQrwpiZVVqUX5
	MClpDhYlcd6bHPZBQgLpiSWp2ampBalFMFkZDg4lCd5MHqChgkWp6akVaZk5JQhpJg5OkOE8
	QMP7QWp4iwsSc4sz0yHypxgVpcR5/UESAiCJjNI8uF5YEnnFKA70ijBvD0gVDzABwXW/AhrM
	BDTYe88qkMEliQgpqQZG/vA5dht9LqzOTQ2aVbvEa32Q7oFb+YX5n5ncvA0nmK43/p2y9mwL
	78dtL97sLQwsfeL1eNbz6wq7p/74dPrwLQ/l4OZJ87YFLE2uWrTqbPqms20Xr3gs3bfj4bsN
	q+Pfrdyqylt5Y83sy/OSjuTFvrE15pIVlFZlOxqWWGjmGxeQ/2Tl7sAIMSWW4oxEQy3mouJE
	AKuvLET9AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until then, we need all the entropy we can get.  The "min_bytes"
logic takes care of making these reseeds catastrophic, and
reserving entropy for /dev/random isn't a priority in early boot.

Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index c2428ecb2..f55365696 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -907,7 +907,7 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 static void _xfer_secondary_pool(struct entropy_store *r, size_t nbytes);
 static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 {
-	if (r->limit == 0 && random_min_urandom_seed) {
+	if (r->limit == 0 && r->initialized && random_min_urandom_seed) {
 		unsigned long now = jiffies;
 
 		if (time_before(now,
-- 
1.8.3.2

