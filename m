Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbaFJOqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:46:42 -0400
Received: from mail.kernel.org ([198.145.19.201]:53762 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbaFJOqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:46:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/7] perf probe: Improve error messages in --line option
Date: Tue, 10 Jun 2014 11:46:03 -0300
Message-Id: <1402411564-3303-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402411564-3303-1-git-send-email-acme@infradead.org>
References: <1402411564-3303-1-git-send-email-acme@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Improve error messages of 'perf probe --line' mode.

Currently 'perf probe' shows the "Debuginfo analysis failed" message with
an error code when the given symbol is not found:

  -----
  # perf probe -L page_cgroup_init_flatmem
  Debuginfo analysis failed. (-2)
    Error: Failed to show lines.
  -----

But -2 (-ENOENT) means that the given source line or function was not
found. With this patch, 'perf probe' shows the correct error message:

  -----
  # perf probe -L page_cgroup_init_flatmem
  Specified source line is not found.
    Error: Failed to show lines.
  -----

There is also another debug error code is shown in the same function
after get_real_path(). This removes that too.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140606071406.6788.47850.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 44c71417262f..9a0a1839a377 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -628,11 +628,11 @@ static int __show_line_range(struct line_range *lr, const char *module)
 
 	ret = debuginfo__find_line_range(dinfo, lr);
 	debuginfo__delete(dinfo);
-	if (ret == 0) {
+	if (ret == 0 || ret == -ENOENT) {
 		pr_warning("Specified source line is not found.\n");
 		return -ENOENT;
 	} else if (ret < 0) {
-		pr_warning("Debuginfo analysis failed. (%d)\n", ret);
+		pr_warning("Debuginfo analysis failed.\n");
 		return ret;
 	}
 
@@ -641,7 +641,7 @@ static int __show_line_range(struct line_range *lr, const char *module)
 	ret = get_real_path(tmp, lr->comp_dir, &lr->path);
 	free(tmp);	/* Free old path */
 	if (ret < 0) {
-		pr_warning("Failed to find source file. (%d)\n", ret);
+		pr_warning("Failed to find source file path.\n");
 		return ret;
 	}
 
-- 
1.9.3

