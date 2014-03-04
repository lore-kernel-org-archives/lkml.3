Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaCDFFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 00:05:24 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:58182 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbaCDFFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 00:05:18 -0500
Date: Mon, 3 Mar 2014 21:05:15 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "He, Bo" <bo.he@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        "yanmin_zhang@intel.linux.com" <yanmin_zhang@intel.linux.com>,
        "Wang, Biao" <biao.wang@intel.com>
Subject: Re: [PATCH]  mm, oom: normalize the adj to ensure oom_badness return
 one
In-Reply-To: <CD6925E8781EFD4D8E11882D20FC406D01AEDC58@SHSMSX103.ccr.corp.intel.com>
Message-ID: <alpine.DEB.2.02.1403032101370.21548@chino.kir.corp.google.com>
References: <CD6925E8781EFD4D8E11882D20FC406D01AEDC58@SHSMSX103.ccr.corp.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2014, He, Bo wrote:

> if oom_score_adj is a big negative number, such as -941,
> adj *= totalpages / 1000 will be a big negative number, 
> finally the oom_badness will get 0 points, here normalize 
> the oom_score_adj to ensure oom_badness return the
> positive number.
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
