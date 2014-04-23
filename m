Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaDWLbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:31:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbaDWLbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:31:40 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        stable@vger.kernel.org.#.3.14+, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 4/4] tools lib traceevent: Fix memory leak in pretty_print()
Date: Wed, 23 Apr 2014 13:31:22 +0200
Message-Id: <1398252682-17185-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1398252682-17185-1-git-send-email-jolsa@redhat.com>
References: <1398252682-17185-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Commit 12e55569a244 "tools lib traceevent: Use helper trace-seq in print
functions like kernel does" added a extra trace_seq helper to process
string arguments like the kernel does it. But the difference between the
kernel and the userspace library is that the kernel's trace_seq structure
has a static allocated buffer. The userspace one has a dynamically
allocated one. It requires a trace_seq_destroy(), otherwise it produces
a nasty memory leak.

Cc: stable@vger.kernel.org # 3.14+
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20140422192330.6bb09bf8@gandalf.local.home
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
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
1.8.3.1

