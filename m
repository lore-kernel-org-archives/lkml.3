Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab3BFM6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 07:58:08 -0500
Received: from multi.imgtec.com ([194.200.65.239]:18336 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab3BFM6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 07:58:03 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>, Michal Marek <mmarek@suse.cz>,
        <linux-kbuild@vger.kernel.org>, Mike Frysinger <vapier@gentoo.org>,
        "Yoshinori Sato" <ysato@users.sourceforge.jp>,
        <uclinux-dist-devel@blackfin.uclinux.org>
Subject: [PATCH v2 1/1] depmod: pass -P $CONFIG_SYMBOL_PREFIX
Date: Wed, 6 Feb 2013 12:56:59 +0000
Message-ID: <1360155419-12349-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_06_12_57_59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On architectures which have symbol prefixes, depmod emits lots of
warnings like this:

WARNING: $module.ko needs unknown symbol $symbol

This is because depmod isn't being passed the -P <symbol_prefix>
arguments to specify the symbol prefix to ignore. This option is
included since the 3.13 release of module-init-tools.

Update scripts/depmod.sh to take extra arguments for the symbol prefix
(required but may be empty), and update the main Makefile to always pass
"$(CONFIG_SYMBOL_PREFIX)" to scripts/depmod.sh.

If the provided symbol prefix is non-empty, scripts/depmod.sh checks if
depmod --version reports module-init-tools with a version number < 3.13
otherwise it appends -P $SYMBOL_PREFIX to the depmod command line.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: uclinux-dist-devel@blackfin.uclinux.org
---
changes since v1: clean up with assistance from Mike Frysinger (thanks!)
* always pass prefix to depmod.sh to simplify the logic
* use printf instead of ugly echos in version check

 Makefile          |    2 +-
 scripts/depmod.sh |   26 +++++++++++++++++++++++---
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 54dfde5..6cb7fdb 100644
--- a/Makefile
+++ b/Makefile
@@ -1397,7 +1397,7 @@ quiet_cmd_rmfiles = $(if $(wildcard $(rm-files)),CLEAN   $(wildcard $(rm-files))
 # Run depmod only if we have System.map and depmod is executable
 quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
       cmd_depmod = $(CONFIG_SHELL) $(srctree)/scripts/depmod.sh $(DEPMOD) \
-                   $(KERNELRELEASE)
+                   $(KERNELRELEASE) "$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))"
 
 # Create temporary dir for module support files
 # clean it up only when building all modules
diff --git a/scripts/depmod.sh b/scripts/depmod.sh
index 2ae4817..122599b 100755
--- a/scripts/depmod.sh
+++ b/scripts/depmod.sh
@@ -2,16 +2,36 @@
 #
 # A depmod wrapper used by the toplevel Makefile
 
-if test $# -ne 2; then
-	echo "Usage: $0 /sbin/depmod <kernelrelease>" >&2
+if test $# -ne 3; then
+	echo "Usage: $0 /sbin/depmod <kernelrelease> <symbolprefix>" >&2
 	exit 1
 fi
 DEPMOD=$1
 KERNELRELEASE=$2
+SYMBOL_PREFIX=$3
 
 if ! test -r System.map -a -x "$DEPMOD"; then
 	exit 0
 fi
+
+# older versions of depmod don't support -P <symbol-prefix>
+# support was added in module-init-tools 3.13
+if test -n "$SYMBOL_PREFIX"; then
+	release=$("$DEPMOD" --version)
+	package=$(echo "$release" | cut -d' ' -f 1)
+	if test "$package" = "module-init-tools"; then
+		version=$(echo "$release" | cut -d' ' -f 2)
+		later=$(printf '%s\n' "$version" "3.13" | sort -V | tail -n 1)
+		if test "$later" != "$version"; then
+			# module-init-tools < 3.13, drop the symbol prefix
+			SYMBOL_PREFIX=""
+		fi
+	fi
+	if test -n "$SYMBOL_PREFIX"; then
+		SYMBOL_PREFIX="-P $SYMBOL_PREFIX"
+	fi
+fi
+
 # older versions of depmod require the version string to start with three
 # numbers, so we cheat with a symlink here
 depmod_hack_needed=true
@@ -34,7 +54,7 @@ set -- -ae -F System.map
 if test -n "$INSTALL_MOD_PATH"; then
 	set -- "$@" -b "$INSTALL_MOD_PATH"
 fi
-"$DEPMOD" "$@" "$KERNELRELEASE"
+"$DEPMOD" "$@" "$KERNELRELEASE" $SYMBOL_PREFIX
 ret=$?
 
 if $depmod_hack_needed; then
-- 
1.7.7.6


