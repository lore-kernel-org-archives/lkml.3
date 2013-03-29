Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab3C2As6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 20:48:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:1119 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753570Ab3C2As5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 20:48:57 -0400
X-IronPort-AV: E=Sophos;i="4.87,370,1363104000"; 
   d="scan'208";a="6965405"
From: liguang <lig.fnst@cn.fujitsu.com>
To: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH][update] Makefile: allow no update .config build
Date: Fri, 29 Mar 2013 08:46:37 +0800
Message-Id: <1364517997-24067-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/29 08:48:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/29 08:48:05,
	Serialize complete at 2013/03/29 08:48:05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if we pull some commits from other git repo
which bring in a few CONFIG_* options, then
we have to build all again, but we do assure
these options are not interesting for us,
so the long waiting build will be offending.
this change help us to avoid all-build.

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 Makefile |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index 54d2b2a..d10e505 100644
--- a/Makefile
+++ b/Makefile
@@ -106,6 +106,12 @@ ifeq ("$(origin W)", "command line")
   export KBUILD_ENABLE_EXTRA_GCC_CHECKS := $(W)
 endif
 
+# KBUILD_NCU is set to do not update .config even
+# a few new CONFIG_* options appeared
+ifeq ("$(origin NCU)", "command line")
+  KBUILD_NCU := $(NCU)
+endif
+
 # That's our default target when none is given on the command line
 PHONY := _all
 _all:
@@ -540,8 +546,10 @@ $(KCONFIG_CONFIG) include/config/auto.conf.cmd: ;
 # with it and forgot to run make oldconfig.
 # if auto.conf.cmd is missing then we are probably in a cleaned tree so
 # we execute the config step to be sure to catch updated Kconfig files
+ifneq ($(KBUILD_NCU), 1)
 include/config/%.conf: $(KCONFIG_CONFIG) include/config/auto.conf.cmd
 	$(Q)$(MAKE) -f $(srctree)/Makefile silentoldconfig
+endif # $(KBUILD_NCU)
 else
 # external modules needs include/generated/autoconf.h and include/config/auto.conf
 # but do not care if they are up-to-date. Use auto.conf to trigger the test
@@ -1157,6 +1165,7 @@ help:
 	@echo  '		2: warnings which occur quite often but may still be relevant'
 	@echo  '		3: more obscure warnings, can most likely be ignored'
 	@echo  '		Multiple levels can be combined with W=12 or W=123'
+	@echo  '  make NCU=1 [targets] no .config update'
 	@echo  ''
 	@echo  'Execute "make" or "make all" to build all targets marked with [*] '
 	@echo  'For further info see the ./README file'
-- 
1.7.2.5

