Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100AbaD1Tdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:33:33 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:58784 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433AbaD1Tdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:33:31 -0400
Message-ID: <1398708274.2009.19.camel@j-VirtualBox>
Subject: Re: [PATCH 1/3] sched, balancing: Update rq->max_idle_balance_cost
 whenever newidle balance is attempted
From: Jason Low <jason.low2@hp.com>
To: Preeti Murthy <preeti.lkml@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Alex Shi <alex.shi@linaro.org>, Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>
Date: Mon, 28 Apr 2014 11:04:34 -0700
In-Reply-To: <CAM4v1pMj8KqPG3gebA6ykU92fzWhDVCAzw6fUpVGgGNcruDd0A@mail.gmail.com>
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
	 <1398303035-18255-2-git-send-email-jason.low2@hp.com>
	 <5358E417.8090503@linux.vnet.ibm.com>
	 <20140424120415.GS11096@twins.programming.kicks-ass.net>
	 <20140424124438.GT13658@twins.programming.kicks-ass.net>
	 <1398358417.3509.11.camel@j-VirtualBox>
	 <20140424171453.GZ11096@twins.programming.kicks-ass.net>
	 <5359EDDB.4060409@linux.vnet.ibm.com>
	 <20140425094331.GF26782@laptop.programming.kicks-ass.net>
	 <1398455654.2102.29.camel@j-VirtualBox>
	 <CAM4v1pMj8KqPG3gebA6ykU92fzWhDVCAzw6fUpVGgGNcruDd0A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-04-27 at 14:01 +0530, Preeti Murthy wrote:
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

Hi Preeti,

If jiffies is after this_rq->next_balance, doesn't that mean that it's
actually due for a periodic balance and we wouldn't need to modify it?
In rebalance_domains(), we do load_balance if time_after_eq(jiffies,
sd->last_balance + interval).

> 
> Besides this:
> Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>

Thanks for the review.

