Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab3CGJrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 04:47:04 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:40495 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3CGJrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 04:47:02 -0500
Message-ID: <51386207.5040808@linux.vnet.ibm.com>
Date: Thu, 07 Mar 2013 17:46:47 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: wakeup buddy
References: <5136EB06.2050905@linux.vnet.ibm.com> <1362645372.2606.11.camel@laptop>
In-Reply-To: <1362645372.2606.11.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030709-7014-0000-0000-000002AF494E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, Peter

Thanks for your reply.

On 03/07/2013 04:36 PM, Peter Zijlstra wrote:
> On Wed, 2013-03-06 at 15:06 +0800, Michael Wang wrote:
> 
>> wake_affine() stuff is trying to bind related tasks closely, but it doesn't
>> work well according to the test on 'perf bench sched pipe' (thanks to Peter).
> 
> so sched-pipe is a poor benchmark for this.. 
> 
> Ideally we'd write a new benchmark that has some actual data footprint
> and we'd measure the cost of tasks being apart on the various cache
> metrics and see what affine wakeup does for it.

I think sched-pipe is still somewhat capable, the problem is that the
select_idle_sibling() doesn't take care the wakeup related case, it
doesn't contain the logical to locate an idle cpu closely.

So even we detect the relationship successfully, select_idle_sibling()
can only help to make sure the target cpu won't be outside of the
current package, it's a package level bind, not mc or smp level.

> 
> Before doing something like what you're proposing, I'd have a hard look
> at WF_SYNC, it is possible we should disable/fix select_idle_sibling
> for sync wakeups.

The patch is supposed to stop using wake_affine() blindly, not improve
the wake_affine() stuff itself, the whole stuff still works, but since
we rely on select_idle_sibling() to make the choice, the benefit is not
so significant, especially on my one node box...

> 
> The idea behind sync wakeups is that we try and detect the case where
> we wakeup up one task only to go to sleep ourselves and try and avoid
> the regular ping-pong this would otherwise create on account of the
> waking task still being alive and so the current cpu isn't actually
> idle yet but we know its going to be idle soon.

Are you suggesting that we should separate the process of wakeup related
case, not just pass current cpu to select_idle_sibling()?

Regards,
Michael Wang

> 
> 
> 

