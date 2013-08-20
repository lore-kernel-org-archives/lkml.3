Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab3HTGUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:20:54 -0400
Received: from mail.eperm.de ([89.247.134.16]:52741 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab3HTGUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:20:52 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: sandyinchina@gmail.com, Theodore Tso <tytso@mit.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH][RFC] Tests on 200 different CPUs/Arches and OSes with CPU Jitter RNG
Date: Tue, 20 Aug 2013 08:20:40 +0200
Message-ID: <114750096.FHpdnNQbA1@tauon>
User-Agent: KMail/4.10.5 (Linux/3.10.6-200.fc19.x86_64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2846522.WmUuVkVV56@tauon>
References: <2846522.WmUuVkVV56@tauon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 18. August 2013, 20:05:52 schrieb Stephan Mueller:

Hi Ted, Sandy,

For FIPS 140-2, there is currently a draft of an Implementation Guidance 
discussed covering the requirements of seed sources for deterministic 
random number generators. The standard seed source when having no 
hardware RNGs is either /dev/urandom or /dev/random. Please note that 
the current discussion explicitly prohibits the use of /dev/urandom for 
FIPS 140-2 compliant systems.

In addition, the recommendation of SP800-90B is available in draft form 
at [1] placing quite severe requirements on seed sources. After 
assessing the above mentioned IG discussion and in discussions with the 
German BSI, these governmental folks seem to interpret the concept of 
entropy as solely information theoretical entropy. They seem to 
disregard cryptographic strength added by a whitening function. 
Therefore, my gut feeling is that /dev/urandom is also questioned by 
SP800-90B -- but I have no proof at this point.

That focus on information theoretical entropy ultimately implies that 
only /dev/random can be used and /dev/urandom must not be used. 
Naturally, many people are not happy with that due to the blocking 
behavior. Especially in a headless environment like server systems, 
Linux is currently starved of entropy. This is even more a problem with 
virtualized environments. For example, some time ago we tried to obtain 
48 bytes out of /dev/random on a PPC system after the entropy pools 
where completely drained. Well, we got it after some 20 hours as the 
system was quiet (it may now be a bit better with the interrupt usage in 
current kernels, but still there will be a noticeable block).

Now, people will scream: those governmental guys sell snake oil and we 
should still use /dev/urandom. And I have to concur. Yet, I am just 
delivering the message. With the German BSI, the last discussion showed 
that they are open to allowing /dev/urandom based on extensive 
discussions. Yet, you have to make quite a stance to prove that.

>- addition of a patch to integrate the RNG into /dev/random as
>explained in appendix B.3 of [2], although the long-term goal of the
>RNG is rather the integration into the kernel crypto API when
>considering the Linux kernel as outlined in appendix B.1 of [2]

All in all, with the suggested CPU Jitter RNG, all of this would be an 
issue of the past on systems the init function considers appropriate -- 
in my tests more than 95% of all systems are accepted. When using my 
patch on /dev/random, dd shows a throughput of about 6kb/s on my system 
when pulling out megabytes of data. It will be slower on slower systems, 
but yet it will not block. Moreover when pulling data for seed which is 
only a few bytes at a time, the invocation of /dev/random will not show 
any noticeable delay.

PS: As I mentioned earlier, however, my long term goal would be that 
callers would disregard /dev/random entirely as it is a central entropy 
source and therefore the prime spot for attacks to reduce entropy. With 
the jitter RNG, even unprivileged user space can have its own instance 
of a seed source.


[1] http://csrc.nist.gov/publications/PubsDrafts.html#SP-800-90-B


Ciao
Stephan
-- 
| Cui bono? |

