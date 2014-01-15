Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaAOKoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:44:30 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58719 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751042AbaAOKo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:44:26 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 1/3] perf: tools: Fix aliasing violation in zfree uses
Date: Wed, 15 Jan 2014 10:44:06 +0000
Message-Id: <1389782648-4417-2-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1389782648-4417-1-git-send-email-mark.rutland@arm.com>
References: <1389782648-4417-1-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 74cf249d5cf7 (perf tools: Use zfree to help detect
use after free bugs) changed many uses of free to zfree, which
automatically clears the pointer. However, in a couple of places it
casts a const char** to void**, which the compiler doesn't like:

  cc1: warnings being treated as errors
  util/strlist.c: In function ‘str_node__delete’:
  util/strlist.c:42: error: dereferencing type-punned pointer will break strict-aliasing rules
  util/strlist.c:42: error: dereferencing type-punned pointer will break strict-aliasing rules
  make[1]: *** [util/strlist.o] Error 1

This patch fixes the issue by only throwing away the const, casting to char**
instead. This is more readily accepted by the compiler.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
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
 
-- 
1.8.1.1

