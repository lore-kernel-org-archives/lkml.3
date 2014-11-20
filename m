Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbaKTPaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:30:25 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:7721 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757298AbaKTP1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:27:19 -0500
Message-Id: <20141120152716.901899133@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 20 Nov 2014 10:21:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: [for-next][PATCH 08/15] tracing: Add paranoid size check in trace_printk_seq()
References: <20141120152120.168868031@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0008-tracing-Add-paranoid-size-check-in-trace_printk_seq.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

To be really paranoid about writing out of bound data in
trace_printk_seq(), add another check of len compared to size.

Link: http://lkml.kernel.org/r/20141119144004.GB2332@dhcp128.suse.cz

Suggested-by: Petr Mladek <pmladek@suse.cz>
Reviewed-by: Petr Mladek <pmladek@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9023446b2c2b..26facec4625e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6656,6 +6656,14 @@ trace_printk_seq(struct trace_seq *s)
 	if (s->seq.len >= TRACE_MAX_PRINT)
 		s->seq.len = TRACE_MAX_PRINT;
 
+	/*
+	 * More paranoid code. Although the buffer size is set to
+	 * PAGE_SIZE, and TRACE_MAX_PRINT is 1000, this is just
+	 * an extra layer of protection.
+	 */
+	if (WARN_ON_ONCE(s->seq.len >= s->seq.size))
+		s->seq.len = s->seq.size - 1;
+
 	/* should be zero ended, but we are paranoid. */
 	s->buffer[s->seq.len] = 0;
 
-- 
2.1.1


