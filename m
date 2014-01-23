Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbaAWRFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:05:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55676 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176AbaAWRFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:05:35 -0500
Date: Thu, 23 Jan 2014 09:04:37 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-578c03c86fadcc6fd7319ddf41dd4d1d88aab77a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, gjain@fb.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, gjain@fb.com, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1389836971-3549-1-git-send-email-namhyung@kernel.org>
References: <1389836971-3549-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols: Fix JIT symbol resolution on heap
Git-Commit-ID: 578c03c86fadcc6fd7319ddf41dd4d1d88aab77a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 23 Jan 2014 09:04:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  578c03c86fadcc6fd7319ddf41dd4d1d88aab77a
Gitweb:     http://git.kernel.org/tip/578c03c86fadcc6fd7319ddf41dd4d1d88aab77a
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 16 Jan 2014 10:49:31 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 21 Jan 2014 10:56:05 -0300

perf symbols: Fix JIT symbol resolution on heap

Gaurav reported that perf cannot profile JIT program if it executes the
code on heap.  This was because current map__new() only handle JIT on
anon mappings - extends it to handle no_dso (heap, stack) case too.

This patch assumes JIT profiling only provides dynamic function symbols
so check the mapping type to distinguish the case.  It'd provide no
symbols for data mapping - if we need to support symbols on data
mappings later it should be changed.

Reported-by: Gaurav Jain <gjain@fb.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Gaurav Jain <gjain@fb.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Gaurav Jain <gjain@fb.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1389836971-3549-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 9b9bd71..ee1dd68 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -69,7 +69,7 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		map->ino = ino;
 		map->ino_generation = ino_gen;
 
-		if (anon) {
+		if ((anon || no_dso) && type == MAP__FUNCTION) {
 			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
 			filename = newfilename;
 		}
@@ -93,7 +93,7 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 			 * functions still return NULL, and we avoid the
 			 * unnecessary map__load warning.
 			 */
-			if (no_dso)
+			if (type != MAP__FUNCTION)
 				dso__set_loaded(dso, map->type);
 		}
 	}
