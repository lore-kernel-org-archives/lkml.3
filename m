Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab3GBTld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 15:41:33 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:52958 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab3GBT1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 15:27:39 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 3/6] perf event: initialize allocated memory for synthesized events
Date: Tue,  2 Jul 2013 13:27:22 -0600
Message-Id: <1372793245-4136-4-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1372793245-4136-1-git-send-email-dsahern@gmail.com>
References: <1372793245-4136-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes valgrind complaint:

=3118== Syscall param write(buf) points to uninitialised byte(s)
==3118==    at 0x4E3F5B0: __write_nocancel (in /lib64/libpthread-2.14.90.so)
==3118==    by 0x42F0EB: process_synthesized_event (builtin-record.c:89)
==3118==    by 0x44E81C: perf_event__synthesize_mmap_events (event.c:230)
==3118==    by 0x44F27C: perf_event__synthesize_threads (event.c:307)
==3118==    by 0x42FEEA: cmd_record (builtin-record.c:530)
==3118==    by 0x419D22: run_builtin (perf.c:319)
==3118==    by 0x4195A2: main (perf.c:376)

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/event.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 5cd13d7..556b999 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -316,11 +316,11 @@ int perf_event__synthesize_thread_map(struct perf_tool *tool,
 	union perf_event *comm_event, *mmap_event;
 	int err = -1, thread, j;
 
-	comm_event = malloc(sizeof(comm_event->comm) + machine->id_hdr_size);
+	comm_event = zalloc(sizeof(comm_event->comm) + machine->id_hdr_size);
 	if (comm_event == NULL)
 		goto out;
 
-	mmap_event = malloc(sizeof(mmap_event->mmap) + machine->id_hdr_size);
+	mmap_event = zalloc(sizeof(mmap_event->mmap) + machine->id_hdr_size);
 	if (mmap_event == NULL)
 		goto out_free_comm;
 
@@ -375,11 +375,11 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 	union perf_event *comm_event, *mmap_event;
 	int err = -1;
 
-	comm_event = malloc(sizeof(comm_event->comm) + machine->id_hdr_size);
+	comm_event = zalloc(sizeof(comm_event->comm) + machine->id_hdr_size);
 	if (comm_event == NULL)
 		goto out;
 
-	mmap_event = malloc(sizeof(mmap_event->mmap) + machine->id_hdr_size);
+	mmap_event = zalloc(sizeof(mmap_event->mmap) + machine->id_hdr_size);
 	if (mmap_event == NULL)
 		goto out_free_comm;
 
-- 
1.7.10.1

