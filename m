Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab3LPO2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 09:28:21 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52938 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3LPO2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 09:28:20 -0500
Date: Mon, 16 Dec 2013 15:28:16 +0100
From: Ingo Molnar <mingo@kernel.org>
To: John <da_audiophile@yahoo.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david.heidelberger@ixit.cz" <david.heidelberger@ixit.cz>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] expand micro-optimizations in kernel to newer model CPUs
Message-ID: <20131216142816.GA6350@gmail.com>
References: <1386518000.90452.YahooMailNeo@web140004.mail.bf1.yahoo.com>
 <864985fbeb1d8148439e25ec01f47a67@ixit.cz>
 <52AAFF89.5080509@gmail.com>
 <1387051250.86178.YahooMailNeo@web140005.mail.bf1.yahoo.com>
 <ce679ca5-bf83-4c2a-9234-859cc7a4206b@email.android.com>
 <1387057337.97000.YahooMailNeo@web140004.mail.bf1.yahoo.com>
 <52ACECC4.208@zytor.com>
 <1387108841.76039.YahooMailNeo@web140006.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387108841.76039.YahooMailNeo@web140006.mail.bf1.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John <da_audiophile@yahoo.com> wrote:

> This patch has been tested on and known to work with kernel versions 
> from 3.2 up to the latest git version (pulled on 12/14/2013).
>
> This patch will expand the number of microarchitectures to include 
> new processors including: AMD K10-family, AMD Family 10h 
> (Barcelona), AMD Family 14h (Bobcat), AMD Family 15h (Bulldozer), 
> AMD Family 15h (Piledriver), AMD Family 16h (Jaguar), Intel 1st Gen 
> Core i3/i5/i7 (Nehalem), Intel 2nd Gen Core i3/i5/i7 (Sandybridge), 
> Intel 3rd Gen Core i3/i5/i7 (Ivybridge), and Intel 4th Gen Core 
> i3/i5/i7 (Haswell). It also offers the compiler the 'native' flag.

So let me (again) follow Linus's general advice to say 'no' to patches 
more forcefully, so that people don't go down potential dead ends for 
too long time without strong negative feedback from upstream. :-)

This series does not look convincing enough to me. My complaints:

 - I'm not convinced the numbers are right. Rarely are such tiny
   compiler optimizations measureable in integer-only kernel code ...
   Too noisy benchmarks were used. More precise measurements done by
   Boris showed no statistically significant improvements:

      http://marc.info/?l=linux-kernel&m=138081947417204

 - Modern CPUs have inherently high noise: boot-to-boot variance is 
   often higher on modern systems with large caches than the speedup 
   claimed by optimization options ...

 - I'm not convinced the whole concept is long term maintainable to 
   begin with. When Linux on x86 began we used to have just 2-3 major 
   CPU models to care about, so it made sense. That count grew rapidly 
   and today we havedozens (if not hundreds) of models, families and
   variants and our 'optimization' options are just one big 
   fragmented, rarely tested mess with essentially random compiler 
   flags thrown at it.

 - The cost of getting optimizations wrong by going away from sane 
   defaults is probably high as well: see the case where Boris
   measured a regression from an 'optimization' option.

 - GCC itself changes as well, so a seemingly good but rarely used
   optimization flag could get out of sync and hurt performance on 
   rarer, rarely tested CPU models. It's sometimes safer to go with 
   the herd and use good, sensible defaults in most situations.

For those reasons I think we should just strip out all the current 
outdated micro-management of models/ and go to more logical, much 
broader optimization categories such as:

   "Optimize for modern Intel CPUs"
   "Optimize for modern AMD CPUs"

because most of the day to day measurement and testing work is 
concentrated on modern CPUs.

We might not even want to make a vendor differentiation there and just 
do a generic:

   "Optimize for modern x86 CPUs"
   
With perhaps a "workarounds" sub-option opening up:

   "Optimization workarounds" [x]
      "Intel Atom CPUs" [x]

Because occasionally there will be oddball yet common CPUs that need 
starkly different optimizations/workarounds. Naming it a 'workaround' 
creates an incentive to return such platforms to the common options.

I.e. handle and document the exceptions, and try to minimize them - 
instead of trying to enumerate every CPU model which is IMHO a losing 
game ...

[ If that is done then we also need much more statistically convincing
  methods to test how well a kernel's compiler options perform.

Thanks,

        Ingo
