Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3DWFne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 01:43:34 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:52294 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab3DWFnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 01:43:11 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org
Subject: [PATCH V4 0/5] powerpc, perf: BHRB based branch stack enablement on POWER8
Date: Tue, 23 Apr 2013 11:12:39 +0530
Message-Id: <1366695764-3073-1-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042305-4790-0000-0000-000007F92548
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

                Branch History Rolling Buffer (BHRB) is a new PMU feaure in IBM
POWER8 processor which records the branch instructions inside the execution
pipeline. This patchset enables the basic functionality of the feature through
generic perf branch stack sampling framework.

Sample output
-------------
$./perf record -b top
$./perf report

Overhead  Command  Source Shared Object                           Source Symbol  Target Shared Object                        Target Symbol
# ........  .......  ....................  ......................................  ....................  ...................................
#

     7.82%      top  libc-2.11.2.so        [k] _IO_vfscanf                         libc-2.11.2.so        [k] _IO_vfscanf
     6.17%      top  libc-2.11.2.so        [k] _IO_vfscanf                         [unknown]             [k] 00000000
     2.37%      top  [unknown]             [k] 0xf7aafb30                          [unknown]             [k] 00000000
     1.80%      top  [unknown]             [k] 0x0fe07978                          libc-2.11.2.so        [k] _IO_vfscanf
     1.60%      top  libc-2.11.2.so        [k] _IO_vfscanf                         [kernel.kallsyms]     [k] .do_task_stat
     1.20%      top  [kernel.kallsyms]     [k] .do_task_stat                       [kernel.kallsyms]     [k] .do_task_stat
     1.02%      top  libc-2.11.2.so        [k] vfprintf                            libc-2.11.2.so        [k] vfprintf
     0.92%      top  top                   [k] _init                               [unknown]             [k] 0x0fe037f4

Changes in V2
--------------
- Added copyright messages to the newly created files
- Modified couple of commit messages

Changes in V3
-------------
- Incorporated review comments from Segher https://lkml.org/lkml/2013/4/16/350
- Worked on a solution for review comment from Michael Ellerman https://lkml.org/lkml/2013/4/17/548
	- Could not move updated cpu_hw_events structure from core-book3s.c file into perf_event_server.h
          Because perf_event_server.h is pulled in first inside linux/perf_event.h before the definition of
          perf_branch_entry structure. Thats the reason why perf_branch_entry definition is not available
          inside perf_event_server.h where we define the array inside cpu_hw_events structure.

	- Finally have pulled in the code from perf_event_bhrb.c into core-book3s.c

- Improved documentation for the patchset

Changes in V4
-------------
- Incorporated review comments on V3 regarding new instruction encoding

Anshuman Khandual (5):
  powerpc, perf: Add new BHRB related instructions for POWER8
  powerpc, perf: Add basic assembly code to read BHRB entries on POWER8
  powerpc, perf: Add new BHRB related generic functions, data and flags
  powerpc, perf: Define BHRB generic functions, data and flags for POWER8
  powerpc, perf: Enable branch stack sampling framework

 arch/powerpc/include/asm/perf_event_server.h |   7 ++
 arch/powerpc/include/asm/ppc-opcode.h        |   8 ++
 arch/powerpc/perf/Makefile                   |   2 +-
 arch/powerpc/perf/bhrb.S                     |  44 +++++++
 arch/powerpc/perf/core-book3s.c              | 167 ++++++++++++++++++++++++++-
 arch/powerpc/perf/power8-pmu.c               |  57 ++++++++-
 6 files changed, 280 insertions(+), 5 deletions(-)
 create mode 100644 arch/powerpc/perf/bhrb.S

-- 
1.7.11.7

