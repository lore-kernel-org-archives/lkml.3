Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbbAIJIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:08:55 -0500
Received: from ozlabs.org ([103.22.144.67]:48807 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759AbbAIJGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 04:06:49 -0500
From: Michael Ellerman <mpe@ellerman.id.au>
To: <linux-kernel@vger.kernel.org>
Cc: mmarek@suse.cz, gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        keescook@chromium.org, tranmanphong@gmail.com, cov@codeaurora.org,
        dh.herrmann@gmail.com, hughd@google.com, bobby.prani@gmail.com,
        serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        tim.bird@sonymobile.com, josh@joshtriplett.org, koct9i@gmail.com,
        linux-kbuild@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, shuahkh@osg.samsung.com
Subject: [PATCH 4/6] kbuild: add a new kselftest_install make target to install selftests
Date: Fri,  9 Jan 2015 20:06:13 +1100
Message-Id: <1420794375-31881-4-git-send-email-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420794375-31881-1-git-send-email-mpe@ellerman.id.au>
References: <1420794375-31881-1-git-send-email-mpe@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new make target to install kernel selftests. This new target will
build and install selftests.

The default is just $(objtree)/selftests. This is preferable to
something based on $(INSTALL_MOD_PATH) (which defaults to /), as it
allows a normal user to install the tests. This is similar to the
default behaviour of make headers_install.

Therefore the most basic usage is:

$ make kselftests_install
$ ./selftests/all.sh

To install elsewhere use:

$ make kselftests_install INSTALL_SELFTESTS_PATH=/some/where
$ /some/where/all.sh

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 Makefile                         | 13 ++++++++++++-
 tools/testing/selftests/Makefile |  1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index eb4eca56843a..c186a928d8be 100644
--- a/Makefile
+++ b/Makefile
@@ -1072,12 +1072,20 @@ headers_check: headers_install
 	$(Q)$(MAKE) $(hdr-inst)=arch/$(hdr-arch)/include/uapi/asm $(hdr-dst) HDRCHECK=1
 
 # ---------------------------------------------------------------------------
-# Kernel selftest
+# Kernel selftest targets
+
+# Default base path for kselftest install
+INSTALL_SELFTESTS_PATH = $(abspath $(objtree)/selftests)
 
 PHONY += kselftest
 kselftest:
 	$(Q)$(MAKE) -C tools/testing/selftests run_tests
 
+# Kernel selftest install
+PHONY += kselftest_install
+kselftest_install:
+	$(Q)$(MAKE) -C tools/testing/selftests INSTALL_PATH=$(INSTALL_SELFTESTS_PATH) install
+
 # ---------------------------------------------------------------------------
 # Modules
 
@@ -1286,6 +1294,9 @@ help:
 	@echo  '                    Build, install, and boot kernel before'
 	@echo  '                    running kselftest on it'
 	@echo  ''
+	@echo  '  kselftest_install - Install selftests to INSTALL_SELFTESTS_PATH'
+	@echo  '                      default: $(INSTALL_SELFTESTS_PATH)'
+	@echo  ''
 	@echo  'Kernel packaging:'
 	@$(MAKE) $(build)=$(package-dir) help
 	@echo  ''
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 4f2849b5ff77..a2345f4512bb 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -62,6 +62,7 @@ ifdef INSTALL_PATH
 
 	@# Ask all targets to emit their test scripts
 	echo "#!/bin/bash\n\n" > $(ALL_SCRIPT)
+	echo "cd \$$(dirname \$$0)" >> $(ALL_SCRIPT)
 	echo "ROOT=\$$PWD\n" >> $(ALL_SCRIPT)
 
 	for TARGET in $(TARGETS); do \
-- 
2.1.0

