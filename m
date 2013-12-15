Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab3LOCBP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 21:01:15 -0500
Received: from dmz-mailsec-scanner-3.mit.edu ([18.9.25.14]:53606 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596Ab3LOCBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 21:01:11 -0500
X-AuditID: 1209190e-b7efb6d000000bb9-24-52ad0d661f0e
Date: Sat, 14 Dec 2013 21:01:08 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/14] random: accept small seeds early on
Message-ID: <20131215020108.GD27191@athena.dialup.mit.edu>
References: <cover.1387067223.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1387067223.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsUixCmqrZvGuzbIYOIleYvLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJVx9m1twQX+irPPpjI1MJ7k6WLk5JAQMJG4tGw1M4QtJnHh3nq2
	LkYuDiGB2UwSG07tYgdJCAlsZJSYek8SIvGLUaLty2NWkASLgKrE1s0zwIrYBBQkfsxfBzZJ
	REBZYtXMTUwgNjNQ/Ne9TWD1wgJWEjcurQer4QWyOw+/YYVYYCDRPrOBCSIuKHFy5hMWiF4t
	iRv/XgLFOYBsaYnl/zhAwpwChhLvFl5lBLFFBVQkppzcxjaBUXAWku5ZSLpnIXQvYGRexSib
	klulm5uYmVOcmqxbnJyYl5dapGusl5tZopeaUrqJERykknw7GL8eVDrEKMDBqMTDe4B5bZAQ
	a2JZcWXuIUZJDiYlUV4pTqAQX1J+SmVGYnFGfFFpTmrxIUYJDmYlEd4d59cECfGmJFZWpRbl
	w6SkOViUxHlvctgHCQmkJ5akZqemFqQWwWRlODiUJHgzeYCGChalpqdWpGXmlCCkmTg4QYbz
	AA0XA6nhLS5IzC3OTIfIn2LU5ehZ9+EboxBLXn5eqpQ4rz9IkQBIUUZpHtwcWHJ5xSgO9JYw
	byBIFQ8wMcFNegW0hAloifeeVSBLShIRUlINjPJNpQxO36brCTLsfLE0cGLcW9Oq77FJLbUx
	yRfivqpeC9KLkM8S8kvdsLmo+krq/haVixn88xQeZsQof5obfm/hYvPnKt+sUoN6mpZylZX6
	KV7Tljt1bd5Skw0lDdarrrb9bFxgrvTM4G7DmfTgGMaF17UXTMs3LZBYHvzE/fKi6wpcpvXH
	lViKMxINtZiLihMB4uSFoQkDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Early in boot, we want to get /dev/urandom (and the kernel's
internal randomness source) adequately seeded ASAP.  If we're
desperately short of entropy and are asked to produce output,
we're better off getting, say, 16 bits now and 32 bits next time
rather than holding out for a whole 64-bit reseed while producing
output from virtually no entropy.

At present most input goes directly to the nonblocking pool early on
anyway, but this helps put us in a position to change that.

Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index bf7fedadd..9f24f6468 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -925,12 +925,21 @@ static void _xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 	__u32 tmp[OUTPUT_POOL_WORDS];
 	int bytes, min_bytes, reserved_bytes;
 
-	/* pull at least as much as a wakeup */
-	min_bytes = random_read_wakeup_bits / 8;
-	/* but never more than the buffer size */
+	/* Try to pull a full wakeup's worth if we might have just woken up
+	 * for it, and a full reseed's worth (which is controlled by the same
+	 * parameter) for the nonblocking pool... */
+	if (r == &blocking_pool || r->initialized) {
+		min_bytes = random_read_wakeup_bits / 8;
+	} else {
+		/* ... except if we're hardly seeded at all, we'll settle for
+		 * enough to double what we have ... */
+		min_bytes = min(random_read_wakeup_bits / 8,
+				(r->entropy_total+7) / 8);
+	}
+	/* ... and in any event no more than our (giant) buffer holds. */
 	bytes = min(sizeof(tmp), max_t(size_t, min_bytes, nbytes));
 
-	/* reserve some for /dev/random's pool, unless we really need it */
+	/* Reserve some for /dev/random's pool, unless we really need it. */
 	reserved_bytes = 0;
 	if (!r->limit && r->initialized)
 		reserved_bytes = 2 * (random_read_wakeup_bits / 8);
-- 
1.8.3.2

