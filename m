Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaKKU23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 15:28:29 -0500
Received: from mailout.easymail.ca ([64.68.201.169]:48074 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbaKKU2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 15:28:22 -0500
X-Quarantine-ID: <DdIrFixZo9SF>
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "References"
X-Spam-Flag: NO
X-Spam-Score: -4.399
From: Shuah Khan <shuahkh@osg.samsung.com>
To: gregkh@linuxfoundation.org, akpm@linux-foundation.org, mmarek@suse.cz,
        davem@davemloft.net, keescook@chromium.org, tranmanphong@gmail.com,
        dh.herrmann@gmail.com, hughd@google.com, bobby.prani@gmail.com,
        ebiederm@xmission.com, serge.hallyn@ubuntu.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 09/19] selftests/kcmp: add install target to enable installing test
Date: Tue, 11 Nov 2014 13:27:49 -0700
Message-Id: <5f77ee88e61e41399beb12cc52862bedbe934f92.1415735831.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1415735831.git.shuahkh@osg.samsung.com>
References: <cover.1415735831.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1415735831.git.shuahkh@osg.samsung.com>
References: <cover.1415735831.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new make target to enable installing test. This target
installs test in the kselftest install location and add to the
kselftest script to run the test. Install target can be run
only from top level source dir.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/kcmp/Makefile | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
index 8aabd82..753890f 100644
--- a/tools/testing/selftests/kcmp/Makefile
+++ b/tools/testing/selftests/kcmp/Makefile
@@ -14,6 +14,8 @@ CFLAGS += -I../../../../include/
 CFLAGS += -I../../../../usr/include/
 CFLAGS += -I../../../../arch/x86/include/
 
+TEST_STR = ./kcmp_test || echo kcmp_test: [FAIL]
+
 all:
 ifeq ($(ARCH),x86)
 	gcc $(CFLAGS) kcmp_test.c -o kcmp_test
@@ -21,8 +23,26 @@ else
 	echo "Not an x86 target, can't build kcmp selftest"
 endif
 
+install:
+ifdef INSTALL_KSFT_PATH
+ifeq ($(ARCH),x86)
+	install ./kcmp_test $(INSTALL_KSFT_PATH)
+	@echo echo Start kcmp test .... >> $(KSELFTEST)
+	@echo "$(TEST_STR)" >> $(KSELFTEST)
+	@echo rm -f kcmp-test-file >> $(KSELFTEST)
+	@echo echo End kcmp test .... >> $(KSELFTEST)
+	@echo echo ============================== >> $(KSELFTEST)
+else
+	@echo Not an x86 target, unable install kcmp selftests
+endif
+else
+	@echo Run make kselftest_install in top level source directory
+endif
+
 run_tests: all
-	@./kcmp_test || echo "kcmp_test: [FAIL]"
+ifeq ($(ARCH),x86)
+	@$(TEST_STR)
+endif
 
 clean:
 	$(RM) kcmp_test kcmp-test-file
-- 
1.9.1

