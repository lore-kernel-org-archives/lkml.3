Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab3JNLTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 07:19:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53872 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab3JNLTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 07:19:02 -0400
Date: Mon, 14 Oct 2013 13:18:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com--no-chain-reply-to
Subject: Re: [PATCH 03/14] sched: SCHED_DEADLINE structures & implementation.
Message-ID: <20131014111842.GB3081@twins.programming.kicks-ass.net>
References: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com>
 <1381747426-31334-4-git-send-email-juri.lelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381747426-31334-4-git-send-email-juri.lelli@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 12:43:35PM +0200, Juri Lelli wrote:
> @@ -1693,8 +1701,14 @@ void sched_fork(struct task_struct *p)
>  		p->sched_reset_on_fork = 0;
>  	}
>  
> -	if (!rt_prio(p->prio))
> +	if (dl_prio(p->prio)) {
> +		put_cpu();
> +		return -EAGAIN;

Is this really the error we want to return on fork()?

EAGAIN to me indicates a spurious error and we should try again later;
however as it obvious from the code above; we'll always fail, there's no
point in trying again later.

I would think something like EINVAL; even though there are no arguments
to fork(); would me a better option.

Then again; I really don't care too much; anybody any preferences?
