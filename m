Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab3LSJ5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:57:54 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:24838 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab3LSJ4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:56:49 -0500
X-IronPort-AV: E=Sophos;i="4.95,512,1384272000"; 
   d="scan'208";a="9291075"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, eranian@google.com, dsahern@gmail.com,
        adrian.hunter@intel.com, acme@ghostprotocols.net
Cc: mingo@redhat.com, paulus@samba.org, a.p.zijlstra@chello.nl,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/4] perf tools: Add support of guest in synthesize_threads.
Date: Thu, 19 Dec 2013 17:54:51 -0500
Message-Id: <c1922c3cf1b16ae6fc8c009cf7c02db5144ab001.1387493396.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1387493396.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1387493396.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/19 17:56:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/19 17:56:16,
	Serialize complete at 2013/12/19 17:56:16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are using XXX__synthesize_threads() function to synthesize the
symbols of user space for host. This patch add support of guest
for these functions.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/util/event.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 6948768..6e36bbb 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -106,8 +106,12 @@ static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
 
 	memset(&event->comm, 0, sizeof(event->comm));
 
-	tgid = perf_event__get_comm_tgid(pid, event->comm.comm,
-					 sizeof(event->comm.comm));
+	if (machine__is_host(machine))
+		tgid = perf_event__get_comm_tgid(pid, event->comm.comm,
+						 sizeof(event->comm.comm));
+	else
+		tgid = machine->pid;
+
 	if (tgid < 0)
 		goto out;
 
@@ -129,7 +133,11 @@ static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
 		goto out;
 	}
 
-	snprintf(filename, sizeof(filename), "/proc/%d/task", pid);
+	if (machine__is_default_guest(machine))
+		return 0;
+
+	snprintf(filename, sizeof(filename), "%s/proc/%d/task",
+		 machine->root_dir, pid);
 
 	tasks = opendir(filename);
 	if (tasks == NULL) {
@@ -178,7 +186,11 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 	FILE *fp;
 	int rc = 0;
 
-	snprintf(filename, sizeof(filename), "/proc/%d/maps", pid);
+	if (machine__is_default_guest(machine))
+		return 0;
+
+	snprintf(filename, sizeof(filename), "%s/proc/%d/maps",
+		 machine->root_dir, pid);
 
 	fp = fopen(filename, "r");
 	if (fp == NULL) {
@@ -218,7 +230,10 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		/*
 		 * Just like the kernel, see __perf_event_mmap in kernel/perf_event.c
 		 */
-		event->header.misc = PERF_RECORD_MISC_USER;
+		if (machine__is_host(machine))
+			event->header.misc = PERF_RECORD_MISC_USER;
+		else
+			event->header.misc = PERF_RECORD_MISC_GUEST_USER;
 
 		if (prot[2] != 'x') {
 			if (!mmap_data || prot[0] != 'r')
@@ -387,6 +402,7 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 				   struct machine *machine, bool mmap_data)
 {
 	DIR *proc;
+	char proc_path[PATH_MAX];
 	struct dirent dirent, *next;
 	union perf_event *comm_event, *mmap_event;
 	int err = -1;
@@ -399,7 +415,12 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 	if (mmap_event == NULL)
 		goto out_free_comm;
 
-	proc = opendir("/proc");
+	if (machine__is_default_guest(machine))
+		return 0;
+
+	snprintf(proc_path, sizeof(proc_path), "%s/proc", machine->root_dir);
+	proc = opendir(proc_path);
+
 	if (proc == NULL)
 		goto out_free_mmap;
 
-- 
1.8.2.1

