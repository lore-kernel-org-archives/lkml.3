Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750909Ab3EJEWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 00:22:43 -0400
Received: from mail-ye0-f178.google.com ([209.85.213.178]:52351 "EHLO
	mail-ye0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab3EJEWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 00:22:42 -0400
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 May 2013 00:22:42 EDT
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] init/Kconfig: Add option to set modprobe command
Date: Fri, 10 May 2013 01:15:16 -0300
Message-Id: <1368159316-31744-3-git-send-email-lucas.de.marchi@gmail.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1368159316-31744-1-git-send-email-lucas.de.marchi@gmail.com>
References: <1368159316-31744-1-git-send-email-lucas.de.marchi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hard-coded path of modprobe doesn't allow distros to put the binary
in another place without add links from one place to another. For
example, in recent versions of distros like Fedora, Arch and Suse, kmod
is the default tool to load modules and they have to create a link from
modprobe to kmod binary.  kmod relies on argv[0] to know what to do but
in future they want to add commands like "kmod load -- modulename",
which is not possible if the path to the tool to load modules is
hard-coded in kernel.

Moreover, it's already possible to set the path through /proc/sys, but
it would have to be done very early in the boot sequence and on every
boot since modprobe may be called even before / is mounted. In this
scenario booting without and initrd would be more difficult as well.

Signed-off-by: Lucas De Marchi <lucas.de.marchi@gmail.com>
---
 init/Kconfig  | 7 +++++++
 kernel/kmod.c | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index 5341d72..72eee1c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1593,6 +1593,13 @@ menuconfig MODULES
 
 if MODULES
 
+config DEFAULT_MODULE_LOAD_BIN
+	string "Default module load binary"
+	default "/sbin/modprobe -q --"
+	help
+	  This option determines the default executable to be called when a
+	  module is requested to be loaded via request_module().
+
 config MODULE_FORCE_LOAD
 	bool "Forced module loading"
 	default n
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 70df90b..1828542 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -67,7 +67,7 @@ static DECLARE_RWSEM(umhelper_sem);
 /*
 	modprobe_path is set via /proc/sys.
 */
-char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe -q --";
+char modprobe_path[KMOD_PATH_LEN] = CONFIG_DEFAULT_MODULE_LOAD_BIN;
 
 static void free_modprobe_argv(struct subprocess_info *info)
 {
-- 
1.8.2.2

