Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab3KGAqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 19:46:32 -0500
Received: from hofr.at ([212.69.189.236]:33465 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805Ab3KGAqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 19:46:31 -0500
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Nov 2013 19:46:30 EST
Date: Thu, 7 Nov 2013 01:36:25 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Stephan Mueller <smueller@chronox.de>,
        sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
	/dev/random
Message-ID: <20131107003625.GB1950@opentech.at>
References: <2579337.FPgJGgHYdz@tauon> <4306229.ErfOL470s2@tauon> <20131106124354.GJ14235@thunk.org> <9172761.DO0L6FkY0c@tauon> <20131106130432.GK14235@thunk.org> <20131106132457.GA13852@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106132457.GA13852@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Nov 2013, Pavel Machek wrote:

> Hi!
> 
> > Of course, some of the state in the CPU may not be unknown to the
> > attacker, if it is derived by external events that are not visible to
> > the attacker, such as a network interrupt.  But if that's the case,
> > why not measure network interrupts directly?  We're much less likely
> > to overestimate the amount of entropy we can extract the system in
> > that case.
> 
> Actually, I believe Stephan is up to something here.
> 
> We _can't_ measure network interrupts directly, because we do not have
> TSC. (And TSC-less machines are the ones that are problematic, right?)
>

If you are interested in entropy then there is no need to compare events against timestamps (which are just an event class) you can use any uncorrelated event (the assumption in using timestamps precisely is that they would be uncorrelated). If you are using jitter then the only question is how to extract it and how your
extracter can be assured to be sensitive to time differences that are smaller than what can be impacted by external events. Specifically this also means that no mater how you extract jitter you can not assume it is unbiased and you would need to unbias it (e.g. using Neuman/Peres method) - e.g. look at the jitter distributions in the OSADL QA-Farm - it is clear that they are in none of the cases bias-free.

E.g. practically all systems we looked at the jitter distribution is sensitive to the amount of memory in the box.
 
> Extracting entropy from the CPU will allow us to pick up entropy from
> network packets (and timer interrupt jitter) even on machines that
> lack TSC. And that counts like very cool feature.

if you use external events then I do not see the relation to using CPU inherent non-determinism - why do you want to bind the selectd events to an external and potentially contrtolable event at all ?

> 
> (And yes, we could just increment variable to get tsc emulation in
> idle loop, and then extract entropy from that. But we would not be
> able to enter low power states at that point, and it would not work
> when cpu is busy computing.)
>
there is so much global state information in the kernel that can be
used to harvest entropy I do not see why we would neeed to implement
a dedicated method (counter loop or the like) at all - rather
all that would be needed is an extracter.

Note that using global state though is not directly bound to microtiming (it
might be too complex to systematically scew never the less but that would need tto be demonstrated). The only think that I believe is directly bound to microttiming are race conditions (also not unbiased though).

thx!
hofrat
