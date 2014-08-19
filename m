Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbaHSTHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 15:07:43 -0400
Received: from fr1.as29.net ([62.210.131.231]:39628 "EHLO
	toothrot.meleeweb.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbaHSTHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 15:07:19 -0400
From: Bertrand Jacquin <beber@meleeweb.net>
To: Rusty Russell <rusty@rustcorp.com.au>, linux-kbuild@vger.kernel.org
Cc: Bertrand Jacquin <beber@meleeweb.net>, linux-kernel@vger.kernel.org,
        Willy Tarreau <w@1wt.eu>
Subject: [PATCH 2/3] kbuild: handle module compression while running 'make modules_install'.
Date: Tue, 19 Aug 2014 20:57:39 +0200
Message-Id: <1408474660-24999-3-git-send-email-beber@meleeweb.net>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1408474660-24999-1-git-send-email-beber@meleeweb.net>
References: <1408474660-24999-1-git-send-email-beber@meleeweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since module-init-tools (gzip) and kmod (gzip and xz) support compressed
modules, it could be useful to include a support for compressing modules
right after having them installed. Doing this in kbuild instead of per
distro can permit to make this kind of usage more generic.

This patch add a Kconfig entry to "Enable loadable module support" menu
and let you choose to compress using gzip (default) or xz.

Both gzip and xz does not used any extra -[1-9] option since Andi Kleen
and Rusty Russell prove no gain is made using them. gzip is called with -n
argument to avoid storing original filename inside compressed file, that
way we can save some more bytes.

On a v3.16 kernel, 'make allmodconfig' generated 4680 modules for a
total of 378MB (no strip, no sign, no compress), the following table
shows observed disk space gain based on the allmodconfig .config :

       |           time                |
       +-------------+-----------------+
       | manual .ko  |       make      | size | percent
       | compression | modules_install |      | gain
       +-------------+-----------------+------+--------
  -    |             |     18.61s      | 378M |
  GZIP |   3m16s     |     3m37s       | 102M | 73.41%
  XZ   |   5m22s     |     5m39s       |  77M | 79.83%

The gain for restricted environnement seems to be interesting while
uncompress can be time consuming but happens only while loading a module,
that is generally done only once.

This is fully compatible with signed modules while the signed module is
compressed. module-init-tools or kmod handles decompression
and provide to other layer the uncompressed but signed payload.

Reviewed-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Bertrand Jacquin <beber@meleeweb.net>
---
 Makefile                 | 15 +++++++++++++++
 init/Kconfig             | 43 +++++++++++++++++++++++++++++++++++++++++++
 scripts/Makefile.modinst |  3 ++-
 3 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index e432442..300ff99 100644
--- a/Makefile
+++ b/Makefile
@@ -842,6 +842,21 @@ mod_strip_cmd = true
 endif # INSTALL_MOD_STRIP
 export mod_strip_cmd
 
+# CONFIG_MODULE_COMPRESS, if defined, will cause module to be compressed
+# after they are installed in agreement with CONFIG_MODULE_COMPRESS_GZIP
+# or CONFIG_MODULE_COMPRESS_XZ.
+
+mod_compress_cmd = true
+ifdef CONFIG_MODULE_COMPRESS
+  ifdef CONFIG_MODULE_COMPRESS_GZIP
+    mod_compress_cmd = gzip -n
+  endif # CONFIG_MODULE_COMPRESS_GZIP
+  ifdef CONFIG_MODULE_COMPRESS_XZ
+    mod_compress_cmd = xz
+  endif # CONFIG_MODULE_COMPRESS_XZ
+endif # CONFIG_MODULE_COMPRESS
+export mod_compress_cmd
+
 # Select initial ramdisk compression format, default is gzip(1).
 # This shall be used by the dracut(8) tool while creating an initramfs image.
 #
diff --git a/init/Kconfig b/init/Kconfig
index e84c642..4980925 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1906,6 +1906,49 @@ config MODULE_SIG_HASH
 	default "sha384" if MODULE_SIG_SHA384
 	default "sha512" if MODULE_SIG_SHA512
 
+config MODULE_COMPRESS
+	bool "Compress modules on installation"
+	depends on MODULES
+	help
+	  This option compresses the kernel modules when 'make
+	  modules_install' is run.
+
+	  The modules will be compressed either using gzip or xz depend on the
+	  choice made in "Compression algorithm".
+
+	  module-init-tools has support for gzip format while kmod handle gzip
+	  and xz compressed modules.
+
+	  When a kernel module is installed from outside of the main kernel
+	  source and uses the Kbuild system for installing modules then that
+	  kernel module will also be compressed when it is installed.
+
+	  This option provides little benefit when the modules are to be used inside
+	  an initrd or initramfs, it generally is more efficient to compress the whole
+	  initrd or initramfs instead.
+
+	  This is fully compatible with signed modules while the signed module is
+	  compressed. module-init-tools or kmod handles decompression and provide to
+	  other layer the uncompressed but signed payload.
+
+choice
+	prompt "Compression algorithm"
+	depends on MODULE_COMPRESS
+	default MODULE_COMPRESS_GZIP
+	help
+	  This determines which sort of compression will be used during
+	  'make modules_install'.
+
+	  GZIP (default) and XZ are supported.
+
+config MODULE_COMPRESS_GZIP
+	bool "GZIP"
+
+config MODULE_COMPRESS_XZ
+	bool "XZ"
+
+endchoice
+
 endif # MODULES
 
 config INIT_ALL_POSSIBLE
diff --git a/scripts/Makefile.modinst b/scripts/Makefile.modinst
index aa911b5..e48a4e9 100644
--- a/scripts/Makefile.modinst
+++ b/scripts/Makefile.modinst
@@ -22,7 +22,8 @@ quiet_cmd_modules_install = INSTALL $@
     mkdir -p $(2) ; \
     cp $@ $(2) ; \
     $(mod_strip_cmd) $(2)/$(notdir $@) ; \
-    $(mod_sign_cmd) $(2)/$(notdir $@) $(patsubst %,|| true,$(KBUILD_EXTMOD))
+    $(mod_sign_cmd) $(2)/$(notdir $@) $(patsubst %,|| true,$(KBUILD_EXTMOD)) ; \
+    $(mod_compress_cmd) $(2)/$(notdir $@)
 
 # Modules built outside the kernel source tree go into extra by default
 INSTALL_MOD_DIR ?= extra
-- 
2.0.4

