Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaBQKEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 05:04:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbaBQKEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 05:04:07 -0500
Date: Mon, 17 Feb 2014 11:04:02 +0100
From: Petr Tesarik <ptesarik@suse.cz>
To: "Jan Beulich" <JBeulich@suse.com>
Cc: "Borislav Petkov" <bp@alien8.de>, <x86@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Issue a warning if number of present CPUs >
 maxcpus and CONFIG_HOTPLUG=n
Message-ID: <20140217110402.7e4fc211@hananiah.suse.cz>
In-Reply-To: <5301D7AA020000780011CBE9@nat28.tlf.novell.com>
References: <20140215150223.63bb52fb@hananiah.suse.cz>
	<5301D7AA020000780011CBE9@nat28.tlf.novell.com>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On Mon, 17 Feb 2014 08:34:34 +0000
"Jan Beulich" <JBeulich@suse.com> wrote:

> >>> On 15.02.14 at 15:02, Petr Tesarik <ptesarik@suse.cz> wrote:
> > --- a/arch/x86/kernel/smpboot.c
> > +++ b/arch/x86/kernel/smpboot.c
> > @@ -1226,9 +1226,6 @@ __init void prefill_possible_map(void)
> >  #ifdef CONFIG_HOTPLUG_CPU
> >  		if (setup_max_cpus)
> >  			possible += disabled_cpus;
> > -#else
> > -		if (possible > i)
> > -			possible = i;
> >  #endif
> >  	} else
> >  		possible = setup_possible_cpus;
> 
> In between here total_cpus is being set, which now will get a
> larger value if !HOTPLUG_CPU. Did you check that this has no
> unintended side effect? And even if you did, it would still feel
> more safe if you moved that line down after the capping point
> below.

This is a non-issue. total_cpus is initialized to
max(possible, num_processors + disabled_cpus).
possible is initialized to num_processors just before the conditional
block, and in !HOTPLUG case, it is not modified afterwards. So:

BEFORE THE CHANGE:
The value of possible was modified only if it was larger than
min(setup_max_cpus, 1). In turn, it could never be bigger than
num_processors + disabled_cpus.

Result: total_cpus = num_processors + disabled_cpus.

AFTER THE CHANGE:
The value of possible is not modified, i.e. it remains equal to
num_processors. disabled_cpus cannot be negative.

Result: total_cpus = num_processors + disabled_cpus

In fact, you can only increase the value of total_cpus by passing
a nr_possible parameter to the kernel which is greater than the
total number of CPUs detected through system tables (MPTABLES, ACPI,
SFI etc.).

> Similarly (but perhaps less important, albeit possibly slightly
> confusing) the NR_CPUS related warning could now get issued
> along with the warning below (when possible > nr_cpu_ids > i).
> Hence that may better be moved down too (or then in effect
> the if() block you modify below would get moved up). I realize
> that two warning instead of just one would also be possible
> without any change, so you're not really introducing some
> entirely new inconsistency here...

Well, if the user passes both nr_cpus and maxcpus parameters to the
kernel, I think it's fair to issue two warnings. But if everyone agrees
that only the maxcpus warning should be printed in that case, I can
send a version 2 of my patch.

Petr Tesarik

> > @@ -1246,7 +1243,7 @@ __init void prefill_possible_map(void)
> >  	if (!setup_max_cpus)
> >  #endif
> >  	if (possible > i) {
> > -		pr_warn("%d Processors exceeds max_cpus limit of %u\n",
> > +		pr_warn("%d Processors exceeds maxcpus limit of %u\n",
> >  			possible, setup_max_cpus);
> >  		possible = i;
> >  	}
> > -- 
> > 1.8.4.5
> 
> 
> 

