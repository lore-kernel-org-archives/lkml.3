Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbaFRXAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:00:30 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:36260 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144AbaFRXAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:00:16 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Josh Boyer <jwboyer@fedoraproject.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 5/5] x86,vdso: Create .build-id links for unstripped vdso files
Date: Wed, 18 Jun 2014 15:59:50 -0700
Message-Id: <26fa44a597716445c134d21194170c292d46a421.1403129369.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1403129369.git.luto@amacapital.net>
References: <cover.1403129369.git.luto@amacapital.net>
In-Reply-To: <cover.1403129369.git.luto@amacapital.net>
References: <cover.1403129369.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this change, doing 'make vdso_install' and telling gdb:

set debug-file-directory /lib/modules/KVER/vdso

will enable vdso debugging with symbols.  This is useful for
testing, but kernel RPM builds will probably want to manually delete
these symlinks or otherwise do something sensible when they strip
the vdso/*.so files.

This may break make vdso_install with binutils before 2.17.50.0.17.
On the other hand, make vdso_install was probably never useful with
earlier binutils, since the installed files are AFAIK completely
useless without build-id.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/Makefile | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 2c1ca98..ac16c17 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -176,7 +176,14 @@ GCOV_PROFILE := n
 # Install the unstripped copies of vdso*.so.
 #
 quiet_cmd_vdso_install = INSTALL $(@:install_%=%)
-      cmd_vdso_install = cp $< $(MODLIB)/vdso/$(@:install_%=%)
+define cmd_vdso_install
+	buildid=`readelf -n $< |grep 'Build ID' |sed -e 's/^.*Build ID: \(.*\)$$/\1/'`; \
+	first=`echo $$buildid | cut -b-2`; \
+	last=`echo $$buildid | cut -b3-`; \
+	cp $< "$(MODLIB)/vdso/$(@:install_%=%)"; \
+	mkdir -p "$(MODLIB)/vdso/.build-id/$$first"; \
+	ln -sf "../../$(@:install_%=%)" "$(MODLIB)/vdso/.build-id/$$first/$$last.debug"
+endef
 
 vdso_img_insttargets := $(vdso_img_sodbg:%.dbg=install_%)
 
-- 
1.9.3

