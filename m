Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab3KHAFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:05:06 -0500
Received: from dmz-mailsec-scanner-4.mit.edu ([18.9.25.15]:45277 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756349Ab3KHAEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:04:45 -0500
X-AuditID: 1209190f-b7f7b8e0000053dd-7c-527c296b4e81
Date: Thu, 7 Nov 2013 18:59:37 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 11/11] random: simplify accounting code
Message-ID: <20131107235937.GN16018@ringworld.MIT.EDU>
References: <cover.1383868558.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1383868558.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsUixCmqrJutWRNksPaEjcXuOYtZLC7vmsPm
	wORxZsERdo/Pm+QCmKK4bFJSczLLUov07RK4Mn63nmYqmC1SMaPhG2MD426BLkZODgkBE4l/
	ncuYIGwxiQv31rN1MXJxCAnMZpI4PukzWEJIYAOjxPybJhCJn4wSi1c2MoIkWARUJBqXNLGC
	2GwCChI/5q9jBrFFBJQlVs3cBNbMLGAv8XvqZHYQW1jAXOLqlg42EJtXwExi4rZpLBALDCR+
	Tn/LAhEXlDg58wkLRK+WxI1/L4HmcADZ0hLL/3GAhDkFDCXam6+ArRUFOmHKyW1sExgFZyHp
	noWkexZC9wJG5lWMsim5Vbq5iZk5xanJusXJiXl5qUW6Jnq5mSV6qSmlmxjBoSvJv4Px20Gl
	Q4wCHIxKPLwFF6qDhFgTy4orcw8xSnIwKYnyTlSvCRLiS8pPqcxILM6ILyrNSS0+xCjBwawk
	wvtMESjHm5JYWZValA+TkuZgURLnvclhHyQkkJ5YkpqdmlqQWgSTleHgUJLg1dIAahQsSk1P
	rUjLzClBSDNxcIIM5wEaHgFSw1tckJhbnJkOkT/FqCglzmsEkhAASWSU5sH1wlLLK0ZxoFeE
	eVVAqniAaQmu+xXQYCagwSG/KkEGlyQipKQaGKequfQ+OiBbYMXHUMl190zY3KURVbnCdmpH
	JpatTuN5G7I/tOJJmv2hpTPCLy00ns626r7Y1PR5F9NZj/4441A8fdPtA7/e1ks/m37ZMeeg
	d03w+8o9379vTsk+qG72+pfb4l1T4z60ztzn3LArZLqn7pXE5QEr1qgtvHBrrvU88cbXxuG3
	r/YrsRRnJBpqMRcVJwIAhG17vAgDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this we handle "reserved" in just one place.  As a bonus the
code becomes less nested, and the "wakeup_write" flag variable
becomes unnecessary.  The variable "flags" was already unused.

This code behaves identically to the previous version except in
two pathological cases that don't occur.  If the argument "nbytes"
is already less than "min", then we didn't previously enforce
"min".  If r->limit is false while "reserved" is nonzero, then we
previously applied "reserved" in checking whether we had enough
bits, even though we don't apply it to actually limit how many we
take.  The callers of account() never exercise either of these cases.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 87d3728..3f343ff 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -840,8 +840,6 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 static size_t account(struct entropy_store *r, size_t nbytes, int min,
 		      int reserved)
 {
-	unsigned long flags;
-	int wakeup_write = 0;
 	int entropy_count, orig;
 
 	BUG_ON(r->entropy_count > r->poolinfo->POOLBITS);
@@ -850,24 +848,19 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 
 retry:
 	entropy_count = orig = ACCESS_ONCE(r->entropy_count);
-	if (entropy_count / 8 < min + reserved) {
+	/* If limited, never pull more than available */
+	if (r->limit)
+		nbytes = min_t(size_t, nbytes, entropy_count/8 - reserved);
+	if (nbytes < min)
 		nbytes = 0;
-	} else {
-		/* If limited, never pull more than available */
-		if (r->limit)
-			nbytes = min_t(size_t, nbytes, entropy_count/8 - reserved);
-		entropy_count = max_t(int, entropy_count - nbytes*8, 0);
-		if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
-			goto retry;
-
-		if (entropy_count < random_write_wakeup_thresh)
-			wakeup_write = 1;
-	}
+	entropy_count = max_t(int, entropy_count - nbytes*8, 0);
+	if (nbytes && cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
+		goto retry;
 
 	DEBUG_ENT("debiting %zu entropy credits from %s%s\n",
 		  nbytes * 8, r->name, r->limit ? "" : " (unlimited)");
 
-	if (wakeup_write) {
+	if (nbytes && entropy_count < random_write_wakeup_thresh) {
 		wake_up_interruptible(&random_write_wait);
 		kill_fasync(&fasync, SIGIO, POLL_OUT);
 	}
-- 
1.8.3.2
