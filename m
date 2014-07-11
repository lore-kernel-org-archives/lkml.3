Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaGKQMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:12:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbaGKQMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:12:44 -0400
Message-ID: <53C00CC1.1030401@redhat.com>
Date: Fri, 11 Jul 2014 12:11:45 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>
CC: Michael wang <wangyun@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: select 'idle' cfs_rq per task-group to prevent
 tg-internal imbalance
References: <53A11A89.5000602@linux.vnet.ibm.com>	 <20140623094251.GS19860@laptop.programming.kicks-ass.net>	 <53A8F1DE.2060908@linux.vnet.ibm.com>	 <20140701082020.GL6758@twins.programming.kicks-ass.net>	 <53B273A2.5050500@linux.vnet.ibm.com> <53B41B7E.8020009@redhat.com> <1404359462.5137.72.camel@marge.simpson.net>
In-Reply-To: <1404359462.5137.72.camel@marge.simpson.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/02/2014 11:51 PM, Mike Galbraith wrote:
> On Wed, 2014-07-02 at 10:47 -0400, Rik van Riel wrote:
>> On 07/01/2014 04:38 AM, Michael wang wrote:
>>> On 07/01/2014 04:20 PM, Peter Zijlstra wrote: [snip]
>>>>> 
>>>>> Just wondering could we make this another scheduler
>>>>> feature?
>>>> 
>>>> No; sched_feat() is for debugging, BIG CLUE: its guarded by 
>>>> CONFIG_SCHED_DEBUG, anybody using it in production or
>>>> anywhere else is broken.
>>>> 
>>>> If people are using it, I should remove or at least randomize
>>>> the interface.
>>> 
>>> Fair enough... but is there any suggestions on how to handle
>>> this issue?
>>> 
>>> Currently when dbench running with stress, it could only gain
>>> one CPU, and cpu-cgroup cpu.shares is meaningless, is there any
>>> good methods to address that?
>> 
>> select_idle_sibling will iterate over all of the CPUs in an LLC
>> domain if there is no idle cpu in the domain.
>> 
>> I suspect it would not take much extra code to track down the
>> idlest CPU in the LLC domain, and make sure to schedule tasks
>> there, in case no completely idle CPU was found.
>> 
>> Are there any major problems with that thinking?
> 
> That's full wake balance.. if that was cheap,
> select_idle_sibling() would not exist.

Full wake balance iterates over all the groups in the system,
select_idle_sibling only over one LLC domain.

If no CPU in the LLC domain is idle, select_idle_sibling will
iterate over all of them.  During this iteration, which the
code already does, it should be possible to identify the least
loaded of the CPUs and pick that one.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTwAzBAAoJEM553pKExN6DlrEH/RKQPdAdMFK/pxZ/2f9TCXFK
Vq25LWZeJQhNOrH3Q6VzTTfAG06O8+Bjxfb+SR6BOHCtD4kCBqaBdwVVUDXC+MbK
NdBa3GtCT3ahvguiYLPEHL1vugND2yzHUgnr9EhUgk6zhnLxfvhIIJj7uv+ZRsri
o8DsLrIG1jqDGVbbu5ssZ37w6cldoFBw0FAHcVAquoM2SP+/MuatW1SCkRP31IVL
q0dssP1CD0Nkecz+S6WSI59c0Wt0c73oWNg/q41a/kha7RI1J5VF5yNFacq/uL0g
Xxyb0mOiJarqMtzuq5ItlOiTry+BpqY1jFhN5ZhFjt9mtvpTR1C/tcXpOw77y0Y=
=BEJk
-----END PGP SIGNATURE-----
