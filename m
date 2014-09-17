Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbaIQIlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:41:07 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:55166 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbaIQIlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:41:04 -0400
Subject: [PATCH perf/core 1/2] perf probe: Do not access kallsyms when
 analyzing user binaries
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-perf-user@vger.kernel.org, david lerner <dlernerdroid@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, yrl.pp-manager.tt@hitachi.com
Date: Wed, 17 Sep 2014 08:40:54 +0000
Message-ID: <20140917084054.3722.73975.stgit@kbuild-f20.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not access kallsyms to show available variables and
show source lines in user binaries.
This behavior always requires the root privilege when
sysctl sets kernel.kptr_restrict=1, but we don't need
it just for analyzing user binaries.

Without this patch (by normal user, kptr_restrict=1):
  ----
  $ perf probe -x ./perf -V add_cmdname
  Failed to init vmlinux path.
    Error: Failed to show vars.
  $ perf probe -x ./perf -L add_cmdname
  Failed to init vmlinux path.
    Error: Failed to show lines.
  ----

With this patch:
  ----
  $ perf probe -x ./perf -V add_cmdname
  Available variables at add_cmdname
          @<perf_unknown_cmd_config+144>
                  (No matched variables)
          @<list_commands_in_dir+160>
                  (No matched variables)
          @<add_cmdname+0>
                  char*   name
                  size_t  len
                  struct cmdnames*        cmds
  $ perf probe -x ./perf -L add_cmdname
  <add_cmdname@/home/fedora/ksrc/linux-3/tools/perf/util/help.c:0>
        0  void add_cmdname(struct cmdnames *cmds, const char *name, size_t len)
        1  {
        2         struct cmdname *ent = malloc(sizeof(*ent) + len + 1);

        4         ent->len = len;
        5         memcpy(ent->name, name, len);
        6         ent->name[len] = 0;
  ...
  ----

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/builtin-probe.c    |    3 ++-
 tools/perf/util/probe-event.c |    6 +++---
 tools/perf/util/probe-event.h |    3 ++-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 347729e..a9b82c4b 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -470,7 +470,8 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 			usage_with_options(probe_usage, options);
 		}
 
-		ret = show_line_range(&params.line_range, params.target);
+		ret = show_line_range(&params.line_range, params.target,
+				      params.uprobes);
 		if (ret < 0)
 			pr_err_with_code("  Error: Failed to show lines.", ret);
 		return ret;
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index f73595f..041e63c 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -697,11 +697,11 @@ end:
 	return ret;
 }
 
-int show_line_range(struct line_range *lr, const char *module)
+int show_line_range(struct line_range *lr, const char *module, bool user)
 {
 	int ret;
 
-	ret = init_symbol_maps(false);
+	ret = init_symbol_maps(user);
 	if (ret < 0)
 		return ret;
 	ret = __show_line_range(lr, module);
@@ -776,7 +776,7 @@ int show_available_vars(struct perf_probe_event *pevs, int npevs,
 	int i, ret = 0;
 	struct debuginfo *dinfo;
 
-	ret = init_symbol_maps(false);
+	ret = init_symbol_maps(pevs->uprobes);
 	if (ret < 0)
 		return ret;
 
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 776c934..e01e994 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -128,7 +128,8 @@ extern int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 				 bool force_add);
 extern int del_perf_probe_events(struct strlist *dellist);
 extern int show_perf_probe_events(void);
-extern int show_line_range(struct line_range *lr, const char *module);
+extern int show_line_range(struct line_range *lr, const char *module,
+			   bool user);
 extern int show_available_vars(struct perf_probe_event *pevs, int npevs,
 			       int max_probe_points, const char *module,
 			       struct strfilter *filter, bool externs);


