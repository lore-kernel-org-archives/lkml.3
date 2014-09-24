Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbaIXLtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:49:00 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:65444 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbaIXLs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:48:59 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        acme@redhat.com, cebbert.lkml@gmail.com
Subject: [PATCH v7 0/6] perf: add ability to sample interrupted machine state
Date: Wed, 24 Sep 2014 13:48:36 +0200
Message-Id: <1411559322-16548-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This short patch series add the ability to sample the interrupted
machine state for each hardware sample. This is useful to analyze
the state after certain events, for instance for function value
profiling after a call instruction.

The patch extends the interface with a new PERF_SAMPLE_REGS_INTR 
smaple_type flag. The register to sample can be named in the
sample_regs_intr bitmask for each event. The name and bit
position for each register is architecture dependent and
provided, just like for PERF_SAMPLE_REGS_USER by asm/perf_regs.h.

The support is similar to PERF_SAMPLE_REGS_USER.

On Intel x86, the series includes support for capturing the
PEBS state as well. When precise sampling is used, the interrupted
state is collect from the PEBS records, at least partially.
The PEBS machine state is a subset of the machine state.

The series provides access to this new feature in perf record
with the -I option. It is possible to display the sampled
register values using perf report -D.

This patch series is the fundation for a future series adding
function value profiling.

In V2, we address the issues raised during reviews:
 - add sample parsing test
 - shorten perf record option to --intr-regs
 - added man page for perf record -I/--intr-regs option
 - refactor register printf code between user and intr regs
 - rebase to v3.16-rc3

In V3, we rebase to 3.16.0+ and made the modifications suggested
by PeterZ. We also integrated his patch to improve the layout
of perf_sample_data.

In V4, we rebase to 3.17-rc3 and we fix the ABI change issue 
reported by Namhyung Kim.

In V5, the patch is rebased to 3.17-rc4 and the bugs reported
on LKML about the PEBS machine state copying code have been fixed
(a few registers were missing).

In V6, we added the missing copy of the eflags from the PEBS
mahcine state (reported by Andi). We fixed some formatting
issues. We rebased to 3.17-rc6.

In V7, we fix the eflags compilation error, we added
the #ifndef CONFIG_X86_32 to enable 32-bit compilations.
Still relative to 3.17-rc6

Peter Zijlstra (1):
  perf: improve perf_sample_data struct layout

Stephane Eranian (5):
  perf: add ability to sample machine state on interrupt
  perf/x86: add support for sampling PEBS machine state registers
  perf tools: add core support for sampling intr machine state regs
  perf/tests: add interrupted state sample parsing test
  perf record: add new -I option to sample interrupted machine state

 arch/x86/kernel/cpu/perf_event_intel_ds.c |   23 ++++++++++++
 include/linux/perf_event.h                |   37 ++++++++++---------
 include/uapi/linux/perf_event.h           |   15 +++++++-
 kernel/events/core.c                      |   51 ++++++++++++++++++++++++--
 tools/perf/Documentation/perf-record.txt  |    6 ++++
 tools/perf/builtin-record.c               |    2 ++
 tools/perf/perf.h                         |    1 +
 tools/perf/tests/sample-parsing.c         |   55 +++++++++++++++++++++--------
 tools/perf/util/event.h                   |    1 +
 tools/perf/util/evsel.c                   |   46 +++++++++++++++++++++++-
 tools/perf/util/header.c                  |    1 +
 tools/perf/util/session.c                 |   44 ++++++++++++++++++++---
 12 files changed, 240 insertions(+), 42 deletions(-)

-- 
1.7.9.5

