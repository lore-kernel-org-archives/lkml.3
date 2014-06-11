Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaFKTmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:42:05 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:49131 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbaFKTmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:42:03 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] x86,build: Fix make -jN modules_install install
Date: Wed, 11 Jun 2014 12:41:57 -0700
Message-Id: <37910a32e3d223a688a2743376bdde8fbdc8ef5c.1402515662.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every few months, I forget why I type:

$ sudo make -j12 modules_install && sudo make -j12 install

instead of just:

$ sudo make -j12 modules_install install

I try the latter, it appears to work, and then my machine won't boot
because dracut got confused.  This fixes it once and for all: if you
ask make to install modules and a kernel, you almost certainly want
the modules installed *first* so that your initramfs scripts can
find the modules.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/Makefile | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 33f71b0..7280d28 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -240,6 +240,15 @@ PHONY += install
 install:
 	$(Q)$(MAKE) $(build)=$(boot) $@
 
+# If installing modules and a kernel, it's very likely that some initramfs
+# script associated with installing the kernel will reference the modules,
+# so make sure that modules are installed first.
+ifneq ($(filter modules_install,$(MAKECMDGOALS)),)
+  ifneq ($(filter modules_install,$(MAKECMDGOALS)),)
+    install: modules_install
+  endif
+endif
+
 PHONY += vdso_install
 vdso_install:
 	$(Q)$(MAKE) $(build)=arch/x86/vdso $@
-- 
1.9.3

