Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaKDNhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:37:46 -0500
Received: from out4133-98.mail.aliyun.com ([42.120.133.98]:4949 "EHLO
	out4133-98.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985AbaKDNhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:37:43 -0500
X-Greylist: delayed 2570 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Nov 2014 08:37:42 EST
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;FP=0|-1|-1|-1|0|-1|-1|-1;HT=r41g08153;MF=hillf.zj@alibaba-inc.com;PH=DS;RN=8;RT=8;SR=0;
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
To: "'Vincent Guittot'" <vincent.guittot@linaro.org>
Cc: "'Wanpeng Li'" <kernellwp@gmail.com>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Ingo Molnar'" <mingo@kernel.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Preeti U Murthy'" <preeti@linux.vnet.ibm.com>,
        "'Morten Rasmussen'" <Morten.Rasmussen@arm.com>,
        "'Kamalesh Babulal'" <kamalesh@linux.vnet.ibm.com>
References: <011001cff827$f14b9870$d3e2c950$@alibaba-inc.com> <CAKfTPtD6TZ4iHv9wtg-KCkGZriU79ySSxEV3nao2qQacveKAxA@mail.gmail.com> <011801cff82e$78cd2c90$6a6785b0$@alibaba-inc.com> <CAKfTPtCwLobjq6RVsB=61D_4amMtnLCmfUcpPo50Z7kzWgy5Hw@mail.gmail.com>
In-Reply-To: <CAKfTPtCwLobjq6RVsB=61D_4amMtnLCmfUcpPo50Z7kzWgy5Hw@mail.gmail.com>
Subject: RE: [PATCH v8 03/10] sched: move cfs task on a CPU with higher capacity
Date: Tue, 04 Nov 2014 21:31:57 +0800
Message-ID: <011901cff833$b49afb30$1dd0f190$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIA8HtVxJmKoorqFpZD8DtHhnWE3gJX3gDYApYsit4BZQPEiZu76sbw
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> > I wonder if you can please shed light on the case that
> >> > the dst_cpu is newly idle.
> >>
> >> The main problem if we do the test only for newly idle case, is that
> >> we are not sure to move the task because we must rely on the
> >> wakeup/sleep sequence of other tasks on an idle CPU in order to trig
> >> the migration (periodic background task as an example). So we might
> >> never move the task whereas idle CPUs are available
> >>
> > So no task is migrated in the newly idle case, if I understand the
> > above correctly.
> 
> A task can be moved in both idle and newly idle. If we rely only on
> newly idle and we  have only idle CPUs, we can never move task. In the
> same way, if we rely only on idle case and a CPU never stays idle long
> enough to trig the idle load balance, we will never move the task. I
> agree that for the latter, we might wonder if it's worth moving the
> task. This is your concern ?
> 
I concern if the only-one cfs task is migrated to a newly-idle CPU in
your code:
+	/*
+	 * The dst_cpu is idle and the src_cpu CPU has only 1 CFS task.
+	 * It's worth migrating the task if the src_cpu's capacity is reduced
+	 * because of other sched_class or IRQs whereas capacity stays
+	 * available on dst_cpu.
+	 */
+	if ((env->idle != CPU_NOT_IDLE) &&
+			(env->src_rq->cfs.h_nr_running == 1)) {
+	
due to the comment:
                /*
                 * Increment the failure counter only on periodic balance.
                 * We do not want newidle balance, which can be very
                 * frequent, pollute the failure counter causing
                 * excessive cache_hot migrations and active balances.
                 */
                if (idle != CPU_NEWLY_IDLE)
                        sd->nr_balance_failed++;

Hillf

