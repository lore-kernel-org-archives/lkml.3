Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbaD1JYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:24:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:51751 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbaD1JYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:24:09 -0400
Date: Mon, 28 Apr 2014 11:24:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti Murthy <preeti.lkml@gmail.com>
Cc: Jason Low <jason.low2@hp.com>, Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Alex Shi <alex.shi@linaro.org>, Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>, aswin@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 1/3] sched, balancing: Update rq->max_idle_balance_cost
 whenever newidle balance is attempted
Message-ID: <20140428092403.GE27561@twins.programming.kicks-ass.net>
References: <1398303035-18255-2-git-send-email-jason.low2@hp.com>
 <5358E417.8090503@linux.vnet.ibm.com>
 <20140424120415.GS11096@twins.programming.kicks-ass.net>
 <20140424124438.GT13658@twins.programming.kicks-ass.net>
 <1398358417.3509.11.camel@j-VirtualBox>
 <20140424171453.GZ11096@twins.programming.kicks-ass.net>
 <5359EDDB.4060409@linux.vnet.ibm.com>
 <20140425094331.GF26782@laptop.programming.kicks-ass.net>
 <1398455654.2102.29.camel@j-VirtualBox>
 <CAM4v1pMj8KqPG3gebA6ykU92fzWhDVCAzw6fUpVGgGNcruDd0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM4v1pMj8KqPG3gebA6ykU92fzWhDVCAzw6fUpVGgGNcruDd0A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 02:01:45PM +0530, Preeti Murthy wrote:
> Hi Jason, Peter,
> 
> The below patch looks good to me except for one point.
> 
> In idle_balance() the below code snippet does not look right:
> 
> - if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
> - /*
> - * We are going idle. next_balance may be set based on
> - * a busy processor. So reset next_balance.
> - */
> +out:
> + /* Move the next balance forward */
> + if (time_after(this_rq->next_balance, next_balance))
>   this_rq->next_balance = next_balance;
> - }
> 
> By not checking this_rq->next_balance against jiffies,
> we might end up not updating this parameter when it
> has expired.
> 
> So shouldn't it be:
> 
> if (time_after(jiffies, this_rq->next_balance) ||
>            time_after(this_rq->next_balance, next_balance))
>     this_rq->next_balance = next_balance;

So the reason I didn't do that is that nothing else does that either.
Also, note that the value we set rq->next_balance to might itself
already be expired. There is no guarantee that last_balance + interval
is in the future.

