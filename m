Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbaFLMCC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:02:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60534 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbaFLMB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:01:57 -0400
Date: Thu, 12 Jun 2014 05:01:28 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-a261e4a09a073451057e9dbe17783255ea94598d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <20140605204117.GA1771@krava.redhat.com>
References: <20140605204117.GA1771@krava.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix pipe check regression in attr event callback
Git-Commit-ID: a261e4a09a073451057e9dbe17783255ea94598d
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

Commit-ID:  a261e4a09a073451057e9dbe17783255ea94598d
Gitweb:     http://git.kernel.org/tip/a261e4a09a073451057e9dbe17783255ea94598d
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Thu, 5 Jun 2014 18:51:44 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 9 Jun 2014 12:20:34 +0200

perf tools: Fix pipe check regression in attr event callback

The file factoring in builtin-inject.c object introduced regression
in attr event callback. The commit is:
  3406912 perf inject: Handle output file via perf_data_file object

Following hunk reversed the logic:
  -       if (!inject->pipe_output)
  +       if (&inject->output.is_pipe)

putting it back, following example now works:
  $ perf record -o - kill | perf inject -b | perf report -i -

Plus removing extra '&' (kudos to Arnaldo)

Reported-by: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140605204117.GA1771@krava.redhat.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-inject.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 6a3af00..16c7c11 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -72,7 +72,7 @@ static int perf_event__repipe_attr(struct perf_tool *tool,
 	if (ret)
 		return ret;
 
-	if (&inject->output.is_pipe)
+	if (!inject->output.is_pipe)
 		return 0;
 
 	return perf_event__repipe_synth(tool, event);
