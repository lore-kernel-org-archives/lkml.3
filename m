Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab3L0UrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 15:47:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35680 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab3L0UrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 15:47:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 39/49] perf tools: Use machine->pid for tgid if machine is guest.
Date: Fri, 27 Dec 2013 17:46:55 -0300
Message-Id: <1388177225-17349-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1388177225-17349-1-git-send-email-acme@infradead.org>
References: <1388177225-17349-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

When we synthesize an comm event, if machine is guest, we should
use the pid of machine as the event->comm.pid, rather than tgid
of thread.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Link: http://lkml.kernel.org/r/22455abe107c618a361e7b667ad0f098f7c9b4a3.1387572416.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 07c07833de53..2905771a1f49 100644
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
1.8.1.4

