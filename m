Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab3JOFoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:44:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33134 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758313Ab3JOF0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:26:07 -0400
Date: Mon, 14 Oct 2013 22:25:30 -0700
From: tip-bot for Willy Tarreau <tipbot@zytor.com>
Message-ID: <tip-fc2be6968e99b5314f20e938a547d44dcb1c40eb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        hpa@zytor.com, mingo@kernel.org, w@1wt.eu, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, w@1wt.eu,
        tglx@linutronix.de
In-Reply-To: <20130914083259.GA3418@1wt.eu>
References: <20130914083259.GA3418@1wt.eu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Add new option --ignore-vmlinux for perf top
Git-Commit-ID: fc2be6968e99b5314f20e938a547d44dcb1c40eb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:25:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc2be6968e99b5314f20e938a547d44dcb1c40eb
Gitweb:     http://git.kernel.org/tip/fc2be6968e99b5314f20e938a547d44dcb1c40eb
Author:     Willy Tarreau <w@1wt.eu>
AuthorDate: Sat, 14 Sep 2013 10:32:59 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:42:20 -0300

perf symbols: Add new option --ignore-vmlinux for perf top

Running "perf top" on a machine with possibly invalid or non-matching
vmlinux at the various places results in no symbol resolving despite
/proc/kallsyms being present and valid.

Add a new option --ignore-vmlinux to explicitly indicate that we do not
want to use these kernels and just use what we have (kallsyms).

Signed-off-by: Willy Tarreau <w@1wt.eu>
Cc: Ingo Molnar <mingo@redhat.com>
Link: http://lkml.kernel.org/r/20130914083259.GA3418@1wt.eu
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c | 2 ++
 tools/perf/util/symbol.c | 4 ++--
 tools/perf/util/symbol.h | 1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e846695..65c49b2 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1073,6 +1073,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "list of cpus to monitor"),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
+	OPT_BOOLEAN(0, "ignore-vmlinux", &symbol_conf.ignore_vmlinux,
+		    "don't load vmlinux even if found"),
 	OPT_BOOLEAN('K', "hide_kernel_symbols", &top.hide_kernel_symbols,
 		    "hide kernel symbols"),
 	OPT_CALLBACK('m', "mmap-pages", &opts->mmap_pages, "pages",
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index cd1dcc4..48c3879 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1215,7 +1215,7 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 		goto do_kallsyms;
 	}
 
-	if (symbol_conf.vmlinux_name != NULL) {
+	if (!symbol_conf.ignore_vmlinux && symbol_conf.vmlinux_name != NULL) {
 		err = dso__load_vmlinux(dso, map,
 					symbol_conf.vmlinux_name, filter);
 		if (err > 0) {
@@ -1227,7 +1227,7 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 		return err;
 	}
 
-	if (vmlinux_path != NULL) {
+	if (!symbol_conf.ignore_vmlinux && vmlinux_path != NULL) {
 		err = dso__load_vmlinux_path(dso, map, filter);
 		if (err > 0)
 			return err;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 2a97bb1..9b8b213 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -85,6 +85,7 @@ struct symbol_conf {
 	unsigned short	priv_size;
 	unsigned short	nr_events;
 	bool		try_vmlinux_path,
+			ignore_vmlinux,
 			show_kernel_path,
 			use_modules,
 			sort_by_name,
