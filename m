Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbaG2XMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:12:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:53682 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbaG2XMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:12:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,760,1400050800"; 
   d="scan'208";a="580884487"
From: Andi Kleen <andi@firstfloor.org>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Dirk Gouders <dirk@gouders.net>
Subject: [PATCH 1/2] kbuild: Support split debug info v4
Date: Wed, 30 Jul 2014 01:11:32 +0200
Message-Id: <1406675493-2539-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This is an alternative approach to lower the overhead of debug info
(as we discussed a few days ago)

gcc 4.7+ and newer binutils have a new "split debug info" debug info
model where the debug info is only written once into central ".dwo" files.

This avoids having to copy it around multiple times, from the object
files to the final executable. It lowers the disk space
requirements. In addition it defaults to compressed debug data.

More details here: http://gcc.gnu.org/wiki/DebugFission

This patch adds a new option to enable it. It has to be an option,
because it'll undoubtedly break everyone's debuginfo packaging scheme.
gdb/objdump/etc. all still work, if you have new enough versions.

I don't see big compile wins (maybe a second or two faster or so), but the
object dirs with debuginfo get significantly smaller. My standard kernel
config (slightly bigger than defconfig) shrinks from 2.9G disk space
to 1.1G objdir (with non reduced debuginfo). I presume if you are IO limited
the compile time difference will be larger.

Only problem I've seen so far is that it doesn't play well with older
versions of ccache (apparently fixed, see
https://bugzilla.samba.org/show_bug.cgi?id=10005)

v2: various fixes from Dirk Gouders. Improve commit message slightly.
v3: Fix clean rules and improve Kconfig slightly
v4: Fix merge error in last version (Sam Ravnborg)
    Clarify description that it mainly helps disk size.
Cc: Dirk Gouders <dirk@gouders.net>
Cc: mmarek@suse.cz
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 .gitignore        |  1 +
 Makefile          |  5 +++++
 lib/Kconfig.debug | 15 +++++++++++++++
 3 files changed, 21 insertions(+)

diff --git a/.gitignore b/.gitignore
index f4c0b09..e213b27 100644
--- a/.gitignore
+++ b/.gitignore
@@ -34,6 +34,7 @@
 *.gcno
 modules.builtin
 Module.symvers
+*.dwo
 
 #
 # Top-level generic files
diff --git a/Makefile b/Makefile
index f3c543d..6a717cd 100644
--- a/Makefile
+++ b/Makefile
@@ -689,7 +689,11 @@ endif
 endif
 
 ifdef CONFIG_DEBUG_INFO
+ifdef CONFIG_DEBUG_INFO_SPLIT
+KBUILD_CFLAGS   += $(call cc-option, -gsplit-dwarf, -g)
+else
 KBUILD_CFLAGS	+= -g
+endif
 KBUILD_AFLAGS	+= -Wa,-gdwarf-2
 endif
 
@@ -1377,6 +1381,7 @@ clean: $(clean-dirs)
 	@find $(if $(KBUILD_EXTMOD), $(KBUILD_EXTMOD), .) $(RCS_FIND_IGNORE) \
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '*.ko.*' \
+		-o -name '*.dwo'  \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
 		-o -name '*.symtypes' -o -name 'modules.order' \
 		-o -name modules.builtin -o -name '.tmp_*.o.*' \
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 7a638aa..0360468 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -143,6 +143,21 @@ config DEBUG_INFO_REDUCED
 	  DEBUG_INFO build and compile times are reduced too.
 	  Only works with newer gcc versions.
 
+config DEBUG_INFO_SPLIT
+	bool "Produce split debuginfo in .dwo files"
+	depends on DEBUG_INFO
+	help
+	  Generate debug info into separate .dwo files. This significantly
+	  reduces the build directory size for builds with DEBUG_INFO,
+	  because it stores the information only once on disk in .dwo
+	  files instead of multiple times in object files and executables.
+	  In addition the debug information is also compressed.
+
+	  Requires recent gcc (4.7+) and recent gdb/binutils.
+	  Any tool that packages or reads debug information would need
+	  to know about the .dwo files and include them.
+	  Incompatible with older versions of ccache.
+
 config ENABLE_WARN_DEPRECATED
 	bool "Enable __deprecated logic"
 	default y
-- 
1.8.5.2

