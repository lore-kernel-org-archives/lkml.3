Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab3J3S3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 14:29:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51390 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab3J3S3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 14:29:45 -0400
Date: Wed, 30 Oct 2013 19:29:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Victor Kaplansky <VICTORK@il.ibm.com>
Cc: paulmck@linux.vnet.ibm.com, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <20131030182930.GP2490@laptop.programming.kicks-ass.net>
References: <20131025173749.GG19466@laptop.lan>
 <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com>
 <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com>
 <20131028132634.GO19466@laptop.lan>
 <20131028163418.GD4126@linux.vnet.ibm.com>
 <20131028201735.GA15629@redhat.com>
 <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
 <20131030092725.GL4126@linux.vnet.ibm.com>
 <OFC6B7100E.31C6B190-ON42257C14.004841C6-42257C14.004A0EA6@il.ibm.com>
 <20131030155116.GO16117@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030155116.GO16117@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 04:51:16PM +0100, Peter Zijlstra wrote:
> On Wed, Oct 30, 2013 at 03:28:54PM +0200, Victor Kaplansky wrote:
> > one of the authors of Documentation/memory-barriers.txt is on cc: list ;-)
> > 
> > Disclaimer: it is anyway impossible to prove lack of *any* problem.
> > 
> > Having said that, lets look into an example in
> > Documentation/circular-buffers.txt:
> 
> > 
> > We can see that authors of the document didn't put any memory barrier
> 
> Note that both documents have the same author list ;-)
> 
> Anyway, I didn't know about the circular thing, I suppose I should use
> CIRC_SPACE() thing :-)

The below removes 80 bytes from ring_buffer.o of which 50 bytes are from
perf_output_begin(), it also removes 30 lines of code, so yay!

(x86_64 build)

And it appears to still work.. although I've not stressed the no-space
bits.

---
 kernel/events/ring_buffer.c | 74 ++++++++++++++-------------------------------
 1 file changed, 22 insertions(+), 52 deletions(-)

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 9c2ddfbf4525..e4a51fa10595 100644
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
@@ -115,8 +85,7 @@ static void perf_output_put_handle(struct perf_output_handle *handle)
 	rb->user_page->data_head = head;
 
 	/*
-	 * Now check if we missed an update, rely on the (compiler)
-	 * barrier in atomic_dec_and_test() to re-read rb->head.
+	 * Now check if we missed an update.
 	 */
 	if (unlikely(head != local_read(&rb->head))) {
 		local_inc(&rb->nest);
@@ -135,7 +104,7 @@ int perf_output_begin(struct perf_output_handle *handle,
 {
 	struct ring_buffer *rb;
 	unsigned long tail, offset, head;
-	int have_lost;
+	int have_lost, page_shift;
 	struct perf_sample_data sample_data;
 	struct {
 		struct perf_event_header header;
@@ -161,7 +130,7 @@ int perf_output_begin(struct perf_output_handle *handle,
 		goto out;
 
 	have_lost = local_read(&rb->lost);
-	if (have_lost) {
+	if (unlikely(have_lost)) {
 		lost_event.header.size = sizeof(lost_event);
 		perf_event_header__init_id(&lost_event.header, &sample_data,
 					   event);
@@ -171,32 +140,33 @@ int perf_output_begin(struct perf_output_handle *handle,
 	perf_output_get_handle(handle);
 
 	do {
-		/*
-		 * Userspace could choose to issue a mb() before updating the
-		 * tail pointer. So that all reads will be completed before the
-		 * write is issued.
-		 *
-		 * See perf_output_put_handle().
-		 */
 		tail = ACCESS_ONCE(rb->user_page->data_tail);
-		smp_mb();
 		offset = head = local_read(&rb->head);
-		head += size;
-		if (unlikely(!perf_output_space(rb, tail, offset, head)))
+		if (!rb->overwrite &&
+		    unlikely(CIRC_SPACE(head, tail, perf_data_size(rb)) < size))
 			goto fail;
+		head += size;
 	} while (local_cmpxchg(&rb->head, offset, head) != offset);
 
+	/*
+	 * Userspace SHOULD issue an MB before writing the tail; see
+	 * perf_output_put_handle().
+	 */
+	smp_mb();
+
 	if (head - local_read(&rb->wakeup) > rb->watermark)
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
+
+	offset &= page_shift - 1;
+
+	handle->addr = rb->data_pages[handle->page] + offset;
+	handle->size = (1 << page_shift) - offset;
 
-	if (have_lost) {
+	if (unlikely(have_lost)) {
 		lost_event.header.type = PERF_RECORD_LOST;
 		lost_event.header.misc = 0;
 		lost_event.id          = event->id;
