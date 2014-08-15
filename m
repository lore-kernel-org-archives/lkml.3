Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaHOQum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:50:42 -0400
Received: from mail.kernel.org ([198.145.19.201]:44706 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbaHOQuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:50:40 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Naohiro Aota <naota@elisp.net>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/18] perf probe: Don't use strerror if strlist__add failed
Date: Fri, 15 Aug 2014 13:49:51 -0300
Message-Id: <1408121403-11919-7-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408121403-11919-1-git-send-email-acme@kernel.org>
References: <1408121403-11919-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Since the strlist__add doesn't involves any IO, the failure reason must
be ENOMEM or EINVAL, moreover this is just a debug message, we don't
need to show the error string.

And also, if get_probe_trace_command_rawlist() returns NULL, it doesn't
mean the rawlist is empty, there is an error.  So caller must use
-ENOMEM for the error.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140814022230.3545.99254.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index ac15ff780009..bf39c23b275d 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1881,7 +1881,7 @@ static struct strlist *get_probe_trace_command_rawlist(int fd)
 			p[idx] = '\0';
 		ret = strlist__add(sl, buf);
 		if (ret < 0) {
-			pr_debug("strlist__add failed: %s\n", strerror(-ret));
+			pr_debug("strlist__add failed (%d)\n", ret);
 			strlist__delete(sl);
 			return NULL;
 		}
@@ -1940,7 +1940,7 @@ static int __show_perf_probe_events(int fd, bool is_kprobe)
 
 	rawlist = get_probe_trace_command_rawlist(fd);
 	if (!rawlist)
-		return -ENOENT;
+		return -ENOMEM;
 
 	strlist__for_each(ent, rawlist) {
 		ret = parse_probe_trace_command(ent->s, &tev);
@@ -2007,6 +2007,8 @@ static struct strlist *get_probe_trace_event_names(int fd, bool include_group)
 
 	memset(&tev, 0, sizeof(tev));
 	rawlist = get_probe_trace_command_rawlist(fd);
+	if (!rawlist)
+		return NULL;
 	sl = strlist__new(true, NULL);
 	strlist__for_each(ent, rawlist) {
 		ret = parse_probe_trace_command(ent->s, &tev);
-- 
1.9.3

