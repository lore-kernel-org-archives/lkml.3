Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaJETIK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 15:08:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbaJETII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 15:08:08 -0400
Date: Sun, 5 Oct 2014 21:08:02 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, acme@kernel.org
Subject: Re: [PATCH V7 0/4] perf tools: pmu event new style format fix
Message-ID: <20141005190802.GC1934@krava.redhat.com>
References: <1412352548-7603-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412352548-7603-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 12:09:04PM -0400, kan.liang@intel.com wrote:
> From: Kan Liang <kan.liang@intel.com>
> 
> There are two types of pmu event stytle formats, "pmu_event_name"
> or "cpu/pmu_event_name/". However, there is a bug on supporting these
> two formats, especially when they mixed with other perf events.
> The patch set intends to fix this issue.
> 
> The patch set has been tested on my haswell.
> Here is the test script I used for this issue.
> (Note: please make sure that your test system support TSX and
> L1-dcache-loads events. Otherwise, you may want to change the events
> to other pmu events.)
> 
> [lk@localhost ~]$ cat perf_style_test.sh
> #hardware events + kernel pmu event with different style
> perf stat -x, -e cycles,mem-stores,tx-start sleep 2
> perf stat -x, -e cpu-cycles,cycles-ct,cycles-t sleep 2
> perf stat -x, -e cycles,cpu/cycles-ct/,cpu/cycles-t/ sleep 2
> perf stat -x, -e instructions,cpu/tx-start/ sleep 2
> perf stat -x, -e '{cycles,tx-start}' sleep 2
> perf stat -x, -e '{cycles,cpu/tx-start/}' sleep 2
> 
> #HW Cache event + kernel pmu event with different style
> perf stat -x, -e L1-dcache-loads,cpu/mem-stores/,tx-start sleep 2
> perf stat -x, -e L1-dcache-loads,mem-stores,cpu/tx-start/ sleep 2
> perf stat -x, -e '{L1-dcache-loads,mem-stores}' sleep 2
> perf stat -x, -e '{L1-dcache-loads,cpu/tx-start/}' sleep 2
> 
> #Raw event + kernel pmu event with different style:
> perf stat -x, -e cpu/event=0xc0,umask=0x00/,mem-loads,cpu/mem-stores/ sleep 2
> perf stat -x, -e cpu/event=0xc0,umask=0x00/,tx-start,cpu/el-start/ sleep 2
> perf stat -x, -e '{cpu/event=0xc0,umask=0x00/,tx-start}' sleep 2
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
> scan kernel pmu events from sysfs only needed
> rename the init/check/clenup functions and related struct.
> allocate each symbol string separatelly
> Use ALLOC_LIST
> 
> Changes since V5:
> Using perf_pmu__find to instead of perf_pmu__scan
> Don't scan all the time if the system doesn't support kernel pmu events
> 
> Changes since V6:
> Add test case in automated tests suite
> Use strdup and macro to refine the code
> Add sep_dc for PMU event to support PE_MODIFIER_EVENT
> Some minor changes for code style
> 
> Kan Liang (4):
>   Revert "perf tools: Default to cpu// for events v5"
>   perf tools: parse the pmu event prefix and suffix
>   perf tools: Add support to new style format of kernel PMU event
>   perf tools: Add test case for pmu event new style format

got test failure with your patchset:

[jolsa@krava perf]$ sudo ./perf test parse -v
 5: parse events tests                                     :
--- start ---
test child forked, pid 9972
running test 0 'syscalls:sys_enter_open'
registering plugin: /root/.traceevent/plugins/plugin_kvm.so
registering plugin: /root/.traceevent/plugins/plugin_scsi.so
registering plugin: /root/.traceevent/plugins/plugin_mac80211.so
registering plugin: /root/.traceevent/plugins/plugin_hrtimer.so

SNIP

running test 6 'faults'
running test 7 'L1-dcache-load-miss'
running test 8 'mem:0'
running test 9 'mem:0:x'
running test 10 'mem:0:r'
running test 11 'mem:0:w'
running test 12 'syscalls:sys_enter_open:k'
running test 13 'syscalls:*:u'
test child interrupted
---- end ----
parse events tests: FAILED!


jirka
