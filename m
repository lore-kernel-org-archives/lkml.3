Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab3C0BXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 21:23:38 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:60704 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3C0BXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 21:23:37 -0400
Date: Tue, 26 Mar 2013 18:23:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] nohz: Full dynticks base interface
Message-ID: <20130327012323.GX4379@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1363879460-21595-1-git-send-email-fweisbec@gmail.com>
 <20130324081701.GA13328@gmail.com>
 <CAFTL4hx4FLaRR6i9ap9UrCZY4ikhVtLfUqWSsjTpsO3dvShUjQ@mail.gmail.com>
 <20130325170257.GA24554@linux.vnet.ibm.com>
 <CAFTL4hwRoMGpS823ZD51sw=+AX7_GfroPqz=EspNAtkA86YZ_g@mail.gmail.com>
 <20130325171844.GA3637@linux.vnet.ibm.com>
 <CAFTL4hxobFT_X_HMVOwB5WDHNR-YVkBjj0c2DMECPKy9goB3LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hxobFT_X_HMVOwB5WDHNR-YVkBjj0c2DMECPKy9goB3LQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032701-4834-0000-0000-0000052632CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 12:48:20AM +0100, Frederic Weisbecker wrote:
> 2013/3/25 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> > On Mon, Mar 25, 2013 at 06:12:12PM +0100, Frederic Weisbecker wrote:
> >> 2013/3/25 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> >> > On Sun, Mar 24, 2013 at 03:46:40PM +0100, Frederic Weisbecker wrote:
> >> >> 2013/3/24 Ingo Molnar <mingo@kernel.org>:
> >> >> >
> >> >> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >> >> >
> >> >> >> Hi Ingo,
> >> >> >>
> >> >> >> This settles the initial ground to start a special full dynticks tree in -tip
> >> >> >> that we can iterate incrementally to accelerate the development.
> >> >> >> It is based on tip:sched/core.
> >> >> >>
> >> >> >> I tried to rearrange a bit the naming. We are probably not yet done with
> >> >> >> that but I guess we can fix it along with the rest.
> >> >> >>
> >> >> >> Please pull from:
> >> >> >>
> >> >> >> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> >> >> >>       full-dynticks-for-mingo
> >> >> >>
> >> >> >> Changes on these commits since they were part of 3.9-rc1-nohz1:
> >> >> >>
> >> >> >> * Force a timekeeping CPU over the full dynticks range
> >> >> >> * Rename CONFIG_NO_HZ_FULL to CONFIG_NO_HZ_EXTENDED
> >> >> >> * Following *_nohz_extended_* APIs renames
> >> >> >> * Handle CPU hotplug for timekeeping
> >> >> >> * Rename full_nohz= kernel parameter to nohz_extended=
> >> >> >
> >> >> > Note that boot parameters suck for pretty much any purpose but quirks -
> >> >> > please also add a (default off!) Kconfig option to easily enable
> >> >> > nohz_extended for all CPUs.
> >> >> >
> >> >> > That way I will be able to test it automatically via randconfig and such.
> >> >>
> >> >> Sure, I'm adding such an option.
> >> >
> >> > Hmmm...  This would be an option to make all but one CPU an adaptive-ticks
> >> > CPU, right?  If so, this leads to the question of whether I should add a
> >> > matching no-CBs Kconfig option.  My guess is "no", because the existing
> >> > CONFIG_RCU_NOCB_CPU_ALL should work just fine -- there would be a CPU that
> >> > was not an adaptive-ticks CPU, but does have its RCU callbacks offloaded.
> >> >
> >> > Or am I missing something here?
> >>
> >> No that looks right. Now I wonder if I should select
> >> CONFIG_RCU_NOCB_CPU_ALL at the same time. Probably.
> >
> > Sounds like a good initial position to me.  If it somehow causes problems,
> > we can always change it later.
> 
> Ah "rcu: Provide compile-time control for no-CBs CPUs" is not yet in
> -tip so I can't do that yet. Ok for now I'm going to add
> CONFIG_NO_HZ_EXTENDED_ALL and will select the matching RCU config once
> it's visible upstream.

Good point...  I expect to be sending a pull request in a day or two.

							Thanx, Paul

