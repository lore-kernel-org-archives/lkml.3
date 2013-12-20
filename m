Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab3LTHzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 02:55:54 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54386 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754506Ab3LTHzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 02:55:00 -0500
X-IronPort-AV: E=Sophos;i="4.95,519,1384272000"; 
   d="scan'208";a="9296748"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, namhyung.kim@lge.com, jolsa@redhat.com,
        dsahern@gmail.com, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 4/7] perf tools: Use machine->pid for tgid if mahicne is guest.
Date: Fri, 20 Dec 2013 15:52:59 -0500
Message-Id: <22455abe107c618a361e7b667ad0f098f7c9b4a3.1387572416.git.yangds.fnst@cn.fujitsu.com>
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

When we synthesize an comm event, if machine is guest, we should
use the pid of machine as the event->comm.pid, rather than tgid
of thread.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/util/event.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 2d90ed8..93c6701 100644
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
 
-- 
1.8.2.1

