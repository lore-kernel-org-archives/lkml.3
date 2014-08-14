Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbaHNCWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 22:22:36 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51965 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbaHNCWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 22:22:34 -0400
X-AuditID: 85900ec0-d272ab9000001514-b2-53ec1d67bc25
Subject: [PATCH 01/13] perf probe: Don't use strerror if strlist__add failed
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>
Date: Thu, 14 Aug 2014 02:22:30 +0000
Message-ID: <20140814022230.3545.99254.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140814022228.3545.90481.stgit@kbuild-fedora.novalocal>
References: <20140814022228.3545.90481.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the strlist__add doesn't involves any IO, the failure
reason must be ENOMEM or EINVAL, moreover this is just a
debug message, we don't need to show the error string.

And also, if get_probe_trace_command_rawlist() returns NULL,
it doesn't mean the rawlist is empty, there is an error.
So caller must use -ENOMEM for the error.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/util/probe-event.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 784ea42..66799c6 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1876,7 +1876,7 @@ static struct strlist *get_probe_trace_command_rawlist(int fd)
 			p[idx] = '\0';
 		ret = strlist__add(sl, buf);
 		if (ret < 0) {
-			pr_debug("strlist__add failed: %s\n", strerror(-ret));
+			pr_debug("strlist__add failed (%d)\n", ret);
 			strlist__delete(sl);
 			return NULL;
 		}
@@ -1935,7 +1935,7 @@ static int __show_perf_probe_events(int fd, bool is_kprobe)
 
 	rawlist = get_probe_trace_command_rawlist(fd);
 	if (!rawlist)
-		return -ENOENT;
+		return -ENOMEM;
 
 	strlist__for_each(ent, rawlist) {
 		ret = parse_probe_trace_command(ent->s, &tev);
@@ -2002,6 +2002,8 @@ static struct strlist *get_probe_trace_event_names(int fd, bool include_group)
 
 	memset(&tev, 0, sizeof(tev));
 	rawlist = get_probe_trace_command_rawlist(fd);
+	if (!rawlist)
+		return NULL;
 	sl = strlist__new(true, NULL);
 	strlist__for_each(ent, rawlist) {
 		ret = parse_probe_trace_command(ent->s, &tev);

