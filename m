Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbaD2D4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 23:56:24 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44530 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbaD2D4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 23:56:23 -0400
Message-ID: <535F21E0.9020305@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2014 09:22:00 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>
CC: Preeti Murthy <preeti.lkml@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Alex Shi <alex.shi@linaro.org>, Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>
Subject: Re: [PATCH 1/3] sched, balancing: Update rq->max_idle_balance_cost
 whenever newidle balance is attempted
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com> <1398303035-18255-2-git-send-email-jason.low2@hp.com> <5358E417.8090503@linux.vnet.ibm.com> <20140424120415.GS11096@twins.programming.kicks-ass.net> <20140424124438.GT13658@twins.programming.kicks-ass.net> <1398358417.3509.11.camel@j-VirtualBox> <20140424171453.GZ11096@twins.programming.kicks-ass.net> <5359EDDB.4060409@linux.vnet.ibm.com> <20140425094331.GF26782@laptop.programming.kicks-ass.net> <1398455654.2102.29.camel@j-VirtualBox> <CAM4v1pMj8KqPG3gebA6ykU92fzWhDVCAzw6fUpVGgGNcruDd0A@mail.gmail.com> <1398708274.2009.19.camel@j-VirtualBox>
In-Reply-To: <1398708274.2009.19.camel@j-VirtualBox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042903-1344-0000-0000-000001358BBD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 11:34 PM, Jason Low wrote:
> On Sun, 2014-04-27 at 14:01 +0530, Preeti Murthy wrote:
>> Hi Jason, Peter,
>>
>> The below patch looks good to me except for one point.
>>
>> In idle_balance() the below code snippet does not look right:
>>
>> - if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
>> - /*
>> - * We are going idle. next_balance may be set based on
>> - * a busy processor. So reset next_balance.
>> - */
>> +out:
>> + /* Move the next balance forward */
>> + if (time_after(this_rq->next_balance, next_balance))
>>   this_rq->next_balance = next_balance;
>> - }
>>
>> By not checking this_rq->next_balance against jiffies,
>> we might end up not updating this parameter when it
>> has expired.
>>
>> So shouldn't it be:
>>
>> if (time_after(jiffies, this_rq->next_balance) ||
>>            time_after(this_rq->next_balance, next_balance))
>>     this_rq->next_balance = next_balance;
> 
> Hi Preeti,
> 
> If jiffies is after this_rq->next_balance, doesn't that mean that it's
> actually due for a periodic balance and we wouldn't need to modify it?
> In rebalance_domains(), we do load_balance if time_after_eq(jiffies,
> sd->last_balance + interval).

Right. So I missed the point that we don't really have a problem with
the rq->next_balance being expired. It will anyway ensure that in the
next call to rebalance_domains() load balancing will be done and that is
all we want. Thanks for pointing it out.

Regards
Preeti U Murthy
> 
>>
>> Besides this:
>> Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> 
> Thanks for the review.
> 

