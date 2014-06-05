Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaFEPVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:21:50 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:19284 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751965AbaFEPVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:21:16 -0400
Message-Id: <20140605152114.045638974@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 05 Jun 2014 11:15:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [for-next][PATCH 3/5] tracing: Eliminate double free on failure of allocation on boot up
References: <20140605151540.672365024@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-tracing-Eliminate-double-free-on-failure-of-allocati.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>

If allocation of the max_buffer fails on boot up, the error path will
free both per_cpu data structures from the buffers. With the new redesign
of the code, those structures are freed if allocations failed. That is,
the helper function that allocates the buffers will free the per cpu data
on failure. No need to do it again. In fact, the second free will cause
a bug as the code can not handle a double free.

Link: http://lkml.kernel.org/p/20140603042803.27308.30956.stgit@yunodevel

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 626dbfde5d56..135af323608b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6671,10 +6671,6 @@ __init static int tracer_alloc_buffers(void)
 out_free_temp_buffer:
 	ring_buffer_free(temp_buffer);
 out_free_cpumask:
-	free_percpu(global_trace.trace_buffer.data);
-#ifdef CONFIG_TRACER_MAX_TRACE
-	free_percpu(global_trace.max_buffer.data);
-#endif
 	free_cpumask_var(global_trace.tracing_cpumask);
 out_free_buffer_mask:
 	free_cpumask_var(tracing_buffer_mask);
-- 
2.0.0.rc2


