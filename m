Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaAPNiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:38:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38268 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbaAPNiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:38:13 -0500
Date: Thu, 16 Jan 2014 05:37:44 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-3026bba3c37711234771349ca020d9a85e572f60@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1389750340-15965-3-git-send-email-namhyung@kernel.org>
References: <1389750340-15965-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Check return value of realloc()
Git-Commit-ID: 3026bba3c37711234771349ca020d9a85e572f60
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 05:37:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3026bba3c37711234771349ca020d9a85e572f60
Gitweb:     http://git.kernel.org/tip/3026bba3c37711234771349ca020d9a85e572f60
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Wed, 15 Jan 2014 10:45:25 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 15 Jan 2014 15:10:28 -0300

tools lib traceevent: Check return value of realloc()

If realloc() fails, it'll leak the buffer.  Also increate buffer size
only if the allocation succeeded.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1389750340-15965-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/trace-seq.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/trace-seq.c b/tools/lib/traceevent/trace-seq.c
index f711213..e454a2c 100644
--- a/tools/lib/traceevent/trace-seq.c
+++ b/tools/lib/traceevent/trace-seq.c
@@ -91,11 +91,16 @@ void trace_seq_destroy(struct trace_seq *s)
 
 static void expand_buffer(struct trace_seq *s)
 {
-	s->buffer_size += TRACE_SEQ_BUF_SIZE;
-	s->buffer = realloc(s->buffer, s->buffer_size);
-	if (WARN_ONCE(!s->buffer,
-		      "Can't allocate trace_seq buffer memory"))
+	char *buf;
+
+	buf = realloc(s->buffer, s->buffer_size + TRACE_SEQ_BUF_SIZE);
+	if (WARN_ONCE(!buf, "Can't allocate trace_seq buffer memory")) {
 		s->state = TRACE_SEQ__MEM_ALLOC_FAILED;
+		return;
+	}
+
+	s->buffer = buf;
+	s->buffer_size += TRACE_SEQ_BUF_SIZE;
 }
 
 /**
