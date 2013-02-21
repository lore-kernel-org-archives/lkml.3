Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab3BUKVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 05:21:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37152 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab3BUKVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 05:21:10 -0500
Message-ID: <1361442055.26780.3.camel@laptop>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Thu, 21 Feb 2013 11:20:55 +0100
In-Reply-To: <5125A7C8.8020308@linux.vnet.ibm.com>
References: <51079178.3070002@linux.vnet.ibm.com>
	 <20130220104958.GA9152@gmail.com> <5125A7C8.8020308@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-21 at 12:51 +0800, Michael Wang wrote:
> The old logical when locate affine_sd is:
> 
>         if prev_cpu != curr_cpu
>                 if wake_affine()
>                         prev_cpu = curr_cpu
>         new_cpu = select_idle_sibling(prev_cpu)
>         return new_cpu
> 
> The new logical is same to the old one if prev_cpu == curr_cpu, so
> let's
> simplify the old logical like:
> 
>         if wake_affine()
>                 new_cpu = select_idle_sibling(curr_cpu)
>         else
>                 new_cpu = select_idle_sibling(prev_cpu)
> 
>         return new_cpu
> 
> Actually that doesn't make sense.

It does :-)

> I think wake_affine() is trying to check whether move a task from
> prev_cpu to curr_cpu will break the balance in affine_sd or not, but
> why
> won't break balance means curr_cpu is better than prev_cpu for
> searching
> the idle cpu?

It doesn't, the whole affine wakeup stuff is meant to pull waking tasks
towards the cpu that does the wakeup, we limit this by putting bounds on
the imbalance this is may create.

The reason we want to run tasks on the cpu that does the wakeup is
because that cpu 'obviously' is running something related and it seems
like a good idea to run related tasks close together.

So look at affine wakeups as a force that groups related tasks.

> So the new logical in this patch set is:
> 
>         new_cpu = select_idle_sibling(prev_cpu)
>         if idle_cpu(new_cpu)
>                 return new_cpu
> 
>         new_cpu = select_idle_sibling(curr_cpu)
>         if idle_cpu(new_cpu) {
>                 if wake_affine()
>                         return new_cpu
>         }
> 
>         return prev_cpu
> 
> And now, unless we are really going to move load from prev_cpu to
> curr_cpu, we won't use wake_affine() any more.

That's completely breaks stuff, not cool.

