Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847Ab3EOJma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:42:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:56269 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758480Ab3EOJm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:42:27 -0400
Date: Wed, 15 May 2013 11:42:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 05/15] clocksource: Allow clocksource select to skip
 current clocksource
In-Reply-To: <517F17AB.5070100@linaro.org>
Message-ID: <alpine.LFD.2.02.1305151142100.1388@ionos>
References: <20130425142452.908423538@linutronix.de> <20130425143435.834965397@linutronix.de> <517F17AB.5070100@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Apr 2013, John Stultz wrote:
> On 04/25/2013 01:31 PM, Thomas Gleixner wrote:
> > Preparatory patch for clocksource unbind support.
> > 
> > Modify clocksource_select, so it skips the current clocksource on
> > request and tries to find a fallback clocksource. Convert all existing
> > users. No functional change.
> > 
> > Signed-off-by: Thomas Gleixner<tglx@linutronix.de>
> > ---
> >   kernel/time/clocksource.c |   24 ++++++++++++++----------
> >   1 file changed, 14 insertions(+), 10 deletions(-)
> > 
> > Index: tip/kernel/time/clocksource.c
> > ===================================================================
> > --- tip.orig/kernel/time/clocksource.c
> > +++ tip/kernel/time/clocksource.c
> > @@ -553,7 +553,7 @@ static u64 clocksource_max_deferment(str
> >     #ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
> >   -static struct clocksource *clocksource_find_best(bool oneshot)
> > +static struct clocksource *clocksource_find_best(bool oneshot, bool
> > skipcur)
> >   {
> >   	struct clocksource *cs;
> >   @@ -566,6 +566,8 @@ static struct clocksource *clocksource_f
> >   	 * the best rating.
> >   	 */
> >   	list_for_each_entry(cs, &clocksource_list, list) {
> > +		if (skipcur && cs == curr_clocksource)
> > +			continue;
> >   		if (oneshot && !(cs->flags & CLOCK_SOURCE_VALID_FOR_HRES))
> >   			continue;
> >   		return cs;
> > @@ -581,18 +583,20 @@ static struct clocksource *clocksource_f
> >    * Select the clocksource with the best rating, or the clocksource,
> >    * which is selected by userspace override.
> >    */
> > -static void clocksource_select(void)
> > +static void clocksource_select(bool skipcur)
> >   {
> >   	bool oneshot = tick_oneshot_mode_active();
> >   	struct clocksource *best, *cs;
> >     	/* Find the best suitable clocksource */
> > -	best = clocksource_find_best(oneshot);
> > +	best = clocksource_find_best(oneshot, skipcur);
> >   	if (!best)
> >   		return;
> >     	/* Check for the override clocksource. */
> >   	list_for_each_entry(cs, &clocksource_list, list) {
> > +		if (skipcur && cs == curr_clocksource)
> > +			continue;
> >   		if (strcmp(cs->name, override_name) != 0)
> >   			continue;
> >   		/*
> > @@ -620,7 +624,7 @@ static void clocksource_select(void)
> >     #else /* !CONFIG_ARCH_USES_GETTIMEOFFSET */
> >   -static inline void clocksource_select(void) { }
> > +static inline void clocksource_select(bool skipcur) { }
> >     #endif
> 
> Not a major objection, but I sort of don't like the bool flag arguments to
> function that alters their behavior, since its not really very descriptive. I
> know I'll be looking at the code below thinking "hmmm..
> clocksource_select(false).. now what does that mean?" at some point not too
> far away.
> 
> Instead, would leaving clocksource_select() alone, and introducing a
> clocksource_select_fallback() for the skipcur behavior, be a more descriptive
> choice? The code could very much use the same skipcur logic, in a
> __clocksource_select() or something function, but just helps make the normal
> usage easier to read.

Yeah, I can do that.
