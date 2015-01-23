Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbbAWBUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 20:20:54 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:55083 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbbAWBUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 20:20:52 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH] modsign: provide option to automatically delete the key after modules were installed
Date: Fri, 23 Jan 2015 02:20:09 +0100
Message-Id: <1421976009-9819-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 2.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I usually throw away (delete) the key used to sign modules after having
called make -jN (b)zImage modules && make -jN modules_install. Because I've
got bored to always have to type rm signing_key.* afterwards, I've build
this patch some time ago.
As I'm not eager anymore to publish kernel patches, it rested in my private
chest of patches until I've seen the keynote of Linux.conf.au 2015. It made
me aware that this patch might have a chance to become included. ;)

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 Makefile     |  7 +++++++
 init/Kconfig | 12 ++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/Makefile b/Makefile
index fb93350..95e07ca 100644
--- a/Makefile
+++ b/Makefile
@@ -1129,6 +1129,13 @@ _modinst_:
 	@cp -f $(objtree)/modules.order $(MODLIB)/
 	@cp -f $(objtree)/modules.builtin $(MODLIB)/
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst
+ifeq ($(CONFIG_MODULE_SIG_THROW_AWAY), y)
+	@echo "###"
+	@echo "### Deleting key used to sign modules."
+	@echo "###"
+	@rm ./signing_key.priv
+	@rm ./signing_key.x509
+endif
 
 # This depmod is only for convenience to give the initial
 # boot a modules.dep even before / is mounted read-write.  However the
diff --git a/init/Kconfig b/init/Kconfig
index 9afb971..f29304e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1884,6 +1884,18 @@ config MODULE_SIG_ALL
 	  Sign all modules during make modules_install. Without this option,
 	  modules must be signed manually, using the scripts/sign-file tool.
 
+config MODULE_SIG_THROW_AWAY
+	bool "Automatically delete the key after modules were installed"
+	default n
+	depends on MODULE_SIG_ALL
+	help
+	  Delete the key used to sign modules after modules were installed.
+	  Be aware of the consequences. The downside is that you  won't be
+	  able to build any module for a (maybe running) kernel, but will
+	  have to rebuild the kernel and all modules in order to add or modify
+	  a module. The upside is that you don't have to secure the key in
+	  order to keep a running kernel safe from unwanted modules.
+
 comment "Do not forget to sign required modules with scripts/sign-file"
 	depends on MODULE_SIG_FORCE && !MODULE_SIG_ALL
 
-- 
2.0.5

