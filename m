Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbaCKMsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:48:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35648 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055AbaCKMjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:39:15 -0400
Date: Tue, 11 Mar 2014 05:38:31 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-63c45f4ba533e9749da16298db53e491c25d805b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, peterz@infradead.org,
        acme@ghostprotocols.net, jolsa@redhat.com, vincent.weaver@maine.edu,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, peterz@infradead.org, jolsa@redhat.com,
        vincent.weaver@maine.edu, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1393775800-13524-3-git-send-email-jolsa@redhat.com>
References: <1393775800-13524-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Disallow user-space stack dumps for function trace events
Git-Commit-ID: 63c45f4ba533e9749da16298db53e491c25d805b
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

Commit-ID:  63c45f4ba533e9749da16298db53e491c25d805b
Gitweb:     http://git.kernel.org/tip/63c45f4ba533e9749da16298db53e491c25d805b
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sun, 2 Mar 2014 16:56:39 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Mar 2014 11:57:58 +0100

perf: Disallow user-space stack dumps for function trace events

Recent issues with user space callchains processing within
page fault handler tracing showed as Peter said 'there's
just too much fail surface'.

The user space stack dump is just another source of the this issue.

Related list discussions:
  http://marc.info/?t=139302086500001&r=1&w=2
  http://marc.info/?t=139301437300003&r=1&w=2

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1393775800-13524-3-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/trace/trace_event_perf.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index d5e01c3..c894614 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -42,6 +42,13 @@ static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
 		 */
 		if (!p_event->attr.exclude_callchain_user)
 			return -EINVAL;
+
+		/*
+		 * Same reason to disable user stack dump as for user space
+		 * callchains above.
+		 */
+		if (p_event->attr.sample_type & PERF_SAMPLE_STACK_USER)
+			return -EINVAL;
 	}
 
 	/* No tracing, just counting, so no obvious leak */
