Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbaHNIpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:45:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36285 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaHNIpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:45:16 -0400
Date: Thu, 14 Aug 2014 01:44:15 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-467ec08567483e3868f240b1ee03808970e06388@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, naota@elisp.net,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        naota@elisp.net, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
In-Reply-To: <20140813161250.26440.24028.stgit@kbuild-fedora.novalocal>
References: <20140813161250.26440.24028.stgit@kbuild-fedora.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe:
  Fix --del option to delete events only with uprobe events
Git-Commit-ID: 467ec08567483e3868f240b1ee03808970e06388
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

Commit-ID:  467ec08567483e3868f240b1ee03808970e06388
Gitweb:     http://git.kernel.org/tip/467ec08567483e3868f240b1ee03808970e06388
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Wed, 13 Aug 2014 16:12:50 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 15:54:11 -0300

perf probe: Fix --del option to delete events only with uprobe events

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
 
