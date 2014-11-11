Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbaKKU2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 15:28:21 -0500
Received: from mailout.easymail.ca ([64.68.201.169]:47997 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbaKKU2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 15:28:18 -0500
X-Quarantine-ID: <ZVy2qQA2RFm6>
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
Subject: [PATCH v2 07/19] selftests/firmware: add install target to enable installing test
Date: Tue, 11 Nov 2014 13:27:47 -0700
Message-Id: <1d2d13556ddbbbbb13989cdcb08447909bc4afaf.1415735831.git.shuahkh@osg.samsung.com>
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
 tools/testing/selftests/firmware/Makefile | 49 ++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/firmware/Makefile b/tools/testing/selftests/firmware/Makefile
index e23cce0..2286dbb 100644
--- a/tools/testing/selftests/firmware/Makefile
+++ b/tools/testing/selftests/firmware/Makefile
@@ -1,25 +1,40 @@
 # Makefile for firmware loading selftests
 
 # No binaries, but make sure arg-less "make" doesn't trigger "run_tests"
+
+__fw_filesystem:
+fw_filesystem  = if /bin/sh ./fw_filesystem.sh ; then
+fw_filesystem += echo fw_filesystem: ok;
+fw_filesystem += else echo fw_filesystem: [FAIL];
+fw_filesystem += fi
+
+__fw_userhelper:
+fw_userhelper  = if /bin/sh ./fw_userhelper.sh ; then
+fw_userhelper += echo fw_userhelper: ok;
+fw_userhelper += else
+fw_userhelper += echo fw_userhelper: [FAIL];
+fw_userhelper += fi
+
 all:
 
-fw_filesystem:
-	@if /bin/sh ./fw_filesystem.sh ; then \
-                echo "fw_filesystem: ok"; \
-        else \
-                echo "fw_filesystem: [FAIL]"; \
-                exit 1; \
-        fi
-
-fw_userhelper:
-	@if /bin/sh ./fw_userhelper.sh ; then \
-                echo "fw_userhelper: ok"; \
-        else \
-                echo "fw_userhelper: [FAIL]"; \
-                exit 1; \
-        fi
-
-run_tests: all fw_filesystem fw_userhelper
+install:
+ifdef INSTALL_KSFT_PATH
+	install ./fw_filesystem.sh ./fw_userhelper.sh $(INSTALL_KSFT_PATH)
+	@echo echo Start firmware filesystem test .... >> $(KSELFTEST)
+	@echo "$(fw_filesystem)" >> $(KSELFTEST)
+	@echo echo End firmware filesystem test .... >> $(KSELFTEST)
+	@echo echo -------------------- >> $(KSELFTEST)
+	@echo echo Start firmware userhelper test .... >> $(KSELFTEST)
+	@echo "$(fw_userhelper)" >> $(KSELFTEST)
+	@echo echo End firmware userhelper test .... >> $(KSELFTEST)
+	@echo echo ============================== >> $(KSELFTEST)
+else
+	@echo Run make kselftest_install in top level source directory
+endif
+
+run_tests:
+	@$(fw_filesystem)
+	@$(fw_userhelper)
 
 # Nothing to clean up.
 clean:
-- 
1.9.1

