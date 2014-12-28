Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaL1UR0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 15:17:26 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:44950 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaL1URZ (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Sun, 28 Dec 2014 15:17:25 -0500
Message-ID: <1419797834.8667.8.camel@stgolabs.net>
Subject: Re: sched: spinlock recursion in sched_rr_get_interval
From: Davidlohr Bueso <dave@stgolabs.net>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Li Bin <huawei.libin@huawei.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, rui.xiang@huawei.com,
        wengmeiling.weng@huawei.com
Date: Sun, 28 Dec 2014 12:17:14 -0800
In-Reply-To: <549ED5D7.8070007@oracle.com>
References: <53B98709.3090603@oracle.com>
	 <20140707083016.GA19379@twins.programming.kicks-ass.net>
	 <53BAA6DF.5060409@oracle.com>
	 <20140707200550.GA6758@twins.programming.kicks-ass.net>
	 <549D03F6.9090607@huawei.com> <1419673927.8667.2.camel@stgolabs.net>
	 <549ED5D7.8070007@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-12-27 at 10:52 -0500, Sasha Levin wrote:
> On 12/27/2014 04:52 AM, Davidlohr Bueso wrote:
> >> Hello，
> >> > Does ACCESS_ONCE() can help this issue? I have no evidence that its lack is
> >> > responsible for the issue, but I think here need it indeed. Is that right?
> >> > 
> >> > SPIN_BUG_ON(ACCESS_ONCE(lock->owner) == current, "recursion");
> > Hmm I guess on a contended spinlock, there's a chance that lock->owner
> > can change, if the contended lock is acquired, right between the 'cond'
> > and spin_debug(), which would explain the bogus ->owner related
> > messages. Of course the same applies to ->owner_cpu. Your ACCESS_ONCE,
> > however, doesn't really change anything since we still read ->owner
> > again in spin_debug; How about something like this (untested)?

I guess we'd need a writer rwlock counterpart too.

> There's a chance that lock->owner would change, but how would you explain
> it changing to 'current'?

So yeah, the above only deals with the weird printk values, not the
actual issue that triggers the BUG_ON. Lets sort this out first and at
least get correct data.

> That is, what race condition specifically creates the
> 'lock->owner == current' situation in the debug check?

Why do you suspect a race as opposed to a legitimate recursion issue?
Although after staring at the code for a while, I cannot see foul play
in sched_rr_get_interval.

Given that all reports show bogus contending CPU and .owner_cpu, I do
wonder if this is actually a symptom of the BUG_ON where something fishy
is going on.. although I have no evidence to support that. I also ran
into this https://lkml.org/lkml/2014/11/7/762 which shows the same bogus
values yet a totally different stack.

Sasha, I ran trinity with CONFIG_DEBUG_SPINLOCK=y all night without
triggering anything. How are you hitting this?

Thanks,
Davidlohr


