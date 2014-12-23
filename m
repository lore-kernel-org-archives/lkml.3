Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbaLWQQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 11:16:49 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:30562 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756084AbaLWQQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 11:16:48 -0500
Message-Id: <20141223161340.297942985@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 23 Dec 2014 11:13:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/2] tracing: Remove bottle neck mutex in splicing from ring buffer
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While profiling with trace-cmd, I found that the there was a global
mutex being taken in the per-cpu splice code. This was slowing down
the recording and causing more missed events than necessary.

By adding a ref count to the tracer, and preventing the tracer from
changing when the ref count is non-zero (when a trace file is opened)
we can remove the taking of the trace_types_lock mutex from the
splice page and speed things up a bit.

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: d716ff71dd12bc6328f84a9ec1c3647daf01c827


Steven Rostedt (Red Hat) (2):
      tracing: Add ref count to tracer for when they are being read by pipe
      tracing: Remove taking of trace_types_lock in pipe files

----
 kernel/trace/trace.c | 126 ++++++++++++++++++---------------------------------
 kernel/trace/trace.h |   1 +
 2 files changed, 44 insertions(+), 83 deletions(-)

