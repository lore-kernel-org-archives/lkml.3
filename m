Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbaCKMjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:39:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35641 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943AbaCKMjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:39:12 -0400
Date: Tue, 11 Mar 2014 05:38:19 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-cfa77bc4af2c75c0781ee76cde2dd104c6c8e2b7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, peterz@infradead.org,
        acme@ghostprotocols.net, jolsa@redhat.com, vincent.weaver@maine.edu,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, peterz@infradead.org, jolsa@redhat.com,
        vincent.weaver@maine.edu, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1393775800-13524-2-git-send-email-jolsa@redhat.com>
References: <1393775800-13524-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Disallow user-space callchains for function trace events
Git-Commit-ID: cfa77bc4af2c75c0781ee76cde2dd104c6c8e2b7
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

Commit-ID:  cfa77bc4af2c75c0781ee76cde2dd104c6c8e2b7
Gitweb:     http://git.kernel.org/tip/cfa77bc4af2c75c0781ee76cde2dd104c6c8e2b7
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sun, 2 Mar 2014 16:56:38 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Mar 2014 11:57:57 +0100

perf: Disallow user-space callchains for function trace events

Recent issues with user space callchains processing within
page fault handler tracing showed as Peter said 'there's
just too much fail surface'.

Related list discussions:

  http://marc.info/?t=139302086500001&r=1&w=2
  http://marc.info/?t=139301437300003&r=1&w=2

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1393775800-13524-2-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/trace/trace_event_perf.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index e854f42..d5e01c3 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -31,9 +31,18 @@ static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
 	}
 
 	/* The ftrace function trace is allowed only for root. */
-	if (ftrace_event_is_function(tp_event) &&
-	    perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
-		return -EPERM;
+	if (ftrace_event_is_function(tp_event)) {
+		if (perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		/*
+		 * We don't allow user space callchains for  function trace
+		 * event, due to issues with page faults while tracing page
+		 * fault handler and its overall trickiness nature.
+		 */
+		if (!p_event->attr.exclude_callchain_user)
+			return -EINVAL;
+	}
 
 	/* No tracing, just counting, so no obvious leak */
 	if (!(p_event->attr.sample_type & PERF_SAMPLE_RAW))
