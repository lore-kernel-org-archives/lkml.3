Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab3EHNxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 09:53:53 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:30140 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab3EHNxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 09:53:52 -0400
Message-ID: <518A58C0.9030304@oracle.com>
Date: Wed, 08 May 2013 09:53:04 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130429 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] liblockdep: Wrap kernel/lockdep.c to allow usage
 from userspace
References: <1367348080-4680-1-git-send-email-sasha.levin@oracle.com> <1367348080-4680-3-git-send-email-sasha.levin@oracle.com> <20130508100143.GA6131@dyad.programming.kicks-ass.net> <518A52D2.4050505@oracle.com> <20130508133547.GA8386@dyad.programming.kicks-ass.net>
In-Reply-To: <20130508133547.GA8386@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 09:35 AM, Peter Zijlstra wrote:
> On Wed, May 08, 2013 at 09:27:46AM -0400, Sasha Levin wrote:
>> [snip]
>>
>> Hi Peter,
>>
>> You're right - I broke multithreading for some odd reason (mostly me being stupid)
>> after having it working :/
>>
>> It's enough to set the __thread flag on current_obj:
>>
>> 	diff --git a/tools/lib/lockdep/common.c b/tools/lib/lockdep/common.c
>> 	index eb5e481..8ef602f 100644
>> 	--- a/tools/lib/lockdep/common.c
>> 	+++ b/tools/lib/lockdep/common.c
>> 	@@ -5,7 +5,7 @@
>> 	 #include <unistd.h>
>> 	 #include <sys/syscall.h>
>> 	
>> 	-static struct task_struct current_obj;
>> 	+static __thread struct task_struct current_obj;
>> 	
>> 	 /* lockdep wants these */
>> 	 bool debug_locks = true;
>>
>> Since we don't need any special initialization of the struct at any point. This
>> means that the patch above is enough and we don't need to hook pthread_create.
>>
> 
> I tried googling but failed to find the TLS initialization rules. Are they
> zero'd for each thread or copied about or what? And is this documented or
> implementation behaviour?
> 
> If its consistently zero'd then I suppose you're right and we can get away with
> just adding __thread; *phew*.

I assumed that they are zero'd because it is a global variable, and those are
supposed to be zero'd.

Running a quick test confirmed that they are indeed zero'd for each thread, so
we're safe to just add that __thread.


Thanks,
Sasha

