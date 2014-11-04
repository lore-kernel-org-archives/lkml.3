Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaKDRSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:18:48 -0500
Received: from mailout.easymail.ca ([64.68.201.169]:50551 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaKDRSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:18:21 -0500
X-Quarantine-ID: <ZU4zpBbs4tHZ>
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
Subject: [PATCH 03/20] kbuild: kselftest_install - add a new make target to install selftests
Date: Tue,  4 Nov 2014 10:10:59 -0700
Message-Id: <66ccc558465313d98f3742c7b428efa0efdfbc3f.1415117102.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1415117102.git.shuahkh@osg.samsung.com>
References: <cover.1415117102.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1415117102.git.shuahkh@osg.samsung.com>
References: <cover.1415117102.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new make target to install to install kernel selftests.
This new target will build and install selftests.

Approach:

make kselftest_target:
-- exports kselftest INSTALL_KSFT_PATH
   default $(INSTALL_MOD_PATH)/lib/kselftest/$(KERNELRELEASE)
-- exports path for ksefltest.sh
-- runs selftests make install target:

selftests make install target
-- creates kselftest.sh script in install install dir
-- runs install targets for all INSTALL_TARGETS

Individual test make install targets:
-- install test programs and/or scripts in install dir
-- append to the ksefltest.sh file to add commands to run test

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 Makefile | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Makefile b/Makefile
index 05d67af..291aff7 100644
--- a/Makefile
+++ b/Makefile
@@ -1078,6 +1078,20 @@ kselftest:
 	$(Q)$(MAKE) -C tools/testing/selftests run_tests
 
 # ---------------------------------------------------------------------------
+# Kernel selftest install
+INSTALL_KSFT_PATH=$(INSTALL_MOD_PATH)/lib/kselftest/$(KERNELRELEASE)
+export INSTALL_KSFT_PATH
+KSELFTEST=$(INSTALL_KSFT_PATH)/kselftest.sh
+export KSELFTEST
+
+PHONY += kselftest_install
+kselftest_install:
+	@rm -rf $(INSTALL_KSFT_PATH)
+	@mkdir -p $(INSTALL_KSFT_PATH)
+	$(Q)$(MAKE) -C tools/testing/selftests install
+	chmod +x $(KSELFTEST)
+
+# ---------------------------------------------------------------------------
 # Modules
 
 ifdef CONFIG_MODULES
@@ -1285,6 +1299,9 @@ help:
 	@echo  '                    Build, install, and boot kernel before'
 	@echo  '                    running kselftest on it'
 	@echo  ''
+	@echo  '  kselftest_install - Install Kselftests to INSTALL_KSFT_PATH'
+	@echo  '                      default: $(INSTALL_MOD_PATH)/lib/kselftest/$(KERNELRELEASE)'
+	@echo  ''
 	@echo  'Kernel packaging:'
 	@$(MAKE) $(build)=$(package-dir) help
 	@echo  ''
-- 
1.9.1

