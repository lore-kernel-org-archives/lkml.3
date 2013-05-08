Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab3EHOeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:34:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:33282 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740Ab3EHOeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:34:36 -0400
Date: Wed, 8 May 2013 16:34:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@ucw.cz>
cc: Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>,
        Feng Tang <feng.tang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Fwd: [GIT PULL] timer changes for v3.10
In-Reply-To: <20130508105542.GA22703@amd.pavel.ucw.cz>
Message-ID: <alpine.LFD.2.02.1305081626110.2863@ionos>
References: <20130430074322.GA20110@gmail.com> <20130506230137.GA16801@amd.pavel.ucw.cz> <CA++bM2scosWgBpC3_LzcKYOjG4EQQzN5Vf4rZFds-5qRVRwvDQ@mail.gmail.com> <20130507023853.GA2945@feng-snb> <20130507065348.GF17705@gmail.com> <51892560.7090202@linaro.org>
 <20130507213142.GA10061@amd.pavel.ucw.cz> <51897497.7040806@linaro.org> <20130507215151.GB10061@amd.pavel.ucw.cz> <20130508064419.GA5378@gmail.com> <20130508105542.GA22703@amd.pavel.ucw.cz>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel,

On Wed, 8 May 2013, Pavel Machek wrote:
> > > > Sorry. You seem to not like the merged change, but I guess I'm not
> > > > quite sure what exactly your objection is here.
> > > 
> > > I'm not exactly sure what my objections are.
> > > 
> > > TSC was not designed for long-term precise timekeeping. [...]
> > 
> > The TSC is just a 64-bit counter that can be read very cheaply.
> > 
> > If the TSC is _implemented_ precisely in hardware and is kept in sync over 
> > CPUs then it's obviously fit for long-term precise timekeeping from that 
> > point on.
> 
> Yes. But the clock for TSC is not being generated in CPU (right?) and
> AFAICT, the code said "if the CPU is new enough, assume TSC is good
> timesource". You need good clock for good timesource.

TSC is a good clock source if:

    - Frequency constant (>= Core2)
    - Not affected by C-States (>= Nehalem)
    - Running during Suspend (>= Haswell)

So we only use TSC across Suspend for Haswell and newer. On older
systems we use RTC during suspend, but we still use the TSC as a
clocksource during normal operation.

> > > [...] but some people suspend their machines for longer than that. Plus 
> > > I wonder how it will interfere with /etc/adjtime.
> > 
> > If it's precise then why should it interfere?
> > 
> > The history of the TSC being problematic can be ignored the moment CPU 
> > makers fix it completely - and apparently that is happening...
> 
> AFAICT we normally use RTC/PIT during runtime. If we switch to TSC

No, we do NOT use RTC/PIT during runtime. That's the worst choice one
could make. If TSC is non frequency constant or affected by C-States
we use HPET or PM-Timer, and we only ever use the PIT if nothing else
is available.

RTC is not used at all for timekeeping. RTC is only used at system
start and when we resume and the TSC stopped during that time, which
is true for hibernation even on Haswell and newer.

> during suspend, surely /etc/adjtime will be confused. (RTC has its own
> timesource, so it is unlikely to have same error as TSC).

Nothing gets confused. It's all handled proper in the core code and
the clock source drivers.

Thanks,

	tglx
