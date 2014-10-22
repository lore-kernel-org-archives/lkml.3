Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314AbaJVLfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:35:47 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:25506 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932958AbaJVLeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:34:05 -0400
From: Wang Nan <wangnan0@huawei.com>
To: <tixy@linaro.org>, <masami.hiramatsu.pt@hitachi.com>,
        <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        <dave.long@linaro.org>, <taras.kondratiuk@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Christoph Lameter <cl@linux.com>, Rabin Vincent <rabin@rab.in>,
        "David S. Miller" <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        "Li Zefan" <lizefan@huawei.com>
Subject: [PATCH v6 0/7] ARM: kprobes: enable OPTPROBES for ARM 32.
Date: Wed, 22 Oct 2014 19:31:58 +0800
Message-ID: <1413977525-51480-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous 5 version of ARM OPTPROBES patches are unable to deal with
stack storing instructions correctly. V5 patches disallow optimizing
every protential stack store instructions based on pessimistic
assumption. Which, as Tixy comments, 'excludes the main use of
kprobes'. (https://lkml.org/lkml/2014/8/29/117 )

The main obstacle which prevents us from computing stack requirement is
the missing of per-instruction decoder in probes_decode_insn() and its
friends. Only part of instructions have their decoders (and not in
each case).

In this patch series, I propose 'checker', which allows us define
functions for each type of instruction, extract more information.  Stack
consumption computing is an example. Checker can be further employed to
determine whether one instruction is possible to execute directy in
optimized kprobe. I'd like to expand current checker framework by
chaining checkers together. After that, I believe most of ARM
instructions can be executed directly like x86, kprobe performace can be
improved.

The first 3 patches introduces checker. After that, patch 4/7 checks
stack requirement for probed instructions. Patches 5/7 - 7/7 are similar
to patch v5, except:

 1. As Tixy proposed, unoptimized probes are also suffer from stack
    problem (https://lkml.org/lkml/2014/9/1/548 ). Commit d30a0c8b saves
    64 bytes for them, but for instruction use register addressing (like
    'str r0, [sp, r1]'), 64 bytes are unsafe. Patch 5/7 prohibit such
    probing according to stack information collected by checker.

 2. In patch 7/7, stack protection code now is generated according to
    the instruction be optimized.

 3. In patch 7/7, kprobes-opt.c is renamed to kprobes-opt-arm.c due to
    it only deal with ARM case.

 4. Bug in v5 is fixed.

Wang Nan (7):
  ARM: kprobes: replace 'union decode_action' to 'struct decode_action'
  ARM: kprobes: seprates load and store actions
  ARM: kprobes: introduces checker
  ARM: kprobes: collects stack consumption for store instructions
  ARM: kprobes: disallow probing stack consuming instructions
  kprobes: copy ainsn after alloc aggr kprobe
  ARM: kprobes: enable OPTPROBES for ARM 32

 arch/arm/Kconfig                     |   1 +
 arch/arm/include/asm/kprobes.h       |  26 ++++
 arch/arm/include/asm/probes.h        |   1 +
 arch/arm/kernel/Makefile             |   3 +-
 arch/arm/kernel/kprobes-arm.c        |  12 +-
 arch/arm/kernel/kprobes-opt-arm.c    | 285 +++++++++++++++++++++++++++++++++++
 arch/arm/kernel/kprobes-test-arm.c   |  17 ++-
 arch/arm/kernel/kprobes-test-thumb.c |  13 ++
 arch/arm/kernel/kprobes-thumb.c      |  24 +--
 arch/arm/kernel/kprobes.c            |  10 +-
 arch/arm/kernel/kprobes.h            |   8 +-
 arch/arm/kernel/probes-arm.c         |  32 +++-
 arch/arm/kernel/probes-arm.h         |  15 +-
 arch/arm/kernel/probes-thumb.c       | 152 ++++++++++++++++---
 arch/arm/kernel/probes-thumb.h       |  31 +++-
 arch/arm/kernel/probes.c             |  76 +++++++++-
 arch/arm/kernel/probes.h             |  27 +++-
 arch/arm/kernel/uprobes-arm.c        |  12 +-
 arch/arm/kernel/uprobes.h            |   2 +-
 kernel/kprobes.c                     |   6 +
 20 files changed, 679 insertions(+), 74 deletions(-)
 create mode 100644 arch/arm/kernel/kprobes-opt-arm.c

-- 
1.8.4

