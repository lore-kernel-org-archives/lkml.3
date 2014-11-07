Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaKGSld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:41:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbaKGSlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:41:32 -0500
Date: Fri, 7 Nov 2014 19:41:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Subbaraman Narayanamurthy <subbaram@codeaurora.org>,
        daniel@numascale.com, yuyang.du@intel.com,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH]: kthread: Fix memory ordering in __kthread_parkme
Message-ID: <20141107184103.GA16043@redhat.com>
References: <20141106150150.GT10501@worktop.programming.kicks-ass.net> <alpine.DEB.2.11.1411071037440.3789@nanos> <20141107102855.GA29390@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107102855.GA29390@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07, Peter Zijlstra wrote:
>
>  static void __kthread_parkme(struct kthread *self)
>  {
> -	__set_current_state(TASK_PARKED);
> +	set_current_state(TASK_PARKED);
>  	while (test_bit(KTHREAD_SHOULD_PARK, &self->flags)) {
>  		if (!test_and_set_bit(KTHREAD_IS_PARKED, &self->flags))
>  			complete(&self->parked);
>  		schedule();
> -		__set_current_state(TASK_PARKED);
> +		set_current_state(TASK_PARKED);
>  	}

Perhaps it makses sense to do set_current_state(PARKED) once at the start
of "for (;;)" loop, but this is cosmetic.

What if kthread_unpark() is called right after test_bit(KTHREAD_SHOULD_PARK)
and KTHREAD_IS_PARKED is not set? It seems that __kthread_unpark() should
call wake_up_state() unconditionally ?

Oleg.

