Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab3G1POm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 11:14:42 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:54050 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab3G1POk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 11:14:40 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf tool: Actually show symbol offset in stack trace when requested
Date: Sun, 28 Jul 2013 09:14:34 -0600
Message-Id: <1375024474-45726-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 tools/perf/util/session.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 272c9cf..38320ac 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1411,8 +1411,13 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
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
1.7.10.1

