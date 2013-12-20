Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab3LTKJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:09:43 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:38032 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247Ab3LTKIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:08:40 -0500
Subject: [PATCH -tip 1/3] [CLEANUP] perf-probe: Expand given path to
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
Date: Fri, 20 Dec 2013 10:02:57 +0000
Message-ID: <20131220100257.7169.60537.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131220100255.7169.19384.stgit@kbuild-fedora.novalocal>
References: <20131220100255.7169.19384.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expand given path to absolute path in option parser,
except for a module name. Instead of expanding it later,
this get the absolute path in early stage.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/builtin-probe.c    |    9 +++++++++
 tools/perf/util/probe-event.c |   11 ++---------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 6ea9e85..b40d064 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -180,6 +180,15 @@ static int opt_set_target(const struct option *opt, const char *str,
 		else
 			return ret;
 
+		/* Expand given path to absolute path, except for modulename */
+		if (params.uprobes || strchr(str, '/')) {
+			str = realpath(str, NULL);
+			if (!str) {
+				pr_warning("Failed to find the path of %s.\n",
+					   str);
+				return ret;
+			}
+		}
 		params.target = str;
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


