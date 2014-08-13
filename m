Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbaHMQMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 12:12:55 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:55199 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaHMQMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:12:53 -0400
X-AuditID: 85900ec0-d1328b9000001514-81-53eb8e832d64
Subject: [PATCH v2 2/2] [BUGFIX] perf probe: Fix --del option to delete
 events only with uprobe events
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 13 Aug 2014 16:12:50 +0000
Message-ID: <20140813161250.26440.24028.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140813161248.26440.84370.stgit@kbuild-fedora.novalocal>
References: <20140813161248.26440.84370.stgit@kbuild-fedora.novalocal>
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

Changes in v2:
 - Use strerror_r instead of strerror.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
---
 tools/perf/util/probe-event.c |   49 ++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 50aa7f0..443225c 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1803,6 +1803,23 @@ static void print_open_warning(int err, bool is_kprobe)
 			   strerror_r(-err, sbuf, sizeof(sbuf)));
 }
 
+static void print_both_open_warning(int kerr, int uerr)
+{
+	/* Both kprobes and uprobes are disabled, warn it. */
+	if (kerr == -ENOTSUP && uerr == -ENOTSUP)
+		pr_warning("Debugfs is not mounted.\n");
+	else if (kerr == -ENOENT && uerr == -ENOENT)
+		pr_warning("Please rebuild kernel with CONFIG_KPROBE_EVENTS "
+			   "or/and CONFIG_UPROBE_EVENTS.\n");
+	else {
+		char sbuf[128];
+		pr_warning("Failed to open kprobe events: %s.\n",
+			   strerror_r(-kerr, sbuf, sizeof(sbuf)));
+		pr_warning("Failed to open uprobe events: %s.\n",
+			   strerror_r(-uerr, sbuf, sizeof(sbuf)));
+	}
+}
+
 static int open_probe_events(const char *trace_file, bool readwrite)
 {
 	char buf[PATH_MAX];
@@ -1960,20 +1977,7 @@ int show_perf_probe_events(void)
 
 	up_fd = open_uprobe_events(false);
 	if (kp_fd < 0 && up_fd < 0) {
-		/* Both kprobes and uprobes are disabled, warn it. */
-		if (kp_fd == -ENOTSUP && up_fd == -ENOTSUP)
-			pr_warning("Debugfs is not mounted.\n");
-		else if (kp_fd == -ENOENT && up_fd == -ENOENT)
-			pr_warning("Please rebuild kernel with "
-				   "CONFIG_KPROBE_EVENTS or/and "
-				   "CONFIG_UPROBE_EVENTS.\n");
-		else {
-			char sbuf[128];
-			pr_warning("Failed to open kprobe events: %s.\n",
-				   strerror_r(-kp_fd, sbuf, sizeof(sbuf)));
-			pr_warning("Failed to open uprobe events: %s.\n",
-				   strerror_r(-up_fd, sbuf, sizeof(sbuf)));
-		}
+		print_both_open_warning(kp_fd, up_fd);
 		ret = kp_fd;
 		goto out;
 	}
@@ -2474,19 +2478,18 @@ int del_perf_probe_events(struct strlist *dellist)
 
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
 

