Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbaA2R6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 12:58:25 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:1026 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaA2R6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 12:58:24 -0500
Message-ID: <52E94125.8010900@hp.com>
Date: Wed, 29 Jan 2014 12:57:57 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v3 1/2] qspinlock: Introducing a 4-byte queue spinlock
 implementation
References: <1390933151-1797-1-git-send-email-Waiman.Long@hp.com> <1390933151-1797-2-git-send-email-Waiman.Long@hp.com> <20140129002048.GE11821@two.firstfloor.org>
In-Reply-To: <20140129002048.GE11821@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 07:20 PM, Andi Kleen wrote:
> So the 1-2 threads case is the standard case on a small
> system, isn't it? This may well cause regressions.
>

Yes, it is possible that in a lightly contended case, the queue spinlock 
maybe a bit slower because of the slowpath overhead. I observed some 
slight slowdown in some of the lightly contended workloads. I will run 
more test in a smaller 2-socket system or even a 1-socket system to see 
if there is observed regression.

>> In the extremely unlikely case that all the queue node entries are
>> used up, the current code will fall back to busy spinning without
>> waiting in a queue with warning message.
> Traditionally we had some code which could take thousands
> of locks in rare cases (e.g. all locks in a hash table or all locks of
> a big reader lock)
>
> The biggest offender was the mm for changing mmu
> notifiers, but I believe that's a mutex now.
> lglocks presumably still can do it on large enough
> systems.  I wouldn't be surprised if there is
> other code which e.g. make take all locks in a table.
>
> I don't think the warning is valid and will
> likely trigger in some obscure cases.
>
> -Andi

As explained by George, the queue node is only needed when the thread is 
waiting to acquire the lock. Once it gets the lock, the node can be 
released and be reused.

-Longman

