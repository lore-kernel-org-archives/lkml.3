Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaIBPzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:55:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbaIBPzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:55:03 -0400
Date: Tue, 2 Sep 2014 17:52:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kautuk Consul <consul.kautuk@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Ionut Alexa <ionut.m.alexa@gmail.com>,
        Guillaume Morin <guillaume@morinfr.org>, linux-kernel@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH 1/1] do_exit(): Solve possibility of BUG() due to race
	with try_to_wake_up()
Message-ID: <20140902155208.GA28668@redhat.com>
References: <1408964064-21447-1-git-send-email-consul.kautuk@gmail.com> <20140825155738.GA5944@redhat.com> <20140901153935.GQ27892@worktop.ger.corp.intel.com> <20140901175851.GA15210@redhat.com> <20140901190931.GD5806@worktop.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140901190931.GD5806@worktop.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01, Peter Zijlstra wrote:
>
> On Mon, Sep 01, 2014 at 07:58:51PM +0200, Oleg Nesterov wrote:
>
> > However, the very fact that another CPU can look at this task_struct
> > means that we still need spin_unlock_wait(). If nothing else to ensure
> > that try_to_wake_up()->spin_unlock(pi_lock) won't write into the memory
> > we are are going to free.
>
> task_struct is RCU freed, if it still has a 'reference' to the task,

Not really, put_task_struct() frees this memory once the counter is zero,
but this doesn't matter,

> it shouldn't be going 'away', right?

Yes, thanks for correcting me. Somehow I forgot that the caller of ttwu()
should have a reference anyway. And indeed, say, __rwsem_do_wake() does
have. Otherwise this code would be obviously buggy in any case.

> > So I think the comment in do exit should be updated too, and smp_mb()
> > should be moved under raw_spin_unlock_wait() but ...
> >
> > But. If am right, doesn't this mean we that have even more problems with
> > postmortem wakeups??? Why ttwu() can't _start_ after spin_unlock_wait ?
>
> ttwu should bail at: if (!(p->state & state)) goto out; That should
> never match with TASK_DEAD.

See above. I meant another problem, but I was wrong.

OK. So this patch should probably work. But let me think again and send
it tommorrow. Because today (and yesterday) I didn't really sleep ;)

Oleg.

