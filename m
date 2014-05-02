Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaEBSVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 14:21:00 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:43457 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaEBSU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 14:20:58 -0400
Date: Fri, 2 May 2014 14:20:56 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Daniel Lezcano <daniel.lezcano@linaro.org>, peterz@infradead.org,
        mingo@elte.hu, amit.kucheria@linaro.org,
        linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/2] sched: idle: Encapsulate the code to compile it
 out
In-Reply-To: <5985714.f7hh9Ej59L@vostro.rjw.lan>
Message-ID: <alpine.LFD.2.11.1405021417460.980@knanqh.ubzr>
References: <1398859263-7632-1-git-send-email-daniel.lezcano@linaro.org> <2735426.75qSjG3M6Y@vostro.rjw.lan> <53635E5F.8070100@linaro.org> <5985714.f7hh9Ej59L@vostro.rjw.lan>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2014, Rafael J. Wysocki wrote:

> On Friday, May 02, 2014 10:59:11 AM Daniel Lezcano wrote:
> > On 05/01/2014 12:56 AM, Rafael J. Wysocki wrote:
> > > On Thursday, May 01, 2014 12:47:25 AM Rafael J. Wysocki wrote:
> > >> On Wednesday, April 30, 2014 02:01:02 PM Daniel Lezcano wrote:
> > >>> Encapsulate the large portion of cpuidle_idle_call inside another
> > >>> function so when CONFIG_CPU_IDLE=n, the code will be compiled out.
> > >>> Also that is benefitial for the clarity of the code as it removes
> > >>> a nested indentation level.
> > >>>
> > >>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> > >>
> > >> Well, this conflicts with
> > >>
> > >> https://patchwork.kernel.org/patch/4071541/
> > >>
> > >> which you haven't commented on and I still want cpuidle_select() to be able to
> > >> return negative values because of
> > >>
> > >> https://patchwork.kernel.org/patch/4089631/
> > >>
> > >> (and I have one more patch on top of these two that requires this).
> > >
> > > Moreover (along the lines of Nico said) after https://patchwork.kernel.org/patch/4071541/
> > > we actually don't need the #ifdef CONFIG_CPU_IDLE in your patch, because cpuidle_select()
> > > for CONFIG_CPU_IDLE unset is a static inline returning a negative number and the compiler
> > > should optimize out the blocks that depend on it being non-negative.
> > 
> > Thanks for the head up.
> > 
> > Actually that was to solve a compilation issue with the next patch when 
> > adding the cpuidle state in the struct rq.
> > 
> > When the option CPU_IDLE is not set, the code assinging the cpu idle 
> > state in the rq is still there while in the struct rq the field is 
> > compiled out with the ifdef macro. If I rely on the compiler 
> > optimization, the compilation error will happen.
> 
> I see.
> 
> If you don't put the new idle_state field in struct_rq under the #ifdef,
> you won't need to worry about the build problem.
> 
> Alternatively, you can define
> 
> #ifdef CONFIG_CPU_IDLE
> static inline void rq_set_idle_state(struct rq *rq, struct cpuidle_state *state)
> {
> 	rq->idle_state = state;
> }
> #else
> static inline void rq_set_idle_state(struct rq *rq, struct cpuidle_state *state) {}
> #endif
> 
> and use rq_set_idle_state() to set that field.

Agreed.  And a similar accessor for consumers to get this value in order 
to avoid #ifdef's there as well.


Nicolas
