Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845Ab3KMIIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 03:08:50 -0500
Received: from dmz-mailsec-scanner-8.mit.edu ([18.7.68.37]:52353 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758743Ab3KMIId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 03:08:33 -0500
X-AuditID: 12074425-b7fd96d000000c39-07-5283337f1a19
Date: Wed, 13 Nov 2013 03:08:28 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 7/9] random: forget lock in lockless accounting
Message-ID: <20131113080828.GU16018@ringworld.MIT.EDU>
References: <cover.1384329436.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1384329436.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsUixCmqrFtv3BxkcOWZjsXuOYtZLC7vmsPm
	wORxZsERdo/Pm+QCmKK4bFJSczLLUov07RK4Mu7/YCvYyVlxpvsMewPjHfYuRk4OCQETiXPr
	3kHZYhIX7q1n62Lk4hASmM0ksbnvLZSzkVHix8ZTLCBVQgK/GCUau0JBbBYBVYnL116BxdkE
	FCR+zF/HDGKLCChLrJq5iQnEZhawl/g9dTLQBg4OYSD71XZTkDCvgJnE485dUCMNJDbun8AM
	EReUODnzCQtEq5bEjX8vmUBamQWkJZb/4wAJcwoYSkzacJQVxBYVUJGYcnIb2wRGwVlIumch
	6Z6F0L2AkXkVo2xKbpVubmJmTnFqsm5xcmJeXmqRroVebmaJXmpK6SZGUNiyu6juYJxwSOkQ
	owAHoxIPr0VMU5AQa2JZcWXuIUZJDiYlUV4nneYgIb6k/JTKjMTijPii0pzU4kOMEhzMSiK8
	B4SBcrwpiZVVqUX5MClpDhYlcd5bHPZBQgLpiSWp2ampBalFMFkZDg4lCV4nQ6BGwaLU9NSK
	tMycEoQ0EwcnyHAeoOGRIDW8xQWJucWZ6RD5U4yKUuK8uSAJAZBERmkeXC8srbxiFAd6RZg3
	HqSKB5iS4LpfAQ1mAhpsUdwEMrgkESEl1cDI/ya293zHKq7sAkar6bYVr+V3fq1wSfLhS5vM
	vmSr8kK2jz55e/luTs20/jRt1XPrbfFrcy6+4at+U30xremN++ceDsH6xs9qh+rnCwsozdGJ
	Cgytu5l9JPNv4eY3HyVLdydo/RHicmm79uwbR722O49dWdbRGAPTyTk8K1lOnBLrSVa+uEuJ
	pTgj0VCLuag4EQCWdtZnBgMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only mutable data accessed here is ->entropy_count, but since
902c098a3 ("random: use lockless techniques in the interrupt path")
that member isn't protected by the lock anyway.  Since 10b3a32d2
("random: fix accounting race condition") we use cmpxchg to protect
our accesses to ->entropy_count here.  Drop the use of the lock.

Cc: Jiri Kosina <jkosina@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 5dffca8..1f43f9e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -974,9 +974,6 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 	int entropy_count, orig;
 	size_t ibytes;
 
-	/* Hold lock while accounting */
-	spin_lock_irqsave(&r->lock, flags);
-
 	BUG_ON(r->entropy_count > r->poolinfo->poolfracbits);
 
 	/* Can we pull enough? */
@@ -999,7 +996,6 @@ retry:
 		    < random_write_wakeup_thresh)
 			wakeup_write = 1;
 	}
-	spin_unlock_irqrestore(&r->lock, flags);
 
 	trace_debit_entropy(r->name, 8 * ibytes);
 	if (wakeup_write) {
-- 
1.8.3.2

