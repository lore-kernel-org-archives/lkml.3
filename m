Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaALShZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:37:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45836 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbaALShT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:37:19 -0500
Date: Sun, 12 Jan 2014 10:37:04 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-995634650ef1f907196bd7e9ae45354124a80e47@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung.kim@lge.com, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung.kim@lge.com, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <927b937da9177a079abafe4532fa9c9b60b5c4b7.1387572416.git.yangds.fnst@cn.fujitsu.com>
References: <927b937da9177a079abafe4532fa9c9b60b5c4b7.1387572416.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Find the proc info under machine->
 root_dir.
Git-Commit-ID: 995634650ef1f907196bd7e9ae45354124a80e47
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:37:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  995634650ef1f907196bd7e9ae45354124a80e47
Gitweb:     http://git.kernel.org/tip/995634650ef1f907196bd7e9ae45354124a80e47
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Fri, 20 Dec 2013 15:52:57 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 23 Dec 2013 16:49:49 -0300

perf tools: Find the proc info under machine->root_dir.

When we synthesize the threads, we are looking for the infomation under
/proc. But it is only for host.

This patch look for the path of proc under machine->root_dir, then
XXX__synthesize_threads() functions can support guest machines.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Link: http://lkml.kernel.org/r/927b937da9177a079abafe4532fa9c9b60b5c4b7.1387572416.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 484e994..a61726e 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -129,7 +129,8 @@ static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
 		goto out;
 	}
 
-	snprintf(filename, sizeof(filename), "/proc/%d/task", pid);
+	snprintf(filename, sizeof(filename), "%s/proc/%d/task",
+		 machine->root_dir, pid);
 
 	tasks = opendir(filename);
 	if (tasks == NULL) {
@@ -178,7 +179,8 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 	FILE *fp;
 	int rc = 0;
 
-	snprintf(filename, sizeof(filename), "/proc/%d/maps", pid);
+	snprintf(filename, sizeof(filename), "%s/proc/%d/maps",
+		 machine->root_dir, pid);
 
 	fp = fopen(filename, "r");
 	if (fp == NULL) {
@@ -387,6 +389,7 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 				   struct machine *machine, bool mmap_data)
 {
 	DIR *proc;
+	char proc_path[PATH_MAX];
 	struct dirent dirent, *next;
 	union perf_event *comm_event, *mmap_event;
 	int err = -1;
@@ -399,7 +402,9 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 	if (mmap_event == NULL)
 		goto out_free_comm;
 
-	proc = opendir("/proc");
+	snprintf(proc_path, sizeof(proc_path), "%s/proc", machine->root_dir);
+	proc = opendir(proc_path);
+
 	if (proc == NULL)
 		goto out_free_mmap;
 
