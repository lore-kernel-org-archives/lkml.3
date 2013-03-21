Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab3CUSRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:17:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33609 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3CUSRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:17:43 -0400
Date: Thu, 21 Mar 2013 11:16:29 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-dd9c086d9f507d02d5ba4d7c5eef4bb9518088b8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <20130318133327.GA3056@quad>
References: <20130318133327.GA3056@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix ring_buffer perf_output_space()
  boundary calculation
Git-Commit-ID: dd9c086d9f507d02d5ba4d7c5eef4bb9518088b8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 11:16:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd9c086d9f507d02d5ba4d7c5eef4bb9518088b8
Gitweb:     http://git.kernel.org/tip/dd9c086d9f507d02d5ba4d7c5eef4bb9518088b8
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 18 Mar 2013 14:33:28 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 21 Mar 2013 12:04:35 +0100

perf: Fix ring_buffer perf_output_space() boundary calculation

This patch fixes a flaw in perf_output_space(). In case the size
of the space needed is bigger than the actual buffer size, there
may be situations where the function would return true (i.e.,
there is space) when it should not. head > offset due to
rounding of the masking logic.

The problem can be tested by activating BTS on Intel processors.
A BTS record can be as big as 16 pages. The following command
fails:

  $ perf record -m 4 -c 1 -e branches:u my_test_program

You will get a buffer corruption with this. Perf report won't be
able to parse the perf.data.

The fix is to first check that the requested space is smaller
than the buffer size. If so, then the masking logic will work
fine. If not, then there is no chance the record can be saved
and it will be gracefully handled by upper code layers.

[ In v2, we also make the logic for the writable more explicit by
  renaming it to rb->overwrite because it tells whether or not the
  buffer can overwrite its tail (suggested by PeterZ). ]

Signed-off-by: Stephane Eranian <eranian@google.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: peterz@infradead.org
Cc: jolsa@redhat.com
Cc: fweisbec@gmail.com
Link: http://lkml.kernel.org/r/20130318133327.GA3056@quad
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/internal.h    |  2 +-
 kernel/events/ring_buffer.c | 22 ++++++++++++++++++----
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index d56a64c..eb675c4 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -16,7 +16,7 @@ struct ring_buffer {
 	int				page_order;	/* allocation order  */
 #endif
 	int				nr_pages;	/* nr of data pages  */
-	int				writable;	/* are we writable   */
+	int				overwrite;	/* can overwrite itself */
 
 	atomic_t			poll;		/* POLL_ for wakeups */
 
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 23cb34f..97fddb0 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -18,12 +18,24 @@
 static bool perf_output_space(struct ring_buffer *rb, unsigned long tail,
 			      unsigned long offset, unsigned long head)
 {
-	unsigned long mask;
+	unsigned long sz = perf_data_size(rb);
+	unsigned long mask = sz - 1;
 
-	if (!rb->writable)
+	/*
+	 * check if user-writable
+	 * overwrite : over-write its own tail
+	 * !overwrite: buffer possibly drops events.
+	 */
+	if (rb->overwrite)
 		return true;
 
-	mask = perf_data_size(rb) - 1;
+	/*
+	 * verify that payload is not bigger than buffer
+	 * otherwise masking logic may fail to detect
+	 * the "not enough space" condition
+	 */
+	if ((head - offset) > sz)
+		return false;
 
 	offset = (offset - tail) & mask;
 	head   = (head   - tail) & mask;
@@ -212,7 +224,9 @@ ring_buffer_init(struct ring_buffer *rb, long watermark, int flags)
 		rb->watermark = max_size / 2;
 
 	if (flags & RING_BUFFER_WRITABLE)
-		rb->writable = 1;
+		rb->overwrite = 0;
+	else
+		rb->overwrite = 1;
 
 	atomic_set(&rb->refcount, 1);
 
