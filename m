Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbaAOUdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 15:33:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48480 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbaAOUdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 15:33:36 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/13] perf tools: Fix build error due to zfree() cast
Date: Wed, 15 Jan 2014 17:33:01 -0300
Message-Id: <1389817991-8145-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389817991-8145-1-git-send-email-acme@infradead.org>
References: <1389817991-8145-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

It failed to build perf on my ubuntu 10.04 box (gcc 4.4.3):

    CC       util/strlist.o
  cc1: warnings being treated as errors
  util/strlist.c: In function ‘str_node__delete’:
  util/strlist.c:42: error: dereferencing type-punned pointer will break strict-aliasing rules
  util/strlist.c:42: error: dereferencing type-punned pointer will break strict-aliasing rules
    CC       util/strfilter.o
  make: *** [util/strlist.o] Error 1

    CC       util/srcline.o
  cc1: warnings being treated as errors
  util/srcline.c: In function ‘addr2line_init’:
  util/srcline.c:132: error: dereferencing type-punned pointer will break strict-aliasing rules
  util/srcline.c:132: error: dereferencing type-punned pointer will break strict-aliasing rules
  util/srcline.c: In function ‘addr2line_cleanup’:
  util/srcline.c:143: error: dereferencing type-punned pointer will break strict-aliasing rules
  util/srcline.c:143: error: dereferencing type-punned pointer will break strict-aliasing rules
  make: *** [util/srcline.o] Error 1

It seems it only allows to remove 'const' qualifier.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1389276479-9047-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/srcline.c | 4 ++--
 tools/perf/util/strlist.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index 7e67879ebd25..f3e4bc5fe5d2 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -129,7 +129,7 @@ static struct a2l_data *addr2line_init(const char *path)
 
 out:
 	if (a2l) {
-		zfree((void **)&a2l->input);
+		zfree((char **)&a2l->input);
 		free(a2l);
 	}
 	bfd_close(abfd);
@@ -140,7 +140,7 @@ static void addr2line_cleanup(struct a2l_data *a2l)
 {
 	if (a2l->abfd)
 		bfd_close(a2l->abfd);
-	zfree((void **)&a2l->input);
+	zfree((char **)&a2l->input);
 	zfree(&a2l->syms);
 	free(a2l);
 }
diff --git a/tools/perf/util/strlist.c b/tools/perf/util/strlist.c
index 61a90bf24b4d..71f9d102b96f 100644
--- a/tools/perf/util/strlist.c
+++ b/tools/perf/util/strlist.c
@@ -39,7 +39,7 @@ out_delete:
 static void str_node__delete(struct str_node *snode, bool dupstr)
 {
 	if (dupstr)
-		zfree((void **)&snode->s);
+		zfree((char **)&snode->s);
 	free(snode);
 }
 
-- 
1.8.1.4

