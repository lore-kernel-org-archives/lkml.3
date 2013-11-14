Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab3KNUZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:25:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36291 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757Ab3KNUZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:25:24 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Bill Gray <bgray@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Joe Mario <jmario@redhat.com>, Richard Fowles <rfowles@redhat.com>,
        Stephane Eranian <eranian@google.com>, stable@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/10] perf tools: Synthesize anon MMAP records again
Date: Thu, 14 Nov 2013 17:25:09 -0300
Message-Id: <1384460715-23198-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384460715-23198-1-git-send-email-acme@infradead.org>
References: <1384460715-23198-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Zickus <dzickus@redhat.com>

When introducing the PERF_RECORD_MMAP2 in:

5c5e854bc760 perf tools: Add attr->mmap2 support

A check for the number of entries parsed by sscanf was introduced that
assumed all of the 8 fields needed to be correctly parsed so that
particular /proc/pid/maps line would be considered synthesizable.

That broke anon records synthesizing, as it doesn't have the 'execname'
field.

Fix it by keeping the sscanf return check, changing it to not require
that the 'execname' variable be parsed, so that the preexisting logic
can kick in and set it to '//anon'.

This should get things like JIT profiling working again.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Bill Gray <bgray@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Joe Mario <jmario@redhat.com>
Cc: Richard Fowles <rfowles@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/n/tip-bo4akalno7579shpz29u867j@git.kernel.org
[ commit log message is mine, dzickus reported the problem with a patch ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 6e3a846aed0e..bb788c109fe6 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -209,8 +209,10 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		       &event->mmap.start, &event->mmap.len, prot,
 		       &event->mmap.pgoff,
 		       execname);
-
-		if (n != 5)
+		/*
+ 		 * Anon maps don't have the execname.
+ 		 */
+		if (n < 4)
 			continue;
 		/*
 		 * Just like the kernel, see __perf_event_mmap in kernel/perf_event.c
-- 
1.8.1.4

