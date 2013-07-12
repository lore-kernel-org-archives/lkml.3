Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702Ab3GLIwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 04:52:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54901 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631Ab3GLIwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 04:52:37 -0400
Date: Fri, 12 Jul 2013 01:52:24 -0700
From: tip-bot for Robert Richter <tipbot@zytor.com>
Message-ID: <tip-a4147f0f91386540316e468f3a3674a498dada5f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, robert.richter@calxeda.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, robert.richter@calxeda.com
In-Reply-To: <1368006214-12912-1-git-send-email-rric@kernel.org>
References: <1368006214-12912-1-git-send-email-rric@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix perf version generation
Git-Commit-ID: a4147f0f91386540316e468f3a3674a498dada5f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 01:52:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a4147f0f91386540316e468f3a3674a498dada5f
Gitweb:     http://git.kernel.org/tip/a4147f0f91386540316e468f3a3674a498dada5f
Author:     Robert Richter <robert.richter@calxeda.com>
AuthorDate: Wed, 8 May 2013 11:43:34 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Jul 2013 18:09:52 -0300

perf tools: Fix perf version generation

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
