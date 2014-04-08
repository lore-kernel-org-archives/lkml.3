Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbaDHOz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:55:27 -0400
Received: from smtp.01.com ([199.36.142.181]:46749 "EHLO smtp.01.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756780AbaDHOzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:55:25 -0400
X-Greylist: delayed 515 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Apr 2014 10:55:25 EDT
Message-ID: <53440BD6.5030008@agliodbs.com>
Date: Tue, 08 Apr 2014 10:46:46 -0400
From: Josh Berkus <josh@agliodbs.com>
Organization: PostgreSQL Experts Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>, Vlastimil Babka <vbabka@suse.cz>
CC: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Robert Haas <robertmhaas@gmail.com>,
        Andres Freund <andres@2ndquadrant.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, sivanich@sgi.com
Subject: Re: [PATCH 0/2] Disable zone_reclaim_mode by default
References: <1396910068-11637-1-git-send-email-mgorman@suse.de> <5343A494.9070707@suse.cz> <alpine.DEB.2.10.1404080914280.8782@nuc> <WM!ea1193ee171854a74828ee30c859d97ff2ce66405ffa3a0b8c31a1233c6a0b55530cdf3cbfcd989c0ec18fef1d533f81!@asav-3.01.com>
In-Reply-To: <WM!ea1193ee171854a74828ee30c859d97ff2ce66405ffa3a0b8c31a1233c6a0b55530cdf3cbfcd989c0ec18fef1d533f81!@asav-3.01.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 10:17 AM, Christoph Lameter wrote:

> Another solution here would be to increase the threshhold so that
> 4 socket machines do not enable zone reclaim by default. The larger the
> NUMA system is the more memory is off node from the perspective of a
> processor and the larger the hit from remote memory.

8 and 16 socket machines aren't common for nonspecialist workloads
*now*, but by the time these changes make it into supported distribution
kernels, they may very well be.  So having zone_reclaim_mode
automatically turn itself on if you have more than 8 sockets would still
be a booby-trap ("Boss, I dunno.  I installed the additional processors
and memory performance went to hell!")

For zone_reclaim_mode=1 to be useful on standard servers, both of the
following need to be true:

1. the user has to have set CPU affinity for their applications;

2. the applications can't need more than one memory bank worth of cache.

The thing is, there is *no way* for Linux to know if the above is true.

Now, I can certainly imagine non-HPC workloads for which both of the
above would be true; for example, I've set up VMware ESX servers where
each VM has one socket and one memory bank. However, if the user knows
enough to set up socket affinity, they know enough to set
zone_reclaim_mode = 1.  The default should cover the know-nothing case,
not the experienced specialist case.

I'd also argue that there's a fundamental false assumption in the entire
algorithm of zone_reclaim_mode, because there is no memory bank which is
as distant as disk is, ever.  However, if it's off by default, then I
don't care.

-- 
Josh Berkus
PostgreSQL Experts Inc.
http://pgexperts.com
