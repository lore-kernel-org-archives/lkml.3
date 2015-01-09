Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbbAIPKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:10:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757255AbbAIPKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:10:16 -0500
From: Michal Marek <mmarek@suse.cz>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        tomoyo-dev-en@lists.sourceforge.jp
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] tomoyo: Use if_changed when generating builtin-policy.h
Date: Fri,  9 Jan 2015 16:08:53 +0100
Message-Id: <1420816134-12758-3-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1420816134-12758-1-git-send-email-mmarek@suse.cz>
References: <1420816134-12758-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 security/tomoyo/Makefile | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/security/tomoyo/Makefile b/security/tomoyo/Makefile
index a6c02a5..ccca034 100644
--- a/security/tomoyo/Makefile
+++ b/security/tomoyo/Makefile
@@ -26,23 +26,16 @@ $(obj)/policy/stat.conf:
 	@echo Creating an empty policy/stat.conf
 	@touch $@
 
+targets += builtin-policy.h
+define do_policy
+echo "static char tomoyo_builtin_$(1)[] __initdata ="; \
+$(objtree)/scripts/basic/bin2c <$(obj)/policy/$(1).conf; \
+echo ";"
+endef
+quiet_cmd_policy  = POLICY  $@
+      cmd_policy  = ($(call do_policy,profile); $(call do_policy,exception_policy); $(call do_policy,domain_policy); $(call do_policy,manager); $(call do_policy,stat)) >$@
+
 $(obj)/builtin-policy.h: $(obj)/policy/profile.conf $(obj)/policy/exception_policy.conf $(obj)/policy/domain_policy.conf $(obj)/policy/manager.conf $(obj)/policy/stat.conf
-	@echo Generating built-in policy for TOMOYO 2.5.x.
-	@echo "static char tomoyo_builtin_profile[] __initdata =" > $@.tmp
-	@$(objtree)/scripts/basic/bin2c < $(obj)/policy/profile.conf >> $@.tmp
-	@echo ";" >> $@.tmp
-	@echo "static char tomoyo_builtin_exception_policy[] __initdata =" >> $@.tmp
-	@$(objtree)/scripts/basic/bin2c < $(obj)/policy/exception_policy.conf >> $@.tmp
-	@echo ";" >> $@.tmp
-	@echo "static char tomoyo_builtin_domain_policy[] __initdata =" >> $@.tmp
-	@$(objtree)/scripts/basic/bin2c < $(obj)/policy/domain_policy.conf >> $@.tmp
-	@echo ";" >> $@.tmp
-	@echo "static char tomoyo_builtin_manager[] __initdata =" >> $@.tmp
-	@$(objtree)/scripts/basic/bin2c < $(obj)/policy/manager.conf >> $@.tmp
-	@echo ";" >> $@.tmp
-	@echo "static char tomoyo_builtin_stat[] __initdata =" >> $@.tmp
-	@$(objtree)/scripts/basic/bin2c < $(obj)/policy/stat.conf >> $@.tmp
-	@echo ";" >> $@.tmp
-	@mv $@.tmp $@
+	$(call if_changed,policy)
 
 $(obj)/common.o: $(obj)/builtin-policy.h
-- 
2.1.2

