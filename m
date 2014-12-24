Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaLXQb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 11:31:58 -0500
Received: from resqmta-po-07v.sys.comcast.net ([96.114.154.166]:47000 "EHLO
	resqmta-po-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751683AbaLXQ2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 11:28:09 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mmarek@suse.cz, gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        keescook@chromium.org, tranmanphong@gmail.com, mpe@ellerman.id.au,
        cov@codeaurora.org, dh.herrmann@gmail.com, hughd@google.com,
        bobby.prani@gmail.com, serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        tim.bird@sonymobile.com, josh@joshtriplett.org, koct9i@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 08/20] selftests/memfd: add install target to enable test install
Date: Wed, 24 Dec 2014 09:27:44 -0700
Message-Id: <9ae1eafc12ee4ca5b1e73654b9e0bda2c5d75748.1419387513.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1419387513.git.shuahkh@osg.samsung.com>
References: <cover.1419387513.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1419387513.git.shuahkh@osg.samsung.com>
References: <cover.1419387513.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new make target to enable installing test. This target
installs test in the kselftest install location and add to the
kselftest script to run the test. Install target can be run
only from top level kernel source directory.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/memfd/Makefile | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/memfd/Makefile b/tools/testing/selftests/memfd/Makefile
index b80cd10..5f70b33 100644
--- a/tools/testing/selftests/memfd/Makefile
+++ b/tools/testing/selftests/memfd/Makefile
@@ -2,19 +2,30 @@ CFLAGS += -D_FILE_OFFSET_BITS=64
 CFLAGS += -I../../../../include/uapi/
 CFLAGS += -I../../../../include/
 
+INSTALL_PROGS = memfd_test fuse_test run_fuse_test.sh
+MEMFD_TEST_STR = ./memfd_test || echo memfd_test: [FAIL]
+FUSE_TEST_STR = ./run_fuse_test.sh || echo fuse_test: [FAIL]
+
 all:
 	gcc $(CFLAGS) memfd_test.c -o memfd_test
 
+install:
+ifdef INSTALL_KSFT_PATH
+	install $(INSTALL_PROGS) $(INSTALL_KSFT_PATH)
+	@echo "$(MEMFD_TEST_STR)" >> $(KSELFTEST)
+else
+	@echo Run make kselftest_install in top level source directory
+endif
+
 run_tests: all
-	gcc $(CFLAGS) memfd_test.c -o memfd_test
-	@./memfd_test || echo "memfd_test: [FAIL]"
+	@$(MEMFD_TEST_STR)
 
 build_fuse:
 	gcc $(CFLAGS) fuse_mnt.c `pkg-config fuse --cflags --libs` -o fuse_mnt
 	gcc $(CFLAGS) fuse_test.c -o fuse_test
 
 run_fuse: build_fuse
-	@./run_fuse_test.sh || echo "fuse_test: [FAIL]"
+	@$(FUSE_TEST_STR)
 
 clean:
 	$(RM) memfd_test fuse_test
-- 
2.1.0

