Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab3LOCA5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 21:00:57 -0500
Received: from dmz-mailsec-scanner-4.mit.edu ([18.9.25.15]:52983 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596Ab3LOCAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 21:00:54 -0500
X-AuditID: 1209190f-b7fb86d000000c36-6d-52ad0d5571ab
Date: Sat, 14 Dec 2013 21:00:51 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/14] random: fix signedness bug
Message-ID: <20131215020051.GA27191@athena.dialup.mit.edu>
References: <cover.1387067223.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1387067223.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsUixCmqrBvKuzbIoPmkpcXlXXPYHBg9Pm+S
	C2CM4rJJSc3JLEst0rdL4Mr4NOkXW0ErZ8XUPUvYGxjnsXcxcnJICJhI3JrzjxHCFpO4cG89
	G4gtJDCbSaJvhRmEvZFR4sU1oS5GLiD7F6PE7FuPmEASLAKqEn97T7GA2GwCChI/5q9jBrFF
	BJQlVs3cBFbDDBT/dW8TaxcjB4ewgKHEj3eWIGFeASuJlwsusEPMN5Bon9nABBEXlDg58wkL
	RKuWxI1/L5lAWpkFpCWW/+MACXMCTXm38CrYyaICKhJTTm5jm8AoOAtJ9ywk3bMQuhcwMq9i
	lE3JrdLNTczMKU5N1i1OTszLSy3SNdHLzSzRS00p3cQIDlFJ/h2M3w4qHWIU4GBU4uE9yLw2
	SIg1say4MvcQoyQHk5IorxQnUIgvKT+lMiOxOCO+qDQntfgQowQHs5II747za4KEeFMSK6tS
	i/JhUtIcLErivDc57IOEBNITS1KzU1MLUotgsjIcHEoSvNo8QEMFi1LTUyvSMnNKENJMHJwg
	w3mAhouB1PAWFyTmFmemQ+RPMSpKifP6gyQEQBIZpXlwvbAU8opRHOgVYV4JkCoeYPqB634F
	NJgJaLD3nlUgg0sSEVJSDYzxHXOVcsNmF5hwun6ZVFb7IpzvdtIXn8NJ8jtWlVxItQ7lfRbp
	obfz0rcWmZc2RVoXp0Zoq015m7Gw55HIiscr509hs7H5uy36r1f8nJxznNZKHqUzWvQezjN/
	8uBbl5BA7c4H/fuu5uoX1DM+PLTdtyPUzu/x97j+3axJ3aHGiStr2LXcJyixFGckGmoxFxUn
	AgBpKvMR/AIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Negative numbers and size_t don't mix.  When the total entropy
available was less than 'reserved', we would fail to enforce any limit
at all.  Fix that.  We never care how negative have_bytes - reserved
is, so just flatten it to zero if negative.

This behavior entered in 987cd8c30 "random: simplify accounting code"
a few commits ago.  Before that, for a long time we would compare
have_bytes - reserved (or equivalent) to ibytes or store it into ibytes,
but only inside a condition that guaranteed it wasn't negative.

Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 8cc7d6515..1dd5f2634 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -977,7 +977,8 @@ retry:
 	ibytes = nbytes;
 	/* If limited, never pull more than available */
 	if (r->limit)
-		ibytes = min_t(size_t, ibytes, have_bytes - reserved);
+		ibytes = min_t(size_t, ibytes,
+			       max(0, have_bytes - reserved));
 	if (ibytes < min)
 		ibytes = 0;
 	entropy_count = max_t(int, 0,
-- 
1.8.3.2

