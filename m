Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab3KHAEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:04:48 -0500
Received: from dmz-mailsec-scanner-7.mit.edu ([18.7.68.36]:57923 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755444Ab3KHAEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:04:36 -0500
X-AuditID: 12074424-b7f0b8e000004bf2-b5-527c2967f60c
Date: Thu, 7 Nov 2013 18:59:32 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 10/11] random: pull 'min' check in accounting to inside
 lockless update
Message-ID: <20131107235932.GM16018@ringworld.MIT.EDU>
References: <cover.1383868558.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1383868558.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42IR4hRV1k3XrAky2LyTx2L3nMUsFpd3zWFz
	YPI4s+AIu8fnTXIBTFFcNimpOZllqUX6dglcGW/ad7MWnBCt2PD9EVMD43WBLkZODgkBE4mF
	Kw6xQdhiEhfurQeyuTiEBGYzSczYtJYVwtnAKLFh7glGCOcno8T/3Z/YQVpYBFQk/k5azgRi
	swkoSPyYv44ZxBYRUJZYNXMTWJxZwF7i99TJYPXCApESH5tOgcV5BcwkWj7cBbOFBAwkfk5/
	ywIRF5Q4OfMJC0SvlsSNfy+BajiAbGmJ5f84QMKcAoYS7c1XWEFsUaATppzcxjaBUXAWku5Z
	SLpnIXQvYGRexSibklulm5uYmVOcmqxbnJyYl5dapGuul5tZopeaUrqJERS87C4qOxibDykd
	YhTgYFTi4S24UB0kxJpYVlyZe4hRkoNJSZR3onpNkBBfUn5KZUZicUZ8UWlOavEhRgkOZiUR
	3meKQDnelMTKqtSifJiUNAeLkjjvLQ77ICGB9MSS1OzU1ILUIpisDAeHkgTvTA2gRsGi1PTU
	irTMnBKENBMHJ8hwHqDhYDW8xQWJucWZ6RD5U4y6HC++f/rGKMSSl5+XKiXOuxKkSACkKKM0
	D24OLOm8YhQHekuYdzZIFQ8wYcFNegW0hAloScivSpAlJYkIKakGRocJAhYCPH4n961kmPhZ
	YGVJ4qw6oc9WdkVFTF+9ZCJ+371j/nGVRd1Go8AJivK/apl2/PrG9FPjPpfGrw3arHElwR9m
	PC1jZ0iPuLf1SEiyxfmIR2miFxkWd6vPuPLp9KOW7lcTiu6zvdEJL5+4onrPU9WjTs8f+bqZ
	6xxaImY0ZVZgZPKbICWW4oxEQy3mouJEANhf8FgVAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 902c098a3 ("random: use lockless techniques in the interrupt
path") we have protected entropy_count only with cmpxchg, not the
lock.  In 10b3a32d2 ("random: fix accounting race condition") we
put a cmpxchg-retry loop around most of the logic in account(),
but the enforcement of the 'min' parameter stayed outside.

Under concurrent accesses to /dev/urandom this can suffer a race
that defeats our "catastrophic reseed" measures so that our
reseeding isn't effective.  If accesses to /dev/urandom and
/dev/random are interleaved in the wrong pattern, we could go
indefinitely long without a successful catastrophic reseed of
/dev/urandom, even while consuming an indefinite amount of entropy
in ineffective smaller reseeds.

NB that with or without this bug, if /dev/random is simply
accessed constantly, we can go indefinitely long without any
reseed of /dev/urandom.  So the effect of the bug is not that big.

The race comes when two tasks are in account() on input_pool
and access ->entropy_count in the following order:

             task A                           task B
   if (r->entropy_count / 8
               < min + reserved)
                                   ACCESS_ONCE(r->entropy_count)
                                   cmpxchg
   ACCESS_ONCE(r->entropy_count)
   cmpxchg

where B causes r->entropy_count / 8 to fall below A's
min + reserved but above reserved.  Task A will cheerfully
take r->entropy_count / 8 - reserved bytes from the pool,
even though this is less than min.

Move the "min" check inside the ACCESS_ONCE/cmpxchg loop to
prevent the race.

Cc: Jiri Kosina <jkosina@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 1bf6bf8..87d3728 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -842,18 +842,17 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 {
 	unsigned long flags;
 	int wakeup_write = 0;
+	int entropy_count, orig;
 
 	BUG_ON(r->entropy_count > r->poolinfo->POOLBITS);
 	DEBUG_ENT("trying to extract %zu bits from %s\n",
 		  nbytes * 8, r->name);
 
-	/* Can we pull enough? */
-	if (r->entropy_count / 8 < min + reserved) {
+retry:
+	entropy_count = orig = ACCESS_ONCE(r->entropy_count);
+	if (entropy_count / 8 < min + reserved) {
 		nbytes = 0;
 	} else {
-		int entropy_count, orig;
-retry:
-		entropy_count = orig = ACCESS_ONCE(r->entropy_count);
 		/* If limited, never pull more than available */
 		if (r->limit)
 			nbytes = min_t(size_t, nbytes, entropy_count/8 - reserved);
-- 
1.8.3.2

