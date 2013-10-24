Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab3JXTPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 15:15:47 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:53605 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab3JXTOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 15:14:44 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH trace-cmd 2/5] build: Install data files without execute permissions
Date: Thu, 24 Oct 2013 14:14:31 -0500
Message-Id: <1382642074-15567-3-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382642074-15567-1-git-send-email-seth.forshee@canonical.com>
References: <1382642074-15567-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Libraries and data files should not be installed with execute
permissions as is currently the case. Add do_data_install
functions to the makefiles to install data without execute
permissions and use this for installing all data files.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 Documentation/Makefile | 13 +++++++------
 Makefile               | 24 ++++++++++++++++++------
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index ad53c3b..21e42fd 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -73,21 +73,22 @@ all: $(MAN1) $(MAN5)
 
 # Need to find out how to export a macro instead of
 # copying this from the main Makefile.
-define do_install
+define do_install_data
 	$(print_install)				\
 	if [ ! -d '$(DESTDIR_SQ)$2' ]; then		\
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$2';	\
 	fi;						\
-	$(INSTALL) $1 '$(DESTDIR_SQ)$2'
+	$(INSTALL) -m 644 $1 '$(DESTDIR_SQ)$2'
 endef
 
+
 MAN1_INSTALL = $(MAN1:%.1=%.1.install)
 MAN5_INSTALL = $(MAN5:%.5=%.5.install)
 
 $(MAN1_INSTALL): %.1.install : %.1 force
-	$(Q)$(call do_install,$<,$(man_dir_SQ)/man1)
+	$(Q)$(call do_install_data,$<,$(man_dir_SQ)/man1)
 $(MAN5_INSTALL): %.5.install : %.5 force
-	$(Q)$(call do_install,$<,$(man_dir_SQ)/man5)
+	$(Q)$(call do_install_data,$<,$(man_dir_SQ)/man5)
 
 html_dir = $(src)/HTML
 image_dir = $(html_dir)/images
@@ -99,10 +100,10 @@ HTML_INSTALL = $(subst .html,.html.install,$(HTML))
 IMGS_INSTALL = $(subst .png,.png.install,$(IMGS))
 
 $(HTML_INSTALL): %.html.install : %.html force
-	$(Q)$(call do_install,$<,'$(html_install_SQ)')
+	$(Q)$(call do_install_data,$<,'$(html_install_SQ)')
 
 $(IMGS_INSTALL): %.png.install : %.png force
-	$(Q)$(call do_install,$<,'$(img_install_SQ)')
+	$(Q)$(call do_install_data,$<,'$(img_install_SQ)')
 
 
 GUI_INSTALL = $(HTML_INSTALL) $(IMGS_INSTALL)
diff --git a/Makefile b/Makefile
index 1964949..2423038 100644
--- a/Makefile
+++ b/Makefile
@@ -86,7 +86,8 @@ ifeq ($(shell sh -c "python-config --includes > /dev/null 2>&1 && echo y"), y)
 	PYTHON_PLUGINS := plugin_python.so
 	BUILD_PYTHON := $(PYTHON) $(PYTHON_PLUGINS)
 	PYTHON_SO_INSTALL := ctracecmd.install
-	PYTHON_PY_INSTALL := event-viewer.install tracecmd.install tracecmdgui.install
+	PYTHON_PY_PROGS := event-viewer.install
+	PYTHON_PY_LIBS := tracecmd.install tracecmdgui.install
 endif
 endif # NO_PYTHON
 
@@ -506,21 +507,32 @@ define do_install
 	$(INSTALL) $1 '$(DESTDIR_SQ)$2'
 endef
 
+define do_install_data
+	$(print_install)				\
+	if [ ! -d '$(DESTDIR_SQ)$2' ]; then		\
+		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$2';	\
+	fi;						\
+	$(INSTALL) -m 644 $1 '$(DESTDIR_SQ)$2'
+endef
+
 $(PLUGINS_INSTALL): %.install : %.so force
-	$(Q)$(call do_install,$<,$(plugin_dir_SQ))
+	$(Q)$(call do_install_data,$<,$(plugin_dir_SQ))
 
 install_plugins: $(PLUGINS_INSTALL)
 
 $(PYTHON_SO_INSTALL): %.install : %.so force
-	$(Q)$(call do_install,$<,$(python_dir_SQ))
+	$(Q)$(call do_install_data,$<,$(python_dir_SQ))
 
-$(PYTHON_PY_INSTALL): %.install : %.py force
+$(PYTHON_PY_PROGS): %.install : %.py force
 	$(Q)$(call do_install,$<,$(python_dir_SQ))
 
+$(PYTHON_PY_LIBS): %.install : %.py force
+	$(Q)$(call do_install_data,$<,$(python_dir_SQ))
+
 $(PYTHON_PY_PLUGINS): %.install : %.py force
-	$(Q)$(call do_install,$<,$(plugin_dir_SQ))
+	$(Q)$(call do_install_data,$<,$(plugin_dir_SQ))
 
-install_python: $(PYTHON_SO_INSTALL) $(PYTHON_PY_INSTALL) $(PYTHON_PY_PLUGINS)
+install_python: $(PYTHON_SO_INSTALL) $(PYTHON_PY_PROGS) $(PYTHON_PY_LIBS) $(PYTHON_PY_PLUGINS)
 
 install_cmd: all_cmd install_plugins install_python
 	$(Q)$(call do_install,trace-cmd,$(bindir_SQ))
-- 
1.8.3.2

