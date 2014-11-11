Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbaKKUa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 15:30:29 -0500
Received: from mailout.easymail.ca ([64.68.201.169]:48128 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaKKU23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 15:28:29 -0500
X-Quarantine-ID: <JtmZKwPx84lU>
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
Subject: [PATCH v2 13/19] selftests/mqueue: add install target to enable installing test
Date: Tue, 11 Nov 2014 13:27:53 -0700
Message-Id: <9d545d554e9159d67a31403bdef39db8c75225a4.1415735831.git.shuahkh@osg.samsung.com>
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
 tools/testing/selftests/mqueue/Makefile | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mqueue/Makefile b/tools/testing/selftests/mqueue/Makefile
index 8056e2e..7a7e5d3 100644
--- a/tools/testing/selftests/mqueue/Makefile
+++ b/tools/testing/selftests/mqueue/Makefile
@@ -1,10 +1,24 @@
+MQ_OPEN_TEST_STR = ./mq_open_tests /test1 || echo mq_open_tests: [FAIL]
+MQ_PERF_TEST_STR = ./mq_perf_tests || echo mq_perf_tests: [FAIL]
+
 all:
 	gcc -O2 mq_open_tests.c -o mq_open_tests -lrt
 	gcc -O2 -o mq_perf_tests mq_perf_tests.c -lrt -lpthread -lpopt
 
-run_tests:
-	@./mq_open_tests /test1 || echo "mq_open_tests: [FAIL]"
-	@./mq_perf_tests || echo "mq_perf_tests: [FAIL]"
+install:
+ifdef INSTALL_KSFT_PATH
+	install ./mq_open_tests ./mq_perf_tests $(INSTALL_KSFT_PATH)
+	@echo echo Start mqueue test .... >> $(KSELFTEST)
+	@echo "$(MQ_OPEN_TEST_STR)" >> $(KSELFTEST)
+	@echo "$(MQ_PERF_TEST_STR)" >> $(KSELFTEST)
+	@echo echo ============================== >> $(KSELFTEST)
+else
+	@echo Run make kselftest_install in top level source directory
+endif
+
+run_tests: all
+	@$(MQ_OPEN_TEST_STR)
+	@$(MQ_PERF_TEST_STR)
 
 clean:
 	rm -f mq_open_tests mq_perf_tests
-- 
1.9.1

