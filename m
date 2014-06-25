Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbaFYFj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:39:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761AbaFYFj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:39:58 -0400
Message-ID: <53AA608F.50301@redhat.com>
Date: Wed, 25 Jun 2014 01:39:27 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, chegu_vinod@hp.com, mgorman@suse.de,
        mingo@kernel.org
Subject: Re: [PATCH 9/7] sched,numa: remove task_h_load from task_numa_compare
References: <1403538095-31256-1-git-send-email-riel@redhat.com> <20140624151454.2a05082e@annuminas.surriel.com> <20140625050735.GB28774@twins.programming.kicks-ass.net> <20140625052144.GH3588@twins.programming.kicks-ass.net> <53AA5D2C.9000401@redhat.com> <20140625053138.GF6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140625053138.GF6758@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 06/25/2014 01:31 AM, Peter Zijlstra wrote:
> On Wed, Jun 25, 2014 at 01:25:00AM -0400, Rik van Riel wrote:
>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA1
>> 
>> On 06/25/2014 01:21 AM, Peter Zijlstra wrote:
>>> On Wed, Jun 25, 2014 at 07:07:35AM +0200, Peter Zijlstra
>>> wrote:
>>>> Shall I merge this into patch 3?
>>> 
>>> Which gets me the below; which is has a wrong changelog.
>>> 
>>> task_h_load() already computes the load as seen from the root 
>>> group. effective_load() just does a better (and more expensive)
>>> job of computing the task movement implications of a move.
>>> 
>>> So the total effect of this patch shouldn't be very big;
>>> regular load balancing also only uses task_h_load(), see
>>> move_tasks().
>>> 
>>> Now, we don't run with preemption disabled, don't run as
>>> often, etc.., so maybe we can indeed use the more expensive
>>> variant just fine, but does it really matter?
>> 
>> In my testing, it appears to make a difference between workloads 
>> converging, and workloads sitting with one last thread stuck on 
>> another node that never gets moved...
> 
> Fair enough; can you provide a new Changelog that I can paste in?

Here it goes:

When CONFIG_FAIR_GROUP_SCHED is enabled, the load that a task places
on a CPU is determined by the group the task is in. The active groups
on the source and destination CPU can be different, resulting in a
different load contribution by the same task at its source and at its
destination. As a result, the load needs to be calculated separately
for each CPU, instead of estimated once with task_h_load.

Getting this calculation right allows some workloads to converge,
where previously the last thread could get stuck on another node,
without being able to migrate to its final destination.




- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTqmCPAAoJEM553pKExN6D4/IH/1Ez7G3jAnYFpQYvH/wSm75V
kbH+mouLAqeICjHRdXAr1SGuD8i85JeUeDU2+SymdhC+hwZXbvR/aQfX0/ok4kN7
e7kJbaNS6Lrq3bDjm74aTpMKB+zK2OExqR1DQBXwynbUahAyx3+9uXNDYp35yZwo
tt+h3Rdrmy2lTTpE0fuEjGc8ODrEJjeWyYAVxT/aQXnwgfXfp6BZ1SEXyRRmrxR0
BunsgWTO7uBxGGEIZrrm/l7mdIrsi4oAN9C4RA7v6LMR6cUW9Fj5o6iva9X714wG
txP4/AGowucS5VckN1RIaM8/pzMB3MVuAmCTX4PqWg1jf3eggcQpe5/4/bVYUqQ=
=QgYM
-----END PGP SIGNATURE-----
