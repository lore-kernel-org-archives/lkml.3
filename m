Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbaB1HWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 02:22:50 -0500
Received: from www84.your-server.de ([213.133.104.84]:40417 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaB1HWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 02:22:49 -0500
Message-ID: <1393572124.1019.3.camel@wall-e.seibold.net>
Subject: Re: Final: Add 32 bit VDSO time function support
From: Stefani Seibold <stefani@seibold.net>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Date: Fri, 28 Feb 2014 08:22:04 +0100
In-Reply-To: <CALCETrW_PHbDzn2S3NyGTSk4yqYjnpJbStCuLc_yBGdfspfFCA@mail.gmail.com>
References: <1393443298.1917.5.camel@wall-e.seibold.net>
	 <20140226204524.GA1598@kroah.com>
	 <CALCETrU+u3GMK-GaTk4gbAjyMbpQY15qNC4D9q9h2a26YfsLwA@mail.gmail.com>
	 <CALCETrW_PHbDzn2S3NyGTSk4yqYjnpJbStCuLc_yBGdfspfFCA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 26.02.2014, 16:55 -0800 schrieb Andy Lutomirski:
> Um.  This code doesn't work.  I'll send a patch.  I can't speak
> towards how well it compiles in different configurations.
> 
> I can't speak towards how well it compiles in different
> configurations.  Also, vdso_fallback_gettime needs .cfi annotations, I
> think.  I could probably dredge the required incantations from
> somewhere, but someone else may know how to do it.
> 
> Once I patch it to work, your 32-bit code is considerably faster than
> the 64-bit case.  It's enough faster that I suspect a bug.  Dumping
> the in-memory shows some rather suspicious nops before the rdtsc
> instruction.  I suspect that you've forgotten to run the 32-bit vdso
> through the alternatives code.  The is a nasty bug: it will appear to
> work, but you'll see non-monotonic times on some SMP systems.
> 

I didn't know this. My basic test case is a KVM which defaults to 1 cpu.
Thanks for discovering the issue.

> In my configuration, with your patches, I get (64-bit):
> 
> CLOCK_REALTIME:
> 100000000 loops in 2.07105s = 20.71 nsec / loop
> 100000000 loops in 2.06874s = 20.69 nsec / loop
> 100000000 loops in 2.29415s = 22.94 nsec / loop
> CLOCK_MONOTONIC:
> 100000000 loops in 2.06526s = 20.65 nsec / loop
> 100000000 loops in 2.10134s = 21.01 nsec / loop
> 100000000 loops in 2.10615s = 21.06 nsec / loop
> CLOCK_REALTIME_COARSE:
> 100000000 loops in 0.37440s = 3.74 nsec / loop
> [  503.011756] perf samples too long (2550 > 2500), lowering
> kernel.perf_event_max_sample_rate to 50000
> 100000000 loops in 0.37399s = 3.74 nsec / loop
> 100000000 loops in 0.38445s = 3.84 nsec / loop
> CLOCK_MONOTONIC_COARSE:
> 100000000 loops in 0.40238s = 4.02 nsec / loop
> 100000000 loops in 0.40939s = 4.09 nsec / loop
> 100000000 loops in 0.41152s = 4.12 nsec / loop
> 
> Without the patches, I get:
> 
> CLOCK_REALTIME:
> 100000000 loops in 2.07348s = 20.73 nsec / loop
> 100000000 loops in 2.07346s = 20.73 nsec / loop
> 100000000 loops in 2.06922s = 20.69 nsec / loop
> CLOCK_MONOTONIC:
> 100000000 loops in 1.98955s = 19.90 nsec / loop
> 100000000 loops in 1.98895s = 19.89 nsec / loop
> 100000000 loops in 1.98881s = 19.89 nsec / loop
> CLOCK_REALTIME_COARSE:
> 100000000 loops in 0.37462s = 3.75 nsec / loop
> 100000000 loops in 0.37460s = 3.75 nsec / loop
> 100000000 loops in 0.37428s = 3.74 nsec / loop
> CLOCK_MONOTONIC_COARSE:
> 100000000 loops in 0.40081s = 4.01 nsec / loop
> 100000000 loops in 0.39834s = 3.98 nsec / loop
> [   36.706696] perf samples too long (2565 > 2500), lowering
> kernel.perf_event_max_sample_rate to 50000
> 100000000 loops in 0.39949s = 3.99 nsec / loop
> 
> This looks like a wash, except for CLOCK_MONOTONIC, which got a bit
> slower.  I'll send a followup patch once the bugs are fixed that
> improves the timings to:
> 
> CLOCK_REALTIME:
> 100000000 loops in 2.08621s = 20.86 nsec / loop
> 100000000 loops in 2.07122s = 20.71 nsec / loop
> 100000000 loops in 2.07089s = 20.71 nsec / loop
> CLOCK_MONOTONIC:
> 100000000 loops in 2.06831s = 20.68 nsec / loop
> 100000000 loops in 2.06862s = 20.69 nsec / loop
> 100000000 loops in 2.06195s = 20.62 nsec / loop
> CLOCK_REALTIME_COARSE:
> 100000000 loops in 0.37274s = 3.73 nsec / loop
> 100000000 loops in 0.37247s = 3.72 nsec / loop
> 100000000 loops in 0.37234s = 3.72 nsec / loop
> CLOCK_MONOTONIC_COARSE:
> 100000000 loops in 0.39944s = 3.99 nsec / loop
> 100000000 loops in 0.39940s = 3.99 nsec / loop
> 100000000 loops in 0.40054s = 4.01 nsec / loop
> 
> I'm not quite sure that causes the remaining loss.
> 
> Test code is here:
> 
> https://gitorious.org/linux-test-utils/linux-clock-tests


