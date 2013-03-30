Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab3C3L1k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 07:27:40 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:38249 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab3C3L1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 07:27:39 -0400
Message-ID: <5156CB90.5060209@linux.vnet.ibm.com>
Date: Sat, 30 Mar 2013 16:55:04 +0530
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
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-15-git-send-email-alex.shi@intel.com> <514941C5.6080007@linux.vnet.ibm.com> <514ABA19.1080807@intel.com> <514AC7B2.7030400@linux.vnet.ibm.com> <514AD26F.9010905@intel.com> <514AE07A.10100@linux.vnet.ibm.com> <514BB452.2070906@intel.com> <514BE8AC.6000607@linux.vnet.ibm.com> <514FD801.8070403@intel.com> <51558C31.1060605@linux.vnet.ibm.com> <515599AD.5090901@intel.com>
In-Reply-To: <515599AD.5090901@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 13033011-6102-0000-0000-0000033D1C75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2013 07:09 PM, Alex Shi wrote:
> On 03/29/2013 08:42 PM, Preeti U Murthy wrote:
>>>> did you try the simplest benchmark: while true; do :; done
>> Yeah I tried out this while true; do :; done benchmark on a vm which ran
> 
> Thanks a lot for trying!
> 
> What's do you mean 'vm'? Virtual machine?

Yes.

> 
>> on 2 socket, 2 cores each socket and 2 threads each core emulation.
>> I ran two instances of this loop with balance policy on, and it was
>> found that there was one instance running on each socket, rather than
>> both instances getting consolidated on one socket.
>>
>> But when I apply the change where we do not consider rq->util if it has
>> no nr_running on the rq,the two instances of the above benchmark get
>> consolidated onto one socket.
>>
>>
> 
> I don't know much of virtual machine, guess the unstable VCPU to CPU pin
> cause rq->util keep large? Did you try to pin VCPU to physical CPU?

No I hadn't done any vcpu to cpu pinning but why did the situation
drastically alter to consolidate the load when the rq->util for the
runqueues with 0 tasks on them was not considered as part of sgs->utils?

> 
> I still give the rq->util weight even the nr_running is 0, because some
> transitory tasks may actived on the cpu, but just missed on balancing point.
> 
> I just wondering that forgetting rq->util when nr_running = 0 is the
> real root cause if your finding is just on VM and without fixed VCPU to
> CPU pin.

I find the same situation on a physical machine too. On a 2 socket, 4
core machine as well. In fact, using trace_printks in the load balancing
part, I could find that the reason that the load was not getting
consolidated onto a socket was because the rq->util of a run-queue with
no processes on it, had not decayed to 0, which is why it would consider
the socket as overloaded and would  rule out power aware balancing.All
this was on a physical machine.

Regards
Preeti U Murthy


> 
> 

