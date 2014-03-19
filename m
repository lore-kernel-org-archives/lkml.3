Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934080AbaCSNH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:07:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34219 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933804AbaCSNHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:07:48 -0400
Date: Wed, 19 Mar 2014 06:07:35 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-574799bfdbc3a13e0b5e2f6af34b761bde743a9a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jmario@redhat.com, namhyung@kernel.org,
        jolsa@redhat.com, tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jmario@redhat.com, namhyung@kernel.org,
        jolsa@redhat.com, tglx@linutronix.de, dzickus@redhat.com
In-Reply-To: <87ob15tx6a.fsf@sejong.aot.lge.com>
References: <87ob15tx6a.fsf@sejong.aot.lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix memory leak when synthesizing thread records
Git-Commit-ID: 574799bfdbc3a13e0b5e2f6af34b761bde743a9a
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

Commit-ID:  574799bfdbc3a13e0b5e2f6af34b761bde743a9a
Gitweb:     http://git.kernel.org/tip/574799bfdbc3a13e0b5e2f6af34b761bde743a9a
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 17 Mar 2014 10:45:49 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Mar 2014 18:17:01 -0300

perf tools: Fix memory leak when synthesizing thread records

Checking default guest machine should be done before allocating event
structures otherwise it'll leak memory.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Joe Mario <jmario@redhat.com>
Link: http://lkml.kernel.org/r/87ob15tx6a.fsf@sejong.aot.lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index ebb48a6..9d12aa6 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -446,6 +446,9 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 	union perf_event *comm_event, *mmap_event, *fork_event;
 	int err = -1;
 
+	if (machine__is_default_guest(machine))
+		return 0;
+
 	comm_event = malloc(sizeof(comm_event->comm) + machine->id_hdr_size);
 	if (comm_event == NULL)
 		goto out;
@@ -458,9 +461,6 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 	if (fork_event == NULL)
 		goto out_free_mmap;
 
-	if (machine__is_default_guest(machine))
-		return 0;
-
 	snprintf(proc_path, sizeof(proc_path), "%s/proc", machine->root_dir);
 	proc = opendir(proc_path);
 
