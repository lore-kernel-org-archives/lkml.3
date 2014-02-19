Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbaBST02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 14:26:28 -0500
Received: from g4t3427.houston.hp.com ([15.201.208.55]:57007 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbaBST0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 14:26:25 -0500
Message-ID: <5305054B.5020601@hp.com>
Date: Wed, 19 Feb 2014 14:26:03 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
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
Subject: Re: [PATCH v4 1/3] qspinlock: Introducing a 4-byte queue spinlock
 implementation
References: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com> <1392669684-4807-2-git-send-email-Waiman.Long@hp.com> <20140218073951.GZ27965@twins.programming.kicks-ass.net> <5303B6F3.9090001@hp.com> <20140218213400.GS14089@laptop.programming.kicks-ass.net> <5303FFC5.5040004@hp.com> <20140219085225.GH27965@twins.programming.kicks-ass.net>
In-Reply-To: <20140219085225.GH27965@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 03:52 AM, Peter Zijlstra wrote:
> On Tue, Feb 18, 2014 at 07:50:13PM -0500, Waiman Long wrote:
>> On 02/18/2014 04:34 PM, Peter Zijlstra wrote:
>>> On Tue, Feb 18, 2014 at 02:39:31PM -0500, Waiman Long wrote:
>>>> The #ifdef is harder to take away here. The point is that doing a 32-bit
>>>> exchange may accidentally steal the lock with the additional code to handle
>>>> that. Doing a 16-bit exchange, on the other hand, will never steal the lock
>>>> and so don't need the extra handling code. I could construct a function with
>>>> different return values to handle the different cases if you think it will
>>>> make the code easier to read.
>>> Does it really pay to use xchg() with all those fixup cases? Why not
>>> have a single cmpxchg() loop that does just the exact atomic op you
>>> want?
>> The main reason for using xchg instead of cmpxchg is its performance impact
>> when the lock is heavily contended. Under those circumstances, a task may
>> need to do several tries of read+atomic-RMV before getting it right. This
>> may cause a lot of cacheline contention. With xchg, we need at most 2 atomic
>> ops. Using cmpxchg() does simplify the code a bit at the expense of
>> performance with heavy contention.
> Have you actually measured this?

I haven't actually measured that myself. It is mostly from my 
experience. I could do some timing experiment with the cmpxchg() change 
and report back to you later.

-Longman
