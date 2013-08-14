Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760338Ab3HNS2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:28:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34371 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760199Ab3HNSZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:25:29 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 19/21] perf tests: Fix compile failure on do_sort_something
Date: Wed, 14 Aug 2013 15:25:13 -0300
Message-Id: <1376504715-28107-20-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376504715-28107-1-git-send-email-acme@infradead.org>
References: <1376504715-28107-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Commit b55ae0a9 added code-reading.c which fails to compile on Fedora 16
with compiler version:
$ gcc --version
gcc (GCC) 4.6.3 20120306 (Red Hat 4.6.3-2)

Failure message is:

tests/code-reading.c: In function ‘do_sort_something’:
tests/code-reading.c:305:13: error: stack protector not protecting local variables: variable length buffer [-Werror=stack-protector]
cc1: all warnings being treated as errors
make: *** [/tmp/junk/tests/code-reading.o] Error 1
make: *** Waiting for unfinished jobs....

v2: as Adrian noticed changed sizeof to ARRAY_SIZE

Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1376454732-83728-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/code-reading.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index eec1421..df9afd9 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -304,15 +304,14 @@ static int comp(const void *a, const void *b)
 
 static void do_sort_something(void)
 {
-	size_t sz = 40960;
-	int buf[sz], i;
+	int buf[40960], i;
 
-	for (i = 0; i < (int)sz; i++)
-		buf[i] = sz - i - 1;
+	for (i = 0; i < (int)ARRAY_SIZE(buf); i++)
+		buf[i] = ARRAY_SIZE(buf) - i - 1;
 
-	qsort(buf, sz, sizeof(int), comp);
+	qsort(buf, ARRAY_SIZE(buf), sizeof(int), comp);
 
-	for (i = 0; i < (int)sz; i++) {
+	for (i = 0; i < (int)ARRAY_SIZE(buf); i++) {
 		if (buf[i] != i) {
 			pr_debug("qsort failed\n");
 			break;
-- 
1.8.1.4

