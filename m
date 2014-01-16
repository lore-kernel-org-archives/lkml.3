Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbaAPNou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:44:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38264 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbaAPNiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:38:10 -0500
Date: Thu, 16 Jan 2014 05:37:24 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-7d16c634233c411f54b89d0f1d51750dc85c5f7e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung.kim@lge.com,
        mark.rutland@arm.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, namhyung.kim@lge.com,
        mark.rutland@arm.com, namhyung@kernel.org, tglx@linutronix.de
In-Reply-To: <1389276479-9047-1-git-send-email-namhyung@kernel.org>
References: <1389276479-9047-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix build error due to zfree() cast
Git-Commit-ID: 7d16c634233c411f54b89d0f1d51750dc85c5f7e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 05:37:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d16c634233c411f54b89d0f1d51750dc85c5f7e
Gitweb:     http://git.kernel.org/tip/7d16c634233c411f54b89d0f1d51750dc85c5f7e
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 9 Jan 2014 23:07:59 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 15 Jan 2014 15:10:04 -0300

perf tools: Fix build error due to zfree() cast

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
index 7e67879..f3e4bc5 100644
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
index 61a90bf..71f9d10 100644
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
 
