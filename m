Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaIAHQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 03:16:53 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:34412 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbaIAHQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 03:16:51 -0400
Subject: [PATCH v2 3/4] kconfig: get target architecture from config file
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Cc: Paul Bolle <pebolle@tiscali.nl>, Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 01 Sep 2014 11:16:36 +0400
Message-ID: <20140901071636.28909.74871.stgit@zurg>
In-Reply-To: <20140901065916.28909.35097.stgit@zurg>
References: <20140901065916.28909.35097.stgit@zurg>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes kernel cross-compilation little bit easier.
After initial configuration no special environment variables
are required because default ARCH is saved in .config file:

# make ARCH=arm defconfig
# make menuconfig
# make

To solve chicken and egg problem ARCH is read directly from config file.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
---
 Documentation/kbuild/makefiles.txt |    3 ++-
 Makefile                           |   15 ++++++++++-----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index 764f599..92cf95b 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -1365,7 +1365,8 @@ The top Makefile exports the following variables:
 	"arm", or "sparc". Some kbuild Makefiles test $(ARCH) to
 	determine which files to compile.
 
-	By default, the top Makefile sets $(ARCH) to be the same as the
+	By default $(ARCH) is set by option CONFIG_ARCH in .config,
+	default for it is set by top Makefile to be the same as the
 	host system architecture.  For a cross build, a user may
 	override the value of $(ARCH) on the command line:
 
diff --git a/Makefile b/Makefile
index 2893d7f..f648405 100644
--- a/Makefile
+++ b/Makefile
@@ -220,6 +220,8 @@ VPATH		:= $(srctree)$(if $(KBUILD_EXTMOD),:$(KBUILD_EXTMOD))
 
 export srctree objtree VPATH
 
+KCONFIG_CONFIG	?= .config
+export KCONFIG_CONFIG
 
 # SUBARCH tells the usermode build what the underlying arch is.  That is set
 # first, and if a usermode build is happening, the "ARCH=um" on the command
@@ -242,7 +244,14 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
 # ARCH can be set during invocation of make:
 # make ARCH=ia64
 # Another way is to have ARCH set in the environment.
-# The default ARCH is the host where make is executed.
+# Usually default value is saved in .config as CONFIG_ARCH.
+# If this option is undefined or config file does not exist
+# ARCH is set to the host where make is executed.
+ifndef ARCH
+	ARCH := $(shell $(srctree)/scripts/config \
+				--file $(KBUILD_OUTPUT)$(KCONFIG_CONFIG) \
+				--if-undef "$(SUBARCH)" --state "ARCH")
+endif
 
 # CROSS_COMPILE specify the prefix used for all executables used
 # during compilation. Only gcc and related bin-utils executables
@@ -254,7 +263,6 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
 # "make" in the configured kernel build directory always uses that.
 # Default value for CROSS_COMPILE is not to prefix executables
 # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile
-ARCH		?= $(SUBARCH)
 CROSS_COMPILE	?= $(CONFIG_CROSS_COMPILE:"%"=%)
 
 # Architecture as present in compile.h
@@ -293,9 +301,6 @@ endif
 # Where to locate arch specific headers
 hdr-arch  := $(SRCARCH)
 
-KCONFIG_CONFIG	?= .config
-export KCONFIG_CONFIG
-
 # SHELL used by kbuild
 CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
 	  else if [ -x /bin/bash ]; then echo /bin/bash; \

