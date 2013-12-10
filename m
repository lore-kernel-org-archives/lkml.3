Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab3LJJep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:34:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44081 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab3LJJQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:16:59 -0500
Date: Tue, 10 Dec 2013 01:16:35 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-9c105fbc94a67ea5943d309d9a78ca669e0ddc61@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de,
        yangds.fnst@cn.fujitsu.com
In-Reply-To: <b8c41f1fd2c4f0df71eb7b19aea74fb64d46cdda.1386197481.git.yangds.fnst@cn.fujitsu.com>
References: <b8c41f1fd2c4f0df71eb7b19aea74fb64d46cdda.1386197481.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf target:
  Move the checking of which map function to call into function.
Git-Commit-ID: 9c105fbc94a67ea5943d309d9a78ca669e0ddc61
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 01:16:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9c105fbc94a67ea5943d309d9a78ca669e0ddc61
Gitweb:     http://git.kernel.org/tip/9c105fbc94a67ea5943d309d9a78ca669e0ddc61
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Wed, 4 Dec 2013 17:56:40 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 4 Dec 2013 13:46:37 -0300

perf target: Move the checking of which map function to call into function.

Check for cpu_map__dummy_new() or cpu_map__new() to be called in
perf_evlist__create_maps() is more complicated.

This patch moves the checking work into target.h, combining two
conditions and making perf_evlist__create_maps() more readable.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/b8c41f1fd2c4f0df71eb7b19aea74fb64d46cdda.1386197481.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |  8 +-------
 tools/perf/util/target.h | 13 +++++++++++++
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 76fa764..7bb6ee1 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -819,13 +819,7 @@ int perf_evlist__create_maps(struct perf_evlist *evlist, struct target *target)
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (target->default_per_cpu)
-		evlist->cpus = target->per_thread ?
-					cpu_map__dummy_new() :
-					cpu_map__new(target->cpu_list);
-	else if (target__has_task(target))
-		evlist->cpus = cpu_map__dummy_new();
-	else if (!target__has_cpu(target) && !target->uses_mmap)
+	if (target__uses_dummy_map(target))
 		evlist->cpus = cpu_map__dummy_new();
 	else
 		evlist->cpus = cpu_map__new(target->cpu_list);
diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
index 31dd2e9..7381b1c 100644
--- a/tools/perf/util/target.h
+++ b/tools/perf/util/target.h
@@ -63,4 +63,17 @@ static inline bool target__none(struct target *target)
 	return !target__has_task(target) && !target__has_cpu(target);
 }
 
+static inline bool target__uses_dummy_map(struct target *target)
+{
+	bool use_dummy = false;
+
+	if (target->default_per_cpu)
+		use_dummy = target->per_thread ? true : false;
+	else if (target__has_task(target) ||
+	         (!target__has_cpu(target) && !target->uses_mmap))
+		use_dummy = true;
+
+	return use_dummy;
+}
+
 #endif /* _PERF_TARGET_H */
