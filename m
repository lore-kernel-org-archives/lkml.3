Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbaBQOnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 09:43:32 -0500
Received: from relay.parallels.com ([195.214.232.42]:45476 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaBQOnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 09:43:31 -0500
Message-ID: <1392648219.5384.93.camel@tkhai>
Subject: Re: [PATCH] sched/core: Create new task with twice disabled
 preemption
From: Kirill Tkhai <ktkhai@parallels.com>
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, "tkhai@yandex.ru" <tkhai@yandex.ru>
Date: Mon, 17 Feb 2014 18:43:39 +0400
In-Reply-To: <20140214154906.GF10590@arm.com>
References: <1392306716.5384.3.camel@tkhai> <20140214123536.GA12304@arm.com>
	 <1392381841.5384.43.camel@tkhai> <20140214154906.GF10590@arm.com>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Птн, 14/02/2014 в 15:49 +0000, Catalin Marinas пишет:
> On Fri, Feb 14, 2014 at 12:44:01PM +0000, Kirill Tkhai wrote:
> > В Птн, 14/02/2014 в 12:35 +0000, Catalin Marinas пишет:
> > > On Thu, Feb 13, 2014 at 07:51:56PM +0400, Kirill Tkhai wrote:
> > > > Preemption state on enter in finish_task_switch() is different
> > > > in cases of context_switch() and schedule_tail().
> > > > 
> > > > In the first case we have it twice disabled: at the start of
> > > > schedule() and during spin locking. In the second it is only
> > > > once: the value which was set in init_task_preempt_count().
> > > > 
> > > > For archs without __ARCH_WANT_UNLOCKED_CTXSW set this means
> > > > that all newly created tasks execute finish_arch_post_lock_switch()
> > > > and post_schedule() with preemption enabled.
> > > > 
> > > > It seems there is possible a problem in rare situations on arm64,
> > > > when one freshly created thread preempts another before
> > > > finish_arch_post_lock_switch() has finished. If mm is the same,
> > > > then TIF_SWITCH_MM on the second won't be set.
> > > > 
> > > > The second rare but possible issue is zeroing of post_schedule()
> > > > on a wrong cpu.
> > > > 
> > > > So, lets fix this and unify preempt_count state.
> > > 
> > > An alternative to your patch:
> > 
> > It looks better, than the initial.
> > 
> > You may add my Acked-by if you want.
> 
> Thanks for the ack. But apart from arm64, are there any other problems
> with running part of finish_task_switch() and post_schedule() with
> preemption enabled?

1)We have architecture-dependent finish_arch_post_lock_switch()
  which is possible(?) to be fixed for every arch at the moment,
  but someone may run into it in the future.

2)The second is fire_sched_in_preempt_notifiers(). It's generic interface
  which is currently unused. It notifies about preemption, so it's bad
  if additional preemption happens when it has not finished.

3)tick_nohz_task_switch() seems to be without problems. Just very-very
  slightly performance.

4)If post_schedule() happens on wrong CPU, the system may occur imbalanced
  for a short period. This happens, when post_schedule() of wrong class
  is executed.

If we fix that once in scheduler we'll decide everything above now and
in the future. Also we'll decrease number of rare situations.

> The finish_arch_post_lock_switch() is currently only used by arm and
> arm64 (the former UP only) and arm no longer has the preemption problem
> (see commit bdae73cd374e2). So I can either disable the preemption
> around schedule_tail() call in arm64 or do it globally as per yours or
> my patch.
> 
> Peter, Ingo, any thoughts? Do we care about preempt count consistency
> across finish_task_switch() and post_schedule()?
> 
> Thanks.
> 


