Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbaBHXF4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 18:05:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:8397 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbaBHXFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 18:05:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,808,1384329600"; 
   d="scan'208";a="471946178"
From: Andi Kleen <ak@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        torvalds@linux-foundation.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] kbuild: Support split debug info
Date: Sun,  9 Feb 2014 00:05:03 +0100
Message-Id: <1391900703-18163-1-git-send-email-ak@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an alternative approach to lower the overhead of debug info
(as we discussed a few days ago)

gcc 4.7+ and newer binutils have a new "split debug info" debug info
model where the debug info is only written once into central ".dwo" files.

This avoids having to copy it around multiple times, from the object
files to the final executable. It also lowers the disk space
requirement. In addition it defaults to compressed debug data.

More details here: http://gcc.gnu.org/wiki/DebugFission

This patch adds a new option to enable it. It has to be an option,
because it'll undoubtedly break everyone's debuginfo packaging scheme.
gdb/objdump/etc. all still work, if you have new enough versions.

I don't see big compile wins (maybe a second or two faster or so), but the
object dirs with debuginfo get significantly smaller. My standard kernel
config (slightly bigger than defconfig) goes from 2.9G disk space
to 1.1G objdir (without debuginfo reduced). I presume if you are IO limited
it will also compile faster.

Only problem I've seen so far is that it doesn't play well with ccache.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Makefile          |  6 ++++++
 lib/Kconfig.debug | 13 +++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/Makefile b/Makefile
index 606ef7c..2f3d9d1 100644
--- a/Makefile
+++ b/Makefile
@@ -638,7 +638,11 @@ endif
 endif
 
 ifdef CONFIG_DEBUG_INFO
+ifdef CONFIG_DEBUG_INFO_SPLIT
+KBUILD_CFLAGS   += $(call cc-option, -gsplit-dwarf, -g)
+else
 KBUILD_CFLAGS	+= -g
+endif
 KBUILD_AFLAGS	+= -Wa,--gdwarf-2
 endif
 
@@ -1072,6 +1076,8 @@ MRPROPER_FILES += .config .config.old .version .old_version $(version_h) \
 		  extra_certificates signing_key.x509.keyid		\
 		  signing_key.x509.signer
 
+CLEAN_FILES += .*.dwo
+
 # clean - Delete most, but leave enough to build external modules
 #
 clean: rm-dirs  := $(CLEAN_DIRS)
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a48abea..367a6ba 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -143,6 +143,19 @@ config DEBUG_INFO_REDUCED
 	  DEBUG_INFO build and compile times are reduced too.
 	  Only works with newer gcc versions.
 
+config DEBUG_INFO_SPLIT
+	bool "Produce split debuginfo in .dwo files"
+	depends on DEBUG_INFO
+	help
+	  Generate debug info into separate .dwo files. This can be
+	  faster for building than including the debug information directly
+	  in the object files and the vmlinux, as it only needs to 
+	  be stored once to disk, not multiple times in object files.
+	  Requires recent gcc (4.8+) and recent gdb/binutils.
+	  Any tool that packages or reads debug information would need
+	  to know about the .dwo files and include them.
+	  Currently incompatible with ccache.
+
 config ENABLE_WARN_DEPRECATED
 	bool "Enable __deprecated logic"
 	default y
-- 
1.8.5.2

