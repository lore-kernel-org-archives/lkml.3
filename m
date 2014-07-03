Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030203AbaGCJXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:23:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52164 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030182AbaGCJXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:23:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 118/198] selftests: Add infrastructure for powerpc selftests
Date: Thu,  3 Jul 2014 10:19:21 +0100
Message-Id: <1404379241-8590-119-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <michael@ellerman.id.au>

commit 0e56dacdda49940ff6e24e504f11468a27922416 upstream.

This commit adds a powerpc subdirectory to tools/testing/selftests,
for tests that are powerpc specific.

On other architectures nothing is built. The makefile supports cross
compilation if the user sets ARCH and CROSS_COMPILE.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
[ luis: 3.11.y prereq for:
  96d016108640 "powerpc: Correct DSCR during TM context switch" ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 tools/testing/selftests/Makefile         |  1 +
 tools/testing/selftests/powerpc/Makefile | 39 ++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)
 create mode 100644 tools/testing/selftests/powerpc/Makefile

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 4cb14cae3791..9f3eae290900 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -8,6 +8,7 @@ TARGETS += net
 TARGETS += ptrace
 TARGETS += timers
 TARGETS += vm
+TARGETS += powerpc
 
 all:
 	for TARGET in $(TARGETS); do \
diff --git a/tools/testing/selftests/powerpc/Makefile b/tools/testing/selftests/powerpc/Makefile
new file mode 100644
index 000000000000..b315740e4cd9
--- /dev/null
+++ b/tools/testing/selftests/powerpc/Makefile
@@ -0,0 +1,39 @@
+# Makefile for powerpc selftests
+
+# ARCH can be overridden by the user for cross compiling
+ARCH ?= $(shell uname -m)
+ARCH := $(shell echo $(ARCH) | sed -e s/ppc.*/powerpc/)
+
+ifeq ($(ARCH),powerpc)
+
+GIT_VERSION = $(shell git describe --always --long --dirty || echo "unknown")
+
+CC := $(CROSS_COMPILE)$(CC)
+CFLAGS := -Wall -O2 -flto -Wall -Werror -DGIT_VERSION='"$(GIT_VERSION)"' -I$(CURDIR) $(CFLAGS)
+
+export CC CFLAGS
+
+TARGETS =
+
+endif
+
+all:
+	@for TARGET in $(TARGETS); do \
+		$(MAKE) -C $$TARGET all; \
+	done;
+
+run_tests: all
+	@for TARGET in $(TARGETS); do \
+		$(MAKE) -C $$TARGET run_tests; \
+	done;
+
+clean:
+	@for TARGET in $(TARGETS); do \
+		$(MAKE) -C $$TARGET clean; \
+	done;
+	rm -f tags
+
+tags:
+	find . -name '*.c' -o -name '*.h' | xargs ctags
+
+.PHONY: all run_tests clean tags
-- 
1.9.1

