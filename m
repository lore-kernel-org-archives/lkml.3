Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbaJMPoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 11:44:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:41008 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbaJMPoD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 11:44:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,711,1406617200"; 
   d="scan'208";a="617796402"
From: "Liang, Kan" <kan.liang@intel.com>
To: "jolsa@redhat.com" <jolsa@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "acme@kernel.org" <acme@kernel.org>
Subject: RE: [PATCH V8 0/4] perf tools: pmu event new style format fix
Thread-Topic: [PATCH V8 0/4] perf tools: pmu event new style format fix
Thread-Index: AQHP4kGaW0NYPLd3iU6YrYxX+h3A0pwuMiQg
Date: Mon, 13 Oct 2014 15:43:18 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F077016237E7@SHSMSX103.ccr.corp.intel.com>
References: <1412694532-23391-1-git-send-email-kan.liang@intel.com>
In-Reply-To: <1412694532-23391-1-git-send-email-kan.liang@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jolsa,

Does the new patch set work on your machine?
I tested the V8 patch set on haswell, ivybridge and Romley platform,
I cannot reproduce the issue you mentioned.
Could you please try the latest V8 patch? 

Thanks,
Kan

> From: Kan Liang <kan.liang@intel.com>
> 
> There are two types of pmu event stytle formats, "pmu_event_name"
> or "cpu/pmu_event_name/". However, there is a bug on supporting these
> two formats, especially when they mixed with other perf events.
> The patch set intends to fix this issue.
> 
> The patch set has been tested by perf automated test "./perf test parse -v"
> on haswell, ivybridge and Romley platform.
> The patch set also has been tested on haswell by the following script.
> (Note: please make sure that your test system support TSX and L1-dcache-
> loads events. Otherwise, you may want to change the events to other pmu
> events.)
> 
> [lk@localhost ~]$ cat perf_style_test.sh #hardware events + kernel pmu
> event with different style perf stat -x, -e cycles,mem-stores,tx-start sleep 2
> perf stat -x, -e cpu-cycles,cycles-ct,cycles-t sleep 2 perf stat -x, -e
> cycles,cpu/cycles-ct/,cpu/cycles-t/ sleep 2 perf stat -x, -e instructions,cpu/tx-
> start/ sleep 2 perf stat -x, -e '{cycles,tx-start}' sleep 2 perf stat -x, -e
> '{cycles,cpu/tx-start/}' sleep 2
> 
> #HW Cache event + kernel pmu event with different style perf stat -x, -e L1-
> dcache-loads,cpu/mem-stores/,tx-start sleep 2 perf stat -x, -e L1-dcache-
> loads,mem-stores,cpu/tx-start/ sleep 2 perf stat -x, -e '{L1-dcache-
> loads,mem-stores}' sleep 2 perf stat -x, -e '{L1-dcache-loads,cpu/tx-start/}'
> sleep 2
> 
> #Raw event + kernel pmu event with different style:
> perf stat -x, -e cpu/event=0xc0,umask=0x00/,mem-loads,cpu/mem-stores/
> sleep 2 perf stat -x, -e cpu/event=0xc0,umask=0x00/,tx-start,cpu/el-start/
> sleep 2 perf stat -x, -e '{cpu/event=0xc0,umask=0x00/,tx-start}' sleep 2
> 
> Changes since V1:
> Read kernel PMU events from sysfs at runtime
> 
> Changes since V2:
> Use strlcpy to replace strncpy
> 
> Changes since V3:
> rebase to git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core
> 
> Changes since V4:
> scan kernel pmu events from sysfs only needed rename the
> init/check/clenup functions and related struct.
> allocate each symbol string separatelly
> Use ALLOC_LIST
> 
> Changes since V5:
> Using perf_pmu__find to instead of perf_pmu__scan Don't scan all the time
> if the system doesn't support kernel pmu events
> 
> Changes since V6:
> Add test case in automated tests suite
> Use strdup and macro to refine the code
> Add sep_dc for PMU event to support PE_MODIFIER_EVENT Some minor
> changes for code style
> 
> Changes since V7:
> Add allocation failure check
> 
> Kan Liang (4):
>   Revert "perf tools: Default to cpu// for events v5"
>   perf tools: parse the pmu event prefix and suffix
>   perf tools: Add support to new style format of kernel PMU event
>   perf tools: Add test case for pmu event new style format
> 
>  tools/perf/tests/parse-events.c        |  36 +++++++++
>  tools/perf/util/include/linux/string.h |   1 -
>  tools/perf/util/parse-events.c         | 133 +++++++++++++++++++++++++++-
> -----
>  tools/perf/util/parse-events.h         |  14 ++++
>  tools/perf/util/parse-events.l         |  30 +++++++-
>  tools/perf/util/parse-events.y         |  40 ++++++++++
>  tools/perf/util/pmu.c                  |  10 ---
>  tools/perf/util/pmu.h                  |  10 +++
>  tools/perf/util/string.c               |  24 ------
>  9 files changed, 240 insertions(+), 58 deletions(-)
> 
> --
> 1.8.3.2

