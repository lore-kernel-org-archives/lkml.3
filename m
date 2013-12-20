Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab3LTHzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 02:55:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54386 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754347Ab3LTHy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 02:54:59 -0500
X-IronPort-AV: E=Sophos;i="4.95,519,1384272000"; 
   d="scan'208";a="9296744"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, namhyung.kim@lge.com, jolsa@redhat.com,
        dsahern@gmail.com, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 2/7] perf tools: Find the proc info under machine->root_dir.
Date: Fri, 20 Dec 2013 15:52:57 -0500
Message-Id: <927b937da9177a079abafe4532fa9c9b60b5c4b7.1387572416.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1387572416.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1387572416.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/20 15:54:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/20 15:54:23,
	Serialize complete at 2013/12/20 15:54:23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we synthesize the threads, we are looking for the infomation
under /proc. But it is only for host.

This patch look for the path of proc under machine->root_dir, then
XXX__synthesize_threads() functions can support guest machines.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/util/event.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 44992ed..c75046f 100644
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
 
-- 
1.8.2.1

