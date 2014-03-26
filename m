Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbaCZNdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 09:33:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933AbaCZNdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 09:33:12 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shli@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH RFC 0/2] percpu_ida: Take into account CPU topology when stealing tags
Date: Wed, 26 Mar 2014 14:34:22 +0100
Message-Id: <cover.1395840483.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series is against 3.14.0-rc7.

It is amied to further improve 'percpu_ida' tags locality by taking
into account system's CPU topology when stealing tags. That is try
to steal from a CPU which is 'closest' to the stealing one.

I would not bother to post this, since on several system the change
did not show any improvement, i.e. on such one:

CPU0 attaching sched-domain:
 domain 0: span 0,8 level SIBLING
  groups: 0 (cpu_power = 588) 8 (cpu_power = 588)
  domain 1: span 0-3,8-11 level MC
   groups: 0,8 (cpu_power = 1176) 1,9 (cpu_power = 1176) 2,10 (cpu_power = 1176) 3,11 (cpu_power = 1176)
   domain 2: span 0-15 level NUMA
    groups: 0-3,8-11 (cpu_power = 4704) 4-7,12-15 (cpu_power = 4704)


But other systems (more dense?) showed increased cache-hit rate
up to 20%, i.e. this one:

CPU5 attaching sched-domain:
 domain 0: span 0-5 level MC
  groups: 5 (cpu_power = 1023) 0 (cpu_power = 1023) 1 (cpu_power = 1023) 2 (cpu_power = 1023) 3 (cpu_power = 1023) 4 (cpu_power = 1023)
  domain 1: span 0-7 level NUMA
   groups: 0-5 (cpu_power = 6138) 6-7 (cpu_power = 2046)
CPU6 attaching sched-domain:
 domain 0: span 6-7 level MC
  groups: 6 (cpu_power = 1023) 7 (cpu_power = 1023)
  domain 1: span 0-7 level NUMA
   groups: 6-7 (cpu_power = 2046) 0-5 (cpu_power = 6138)


I tested using 'null_blk' device with number of threads equal
to the number of CPUs with each thread affined to one CPU and
not affined, with no difference.

Suggestions are welcomed :)

Thanks!

Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Shaohua Li <shli@kernel.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>

Alexander Gordeev (2):
  sched: Introduce topology level masks and for_each_tlm() macro
  percpu_ida: Use for_each_tlm() macro for CPU lookup in steal_tags()

 include/linux/percpu_ida.h |    1 -
 include/linux/sched.h      |    5 ++
 kernel/sched/core.c        |   89 ++++++++++++++++++++++++++++++++++++++++++++
 lib/percpu_ida.c           |   46 +++++++++-------------
 4 files changed, 113 insertions(+), 28 deletions(-)

-- 
1.7.7.6

