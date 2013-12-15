Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab3LOCBD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 21:01:03 -0500
Received: from dmz-mailsec-scanner-5.mit.edu ([18.7.68.34]:43549 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596Ab3LOCA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 21:00:59 -0500
X-AuditID: 12074422-b7f9d6d000000bc0-c7-52ad0d5bad74
Date: Sat, 14 Dec 2013 21:00:57 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/14] random: fix a (harmless) overflow
Message-ID: <20131215020057.GB27191@athena.dialup.mit.edu>
References: <cover.1387067223.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1387067223.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsUixCmqrBvNuzbI4OImfovLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJVx8OZq9oLVghWbfl5nbWDs4+ti5OCQEDCRuLRMrIuRE8gUk7hw
	bz0biC0kMJtJYta7pC5GLiB7I6PE39PL2CGcX4wSN+9tBKtiEVCVOH7+MzOIzSagIPFj/jow
	W0RAWWLVzE1MIDYzUPzXvU2sILawgIXEnF83wGp4BawkHvb/htpmINE+s4EJIi4ocXLmExaI
	Xi2JG/9eMoEcyiwgLbH8HwdImFPAUOLdwquMILaogIrElJPb2CYwCs5C0j0LSfcshO4FjMyr
	GGVTcqt0cxMzc4pTk3WLkxPz8lKLdE31cjNL9FJTSjcxgoKU3UVpB+PPg0qHGAU4GJV4eCXY
	1gYJsSaWFVfmHmKU5GBSEuWV4gQK8SXlp1RmJBZnxBeV5qQWH2KU4GBWEuHdcX5NkBBvSmJl
	VWpRPkxKmoNFSZz3Fod9kJBAemJJanZqakFqEUxWhoNDSYJ3EQ/QUMGi1PTUirTMnBKENBMH
	J8hwHqDh50BqeIsLEnOLM9Mh8qcYFaXEef1BEgIgiYzSPLheWBJ5xSgO9Iow7ymQKh5gAoLr
	fgU0mAlosPeeVSCDSxIRUlINjAL3VS/HXPlfOElM1pPxSWrsTs2HzBVz/vZJTVu09xvvjJ0P
	/fqNEhXqNhv6i1ox935r1z3snOe0STbOUi/nD/ccwwuZpctPXZk18fTv9k95ipcXvX9zNn5K
	saTfG52L4nvF+OJqcivlEn2yF0/j4d+wwPvM2n2RvHlLwy4ue/t4m8COc5kM+UosxRmJhlrM
	RcWJAHrLj//9AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This overflow is harmless except to think about, but it's best
to fix it.  If userspace does a giant read from /dev/urandom,
bigger than INT_MAX, then that size gets passed straight
through extract_entropy_user and xfer_secondary_pool to
_xfer_secondary_pool as nbytes, and we would store it into
bytes, which is an int.  The result could be negative.

The consequence is pretty small -- we would pull only the minimum
amount of entropy, rather than as much as we could up to the size
of the output pool, and this is urandom so that's fine.  But the
code is a little easier to read if we make it clear that overflow
isn't an issue.  Also we might be less likely to make mistakes like
the one fixed in the previous commit.

As a bonus, give a name to the minimum number of bytes to pull,
which we use twice.

Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 1dd5f2634..92d9f6862 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -922,21 +922,20 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 
 static void _xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 {
-	__u32	tmp[OUTPUT_POOL_WORDS];
+	__u32 tmp[OUTPUT_POOL_WORDS];
+	int bytes, min_bytes;
 
 	/* For /dev/random's pool, always leave two wakeups' worth */
 	int rsvd_bytes = r->limit ? 0 : random_read_wakeup_bits / 4;
-	int bytes = nbytes;
 
 	/* pull at least as much as a wakeup */
-	bytes = max_t(int, bytes, random_read_wakeup_bits / 8);
+	min_bytes = random_read_wakeup_bits / 8;
 	/* but never more than the buffer size */
-	bytes = min_t(int, bytes, sizeof(tmp));
+	bytes = min(sizeof(tmp), max_t(size_t, min_bytes, nbytes));
 
 	trace_xfer_secondary_pool(r->name, bytes * 8, nbytes * 8,
 				  ENTROPY_BITS(r), ENTROPY_BITS(r->pull));
-	bytes = extract_entropy(r->pull, tmp, bytes,
-				random_read_wakeup_bits / 8, rsvd_bytes);
+	bytes = extract_entropy(r->pull, tmp, bytes, min_bytes, rsvd_bytes);
 	mix_pool_bytes(r, tmp, bytes, NULL);
 	credit_entropy_bits(r, bytes*8);
 }
-- 
1.8.3.2

