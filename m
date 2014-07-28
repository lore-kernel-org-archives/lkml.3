Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaG1I3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:29:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42807 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaG1I3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:29:19 -0400
Date: Mon, 28 Jul 2014 01:28:23 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-f4be073db878d0e79f74bc36f1642847781791a0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, acme@kernel.org, fweisbec@gmail.com,
        yarygin@linux.vnet.ibm.com, rostedt@goodmis.org, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        yarygin@linux.vnet.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1405079782-8139-1-git-send-email-jolsa@kernel.org>
References: <1405079782-8139-1-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Check permission only for parent tracepoint event
Git-Commit-ID: f4be073db878d0e79f74bc36f1642847781791a0
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

Commit-ID:  f4be073db878d0e79f74bc36f1642847781791a0
Gitweb:     http://git.kernel.org/tip/f4be073db878d0e79f74bc36f1642847781791a0
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Wed, 16 Jul 2014 14:33:29 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 28 Jul 2014 10:01:38 +0200

perf: Check permission only for parent tracepoint event

There's no need to check cloned event's permission once the
parent was already checked.

Also the code is checking 'current' process permissions, which
is not owner process for cloned events, thus could end up with
wrong permission check result.

Reported-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Tested-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1405079782-8139-1-git-send-email-jolsa@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/trace/trace_event_perf.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 5d12bb4..4b9c114 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -30,6 +30,18 @@ static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
 			return ret;
 	}
 
+	/*
+	 * We checked and allowed to create parent,
+	 * allow children without checking.
+	 */
+	if (p_event->parent)
+		return 0;
+
+	/*
+	 * It's ok to check current process (owner) permissions in here,
+	 * because code below is called only via perf_event_open syscall.
+	 */
+
 	/* The ftrace function trace is allowed only for root. */
 	if (ftrace_event_is_function(tp_event)) {
 		if (perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
