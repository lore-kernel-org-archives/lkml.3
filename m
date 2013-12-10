Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3LJQGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:06:36 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:58621 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab3LJQGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:06:35 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Jiang Liu <liuj97@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 0/7] Optimize jump label implementation for ARM64
Date: Wed, 11 Dec 2013 00:03:46 +0800
Message-Id: <1386691433-6827-1-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset tries to optimize arch specfic jump label implementation
for ARM64 by dynamic kernel text patching.

To enable this feature, your toolchain must support "asm goto" extension
and "%c" constraint extesion. Current GCC for AARCH64 doesn't support
"%c", and there's a patch for it now:
http://gcc.gnu.org/ml/gcc-patches/2013-10/msg01314.html

It has been tested on ARM Fast mode and a real hardware platform.

Any comments are welcomed!

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
 arch/arm64/include/asm/jump_label.h |  51 ++++++
 arch/arm64/kernel/Makefile          |   3 +-
 arch/arm64/kernel/insn.c            | 302 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/jump_label.c      |  59 +++++++
 arch/arm64/kernel/module.c          | 157 ++++++-------------
 include/linux/jump_label.h          |  15 +-
 scripts/gcc-goto.sh                 |   2 +-
 9 files changed, 581 insertions(+), 117 deletions(-)
 create mode 100644 arch/arm64/include/asm/insn.h
 create mode 100644 arch/arm64/include/asm/jump_label.h
 create mode 100644 arch/arm64/kernel/insn.c
 create mode 100644 arch/arm64/kernel/jump_label.c

-- 
1.8.1.2

