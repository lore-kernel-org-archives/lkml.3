Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab3JOFPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:15:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60569 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab3JOFP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:15:26 -0400
Date: Mon, 14 Oct 2013 22:15:11 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-d795a658eb0ab5ab0b86cda5abe28954b0a08471@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Split out feature check: '
 libaudit'
Git-Commit-ID: d795a658eb0ab5ab0b86cda5abe28954b0a08471
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:15:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d795a658eb0ab5ab0b86cda5abe28954b0a08471
Gitweb:     http://git.kernel.org/tip/d795a658eb0ab5ab0b86cda5abe28954b0a08471
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 30 Sep 2013 14:55:31 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:40 +0200

tools/perf/build: Split out feature check: 'libaudit'

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-orhejqtjao3vf4wxwBUdzhaz@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                       | 4 ++--
 tools/perf/config/feature-checks/Makefile        | 4 ++++
 tools/perf/config/feature-checks/test-libaudit.c | 7 +++++++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index d684a29..d4f18f4 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -114,6 +114,7 @@ FEATURE_TESTS =				\
 	libelf-mmap			\
 	libelf-getphdrnum		\
 	libunwind			\
+	libaudit			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -265,8 +266,7 @@ ifndef NO_LIBUNWIND
 endif
 
 ifndef NO_LIBAUDIT
-  FLAGS_LIBAUDIT = $(CFLAGS) $(LDFLAGS) -laudit
-  ifneq ($(call try-cc,$(SOURCE_LIBAUDIT),$(FLAGS_LIBAUDIT),libaudit),y)
+  ifneq ($(feature-libaudit), 1)
     msg := $(warning No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev);
     NO_LIBAUDIT := 1
   else
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index d6d9570..8e49fa0 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -12,6 +12,7 @@ FILES=					\
 	test-libelf-mmap		\
 	test-libelf-getphdrnum		\
 	test-libunwind			\
+	test-libaudit			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -61,6 +62,9 @@ test-libnuma:
 test-libunwind:
 	$(BUILD) -lunwind -lunwind-x86_64 -lelf
 
+test-libaudit:
+	$(BUILD) -laudit
+
 -include *.d */*.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-libaudit.c b/tools/perf/config/feature-checks/test-libaudit.c
new file mode 100644
index 0000000..854a65d
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libaudit.c
@@ -0,0 +1,7 @@
+#include <libaudit.h>
+
+int main(void)
+{
+	printf("error message: %s\n", audit_errno_to_name(0));
+	return audit_open();
+}
