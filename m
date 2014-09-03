Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbaICJpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:45:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43069 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930AbaICJpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:45:53 -0400
Date: Wed, 3 Sep 2014 11:45:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Oleg Nesterov <oleg@redhat.com>, Kautuk Consul <consul.kautuk@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Ionut Alexa <ionut.m.alexa@gmail.com>,
        Guillaume Morin <guillaume@morinfr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] do_exit(): Solve possibility of BUG() due to race
 with try_to_wake_up()
Message-ID: <20140903094538.GF4783@worktop.ger.corp.intel.com>
References: <1408964064-21447-1-git-send-email-consul.kautuk@gmail.com>
 <20140825155738.GA5944@redhat.com>
 <3702911409735076@web26g.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3702911409735076@web26g.yandex.ru>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 01:04:36PM +0400, Kirill Tkhai wrote:
> 25.08.2014, 20:01, "Oleg Nesterov" <oleg@redhat.com>:
> > Peter, do you remember another problem with TASK_DEAD we discussed recently?
> > (prev_state == TASK_DEAD detection in finish_task_switch() still looks racy).
> 
> One more problem with task_dead just to mention it here.
> 
> Below is racy with the change of sched_class:
> 
>         if (prev->sched_class->task_dead)
>                 prev->sched_class->task_dead(prev);
> 
> switched_from_dl() does not cancel running timers.

Well, it does a try_to_cancel() but yes, that can fail. Now I suspect
you cannot actually do hrtimer_cancel() from switched_from because its
called with locks held and the timer function will also try and acquire
those locks.

But yes, that appears to be an actual problem indeed.
