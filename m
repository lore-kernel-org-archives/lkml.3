Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087Ab3JOF07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:26:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33187 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab3JOF04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:26:56 -0400
Date: Mon, 14 Oct 2013 22:26:40 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-2cc9d0ef577975abb3ebce7d5978559ec1c73633@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
In-Reply-To: <1378876173-13363-8-git-send-email-namhyung@kernel.org>
References: <1378876173-13363-8-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Save failed result of get_srcline()
Git-Commit-ID: 2cc9d0ef577975abb3ebce7d5978559ec1c73633
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:26:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2cc9d0ef577975abb3ebce7d5978559ec1c73633
Gitweb:     http://git.kernel.org/tip/2cc9d0ef577975abb3ebce7d5978559ec1c73633
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 11 Sep 2013 14:09:31 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 16:02:02 -0300

perf tools: Save failed result of get_srcline()

Some dso's lack srcline info, so there's no point to keep trying on
them.  Just save failture status and skip them.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1378876173-13363-8-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c     |  1 +
 tools/perf/util/dso.h     |  1 +
 tools/perf/util/srcline.c | 10 ++++++++--
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 6bfc8aa..af4c687c 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -450,6 +450,7 @@ struct dso *dso__new(const char *name)
 		dso->rel = 0;
 		dso->sorted_by_name = 0;
 		dso->has_build_id = 0;
+		dso->has_srcline = 1;
 		dso->kernel = DSO_TYPE_USER;
 		dso->needs_swap = DSO_SWAP__UNSET;
 		INIT_LIST_HEAD(&dso->node);
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 72eedd6..9ac666a 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -83,6 +83,7 @@ struct dso {
 	enum dso_binary_type	data_type;
 	u8		 adjust_symbols:1;
 	u8		 has_build_id:1;
+	u8		 has_srcline:1;
 	u8		 hit:1;
 	u8		 annotate_warned:1;
 	u8		 sname_alloc:1;
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index c736d94..dcff10b 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -58,10 +58,13 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 {
 	char *file;
 	unsigned line;
-	char *srcline = SRCLINE_UNKNOWN;
+	char *srcline;
 	char *dso_name = dso->long_name;
 	size_t size;
 
+	if (!dso->has_srcline)
+		return SRCLINE_UNKNOWN;
+
 	if (dso_name[0] == '[')
 		goto out;
 
@@ -81,8 +84,11 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 		srcline = SRCLINE_UNKNOWN;
 
 	free(file);
-out:
 	return srcline;
+
+out:
+	dso->has_srcline = 0;
+	return SRCLINE_UNKNOWN;
 }
 
 void free_srcline(char *srcline)
