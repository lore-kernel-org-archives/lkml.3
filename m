Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945AbaCSCXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 22:23:22 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58475 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757623AbaCSCXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 22:23:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140318162319.GB5669@redhat.com>
References: <1395148208-2209-1-git-send-email-bergwolf@gmail.com>
 <20140318133331.GA23193@laptop.programming.kicks-ass.net> <CA+a=Yy74V9_N4L8DoG=6iLnjGyOb6=ifraAqs5jW7ZsCG0t7jw@mail.gmail.com>
 <20140318140504.GD23193@laptop.programming.kicks-ass.net> <CA+a=Yy567xtU0Osz+9-hTCNrzB65vE=ErYWTq880N+uEwG2DHA@mail.gmail.com>
 <20140318162319.GB5669@redhat.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Wed, 19 Mar 2014 10:22:59 +0800
Message-ID: <CA+a=Yy51Ex=UdsCRn8Ty_s4XR4xbOZ_YAf3tejb=JyTgQ_QzRA@mail.gmail.com>
Subject: Re: [PATCH RFC] sched: introduce add_wait_queue_exclusive_head
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 12:23 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 03/18, Peng Tao wrote:
>>
>> On Tue, Mar 18, 2014 at 10:05 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> >
>> > Unless you cannot use ___wait() and really need to open-code the
>> > wait_event() stuff.
>> >
>> Lustre's private l_wait_event() stuff takes care to (un)mask
>> LUSTRE_FATAL_SIGS
>
> Hmm. This is off-topic but after the quick grep LUSTRE_FATAL_SIGS/etc
> looks suspicious.
>
> Firtsly, cfs_block_sigs/cfs_block_sigsinv/etc are not exactly right,
> they need set_current_blocked(). And you can read "old" lockless.
>
It seems that set_current_blocked() is not exported. Can we ask to export it?

And looking at other similar places like coda_block_signals(), it
doesn't call set_current_blocked() either. So it needs
set_current_blocked() as well.

> And note that cfs_block_sigsinv(0) (which should block all signals)
> can't actually protect from SIGKILL (or in fact from another fatal
> signal) or SIGSTOP if the caller is multithreaded. Or ptrace, or
> freezer.
>
>> and always wait in TASK_INTERRUPTIBLE state.
>
> and it seems that __wstate passed to waitq_wait/waitq_timedwait is
> simply ignored.
>
Yes. That needs to be dropped.

>> It looks to me that we can at least wrap l_wait_event() on top of
>> wait_event_interruptible/wait_event_timeout_interruptible.
>
> l_wait_event looks really complicated ;) but perhaps you can rewrite
> it on top of ___wait_event(), note that condition/cmd can do anything
> you want.
>
Yeah, I meant to say __wait_event(). Thanks for correcting me.

Thanks,
Tao
