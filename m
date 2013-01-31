Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab3AaJmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 04:42:49 -0500
Received: from multi.imgtec.com ([194.200.65.239]:53440 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab3AaJms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 04:42:48 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>, Michal Marek <mmarek@suse.cz>,
        <linux-kbuild@vger.kernel.org>, Mike Frysinger <vapier@gentoo.org>,
        "Yoshinori Sato" <ysato@users.sourceforge.jp>,
        <uclinux-dist-devel@blackfin.uclinux.org>
Subject: [PATCH 1/1] depmod: pass -P $CONFIG_SYMBOL_PREFIX
Date: Thu, 31 Jan 2013 09:41:43 +0000
Message-ID: <1359625303-11842-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_01_31_09_42_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On architectures which have symbol prefixes, depmod emits lots of false
warnings like this:

WARNING: $module.ko needs unknown symbol $symbol

This is because depmod isn't being passed the -P <symbol_prefix>
arguments to specify the symbol prefix to ignore. This option is
included since the 3.13 release of module-init-tools.

Update scripts/depmod.sh to take extra arguments which are passed
through directly to depmod, and update the main Makefile to pass
-P $(CONFIG_SYMBOL_PREFIX to scripts/depmod.sh, but only if
CONFIG_SYMBOL_PREFIX is set and non-empty.

scripts/depmod.sh also drops the -P arguments if depmod --version
reports module-init-tools with a version number < 3.13.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: uclinux-dist-devel@blackfin.uclinux.org
---
My shell-fu isn't great, so all comments for improvements appreciated.

 Makefile          |    6 +++++-
 scripts/depmod.sh |   27 +++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 2d3c92c..89e41d4 100644
--- a/Makefile
+++ b/Makefile
@@ -1394,10 +1394,14 @@ quiet_cmd_rmdirs = $(if $(wildcard $(rm-dirs)),CLEAN   $(wildcard $(rm-dirs)))
 quiet_cmd_rmfiles = $(if $(wildcard $(rm-files)),CLEAN   $(wildcard $(rm-files)))
       cmd_rmfiles = rm -f $(rm-files)
 
+ifneq ($(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX)),)
+  depmod_args = -P $(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
+endif
+
 # Run depmod only if we have System.map and depmod is executable
 quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
       cmd_depmod = $(CONFIG_SHELL) $(srctree)/scripts/depmod.sh $(DEPMOD) \
-                   $(KERNELRELEASE)
+                   $(KERNELRELEASE) $(depmod_args)
 
 # Create temporary dir for module support files
 # clean it up only when building all modules
diff --git a/scripts/depmod.sh b/scripts/depmod.sh
index 2ae4817..4f3747f 100755
--- a/scripts/depmod.sh
+++ b/scripts/depmod.sh
@@ -2,16 +2,35 @@
 #
 # A depmod wrapper used by the toplevel Makefile
 
-if test $# -ne 2; then
-	echo "Usage: $0 /sbin/depmod <kernelrelease>" >&2
+if test $# -lt 2; then
+	echo "Usage: $0 /sbin/depmod <kernelrelease> [args]" >&2
 	exit 1
 fi
 DEPMOD=$1
-KERNELRELEASE=$2
+shift
+KERNELRELEASE=$1
+shift
 
 if ! test -r System.map -a -x "$DEPMOD"; then
 	exit 0
 fi
+
+# older versions of depmod don't support -P <symbol-prefix>
+# support was added in module-init-tools 3.13
+if test "$1" = "-P"; then
+	release=$("$DEPMOD" --version)
+	package=$(echo "$release" | cut -d' ' -f 1)
+	if test "$package" = "module-init-tools"; then
+		version=$(echo "$release" | cut -d' ' -f 2)
+		later=$({ echo "$version"; echo "3.13"; } | sort -V | tail -n 1)
+		if test "$later" != "$version"; then
+			# module-init-tools < 3.13, drop the next 2 args
+			shift
+			shift
+		fi
+	fi
+fi
+
 # older versions of depmod require the version string to start with three
 # numbers, so we cheat with a symlink here
 depmod_hack_needed=true
@@ -30,7 +49,7 @@ if $depmod_hack_needed; then
 	KERNELRELEASE=99.98.$KERNELRELEASE
 fi
 
-set -- -ae -F System.map
+set -- -ae -F System.map "$@"
 if test -n "$INSTALL_MOD_PATH"; then
 	set -- "$@" -b "$INSTALL_MOD_PATH"
 fi
-- 
1.7.7.6


