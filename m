Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbaHDSz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 14:55:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbaHDSz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 14:55:58 -0400
Date: Mon, 4 Aug 2014 20:53:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de,
        ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 3/7] exit: Desl with nested sleeps
Message-ID: <20140804185336.GA21619@redhat.com>
References: <20140804103025.478913141@infradead.org> <20140804103537.492992183@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804103537.492992183@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04, Peter Zijlstra wrote:
>
> Not strictly a bug in the current form,

Yes, this is the false positive.

> but clean it up to enable
> debugging infrastructure and avoid it becoming a bug.

OK, but

> @@ -991,6 +991,8 @@ static int wait_task_zombie(struct wait_
>
>  		get_task_struct(p);
>  		read_unlock(&tasklist_lock);
> +		__set_current_state(TASK_RUNNING);
> +

without a comment it is not clear why do we bother to set RUNNING here.

Perhaps we can add another helper which sets current->state = RUNNING?
Just to self-document the usage.

We can even make it depend on CONFIG_DEBUG_ATOMIC_SLEEP (not sure this
makes sense). But in this case it should set ->task_state_change = 0
and __might_sleep() should take !task_state_change into account.

Oleg.

