Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933337Ab3HGVL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:11:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46905 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933170Ab3HGVLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:11:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/47] perf evsel: Actually show symbol offset in stack trace when requested
Date: Wed,  7 Aug 2013 18:10:38 -0300
Message-Id: <1375909874-22073-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Symbol offset is one of the fields that can be requested in perf-script.
Currently you do not get that data when requested. e.g.,

perf script -f comm,tid,pid,time,cpu,sym,symoff,ip
...
gcc  6201/6201  [006] 762250.617897:
    ffffffff81090d95 update_curr
    ffffffff810911b8 dequeue_entity
    ffffffff81091825 dequeue_task_fair
    ffffffff81087163 dequeue_task
    ffffffff81087c03 deactivate_task
...

With this patch you get the offset:
...
gcc  6201/6201  [006] 762250.617897:
    ffffffff81090d95 update_curr+0x1c5
    ffffffff810911b8 dequeue_entity+0x28
    ffffffff81091825 dequeue_task_fair+0x45
    ffffffff81087163 dequeue_task+0x93
    ffffffff81087c03 deactivate_task+0x23
...

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1375024474-45726-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 9247d9c..a0ce5a4 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1519,8 +1519,13 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 			printf("\t%16" PRIx64, node->ip);
 			if (print_sym) {
 				printf(" ");
-				symbol__fprintf_symname(node->sym, stdout);
+				if (print_symoffset) {
+					al.addr = node->ip;
+					symbol__fprintf_symname_offs(node->sym, &al, stdout);
+				} else
+					symbol__fprintf_symname(node->sym, stdout);
 			}
+
 			if (print_dso) {
 				printf(" (");
 				map__fprintf_dsoname(node->map, stdout);
-- 
1.8.1.4

