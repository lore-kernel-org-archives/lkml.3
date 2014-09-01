Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaIAHQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 03:16:56 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:64230 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbaIAHQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 03:16:54 -0400
Subject: [PATCH v2 4/4] kconfig: link CONFIG_CROSS_COMPILE with environment
 variable
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Cc: Paul Bolle <pebolle@tiscali.nl>, Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 01 Sep 2014 11:16:39 +0400
Message-ID: <20140901071639.28909.88888.stgit@zurg>
In-Reply-To: <20140901065916.28909.35097.stgit@zurg>
References: <20140901065916.28909.35097.stgit@zurg>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cross-compiler tool prefix can be set in command line, in the environment
variable CROSS_COMPILE or in config file, in option CONFIG_COROSS_COMPILE.
Also some arch/*/Makefile provides default value.

This patch links config option CONFIG_CROSS_COMPILE and variable CROSS_COMPILE
in both directions: environment/command line has higher priority and updates
value saved in the config file, config option acts as default value for it.

This is especially useful together with option O=dir which allows to create
separate directory for each target architecture and kernel flavor:

# make O=build/arm ARCH=arm CROSS_COMPILE=arm-none-eabi- defconfig
# make -C build/arm

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
---
 Makefile     |    6 +++++-
 init/Kconfig |    1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index f648405..1044f40 100644
--- a/Makefile
+++ b/Makefile
@@ -263,7 +263,11 @@ endif
 # "make" in the configured kernel build directory always uses that.
 # Default value for CROSS_COMPILE is not to prefix executables
 # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile
-CROSS_COMPILE	?= $(CONFIG_CROSS_COMPILE:"%"=%)
+ifndef CROSS_COMPILE
+	CROSS_COMPILE := $(shell $(srctree)/scripts/config \
+				--file $(KBUILD_OUTPUT)$(KCONFIG_CONFIG) \
+				--if-undef "" --state "CROSS_COMPILE")
+endif
 
 # Architecture as present in compile.h
 UTS_MACHINE 	:= $(ARCH)
diff --git a/init/Kconfig b/init/Kconfig
index e84c642..1c2f621 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -47,6 +47,7 @@ config INIT_ENV_ARG_LIMIT
 
 config CROSS_COMPILE
 	string "Cross-compiler tool prefix"
+	option env="CROSS_COMPILE"
 	help
 	  Same as running 'make CROSS_COMPILE=prefix-' but stored for
 	  default make runs in this kernel build directory.  You don't

