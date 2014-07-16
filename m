Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760938AbaGPTS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:18:28 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60421 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760904AbaGPTSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:18:24 -0400
X-Sasl-enc: oKnV9zHFdNJAvWN56p2ef+MysBDhrxVeXi9G/7w5ZilF 1405538303
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Price <price@mit.edu>
Subject: [PATCH] random: check for increase of entropy_count because of signed conversion
Date: Wed, 16 Jul 2014 21:18:15 +0200
Message-Id: <442eeebeb78f9f2d4066ad923f4144fc2110c6f7.1405538086.git.hannes@stressinduktion.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <20140716083308.GF1491@thunk.org>
References: <20140716083308.GF1491@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The expression entropy_count -= ibytes << (ENTROPY_SHIFT + 3) could
actually increase entropy_count if during assignment of the unsigned
expression on the RHS (mind the -=) we reduce the value modulo
2^width(int) and assign it to entropy_count. Trinity found this.

Reported-by: Dave Jones <davej@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Greg Price <price@mit.edu>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
---
As indicated by credit_entropy_bits entropy_count cannot get negative,
so I don't see any reason to include a check for entropy_count < 0
here. Do you agree?

 drivers/char/random.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 0a7ac0a..cd50c4e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -981,7 +981,7 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 		      int reserved)
 {
 	int entropy_count, orig;
-	size_t ibytes;
+	size_t ibytes, nfrac;
 
 	BUG_ON(r->entropy_count > r->poolinfo->poolfracbits);
 
@@ -999,7 +999,11 @@ retry:
 	}
 	if (ibytes < min)
 		ibytes = 0;
-	if ((entropy_count -= ibytes << (ENTROPY_SHIFT + 3)) < 0)
+
+	nfrac = ibytes << (ENTROPY_SHIFT + 3);
+	if (entropy_count > nfrac)
+		entropy_count -= nfrac;
+	else
 		entropy_count = 0;
 
 	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
-- 
1.9.3

