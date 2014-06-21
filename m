Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbaFUCIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 22:08:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51181 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956AbaFUCIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 22:08:31 -0400
Date: Fri, 20 Jun 2014 19:08:20 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-dda1e95cee38b416b23f751cac65421d781e3c10@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <a424b189ce3ced85fe1e82d032a20e765e0fe0d3.1403291930.git.luto@amacapital.net>
References: <a424b189ce3ced85fe1e82d032a20e765e0fe0d3.1403291930.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/vdso:
  Create .build-id links for unstripped vdso files
Git-Commit-ID: dda1e95cee38b416b23f751cac65421d781e3c10
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dda1e95cee38b416b23f751cac65421d781e3c10
Gitweb:     http://git.kernel.org/tip/dda1e95cee38b416b23f751cac65421d781e3c10
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Fri, 20 Jun 2014 12:20:44 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 20 Jun 2014 13:18:49 -0700

x86/vdso: Create .build-id links for unstripped vdso files

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
Link: http://lkml.kernel.org/r/a424b189ce3ced85fe1e82d032a20e765e0fe0d3.1403291930.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
 
