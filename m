Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbaAWREA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:04:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55558 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbaAWRD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:03:56 -0500
Date: Thu, 23 Jan 2014 09:03:37 -0800
From: tip-bot for Stanislav Fomichev <tipbot@zytor.com>
Message-ID: <tip-8bac41cbfe2efe55e2b93673b84761ed7dd75f69@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        stfomichev@yandex-team.ru, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, stfomichev@yandex-team.ru,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1390217980-22424-3-git-send-email-stfomichev@yandex-team.ru>
References: <1390217980-22424-3-git-send-email-stfomichev@yandex-team.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf session:
  Free cpu_map in perf_session__cpu_bitmap
Git-Commit-ID: 8bac41cbfe2efe55e2b93673b84761ed7dd75f69
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 23 Jan 2014 09:03:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8bac41cbfe2efe55e2b93673b84761ed7dd75f69
Gitweb:     http://git.kernel.org/tip/8bac41cbfe2efe55e2b93673b84761ed7dd75f69
Author:     Stanislav Fomichev <stfomichev@yandex-team.ru>
AuthorDate: Mon, 20 Jan 2014 15:39:39 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 20 Jan 2014 16:19:08 -0300

perf session: Free cpu_map in perf_session__cpu_bitmap

This method uses a temporary struct cpu_map to figure out the cpus
present in the received cpu list in string form, but it failed to free
it after returning. Fix it.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1390217980-22424-3-git-send-email-stfomichev@yandex-team.ru
[ Use goto + err = -1 to do the delete just once, in the normal exit path ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 7acc03e..0b39a48 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1573,7 +1573,7 @@ next:
 int perf_session__cpu_bitmap(struct perf_session *session,
 			     const char *cpu_list, unsigned long *cpu_bitmap)
 {
-	int i;
+	int i, err = -1;
 	struct cpu_map *map;
 
 	for (i = 0; i < PERF_TYPE_MAX; ++i) {
@@ -1602,13 +1602,17 @@ int perf_session__cpu_bitmap(struct perf_session *session,
 		if (cpu >= MAX_NR_CPUS) {
 			pr_err("Requested CPU %d too large. "
 			       "Consider raising MAX_NR_CPUS\n", cpu);
-			return -1;
+			goto out_delete_map;
 		}
 
 		set_bit(cpu, cpu_bitmap);
 	}
 
-	return 0;
+	err = 0;
+
+out_delete_map:
+	cpu_map__delete(map);
+	return err;
 }
 
 void perf_session__fprintf_info(struct perf_session *session, FILE *fp,
