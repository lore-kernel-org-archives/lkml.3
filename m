Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbaESPWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:22:17 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41493 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaESPWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:22:16 -0400
Message-ID: <537A2178.7070701@oracle.com>
Date: Mon, 19 May 2014 11:21:28 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kthreads: kill CLONE_KERNEL, change kernel_thread(kernel_init)
 to avoid CLONE_SIGHAND
References: <20140413195617.GA31819@redhat.com> <53761FDB.10806@oracle.com> <20140516153530.GA30751@redhat.com>
In-Reply-To: <20140516153530.GA30751@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 11:35 AM, Oleg Nesterov wrote:
> On 05/16, Sasha Levin wrote:
>>
>> On 04/13/2014 03:56 PM, Oleg Nesterov wrote:
>>> 1. Remove CLONE_KERNEL, it has no users and it is dangerous.
>>>
>>>    The (old) comment says "List of flags we want to share for kernel
>>>    threads" but this is not true, we do not want to share ->sighand by
>>>    default. This flag can only be used if the caller is sure that both
>>>    parent/child will never play with signals (say, allow_signal/etc).
>>>
>>> 2. Change rest_init() to clone kernel_init() without CLONE_SIGHAND.
>>>
>>>    In this case CLONE_SIGHAND does not really hurt, and it looks like
>>>    optimization because copy_sighand() can avoid kmem_cache_alloc().
>>>
>>>    But in fact this only adds the minor pessimization. kernel_init()
>>>    is going to exec the init process, and de_thread() will need to
>>>    unshare ->sighand and do kmem_cache_alloc(sighand_cachep) anyway,
>>>    but it needs to do more work and take tasklist_lock and siglock.
>>>
>>> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>>
>> Hi Oleg,
>>
>> This patch triggers a hang during boot in my KVM guest.
> 
> Hmm... How??? ;)

I'm afraid this is just bisection gone bad. The real issue was the
new goldfish code added, and not this patch.

Since apparently the boot issue was probabilistic I ended up blaming
this commit by mistake. Sorry about that.


Thanks,
Sasha
