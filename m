Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab3KMIJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 03:09:21 -0500
Received: from dmz-mailsec-scanner-1.mit.edu ([18.9.25.12]:57908 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758832Ab3KMIIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 03:08:47 -0500
X-AuditID: 1209190c-b7f7f6d000000bbd-59-5283338d8fe7
Date: Wed, 13 Nov 2013 03:08:41 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 9/9] random: simplify accounting code
Message-ID: <20131113080841.GW16018@ringworld.MIT.EDU>
References: <cover.1384329436.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1384329436.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsUixCmqrNtr3BxksGmBtcW0jeIWu+csZrG4
	vGsOmwOzx5kFR9g9Pm+S8zjR8oU1gDmKyyYlNSezLLVI3y6BK6P/zmfmgouiFf1nbrI0MO4S
	7GLk5JAQMJHo/3KHCcIWk7hwbz1bFyMXh5DAbCaJQ5862CGcjYwSB941Qjm/GCUWLbvIDtLC
	IqAqseHjLTCbTUBB4sf8dcwgtoiAssSqmZvAxjILZElsvzuLFcQWFjCVeHB1B5jNK2Amsf3/
	WzBbSMBAYuP+CcwQcUGJkzOfsED0aknc+PcSaA4HkC0tsfwfB0iYU8BQYtKGo2CtogIqElNO
	bmObwCg4C0n3LCTdsxC6FzAyr2KUTcmt0s1NzMwpTk3WLU5OzMtLLdI11MvNLNFLTSndxAgO
	Z0meHYxvDiodYhTgYFTi4X0Q2RQkxJpYVlyZe4hRkoNJSZTXSac5SIgvKT+lMiOxOCO+qDQn
	tfgQowQHs5II7wFhoBxvSmJlVWpRPkxKmoNFSZz3Jod9kJBAemJJanZqakFqEUxWhoNDSYLX
	wgioUbAoNT21Ii0zpwQhzcTBCTKcB2i4CEgNb3FBYm5xZjpE/hSjopQ4bwxIQgAkkVGaB9cL
	SzevGMWBXhHmDQSp4gGmKrjuV0CDmYAGWxQ3gQwuSURISTUw+muzf8jjST+26vasebGXpibt
	/fLq7s1khbBJb1tNNRfcTb2VeO3NOUu9tSohBr3rZ7WUsPqX+1w68cjy5oaI6/NO5/Uxck4/
	luIbeXHfXhe37yqOBvvfFn69fDhIijlAkL/KIW9V8OaUXYLaS1Q38iyKVah96NvEpmkfeGnW
	+ftPOX5POHbFVYmlOCPRUIu5qDgRAHsxypESAwAA
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

Before the previous commit, it was possible for "nbytes" to be less
than "min" if userspace chose a pathological configuration, but no
longer.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 865c8db..87b41b0 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -968,8 +968,6 @@ static void push_to_pool(struct work_struct *work)
 static size_t account(struct entropy_store *r, size_t nbytes, int min,
 		      int reserved)
 {
-	unsigned long flags;
-	int wakeup_write = 0;
 	int have_bytes;
 	int entropy_count, orig;
 	size_t ibytes;
@@ -981,24 +979,19 @@ retry:
 	entropy_count = orig = ACCESS_ONCE(r->entropy_count);
 	have_bytes = entropy_count >> (ENTROPY_SHIFT + 3);
 	ibytes = nbytes;
-	if (have_bytes < min + reserved) {
+	/* If limited, never pull more than available */
+	if (r->limit)
+		ibytes = min_t(size_t, ibytes, have_bytes - reserved);
+	if (ibytes < min)
 		ibytes = 0;
-	} else {
-		/* If limited, never pull more than available */
-		if (r->limit)
-			ibytes = min_t(size_t, ibytes, have_bytes - reserved);
-		entropy_count = max_t(int, 0,
-			    entropy_count - (ibytes << (ENTROPY_SHIFT + 3)));
-		if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
-			goto retry;
-
-		if ((r->entropy_count >> ENTROPY_SHIFT)
-		    < random_write_wakeup_thresh)
-			wakeup_write = 1;
-	}
+	entropy_count = max_t(int, 0,
+			      entropy_count - (ibytes << (ENTROPY_SHIFT + 3)));
+	if (ibytes && cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
+		goto retry;
 
 	trace_debit_entropy(r->name, 8 * ibytes);
-	if (wakeup_write) {
+	if (ibytes &&
+	    (r->entropy_count >> ENTROPY_SHIFT) < random_write_wakeup_thresh) {
 		wake_up_interruptible(&random_write_wait);
 		kill_fasync(&fasync, SIGIO, POLL_OUT);
 	}
-- 
1.8.3.2
