Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab3KGPau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:30:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40757 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab3KGPat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:30:49 -0500
Date: Thu, 7 Nov 2013 07:30:35 -0800
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-a614d01bdd0cc8200d917da25f5a3d539b944193@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1383753335-25782-1-git-send-email-dsahern@gmail.com>
References: <1383753335-25782-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix version when building out of tree
Git-Commit-ID: a614d01bdd0cc8200d917da25f5a3d539b944193
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 07 Nov 2013 07:30:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a614d01bdd0cc8200d917da25f5a3d539b944193
Gitweb:     http://git.kernel.org/tip/a614d01bdd0cc8200d917da25f5a3d539b944193
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 6 Nov 2013 08:55:35 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 7 Nov 2013 10:40:47 -0300

perf tools: Fix version when building out of tree

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
index a4f31c9..c5d4733 100644
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
index ce7a804..39f1750 100755
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
