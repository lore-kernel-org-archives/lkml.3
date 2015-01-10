Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbbAJKe4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 05:34:56 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:55829 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbbAJKeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 05:34:09 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 4/4] perf probe: Propagate error code when write(2) failed
Date: Sat, 10 Jan 2015 19:33:48 +0900
Message-Id: <1420886028-15135-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1420886028-15135-1-git-send-email-namhyung@kernel.org>
References: <1420886028-15135-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When it failed to write probe commands to the probe_event file in
debugfs, it needs to propagate the error code properly.  Current code
blindly uses the return value of the write(2) so it always uses
-1 (-EPERM) and it might confuse users.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/probe-event.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 6fe5aa357efc..ddc295885af0 100644
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
-- 
2.2.1

