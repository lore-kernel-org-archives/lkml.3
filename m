Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab3HNEcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 00:32:23 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36163 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab3HNEcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 00:32:20 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf tests: Fix compile failure on do_sort_something - v2
Date: Tue, 13 Aug 2013 22:32:12 -0600
Message-Id: <1376454732-83728-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/tests/code-reading.c |   11 +++++------
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
1.7.10.1

