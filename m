Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934976AbaKNBOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:14:18 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:19427 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934578AbaKNBOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:14:12 -0500
Message-Id: <20141114011410.200049674@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 13 Nov 2014 20:12:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: [RFC][PATCH 01/23 v4] tracing: Fix trace_seq_bitmask() to start at current position
References: <20141114011244.256115061@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-tracing-Fix-trace_seq_bitmask-to-start-at-current-po.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

In trace_seq_bitmask() it calls bitmap_scnprintf() not from the current
position of the trace_seq buffer (s->buffer + s->len), but instead from
the beginning of the buffer (s->buffer).

Luckily, the only user of this "ipi_raise tracepoint" uses it as the
first parameter, and as such, the start of the temp buffer in
include/trace/ftrace.h (see __get_bitmask()).

Reported-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_seq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
index 1f24ed99dca2..b100994a17fe 100644
--- a/kernel/trace/trace_seq.c
+++ b/kernel/trace/trace_seq.c
@@ -122,7 +122,7 @@ int trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
 	if (s->full || !len)
 		return 0;
 
-	ret = bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
+	ret = bitmap_scnprintf(s->buffer + s->len, len, maskp, nmaskbits);
 	s->len += ret;
 
 	return 1;
-- 
2.1.1


