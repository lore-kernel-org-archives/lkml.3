Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622AbaLKSGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 13:06:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758568AbaLKSGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 13:06:51 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH 1/4] xen: build infrastructure for generating hypercall depending symbols
Date: Thu, 11 Dec 2014 19:04:22 +0100
Message-Id: <1418321065-10212-2-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1418321065-10212-1-git-send-email-jgross@suse.com>
References: <1418321065-10212-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today there are several places in the kernel which build tables
containing one entry for each possible Xen hypercall. Create an
infrastructure to be able to generate these tables at build time.

Based-on-patch-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/syscalls/Makefile |  9 +++++++++
 scripts/xen-hypercalls.sh  | 11 +++++++++++
 2 files changed, 20 insertions(+)
 create mode 100644 scripts/xen-hypercalls.sh

diff --git a/arch/x86/syscalls/Makefile b/arch/x86/syscalls/Makefile
index 3323c27..a55abb9 100644
--- a/arch/x86/syscalls/Makefile
+++ b/arch/x86/syscalls/Makefile
@@ -19,6 +19,9 @@ quiet_cmd_syshdr = SYSHDR  $@
 quiet_cmd_systbl = SYSTBL  $@
       cmd_systbl = $(CONFIG_SHELL) '$(systbl)' $< $@
 
+quiet_cmd_hypercalls = HYPERCALLS $@
+      cmd_hypercalls = $(CONFIG_SHELL) '$<' $@ $(filter-out $<,$^)
+
 syshdr_abi_unistd_32 := i386
 $(uapi)/unistd_32.h: $(syscall32) $(syshdr)
 	$(call if_changed,syshdr)
@@ -47,10 +50,16 @@ $(out)/syscalls_32.h: $(syscall32) $(systbl)
 $(out)/syscalls_64.h: $(syscall64) $(systbl)
 	$(call if_changed,systbl)
 
+$(out)/xen-hypercalls.h: $(srctree)/scripts/xen-hypercalls.sh
+	$(call if_changed,hypercalls)
+
+$(out)/xen-hypercalls.h: $(srctree)/include/xen/interface/xen*.h
+
 uapisyshdr-y			+= unistd_32.h unistd_64.h unistd_x32.h
 syshdr-y			+= syscalls_32.h
 syshdr-$(CONFIG_X86_64)		+= unistd_32_ia32.h unistd_64_x32.h
 syshdr-$(CONFIG_X86_64)		+= syscalls_64.h
+syshdr-$(CONFIG_XEN)		+= xen-hypercalls.h
 
 targets	+= $(uapisyshdr-y) $(syshdr-y)
 
diff --git a/scripts/xen-hypercalls.sh b/scripts/xen-hypercalls.sh
new file mode 100644
index 0000000..e6447b7
--- /dev/null
+++ b/scripts/xen-hypercalls.sh
@@ -0,0 +1,11 @@
+#!/bin/sh
+out="$1"
+shift
+in="$@"
+
+for i in $in; do
+	eval $CPP $LINUXINCLUDE -dD -imacros "$i" -x c /dev/null
+done | \
+awk '$1 == "#define" && $2 ~ /__HYPERVISOR_[a-z][a-z_0-9]*/ { v[$3] = $2 }
+	END {for (i in v) if (!(v[i] in v))
+		print "HYPERCALL("substr(v[i], 14)")"}' | sort -u >$out
-- 
2.1.2

