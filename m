Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab3JOFUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:20:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60849 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757483Ab3JOFT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:19:57 -0400
Date: Mon, 14 Oct 2013 22:19:41 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-b102420b500da97e0fc18d94f0600bddeced1b99@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build:
  Fix non-canonical directory names in O=
Git-Commit-ID: b102420b500da97e0fc18d94f0600bddeced1b99
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:19:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b102420b500da97e0fc18d94f0600bddeced1b99
Gitweb:     http://git.kernel.org/tip/b102420b500da97e0fc18d94f0600bddeced1b99
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Fri, 4 Oct 2013 12:08:05 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:49:01 +0200

tools/perf/build: Fix non-canonical directory names in O=

This was a long-standing bug, relative pathnames like O=dir did not fully
work in the build system:

    $ make O=localdir clean

    SUBDIR Documentation
    ../../scripts/Makefile.include:3: *** O=localdir does not exist.  Stop.
    make[1]: *** [clean] Error 2
    make: *** [clean] Error 2

Fix this by canonizing the directory before passing it to Makefile.perf.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-hchMp1hozn9tqgswWcooxcru@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Makefile | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 74f52d8..9580ebe 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -30,12 +30,19 @@ ifeq ($(JOBS),)
   endif
 endif
 
+#
+# Only pass canonical directory names as the output directory:
+#
+ifneq ($(O),)
+  FULL_O := $(shell readlink -f $(O))
+endif
+
 define print_msg
   @printf '    BUILD: Doing '\''make \033[33m-j'$(JOBS)'\033[m'\'' parallel build\n'
 endef
 
 define make
-  @$(MAKE) -f Makefile.perf --no-print-directory -j$(JOBS) O=$(O) $@
+  @$(MAKE) -f Makefile.perf --no-print-directory -j$(JOBS) O=$(FULL_O) $@
 endef
 
 #
