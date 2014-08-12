Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbaHLTOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 15:14:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678AbaHLTOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 15:14:41 -0400
Date: Tue, 12 Aug 2014 21:12:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time: drop do_sys_times spinlock
Message-ID: <20140812191218.GA15210@redhat.com>
References: <20140812142539.01851e52@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140812142539.01851e52@annuminas.surriel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12, Rik van Riel wrote:
>
> Back in 2009, Spencer Candland pointed out there is a race with
> do_sys_times, where multiple threads calling do_sys_times can
> sometimes get decreasing results.
>
> https://lkml.org/lkml/2009/11/3/522
>
> As a result of that discussion, some of the code in do_sys_times
> was moved under a spinlock.
>
> However, that does not seem to actually make the race go away on
> larger systems. One obvious remaining race is that after one thread
> is about to return from do_sys_times, it is preempted by another
> thread, which also runs do_sys_times, and stores a larger value in
> the shared variable than what the first thread got.
>
> This race is on the kernel/userspace boundary, and not fixable
> with spinlocks.

Not sure I understand...

Afaics, the problem is that a single thread can observe the decreasing
(say) sum_exec_runtime if it calls do_sys_times() twice without the lock.

This is because it can account the exiting sub-thread twice if it races
with __exit_signal() which increments sig->sum_sched_runtime, but this
exiting thread can still be visible to thread_group_cputime().

IOW, it is not actually about decreasing, the problem is that the lockless
thread_group_cputime() can return the wrong result, and the next ys_times()
can show the right value.

> Back in 2009, in changeset 2b5fe6de5 Oleg Nesterov already found
> that it should be safe to remove the spinlock.

Yes, it is safe but only in a sense that for_each_thread() is fine lockless.
So this change was reverted.

Oleg.

