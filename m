Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707AbbAFToA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:44:00 -0500
Received: from resqmta-ch2-08v.sys.comcast.net ([69.252.207.40]:60973 "EHLO
	resqmta-ch2-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932669AbbAFTnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:43:55 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mmarek@suse.cz, gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        keescook@chromium.org, tranmanphong@gmail.com, mpe@ellerman.id.au,
        cov@codeaurora.org, dh.herrmann@gmail.com, hughd@google.com,
        bobby.prani@gmail.com, serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        tim.bird@sonymobile.com, josh@joshtriplett.org, koct9i@gmail.com,
        masami.hiramatsu.pt@hitachi.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v4 08/20] selftests/memfd: add install target to enable test install
Date: Tue,  6 Jan 2015 12:43:22 -0700
Message-Id: <4353762c318dad84798bb9f45bb338be7bb3891f.1420571615.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1420571615.git.shuahkh@osg.samsung.com>
References: <cover.1420571615.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1420571615.git.shuahkh@osg.samsung.com>
References: <cover.1420571615.git.shuahkh@osg.samsung.com>
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
index b80cd10..23c84bf 100644
--- a/tools/testing/selftests/memfd/Makefile
+++ b/tools/testing/selftests/memfd/Makefile
@@ -2,19 +2,30 @@ CFLAGS += -D_FILE_OFFSET_BITS=64
 CFLAGS += -I../../../../include/uapi/
 CFLAGS += -I../../../../include/
 
+INSTALL_PROGS = memfd_test fuse_test run_fuse_test.sh
+MEMFD_TEST_STR = ./memfd_test || echo 'memfd_test: [FAIL]'
+FUSE_TEST_STR = ./run_fuse_test.sh || echo 'fuse_test: [FAIL]'
+
 all:
 	gcc $(CFLAGS) memfd_test.c -o memfd_test
 
+install:
+ifdef INSTALL_KSFT_PATH
+	install $(INSTALL_PROGS) $(INSTALL_KSFT_PATH)
+	@echo "$(MEMFD_TEST_STR)" >> $(KSELFTEST)
+else
+	@echo "Run make kselftest_install in top level source directory"
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

