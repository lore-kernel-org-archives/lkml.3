Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965632Ab3DPXVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 19:21:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49388 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965600Ab3DPXU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 19:20:59 -0400
Date: Tue, 16 Apr 2013 16:20:48 -0700
From: tip-bot for Kees Cook <tipbot@zytor.com>
Message-ID: <tip-17c961f7702ff6037b66bb2e5f3ddd58de4ce7e5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1365797627-20874-5-git-send-email-keescook@chromium.org>
References: <1365797627-20874-5-git-send-email-keescook@chromium.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/kaslr] x86, relocs: Build separate 32/64-bit tools
Git-Commit-ID: 17c961f7702ff6037b66bb2e5f3ddd58de4ce7e5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 16 Apr 2013 16:20:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  17c961f7702ff6037b66bb2e5f3ddd58de4ce7e5
Gitweb:     http://git.kernel.org/tip/17c961f7702ff6037b66bb2e5f3ddd58de4ce7e5
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Fri, 12 Apr 2013 13:13:45 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 16 Apr 2013 15:22:01 -0700

x86, relocs: Build separate 32/64-bit tools

Since the ELF structures and access macros change size based on 32 vs
64 bits, build a separate 32-bit relocs tool (for handling realmode
and 32-bit relocations), and a 64-bit relocs tool (for handling 64-bit
kernel relocations).

Signed-off-by: Kees Cook <keescook@chromium.org>
Link: http://lkml.kernel.org/r/1365797627-20874-5-git-send-email-keescook@chromium.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/compressed/Makefile |  2 +-
 arch/x86/realmode/rm/Makefile     |  2 +-
 arch/x86/tools/.gitignore         |  3 ++-
 arch/x86/tools/Makefile           | 20 ++++++++++++++++++--
 4 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 5ef205c..0dac175 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -44,7 +44,7 @@ $(obj)/vmlinux.bin: vmlinux FORCE
 
 targets += $(patsubst $(obj)/%,%,$(VMLINUX_OBJS)) vmlinux.bin.all vmlinux.relocs
 
-CMD_RELOCS = arch/x86/tools/relocs
+CMD_RELOCS = arch/x86/tools/relocs_$(BITS)
 quiet_cmd_relocs = RELOCS  $@
       cmd_relocs = $(CMD_RELOCS) $< > $@;$(CMD_RELOCS) --abs-relocs $<
 $(obj)/vmlinux.relocs: vmlinux FORCE
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index 8869287..2b1e429 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -56,7 +56,7 @@ $(obj)/realmode.bin: $(obj)/realmode.elf $(obj)/realmode.relocs
 	$(call if_changed,objcopy)
 
 quiet_cmd_relocs = RELOCS  $@
-      cmd_relocs = arch/x86/tools/relocs --realmode $< > $@
+      cmd_relocs = arch/x86/tools/relocs_32 --realmode $< > $@
 
 targets += realmode.relocs
 $(obj)/realmode.relocs: $(obj)/realmode.elf FORCE
diff --git a/arch/x86/tools/.gitignore b/arch/x86/tools/.gitignore
index be0ed06..2b45d5f 100644
--- a/arch/x86/tools/.gitignore
+++ b/arch/x86/tools/.gitignore
@@ -1 +1,2 @@
-relocs
+relocs_32*
+relocs_64*
diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
index bae601f..a8cb70c 100644
--- a/arch/x86/tools/Makefile
+++ b/arch/x86/tools/Makefile
@@ -37,6 +37,22 @@ $(obj)/test_get_len.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/in
 
 $(obj)/insn_sanity.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/inat.c $(srctree)/arch/x86/include/asm/inat_types.h $(srctree)/arch/x86/include/asm/inat.h $(srctree)/arch/x86/include/asm/insn.h $(objtree)/arch/x86/lib/inat-tables.c
 
+HOSTCFLAGS_relocs_32.o += -DELF_BITS=32
+HOSTCFLAGS_relocs_64.o += -DELF_BITS=64
+
+quiet_cmd_cp_reloc = GEN     $@
+      cmd_cp_reloc = cp $< $@
+
+$(obj)/relocs_%.c: $(srctree)/arch/x86/tools/relocs.c
+	$(call cmd,cp_reloc)
+
 HOST_EXTRACFLAGS += -I$(srctree)/tools/include
-hostprogs-y	+= relocs
-relocs: $(obj)/relocs
+hostprogs-y    += relocs_$(BITS)
+relocs_binaries = relocs_$(BITS)
+ifeq ($(CONFIG_64BIT),y)
+	hostprogs-y  += relocs_32
+	relocs_binaries += relocs_32
+endif
+relocs: $(relocs_binaries)
+relocs_32: $(obj)/relocs_32
+relocs_64: $(obj)/relocs_64
