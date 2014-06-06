Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbaFFHOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:14:18 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58969 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbaFFHOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:14:15 -0400
Subject: [PATCH -tip 4/4] perf/probe: Improve error messages with --line
 option
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Date: Fri, 06 Jun 2014 07:14:06 +0000
Message-ID: <20140606071406.6788.47850.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140606071338.6788.799.stgit@kbuild-fedora.novalocal>
References: <20140606071338.6788.799.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve error messages of perf probe --line mode. Current
perf probe shows "Debuginfo analysis failed" error with an
error code when the given symbol is not found as below.

  -----
  # perf probe -L page_cgroup_init_flatmem
  Debuginfo analysis failed. (-2)
    Error: Failed to show lines.
  -----

But -2 (-ENOMEM) means that the given source line or function
is not found. With this patch, perf probe shows correct error
message as below.

  -----
  # perf probe -L page_cgroup_init_flatmem
  Specified source line is not found.
    Error: Failed to show lines.
  -----

There is also another debug error code is shown in the same
function after get_real_path(). This removes that too.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
---
 tools/perf/util/probe-event.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 44c7141..9a0a183 100644
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
 


