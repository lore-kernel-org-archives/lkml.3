Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935730Ab3BTPcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 10:32:39 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50988 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933906Ab3BTPch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 10:32:37 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 2/7] perf: Honor parallel jobs
Date: Wed, 20 Feb 2013 16:32:28 +0100
Message-Id: <1361374353-30385-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1361374353-30385-1-git-send-email-bp@alien8.de>
References: <1361374353-30385-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

We need to hand down parallel build options like the internal make
--jobserver-fds one so that parallel builds can also happen when
building perf from the toplevel directory.

Make it so #1!

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 Makefile                       | 4 ++--
 tools/scripts/Makefile.include | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 2cd4c6be44f2..f14a9c9672be 100644
--- a/Makefile
+++ b/Makefile
@@ -1330,11 +1330,11 @@ kernelversion:
 # Clear a bunch of variables before executing the submake
 tools/: FORCE
 	$(Q)mkdir -p $(objtree)/tools
-	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= O=$(objtree) subdir=tools -C $(src)/tools/
+	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS="$(filter --j% -j,$(MAKEFLAGS))" O=$(objtree) subdir=tools -C $(src)/tools/
 
 tools/%: FORCE
 	$(Q)mkdir -p $(objtree)/tools
-	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= O=$(objtree) subdir=tools -C $(src)/tools/ $*
+	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS="$(filter --j% -j,$(MAKEFLAGS))" O=$(objtree) subdir=tools -C $(src)/tools/ $*
 
 # Single targets
 # ---------------------------------------------------------------------------
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 2964b96aa55f..00a05f45b39a 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -70,7 +70,7 @@ ifndef V
 	QUIET_BISON    = @echo '   ' BISON $@;
 
 	descend = \
-		@echo '   ' DESCEND $(1); \
+		+@echo '   ' DESCEND $(1); \
 		mkdir -p $(OUTPUT)$(1) && \
 		$(MAKE) $(COMMAND_O) subdir=$(if $(subdir),$(subdir)/$(1),$(1)) $(PRINT_DIR) -C $(1) $(2)
 endif
-- 
1.8.1.3.535.ga923c31

