Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965610AbaFTTVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:21:11 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:61086 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965084AbaFTTVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:21:08 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Josh Boyer <jwboyer@fedoraproject.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 5/5] x86,vdso: Create .build-id links for unstripped vdso files
Date: Fri, 20 Jun 2014 12:20:44 -0700
Message-Id: <a424b189ce3ced85fe1e82d032a20e765e0fe0d3.1403291930.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1403291930.git.luto@amacapital.net>
References: <cover.1403291930.git.luto@amacapital.net>
In-Reply-To: <cover.1403291930.git.luto@amacapital.net>
References: <cover.1403291930.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this change, doing 'make vdso_install' and telling gdb:

set debug-file-directory /lib/modules/KVER/vdso

will enable vdso debugging with symbols.  This is useful for
testing, but kernel RPM builds will probably want to manually delete
these symlinks or otherwise do something sensible when they strip
the vdso/*.so files.

If ld does not support --build-id, then the symlinks will not be
created.

Note that kernel packagers that use vdso_install may need to adjust
their packaging scripts to accomdate this change.  For example,
Fedora's scripts create build-id symlinks themselves in a different
location, so the spec should probably be updated to remove the
symlinks created by make vdso_install.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/Makefile | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 2c1ca98..68a15c4 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -169,14 +169,24 @@ quiet_cmd_vdso = VDSO    $@
 		 sh $(srctree)/$(src)/checkundef.sh '$(NM)' '$@'
 
 VDSO_LDFLAGS = -fPIC -shared $(call cc-ldoption, -Wl$(comma)--hash-style=sysv) \
-	-Wl,-Bsymbolic $(LTO_CFLAGS)
+	$(call cc-ldoption, -Wl$(comma)--build-id) -Wl,-Bsymbolic $(LTO_CFLAGS)
 GCOV_PROFILE := n
 
 #
-# Install the unstripped copies of vdso*.so.
+# Install the unstripped copies of vdso*.so.  If our toolchain supports
+# build-id, install .build-id links as well.
 #
 quiet_cmd_vdso_install = INSTALL $(@:install_%=%)
-      cmd_vdso_install = cp $< $(MODLIB)/vdso/$(@:install_%=%)
+define cmd_vdso_install
+	cp $< "$(MODLIB)/vdso/$(@:install_%=%)"; \
+	if readelf -n $< |grep -q 'Build ID'; then \
+	  buildid=`readelf -n $< |grep 'Build ID' |sed -e 's/^.*Build ID: \(.*\)$$/\1/'`; \
+	  first=`echo $$buildid | cut -b-2`; \
+	  last=`echo $$buildid | cut -b3-`; \
+	  mkdir -p "$(MODLIB)/vdso/.build-id/$$first"; \
+	  ln -sf "../../$(@:install_%=%)" "$(MODLIB)/vdso/.build-id/$$first/$$last.debug"; \
+	fi
+endef
 
 vdso_img_insttargets := $(vdso_img_sodbg:%.dbg=install_%)
 
-- 
1.9.3

