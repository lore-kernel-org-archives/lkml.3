Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbaIQV0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:26:31 -0400
Received: from mail.kernel.org ([198.145.19.201]:58290 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932235AbaIQVZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:25:46 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        david lerner <dlernerdroid@gmail.com>,
        linux-perf-users@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 18/20] perf probe: Do not access kallsyms when analyzing user binaries
Date: Wed, 17 Sep 2014 18:24:21 -0300
Message-Id: <1410989063-14207-19-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410989063-14207-1-git-send-email-acme@kernel.org>
References: <1410989063-14207-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Do not access kallsyms to show available variables and show source lines
in user binaries.

This behavior always requires the root privilege when sysctl sets
kernel.kptr_restrict=1, but we don't need it just for analyzing user
binaries.

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
Cc: david lerner <dlernerdroid@gmail.com>
Cc: linux-perf-users@vger.kernel.org
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20140917084054.3722.73975.stgit@kbuild-f20.novalocal
[ Added missing 'bool user' argument to the !DWARF show_line_range() stub ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-probe.c    | 3 ++-
 tools/perf/util/probe-event.c | 9 +++++----
 tools/perf/util/probe-event.h | 3 ++-
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 4d6858dbebea..04412b4770a2 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -472,7 +472,8 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 			usage_with_options(probe_usage, options);
 		}
 
-		ret = show_line_range(&params.line_range, params.target);
+		ret = show_line_range(&params.line_range, params.target,
+				      params.uprobes);
 		if (ret < 0)
 			pr_err_with_code("  Error: Failed to show lines.", ret);
 		return ret;
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index f73595fc0627..be37b5aca335 100644
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
 
@@ -822,7 +822,8 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 }
 
 int show_line_range(struct line_range *lr __maybe_unused,
-		    const char *module __maybe_unused)
+		    const char *module __maybe_unused,
+		    bool user __maybe_unused)
 {
 	pr_warning("Debuginfo-analysis is not supported.\n");
 	return -ENOSYS;
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 776c9347a3b6..e01e9943139f 100644
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
-- 
1.9.3

