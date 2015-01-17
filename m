Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbbAQKL2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 05:11:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44264 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbbAQKLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 05:11:25 -0500
Date: Sat, 17 Jan 2015 02:11:08 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-260d819e3abdbdaa2b88fb983d1314f1b263f9e2@git.kernel.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, dsahern@gmail.com,
        acme@redhat.com, a.p.zijlstra@chello.nl, hpa@zytor.com,
        namhyung@kernel.org, tglx@linutronix.de, jolsa@redhat.com,
        jolsa@kernel.org
Reply-To: tglx@linutronix.de, jolsa@kernel.org, jolsa@redhat.com,
        namhyung@kernel.org, hpa@zytor.com, a.p.zijlstra@chello.nl,
        acme@redhat.com, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org
In-Reply-To: <1420763892-15535-1-git-send-email-namhyung@kernel.org>
References: <1420763892-15535-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf machine: Fix __machine__findnew_thread()
  error path
Git-Commit-ID: 260d819e3abdbdaa2b88fb983d1314f1b263f9e2
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

Commit-ID:  260d819e3abdbdaa2b88fb983d1314f1b263f9e2
Gitweb:     http://git.kernel.org/tip/260d819e3abdbdaa2b88fb983d1314f1b263f9e2
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Fri, 9 Jan 2015 09:38:12 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 16 Jan 2015 17:49:28 -0300

perf machine: Fix __machine__findnew_thread() error path

When thread__init_map_groups() fails, a new thread should be removed
from the rbtree since it's gonna be freed.  Also update last match cache
only if the function succeeded.

Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1420763892-15535-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 94de3e4..1bca3a9 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -389,7 +389,6 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
 	if (th != NULL) {
 		rb_link_node(&th->rb_node, parent, p);
 		rb_insert_color(&th->rb_node, &machine->threads);
-		machine->last_match = th;
 
 		/*
 		 * We have to initialize map_groups separately
@@ -400,9 +399,12 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
 		 * leader and that would screwed the rb tree.
 		 */
 		if (thread__init_map_groups(th, machine)) {
+			rb_erase(&th->rb_node, &machine->threads);
 			thread__delete(th);
 			return NULL;
 		}
+
+		machine->last_match = th;
 	}
 
 	return th;
