Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab3CUKwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:52:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55973 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab3CUKwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:52:50 -0400
Date: Thu, 21 Mar 2013 03:50:36 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-a50e43332756a5ac8d00f3367a54d9effeb9c674@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, rostedt@goodmis.org, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, rostedt@goodmis.org, tglx@linutronix.de, bp@suse.de
In-Reply-To: <1361374353-30385-3-git-send-email-bp@alien8.de>
References: <1361374353-30385-3-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Honor parallel jobs
Git-Commit-ID: a50e43332756a5ac8d00f3367a54d9effeb9c674
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 03:50:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a50e43332756a5ac8d00f3367a54d9effeb9c674
Gitweb:     http://git.kernel.org/tip/a50e43332756a5ac8d00f3367a54d9effeb9c674
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Wed, 20 Feb 2013 16:32:28 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:05:59 -0300

perf tools: Honor parallel jobs

We need to hand down parallel build options like the internal make
--jobserver-fds one so that parallel builds can also happen when
building perf from the toplevel directory.

Make it so #1!

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1361374353-30385-3-git-send-email-bp@alien8.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 Makefile                       | 4 ++--
 tools/scripts/Makefile.include | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 6fccf65..bbb15df 100644
--- a/Makefile
+++ b/Makefile
@@ -1331,11 +1331,11 @@ kernelversion:
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
index 2964b96..00a05f4 100644
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
