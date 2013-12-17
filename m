Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab3LQM72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 07:59:28 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:49220 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab3LQM71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 07:59:27 -0500
Message-ID: <52B04AAD.3070403@gmail.com>
Date: Tue, 17 Dec 2013 07:59:25 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, John <da_audiophile@yahoo.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david.heidelberger@ixit.cz" <david.heidelberger@ixit.cz>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] expand micro-optimizations in kernel to newer model CPUs
References: <1386518000.90452.YahooMailNeo@web140004.mail.bf1.yahoo.com> <864985fbeb1d8148439e25ec01f47a67@ixit.cz> <52AAFF89.5080509@gmail.com> <1387051250.86178.YahooMailNeo@web140005.mail.bf1.yahoo.com> <ce679ca5-bf83-4c2a-9234-859cc7a4206b@email.android.com> <1387057337.97000.YahooMailNeo@web140004.mail.bf1.yahoo.com> <52ACECC4.208@zytor.com> <1387108841.76039.YahooMailNeo@web140006.mail.bf1.yahoo.com> <20131216142816.GA6350@gmail.com>
In-Reply-To: <20131216142816.GA6350@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-12-16 09:28, Ingo Molnar wrote:
> 
> * John <da_audiophile@yahoo.com> wrote:
> 
>> This patch has been tested on and known to work with kernel versions 
>> from 3.2 up to the latest git version (pulled on 12/14/2013).
>>
>> This patch will expand the number of microarchitectures to include 
>> new processors including: AMD K10-family, AMD Family 10h 
>> (Barcelona), AMD Family 14h (Bobcat), AMD Family 15h (Bulldozer), 
>> AMD Family 15h (Piledriver), AMD Family 16h (Jaguar), Intel 1st Gen 
>> Core i3/i5/i7 (Nehalem), Intel 2nd Gen Core i3/i5/i7 (Sandybridge), 
>> Intel 3rd Gen Core i3/i5/i7 (Ivybridge), and Intel 4th Gen Core 
>> i3/i5/i7 (Haswell). It also offers the compiler the 'native' flag.
> 
> So let me (again) follow Linus's general advice to say 'no' to patches 
> more forcefully, so that people don't go down potential dead ends for 
> too long time without strong negative feedback from upstream. :-)
> 
> This series does not look convincing enough to me. My complaints:
> 
>  - I'm not convinced the numbers are right. Rarely are such tiny
>    compiler optimizations measureable in integer-only kernel code ...
>    Too noisy benchmarks were used. More precise measurements done by
>    Boris showed no statistically significant improvements:
> 
>       http://marc.info/?l=linux-kernel&m=138081947417204
> 
>  - Modern CPUs have inherently high noise: boot-to-boot variance is 
>    often higher on modern systems with large caches than the speedup 
>    claimed by optimization options ...
> 
>  - I'm not convinced the whole concept is long term maintainable to 
>    begin with. When Linux on x86 began we used to have just 2-3 major 
>    CPU models to care about, so it made sense. That count grew rapidly 
>    and today we havedozens (if not hundreds) of models, families and
>    variants and our 'optimization' options are just one big 
>    fragmented, rarely tested mess with essentially random compiler 
>    flags thrown at it.
> 
>  - The cost of getting optimizations wrong by going away from sane 
>    defaults is probably high as well: see the case where Boris
>    measured a regression from an 'optimization' option.
> 
>  - GCC itself changes as well, so a seemingly good but rarely used
>    optimization flag could get out of sync and hurt performance on 
>    rarer, rarely tested CPU models. It's sometimes safer to go with 
>    the herd and use good, sensible defaults in most situations.
> 
> For those reasons I think we should just strip out all the current 
> outdated micro-management of models/ and go to more logical, much 
> broader optimization categories such as:
> 
>    "Optimize for modern Intel CPUs"
>    "Optimize for modern AMD CPUs"
> 
> because most of the day to day measurement and testing work is 
> concentrated on modern CPUs.
> 
> We might not even want to make a vendor differentiation there and just 
> do a generic:
> 
>    "Optimize for modern x86 CPUs"
>    
> With perhaps a "workarounds" sub-option opening up:
> 
>    "Optimization workarounds" [x]
>       "Intel Atom CPUs" [x]
> 
> Because occasionally there will be oddball yet common CPUs that need 
> starkly different optimizations/workarounds. Naming it a 'workaround' 
> creates an incentive to return such platforms to the common options.
> 
> I.e. handle and document the exceptions, and try to minimize them - 
> instead of trying to enumerate every CPU model which is IMHO a losing 
> game ...
> 
> [ If that is done then we also need much more statistically convincing
>   methods to test how well a kernel's compiler options perform.

As an alternative to removing them altogether, why not make options
other than CONFIG_GENERICCPU and the big exceptions (such as Atom CPUs)
 depend on CONFIG_EXPERT and mark the kernel as tainted.  This way
people can still use the optimizations, and the developers have recourse
for dismissing bugs that are probably caused by them.

As far as I see things, people who are using these options fall into
four general categories:
1. People running HPC clusters.
2. People using embedded systems.
3. Power users (who actually do testing to determine how worthwhile the
optimization is).
4. Idiots who think that building a custom kernel is cool, but don't
have the ability to deal with potential fallout.

People in the first category will usually have sufficient resources to
hire someone to fix problems caused by the optimizations.  People in the
second and third categories usually know what they are doing and can
deal with any problems that may arise. People in the fourth category
shouldn't be using a custom kernel build to begin with.

In general, following the above suggestion, people in the first three
groups will likely be happy to rebuild the kernel with CONFIG_GENERICCPU
instead of system specific optimizations to try and reproduce a bug.

I understand wanting to make it harder for people to shoot themselves,
but there are still a multitude of legitimate uses for these options,
and I would personally think that a providing a standardized methodology
for optimizing the kernel is generally preferable to making everyone who
wants to do so hack things together.
