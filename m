Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbaHMAvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 20:51:20 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51315 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbaHMAvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 20:51:01 -0400
X-AuditID: 85900ec0-d452db9000001514-00-53eab672efe2
Subject: [PATCH 2/2] [BUGFIX] perf probe: Fix --del option to delete events
 only with uprobe events
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 13 Aug 2014 00:50:57 +0000
Message-ID: <20140813005057.24360.34033.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140813005055.24360.73553.stgit@kbuild-fedora.novalocal>
References: <20140813005055.24360.73553.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current perf probe --del doesn't work if only CONFIG_UPROBE_EVENTS=y
because it aborts when it fails to open kprobe_events file before
checking uprobe_events file.

This fixes --del option to delete dynamic events if it can open
either kprobe_events or uprobe_events. Only if it failed to open
both of them, it shows an error message and aborts.

Without this patch, if we run perf probe -d on the kernel configured
with CONFIG_KPROBE_EVENTS=n and CONFIG_UPROBE_EVENTS=y,

  # perf probe -d \*
  kprobe_events file does not exist - please rebuild kernel with CONFIG_KPROBE_EVENTS.
    Error: Failed to delete events.

With this patch,

  # perf probe -d \*
  Removed event: probe_perf:alloc_event

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
---
 tools/perf/util/probe-event.c |   43 ++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index b4f6555..03108f6 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1801,6 +1801,20 @@ static void print_open_warning(int err, bool is_kprobe)
 			   is_kprobe ? 'k' : 'u', strerror(-err));
 }
 
+static void print_both_open_warning(int kerr, int uerr)
+{
+	/* Both kprobes and uprobes are disabled, warn it. */
+	if (kerr == -ENOTSUP && uerr == -ENOTSUP)
+		pr_warning("Debugfs is not mounted.\n");
+	else if (kerr == -ENOENT && uerr == -ENOENT)
+		pr_warning("Please rebuild kernel with CONFIG_KPROBE_EVENTS "
+			   "or/and CONFIG_UPROBE_EVENTS.\n");
+	else
+		pr_warning("Failed to open kprobe events: %s.\n" \
+			   "Failed to open uprobe events: %s.\n",
+			   strerror(-kerr), strerror(-uerr));
+}
+
 static int open_probe_events(const char *trace_file, bool readwrite)
 {
 	char buf[PATH_MAX];
@@ -1958,17 +1972,7 @@ int show_perf_probe_events(void)
 
 	up_fd = open_uprobe_events(false);
 	if (kp_fd < 0 && up_fd < 0) {
-		/* Both kprobes and uprobes are disabled, warn it. */
-		if (kp_fd == -ENOTSUP && up_fd == -ENOTSUP)
-			pr_warning("Debugfs is not mounted.\n");
-		else if (kp_fd == -ENOENT && up_fd == -ENOENT)
-			pr_warning("Please rebuild kernel with "
-				   "CONFIG_KPROBE_EVENTS or/and "
-				   "CONFIG_UPROBE_EVENTS.\n");
-		else
-			pr_warning("Failed to open kprobe events: %s.\n" \
-				   "Failed to open uprobe events: %s.\n",
-				   strerror(-kp_fd), strerror(-up_fd));
+		print_both_open_warning(kp_fd, up_fd);
 		ret = kp_fd;
 		goto out;
 	}
@@ -2469,19 +2473,18 @@ int del_perf_probe_events(struct strlist *dellist)
 
 	/* Get current event names */
 	kfd = open_kprobe_events(true);
-	if (kfd < 0) {
-		print_open_warning(kfd, true);
-		return kfd;
-	}
+	if (kfd >= 0)
+		namelist = get_probe_trace_event_names(kfd, true);
 
-	namelist = get_probe_trace_event_names(kfd, true);
 	ufd = open_uprobe_events(true);
-
-	if (ufd < 0)
-		print_open_warning(ufd, false);
-	else
+	if (ufd >= 0)
 		unamelist = get_probe_trace_event_names(ufd, true);
 
+	if (kfd < 0 && ufd < 0) {
+		print_both_open_warning(kfd, ufd);
+		goto error;
+	}
+
 	if (namelist == NULL && unamelist == NULL)
 		goto error;
 

