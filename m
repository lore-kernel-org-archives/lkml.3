Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaJCPiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:38:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598AbaJCPiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:38:05 -0400
Message-ID: <542EC2BB.5030907@redhat.com>
Date: Fri, 03 Oct 2014 11:37:31 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH RFC] sched,idle: teach select_idle_sibling about idle
 states
References: <1409844730-12273-1-git-send-email-nicolas.pitre@linaro.org> <1409844730-12273-3-git-send-email-nicolas.pitre@linaro.org> <542B277D.7050103@redhat.com> <alpine.LFD.2.11.1409301904150.5311@knanqh.ubzr> <20141002131548.6cd377d5@cuia.bos.redhat.com> <1412317384.5149.19.camel@marge.simpson.net> <20141003075012.GF10583@worktop.programming.kicks-ass.net> <542EB29A.2050704@redhat.com> <20141003144651.GI10583@worktop.programming.kicks-ass.net>
In-Reply-To: <20141003144651.GI10583@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/03/2014 10:46 AM, Peter Zijlstra wrote:
> On Fri, Oct 03, 2014 at 10:28:42AM -0400, Rik van Riel wrote:

>> The current code has the potential to be quite painful on systems
>> with a large number of cores per chip, so we will have to change
>> things anyway...
> 
> What I said.. so far we've failed at coming up with anything sane 
> though, so far we've found that 2 cpus is too small a slice to look
> at and we're fairly sure 18/36 is too large :-)

Some more brainstorming points...

1) We should probably (lazily/batched?) propagate load information
   up the sched_group tree.  This will be useful for wake_affine,
   load_balancing, find_idlest_cpu, and select_idle_sibling

2) With both find_idlest_cpu and select_idle_sibling walking down
   the tree from the LLC level, they could probably share code

3) Counting both blocked and runnable load may give better long
   term stability of loads, resulting in a reduction in work
   preserving behaviour, but an improvement in locality - this
   could be worthwhile, but it is hard to say in advance

4) We can be pretty sure that CPU makers are not going to stop
   at a mere 18 cores. We need to subdivide things below the LLC
   level, turning select_idle_sibling and find_idlest_cpu into
   a tree walk.

   This means whatever selection criteria are used by these need
   to be propagated up the sched_group tree. This, in turn, means
   we probably need to restrict ourselves to things that do not get
   changed/updated too often.

Am I overlooking anything?

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJULsK7AAoJEM553pKExN6DtBEIAIJWwDPXfrIN6D4yH+/sY7Xg
cDRVDS978OW8GMx3/IqOD90PIvx/l/pttIHHkAcMfDv2Lv8QhiGJEX+OMQg9ETPq
bA31A5t3V3Wlnfc/0xeIMrebc2P3Wfe5s2DApiYPQbDzh47BimDJyeC/9XSqKyvk
CuOZR02t4/20axGwZhl8hk7vGTJhlJWPuh5RUHWjRi2shoHJM90nfZh144GDO3S7
EfiNlC9ZT9z9MYUL6FvCGA7yF+fwzIPE4ppU/KeoDVHsav2OKadV+MjsTQ/IHti2
p0Heu80jEmWW3/zv9zeMpa8jv6Xg8kNsaW709ZSBAzphen5g9sch170A0SdZCiU=
=gUXr
-----END PGP SIGNATURE-----
