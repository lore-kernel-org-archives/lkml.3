Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab3LOCB2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 21:01:28 -0500
Received: from dmz-mailsec-scanner-3.mit.edu ([18.9.25.14]:53609 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754270Ab3LOCBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 21:01:24 -0500
X-AuditID: 1209190e-b7efb6d000000bb9-56-52ad0d7312d2
Date: Sat, 14 Dec 2013 21:01:21 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/14] random: exploit any extra entropy too when reseeding
Message-ID: <20131215020121.GG27191@athena.dialup.mit.edu>
References: <cover.1387067223.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1387067223.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsUixG6nrlvMuzbIYNIzTYvLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJXRMnUuW8EhgYoLr06wNjDO5O1i5OSQEDCR2DjtNBOELSZx4d56
	ti5GLg4hgdlMEi/eLWADSQgJbGSUmPlJEyLxC8j+c4URJMEioCpx8eJKMJtNQEHix/x1zCC2
	iICyxKqZm8CmMgPFf93bxApiCwt4S6ybPBGshlfASmLGqVnsEAsMJNpnNjBBxAUlTs58wgLR
	qyVx499LoDgHkC0tsfwfB0iYU8BQ4t3Cq2BrRQVUJKac3MY2gVFwFpLuWUi6ZyF0L2BkXsUo
	m5JbpZubmJlTnJqsW5ycmJeXWqRrrJebWaKXmlK6iREUppySfDsYvx5UOsQowMGoxMN7gHlt
	kBBrYllxZe4hRkkOJiVRXilOoBBfUn5KZUZicUZ8UWlOavEhRgkOZiUR3h3n1wQJ8aYkVlal
	FuXDpKQ5WJTEeW9y2AcJCaQnlqRmp6YWpBbBZGU4OJQkeDN5gIYKFqWmp1akZeaUIKSZODhB
	hvMADe8HqeEtLkjMLc5Mh8ifYlSUEuf1B0kIgCQySvPgemFp5BWjONArwrw9IFU8wBQE1/0K
	aDAT0GDvPatABpckIqSkGhi9Iks6Zir4Kf1wPniJefGhowaCDsJZNtt4NWp3tso4tSttUeNd
	wn/n4df7VxKdPn4wUj+q8+xJ9t+i3U4vCjhTr1kxOisU/+3YdyFCYdFDlYDQnMeLNTd/dEgI
	WaJfrN+xxj1qz+aXTx2/59jtLW9rzphXyyK9jt97S8QczadL3ltYnTRy8lBiKc5INNRiLipO
	BAAVFGjK/gIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When extracting from the input pool to feed one of the output
pools, extracting more bytes can't hurt the reseed, and it can
help if there happens to be more entropy than we estimated.  We
deliberately try to be conservative in our estimates -- for
example, mixing in the cycle counter on each event but estimating
based on the low-resolution clock -- so this situation is likely.

For example, the authors of http://eprint.iacr.org/2012/251.pdf
found in a multi-week run on a desktop that the actual entropy
from add_input_randomness was much higher than our estimates,
at 9.69 bits min-entropy per event from the cycle counters alone
vs. 1.85 bits estimated.

The only reason to hold back is that we have to debit the input
pool's entropy estimate for every byte we extract, which may delay
us the next time we want to extract from the input pool.  But if
we're already leaving the pool practically empty, this isn't much
of a cost.  So go ahead and suck up two full extractions, 160 bits.
If we have even more than that and didn't know it, this should
still be a good solid seed.

We just have to make sure not to give ourselves credit for more
entropy than our sober estimates allow.  The credit_bits output
parameter takes care of that.

Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index c11281551..c2428ecb2 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1001,6 +1001,13 @@ retry:
 		ibytes = 0;
 	if (credit_bits != NULL)
 		*credit_bits = ibytes * 8;
+	if (dest != NULL && ibytes && ibytes == have_bytes) {
+		/* When a reseed drains the pool, we might as well
+		 * suck up any underestimated entropy as well as what
+		 * we estimate is there. */
+		WARN_ON(credit_bits == NULL);
+		ibytes = max_t(size_t, ibytes, 2*EXTRACT_SIZE);
+	}
 	entropy_count = max_t(int, 0,
 			      entropy_count - (ibytes << (ENTROPY_SHIFT + 3)));
 	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
-- 
1.8.3.2

