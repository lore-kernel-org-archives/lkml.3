Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbbAQKLK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 05:11:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44253 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbbAQKLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 05:11:07 -0500
Date: Sat, 17 Jan 2015 02:10:27 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-7949ba1fa249caa7e611abb8d92f40b0a46c8617@git.kernel.org>
Cc: jolsa@redhat.com, masami.hiramatsu.pt@hitachi.com, acme@redhat.com,
        namhyung@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        dsahern@gmail.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        hpa@zytor.com
Reply-To: acme@redhat.com, namhyung@kernel.org, mingo@kernel.org,
        hpa@zytor.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, dsahern@gmail.com, jolsa@redhat.com,
        masami.hiramatsu.pt@hitachi.com
In-Reply-To: <1420886028-15135-4-git-send-email-namhyung@kernel.org>
References: <1420886028-15135-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Propagate error code when write(2)
  failed
Git-Commit-ID: 7949ba1fa249caa7e611abb8d92f40b0a46c8617
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

Commit-ID:  7949ba1fa249caa7e611abb8d92f40b0a46c8617
Gitweb:     http://git.kernel.org/tip/7949ba1fa249caa7e611abb8d92f40b0a46c8617
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Sat, 10 Jan 2015 19:33:48 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 16 Jan 2015 17:49:28 -0300

perf probe: Propagate error code when write(2) failed

When it failed to write probe commands to the probe_event file in
debugfs, it needs to propagate the error code properly.  Current code
blindly uses the return value of the write(2) so it always uses
-1 (-EPERM) and it might confuse users.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1420886028-15135-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 7f9b863..94a717b 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2052,9 +2052,11 @@ static int write_probe_trace_event(int fd, struct probe_trace_event *tev)
 	pr_debug("Writing event: %s\n", buf);
 	if (!probe_event_dry_run) {
 		ret = write(fd, buf, strlen(buf));
-		if (ret <= 0)
+		if (ret <= 0) {
+			ret = -errno;
 			pr_warning("Failed to write event: %s\n",
 				   strerror_r(errno, sbuf, sizeof(sbuf)));
+		}
 	}
 	free(buf);
 	return ret;
