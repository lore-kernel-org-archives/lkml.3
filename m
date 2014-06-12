Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964921AbaFLMFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:05:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60687 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964870AbaFLMFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:05:04 -0400
Date: Thu, 12 Jun 2014 05:04:46 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-5ee05b8801892ecc5df44e03429008dfa89aa361@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
In-Reply-To: <20140606071406.6788.47850.stgit@kbuild-fedora.novalocal>
References: <20140606071406.6788.47850.stgit@kbuild-fedora.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe:
  Improve error messages in --line option
Git-Commit-ID: 5ee05b8801892ecc5df44e03429008dfa89aa361
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

Commit-ID:  5ee05b8801892ecc5df44e03429008dfa89aa361
Gitweb:     http://git.kernel.org/tip/5ee05b8801892ecc5df44e03429008dfa89aa361
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 6 Jun 2014 07:14:06 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 10 Jun 2014 10:02:06 -0300

perf probe: Improve error messages in --line option

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
 
