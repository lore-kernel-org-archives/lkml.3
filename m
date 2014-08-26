Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaHZPGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:06:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbaHZPGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:06:52 -0400
Date: Tue, 26 Aug 2014 17:03:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Ionut Alexa <ionut.m.alexa@gmail.com>,
        Guillaume Morin <guillaume@morinfr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH 1/1] do_exit(): Solve possibility of BUG() due to race
	with try_to_wake_up()
Message-ID: <20140826150345.GA5671@redhat.com>
References: <1408964064-21447-1-git-send-email-consul.kautuk@gmail.com> <20140825155738.GA5944@redhat.com> <CAFPAmTS5_X1zEQ00vgh0POq_CheY71H+TnJ5uaP5wdWXYiwRtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFPAmTS5_X1zEQ00vgh0POq_CheY71H+TnJ5uaP5wdWXYiwRtA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26, Kautuk Consul wrote:
>
> I got one thing wrong:

Yes, your description was not accurate, but

> From some more code review, both __down_common() and
> do_wait_for_common() inspect the signal_pending() only while in
> TASK_RUNNING.

this doesn't really matter, or I missed something.

We have too much problems with this TASK_DEAD state. I have to admit that
I no longer understand why we do not need a barrier after spin_unlock_wait().

	set_current_state(TASK_UNINTERRUPTIBLE);

	__set_current_state(TASK_RUNNING);

	// do_exit()

	mb();
	spin_unlock_wait();

	tsk->state = TASK_DEAD;

	schedule();

Previously I was convinced, but now I think that ttwu(TASK_UNINTERRUPTIBLE)
still can change TASK_DEAD into TASK_RUNNING if CPU reorders spin_unlock_wait
and "state = TASK_DEAD".

Perhaps I am wrong and in any case we can fix this but there another problem,
in theory finish_task_switch() can race with RUNNING -> DEAD transition.

So I still think that the (incomplete) patch I sent probably makes sense, even
if it adds the ugly rq->dead check into __schedule().

Let's wait for Peter.

Oleg.

