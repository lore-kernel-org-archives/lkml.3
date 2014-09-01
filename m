Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaIATJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 15:09:42 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50457 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbaIATJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 15:09:40 -0400
Date: Mon, 1 Sep 2014 21:09:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kautuk Consul <consul.kautuk@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Ionut Alexa <ionut.m.alexa@gmail.com>,
        Guillaume Morin <guillaume@morinfr.org>, linux-kernel@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH 1/1] do_exit(): Solve possibility of BUG() due to race
 with try_to_wake_up()
Message-ID: <20140901190931.GD5806@worktop.ger.corp.intel.com>
References: <1408964064-21447-1-git-send-email-consul.kautuk@gmail.com>
 <20140825155738.GA5944@redhat.com>
 <20140901153935.GQ27892@worktop.ger.corp.intel.com>
 <20140901175851.GA15210@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140901175851.GA15210@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 07:58:51PM +0200, Oleg Nesterov wrote:

> However, the very fact that another CPU can look at this task_struct
> means that we still need spin_unlock_wait(). If nothing else to ensure
> that try_to_wake_up()->spin_unlock(pi_lock) won't write into the memory
> we are are going to free.

task_struct is RCU freed, if it still has a 'reference' to the task, it
shouldn't be going 'away', right?

> So I think the comment in do exit should be updated too, and smp_mb()
> should be moved under raw_spin_unlock_wait() but ...
> 
> But. If am right, doesn't this mean we that have even more problems with
> postmortem wakeups??? Why ttwu() can't _start_ after spin_unlock_wait ?

ttwu should bail at: if (!(p->state & state)) goto out; That should
never match with TASK_DEAD.

Either that; or I should go sleep already :-) I shifted 7 hours
yesterday, so I'm still somewhat jet-lagged.
