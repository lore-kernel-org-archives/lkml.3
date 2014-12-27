Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaL0Hi5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 02:38:57 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:56001 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaL0Hiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 02:38:55 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <masami.hiramatsu.pt@hitachi.com>, <tixy@linaro.org>,
        <linux@arm.linux.org.uk>
CC: <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v17 00/11] ARM: kprobes: OPTPROBES and other improvements.
Date: Sat, 27 Dec 2014 15:33:57 +0800
Message-ID: <1419665637-12744-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v17 patch series of kprobeopt. The main change in this version
are:

 1. Patch 02/11 remove 3 useless ARM decode actions.
 2. Patch 10/11 collects register usage of probed instructions.
 3. Patch 11/11 use register usage information to decide whether
    the probed instruction needs simulation or emulation. In most
    of the case, the probed instruction is copied into code template
    and get executed during restoring.

Jon Medhurst (Tixy) (2):
  ARM: kprobes: Add test cases for stack consuming instructions
  ARM: kprobes: Fix unreliable MRS instruction tests

Masami Hiramatsu (1):
  kprobes: Pass the original kprobe for preparing optimized kprobe

Wang Nan (8):
  ARM: probes: move all probe code to dedicate directory
  ARM: kprobes: remove unused ARM decoder actions.
  ARM: kprobes: introduces checker
  ARM: kprobes: collects stack consumption for store instructions
  ARM: kprobes: disallow probing stack consuming instructions
  ARM: kprobes: enable OPTPROBES for ARM 32
  ARM: kprobes: check register usage for probed instruction.
  ARM: optprobes: execute instruction during restoring if possible.

 arch/arm/Kconfig                                   |   1 +
 arch/arm/Makefile                                  |   1 +
 arch/arm/{kernel => include/asm}/insn.h            |   0
 arch/arm/include/asm/kprobes.h                     |  33 +-
 arch/arm/{kernel => include/asm}/patch.h           |   0
 arch/arm/include/asm/probes.h                      |  23 ++
 arch/arm/kernel/Makefile                           |  16 +-
 arch/arm/kernel/entry-armv.S                       |   3 +-
 arch/arm/kernel/ftrace.c                           |   3 +-
 arch/arm/kernel/jump_label.c                       |   5 +-
 arch/arm/kernel/patch.c                            |   3 +-
 arch/arm/probes/Makefile                           |   7 +
 .../{kernel/probes-arm.c => probes/decode-arm.c}   |  12 +-
 .../{kernel/probes-arm.h => probes/decode-arm.h}   |  10 +-
 .../probes-thumb.c => probes/decode-thumb.c}       |  16 +-
 .../probes-thumb.h => probes/decode-thumb.h}       |  10 +-
 arch/arm/{kernel/probes.c => probes/decode.c}      |  81 ++++-
 arch/arm/{kernel/probes.h => probes/decode.h}      |  13 +-
 arch/arm/probes/kprobes/Makefile                   |  12 +
 .../kprobes-arm.c => probes/kprobes/actions-arm.c} |  12 +-
 .../kprobes/actions-common.c}                      |   4 +-
 .../kprobes/actions-thumb.c}                       |  10 +-
 arch/arm/probes/kprobes/checkers-arm.c             | 223 +++++++++++++
 arch/arm/probes/kprobes/checkers-common.c          | 101 ++++++
 arch/arm/probes/kprobes/checkers-thumb.c           | 110 +++++++
 arch/arm/probes/kprobes/checkers.h                 |  55 ++++
 .../{kernel/kprobes.c => probes/kprobes/core.c}    |  49 ++-
 .../{kernel/kprobes.h => probes/kprobes/core.h}    |  12 +-
 arch/arm/probes/kprobes/opt-arm.c                  | 360 +++++++++++++++++++++
 .../kprobes/test-arm.c}                            |  37 ++-
 .../kprobes-test.c => probes/kprobes/test-core.c}  |  36 ++-
 .../kprobes-test.h => probes/kprobes/test-core.h}  |  35 +-
 .../kprobes/test-thumb.c}                          |  20 +-
 arch/arm/probes/uprobes/Makefile                   |   1 +
 .../uprobes-arm.c => probes/uprobes/actions-arm.c} |   9 +-
 .../{kernel/uprobes.c => probes/uprobes/core.c}    |   8 +-
 .../{kernel/uprobes.h => probes/uprobes/core.h}    |   0
 arch/x86/kernel/kprobes/opt.c                      |   3 +-
 include/linux/kprobes.h                            |   3 +-
 kernel/kprobes.c                                   |   4 +-
 40 files changed, 1215 insertions(+), 126 deletions(-)
 rename arch/arm/{kernel => include/asm}/insn.h (100%)
 rename arch/arm/{kernel => include/asm}/patch.h (100%)
 create mode 100644 arch/arm/probes/Makefile
 rename arch/arm/{kernel/probes-arm.c => probes/decode-arm.c} (99%)
 rename arch/arm/{kernel/probes-arm.h => probes/decode-arm.h} (92%)
 rename arch/arm/{kernel/probes-thumb.c => probes/decode-thumb.c} (98%)
 rename arch/arm/{kernel/probes-thumb.h => probes/decode-thumb.h} (90%)
 rename arch/arm/{kernel/probes.c => probes/decode.c} (84%)
 rename arch/arm/{kernel/probes.h => probes/decode.h} (97%)
 create mode 100644 arch/arm/probes/kprobes/Makefile
 rename arch/arm/{kernel/kprobes-arm.c => probes/kprobes/actions-arm.c} (97%)
 rename arch/arm/{kernel/kprobes-common.c => probes/kprobes/actions-common.c} (98%)
 rename arch/arm/{kernel/kprobes-thumb.c => probes/kprobes/actions-thumb.c} (98%)
 create mode 100644 arch/arm/probes/kprobes/checkers-arm.c
 create mode 100644 arch/arm/probes/kprobes/checkers-common.c
 create mode 100644 arch/arm/probes/kprobes/checkers-thumb.c
 create mode 100644 arch/arm/probes/kprobes/checkers.h
 rename arch/arm/{kernel/kprobes.c => probes/kprobes/core.c} (94%)
 rename arch/arm/{kernel/kprobes.h => probes/kprobes/core.h} (79%)
 create mode 100644 arch/arm/probes/kprobes/opt-arm.c
 rename arch/arm/{kernel/kprobes-test-arm.c => probes/kprobes/test-arm.c} (97%)
 rename arch/arm/{kernel/kprobes-test.c => probes/kprobes/test-core.c} (98%)
 rename arch/arm/{kernel/kprobes-test.h => probes/kprobes/test-core.h} (92%)
 rename arch/arm/{kernel/kprobes-test-thumb.c => probes/kprobes/test-thumb.c} (97%)
 create mode 100644 arch/arm/probes/uprobes/Makefile
 rename arch/arm/{kernel/uprobes-arm.c => probes/uprobes/actions-arm.c} (96%)
 rename arch/arm/{kernel/uprobes.c => probes/uprobes/core.c} (97%)
 rename arch/arm/{kernel/uprobes.h => probes/uprobes/core.h} (100%)

-- 
1.8.4

