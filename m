Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbbAOMgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:36:52 -0500
Received: from service87.mimecast.com ([91.220.42.44]:35574 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbbAOMgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:36:16 -0500
From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: leo.yan@linaro.org, yexl@marvell.com, Will.Deacon@arm.com,
        Catalin.Marinas@arm.com, mark.rutland@arm.com,
        linux-kernel@vger.kernel.org,
        "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Subject: [PATCHv2 0/3] Handle SETEND for AArch32 tasks
Date: Thu, 15 Jan 2015 12:36:03 +0000
Message-Id: <1421325366-13263-1-git-send-email-suzuki.poulose@arm.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 15 Jan 2015 12:36:13.0264 (UTC) FILETIME=[D914A500:01D030BF]
X-MC-Unique: 115011512361401401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id t0FCb6E8014021

From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>

This series add support for controlling the 'setend' instruction,
which is deprecated in ARMv8, using the legacy instruction emulation
framework, introduced by Punit Agrawal.


Changes since V1:
 - Added a patch to keep track of the mixed endian support and register
   the setend emulation only if all the active CPUs supports mixed endian.
 - Fail hotplug operation if the CPU doesn't support a feature
   required by insn_emulation.
 - Signal handler runs in native endian

Testing :

 $ cat setend_sig.c 
 #include <stdio.h>
 #include <signal.h>

 #define setend_be(a)	asm __volatile__ ( "setend be" ::: "memory" )
 #define setend_le(a)	asm __volatile__ ( "setend le" ::: "memory" )

 volatile int flag = 1;

 void sigint(int sig)
 {
	printf("in sighandler %d\n", sig);
	flag = 0;
	return;
 }

 main()
 {
	volatile int a = 0x0;

	(void)signal(SIGINT, sigint);
	printf("Press Ctrl+C to continue\n");
	setend_be();
	a ++;

	while (flag);

	setend_le();
	a ++;

	printf("a: 0x%x\n", a);
	return 0;
 }
 $ cat /proc/sys/abi/setend 
 1
 $ echo 1 > /sys/kernel/debug/tracing/events/emulation/instruction_emulation/enable 
 $ echo 1 > /sys/kernel/debug/tracing/tracing_on 
 $ ./setend_sig_a32 
 Press Ctrl+C to continue
 ^Cin sighandler 2
 a: 0x1000001
 $ cat /sys/kernel/debug/tracing/trace
 # tracer: nop
 #
 # entries-in-buffer/entries-written: 2/2   #P:2
 #
 #                              _-----=> irqs-off
 #                             / _----=> need-resched
 #                            | / _---=> hardirq/softirq
 #                            || / _--=> preempt-depth
 #                            ||| /     delay
 #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
 #              | |       |   ||||       |         |
   setend_sig_a32-1373  [000] ...1   491.554499: instruction_emulation: instr="setend be" addr=0x8460
   setend_sig_a32-1373  [000] ...1   492.833056: instruction_emulation: instr="setend le" addr=0x8488
 $ dmesg | tail
 [  491.554807] "setend_sig_a32" (1373) uses deprecated setend instruction at 0x8460
 [  492.833285] "setend_sig_a32" (1373) uses deprecated setend instruction at 0x8488
 $ echo 2 > /proc/sys/abi/setend
 $ ./setend_sig_t16 
 Press Ctrl+C to continue
 ^Cin sighandler 2
 a: 0x1000001
 $ dmesg | tail
 [  491.554807] "setend_sig_a32" (1373) uses deprecated setend instruction at 0x8460
 [  492.833285] "setend_sig_a32" (1373) uses deprecated setend instruction at 0x8488
 [  537.426216] Removed setend emulation handler
 [  537.426624] Enabled setend support

Suzuki K. Poulose (3):
  arm64: Track system support for mixed endian EL0
  arm64: Consolidate hotplug notifier for instruction emulation
  arm64:  Emulate SETEND for AArch32 tasks

 Documentation/arm64/legacy_instructions.txt |   13 ++
 arch/arm64/Kconfig                          |   10 ++
 arch/arm64/include/asm/cpufeature.h         |   13 ++
 arch/arm64/include/asm/ptrace.h             |    7 +
 arch/arm64/kernel/armv8_deprecated.c        |  195 ++++++++++++++++++++-------
 arch/arm64/kernel/cpuinfo.c                 |   22 +++
 arch/arm64/kernel/signal32.c                |    5 +-
 7 files changed, 214 insertions(+), 51 deletions(-)

-- 
1.7.9.5


