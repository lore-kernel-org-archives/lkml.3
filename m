Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaKKUdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 15:33:37 -0500
Received: from mailout.easymail.ca ([64.68.201.169]:48028 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaKKU2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 15:28:20 -0500
X-Quarantine-ID: <l1DfYXkzF1Go>
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
Subject: [PATCH v2 08/19] selftests/ipc: add install target to enable installing test
Date: Tue, 11 Nov 2014 13:27:48 -0700
Message-Id: <690a1a8414de13ddb63f79440012acbdfadacc1b.1415735831.git.shuahkh@osg.samsung.com>
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
 tools/testing/selftests/ipc/Makefile | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ipc/Makefile b/tools/testing/selftests/ipc/Makefile
index 74bbefd..cd70f7c 100644
--- a/tools/testing/selftests/ipc/Makefile
+++ b/tools/testing/selftests/ipc/Makefile
@@ -11,6 +11,8 @@ endif
 
 CFLAGS += -I../../../../usr/include/
 
+TEST_STR = ./msgque_test || echo ipc msgque test: [FAIL]
+
 all:
 ifeq ($(ARCH),x86)
 	gcc $(CFLAGS) msgque.c -o msgque_test
@@ -18,8 +20,26 @@ else
 	echo "Not an x86 target, can't build msgque selftest"
 endif
 
+install:
+ifdef INSTALL_KSFT_PATH
+ifeq ($(ARCH),x86)
+	make all
+	install ./msgque_test $(INSTALL_KSFT_PATH)
+	@echo echo Start ipc msgque test .... >> $(KSELFTEST)
+	@echo "$(TEST_STR)" >> $(KSELFTEST)
+	@echo echo End msgque test .... >> $(KSELFTEST)
+	@echo "echo ============================== >> $(KSELFTEST)
+else
+	@echo Not an x86 target, unable to install ipc msgque selftests
+endif
+else
+	@echo Run make kselftest_install in top level source directory
+endif
+
 run_tests: all
-	./msgque_test
+ifeq ($(ARCH),x86)
+	@$(TEST_STR)
+endif
 
 clean:
 	rm -fr ./msgque_test
-- 
1.9.1

