Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab3AYLew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:34:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41765 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756763Ab3AYLeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:34:50 -0500
Date: Fri, 25 Jan 2013 03:34:07 -0800
From: tip-bot for Joshua Zhu <zhu.wen-jie@hp.com>
Message-ID: <tip-d0528b5d71faf612014dd7672e44225c915344b2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        akihiro.nagai.hw@hitachi.com, a.p.zijlstra@chello.nl,
        zhu.wen-jie@hp.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        akihiro.nagai.hw@hitachi.com, andi@firstfloor.org, zhu.wen-jie@hp.com,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1357363797-3550-1-git-send-email-zhu.wen-jie@hp.com>
References: <1357363797-3550-1-git-send-email-zhu.wen-jie@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add anonymous huge page recognition
Git-Commit-ID: d0528b5d71faf612014dd7672e44225c915344b2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:34:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d0528b5d71faf612014dd7672e44225c915344b2
Gitweb:     http://git.kernel.org/tip/d0528b5d71faf612014dd7672e44225c915344b2
Author:     Joshua Zhu <zhu.wen-jie@hp.com>
AuthorDate: Sat, 5 Jan 2013 13:29:57 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:19 -0300

perf tools: Add anonymous huge page recognition

Judging anonymous memory's vm_area_struct, perf_mmap_event's filename
will be set to "//anon" indicating this vma belongs to anonymous
memory.

Once hugepage is used, vma's vm_file points to hugetlbfs. In this way,
this vma will not be regarded as anonymous memory by is_anon_memory() in
perf user space utility.

Signed-off-by: Joshua Zhu <zhu.wen-jie@hp.com>
Cc: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Joshua Zhu <zhu.wen-jie@hp.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1357363797-3550-1-git-send-email-zhu.wen-jie@hp.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 0328d45..ff94425 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -19,7 +19,8 @@ const char *map_type__name[MAP__NR_TYPES] = {
 
 static inline int is_anon_memory(const char *filename)
 {
-	return strcmp(filename, "//anon") == 0;
+	return !strcmp(filename, "//anon") ||
+	       !strcmp(filename, "/anon_hugepage (deleted)");
 }
 
 static inline int is_no_dso_memory(const char *filename)
