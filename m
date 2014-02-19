Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaBSDMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 22:12:23 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:58026 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbaBSDMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 22:12:22 -0500
Message-ID: <5304210B.9060604@linux.vnet.ibm.com>
Date: Wed, 19 Feb 2014 11:12:11 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: paulus@samba.org, Ingo Molnar <mingo@redhat.com>, acme@ghostprotocols.net,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sched: tip/master show panic while booting/rebooting
References: <5302EBA3.10909@linux.vnet.ibm.com> <20140218112230.GA27965@twins.programming.kicks-ass.net>
In-Reply-To: <20140218112230.GA27965@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021903-5816-0000-0000-00000C58E7EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 07:22 PM, Peter Zijlstra wrote:
> On Tue, Feb 18, 2014 at 01:12:03PM +0800, Michael wang wrote:
>> Hi, Folks
>>
>> Got below panic while testing tip/master on x86 box, it randomly
>> occur while booting or rebooting, any ideas?
> 
> The obvious pick would be the relocation of the idle_balance call, but
> I'm not sure how that'll end up stalling.

I've review the code again, seems like it was caused by the same issue
we discussed (RT/DL enqueued issue), I found that idle_balance() will
return 1 in such cases:

        /*
         * While browsing the domains, we released the rq lock.
         * A task could have be enqueued in the meantime
         */
        if (this_rq->nr_running && !pulled_task)
                return 1;

And if no more fair task to be pulled, we will do balance again and
again in pick_next_task_fair() until panic in NMI...

The solution we discussed could solve the problem I suppose, it was
already in progress, correct?

Please let me know if there are any thing I could help with ;-)

Regards,
Michael Wang

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

