Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3KGPEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:04:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55624 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab3KGPEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:04:37 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/7] perf tools: Fix version when building out of tree
Date: Thu,  7 Nov 2013 12:04:13 -0300
Message-Id: <1383836658-10518-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383836658-10518-1-git-send-email-acme@infradead.org>
References: <1383836658-10518-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

When building perf out of tree:

  $ make perf-tar-src-pkg
  $ tar -xf perf-<ver>.tar -C /tmp
  $ cd /tmp/perf<ver>
  $ make -C tools/perf

you get this warning message:
    make[1]: *** No rule to make target `kernelversion'.  Stop.

Fix it by saving the perf version in the tar file and using that for the
out of tree builds.

v2: removed short form request and fixed up version string from usual output.

Signed-off-by: David Ahern <dsahern@gmail.com>
Suggested-by: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1383753335-25782-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 scripts/package/Makefile         | 4 +++-
 tools/perf/util/PERF-VERSION-GEN | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index a4f31c900fa6..c5d473393816 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -115,7 +115,9 @@ git --git-dir=$(srctree)/.git archive --prefix=$(perf-tar)/         \
 	-o $(perf-tar).tar;                                         \
 mkdir -p $(perf-tar);                                               \
 git --git-dir=$(srctree)/.git rev-parse HEAD > $(perf-tar)/HEAD;    \
-tar rf $(perf-tar).tar $(perf-tar)/HEAD;                            \
+(cd $(srctree)/tools/perf;                                          \
+util/PERF-VERSION-GEN ../../$(perf-tar)/ 2>/dev/null);              \
+tar rf $(perf-tar).tar $(perf-tar)/HEAD $(perf-tar)/PERF-VERSION-FILE; \
 rm -r $(perf-tar);                                                  \
 $(if $(findstring tar-src,$@),,                                     \
 $(if $(findstring bz2,$@),bzip2,                                    \
diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index ce7a804b2951..39f17507578d 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -19,6 +19,9 @@ if test -d ../../.git -o -f ../../.git
 then
 	TAG=$(git describe --abbrev=0 --match "v[0-9].[0-9]*" 2>/dev/null )
 	CID=$(git log -1 --abbrev=4 --pretty=format:"%h" 2>/dev/null) && CID="-g$CID"
+elif test -f ../../PERF-VERSION-FILE
+then
+	TAG=$(cut -d' ' -f3 ../../PERF-VERSION-FILE | sed -e 's/\"//g')
 fi
 if test -z "$TAG"
 then
-- 
1.8.1.4

