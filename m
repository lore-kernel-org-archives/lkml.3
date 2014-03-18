Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbaCRIaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:30:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45594 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbaCRIaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:30:00 -0400
Date: Tue, 18 Mar 2014 01:29:28 -0700
From: tip-bot for Patrick Palka <tipbot@zytor.com>
Message-ID: <tip-6eeefccdcfc2cc9697562e740bfe6c35fddd4e1c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, patrick@parcs.ath.cx, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, patrick@parcs.ath.cx,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1394664051-6037-1-git-send-email-patrick@parcs.ath.cx>
References: <1394664051-6037-1-git-send-email-patrick@parcs.ath.cx>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf bench: Fix NULL pointer dereference in "
 perf bench all"
Git-Commit-ID: 6eeefccdcfc2cc9697562e740bfe6c35fddd4e1c
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

Commit-ID:  6eeefccdcfc2cc9697562e740bfe6c35fddd4e1c
Gitweb:     http://git.kernel.org/tip/6eeefccdcfc2cc9697562e740bfe6c35fddd4e1c
Author:     Patrick Palka <patrick@parcs.ath.cx>
AuthorDate: Wed, 12 Mar 2014 18:40:51 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 14 Mar 2014 13:45:54 -0300

perf bench: Fix NULL pointer dereference in "perf bench all"

The for_each_bench() macro must check that the "benchmarks" field of a
collection is not NULL before dereferencing it because the "all"
collection in particular has a NULL "benchmarks" field (signifying that
it has no benchmarks to iterate over).

This fixes this NULL pointer dereference when running "perf bench all":

  [root@ssdandy ~]# perf bench all
  <SNIP>

  # Running mem/memset benchmark...
  # Copying 1MB Bytes ...

         2.453675 GB/Sec
        12.056327 GB/Sec (with prefault)

  Segmentation fault (core dumped)
  [root@ssdandy ~]#

Signed-off-by: Patrick Palka <patrick@parcs.ath.cx>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1394664051-6037-1-git-send-email-patrick@parcs.ath.cx
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-bench.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index e47f90c..8a987d2 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -76,7 +76,7 @@ static struct collection collections[] = {
 
 /* Iterate over all benchmarks within a collection: */
 #define for_each_bench(coll, bench) \
-	for (bench = coll->benchmarks; bench->name; bench++)
+	for (bench = coll->benchmarks; bench && bench->name; bench++)
 
 static void dump_benchmarks(struct collection *coll)
 {
