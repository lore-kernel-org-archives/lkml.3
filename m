Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab3L0UA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 15:00:28 -0500
Received: from hofr.at ([212.69.189.236]:60468 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab3L0UA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 15:00:27 -0500
Date: Fri, 27 Dec 2013 21:00:24 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.6-rt9
Message-ID: <20131227200024.GA19505@opentech.at>
References: <20131223225017.GA8623@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131223225017.GA8623@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Dec 2013, Sebastian Andrzej Siewior wrote:

> Dear RT folks!
> 
> I'm pleased to announce the v3.12.6-rt9 patch set.
> 
> Changes since v3.12.6-rt8
<snip>
> - A patch from Thomas Gleixner not to raise the timer softirq
>   unconditionally (only if a timer is pending)
> 

This one seems to deadlock early in the boot sequence on x86
(i3/i7/Phenom-4x here and Carsten Emde also had boot failures)

after droping this patch with:
patch -p1 -R < ../paches/timers-do-not-raise-softirq-unconditionally.patch
3.12.6-rt9 boots up fine. cyclictest seems to be back to what it was before
(only ran for a few minutes idle and 1h with load on an i3).

The main problem with this patch though are proceduaral isues 
the commit note - which is a mail exchange - actually does not explain what 
the rational for the changes is (...well I don't understand the logic of
run_local_timers - if someone can explain - pleas do) and notably:

from timers-do-not-raise-softirq-unconditionally.patch
<snip>
well, that very same problem is in mainline if you add "threadirqs" to
the command line. But we can be smart about this. The untested patch
                                                    ^^^^^^^^^^^^^^^^^^
below should address that issue. If that works on mainline we can
adapt it for RT (needs a trylock(&base->lock) there).
<snip>

 does make me wonder why this went into -rt9 ?
 It also build fails with CONFIG_PREEMPT_RT_FULL not set.

 as with this patch, systems that booted just fine with 3.12.5-rt7 don't
 even boot (atleast my 3 x86 test boxes here did not) this raises some
 questions regarding the process of getting patches into -rtX - are
 we going to fast here ?

 I would prefere if such patches would go out with a request for testing
 or atleast a "might blow up your system" note in them...

thx!
hofrat
