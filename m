Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965161Ab3DJRYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:24:52 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:59974 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934231Ab3DJRYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:24:51 -0400
Date: Wed, 10 Apr 2013 19:24:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Michal Marek <mmarek@suse.cz>
Subject: Re: [RFC GIT PULL] nohz: Kconfig layout improvements
Message-ID: <20130410172446.GF21951@gmail.com>
References: <1364993190-13784-1-git-send-email-fweisbec@gmail.com>
 <20130408111919.GB1225@gmail.com>
 <CAFTL4hxDGfEWPz0+zsHLmdaPDSg4n0iFHpeN=w=5eFGX9sRZ2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hxDGfEWPz0+zsHLmdaPDSg4n0iFHpeN=w=5eFGX9sRZ2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> 2013/4/8 Ingo Molnar <mingo@kernel.org>:
> > I pulled it into tip:timers/nohz and will push it out if it passes testing because
> > I like the improvements - but there's still a few things missing I think.
> >
> > Firstly, I performed this "how are users exposed to this new feature" test:
> >
> >    git checkout v3.9-rc6
> >    make defconfig
> >    git checkout tip/master
> >    make oldconfig
> >
> > the x86 (64-bit) defconfig has NO_HZ enabled. When I did the 'make oldconfig', I
> > was given:
> >
> >   *
> >   * Timers subsystem
> >   *
> >   Timer tick handling
> >   > 1. Periodic timer ticks (constant rate, no dynticks) (PERIODIC_HZ) (NEW)
> >     2. Idle dynticks system (tickless idle) (NO_HZ_IDLE) (NEW)
> >   choice[1-2]:
> >
> > [ Firstly, while at it: that should be 'Timer subsystem' or 'Timers'. ]
> 
> Isn't "Timers" too general? I really don't mind changing that though.

I'd suggest consulting Thomas.

> > More importantly, the new Kconfig behavior is still not quite right for two
> > reasons:
> >
> > 1)
> >
> > the default is not set to NO_HZ_IDLE. The oldconfig .config had
> > CONFIG_NO_HZ set - this should be grandfathered over into the new config's
> > default choice. That can probably be done by still keeping CONFIG_NO_HZ as
> > a migration helper entry.
> 
> Ah I did keep it for backward compatibility. We default to
> CONFIG_NO_HZ_IDLE if CONFIG_NO_HZ is set. This is just not working
> because CONFIG_NO_HZ isn't visible. It's an arbirtrary Kconfig
> limitation. I'll just make it visible by adding it a title text and
> this will work.

Okay, cool!

> > 2)
> >
> > there's still no extended idle tick option offered - due to it not meeting
> > the CONFIG_VIRT_CPU_ACCOUNTING_GEN dependency.
> >
> > Even if I read the Kconfig rules and figure out the dependency, I have to
> > perform _two_ steps to get extended ticks:
> >
> > I had to manually find CONFIG_VIRT_CPU_ACCOUNTING_GEN in the .config and
> > delete it, so that I'm given the choice on the next 'make oldconfig'.
> >
> > Then NO_HZ_EXTENDED was set to disabled in the .config silently, because
> > NO_HZ_IDLE was already set. So I had to delete that and re-configure it
> > again.
> 
> Agreed. I mentioned that in the pull request. It's again due to an
> arbitrary Kconfig limitation. The following:
> 
>     config X
>         select Y
> 
> doesn't work if Y is part of a Kconfig "choice".
> I have a patch that fixes in Kconfig, will submit it to Michal and fix
> the nohz passive dependency once we get that sorted.

Wow, you are fixing kconfig.

99% of the people work it around in some fashion.

Kudos!

Thanks,

	Ingo
