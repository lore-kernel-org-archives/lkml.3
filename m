Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab3CRKyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 06:54:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33913 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab3CRKx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 06:53:57 -0400
Date: Mon, 18 Mar 2013 03:52:33 -0700
From: tip-bot for Marcin Slusarz <tipbot@zytor.com>
Message-ID: <tip-d2f32479e5526a1ab3b4e43910fcb279871524ce@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, marcin.slusarz@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        marcin.slusarz@gmail.com, tglx@linutronix.de
In-Reply-To: <1361113416-8662-1-git-send-email-marcin.slusarz@gmail.com>
References: <1361113416-8662-1-git-send-email-marcin.slusarz@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: check if -DFORTIFY_SOURCE=
 2 is allowed
Git-Commit-ID: d2f32479e5526a1ab3b4e43910fcb279871524ce
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 18 Mar 2013 03:52:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d2f32479e5526a1ab3b4e43910fcb279871524ce
Gitweb:     http://git.kernel.org/tip/d2f32479e5526a1ab3b4e43910fcb279871524ce
Author:     Marcin Slusarz <marcin.slusarz@gmail.com>
AuthorDate: Sun, 17 Feb 2013 16:03:36 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Mar 2013 16:57:27 -0300

perf tools: check if -DFORTIFY_SOURCE=2 is allowed

It seems gcc (4.7.2) defines _FORTIFY_SOURCE internally and becomes
confused when it sees another definition in flags.

For me, build failed like this:

CHK glibc
Makefile:548: *** No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static. Stop.

and only with V=1 it printed:

<command-line>:0:0: error: "_FORTIFY_SOURCE" redefined [-Werror]
<stdin>:1:0: note: this is the location of the previous definition

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1361113416-8662-1-git-send-email-marcin.slusarz@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a2108ca..bb74c79 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -95,7 +95,7 @@ ifeq ("$(origin DEBUG)", "command line")
   PERF_DEBUG = $(DEBUG)
 endif
 ifndef PERF_DEBUG
-  CFLAGS_OPTIMIZE = -O6 -D_FORTIFY_SOURCE=2
+  CFLAGS_OPTIMIZE = -O6
 endif
 
 ifdef PARSER_DEBUG
@@ -180,6 +180,12 @@ ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wvolatile-register-var,-W
        CFLAGS := $(CFLAGS) -Wvolatile-register-var
 endif
 
+ifndef PERF_DEBUG
+	ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -D_FORTIFY_SOURCE=2,-D_FORTIFY_SOURCE=2),y)
+		CFLAGS := $(CFLAGS) -D_FORTIFY_SOURCE=2
+	endif
+endif
+
 ### --- END CONFIGURATION SECTION ---
 
 ifeq ($(srctree),)
