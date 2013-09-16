Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab3IPJRs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 05:17:48 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:58386 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3IPJRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 05:17:46 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@kernel.org>
Cc: patches@linaro.org, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH v2 0/4] perf: parse the dwarf backtrace info from .debug_frame section
Date: Mon, 16 Sep 2013 11:17:29 +0200
Message-Id: <1379323053-11458-1-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ARM the debug info is not present in the .eh_frame sections but
in .debug_frame instead, in dwarf format.

This patch set uses libunwind to load and parse the dwarf debug info from
the .debug_frame section if no .eh_frame_hdr section is found; also it
sets the hooks in the perf_regs and libunwind code for ARMv7.

Dependencies:
 . if present, libunwind >= 1.1 is needed to prevent a segfault when
   parsing the dwarf info,
 . libunwind needs to be configured with --enable-debug-frame
   to prevent a linkage error. Note: --enable-debug-frame is automatically
   selected on ARM).

The generated perf has been tested on ARMv7 (OMAP4, Marvell Armada XP) and
x86_64, using the following commands:
 perf record -g [dwarf] -- <binary>
 perf report --sort symbol --call-graph --stdio


Jean Pihet (2):
  perf tools: Check libunwind for availability of dwarf parsing feature
  perf: parse the .debug_frame section in case .eh_frame is not present

Will Deacon (2):
  ARM: perf: add support for perf registers API
  ARM: perf: wire up perf_regs and unwind support for ARM

 arch/arm/Kconfig                        |  2 +
 arch/arm/include/uapi/asm/Kbuild        |  1 +
 arch/arm/include/uapi/asm/perf_regs.h   | 23 +++++++++++
 arch/arm/kernel/Makefile                |  1 +
 arch/arm/kernel/perf_regs.c             | 30 ++++++++++++++
 tools/perf/arch/arm/Makefile            |  3 ++
 tools/perf/arch/arm/include/perf_regs.h | 54 +++++++++++++++++++++++++
 tools/perf/arch/arm/util/unwind.c       | 48 ++++++++++++++++++++++
 tools/perf/config/Makefile              |  7 +++-
 tools/perf/config/feature-tests.mak     | 11 ++++-
 tools/perf/util/unwind.c                | 71 +++++++++++++++++++++++++--------
 11 files changed, 232 insertions(+), 19 deletions(-)
 create mode 100644 arch/arm/include/uapi/asm/perf_regs.h
 create mode 100644 arch/arm/kernel/perf_regs.c
 create mode 100644 tools/perf/arch/arm/include/perf_regs.h
 create mode 100644 tools/perf/arch/arm/util/unwind.c

-- 
1.7.11.7

