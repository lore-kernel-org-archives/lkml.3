Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbaIKTJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 15:09:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:41856 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056AbaIKTJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 15:09:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,506,1406617200"; 
   d="scan'208";a="571925950"
From: kan.liang@intel.com
To: acme@kernel.org, jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V6 0/3] perf tools: pmu event new style format fix
Date: Thu, 11 Sep 2014 15:08:56 -0400
Message-Id: <1410462539-5468-1-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

There are two types of pmu event stytle formats, "pmu_event_name"
or "cpu/pmu_event_name/". However, there is a bug on supporting these
two formats, especially when they mixed with other perf events.
The patch set intends to fix this issue.

The patch set has been tested on my haswell.
Here is the test script I used for this issue.
(Note: please make sure that your test system supports TSX and
L1-dcache-loads events. Otherwise, you may want to change the events 
to other pmu events.)

[lk@localhost ~]$ cat perf_style_test.sh
#hardware events + kernel pmu event with different style
perf stat -x, -e cycles,mem-stores,tx-start sleep 2
perf stat -x, -e cpu-cycles,cycles-ct,cycles-t sleep 2
perf stat -x, -e cycles,cpu/cycles-ct/,cpu/cycles-t/ sleep 2
perf stat -x, -e instructions,cpu/tx-start/ sleep 2
perf stat -x, -e '{cycles,tx-start}' sleep 2
perf stat -x, -e '{cycles,cpu/tx-start/}' sleep 2

#HW Cache event + kernel pmu event with different style
perf stat -x, -e L1-dcache-loads,cpu/mem-stores/,tx-start sleep 2
perf stat -x, -e L1-dcache-loads,mem-stores,cpu/tx-start/ sleep 2
perf stat -x, -e '{L1-dcache-loads,mem-stores}' sleep 2
perf stat -x, -e '{L1-dcache-loads,cpu/tx-start/}' sleep 2

#Raw event + kernel pmu event with different style:
perf stat -x, -e cpu/event=0xc0,umask=0x00/,mem-loads,cpu/mem-stores/ sleep 2
perf stat -x, -e cpu/event=0xc0,umask=0x00/,tx-start,cpu/el-start/ sleep 2
perf stat -x, -e '{cpu/event=0xc0,umask=0x00/,tx-start}' sleep 2

Changes since V1:
Read kernel PMU events from sysfs at runtime

Changes since V2:
Use strlcpy to replace strncpy

Changes since V3:
rebase to git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core

Changes since V4:
scan kernel pmu events from sysfs only needed
rename the init/check/clenup functions and related struct.
allocate each symbol string separatelly
Use ALLOC_LIST

Changes since V5:
Using perf_pmu__find to instead of perf_pmu__scan
Don't scan all the time if the system doesn't support kernel pmu events

Kan Liang (3):
  Revert "perf tools: Default to cpu// for events v5"
  perf tools: parse the pmu event prefix and surfix
  perf tools: Add support to new style format of kernel PMU event

 tools/perf/util/include/linux/string.h |   1 -
 tools/perf/util/parse-events.c         | 128 +++++++++++++++++++++++++++------
 tools/perf/util/parse-events.h         |  14 ++++
 tools/perf/util/parse-events.l         |  30 +++++++-
 tools/perf/util/parse-events.y         |  40 +++++++++++
 tools/perf/util/pmu.c                  |  10 ---
 tools/perf/util/pmu.h                  |  10 +++
 tools/perf/util/string.c               |  24 -------
 8 files changed, 199 insertions(+), 58 deletions(-)

-- 
1.8.3.2

