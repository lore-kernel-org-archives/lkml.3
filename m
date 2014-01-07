Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbaAGOUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:20:06 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:54066 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaAGOUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:20:02 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Jiang Liu <liuj97@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 0/7] Optimize jump label implementation for ARM64
Date: Tue,  7 Jan 2014 22:17:07 +0800
Message-Id: <1389104234-15239-1-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset tries to optimize arch specfic jump label implementation
for ARM64 by dynamic kernel text patching.

To enable this feature, your toolchain must support "asm goto" extension
and "%c" constraint extesion.

It has been tested on ARM Fast mode and a real hardware platform.

V7->V8:
1) Minor syntax fix
2) include <asm/insn.h> into <asm/jump_label.h> to avoid duplicated definitions

V6->V7:
1) Minor format clean up
2) Remove smp_mb() pair

V5->V6:
1) optimize stop_machine() related code
2) simplify aarch64_insn_patch_text_nosync() interface
3) refine comments

V4->V5:
1) rework the stop_machine() related code
2) rework aarch64_insn_gen_nop()

V3->V4:
1) resolve a race condition in kernel text patching
2) address other review comments

V2->V3:
1) fix a bug in comparing signed and unsigned values
2) detect big endian by checking __AARCH64EB__

V1->V2: address review comments of V1
1) refine comments
2) add a new interface to always synchronize with stop_machine()
   when patching code
3) handle endian issue when patching code

Jiang Liu (7):
  arm64: introduce basic aarch64 instruction decoding helpers
  arm64: introduce interfaces to hotpatch kernel and module code
  arm64: move encode_insn_immediate() from module.c to insn.c
  arm64: introduce aarch64_insn_gen_{nop|branch_imm}() helper functions
  arm64, jump label: detect %c support for ARM64
  arm64, jump label: optimize jump label implementation
  jump_label: use defined macros instead of hard-coding for better
    readability

 arch/arm64/Kconfig                  |   1 +
 arch/arm64/include/asm/insn.h       | 108 +++++++++++++
 arch/arm64/include/asm/jump_label.h |  52 ++++++
 arch/arm64/kernel/Makefile          |   3 +-
 arch/arm64/kernel/insn.c            | 304 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/jump_label.c      |  58 +++++++
 arch/arm64/kernel/module.c          | 157 ++++++-------------
 include/linux/jump_label.h          |  19 ++-
 scripts/gcc-goto.sh                 |   2 +-
 9 files changed, 585 insertions(+), 119 deletions(-)
 create mode 100644 arch/arm64/include/asm/insn.h
 create mode 100644 arch/arm64/include/asm/jump_label.h
 create mode 100644 arch/arm64/kernel/insn.c
 create mode 100644 arch/arm64/kernel/jump_label.c

-- 
1.8.1.2

