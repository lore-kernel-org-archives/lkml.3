Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaBNPtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 10:49:17 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:34184 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751660AbaBNPtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 10:49:16 -0500
Date: Fri, 14 Feb 2014 15:49:07 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "tkhai@yandex.ru" <tkhai@yandex.ru>
Subject: Re: [PATCH] sched/core: Create new task with twice disabled
 preemption
Message-ID: <20140214154906.GF10590@arm.com>
References: <1392306716.5384.3.camel@tkhai>
 <20140214123536.GA12304@arm.com>
 <1392381841.5384.43.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392381841.5384.43.camel@tkhai>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 12:44:01PM +0000, Kirill Tkhai wrote:
> В Птн, 14/02/2014 в 12:35 +0000, Catalin Marinas пишет:
> > On Thu, Feb 13, 2014 at 07:51:56PM +0400, Kirill Tkhai wrote:
> > > Preemption state on enter in finish_task_switch() is different
> > > in cases of context_switch() and schedule_tail().
> > > 
> > > In the first case we have it twice disabled: at the start of
> > > schedule() and during spin locking. In the second it is only
> > > once: the value which was set in init_task_preempt_count().
> > > 
> > > For archs without __ARCH_WANT_UNLOCKED_CTXSW set this means
> > > that all newly created tasks execute finish_arch_post_lock_switch()
> > > and post_schedule() with preemption enabled.
> > > 
> > > It seems there is possible a problem in rare situations on arm64,
> > > when one freshly created thread preempts another before
> > > finish_arch_post_lock_switch() has finished. If mm is the same,
> > > then TIF_SWITCH_MM on the second won't be set.
> > > 
> > > The second rare but possible issue is zeroing of post_schedule()
> > > on a wrong cpu.
> > > 
> > > So, lets fix this and unify preempt_count state.
> > 
> > An alternative to your patch:
> 
> It looks better, than the initial.
> 
> You may add my Acked-by if you want.

Thanks for the ack. But apart from arm64, are there any other problems
with running part of finish_task_switch() and post_schedule() with
preemption enabled?

The finish_arch_post_lock_switch() is currently only used by arm and
arm64 (the former UP only) and arm no longer has the preemption problem
(see commit bdae73cd374e2). So I can either disable the preemption
around schedule_tail() call in arm64 or do it globally as per yours or
my patch.

Peter, Ingo, any thoughts? Do we care about preempt count consistency
across finish_task_switch() and post_schedule()?

Thanks.

-- 
Catalin
