Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308Ab3CUInH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 04:43:07 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:33933 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933284Ab3CUInA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 04:43:00 -0400
Message-ID: <514AC7B2.7030400@linux.vnet.ibm.com>
Date: Thu, 21 Mar 2013 14:11:22 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 14/15] sched: power aware load balance
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-15-git-send-email-alex.shi@intel.com> <514941C5.6080007@linux.vnet.ibm.com> <514ABA19.1080807@intel.com>
In-Reply-To: <514ABA19.1080807@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032108-0260-0000-0000-000002B34319
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On 03/21/2013 01:13 PM, Alex Shi wrote:
> On 03/20/2013 12:57 PM, Preeti U Murthy wrote:
>> Neither core will be able to pull the task from the other to consolidate
>> the load because the rq->util of t2 and t4, on which no process is
>> running, continue to show some number even though they degrade with time
>> and sgs->utils accounts for them. Therefore,
>> for core1 and core2, the sgs->utils will be slightly above 100 and the
>> above condition will fail, thus failing them as candidates for
>> group_leader,since threshold_util will be 200.
> 
> Thanks for note, Preeti!
> 
> Did you find some real issue in some platform?
> In theory, a totally idle cpu has a zero rq->util at least after 3xxms,
> and in fact, I fi
nd the code works fine on my machines.
> 

Yes, I did find this behaviour on a 2 socket, 8 core machine very
consistently.

rq->util cannot go to 0, after it has begun accumulating load right?

Say a load was running on a runqueue which had its rq->util to be at
100%. After the load finishes, the runqueue goes idle. For every
scheduler tick, its utilisation decays. But can never become 0.

rq->util = rq->avg.runnable_avg_sum/rq->avg.runnable_avg_period

This ratio will come close to 0, but will never become 0 once it has
picked up a value.So if a sched_group consists of two run queues,one
having utilisation 100, running 1 load and the other having utilisation
.001,but running no load,then in update_sd_lb_power_stats(), the below
condition

"sgs->group_utils + FULL_UTIL > threshold_util " will turn out to be

(100.001 + 100 > 200) and hence the group will fail to act as the group
leader,to take on more tasks onto itself.


Regards
Preeti U Murthy

