Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaBEPCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 10:02:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbaBEPCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:02:18 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kirill Tkhai <tkhai@yandex.ru>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kbuild@vger.kernel.org
Subject: [PATCH] Makefile, CONFIG_MODVERSIONS, ignore *.mod.c files
Date: Wed,  5 Feb 2014 10:01:51 -0500
Message-Id: <1391612511-9276-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_MODVERSIONS=y results in a .mod.c for every compiled file in the kernel.
Issuing a 'make cscope' on a compiled kernel tree results in the cscope files
containing *.mod.c files.

[prarit@prarit linux]# make cscope
[prarit@prarit linux]# cat cscope.files | grep mod.c | wc -l
4807

These files are not useful for cscope and should be ignored.  For example,

   #   line  filename / context / line
   1    105  arch/x86/kvm/kvm-intel.mod.c <<GLOBAL>>
             { 0x618911fc, __VMLINUX_SYMBOL_STR(numa_node) },
   2    508  drivers/block/mtip32xx/mtip32xx.h <<GLOBAL>>
             int numa_node;
   3     55  drivers/block/mtip32xx/mtip32xx.mod.c <<GLOBAL>>
             { 0x618911fc, __VMLINUX_SYMBOL_STR(numa_node) },
   4     37  drivers/cpufreq/acpi-cpufreq.mod.c <<GLOBAL>>
             { 0x618911fc, __VMLINUX_SYMBOL_STR(numa_node) },
   <snip>

Add *.mod.c to the RCS_FIND_IGNORE in the top-level Makefile and to the ignore
list in scripts/tags.sh.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kirill Tkhai <tkhai@yandex.ru>
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kbuild@vger.kernel.org
---
 Makefile        |    3 ++-
 scripts/tags.sh |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 606ef7c..4e1b87a 100644
--- a/Makefile
+++ b/Makefile
@@ -415,7 +415,8 @@ export MODVERDIR := $(if $(KBUILD_EXTMOD),$(firstword $(KBUILD_EXTMOD))/).tmp_ve
 # Files to ignore in find ... statements
 
 RCS_FIND_IGNORE := \( -name SCCS -o -name BitKeeper -o -name .svn -o -name CVS \
-		   -o -name .pc -o -name .hg -o -name .git \) -prune -o
+		   -o -name .pc -o -name .hg -o -name .git -o -name *.mod.c\) \
+		   -prune -o
 export RCS_TAR_IGNORE := --exclude SCCS --exclude BitKeeper --exclude .svn \
 			 --exclude CVS --exclude .pc --exclude .hg --exclude .git
 
diff --git a/scripts/tags.sh b/scripts/tags.sh
index 58c4559..6229d6b 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -14,7 +14,7 @@ fi
 # This is a duplicate of RCS_FIND_IGNORE without escaped '()'
 ignore="( -name SCCS -o -name BitKeeper -o -name .svn -o \
           -name CVS  -o -name .pc       -o -name .hg  -o \
-          -name .git )                                   \
+          -name .git -o -name *.mod.c )                  \
           -prune -o"
 
 # Do not use full path if we do not use O=.. builds
-- 
1.7.9.3

