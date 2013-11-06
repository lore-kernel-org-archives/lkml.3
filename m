Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab3KFNUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:20:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48922 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607Ab3KFNUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:20:09 -0500
Date: Wed, 6 Nov 2013 05:18:56 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-zfxnc58qxj0eawdoj31hhupv@git.kernel.org>
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
  -- lost_event case
Git-Commit-ID: d20a973f46ed83e0d7d24f6c512064133038e193
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 05:19:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d20a973f46ed83e0d7d24f6c512064133038e193
Gitweb:     http://git.kernel.org/tip/d20a973f46ed83e0d7d24f6c512064133038e193
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 31 Oct 2013 17:29:29 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 12:34:21 +0100

perf: Optimize perf_output_begin() -- lost_event case

Avoid touching the lost_event and sample_data cachelines twince. Its
not like we end up doing less work, but it might help to keep all
accesses to these cachelines in one place.

Due to code shuffle, this looses 4 bytes on x86_64-defconfig.

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
Link: http://lkml.kernel.org/n/tip-zfxnc58qxj0eawdoj31hhupv@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/ring_buffer.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 6ed16ec..e4d70f3 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -106,7 +106,6 @@ int perf_output_begin(struct perf_output_handle *handle,
 	struct ring_buffer *rb;
 	unsigned long tail, offset, head;
 	int have_lost;
-	struct perf_sample_data sample_data;
 	struct {
 		struct perf_event_header header;
 		u64			 id;
@@ -132,10 +131,9 @@ int perf_output_begin(struct perf_output_handle *handle,
 
 	have_lost = local_read(&rb->lost);
 	if (unlikely(have_lost)) {
-		lost_event.header.size = sizeof(lost_event);
-		perf_event_header__init_id(&lost_event.header, &sample_data,
-					   event);
-		size += lost_event.header.size;
+		size += sizeof(lost_event);
+		if (event->attr.sample_id_all)
+			size += event->id_header_size;
 	}
 
 	perf_output_get_handle(handle);
@@ -169,11 +167,16 @@ int perf_output_begin(struct perf_output_handle *handle,
 	handle->size = (PAGE_SIZE << page_order(rb)) - handle->size;
 
 	if (unlikely(have_lost)) {
+		struct perf_sample_data sample_data;
+
+		lost_event.header.size = sizeof(lost_event);
 		lost_event.header.type = PERF_RECORD_LOST;
 		lost_event.header.misc = 0;
 		lost_event.id          = event->id;
 		lost_event.lost        = local_xchg(&rb->lost, 0);
 
+		perf_event_header__init_id(&lost_event.header,
+					   &sample_data, event);
 		perf_output_put(handle, lost_event);
 		perf_event__output_id_sample(event, handle, &sample_data);
 	}
