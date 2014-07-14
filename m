Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbaGNPSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:18:08 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48429 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033AbaGNPJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:09:22 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>
Subject: [PATCH 08/38] kbuild: drop support for non uapi Kbuild files in headers_install
Date: Mon, 14 Jul 2014 17:08:36 +0200
Message-Id: <1405350546-28467-8-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405350546-28467-1-git-send-email-sam@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no more Kbuild files outside uapi directories used
for exported headers so drop support for these.
Also update documentation to reference the correct files.
Except for destination-y which has no in-tree users at the moment.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: David Howells <dhowells@redhat.com>
---
 Documentation/kbuild/makefiles.txt |  4 ++--
 scripts/Makefile.headersinst       | 17 +----------------
 2 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index c600e2f..98b89bf 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -1294,7 +1294,7 @@ See subsequent chapter for the syntax of the Kbuild file.
 	header-y specify header files to be exported.
 
 		Example:
-			#include/linux/Kbuild
+			#include/linux/uapi/Kbuild
 			header-y += usb/
 			header-y += aio_abi.h
 
@@ -1314,7 +1314,7 @@ See subsequent chapter for the syntax of the Kbuild file.
 	up in another directory when doing 'make O=...' builds.
 
 		Example:
-			#include/linux/Kbuild
+			#include/linux/uapi/Kbuild
 			genhdr-y += version.h
 
 	--- 7.3 destination-y
diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 8ccf830..3f72031 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -16,11 +16,6 @@ include $(kbuild-file)
 # called may set destination dir (when installing to asm/)
 _dst := $(if $(destination-y),$(destination-y),$(if $(dst),$(dst),$(obj)))
 
-old-kbuild-file := $(srctree)/$(subst uapi/,,$(obj))/Kbuild
-ifneq ($(wildcard $(old-kbuild-file)),)
-include $(old-kbuild-file)
-endif
-
 include scripts/Kbuild.include
 
 installdir    := $(INSTALL_HDR_PATH)/$(subst uapi/,,$(_dst))
@@ -40,8 +35,6 @@ wrapper-files := $(filter $(header-y), $(generic-y))
 srcdir        := $(srctree)/$(obj)
 gendir        := $(objtree)/$(gen)
 
-oldsrcdir     := $(srctree)/$(subst /uapi,,$(obj))
-
 # all headers files for this dir
 header-y      := $(filter-out $(generic-y), $(header-y))
 all-files     := $(header-y) $(genhdr-y) $(wrapper-files)
@@ -52,13 +45,6 @@ input-files1  := $(foreach hdr, $(header-y), \
 			$(wildcard $(srcdir)/$(hdr))) \
 		   )
 input-files1-name := $(notdir $(input-files1))
-input-files2  := $(foreach hdr, $(header-y), \
-		   $(if  $(wildcard $(srcdir)/$(hdr)),, \
-			$(if $(wildcard $(oldsrcdir)/$(hdr)), \
-				$(wildcard $(oldsrcdir)/$(hdr)), \
-				$(error Missing UAPI file $(srcdir)/$(hdr))) \
-		   ))
-input-files2-name := $(notdir $(input-files2))
 input-files3  := $(foreach hdr, $(genhdr-y), \
 		   $(if	$(wildcard $(gendir)/$(hdr)), \
 			$(wildcard $(gendir)/$(hdr)), \
@@ -79,7 +65,6 @@ quiet_cmd_install = INSTALL $(printdir) ($(words $(all-files))\
                             file$(if $(word 2, $(all-files)),s))
       cmd_install = \
         $(CONFIG_SHELL) $< $(installdir) $(srcdir) $(input-files1-name); \
-        $(CONFIG_SHELL) $< $(installdir) $(oldsrcdir) $(input-files2-name); \
         $(CONFIG_SHELL) $< $(installdir) $(gendir) $(input-files3-name); \
         for F in $(wrapper-files); do                                   \
                 echo "\#include <asm-generic/$$F>" > $(installdir)/$$F;    \
@@ -106,7 +91,7 @@ __headersinst: $(subdirs) $(install-file)
 	@:
 
 targets += $(install-file)
-$(install-file): scripts/headers_install.sh $(input-files1) $(input-files2) $(input-files3) FORCE
+$(install-file): scripts/headers_install.sh $(input-files1) $(input-files3) FORCE
 	$(if $(unwanted),$(call cmd,remove),)
 	$(if $(wildcard $(dir $@)),,$(shell mkdir -p $(dir $@)))
 	$(call if_changed,install)
-- 
1.9.3

