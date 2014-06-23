Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaFWSEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:04:55 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:58636 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210AbaFWSEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:04:54 -0400
X-Yandex-Uniq: f2218227-b348-45c9-b2c3-2c842100aa91
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Mon, 23 Jun 2014 22:04:43 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: john.stultz@linaro.org, prarit@redhat.com, paul.gortmaker@windriver.com,
        juri.lelli@gmail.com, ddaney.cavm@gmail.com, mbohan@codeaurora.org,
        david.vrabel@citrix.com, david.engraf@sysgo.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hrtimers: calculate expires_next after all timers are
 executed
Message-ID: <20140623180443.GD20225@stfomichev-desktop.yandex.net>
References: <1395067037-20060-1-git-send-email-stfomichev@yandex-team.ru>
 <alpine.DEB.2.02.1403191149460.18573@ionos.tec.linutronix.de>
 <20140319141615.GB11081@stfomichev-desktop.yandex.net>
 <alpine.DEB.2.10.1406221417510.5170@nanos>
 <20140623110302.GA20225@stfomichev-desktop.yandex.net>
 <alpine.DEB.2.10.1406231904090.5170@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1406231904090.5170@nanos>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So in case the enqueued timer is earlier than base0->next, you are
> looking at the wrong data. Same as in the current code and why you
> started to look into this at all.
Right, even if we do a local enqueue from higher base timer into lower base we
still need to update base->next in the enqueue.

> See above WHY it does NOT work.
It works, but without reprogramming in __remove_hrtimer we can end up with a
spurious tick which will just rearm clockdev and do no useful work.
At least no stall :-/

> No, we're not going to add another one in the first place as I know
> how MAY COME works: it translates to NEVER, unless I do it myself.
I'm fine with that, the point I'm trying to make is that I didn't even think
about any cleanup/refactoring in the first place, I just tried to get an
issue fixed and get some feedback. It's even better if we can also do a
cleanup in the process.

> > > Untested patch which addresses the issues below.
> > Aside from a small nitpick below, looks reasonable, I'll try to run it on a
> > couple of machines.
> > Should I send you a v3 afterwards with the changelog or
> > tested-by would be enough?
> 
> Tested-by is fine. I can cobble a changelog together.
Ok, I have a couple of machines running for ~5 hours without any visible
issues, but let's give it at least a day.

> > > +	while (active) {
> > > +		idx = __ffs(active);
> > > +		active &= ~(1UL << idx);
> > Is there any reason you did that instead of conventional:
> 
> I thought about using __ffs before, just never came around it.
Nothing against it, seems totally legit, just looks inconsistent.
Now we have one place where we do __ffs stuff and other places where we
do for(;HRTIMER_MAX_CLOCK_BASES;).
