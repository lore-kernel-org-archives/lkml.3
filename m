Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab3LZGD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 01:03:56 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:48055 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab3LZGDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 01:03:53 -0500
Subject: [PATCH -tip v2 1/2] [CLEANUP] perf-probe: Expand given path to
 absolute path
To: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, systemtap@sourceware.org,
        yrl.pp-manager.tt@hitachi.com, Namhyung Kim <namhyung@kernel.org>
Date: Thu, 26 Dec 2013 05:41:50 +0000
Message-ID: <20131226054150.22364.12187.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131226054148.22364.25224.stgit@kbuild-fedora.novalocal>
References: <20131226054148.22364.25224.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expand given path to absolute path in the option parser,
except for a module name.

Since realpath at later stage in processing several probe
point, can be called several times(even if currently doesn't,
it can happen when we expands the feature), it is waste of the
performance.
Processing it once at the early stage can avoid that.

Changes from previous one:
 - Fix not to print null string.
 - Allocate memory for given path/module name everytime.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/builtin-probe.c    |   16 +++++++++++++++-
 tools/perf/util/probe-event.c |   11 ++---------
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 6ea9e85..5681266 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -169,6 +169,7 @@ static int opt_set_target(const struct option *opt, const char *str,
 			int unset __maybe_unused)
 {
 	int ret = -ENOENT;
+	char *tmp;
 
 	if  (str && !params.target) {
 		if (!strcmp(opt->long_name, "exec"))
@@ -180,7 +181,20 @@ static int opt_set_target(const struct option *opt, const char *str,
 		else
 			return ret;
 
-		params.target = str;
+		/* Expand given path to absolute path, except for modulename */
+		if (params.uprobes || strchr(str, '/')) {
+			tmp = realpath(str, NULL);
+			if (!tmp) {
+				pr_warning("Failed to find the path of %s.\n",
+					   str);
+				return ret;
+			}
+		} else {
+			tmp = strdup(str);
+			if (!tmp)
+				return -ENOMEM;
+		}
+		params.target = tmp;
 		ret = 0;
 	}
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index d7cff57..05be5de 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2281,7 +2281,7 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
 	struct perf_probe_point *pp = &pev->point;
 	struct symbol *sym;
 	struct map *map = NULL;
-	char *function = NULL, *name = NULL;
+	char *function = NULL;
 	int ret = -EINVAL;
 	unsigned long long vaddr = 0;
 
@@ -2297,12 +2297,7 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
 		goto out;
 	}
 
-	name = realpath(exec, NULL);
-	if (!name) {
-		pr_warning("Cannot find realpath for %s.\n", exec);
-		goto out;
-	}
-	map = dso__new_map(name);
+	map = dso__new_map(exec);
 	if (!map) {
 		pr_warning("Cannot find appropriate DSO for %s.\n", exec);
 		goto out;
@@ -2367,7 +2362,5 @@ out:
 	}
 	if (function)
 		free(function);
-	if (name)
-		free(name);
 	return ret;
 }


