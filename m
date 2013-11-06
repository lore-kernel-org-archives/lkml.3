Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab3KFNUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:20:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48939 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab3KFNUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:20:17 -0500
Date: Wed, 6 Nov 2013 05:18:38 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-wlg3jew3qnutm8opd0hyeuwn@git.kernel.org>
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
Subject: [tip:perf/core] perf: Add unlikely() to the ring-buffer code
Git-Commit-ID: c72b42a3dde487132da80202756c101b371b2add
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 05:18:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c72b42a3dde487132da80202756c101b371b2add
Gitweb:     http://git.kernel.org/tip/c72b42a3dde487132da80202756c101b371b2add
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 31 Oct 2013 17:20:25 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 12:34:19 +0100

perf: Add unlikely() to the ring-buffer code

Add unlikely() annotations to 'slow' paths:

When having a sampling event but no output buffer; you have bigger
issues -- also the bail is still faster than actually doing the work.

When having a sampling event but a control page only buffer, you have
bigger issues -- again the bail is still faster than actually doing
work.

Optimize for the case where you're not loosing events -- again, not
doing the work is still faster but make sure that when you have to
actually do work its as fast as possible.

The typical watermark is 1/2 the buffer size, so most events will not
take this path.

Shrinks perf_output_begin() by 16 bytes on x86_64-defconfig.

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
Link: http://lkml.kernel.org/n/tip-wlg3jew3qnutm8opd0hyeuwn@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/ring_buffer.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 6929c58..383cde4 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -121,17 +121,17 @@ int perf_output_begin(struct perf_output_handle *handle,
 		event = event->parent;
 
 	rb = rcu_dereference(event->rb);
-	if (!rb)
+	if (unlikely(!rb))
 		goto out;
 
-	handle->rb	= rb;
-	handle->event	= event;
-
-	if (!rb->nr_pages)
+	if (unlikely(!rb->nr_pages))
 		goto out;
 
+	handle->rb    = rb;
+	handle->event = event;
+
 	have_lost = local_read(&rb->lost);
-	if (have_lost) {
+	if (unlikely(have_lost)) {
 		lost_event.header.size = sizeof(lost_event);
 		perf_event_header__init_id(&lost_event.header, &sample_data,
 					   event);
@@ -157,7 +157,7 @@ int perf_output_begin(struct perf_output_handle *handle,
 		head += size;
 	} while (local_cmpxchg(&rb->head, offset, head) != offset);
 
-	if (head - local_read(&rb->wakeup) > rb->watermark)
+	if (unlikely(head - local_read(&rb->wakeup) > rb->watermark))
 		local_add(rb->watermark, &rb->wakeup);
 
 	handle->page = offset >> (PAGE_SHIFT + page_order(rb));
@@ -167,7 +167,7 @@ int perf_output_begin(struct perf_output_handle *handle,
 	handle->addr += handle->size;
 	handle->size = (PAGE_SIZE << page_order(rb)) - handle->size;
 
-	if (have_lost) {
+	if (unlikely(have_lost)) {
 		lost_event.header.type = PERF_RECORD_LOST;
 		lost_event.header.misc = 0;
 		lost_event.id          = event->id;
