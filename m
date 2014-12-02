Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbaLBFwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 00:52:38 -0500
Received: from ozlabs.org ([103.22.144.67]:39430 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280AbaLBFwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 00:52:24 -0500
From: Michael Ellerman <mpe@ellerman.id.au>
To: <linux-kernel@vger.kernel.org>
Cc: shuahkh@osg.samsung.com, Andrew Morton <akpm@osdl.org>,
        gorcunov@openvz.org, Arnd Bergmann <arnd@arndb.de>, cov@codeaurora.org
Subject: [PATCH 3/3] selftests/kcmp: Always try to build the test
Date: Tue,  2 Dec 2014 16:52:08 +1100
Message-Id: <1417499528-23377-3-git-send-email-mpe@ellerman.id.au>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417499528-23377-1-git-send-email-mpe@ellerman.id.au>
References: <1417499528-23377-1-git-send-email-mpe@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't prevent the test building on non-x86. Just try and build it and
let the chips fall where they may.

Add support for CROSS_COMPILE while we're at it. Also we don't need a
custom rule for building kcmp_test.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---

eg:
$ uname -m
x86_64
$ make ARCH=powerpc headers_install
  CHK     include/generated/uapi/linux/version.h
  UPD     include/generated/uapi/linux/version.h
  ...
  INSTALL usr/include/asm/ (43 files)
$ cd tools/testing/selftests/kcmp/
$ make
ppc64-cc -I../../../../usr/include/    kcmp_test.c   -o kcmp_test
$ file kcmp_test
kcmp_test: ELF 32-bit MSB  executable, PowerPC or cisco 4500 ...


 tools/testing/selftests/kcmp/Makefile | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
index 4f00c0524501..ff0eefdc6ceb 100644
--- a/tools/testing/selftests/kcmp/Makefile
+++ b/tools/testing/selftests/kcmp/Makefile
@@ -1,21 +1,7 @@
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
-ifeq ($(ARCH),i386)
-        ARCH := x86
-	CFLAGS := -DCONFIG_X86_32 -D__i386__
-endif
-ifeq ($(ARCH),x86_64)
-	ARCH := x86
-	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
-endif
+CC := $(CROSS_COMPILE)$(CC)
 CFLAGS += -I../../../../usr/include/
 
-all:
-ifeq ($(ARCH),x86)
-	gcc $(CFLAGS) kcmp_test.c -o kcmp_test
-else
-	echo "Not an x86 target, can't build kcmp selftest"
-endif
+all: kcmp_test
 
 run_tests: all
 	@./kcmp_test || echo "kcmp_test: [FAIL]"
-- 
1.9.1

