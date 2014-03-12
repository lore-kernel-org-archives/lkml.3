Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbaCLKc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:32:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62768 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753946AbaCLKcl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:32:41 -0400
X-IronPort-AV: E=Sophos;i="4.97,636,1389715200"; 
   d="scan'208";a="9683604"
Message-ID: <53202CB5.4090906@cn.fujitsu.com>
Date: Wed, 12 Mar 2014 17:45:25 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, joe@perches.com,
        mingo@kernel.org, tglx@linutronix.de, heiko.carstens@de.ibm.com
Subject: Re: [PATCH 00/17 for-tip V3] A series patches about sched priority.
References: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com>
In-Reply-To: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/12 17:44:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/12 17:45:58
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,
Let me post more explanation about this patchset.
This series of patches here is to git rid of hardcoding of nice value and
collect the logic control in prio.h.

Currently, in tip tree, we can get 36 results with the below command:

# git grep -n -w -E "19|20"|grep -P "_nice" -i
drivers/block/loop.c:551: set_user_nice(current, -20);
drivers/block/nbd.c:536: set_user_nice(current, -20);
drivers/block/pktcdvd.c:1466: set_user_nice(current, -20);
drivers/char/ipmi/ipmi_si_intf.c:1002: set_user_nice(current, 19);
drivers/s390/crypto/ap_bus.c:1806: set_user_nice(current, 19);
drivers/scsi/bnx2fc/bnx2fc_fcoe.c:467: set_user_nice(current, -20);
drivers/scsi/bnx2fc/bnx2fc_fcoe.c:605: set_user_nice(current, -20);
drivers/scsi/bnx2i/bnx2i_hwi.c:1873: set_user_nice(current, -20);
drivers/scsi/fcoe/fcoe.c:1875: set_user_nice(current, -20);
drivers/scsi/ibmvscsi/ibmvfc.c:4518: set_user_nice(current, -20);
drivers/scsi/ibmvscsi/ibmvscsi.c:2216: set_user_nice(current, -20);
drivers/scsi/lpfc/lpfc_hbadisc.c:736: set_user_nice(current, -20);
drivers/scsi/qla2xxx/qla_os.c:4759: set_user_nice(current, -20);
drivers/staging/android/binder.c:439: min_nice = 20 - 
current->signal->rlim[RLIMIT_NICE].rlim_cur;
drivers/staging/android/binder.c:444: if (min_nice < 20)
drivers/staging/lustre/lustre/llite/lloop.c:410: set_user_nice(current, 
-20);
fs/ocfs2/cluster/heartbeat.c:1110: set_user_nice(current, -20);
include/linux/ioprio.h:55: return (task_nice(task) + 20) / 5;
kernel/rcu/torture.c:808: set_user_nice(current, 19);
kernel/rcu/torture.c:874: set_user_nice(current, 19);
kernel/rcu/torture.c:990: set_user_nice(current, 19);
kernel/rcu/torture.c:1587: set_user_nice(current, 19);
kernel/sched/core.c:3001: if (TASK_NICE(p) == nice || nice < -20 || nice 
 > 19)
kernel/sched/core.c:3618: attr->sched_nice = clamp(attr->sched_nice, 
-20, 19);
kernel/sched/sched.h:32:#define PRIO_TO_NICE(prio) ((prio) - MAX_RT_PRIO 
- 20)
kernel/sys.c:253: niceval = 20 - task_nice(p);
kernel/sys.c:264: niceval = 20 - task_nice(p);
kernel/sys.c:280: niceval = 20 - task_nice(p);
kernel/trace/ring_buffer_benchmark.c:43:static int producer_nice = 19;
kernel/trace/ring_buffer_benchmark.c:44:static int consumer_nice = 19;
kernel/trace/ring_buffer_benchmark.c:311: producer_nice == 19 && 
consumer_nice == 19)
kernel/workqueue.c:105: RESCUER_NICE_LEVEL = -20,
kernel/workqueue.c:106: HIGHPRI_NICE_LEVEL = -20,
mm/huge_memory.c:2806: set_user_nice(current, 19);
tools/testing/selftests/mqueue/mq_perf_tests.c:532: cur_nice = -20;

It means there are 36 *men* who can decide the max_nice or min_nice.

This patchset collect this power back to prio.h, then the other subsystems
should use the macros in prio.h, rather than decide it by themselves.

In addition, we use macro such as NICE_TO_IOPRIO to replace
a expression “(task_nice(task) + 20) / 5”, I believe the name of
macro means better.

After this patchset applied:

# git grep -n -w -E "19|20"|grep -P "_nice" -i
include/linux/sched/prio.h:4:#define MAX_NICE 19
include/linux/sched/prio.h:5:#define MIN_NICE -20

It looks more safe and more extensibal.

PS: Peter, I see you are busy and this series of patches seems really
trivial. I wish you can give me your opinion about it when you
have a time. No rush at all.

Thanx. :)

On 03/11/2014 06:09 PM, Dongsheng Yang wrote:
> Hi all,
> 	This patchset is all about priority.
>
> 1. Add two inline functions in prio.h named nice_to_rlimit and rlimit_to_nice.
>     They are converting the value between nice value [-20, 19] and
>     rlimit style value [1, 40].
> 2. Add a macro in ioprio.h named NICE_TO_IOPRIO.
>     It convert nice value [-20, 19] to io priority [0, 7].
> 3. Others are all about replace hardcoding value about nice to MIN_NICE or MAX_NICE.
>
> Changelog:
> 	-v2:
> 	  *Splite [2/16] into two patches, one is about the whitespace changes, and
> 	   the other is about nice_to_rlimit().
> 	-v1:
> 	  *Implement nice_to_rlimit and rlimit_to_nice with inline functions
> 	   rather than macro.
> 	  *Add a patch[16/16] to replace opened code implement with nice_to_rlimit().
>
> Dongsheng Yang (16):
>    sched/prio: Add a inline function named nice_to_rlimit() in prio.h.
>    kernel/sys: Replace opened code implementation with nice_to_rlimit().
>    workqueue: Replace hardcoding of -20 with MIN_NICE.
>    locktorture: Replace hardcoding of 19 with MAX_NICE.
>    tools/mq_perf_tests: Replace hardcoding of -20 with MIN_NICE.
>    mm: Replace hardcoding of 19 with MAX_NICE.
>    ioprio: Add a macro named NICE_TO_IOPRIO.
>    fs/hearbeat: Replace hardcoding of -20 with MIN_NICE.
>    driver/block: Replace hardcoding of -20 with MIN_NICE.
>    driver/char: Replace hardcoding of 19 with MAX_NICE.
>    drivers/s390: Replace hardcoding of 19 with MAX_NICE.
>    sched/prio: Add an inline function named rlimit_to_nice in prio.h.
>    driver/staging/android: Use rlimit_to_nice to replace opened code
>      implementation.
>    driver/staging/lustre: Replace hardcoding of -20 with MIN_NICE.
>    driver/scsi: Replace hardcoding of -20 with MIN_NICE.
>    sched: Get rid of opened code implementation of funtion
>      nice_to_rlimit().
>
> Joe Perches (1):
>    kernel/sys: Fix the indent issue in switch.
>
>   drivers/block/loop.c                           |   2 +-
>   drivers/block/nbd.c                            |   2 +-
>   drivers/block/pktcdvd.c                        |   2 +-
>   drivers/char/ipmi/ipmi_si_intf.c               |   2 +-
>   drivers/s390/crypto/ap_bus.c                   |   2 +-
>   drivers/scsi/bnx2fc/bnx2fc_fcoe.c              |   4 +-
>   drivers/scsi/bnx2i/bnx2i_hwi.c                 |   2 +-
>   drivers/scsi/fcoe/fcoe.c                       |   2 +-
>   drivers/scsi/ibmvscsi/ibmvfc.c                 |   2 +-
>   drivers/scsi/ibmvscsi/ibmvscsi.c               |   2 +-
>   drivers/scsi/lpfc/lpfc_hbadisc.c               |   2 +-
>   drivers/scsi/qla2xxx/qla_os.c                  |   2 +-
>   drivers/staging/android/binder.c               |   4 +-
>   drivers/staging/lustre/lustre/llite/lloop.c    |   2 +-
>   fs/ocfs2/cluster/heartbeat.c                   |   2 +-
>   include/linux/ioprio.h                         |   7 +-
>   include/linux/sched/prio.h                     |  16 ++
>   kernel/locking/locktorture.c                   |   2 +-
>   kernel/sched/core.c                            |   2 +-
>   kernel/sys.c                                   | 206 ++++++++++++-------------
>   kernel/workqueue.c                             |   6 +-
>   mm/huge_memory.c                               |   2 +-
>   tools/testing/selftests/mqueue/mq_perf_tests.c |   4 +-
>   23 files changed, 150 insertions(+), 129 deletions(-)
>

