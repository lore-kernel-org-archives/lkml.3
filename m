Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbaDWNOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:14:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37420 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281AbaDWNOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:14:20 -0400
Date: Wed, 23 Apr 2014 06:14:02 -0700
From: tip-bot for Steven Rostedt <tipbot@zytor.com>
Message-ID: <tip-de04f8657de9d3351a2d5880f1f7080b23b798cf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <20140422192330.6bb09bf8@gandalf.local.home>
References: <20140422192330.6bb09bf8@gandalf.local.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools lib traceevent:
  Fix memory leak in pretty_print()
Git-Commit-ID: de04f8657de9d3351a2d5880f1f7080b23b798cf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de04f8657de9d3351a2d5880f1f7080b23b798cf
Gitweb:     http://git.kernel.org/tip/de04f8657de9d3351a2d5880f1f7080b23b798cf
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Tue, 22 Apr 2014 19:23:30 -0400
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Wed, 23 Apr 2014 13:19:30 +0200

tools lib traceevent: Fix memory leak in pretty_print()

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
