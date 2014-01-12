Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaALShn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:37:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45863 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbaALShh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:37:37 -0500
Date: Sun, 12 Jan 2014 10:37:23 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-f5db57c4c47f3985dfc677152e25636a3401fa13@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung.kim@lge.com, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung.kim@lge.com, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <22455abe107c618a361e7b667ad0f098f7c9b4a3.1387572416.git.yangds.fnst@cn.fujitsu.com>
References: <22455abe107c618a361e7b667ad0f098f7c9b4a3.1387572416.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Use machine->
 pid for tgid if machine is guest.
Git-Commit-ID: f5db57c4c47f3985dfc677152e25636a3401fa13
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:37:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5db57c4c47f3985dfc677152e25636a3401fa13
Gitweb:     http://git.kernel.org/tip/f5db57c4c47f3985dfc677152e25636a3401fa13
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Fri, 20 Dec 2013 15:52:59 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 23 Dec 2013 16:49:50 -0300

perf tools: Use machine->pid for tgid if machine is guest.

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
index 07c0783..2905771 100644
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
 
