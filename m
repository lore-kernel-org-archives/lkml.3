Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab3KFNUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:20:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48920 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606Ab3KFNUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:20:06 -0500
Date: Wed, 6 Nov 2013 05:18:27 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-vtb0xb0llebmsdlfn1v5vtfj@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, anton@samba.org,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, mingo@kernel.org,
        michael@ellerman.id.au, peterz@infradead.org, vince@deater.net,
        paulmck@linux.vnet.ibm.com, benh@kernel.crashing.org,
        fweisbec@gmail.com, oleg@redhat.com, VICTORK@il.ibm.com,
        tglx@linutronix.de, mikey@neuling.org
Reply-To: mingo@kernel.org, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
        anton@samba.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        michael@ellerman.id.au, paulmck@linux.vnet.ibm.com, vince@deater.net,
        fweisbec@gmail.com, benh@kernel.crashing.org, tglx@linutronix.de,
        VICTORK@il.ibm.com, oleg@redhat.com, mikey@neuling.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Simplify the ring-buffer code
Git-Commit-ID: 26c86da8821f7b64fced498674990318bc34c8de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 05:18:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26c86da8821f7b64fced498674990318bc34c8de
Gitweb:     http://git.kernel.org/tip/26c86da8821f7b64fced498674990318bc34c8de
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 31 Oct 2013 10:19:59 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 12:34:18 +0100

perf: Simplify the ring-buffer code

By using CIRC_SPACE() we can obviate the need for perf_output_space().

Shrinks the size of perf_output_begin() by 17 bytes on
x86_64-defconfig.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Michael Neuling <mikey@neuling.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: james.hogan@imgtec.com
Cc: Vince Weaver <vince@deater.net>
Cc: Victor Kaplansky <VICTORK@il.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Anton Blanchard <anton@samba.org>
Link: http://lkml.kernel.org/n/tip-vtb0xb0llebmsdlfn1v5vtfj@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/ring_buffer.c | 37 ++++---------------------------------
 1 file changed, 4 insertions(+), 33 deletions(-)

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 9c2ddfb..6929c58 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -12,40 +12,10 @@
 #include <linux/perf_event.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
+#include <linux/circ_buf.h>
 
 #include "internal.h"
 
-static bool perf_output_space(struct ring_buffer *rb, unsigned long tail,
-			      unsigned long offset, unsigned long head)
-{
-	unsigned long sz = perf_data_size(rb);
-	unsigned long mask = sz - 1;
-
-	/*
-	 * check if user-writable
-	 * overwrite : over-write its own tail
-	 * !overwrite: buffer possibly drops events.
-	 */
-	if (rb->overwrite)
-		return true;
-
-	/*
-	 * verify that payload is not bigger than buffer
-	 * otherwise masking logic may fail to detect
-	 * the "not enough space" condition
-	 */
-	if ((head - offset) > sz)
-		return false;
-
-	offset = (offset - tail) & mask;
-	head   = (head   - tail) & mask;
-
-	if ((int)(head - offset) < 0)
-		return false;
-
-	return true;
-}
-
 static void perf_output_wakeup(struct perf_output_handle *handle)
 {
 	atomic_set(&handle->rb->poll, POLL_IN);
@@ -181,9 +151,10 @@ int perf_output_begin(struct perf_output_handle *handle,
 		tail = ACCESS_ONCE(rb->user_page->data_tail);
 		smp_mb();
 		offset = head = local_read(&rb->head);
-		head += size;
-		if (unlikely(!perf_output_space(rb, tail, offset, head)))
+		if (!rb->overwrite &&
+		    unlikely(CIRC_SPACE(head, tail, perf_data_size(rb)) < size))
 			goto fail;
+		head += size;
 	} while (local_cmpxchg(&rb->head, offset, head) != offset);
 
 	if (head - local_read(&rb->wakeup) > rb->watermark)
