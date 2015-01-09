Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805AbbAIPKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:10:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37367 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757663AbbAIPKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:10:16 -0500
From: Michal Marek <mmarek@suse.cz>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        tomoyo-dev-en@lists.sourceforge.jp
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] tomoyo: Do not generate empty policy files
Date: Fri,  9 Jan 2015 16:08:54 +0100
Message-Id: <1420816134-12758-4-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1420816134-12758-1-git-send-email-mmarek@suse.cz>
References: <1420816134-12758-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Makefile automatically generates the tomoyo policy files, which are
not removed by make clean (because they could have been provided by the
user). Instead of generating the missing files, use /dev/null if a
given file is not provided. Store the default exception_policy in
exception_policy.conf.default.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 security/tomoyo/.gitignore                         |  2 +-
 security/tomoyo/Makefile                           | 30 ++--------------------
 .../tomoyo/policy/exception_policy.conf.default    |  2 ++
 3 files changed, 5 insertions(+), 29 deletions(-)
 create mode 100644 security/tomoyo/policy/exception_policy.conf.default

diff --git a/security/tomoyo/.gitignore b/security/tomoyo/.gitignore
index 5caf1a6..dc0f220 100644
--- a/security/tomoyo/.gitignore
+++ b/security/tomoyo/.gitignore
@@ -1,2 +1,2 @@
 builtin-policy.h
-policy/
+policy/*.conf
diff --git a/security/tomoyo/Makefile b/security/tomoyo/Makefile
index ccca034..65dbcb2 100644
--- a/security/tomoyo/Makefile
+++ b/security/tomoyo/Makefile
@@ -1,41 +1,15 @@
 obj-y = audit.o common.o condition.o domain.o environ.o file.o gc.o group.o load_policy.o memory.o mount.o network.o realpath.o securityfs_if.o tomoyo.o util.o
 
-$(obj)/policy/profile.conf:
-	@mkdir -p $(obj)/policy/
-	@echo Creating an empty policy/profile.conf
-	@touch $@
-
-$(obj)/policy/exception_policy.conf:
-	@mkdir -p $(obj)/policy/
-	@echo Creating a default policy/exception_policy.conf
-	@echo initialize_domain /sbin/modprobe from any >> $@
-	@echo initialize_domain /sbin/hotplug from any >> $@
-
-$(obj)/policy/domain_policy.conf:
-	@mkdir -p $(obj)/policy/
-	@echo Creating an empty policy/domain_policy.conf
-	@touch $@
-
-$(obj)/policy/manager.conf:
-	@mkdir -p $(obj)/policy/
-	@echo Creating an empty policy/manager.conf
-	@touch $@
-
-$(obj)/policy/stat.conf:
-	@mkdir -p $(obj)/policy/
-	@echo Creating an empty policy/stat.conf
-	@touch $@
-
 targets += builtin-policy.h
 define do_policy
 echo "static char tomoyo_builtin_$(1)[] __initdata ="; \
-$(objtree)/scripts/basic/bin2c <$(obj)/policy/$(1).conf; \
+$(objtree)/scripts/basic/bin2c <$(firstword $(wildcard $(obj)/policy/$(1).conf $(srctree)/$(src)/policy/$(1).conf.default) /dev/null); \
 echo ";"
 endef
 quiet_cmd_policy  = POLICY  $@
       cmd_policy  = ($(call do_policy,profile); $(call do_policy,exception_policy); $(call do_policy,domain_policy); $(call do_policy,manager); $(call do_policy,stat)) >$@
 
-$(obj)/builtin-policy.h: $(obj)/policy/profile.conf $(obj)/policy/exception_policy.conf $(obj)/policy/domain_policy.conf $(obj)/policy/manager.conf $(obj)/policy/stat.conf
+$(obj)/builtin-policy.h: $(wildcard $(obj)/policy/*.conf $(src)/policy/*.conf.default) FORCE
 	$(call if_changed,policy)
 
 $(obj)/common.o: $(obj)/builtin-policy.h
diff --git a/security/tomoyo/policy/exception_policy.conf.default b/security/tomoyo/policy/exception_policy.conf.default
new file mode 100644
index 0000000..2678df4
--- /dev/null
+++ b/security/tomoyo/policy/exception_policy.conf.default
@@ -0,0 +1,2 @@
+initialize_domain /sbin/modprobe from any
+initialize_domain /sbin/hotplug from any
-- 
2.1.2

