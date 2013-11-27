Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab3K0Cxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:53:42 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:46653 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab3K0Cxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:53:40 -0500
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Cc: Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/15] uprobes: Add uprobes support for ARM
Date: Tue, 26 Nov 2013 21:53:19 -0500
Message-Id: <1385520814-10663-1-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

This patch series adds basic uprobes support to ARM. It is based on patches
developed earlier by Rabin Vincent. That approach of adding hooks into
the kprobes instruction parsing code was not well received. This approach
separates the ARM instruction parsing code in kprobes out into a separate set
of functions which can be used by both kprobes and uprobes. Both kprobes and
uprobes then provide their own semantic action tables to process the results of
the parsing.

The following are noteworthy changes made for v3:

1) The ARM uprobes functionality no longer depends on kprobes. As
a side effect of this there are no longer any changes to the common
kprobes include file (or any other common kprobes files).
2) A couple large patches have been broken down into more smaller
patches.
3) A problem with uretprobes has been fixed.
4) The kprobes-test module has been made more useable for thumb tests.
5) The argument list to the "action" functions has been shrunk.
6) Alignment with a few recent patches that were made to common
uprobes code specifically to support this patchset.

This patchset is based on v3.13-rc1


David A. Long (14):
  uprobes: allow ignoring of probe hits
  ARM: move shared uprobe/kprobe definitions into new include file
  ARM: Move generic arm instruction parsing code to new files for
    sharing between features
  ARM: move generic thumb instruction parsing code to new files for use
    by other feature
  ARM: use a function table for determining instruction interpreter
    actions
  ARM: Remove use of struct kprobe from generic probes code
  ARM: Use new opcode type in ARM kprobes/uprobes code
  ARM: Make the kprobes condition_check symbol names more generic
  ARM: Change more ARM kprobes symbol names to something more
  ARM: Rename the shared kprobes/uprobe return value enum
  ARM: Change the remaining shared kprobes/uprobes symbols to something
    generic
  ARM: Add an emulate flag to the kprobes/uprobes instruction decode
    functions
  ARM: add uprobes support
  ARM: Remove uprobes dependency on kprobes

Jon Medhurst (Tixy) (1):
  ARM: Disable jprobes test when built into thumb-mode kernel

 arch/arm/Kconfig                                   |    3 +
 arch/arm/include/asm/kprobes.h                     |   15 +-
 arch/arm/include/asm/probes.h                      |   25 +
 arch/arm/include/asm/ptrace.h                      |    6 +
 arch/arm/include/asm/thread_info.h                 |    5 +-
 arch/arm/include/asm/uprobes.h                     |   34 +
 arch/arm/kernel/Makefile                           |    7 +-
 arch/arm/kernel/kprobes-arm.c                      |  804 ++------------
 arch/arm/kernel/kprobes-common.c                   |  468 +-------
 arch/arm/kernel/kprobes-test.c                     |   18 +-
 arch/arm/kernel/kprobes-thumb.c                    | 1141 +++-----------------
 arch/arm/kernel/kprobes.c                          |   24 +-
 arch/arm/kernel/kprobes.h                          |  399 +------
 arch/arm/kernel/{kprobes-arm.c => probes-arm.c}    |  441 ++------
 arch/arm/kernel/probes-arm.h                       |   72 ++
 .../arm/kernel/{kprobes-thumb.c => probes-thumb.c} |  771 ++-----------
 arch/arm/kernel/probes-thumb.h                     |   95 ++
 arch/arm/kernel/{kprobes-common.c => probes.c}     |  215 +---
 arch/arm/kernel/{kprobes.h => probes.h}            |   91 +-
 arch/arm/kernel/signal.c                           |    4 +
 arch/arm/kernel/uprobes-arm.c                      |  223 ++++
 arch/arm/kernel/uprobes.c                          |  198 ++++
 arch/arm/kernel/uprobes.h                          |   27 +
 include/linux/uprobes.h                            |    1 +
 kernel/events/uprobes.c                            |    9 +
 25 files changed, 1267 insertions(+), 3829 deletions(-)
 create mode 100644 arch/arm/include/asm/probes.h
 create mode 100644 arch/arm/include/asm/uprobes.h
 copy arch/arm/kernel/{kprobes-arm.c => probes-arm.c} (64%)
 create mode 100644 arch/arm/kernel/probes-arm.h
 copy arch/arm/kernel/{kprobes-thumb.c => probes-thumb.c} (56%)
 create mode 100644 arch/arm/kernel/probes-thumb.h
 copy arch/arm/kernel/{kprobes-common.c => probes.c} (67%)
 copy arch/arm/kernel/{kprobes.h => probes.h} (85%)
 create mode 100644 arch/arm/kernel/uprobes-arm.c
 create mode 100644 arch/arm/kernel/uprobes.c
 create mode 100644 arch/arm/kernel/uprobes.h

-- 
1.8.1.2

