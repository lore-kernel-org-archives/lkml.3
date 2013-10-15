Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab3JOF0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:26:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33169 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3JOF0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:26:39 -0400
Date: Mon, 14 Oct 2013 22:26:23 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-58d91a0068694a5ba3efc99e88ce6b4b0dd0d085@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
In-Reply-To: <1378876173-13363-6-git-send-email-namhyung@kernel.org>
References: <1378876173-13363-6-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Do not try to call addr2line on non-binary files
Git-Commit-ID: 58d91a0068694a5ba3efc99e88ce6b4b0dd0d085
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:26:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  58d91a0068694a5ba3efc99e88ce6b4b0dd0d085
Gitweb:     http://git.kernel.org/tip/58d91a0068694a5ba3efc99e88ce6b4b0dd0d085
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 11 Sep 2013 14:09:29 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 16:01:05 -0300

perf tools: Do not try to call addr2line on non-binary files

No need to call addr2line since they don't have such information.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1378876173-13363-6-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c    |  3 ---
 tools/perf/util/srcline.c | 11 +++++++++--
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index b7e0ef0..d443593 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -259,9 +259,6 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 	if (!self->ms.map)
 		goto out_ip;
 
-	if (!strncmp(self->ms.map->dso->long_name, "/tmp/perf-", 10))
-		goto out_ip;
-
 	path = get_srcline(self->ms.map->dso->long_name, self->ip);
 	self->srcline = path;
 
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index 7e92cca..777f918 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -57,11 +57,17 @@ char *get_srcline(const char *dso_name, unsigned long addr)
 {
 	char *file;
 	unsigned line;
-	char *srcline;
+	char *srcline = SRCLINE_UNKNOWN;
 	size_t size;
 
+	if (dso_name[0] == '[')
+		goto out;
+
+	if (!strncmp(dso_name, "/tmp/perf-", 10))
+		goto out;
+
 	if (!addr2line(dso_name, addr, &file, &line))
-		return SRCLINE_UNKNOWN;
+		goto out;
 
 	/* just calculate actual length */
 	size = snprintf(NULL, 0, "%s:%u", file, line) + 1;
@@ -73,6 +79,7 @@ char *get_srcline(const char *dso_name, unsigned long addr)
 		srcline = SRCLINE_UNKNOWN;
 
 	free(file);
+out:
 	return srcline;
 }
 
