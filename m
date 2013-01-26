Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab3AZUEP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 15:04:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab3AZUEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 15:04:12 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [RFCv2 0/8] perf tools: Add non-architectural event aliases
Date: Sat, 26 Jan 2013 21:04:02 +0100
Message-Id: <1359230650-10415-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding support to use non-architectural events in perf via name,
to be able to use them like:

$ perf stat -e 'cpu/IDQ.ALL_DSB_CYCLES/' ...
$ perf stat -e 'cpu/L2_STORE_LOCK_RQSTS.MISS/' ...
...

The perf list command displays current non-arch. events available:

$ perf list
...
  cpu/AGU_BYPASS_CANCEL.COUNT/                       [Kernel PMU event]
  cpu/ARITH.FPU_DIV/                                 [Kernel PMU event]
  cpu/ARITH.FPU_DIV_ACTIVE/                          [Kernel PMU event]
  cpu/BACLEARS.ANY/                                  [Kernel PMU event]
...

This version is dependent on precise changes:
http://marc.info/?l=linux-kernel&m=135922143117888&w=2

First version of this RFC is here:
http://marc.info/?l=linux-kernel&m=135575146128720&w=2

This version provides support for non-architectural events
aliasses being defined in sigle files, like for SandyBridge:

$ cat arch/x86/events/intel/snb | head -5
name=AGU_BYPASS_CANCEL.COUNT,event=0xb6,umask=0x1
name=ARITH.FPU_DIV_ACTIVE,event=0x14,umask=0x1
name=ARITH.FPU_DIV,event=0x14,umask=0x10401
name=BACLEARS.ANY,event=0xe6,umask=0x1f
...

So far this is still under testing and only SandyBridge and IvyBridge
events were added. I have no problem to add the rest of the archs.
when the shape of this is agreed.

Available also at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git
  perf/nonarch9

any comments are welcome,
jirka


---
Andi Kleen (1):
      perf tools: List kernel supplied event aliases in perf list v2

Jiri Olsa (7):
      perf tools: Add '.' as part of the event 'name' token
      perf tools: Change perf_pmu__new_alias function interface
      perf tools: Add name term processing for alias
      perf tools: Add pmu interface to parse single file of aliases
      perf tools: Add support to include non architectural event aliases
      perf tools: Add non arch events for SandyBridge microarchitecture
      perf tools: Add non arch events for IvyBridge micro architecture

 tools/perf/Documentation/perf-list.txt |   4 +-
 tools/perf/arch/x86/Makefile           |  11 ++++
 tools/perf/arch/x86/events/intel/ivb   | 248 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/arch/x86/events/intel/snb   | 274 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/arch/x86/util/pmu.c         | 125 ++++++++++++++++++++++++++++++++++++++++++
 tools/perf/builtin-list.c              |   3 +
 tools/perf/util/parse-events.c         |  24 ++------
 tools/perf/util/parse-events.l         |   4 +-
 tools/perf/util/pmu.c                  | 158 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 tools/perf/util/pmu.h                  |   9 +++
 10 files changed, 824 insertions(+), 36 deletions(-)
