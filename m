Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab3KFNYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:24:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48929 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab3KFNUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:20:12 -0500
Date: Wed, 6 Nov 2013 05:19:05 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-3trb2n2henb9m27tncef3ag7@git.kernel.org>
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
Subject: [tip:perf/core] perf: Optimize perf_output_begin()
  -- address calculation
Git-Commit-ID: 524feca5e9da9e5f9e5aa5d5613b1d762db9509e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 05:19:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  524feca5e9da9e5f9e5aa5d5613b1d762db9509e
Gitweb:     http://git.kernel.org/tip/524feca5e9da9e5f9e5aa5d5613b1d762db9509e
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 31 Oct 2013 17:36:25 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 12:34:22 +0100

perf: Optimize perf_output_begin() -- address calculation

Rewrite the handle address calculation code to be clearer.

Saves 8 bytes on x86_64-defconfig.

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
Link: http://lkml.kernel.org/n/tip-3trb2n2henb9m27tncef3ag7@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/ring_buffer.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index e4d70f3..c52a32f 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -105,7 +105,7 @@ int perf_output_begin(struct perf_output_handle *handle,
 {
 	struct ring_buffer *rb;
 	unsigned long tail, offset, head;
-	int have_lost;
+	int have_lost, page_shift;
 	struct {
 		struct perf_event_header header;
 		u64			 id;
@@ -159,12 +159,12 @@ int perf_output_begin(struct perf_output_handle *handle,
 	if (unlikely(head - local_read(&rb->wakeup) > rb->watermark))
 		local_add(rb->watermark, &rb->wakeup);
 
-	handle->page = offset >> (PAGE_SHIFT + page_order(rb));
-	handle->page &= rb->nr_pages - 1;
-	handle->size = offset & ((PAGE_SIZE << page_order(rb)) - 1);
-	handle->addr = rb->data_pages[handle->page];
-	handle->addr += handle->size;
-	handle->size = (PAGE_SIZE << page_order(rb)) - handle->size;
+	page_shift = PAGE_SHIFT + page_order(rb);
+
+	handle->page = (offset >> page_shift) & (rb->nr_pages - 1);
+	offset &= (1UL << page_shift) - 1;
+	handle->addr = rb->data_pages[handle->page] + offset;
+	handle->size = (1UL << page_shift) - offset;
 
 	if (unlikely(have_lost)) {
 		struct perf_sample_data sample_data;
