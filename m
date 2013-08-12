Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab3HLKTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:19:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47752 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295Ab3HLKSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:18:32 -0400
Date: Mon, 12 Aug 2013 03:18:16 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-251f426fddd9217ce6e4478653d3ee33df518030@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1375024474-45726-1-git-send-email-dsahern@gmail.com>
References: <1375024474-45726-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel:
  Actually show symbol offset in stack trace when requested
Git-Commit-ID: 251f426fddd9217ce6e4478653d3ee33df518030
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:18:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  251f426fddd9217ce6e4478653d3ee33df518030
Gitweb:     http://git.kernel.org/tip/251f426fddd9217ce6e4478653d3ee33df518030
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sun, 28 Jul 2013 09:14:34 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:24 -0300

perf evsel: Actually show symbol offset in stack trace when requested

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
