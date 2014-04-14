Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbaDNRoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:44:54 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39963 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbaDNRos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:44:48 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: vegard.nossum@oracle.com, penberg@kernel.org
Cc: jamie.iles@oracle.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        x86@kernel.org, masami.hiramatsu.pt@hitachi.com,
        linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 2/4] x86: Move instruction decoder data into header
Date: Mon, 14 Apr 2014 13:44:08 -0400
Message-Id: <1397497450-6440-2-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com>
References: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now we generate data for the instruction decoder and place it
as a code file which gets #included directly (yuck).

Instead, make it a header which will also be usable by other code
that wants to use the data in there.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 arch/x86/Makefile       |    6 ++++++
 arch/x86/lib/Makefile   |    8 +++++---
 arch/x86/lib/inat.c     |    2 +-
 arch/x86/tools/Makefile |    8 ++++----
 4 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 602f57e..26eee4e 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -178,6 +178,12 @@ archscripts: scripts_basic
 	$(Q)$(MAKE) $(build)=arch/x86/tools relocs
 
 ###
+# inat instruction table generation
+
+archprepare:
+	$(Q)$(MAKE) $(build)=arch/x86/lib inat_tables
+
+###
 # Syscall table generation
 
 archheaders:
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index eabcb6e..3014da8 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -7,12 +7,12 @@ inat_tables_maps = $(srctree)/arch/x86/lib/x86-opcode-map.txt
 quiet_cmd_inat_tables = GEN     $@
       cmd_inat_tables = $(AWK) -f $(inat_tables_script) $(inat_tables_maps) > $@ || rm -f $@
 
-$(obj)/inat-tables.c: $(inat_tables_script) $(inat_tables_maps)
+$(obj)/../include/generated/asm/inat-tables.h: $(inat_tables_script) $(inat_tables_maps)
 	$(call cmd,inat_tables)
 
-$(obj)/inat.o: $(obj)/inat-tables.c
+$(obj)/inat.o: $(obj)/../include/generated/asm/inat-tables.h
 
-clean-files := inat-tables.c
+clean-files := ../include/asm/inat-tables.h
 
 obj-$(CONFIG_SMP) += msr-smp.o cache-smp.o
 
@@ -44,3 +44,5 @@ else
         lib-y += copy_user_64.o copy_user_nocache_64.o
 	lib-y += cmpxchg16b_emu.o
 endif
+
+inat_tables: $(obj)/../include/generated/asm/inat-tables.h
diff --git a/arch/x86/lib/inat.c b/arch/x86/lib/inat.c
index c1f01a8..641a996 100644
--- a/arch/x86/lib/inat.c
+++ b/arch/x86/lib/inat.c
@@ -21,7 +21,7 @@
 #include <asm/insn.h>
 
 /* Attribute tables are generated from opcode map */
-#include "inat-tables.c"
+#include <asm/inat-tables.h>
 
 /* Attribute search APIs */
 insn_attr_t inat_get_opcode_attribute(insn_byte_t opcode)
diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
index e812034..e34e7e3 100644
--- a/arch/x86/tools/Makefile
+++ b/arch/x86/tools/Makefile
@@ -28,14 +28,14 @@ posttest: $(obj)/test_get_len vmlinux $(obj)/insn_sanity
 hostprogs-y	+= test_get_len insn_sanity
 
 # -I needed for generated C source and C source which in the kernel tree.
-HOSTCFLAGS_test_get_len.o := -Wall -I$(objtree)/arch/x86/lib/ -I$(srctree)/arch/x86/include/uapi/ -I$(srctree)/arch/x86/include/ -I$(srctree)/arch/x86/lib/ -I$(srctree)/include/uapi/
+HOSTCFLAGS_test_get_len.o := -Wall -I$(objtree)/arch/x86/lib/ -I$(srctree)/arch/x86/include/uapi/ -I$(srctree)/arch/x86/include/ -I$(srctree)/arch/x86/lib/ -I$(srctree)/include/uapi/ -I$(srctree)/arch/x86/include/generated/
 
-HOSTCFLAGS_insn_sanity.o := -Wall -I$(objtree)/arch/x86/lib/ -I$(srctree)/arch/x86/include/ -I$(srctree)/arch/x86/lib/ -I$(srctree)/include/
+HOSTCFLAGS_insn_sanity.o := -Wall -I$(objtree)/arch/x86/lib/ -I$(srctree)/arch/x86/include/ -I$(srctree)/arch/x86/lib/ -I$(srctree)/include/ -I$(srctree)/arch/x86/include/generated/
 
 # Dependencies are also needed.
-$(obj)/test_get_len.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/inat.c $(srctree)/arch/x86/include/asm/inat_types.h $(srctree)/arch/x86/include/asm/inat.h $(srctree)/arch/x86/include/asm/insn.h $(objtree)/arch/x86/lib/inat-tables.c
+$(obj)/test_get_len.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/inat.c $(srctree)/arch/x86/include/asm/inat_types.h $(srctree)/arch/x86/include/asm/inat.h $(srctree)/arch/x86/include/asm/insn.h $(objtree)/arch/x86/include/generated/asm/inat-tables.h
 
-$(obj)/insn_sanity.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/inat.c $(srctree)/arch/x86/include/asm/inat_types.h $(srctree)/arch/x86/include/asm/inat.h $(srctree)/arch/x86/include/asm/insn.h $(objtree)/arch/x86/lib/inat-tables.c
+$(obj)/insn_sanity.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/inat.c $(srctree)/arch/x86/include/asm/inat_types.h $(srctree)/arch/x86/include/asm/inat.h $(srctree)/arch/x86/include/asm/insn.h $(objtree)/arch/x86/include/generated/asm/inat-tables.h
 
 HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 hostprogs-y	+= relocs
-- 
1.7.10.4

