Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab3KNITD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 03:19:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35264 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab3KNITA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 03:19:00 -0500
Date: Thu, 14 Nov 2013 00:18:43 -0800
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-20799a9645646d99707b9809d789adb60cca4d42@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools/perf/build: Fix timerfd feature check
Git-Commit-ID: 20799a9645646d99707b9809d789adb60cca4d42
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 14 Nov 2013 00:18:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  20799a9645646d99707b9809d789adb60cca4d42
Gitweb:     http://git.kernel.org/tip/20799a9645646d99707b9809d789adb60cca4d42
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Thu, 14 Nov 2013 08:33:24 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Nov 2013 08:40:23 +0100

tools/perf/build: Fix timerfd feature check

'feature_timerfd' is checked all the time and calculated explicitly,
in a serial fashion. Add it to CORE_FEATURE_TESTS which causes it to
be built in parallel, using the newfangled parallel build autodetection
code.

This shaves 137 msecs off the perf build time on my system, which
speeds up the common case cached build by 43%:

Before:

  comet:~/tip> perf stat --null --repeat 5 make -C tools/perf/
  [...]
         0,453771441 seconds time elapsed                                          ( +-  0,09% )

After:

  comet:~/tip> perf stat --null --repeat 5 make -C tools/perf/
  [...]
         0,316290185 seconds time elapsed                                          ( +-  0,24% )

Cc: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-bb92CmexihopoSyqnkqepvsy@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index a8abd0e..396c163 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -142,7 +142,8 @@ CORE_FEATURE_TESTS =			\
 	libunwind			\
 	on-exit				\
 	stackprotector			\
-	stackprotector-all
+	stackprotector-all		\
+	timerfd
 
 #
 # So here we detect whether test-all was rebuilt, to be able
@@ -411,7 +412,6 @@ else
   endif
 endif
 
-$(call feature_check,timerfd)
 ifeq ($(feature-timerfd), 1)
   CFLAGS += -DHAVE_TIMERFD_SUPPORT
 else
