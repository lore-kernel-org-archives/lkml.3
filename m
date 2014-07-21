Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbaGUWIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 18:08:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45401 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbaGUWIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 18:08:31 -0400
Date: Tue, 22 Jul 2014 00:08:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] x86, TSC: Add a software TSC offset
Message-ID: <20140721220825.GE11555@pd.tnic>
References: <20140719130602.GA5101@pd.tnic>
 <53CD6B50.5010404@mit.edu>
 <20140721213534.GB11555@pd.tnic>
 <CALCETrW91Q=ivYRVFb0WKXgHQO7O+x_HHDy67e90TU6Bte_ecg@mail.gmail.com>
 <20140721215225.GD11555@pd.tnic>
 <CALCETrX1LbZAiPH4x2Uby_cUUj2wgN92wc+5wvf-B3_9XdObWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrX1LbZAiPH4x2Uby_cUUj2wgN92wc+5wvf-B3_9XdObWQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 02:56:49PM -0700, Andy Lutomirski wrote:
> I expect that users of __vdso_clock_gettime (e.g. glibc) will get the
> correct time :)  They use vread_tsc, and they can't use
> preempt_disable, because they're in userspace.  They also can't
> directly access per-cpu variables.
> 
> Turning off vdso tsc support on these machines would be an option.

Right, this is what I was going to propose to tglx on IRC. Or we can try
to come up with something working for the vdso too, say RDTSCP :-)

But that still won't work as it needs the per-cpu variables. So I guess
vdso loses...

> I actually own one of these systems.  It's a Sandy Bridge Core-i7
> Extreme or something like that.

Ha, cool, so I've got my tester! :-)

> I wonder if that's a bug in get_cycles.
> 
> The basic issue is that rdtsc is not ordered with respect to nearby
> loads, so it's fairly easy to see it behaving non-monotonically across
> CPUs.  rdtscp is ordered, but it's a little slower.

Yah, that I know. But I don't see get_cycles() having the barriers. So
it might be a bug. We can certainly try to "fix" it and see what happens
:-)

diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 94605c0e9cee..ad7d5e449c0b 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -27,7 +27,9 @@ static inline cycles_t get_cycles(void)
 	if (!cpu_has_tsc)
 		return 0;
 #endif
+	rdtsc_barrier();
 	rdtscll(ret);
+	rdtsc_barrier();
 
 	return ret;
 }

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
