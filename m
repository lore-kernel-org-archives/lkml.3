Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab3BUEvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 23:51:31 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:59040 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab3BUEva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 23:51:30 -0500
Message-ID: <5125A7C8.8020308@linux.vnet.ibm.com>
Date: Thu, 21 Feb 2013 12:51:20 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
References: <51079178.3070002@linux.vnet.ibm.com> <20130220104958.GA9152@gmail.com>
In-Reply-To: <20130220104958.GA9152@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022104-8878-0000-0000-000005F9CEF7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 06:49 PM, Ingo Molnar wrote:
[snip]
> 
> The changes look clean and reasoable, any ideas exactly *why* it 
> speeds up?
> 
> I.e. are there one or two key changes in the before/after logic 
> and scheduling patterns that you can identify as causing the 
> speedup?

Hi, Ingo

Thanks for your reply, please let me point out the key changes here
(forgive me for haven't wrote a good description in cover).

The performance improvement from this patch set is:
1. delay the invoke on wake_affine().
2. save the circle to gain proper sd.

The second point is obviously, and will benefit a lot when the sd
topology is deep (NUMA is suppose to make it deeper on large system).

So in my testing on a 12 cpu box, actually most of the benefit comes
from the first point, and please let me introduce it in detail.

The old logical when locate affine_sd is:

	if prev_cpu != curr_cpu
		if wake_affine()
			prev_cpu = curr_cpu
	new_cpu = select_idle_sibling(prev_cpu)
	return new_cpu

The new logical is same to the old one if prev_cpu == curr_cpu, so let's
simplify the old logical like:

	if wake_affine()
		new_cpu = select_idle_sibling(curr_cpu)
	else
		new_cpu = select_idle_sibling(prev_cpu)

	return new_cpu

Actually that doesn't make sense.

I think wake_affine() is trying to check whether move a task from
prev_cpu to curr_cpu will break the balance in affine_sd or not, but why
won't break balance means curr_cpu is better than prev_cpu for searching
the idle cpu?

So the new logical in this patch set is:

	new_cpu = select_idle_sibling(prev_cpu)
	if idle_cpu(new_cpu)
		return new_cpu

	new_cpu = select_idle_sibling(curr_cpu)
	if idle_cpu(new_cpu) {
		if wake_affine()
			return new_cpu
	}

	return prev_cpu

And now, unless we are really going to move load from prev_cpu to
curr_cpu, we won't use wake_affine() any more.

So we avoid wake_affine() when system load is low or high, for middle
load, the worst cases is when failed to locate idle cpu in prev_cpu
topology but succeed to locate one in curr_cpu's, but that's rarely
happen and the benchmark results proved that point.

Some comparison below:

1. system load is low
	old logical cost:
		wake_affine()
		select_idle_sibling()
	new logical cost:
		select_idle_sibling()

2. system load is high
	old logical cost:
		wake_affine()
		select_idle_sibling()
	new logical cost:
		select_idle_sibling()
		select_idle_sibling()

3. system load is middle
	don't know

1 save the cost of wake_affine(), 3 could be proved by benchmark that no
regression at least.

For 2, it's the comparison between wake_affine() and
select_idle_sibling(), since the system load is high, wake_affine() cost
far more than select_idle_sibling(), and we saved many according to the
benchmark results.

> 
> Such changes also typically have a chance to cause regressions 
> in other workloads - when that happens we need this kind of 
> information to be able to enact plan-B.

The benefit comes from avoiding unnecessary works, and the patch set is
suppose to only reduce the cost of key function with least logical
changing, I could not promise it benefit all the workloads, but till
now, I've not found regression.

Regards,
Michael Wang

> 
> Thanks,
> 
> 	Ingo
> 

