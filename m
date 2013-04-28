Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab3D1B5A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 21:57:00 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:35655 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab3D1B47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 21:56:59 -0400
Message-ID: <1367114209.6391.23.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [RFC PATCH]nohz: Use raw_smp_processor_id() in
 tick_nohz_task_switch()
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Date: Sun, 28 Apr 2013 09:56:49 +0800
In-Reply-To: <CAFTL4hwVXS9s7n=0Ji4+5cbOQSROk53OxMAWY3U=bzRPRijr9w@mail.gmail.com>
References: <1367056747.6391.15.camel@ThinkPad-T5421.cn.ibm.com>
	 <CAFTL4hwVXS9s7n=0Ji4+5cbOQSROk53OxMAWY3U=bzRPRijr9w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042801-1618-0000-0000-000003C7A854
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-04-27 at 15:40 +0200, Frederic Weisbecker wrote:
> 2013/4/27 Li Zhong <zhong@linux.vnet.ibm.com>:
> > I saw following error when testing the latest nohz code on Power:
> >
> > [   85.295384] BUG: using smp_processor_id() in preemptible [00000000] code: rsyslogd/3493
> > [   85.295396] caller is .tick_nohz_task_switch+0x1c/0xb8
> > [   85.295402] Call Trace:
> > [   85.295408] [c0000001fababab0] [c000000000012dc4] .show_stack+0x110/0x25c (unreliable)
> > [   85.295420] [c0000001fababba0] [c0000000007c4b54] .dump_stack+0x20/0x30
> > [   85.295430] [c0000001fababc10] [c00000000044eb74] .debug_smp_processor_id+0xf4/0x124
> > [   85.295438] [c0000001fababca0] [c0000000000d7594] .tick_nohz_task_switch+0x1c/0xb8
> > [   85.295447] [c0000001fababd20] [c0000000000b9748] .finish_task_switch+0x13c/0x160
> > [   85.295455] [c0000001fababdb0] [c0000000000bbe50] .schedule_tail+0x50/0x124
> > [   85.295463] [c0000001fababe30] [c000000000009dc8] .ret_from_fork+0x4/0x54
> >
> > It seems to me that we could just use raw_smp_processor_id() here. Even
> > if the tick_nohz_full_cpu() check is done on a !nohz_full cpu, then the
> > task is moved to another nohz_full cpu, it seems the context switching
> > because of the task moving would call tick_nohz_task_switch() again to
> > evaluate the need for tick.
> >
> > I don't know whether I missed something here.
> 
> You're right it looks safe to do so. But I suggest we rather move the
> test inside local_irq_save()/restore section to avoid confusion on
> reviewers minds.

OK, I'll send an updated version, using local_irq_save() to protect it. 
I tried using raw_* because seems it could avoid some unnecessary irq
disabling...

Thanks, Zhong

> Thanks!
> 


