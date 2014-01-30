Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaA3QfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 11:35:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54822 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaA3QfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 11:35:08 -0500
Date: Thu, 30 Jan 2014 17:35:01 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: nicolas.pitre@linaro.org, mingo@redhat.com, tglx@linutronix.de,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [RFC PATCH 3/3] idle: store the idle state index in the struct rq
Message-ID: <20140130163501.GG5002@laptop.programming.kicks-ass.net>
References: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org>
 <1391090962-15032-4-git-send-email-daniel.lezcano@linaro.org>
 <20140130153150.GD5002@laptop.programming.kicks-ass.net>
 <52EA7D8A.6080604@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52EA7D8A.6080604@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 05:27:54PM +0100, Daniel Lezcano wrote:
> struct cpuidle_state *state = &drv->states[rq->index];
> 
> And from the state, we have the following informations:
> 
> struct cpuidle_state {
> 
> 	[ ... ]
> 
>         unsigned int    exit_latency; /* in US */
>         int             power_usage; /* in mW */
>         unsigned int    target_residency; /* in US */
>         bool            disabled; /* disabled on all CPUs */
> 
> 	[ ... ]
> };

Right, but can we say that a higher index will save more power and have
a higher exit latency? Or is a driver free to have a random mapping from
idle_index to state?

Also, we should probably create a pretty function to get that state,
just like you did in patch 1.

> IIRC, Alex Shi sent a patchset to improve the choosing of the idlest cpu and
> the exit_latency was needed.

Right. However if we have a 'natural' order in the state array the index
itself might often be sufficient to find the least idle state, in this
specific case the absolute exit latency doesn't matter, all we want is
the lowest one.

Not dereferencing the state array saves hitting cold cachelines.
