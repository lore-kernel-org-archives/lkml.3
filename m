Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaELDWa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 23:22:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:48295 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbaELDW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 23:22:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1032,1389772800"; 
   d="scan'208";a="537435939"
Message-ID: <53703E74.9020700@linux.intel.com>
Date: Sun, 11 May 2014 20:22:28 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephan Mueller <smueller@chronox.de>
CC: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: arch_random_refill
References: <21542339.0lFnPSyGRS@myon.chronox.de>
In-Reply-To: <21542339.0lFnPSyGRS@myon.chronox.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2014 04:01 PM, Stephan Mueller wrote:
> Hi Peter,
> 
> some time back when the RDRAND instruction was debated, a patch was offered 
> for driver/char/random.c that in essence turned /dev/random into a frontend 
> for RDRAND in case that instruction was available. The patch kind of 
> monopolized the noise sources such that if a user space "random number hog" 
> pulled data from /dev/random endlessly, the (almost) only noise source was 
> RDRAND. As that patch treated RDRAND to provide entropy, the blocking behavior 
> went away for /dev/random.
> 

This is false in a number of ways.

First of all... we NEVER pulled either /dev/random or /dev/urandom
directly from RDRAND.  We used RDRAND directly for kernel internal
randomness uses.  Users did object to this.

> That patch did not sit well with some developers and it got finally changed 
> such that the output of RDRAND is now just XORed with the output of the 
> "classic" /dev/random behavior -- /dev/random is still blocking. 

Mixing in RDRAND into /dev/random and /dev/urandom is actually

> With the current development cycle for 3.15, the function arch_random_refill 
> is added as presented in [1]. It now uses RDSEED instead of RDRAND. Yet, the 
> way this function is called in random_read seems (as I have no system with an 
> RDSEED, I cannot test) to show the very same behavior as the aforementioned 
> RDRAND patch: the blocking behavior of /dev/random will be gone and RDSEED 
> will monopolize the noise sources in case of a user space hog.

There is a huge difference between this and what people objected to
earlier: we filter everything through the kernel random number pool
system, which would require a herculean mathematical effort to reverse
even if the output of RDSEED was 100% predictable.

> Note, I do not see an issue with the patch that adds RDSEED as part of 
> add_interrupt_randomness outlined in [2]. The reason is that this patch does 
> not monopolizes the noise sources.
> 
> I do not want to imply that Intel (or any other chip manufacturer that will 
> hook into arch_random_refill) intentionally provides bad entropy (and this 
> email shall not start a discussion about entropy again), but I would like to 
> be able to only use noise sources that I can fully audit. As it is with 
> hardware, I am not able to see what it is doing.

I have to point out the irony in this given your previous proposals,
however...

> Thus, may I ask that arch_random_refill is revised such that it will not 
> monopolize the noise sources? If somebody wants that, he can easily use rngd.

Feel free to build the kernel without CONFIG_ARCH_RANDOM, or use the
"nordrand" option to the kernel.  These options are there for a reason.

Now when you mention it, though, the nordrand option should turn off
RDSEED as well as RDRAND.  It currently doesn't; that is a bug, plain
and simple.

	-hpa

