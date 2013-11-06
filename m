Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab3KFAxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 19:53:41 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:38834 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab3KFAxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 19:53:40 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf: Fix version when building out of tree
Date: Tue,  5 Nov 2013 17:53:33 -0700
Message-Id: <1383699213-23981-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building perf out of tree
    make perf-tar-src-pkg
    tar -xf perf-<ver>.tar -C /tmp
    cd /tmp/perf<ver>
    make -C tools/perf

you get the warning message:
    make[1]: *** No rule to make target `kernelversion'.  Stop.

Fix by saving the perf version in the tar file and using that for the
out of tree builds.

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
---
 scripts/package/Makefile         |    4 +++-
 tools/perf/util/PERF-VERSION-GEN |   16 +++++++++++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index a4f31c900fa6..e44653986e0a 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -115,7 +115,9 @@ git --git-dir=$(srctree)/.git archive --prefix=$(perf-tar)/         \
 	-o $(perf-tar).tar;                                         \
 mkdir -p $(perf-tar);                                               \
 git --git-dir=$(srctree)/.git rev-parse HEAD > $(perf-tar)/HEAD;    \
-tar rf $(perf-tar).tar $(perf-tar)/HEAD;                            \
+(cd $(srctree)/tools/perf;                                          \
+util/PERF-VERSION-GEN short ../../$(perf-tar)/ 2>/dev/null);        \
+tar rf $(perf-tar).tar $(perf-tar)/HEAD $(perf-tar)/PERF-VERSION-FILE; \
 rm -r $(perf-tar);                                                  \
 $(if $(findstring tar-src,$@),,                                     \
 $(if $(findstring bz2,$@),bzip2,                                    \
diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index 15a77b7c0e36..142d7dcccfd2 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -1,5 +1,12 @@
 #!/bin/sh
 
+SHORT_FORM=no
+
+if [ "$1" = "short" ]  ; then
+	SHORT_FORM=yes
+	shift
+fi
+
 if [ $# -eq 1 ]  ; then
 	OUTPUT=$1
 fi
@@ -19,6 +26,9 @@ if test -d ../../.git -o -f ../../.git
 then
 	TAG=$(git describe --abbrev=0 --match "v[0-9].[0-9]*" 2>/dev/null )
 	CID=$(git log -1 --abbrev=4 --pretty=format:"%h" 2>/dev/null) && CID="-g$CID"
+elif test -f ../../PERF-VERSION-FILE
+then
+	TAG=$(cat ../../PERF-VERSION-FILE)
 fi
 if test -z "$TAG"
 then
@@ -41,7 +51,11 @@ else
 fi
 test "$VN" = "$VC" || {
 	echo >&2 "PERF_VERSION = $VN"
-	echo "#define PERF_VERSION \"$VN\"" >$GVF
+	if [ "$SHORT_FORM" = "yes" ]; then
+		echo "$VN" >$GVF
+	else
+		echo "#define PERF_VERSION \"$VN\"" >$GVF
+	fi
 }
 
 
-- 
1.7.10.1

