Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbaANQjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:39:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52683 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaANQjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:39:25 -0500
Date: Tue, 14 Jan 2014 08:38:58 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-c4eb6c0e7aa3a5106a3382880bc41c696e72adb4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1389098853-14466-2-git-send-email-jolsa@redhat.com>
References: <1389098853-14466-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Automate setup of FEATURE_CHECK_(C|LD
 )FLAGS-all variables
Git-Commit-ID: c4eb6c0e7aa3a5106a3382880bc41c696e72adb4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:39:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c4eb6c0e7aa3a5106a3382880bc41c696e72adb4
Gitweb:     http://git.kernel.org/tip/c4eb6c0e7aa3a5106a3382880bc41c696e72adb4
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 7 Jan 2014 13:47:18 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 10:06:24 -0300

perf tools: Automate setup of FEATURE_CHECK_(C|LD)FLAGS-all variables

Instead of explicitly adding same value into
FEATURE_CHECK_(C|LD)FLAGS-all variables we can do that automatically.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1389098853-14466-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f2bc659..5d15b43 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -53,9 +53,6 @@ else
   FEATURE_CHECK_LDFLAGS-libunwind = $(LIBUNWIND_LDFLAGS)
   FEATURE_CHECK_CFLAGS-libunwind-debug-frame = $(LIBUNWIND_CFLAGS)
   FEATURE_CHECK_LDFLAGS-libunwind-debug-frame = $(LIBUNWIND_LDFLAGS)
-  #  and the flags for the test-all case
-  FEATURE_CHECK_CFLAGS-all += $(LIBUNWIND_CFLAGS)
-  FEATURE_CHECK_LDFLAGS-all += $(LIBUNWIND_LDFLAGS)
 endif
 
 ifeq ($(NO_PERF_REGS),0)
@@ -152,6 +149,17 @@ CORE_FEATURE_TESTS =			\
 	stackprotector-all		\
 	timerfd
 
+# Set FEATURE_CHECK_(C|LD)FLAGS-all for all CORE_FEATURE_TESTS features.
+# If in the future we need per-feature checks/flags for features not
+# mentioned in this list we need to refactor this ;-).
+set_test_all_flags = $(eval $(set_test_all_flags_code))
+define set_test_all_flags_code
+  FEATURE_CHECK_CFLAGS-all  += $(FEATURE_CHECK_CFLAGS-$(1))
+  FEATURE_CHECK_LDFLAGS-all += $(FEATURE_CHECK_LDFLAGS-$(1))
+endef
+
+$(foreach feat,$(CORE_FEATURE_TESTS),$(call set_test_all_flags,$(feat)))
+
 #
 # So here we detect whether test-all was rebuilt, to be able
 # to skip the print-out of the long features list if the file
