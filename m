Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934294Ab3CMViU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 17:38:20 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:46756 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab3CMViT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 17:38:19 -0400
X-Originating-IP: 67.232.160.146
Date: Wed, 13 Mar 2013 14:38:13 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs: Make binfmt support for #! scripts modular and removable
Message-ID: <20130313213810.GA12653@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new configuration option CONFIG_BINFMT_SCRIPT to configure support
for interpreted scripts starting with "#!"; allow compiling out that
support, or building it as a module.  Embedded systems running
exclusively compiled binaries could leave this support out, and systems
that don't need scripts before mounting the root filesystem can build
this as a module.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

Note when testing this that many shells implement support for shell
scripts themselves, so try it with something like #!/bin/cat instead.

 fs/Kconfig.binfmt |   14 ++++++++++++++
 fs/Makefile       |    5 +----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index 0efd152..370b24c 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -65,6 +65,20 @@ config CORE_DUMP_DEFAULT_ELF_HEADERS
 	  This config option changes the default setting of coredump_filter
 	  seen at boot time.  If unsure, say Y.
 
+config BINFMT_SCRIPT
+	tristate "Kernel support for scripts starting with #!"
+	default y
+	help
+	  Say Y here if you want to execute interpreted scripts starting with
+	  #! followed by the path to an interpreter.
+
+	  You can build this support as a module; however, until that module
+	  gets loaded, you cannot run scripts.  Thus, if you want to load this
+	  module from an initramfs, the portion of the initramfs before loading
+	  this module must consist of compiled binaries only.
+
+	  Most systems will not boot if you say M or N here.  If unsure, say Y.
+
 config BINFMT_FLAT
 	bool "Kernel support for flat binaries"
 	depends on !MMU && (!FRV || BROKEN)
diff --git a/fs/Makefile b/fs/Makefile
index 9d53192..2ef3298 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -34,10 +34,7 @@ obj-$(CONFIG_COMPAT)		+= compat.o compat_ioctl.o
 obj-$(CONFIG_BINFMT_AOUT)	+= binfmt_aout.o
 obj-$(CONFIG_BINFMT_EM86)	+= binfmt_em86.o
 obj-$(CONFIG_BINFMT_MISC)	+= binfmt_misc.o
-
-# binfmt_script is always there
-obj-y				+= binfmt_script.o
-
+obj-$(CONFIG_BINFMT_SCRIPT)	+= binfmt_script.o
 obj-$(CONFIG_BINFMT_ELF)	+= binfmt_elf.o
 obj-$(CONFIG_COMPAT_BINFMT_ELF)	+= compat_binfmt_elf.o
 obj-$(CONFIG_BINFMT_ELF_FDPIC)	+= binfmt_elf_fdpic.o
-- 
1.7.10.4

