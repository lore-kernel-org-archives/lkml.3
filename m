Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab3KFNUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:20:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48919 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594Ab3KFNUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:20:06 -0500
Date: Wed, 6 Nov 2013 05:18:47 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-c19u6egfldyx86tpyc3zgkw9@git.kernel.org>
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
Git-Commit-ID: 85f59edf9684603026c64c902791748116d29478
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 05:18:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  85f59edf9684603026c64c902791748116d29478
Gitweb:     http://git.kernel.org/tip/85f59edf9684603026c64c902791748116d29478
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 31 Oct 2013 17:25:38 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 12:34:20 +0100

perf: Optimize perf_output_begin()

There's no point in re-doing the memory-barrier when we fail the
cmpxchg(). Also placing it after the space reservation loop makes it
clearer it only separates the userpage->tail read from the data
stores.

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
Link: http://lkml.kernel.org/n/tip-c19u6egfldyx86tpyc3zgkw9@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/ring_buffer.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 383cde4..6ed16ec 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -141,15 +141,7 @@ int perf_output_begin(struct perf_output_handle *handle,
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
 		if (!rb->overwrite &&
 		    unlikely(CIRC_SPACE(head, tail, perf_data_size(rb)) < size))
@@ -157,6 +149,15 @@ int perf_output_begin(struct perf_output_handle *handle,
 		head += size;
 	} while (local_cmpxchg(&rb->head, offset, head) != offset);
 
+	/*
+	 * Separate the userpage->tail read from the data stores below.
+	 * Matches the MB userspace SHOULD issue after reading the data
+	 * and before storing the new tail position.
+	 *
+	 * See perf_output_put_handle().
+	 */
+	smp_mb();
+
 	if (unlikely(head - local_read(&rb->wakeup) > rb->watermark))
 		local_add(rb->watermark, &rb->wakeup);
 
