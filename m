Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750866Ab3IFRa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 13:30:58 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:33952 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3IFRaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 13:30:55 -0400
Date: Fri, 6 Sep 2013 10:30:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        josh@joshtriplett.org, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>, edumazet@google.com,
        darren@dvhart.com,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        sbw@mit.edu, Linux-Arch <linux-arch@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH tip/core/rcu 8/9] nohz_full: Add full-system-idle state
 machine
Message-ID: <20130906173047.GT3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130820024700.GA31075@linux.vnet.ibm.com>
 <1376966841-31774-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1376966841-31774-8-git-send-email-paulmck@linux.vnet.ibm.com>
 <CAMuHMdWtZAD3G_miFOT9DPZpfTO3nJ9J4aG_zvHV_6eVf2jdQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWtZAD3G_miFOT9DPZpfTO3nJ9J4aG_zvHV_6eVf2jdQg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090617-8236-0000-0000-0000017FF934
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 10:08:22AM +0200, Geert Uytterhoeven wrote:
> On Tue, Aug 20, 2013 at 4:47 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > --- a/kernel/time/Kconfig
> > +++ b/kernel/time/Kconfig
> > @@ -157,6 +157,33 @@ config NO_HZ_FULL_SYSIDLE
> >
> >          Say N if you are unsure.
> >
> > +config NO_HZ_FULL_SYSIDLE_SMALL
> > +       int "Number of CPUs above which large-system approach is used"
> > +       depends on NO_HZ_FULL_SYSIDLE
> > +       range 1 NR_CPUS
> 
> This causes "kernel/time/Kconfig:162:warning: range is invalid" on m68k and
> all other architectures that do not support SMP.
> 
> How to reproduce:
>     make ARCH=m68k defconfig

OK, this does complain, but seems to give a reasonable .config file.
(From what I can tell.)  It would clearly be good to get rid of the
complaint.

> Furthermore, it seems only hexagon, metag, mips, and x86 set NR_CPUS to 1
> if !SMP. On other architectures, NR_CPUS is not defined and presumed to be 0.

Would it make sense to require that NR_CPUS=1 for !SMP?

> Hence in non-interactive configs (e.g. "make defconfig"),
> NO_HZ_FULL_SYSIDLE_SMALL will end up as 0.
> In interactive configs (e.g. "make oldconfig") Kconfig suggest "0" as
> the default,
> but refuses to accept it as it doesn't fall within the range 1..0.
> 
> How to reproduce:
>     Remove the "depends on NO_HZ_FULL_SYSIDLE"
>     make ARCH=powerpc mpc83xx_defconfig
>     grep NO_HZ_FULL_SYSIDLE_SMALL .config
>     -> CONFIG_NO_HZ_FULL_SYSIDLE_SMALL=0
>     sed 's/CONFIG_NO_HZ_FULL_SYSIDLE_SMALL=0//g' -i .config
>     make ARCH=powerpc oldconfig
>     -> no value is accepted

If it turns out that there is some reason by NR_CPUS=1 is impossible,
there are a few things that I could do:

I could just leave the range off, which would allow people to give
nonsense values.  This would be harmless in the code, for example,
a negative value would simply disable small-system handling, while
a too-large value would similarly disable large-system handling.
Might be a bit obnoxious for the guy who typoed and then wasted a
kernel build/boot/test cycle, but it is an option.

I could use a small fixed range (say from 1 to 64), which would
provide at least some checking.  In the unlikely event that someone
really wants more than 64 CPUs handled with small-system handling,
we could revisit at that point.

I tried creating a NR_CPUS_REALLY as follows:

config NR_CPUS_REALLY
	int "Fixed version of NR_CPUS"
	default NR_CPUS if NR_CPUS
	default 1 if !NR_CPUS

But this still gave a warning on the first "default" even though it
was not in effect.  I also tried using Kconfig "if":

if SMP
config NR_CPUS_REALLY
	int "Fixed version of NR_CPUS"
	default NR_CPUS
endif
if !SMP
config NR_CPUS_REALLY
	int "Fixed version of NR_CPUS"
	default 1 if !SMP
endif

However, Kconfig complained about the use of NR_CPUS even though this
was under an "if" whose condition was not set.  Perhaps someone with
better Kconfig-fu than I have can come up with something.

Defining NR_CPUS=1 if !SMP is looking pretty good to me just now.
This would probably have other benefits -- I cannot be the only
person who ever wanted this.  ;-)

							Thanx, Paul

