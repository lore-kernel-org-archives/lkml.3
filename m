Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbaDVXXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 19:23:34 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:16618 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750723AbaDVXXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 19:23:33 -0400
Date: Tue, 22 Apr 2014 19:23:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH] tools lib traceevent: Fix memory leak in pretty_print()
Message-ID: <20140422192330.6bb09bf8@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit 12e55569a244 "tools lib traceevent: Use helper trace-seq in print
functions like kernel does" added a extra trace_seq helper to process
string arguments like the kernel does it. But the difference between the
kernel and the userspace library is that the kernel's trace_seq structure
has a static allocated buffer. The userspace one has a dynamically
allocated one. It requires a trace_seq_destroy(), otherwise it produces
a nasty memory leak.

Cc: stable@vger.kernel.org # 3.14+
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index baec7d8..b83184f 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4344,6 +4344,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 					      format, len_arg, arg);
 				trace_seq_terminate(&p);
 				trace_seq_puts(s, p.buffer);
+				trace_seq_destroy(&p);
 				arg = arg->next;
 				break;
 			default:
-- 
1.8.1.4

