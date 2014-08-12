Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbaHLOxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:53:01 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:39844 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbaHLOw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:52:59 -0400
Date: Tue, 12 Aug 2014 16:52:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
Cc: mingo@redhat.com, peterz@infradead.org, juri.lelli@gmail.com,
        linux-kernel@vger.kernel.org, xiaofeng.yan2012@gmail.com
Subject: Re: [PATCH v3] sched/deadline: overrun could happen in
 start_hrtick_dl
Message-ID: <20140812145254.GA7103@gmail.com>
References: <1407316094-18207-1-git-send-email-xiaofeng.yan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407316094-18207-1-git-send-email-xiaofeng.yan@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* xiaofeng.yan <xiaofeng.yan@huawei.com> wrote:

> It could be wrong for the precision of runtime and deadline
> when the precision is within microsecond level. For example:
> Task runtime deadline period
>  P1   200us   500us   500us
> 
> This case need enbale HRTICK feature by the next command
>
> PC#echo "HRTICK" > /sys/kernel/debug/sched_features
> PC#trace-cmd record -e sched_switch &
> PC#./schedtool -E -t 200000:500000 -e ./test
> 
> Some of runtime and deadline run with millisecond level by
> reading kernershark. Some pieces of trace.dat are as follows:
> (remove some irrelevant information)
> <idle>-0   157.603157: sched_switch: :R ==> 2481:4294967295: test
> test-2481  157.603203: sched_switch:  2481:R ==> 0:120: swapper/2
> <idle>-0   157.605657: sched_switch:  :R ==> 2481:4294967295: test
> test-2481  157.608183: sched_switch:  2481:R ==> 2483:120: trace-cmd
> trace-cmd-2483 157.609656: sched_switch:2483:R==>2481:4294967295: test
> 
> We can get the runtime from the information at some point.
> runtime = 157.605657 - 157.608183
> runtime = 0.002526(2.526ms)
> The correct runtime should be less than or equal to 200us at some point.
> 
> The problem is caused by a conditional judgment "delta > 10000".
> Because no hrtimer start up to control the runtime when runtime is less than 10us.
> So the process will continue to run until tick-period coming.
> 
> Move the code with the limit of the least time slice
> from hrtick_start_fair() to hrtick_start() because
> EDF schedule class also need this function in start_hrtick_dl().
> 
> To fix this problem, we call hrtimer_start() unconditionally in start_hrtick_dl(),
> and make sure schedule slice won't be smaller than 10us in hrtimer_start().
> 
> Signed-off-by: Xiaofeng Yan <xiaofeng.yan@huawei.com>
> Reviewed-by:   Peter Zijlstra <peterz@infradead.org>
> Reviewed-by:   Li Zefan <lizefan@huawei.com>

The whole changelog is very hard to read and isn't proper English, nor 
is it truly explanatory. Could you please fix the changelog, or bounce 
it to someone who will fix it for you?

Thanks,

	Ingo
