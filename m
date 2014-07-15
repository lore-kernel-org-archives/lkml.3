Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbaGOAbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 20:31:49 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45051 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbaGOAbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 20:31:46 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        acme@redhat.com, namhyung@kernel.org
Subject: [PATCH v2 0/5] perf: add ability to sample interrupted machine state
Date: Tue, 15 Jul 2014 02:31:39 +0200
Message-Id: <1405384304-26816-1-git-send-email-eranian@google.com>
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

Stephane Eranian (5):
  perf: add ability to sample machine state on interrupt
  perf/x86: add support for sampling PEBS machine state registers
  perf tools: add core support for sampling intr machine state regs
  perf/tests: add interrupted state sample parsing test
  perf record: add new -I option to sample interrupted machine state

 arch/x86/kernel/cpu/perf_event_intel_ds.c |   19 ++++++++++
 include/linux/perf_event.h                |    7 ++--
 include/uapi/linux/perf_event.h           |   14 +++++++-
 kernel/events/core.c                      |   44 +++++++++++++++++++++--
 tools/perf/Documentation/perf-record.txt  |    6 ++++
 tools/perf/builtin-record.c               |    2 ++
 tools/perf/perf.h                         |    1 +
 tools/perf/tests/sample-parsing.c         |   55 +++++++++++++++++++++--------
 tools/perf/util/event.h                   |    1 +
 tools/perf/util/evsel.c                   |   46 +++++++++++++++++++++++-
 tools/perf/util/session.c                 |   44 ++++++++++++++++++++---
 11 files changed, 213 insertions(+), 26 deletions(-)

-- 
1.7.9.5

