Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbbA1U4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:56:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbbA1U4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:56:16 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf: Use POLLIN instead of POLL_IN for perf poll data in flag
Date: Wed, 28 Jan 2015 18:54:38 +0100
Message-Id: <1422467678-22341-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we flag available data (via poll syscall) on perf fd with
POLL_IN macro, which is normally used for SIGIO interface.

We've been lucky, because POLLIN (0x1) is subset of POLL_IN (0x20001)
and sys_poll (do_pollfd function) cut the extra bit out (0x20000).

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/events/ring_buffer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index 146a5792b1d2..eadb95ce7aac 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -13,12 +13,13 @@
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
 #include <linux/circ_buf.h>
+#include <linux/poll.h>
 
 #include "internal.h"
 
 static void perf_output_wakeup(struct perf_output_handle *handle)
 {
-	atomic_set(&handle->rb->poll, POLL_IN);
+	atomic_set(&handle->rb->poll, POLLIN);
 
 	handle->event->pending_wakeup = 1;
 	irq_work_queue(&handle->event->pending);
-- 
1.9.3

