Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab3GJTXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:23:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56814 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab3GJTTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:19:53 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@calxeda.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 20/23] perf tools: Fix perf version generation
Date: Wed, 10 Jul 2013 16:19:20 -0300
Message-Id: <1373483963-19277-21-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373483963-19277-1-git-send-email-acme@infradead.org>
References: <1373483963-19277-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@calxeda.com>

The tag of the perf version is wrongly determined, always the latest tag
is taken regardless of the HEAD commit:

 $ perf --version
 perf version 3.9.rc8.gd7f5d3
 $ git describe d7f5d3
 v3.9-rc7-154-gd7f5d33
 $ head -n 4 Makefile
 VERSION = 3
 PATCHLEVEL = 9
 SUBLEVEL = 0
 EXTRAVERSION = -rc7

In other cases no tag might be found.

This patch fixes this.

This new implementation handles also the case if there are no tags at
all found in the git repo but there is a commit id.

Signed-off-by: Robert Richter <robert.richter@calxeda.com>
Link: http://lkml.kernel.org/r/1368006214-12912-1-git-send-email-rric@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/PERF-VERSION-GEN | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index 055fef3..15a77b7 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -13,13 +13,22 @@ LF='
 # First check if there is a .git to get the version from git describe
 # otherwise try to get the version from the kernel Makefile
 #
-if test -d ../../.git -o -f ../../.git &&
-	VN=$(git tag 2>/dev/null | tail -1 | grep -E "v[0-9].[0-9]*")
+CID=
+TAG=
+if test -d ../../.git -o -f ../../.git
 then
-	VN=$(echo $VN"-g"$(git log -1 --abbrev=4 --pretty=format:"%h" HEAD))
-	VN=$(echo "$VN" | sed -e 's/-/./g');
-else
-	VN=$(MAKEFLAGS= make -sC ../.. kernelversion)
+	TAG=$(git describe --abbrev=0 --match "v[0-9].[0-9]*" 2>/dev/null )
+	CID=$(git log -1 --abbrev=4 --pretty=format:"%h" 2>/dev/null) && CID="-g$CID"
+fi
+if test -z "$TAG"
+then
+	TAG=$(MAKEFLAGS= make -sC ../.. kernelversion)
+fi
+VN="$TAG$CID"
+if test -n "$CID"
+then
+	# format version string, strip trailing zero of sublevel:
+	VN=$(echo "$VN" | sed -e 's/-/./g;s/\([0-9]*[.][0-9]*\)[.]0/\1/')
 fi
 
 VN=$(expr "$VN" : v*'\(.*\)')
-- 
1.8.1.4

