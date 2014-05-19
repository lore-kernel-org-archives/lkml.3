Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbaESRaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:30:10 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:40932 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbaESRaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:30:08 -0400
From: bsegall@google.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <klamm@yandex-team.ru>, linux-kernel@vger.kernel.org,
        pjt@google.com, chris.j.arges@canonical.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] sched: tg_set_cfs_bandwidth() causes rq->lock deadlock
References: <87mwej0yja.wl%klamm@yandex-team.ru>
	<xm26k39n3pl9.fsf@sword-of-the-dawn.mtv.corp.google.com>
	<87lhu215ky.wl%klamm@yandex-team.ru>
	<20140519103247.GX30445@twins.programming.kicks-ass.net>
Date: Mon, 19 May 2014 10:30:05 -0700
In-Reply-To: <20140519103247.GX30445@twins.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Mon, 19 May 2014 12:32:47 +0200")
Message-ID: <xm26wqdh3cde.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Fri, May 16, 2014 at 12:38:21PM +0400, Roman Gushchin wrote:
>
>> I still think, there is a deadlock. I'll try to explain.
>> Three CPUs must be involved:
>> CPU0				CPU1				CPU2
>> take rq->lock			period timer fired		
>> ...				take cfs_b lock
>> ...				...				tg_set_cfs_bandwidth()
>> throttle_cfs_rq()		release cfs_b lock		take cfs_b lock
>> ...				distribute_cfs_runtime()	timer_active = 0
>> take cfs_b->lock		wait for rq->lock		...
>> __start_cfs_bandwidth()	
>> {wait for timer callback
>>  break if timer_active == 1}
>> 
>> So, CPU0 and CPU1 are deadlocked.
>
> OK, so can someone explain this ->timer_active thing? esp. what's the
> 'obvious' difference with hrtimer_active()?

timer_active is only changed or checked under cfs_b lock, so that we can
be certain that the timer is active whenever runtime isn't full. We
can't use hrtimer_active because the timer might have unlocked the cfs_b
on another cpu and be about to return HRTIMER_NORESTART.
>
>
> Ideally we'd change the lot to not have this, but if we have to keep it
> we'll need to make it lockdep visible because all this stinks
