Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab3C3JKn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 05:10:43 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:42171 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab3C3JKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 05:10:41 -0400
Date: Sat, 30 Mar 2013 10:10:37 +0100
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
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/4] nohz: New option to force all CPUs in full dynticks
 range
Message-ID: <20130330091037.GA31743@gmail.com>
References: <1364398359-21990-1-git-send-email-fweisbec@gmail.com>
 <1364398359-21990-5-git-send-email-fweisbec@gmail.com>
 <20130328074507.GC24433@gmail.com>
 <CAFTL4hzQfodVP4O+nir1XwQ2QkUUqrfr_dBpWL0635f0u4oRBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hzQfodVP4O+nir1XwQ2QkUUqrfr_dBpWL0635f0u4oRBA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> 2013/3/28 Ingo Molnar <mingo@kernel.org>:
> >
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >
> >> +config NO_HZ_EXTENDED_ALL
> >> +       bool "Full dynticks system on all CPUs"
> >> +       depends on NO_HZ_EXTENDED
> >> +       help
> >> +      Force all CPUs to be full dynticks. The range specified in the
> >> +      nohz_extended boot option will then be ignored.
> >> +
> >> +      Note the boot CPU will still be kept outside the range to handle
> >> +      the timekeeping duty.
> >
> > In most cases this will be the first time users doing 'make oldconfig'
> > will hear about this feature, so I'd not mention noh_extended in such a
> > primary way at all.
> >
> > Instead I'd suggest to explain, in a few simple sentences, what 'full
> > dynticks' _is_. Then maybe mention this near the end of the next:
> >
> >    ( Alternatively this feature can also be enabled via the
> >      nohz_extended=<cpulist> boot option. If this kernel config option is
> >      enabled then the nohz_extended boot parameter is ignored. )
> 
> Ok. Hmm, concerning what full dynticks is, those who run make oldconfig 
> should have passed through CONFIG_NO_HZ_EXTENDED help first so they 
> should know what this is all about, right? I can improve its help text 
> if you think something need more details. Or you think I should add some 
> more reminder in the new config? Also nohz_extended is not mentioned 
> there so I indeed need to fix that. And then do a reminder in the new 
> config. I'll reuse a bit your above sentence.

Kconfig option + boot parameter, or kconfig option + kconfig option, just 
to get a feature to activate, is usability madness.

I think we need _one_ config knob to configure, which, if selected, 
activates all of this feature. Preferably this would be similar to the 
preempt options, like CONFIG_PREEMPT is the most advanced preemption 
model:

          ( ) No Forced Preemption (Server)
          (X) Voluntary Kernel Preemption (Desktop)
          ( ) Preemptible Kernel (Low-Latency Desktop)

NO_HZ_EXTENDED or NO_HZ_FULL could be a third variant to:

          ( ) Periodic Timer Ticks
          (X) Tickless Idle (Dynamic Ticks)
          ( ) Full Tickless (Extended Dynamic Ticks)

or so - instead of this somewhat confusing hierarchy of config and boot 
options. Good help text would explain the differences between then.

Internally, the 'Tickless Idle' option would cause NO_HZ to be set, while 
'Full Tickless' would also set NO_HZ, but would also set NO_HZ_EXTENDED.

Furthermore, right now it's hard to enable NO_HZ_EXTENDED, because it 
depends on so many other options. The option is just hidden unless the 
user knows about it and enables 5 other kernel options. Instead the tick 
mode selected should enable (select) any required features - it should 
drive things, not the other way around.

(After all that is done, the boot option is something that augments this 
existing, kconfig driven mechanism.)

Thanks,

	Ingo
