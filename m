Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972AbaGSN3G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:29:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47193 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070AbaGSN3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:29:03 -0400
Date: Sat, 19 Jul 2014 15:28:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] x86, TSC: Add a software TSC offset
Message-ID: <20140719132859.GA24864@pd.tnic>
References: <20140719130602.GA5101@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140719130602.GA5101@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 03:06:02PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> There are machines which do have stable and always-running TSCs but the
> last get started at different points in time by the platform, causing
> the TSCs to have a small constant diff.
> 
> It has been tried a couple of times to resync those during that
> sync check but the procedure is error prone and flaky, and not 100%
> successful.
> 
> So, instead of doing that, let's not touch the TSCs at all but save a
> per-CPU TSC offset which we add to the TSC value we've read from the
> Time-Stamp Counter. The hope is thus to still salvage the TSC on those
> machines.
> 
> For that to work, we need to populate the TSC AUX MSR with the core ID
> prior to doing the TSC sync check so that RDTSCP can give us the correct
> core number and we can add the offset atomically. And yes, we need a
> X86_FEATURE_RDTSCP CPU for the whole deal to work. Older ones simply
> lose.
> 
> See also comment above tsc_sync.c::compute_tsc_offset() for more details.

And here's how it looks like: So I'm injecting a TSC diff locally because I
don't have a machine which has that problem, Peter has a WSM for that.

So here's the case where the target CPU has started its TSC earlier than
the source CPU:

[    0.264966] x86: Booting SMP configuration:
[    0.265151] .... node  #0, CPUs:      #1
[    0.281610] 1, tsc1: 37576107984
[    0.281611] updating with 600000

This is the error injection into the TSC of CPU1 with +600K cycles.

[    0.281990] 1, tsc2: 37576716684

...

[    0.284259] TSCs of [CPU#0 -> CPU#1] 599193 cycles out of sync, saving offset.
[    0.284756] CPU1, saved offset: -599193

We save a negative offset, and we also see the time it took us to do a
RMW on the TSC :-)

Then we run the sync test again, this time we read the TSC and add the
negative offset.

[    0.287156] TSC synchronization [CPU#0 -> CPU#1]: passed
[    0.287385] x86: Booted up 1 node, 2 CPUs



And now the case where the target CPU starts later than the source (I'd
expect this to be the common case):

[    0.264850] x86: Booting SMP configuration:
[    0.265036] .... node  #0, CPUs:      #1
[    0.281476] identify_cpu: Setting TSC_AUX MSR, cpu 1
[    0.281495] 1, tsc1: 56268738505
[    0.281497] updating with -12345678

injection

[    0.273772] 1, tsc2: 56256402112

...

[    0.284183] TSCs of [CPU#0 -> CPU#1] 12345363 cycles out of sync, saving offset.
[    0.276608] CPU1, saved offset: 12345363
[    0.287057] TSC synchronization [CPU#0 -> CPU#1]: passed
[    0.287288] x86: Booted up 1 node, 2 CPUs



We also state that we have this "workaround" enabled in /proc/cpuinfo:

processor       : 1

...

flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid aperfmperf pni monitor ssse3 cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch ibs skinit wdt arat hw_pstate npt lbrv svm_lock nrip_save pausefilter
bugs            : fxsave_leak tsc_offset
			      ^^^^^^^^^^

bogomips        : 3193.18
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate



The whole deal needs more testing now.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
