Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab3AUVT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:19:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33581 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab3AUVRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:17:30 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=1qUcW2b0jkwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=WFGCPMuA9KsA:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=xt1qIhzxAAAA:8 a=lcmWLoirjDfMRU8MAagA:9 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130121211728.177153584@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 21 Jan 2013 16:14:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [PATCH 06/13 -next] tracing: Add checks if tr->buffer is NULL in
 tracing_reset{_online_cpus}
References: <20130121211403.337052956@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Add-checks-if-tr-buffer-is-NULL-in-tracing_r.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>

max_tr->buffer could be NULL in the tracing_reset{_online_cpus}. In this
case, a NULL pointer dereference happens, so we should return immediately
from these functions.

Note, the current code does not call tracing_reset*() with max_tr when
its buffer is NULL, but future code will. This patch is needed to prevent
the future code from crashing.

Link: http://lkml.kernel.org/r/20121219070234.31200.93863.stgit@liselsia

Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f8b7c62..72b171b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -922,6 +922,9 @@ void tracing_reset(struct trace_array *tr, int cpu)
 {
 	struct ring_buffer *buffer = tr->buffer;
 
+	if (!buffer)
+		return;
+
 	ring_buffer_record_disable(buffer);
 
 	/* Make sure all commits have finished */
@@ -936,6 +939,9 @@ void tracing_reset_online_cpus(struct trace_array *tr)
 	struct ring_buffer *buffer = tr->buffer;
 	int cpu;
 
+	if (!buffer)
+		return;
+
 	ring_buffer_record_disable(buffer);
 
 	/* Make sure all commits have finished */
-- 
1.7.10.4


