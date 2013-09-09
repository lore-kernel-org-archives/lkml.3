Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab3IIKAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:00:44 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:45795 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3IIKAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:00:43 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org
Cc: patches@linaro.org, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 0/3] perf: parse the dwarf backtrace info from .debug_frame section
Date: Mon,  9 Sep 2013 12:00:12 +0200
Message-Id: <1378720815-23964-1-git-send-email-jean.pihet@linaro.org>
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

The generated perf has been tested on ARMv7/OMAP4 and x86_64, using the
following commands:
 perf record -g [dwarf] -- <binary>
 perf report --sort symbol --call-graph --stdio


Jean Pihet (1):
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
 tools/perf/config/Makefile              |  9 +++--
 tools/perf/util/unwind.c                | 71 +++++++++++++++++++++++++--------
 10 files changed, 223 insertions(+), 19 deletions(-)
 create mode 100644 arch/arm/include/uapi/asm/perf_regs.h
 create mode 100644 arch/arm/kernel/perf_regs.c
 create mode 100644 tools/perf/arch/arm/include/perf_regs.h
 create mode 100644 tools/perf/arch/arm/util/unwind.c

-- 
1.7.11.7

