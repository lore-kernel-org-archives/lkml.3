Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaGZQgK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 12:36:10 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:52885 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaGZQgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 12:36:08 -0400
Subject: [PATCH] kbuild: escape single backslashes in macro make-cmd
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Cc: Sascha Hauer <s.hauer@pengutronix.de>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 26 Jul 2014 20:35:51 +0400
Message-ID: <20140726163551.19857.17737.stgit@zurg>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This already has been fixed in commit c353acba28fb3fa1fd05fd
("kbuild: make: fix if_changed when command contains backslashes")
but escaping still isn't perfect and triggers false-positive rebuilds.

For x86 problem happens every time, because rules in arch/x86/realmode/rm/
and arch/x86/boot/ contains commands like sed -n -e 's/foo\(.*\)/\1/p'.
Backslash in \1 isn't escaped and turns into ascii symbol with code 1.
Macro if_changed detects command change and rebuilds target again and again.

Backslash escaping conflicts with other passes because it's used for escaping
other symbols. To avoid that current macro handles only double backslashes.
Obviously this doesn't work for \1 like above.

This patch reorders passes. It doubles all backslashes before escaping # and '

Visible effect in rebuilding x86/defconfig without changes, before patch:

blind@zurg:~/src/linux$ make V=2
  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh - due to target missing
  CHK     include/generated/compile.h
  PASYMS  arch/x86/realmode/rm/pasyms.h - due to command line change
  LDS     arch/x86/realmode/rm/realmode.lds - due to: arch/x86/realmode/rm/pasyms.h
  LD      arch/x86/realmode/rm/realmode.elf - due to: arch/x86/realmode/rm/realmode.lds
  RELOCS  arch/x86/realmode/rm/realmode.relocs - due to: arch/x86/realmode/rm/realmode.elf
  OBJCOPY arch/x86/realmode/rm/realmode.bin - due to: arch/x86/realmode/rm/realmode.elf arch/x86/realmode/rm/realmode.relocs
  AS      arch/x86/realmode/rmpiggy.o - due to: arch/x86/realmode/rm/realmode.bin
  LD      arch/x86/realmode/built-in.o - due to: arch/x86/realmode/rmpiggy.o
  LD      arch/x86/built-in.o - due to: arch/x86/realmode/built-in.o
  LINK    vmlinux - due to: arch/x86/built-in.o
  LD      vmlinux.o
  MODPOST vmlinux.o - due to vmlinux.o not in $(targets)
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o - due to: include/generated/compile.h
  LD      init/built-in.o - due to: init/version.o
  KSYM    .tmp_kallsyms1.o
  KSYM    .tmp_kallsyms2.o
  LD      vmlinux
  SORTEX  vmlinux
  SYSMAP  System.map
  VOFFSET arch/x86/boot/voffset.h - due to: vmlinux
  OBJCOPY arch/x86/boot/compressed/vmlinux.bin - due to: vmlinux
  GZIP    arch/x86/boot/compressed/vmlinux.bin.gz - due to: arch/x86/boot/compressed/vmlinux.bin
  MKPIGGY arch/x86/boot/compressed/piggy.S - due to: arch/x86/boot/compressed/vmlinux.bin.gz
  AS      arch/x86/boot/compressed/piggy.o - due to: arch/x86/boot/compressed/piggy.S
  LD      arch/x86/boot/compressed/vmlinux - due to: arch/x86/boot/compressed/piggy.o
  ZOFFSET arch/x86/boot/zoffset.h - due to: arch/x86/boot/compressed/vmlinux
  AS      arch/x86/boot/header.o - due to: arch/x86/boot/voffset.h arch/x86/boot/zoffset.h
  CC      arch/x86/boot/version.o - due to: include/generated/compile.h
  LD      arch/x86/boot/setup.elf - due to: arch/x86/boot/header.o arch/x86/boot/version.o
  OBJCOPY arch/x86/boot/setup.bin - due to: arch/x86/boot/setup.elf
  OBJCOPY arch/x86/boot/vmlinux.bin - due to: arch/x86/boot/compressed/vmlinux
  BUILD   arch/x86/boot/bzImage - due to: arch/x86/boot/setup.bin arch/x86/boot/vmlinux.bin
Setup is 15676 bytes (padded to 15872 bytes).
System is 5569 kB
CRC c06bbc0c
Kernel: arch/x86/boot/bzImage is ready  (#4)
  Building modules, stage 2.
  MODPOST 12 modules - due to target is PHONY

After:

blind@zurg:~/src/linux$ make V=2
  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh - due to target missing
  CHK     include/generated/compile.h
Kernel: arch/x86/boot/bzImage is ready  (#5)
  Building modules, stage 2.
  MODPOST 12 modules - due to target is PHONY

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
---
 scripts/Kbuild.include |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 122f95c..edd0b0d 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -219,7 +219,7 @@ endif
 # >$< substitution to preserve $ when reloading .cmd file
 # note: when using inline perl scripts [perl -e '...$$t=1;...']
 # in $(cmd_xxx) double $$ your perl vars
-make-cmd = $(subst \\,\\\\,$(subst \#,\\\#,$(subst $$,$$$$,$(call escsq,$(cmd_$(1))))))
+make-cmd = $(call escsq,$(subst \#,\\\#,$(subst \,\\,$(subst $$,$$$$,$(cmd_$(1))))))
 
 # Find any prerequisites that is newer than target or that does not exist.
 # PHONY targets skipped in both cases.

