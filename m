Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbaHMWtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:49:20 -0400
Received: from mail.kernel.org ([198.145.19.201]:54958 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528AbaHMWtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:49:17 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Naohiro Aota <naota@elisp.net>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/41] perf probe: Fix --del option to delete events only with uprobe events
Date: Wed, 13 Aug 2014 19:47:54 -0300
Message-Id: <1407970107-24540-9-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Current perf probe --del doesn't work if only CONFIG_UPROBE_EVENTS=y
because it aborts when it fails to open kprobe_events file before
checking uprobe_events file.

This fixes --del option to delete dynamic events if it can open either
kprobe_events or uprobe_events. Only if it failed to open both of them,
it shows an error message and aborts.

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
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Naohiro Aota <naota@elisp.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140813161250.26440.24028.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c | 49 +++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 50aa7f05ceb1..443225cb62f7 100644
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
 
-- 
1.9.3

