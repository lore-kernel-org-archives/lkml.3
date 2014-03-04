Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaCDFtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 00:49:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:41009 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbaCDFtR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 00:49:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,583,1389772800"; 
   d="scan'208";a="491885304"
From: "He, Bo" <bo.he@intel.com>
To: David Rientjes <rientjes@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        "yanmin_zhang@intel.linux.com" <yanmin_zhang@intel.linux.com>,
        "Wang, Biao" <biao.wang@intel.com>
Subject: RE: [PATCH]  mm, oom: normalize the adj to ensure oom_badness
 return a positive number
Thread-Topic: [PATCH]  mm, oom: normalize the adj to ensure oom_badness
 return a positive number
Thread-Index: Ac83bWNYGP+aOFlxRkSMrhy3K/3OLA==
Date: Tue, 4 Mar 2014 05:49:14 +0000
Message-ID: <CD6925E8781EFD4D8E11882D20FC406D01AEE4A8@SHSMSX103.ccr.corp.intel.com>
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

Sorry, the title is confusing. Change it to: mm, oom: normalize the adj to ensure oom_badness returns a positive number
We are enabling android mobiles. When running stress memory test, there is a bad issue. Some critical processes such as Healthd and watchdogd are killed, while some other processes are still alive.
OOM should kill the tasks whose oom_score are biggest. Many processes use a minus oom_score_adj. oom_badness returns 1 for all of them and their oom_score are all 0.

The patch tries to convert the minus oom_score_adj to a positive number when calculating oom_score. oom_score can keep right process priority sequence.

Without the patch, almost all the processes' oom_score are equal to 0. (cat /proc/XXX/oom_*)
Healthd            -15 0 -941
Servicemanager     -15 0 -941
Vold               -15 0 -941
ia_watchdogd      -15 0 -941
surfaceflinger       -15 0 -941
zygote            -15 0 -941
system_server     -15 0 -941
ndroid.systemui    -11 0 -705

With the patch, we can get different oom_score:
Healthd            -15 59 -941
Servicemanager     -15 89 -941
Vold               -15 60 -941
ia_watchdogd      -15 89 -941
surfaceflinger       -15 145 -941
zygote            -15 122 -941
system_server     -15 166 -941
ndroid.systemui    -11 419 -705


-----Original Message-----
From: David Rientjes [mailto:rientjes@google.com] 
Sent: Tuesday, March 04, 2014 1:05 PM
To: He, Bo
Cc: linux-kernel@vger.kernel.org; Ingo Molnar; hannes@cmpxchg.org; oleg@redhat.com; kirill.shutemov@linux.intel.com; Zhang, Yanmin; yanmin_zhang@intel.linux.com; Wang, Biao
Subject: Re: [PATCH] mm, oom: normalize the adj to ensure oom_badness return one

On Mon, 3 Mar 2014, He, Bo wrote:

> if oom_score_adj is a big negative number, such as -941, adj *= 
> totalpages / 1000 will be a big negative number, finally the 
> oom_badness will get 0 points, here normalize the oom_score_adj to 
> ensure oom_badness return the positive number.
> 

Sorry, I have no clue what you're talking about or trying to fix.

A /proc/pid/oom_score_adj of -941 would mean discounting 94.1% of system 
memory from pid's resident memory usage for a system oom condition.  This 
is the effect of adj *= totalpages / 1000 and is working as intended per 
Documentation/filesystems/proc.txt.

oom_badness() will then return the smallest integer possible, 1 (not 0), 
that still allows the process to be killed, that's the effect of 
"return points > 0 ? points : 1".  It never returns 0 as you state, you're 
either not reading the code correctly or not working on any recent kernel.

> Change-Id: I1c56a948ce48b65a1bb63b56ffef07d5d76d7ec8
> Signed-off-by: he, bo <bo.he@intel.com>
> Signed-off-by: wang, biao <biao.wang@intel.com>
> Reviewed-by: Yanmin Zhang <yanmin_zhang@intel.com>
> ---
>  mm/oom_kill.c |    3 +++ 
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 3291e82..5a93986 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -181,6 +181,9 @@ unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *memcg,
>         points -= (points * 3) / 100;
>  
>     /* Normalize to oom_score_adj units */
> +   if(OOM_SCORE_ADJ_MIN < 0)
> +       adj -= OOM_SCORE_ADJ_MIN;
> +
>     adj *= totalpages / 1000;
>     points += adj;
>  
