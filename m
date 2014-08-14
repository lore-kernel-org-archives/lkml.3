Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaHNIpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:45:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36258 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaHNIoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:44:55 -0400
Date: Thu, 14 Aug 2014 01:44:01 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-5e45187cc94814d2a5324bc18af994efc4fb4f7c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, naota@elisp.net,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        naota@elisp.net, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
In-Reply-To: <20140813161248.26440.84370.stgit@kbuild-fedora.novalocal>
References: <20140813161248.26440.84370.stgit@kbuild-fedora.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe:
  Fix --list option to show events only with uprobe events
Git-Commit-ID: 5e45187cc94814d2a5324bc18af994efc4fb4f7c
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

Commit-ID:  5e45187cc94814d2a5324bc18af994efc4fb4f7c
Gitweb:     http://git.kernel.org/tip/5e45187cc94814d2a5324bc18af994efc4fb4f7c
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Wed, 13 Aug 2014 16:12:48 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 15:53:35 -0300

perf probe: Fix --list option to show events only with uprobe events

Current perf probe --list doesn't work if only CONFIG_UPROBE_EVENTS=y
because it aborts when it fails to open kprobe_events file before
checking uprobe_events file.

This fixes --list option to show dynamic events if it can open either
kprobe_events or uprobe_events. Only if it failed to open both of them,
it shows an error message and aborts.

Without this patch, if we run perf probe -l on the kernel configured
with CONFIG_KPROBE_EVENTS=n and CONFIG_UPROBE_EVENTS=y,

  # perf probe -l
  /sys/kernel/debug/tracing/kprobe_events file does not exist - please rebuild ker
    Error: Failed to show event list.

With this patch,

  # perf probe -l
    probe_perf:alloc_event (on alloc_event@lib/traceevent/event-parse.c in /home/fedora/ksrc/linux-3/tools/perf/perf)

Changes in v2:
 - Use strerror_r instead of strerror.

Reported-by: Naohiro Aota <naota@elisp.net>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Naohiro Aota <naota@elisp.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140813161248.26440.84370.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c | 89 ++++++++++++++++++++++++++++---------------
 1 file changed, 59 insertions(+), 30 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 9a0a183..50aa7f0 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1780,10 +1780,11 @@ static void clear_probe_trace_event(struct probe_trace_event *tev)
 	memset(tev, 0, sizeof(*tev));
 }
 
-static void print_warn_msg(const char *file, bool is_kprobe)
+static void print_open_warning(int err, bool is_kprobe)
 {
+	char sbuf[128];
 
-	if (errno == ENOENT) {
+	if (err == -ENOENT) {
 		const char *config;
 
 		if (!is_kprobe)
@@ -1791,25 +1792,26 @@ static void print_warn_msg(const char *file, bool is_kprobe)
 		else
 			config = "CONFIG_KPROBE_EVENTS";
 
-		pr_warning("%s file does not exist - please rebuild kernel"
-				" with %s.\n", file, config);
-	} else
-		pr_warning("Failed to open %s file: %s\n", file,
-				strerror(errno));
+		pr_warning("%cprobe_events file does not exist"
+			   " - please rebuild kernel with %s.\n",
+			   is_kprobe ? 'k' : 'u', config);
+	} else if (err == -ENOTSUP)
+		pr_warning("Debugfs is not mounted.\n");
+	else
+		pr_warning("Failed to open %cprobe_events: %s\n",
+			   is_kprobe ? 'k' : 'u',
+			   strerror_r(-err, sbuf, sizeof(sbuf)));
 }
 
-static int open_probe_events(const char *trace_file, bool readwrite,
-				bool is_kprobe)
+static int open_probe_events(const char *trace_file, bool readwrite)
 {
 	char buf[PATH_MAX];
 	const char *__debugfs;
 	int ret;
 
 	__debugfs = debugfs_find_mountpoint();
-	if (__debugfs == NULL) {
-		pr_warning("Debugfs is not mounted.\n");
-		return -ENOENT;
-	}
+	if (__debugfs == NULL)
+		return -ENOTSUP;
 
 	ret = e_snprintf(buf, PATH_MAX, "%s/%s", __debugfs, trace_file);
 	if (ret >= 0) {
@@ -1820,19 +1822,19 @@ static int open_probe_events(const char *trace_file, bool readwrite,
 			ret = open(buf, O_RDONLY, 0);
 
 		if (ret < 0)
-			print_warn_msg(buf, is_kprobe);
+			ret = -errno;
 	}
 	return ret;
 }
 
 static int open_kprobe_events(bool readwrite)
 {
-	return open_probe_events("tracing/kprobe_events", readwrite, true);
+	return open_probe_events("tracing/kprobe_events", readwrite);
 }
 
 static int open_uprobe_events(bool readwrite)
 {
-	return open_probe_events("tracing/uprobe_events", readwrite, false);
+	return open_probe_events("tracing/uprobe_events", readwrite);
 }
 
 /* Get raw string list of current kprobe_events  or uprobe_events */
@@ -1940,27 +1942,47 @@ static int __show_perf_probe_events(int fd, bool is_kprobe)
 /* List up current perf-probe events */
 int show_perf_probe_events(void)
 {
-	int fd, ret;
+	int kp_fd, up_fd, ret;
 
 	setup_pager();
-	fd = open_kprobe_events(false);
-
-	if (fd < 0)
-		return fd;
 
 	ret = init_symbol_maps(false);
 	if (ret < 0)
 		return ret;
 
-	ret = __show_perf_probe_events(fd, true);
-	close(fd);
+	kp_fd = open_kprobe_events(false);
+	if (kp_fd >= 0) {
+		ret = __show_perf_probe_events(kp_fd, true);
+		close(kp_fd);
+		if (ret < 0)
+			goto out;
+	}
 
-	fd = open_uprobe_events(false);
-	if (fd >= 0) {
-		ret = __show_perf_probe_events(fd, false);
-		close(fd);
+	up_fd = open_uprobe_events(false);
+	if (kp_fd < 0 && up_fd < 0) {
+		/* Both kprobes and uprobes are disabled, warn it. */
+		if (kp_fd == -ENOTSUP && up_fd == -ENOTSUP)
+			pr_warning("Debugfs is not mounted.\n");
+		else if (kp_fd == -ENOENT && up_fd == -ENOENT)
+			pr_warning("Please rebuild kernel with "
+				   "CONFIG_KPROBE_EVENTS or/and "
+				   "CONFIG_UPROBE_EVENTS.\n");
+		else {
+			char sbuf[128];
+			pr_warning("Failed to open kprobe events: %s.\n",
+				   strerror_r(-kp_fd, sbuf, sizeof(sbuf)));
+			pr_warning("Failed to open uprobe events: %s.\n",
+				   strerror_r(-up_fd, sbuf, sizeof(sbuf)));
+		}
+		ret = kp_fd;
+		goto out;
 	}
 
+	if (up_fd >= 0) {
+		ret = __show_perf_probe_events(up_fd, false);
+		close(up_fd);
+	}
+out:
 	exit_symbol_maps();
 	return ret;
 }
@@ -2075,8 +2097,11 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 	else
 		fd = open_kprobe_events(true);
 
-	if (fd < 0)
+	if (fd < 0) {
+		print_open_warning(fd, !pev->uprobes);
 		return fd;
+	}
+
 	/* Get current event names */
 	namelist = get_probe_trace_event_names(fd, false);
 	if (!namelist) {
@@ -2449,13 +2474,17 @@ int del_perf_probe_events(struct strlist *dellist)
 
 	/* Get current event names */
 	kfd = open_kprobe_events(true);
-	if (kfd < 0)
+	if (kfd < 0) {
+		print_open_warning(kfd, true);
 		return kfd;
+	}
 
 	namelist = get_probe_trace_event_names(kfd, true);
 	ufd = open_uprobe_events(true);
 
-	if (ufd >= 0)
+	if (ufd < 0)
+		print_open_warning(ufd, false);
+	else
 		unamelist = get_probe_trace_event_names(ufd, true);
 
 	if (namelist == NULL && unamelist == NULL)
