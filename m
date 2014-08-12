Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbaHLPaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 11:30:46 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:40240 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbaHLPap convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 11:30:45 -0400
Message-ID: <53EA3320.90908@linaro.org>
Date: Tue, 12 Aug 2014 08:30:40 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        LKML <linux-kernel@vger.kernel.org>, peterz@infradead.org,
        tglx@linutronix.de, sfr@canb.auug.org.au, linuxppc-dev@ozlabs.org,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [tip:timers/core] timekeeping: Fixup typo in update_vsyscall_old
 definition
References: <1406349439-11785-1-git-send-email-john.stultz@linaro.org>	 <tip-953dec21aed4038464fec02f96a2f1b8701a5bce@git.kernel.org> <1407730744.4508.67.camel@pasglop>
In-Reply-To: <1407730744.4508.67.camel@pasglop>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2014 09:19 PM, Benjamin Herrenschmidt wrote:
> On Wed, 2014-07-30 at 00:31 -0700, tip-bot for John Stultz wrote:
>> Commit-ID:  953dec21aed4038464fec02f96a2f1b8701a5bce
>> Gitweb:     http://git.kernel.org/tip/953dec21aed4038464fec02f96a2f1b8701a5bce
>> Author:     John Stultz <john.stultz@linaro.org>
>> AuthorDate: Fri, 25 Jul 2014 21:37:19 -0700
>> Committer:  Thomas Gleixner <tglx@linutronix.de>
>> CommitDate: Wed, 30 Jul 2014 09:26:25 +0200
>>
>> timekeeping: Fixup typo in update_vsyscall_old definition
>>
>> In commit 4a0e637738f0 ("clocksource: Get rid of cycle_last"),
>> currently in the -tip tree, there was a small typo where cycles_t
>> was used intstead of cycle_t. This broke ppc64 builds.
> There's another bug in there... You fix timespec vs. timespec64 for the
> first argument of update_vsyscall_old but not the second one ...
> (wall_to_monotonic).
>
> Also, in e2dff1ec0 you claim this is "minor", you seem to forget that
> arch/powerpc also deals with 32-bit kernels which use the same time
> keeping code, so we have a pretty serious regressions here...
Yikes. My apologies. I had missed that issue and had forgotten ppc32 has
the vsyscall support as well.

Thanks for pointing it out. I'll send a fix here shortly (though I only
have the ppc64le toolchain handy, so forgive me if its not quite right).


> BTW. Is there some documentation you can point me to to figure out what
> replace that "_OLD" stuff so we can update to whatever is "new" ?

So there's not exactly documentation, but the idea is rather then doing:

nsecs +  (mult*(now - cycle_last) >>shift);

We're preserving the sub-nanosecond precision, and doing:

(shifted_nsecs + mult*(now-cycle_last)) >> shift

This avoids the rounding up 1ns every tick, which we did to avoid errors
from truncating the precision.

I think the hard part for ppc, is if I recall, ppc's vsyscall exports
the xsec unit, which less granular then nanoseconds, so it had its own
version of the same precision truncation issues. I recall Paul working
on that, and I thought his solution was to reduce the multiplier by one
so the inter-tick time was slightly slower, then the tick update would
catch up causing a slight stair-step, which isn't ideal but is better
then the inconsistencies that came out of not-handling the precision
properly. That said, skimming the ppc code, I don't see that logic right
off, and have a fuzzy memory that maybe that solution was RHEL5 specific
or something like that.

thanks
-john






