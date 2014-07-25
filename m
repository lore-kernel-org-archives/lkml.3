Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934956AbaGYPpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:45:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933581AbaGYPps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:45:48 -0400
Message-ID: <53D27B7E.8090404@redhat.com>
Date: Fri, 25 Jul 2014 11:45:02 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mikey@neuling.org, mingo@kernel.org,
        pjt@google.com, jhladky@redhat.com, ktkhai@parallels.com,
        tim.c.chen@linux.intel.com, nicolas.pitre@linaro.org
Subject: Re: [PATCH] sched: make update_sd_pick_busiest return true on a busier
 sd
References: <20140722144559.382c5243@annuminas.surriel.com> <20140725152728.GB6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140725152728.GB6758@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/25/2014 11:27 AM, Peter Zijlstra wrote:
> On Tue, Jul 22, 2014 at 02:45:59PM -0400, Rik van Riel wrote:
>> Currently update_sd_pick_busiest only returns true when an sd is
>> overloaded, or for SD_ASYM_PACKING when a domain is busier than
>> average and a higher numbered domain than the target.
>> 
>> This breaks load balancing between domains that are not
>> overloaded, in the !SD_ASYM_PACKING case. This patch makes
>> update_sd_pick_busiest return true when the busiest sd yet is
>> encountered.
>> 
>> On a 4 node system, this seems to result in the load balancer
>> finally putting 1 thread of a 4 thread test run of "perf bench
>> numa mem" on each node, where before the load was generally not
>> spread across all nodes.
> 
> So for !ASYM the code is effectively:
> 
> return sgs->avg_load > sds->busiest_stat.avg_load;
> 
> I'd like to at least add a clause that makes overloaded groups 
> prioritized over !overloaded groups.
> 
> Also, like we found earlier, calculate_imbalance() relies on the 
> sum_nr_running > group_capacity_factor thing, which you've just 
> 'wrecked', so we'd need an update to that part too.

I guess that would mean update_sd_pick_busiest would look like
this for the !ASYM case:

1) remembering whether busiest is overloaded

2) if (sgs->busiest_stat.overloaded && !sgs->overloaded)
            return false;

3) if (sgs->avg_load > sds->busiest_stat.avg_load)
            return true;

>> Behaviour for SD_ASYM_PACKING does not seem to match the
>> comment, in that groups with below average load average are
>> ignored, but I have no hardware to test that so I have left the
>> behaviour of that code unchanged.
> 
> Mikey, does that stuff work as expected?

I suspect it does not, due to the checks above the SD_ASYM_PACKAGING
code occasionally overriding the SD_ASYM_PACKAGING code.

Also, the ASYM code may rely on CPU numbers not being interleaved
between groups, the "env->dst_cpu < group_first_cpu(sg)" check would
probably fail to pull all load onto group 0 if CPU numbers were
distributed like this:

group 0: 0 2 4 6
group 1: 1 3 5 7

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJT0nt9AAoJEM553pKExN6DdiYH/jnO9c8f9VNIPD6ibsuG0JXO
HgMJVhYY4YA/kP3wvdOOjLNwAohivCqd41ZMe7jw5K25aJ6/PIT9BN4iImSnPbgw
JPLzUyvMF+hl6/rfmKJnpYSpTOqxbZllmbJPEXJMc0biizftA1u7aoO88ufHsZbq
vZOZLHieHaiMSJ5J5sHpGaWWLw3hS4Ba0HJmUSlV+sbqSX6yZmcDFoQlvYlzfybK
Q2HFVU3WGtYcOIxgJB1NVcn+axok8+O8kI8lQpWSzpewZN6fRKqZMVnmIvEKK15C
stE3U8zXz6eYrlko5J0YyRcL5OPCE/tr4V5CRPonIvsLXmAmrMra5Ev4Dc/4Rr4=
=hZqS
-----END PGP SIGNATURE-----
