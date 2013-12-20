Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab3LTHzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 02:55:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:11489 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754538Ab3LTHzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 02:55:00 -0500
X-IronPort-AV: E=Sophos;i="4.95,519,1384272000"; 
   d="scan'208";a="9296750"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, namhyung.kim@lge.com, jolsa@redhat.com,
        dsahern@gmail.com, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 5/7] perf tools: Do not synthesize the treads of default guest.
Date: Fri, 20 Dec 2013 15:53:00 -0500
Message-Id: <e9ddb5dac6f963169657218b12ceb3c2030f54e8.1387572416.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1387572416.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1387572416.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/20 15:54:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/20 15:54:24,
	Serialize complete at 2013/12/20 15:54:24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the default guest is designed to handle orphan kernel symboles
with --guestkallsysms and --guestmoudles, it has no user space. So we
should skip synthesizing threads if machine is default guest.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/util/event.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 93c6701..598b73e 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -133,6 +133,9 @@ static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
 		goto out;
 	}
 
+	if (machine__is_default_guest(machine))
+		return 0;
+
 	snprintf(filename, sizeof(filename), "%s/proc/%d/task",
 		 machine->root_dir, pid);
 
@@ -183,6 +186,9 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 	FILE *fp;
 	int rc = 0;
 
+	if (machine__is_default_guest(machine))
+		return 0;
+
 	snprintf(filename, sizeof(filename), "%s/proc/%d/maps",
 		 machine->root_dir, pid);
 
@@ -409,6 +415,9 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 	if (mmap_event == NULL)
 		goto out_free_comm;
 
+	if (machine__is_default_guest(machine))
+		return 0;
+
 	snprintf(proc_path, sizeof(proc_path), "%s/proc", machine->root_dir);
 	proc = opendir(proc_path);
 
-- 
1.8.2.1

