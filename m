Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbaISFXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 01:23:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53065 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaISFXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 01:23:12 -0400
Date: Thu, 18 Sep 2014 22:22:58 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-2b394bc4468c2f5e6814a8dbb2a923c0448f8497@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        dlernerdroid@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        dlernerdroid@gmail.com
In-Reply-To: <20140917084054.3722.73975.stgit@kbuild-f20.novalocal>
References: <20140917084054.3722.73975.stgit@kbuild-f20.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe:
  Do not access kallsyms when analyzing user binaries
Git-Commit-ID: 2b394bc4468c2f5e6814a8dbb2a923c0448f8497
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

Commit-ID:  2b394bc4468c2f5e6814a8dbb2a923c0448f8497
Gitweb:     http://git.kernel.org/tip/2b394bc4468c2f5e6814a8dbb2a923c0448f8497
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Wed, 17 Sep 2014 08:40:54 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Sep 2014 18:01:14 -0300

perf probe: Do not access kallsyms when analyzing user binaries

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
Cc: linux-perf-user@vger.kernel.org
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20140917084054.3722.73975.stgit@kbuild-f20.novalocal
[ Added missing 'bool user' argument to the !DWARF show_line_range() stub ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-probe.c    | 3 ++-
 tools/perf/util/probe-event.c | 9 +++++----
 tools/perf/util/probe-event.h | 3 ++-
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 4d6858d..04412b4 100644
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
index f73595f..be37b5a 100644
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
