Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab3JQPpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 11:45:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:16033 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034Ab3JQPph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 11:45:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,514,1378882800"; 
   d="scan'208";a="376183015"
Message-ID: <52600608.2010704@linux.intel.com>
Date: Thu, 17 Oct 2013 08:45:12 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux@roeck-us.net,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: unify copy_from_user() checking
References: <525E964402000078000FB70C@nat28.tlf.novell.com> <525E9BF7.7020706@linux.intel.com> <525EC6C402000078000FB895@nat28.tlf.novell.com> <525EC73E.3060204@linux.intel.com> <525FCDD702000078000FBBF5@nat28.tlf.novell.com>
In-Reply-To: <525FCDD702000078000FBBF5@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2013 2:45 AM, Jan Beulich wrote:
> Sure: Let's take __tun_chr_ioctl(): While a static function, it gets
> called with two different values for ifreq_len, both of which are
> provably (for a human) correct. I don't think, however, that the
> compiler can be expected to do so on its own in all cases - I would
> expect it to be able to when it decides to inline the function in
> both callers, but the larger that function grows, the more likely
> it'll become that the compiler chooses to keep it separate (and it
> surely would when CONFIG_CC_OPTIMIZE_FOR_SIZE).

with multiple callers.... I would feel safer if there was a check inside the function.
but this is a fair point (the function is large so indeed it is unlikely to get inlined)




> Otoh one would expect a modern compiler to be able to do the
> checking in the case of aer_inject_write(). Yet not everyone is
> using most recent compiler versions, but I personally expect a
> warning free compilation in that case too (at least outside the
> staging sub-tree, which I avoid to build as much as possible). And
> I know that I had seen the warning there (or else it wouldn't have
> caught my attention, and I wouldn't have quoted it in the patch
> description).

if gcc doesn't find this one then arguably that's a gcc bug.
(which is the thing that has been plaguing this feature unfortunately. in theory gcc
should be able to cope with many of these.... in practice...)


for me, the value of the feature overall is this range checking, not the fixed size part.
for fixed size... the chance of the programmer getting it wrong is near zero.
the chance of getting one of the checks wrong is much higher
(we've had cases of wrong sign in the checks, off by ones in the checks etc)
and that is what it was supposed to find.
If that's not possible due practical issues (like the inline case above but more
the compiler practicalities).... removing the warning part entirely is likely just better.

Having a runtime check for the case where the argument is not constant but we know the buffer
size... is likely still clear value... cheap (perfect branch prediction unless disaster hits!)
and the failure case is obviously the disaster case.


