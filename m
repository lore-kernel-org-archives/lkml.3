Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab3KVUfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 15:35:22 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:8133 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab3KVUfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 15:35:19 -0500
Message-ID: <528FBFFA.1000807@hp.com>
Date: Fri, 22 Nov 2013 15:35:06 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] qrwlock: A queue read/write lock implementation
References: <1385147087-26588-1-git-send-email-Waiman.Long@hp.com> <1385147087-26588-2-git-send-email-Waiman.Long@hp.com> <CA+55aFzkqP84M7L6j__QHuks7DXTQnGqdCo3=a=u7qKdER9rEQ@mail.gmail.com>
In-Reply-To: <CA+55aFzkqP84M7L6j__QHuks7DXTQnGqdCo3=a=u7qKdER9rEQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 02:14 PM, Linus Torvalds wrote:
> On Fri, Nov 22, 2013 at 11:04 AM, Waiman Long<Waiman.Long@hp.com>  wrote:
>> In term of single-thread performance (no contention), a 256K
>> lock/unlock loop was run on a 2.4GHz and 2.93Ghz Westmere x86-64
>> CPUs. The following table shows the average time (in ns) for a single
>> lock/unlock sequence (including the looping and timing overhead):
>>
>> Lock Type                   2.4GHz      2.93GHz
>> ---------                   ------      -------
>> Ticket spinlock              14.9        12.3
>> Read lock                    17.0        13.5
>> Write lock                   17.0        13.5
>> Queue read lock              16.0        13.4
>> Queue write lock              9.2         7.8
> Can you verify for me that you re-did those numbers? Because it used
> to be that the fair queue write lock was slower than the numbers you
> now quote..
>
> Was the cost of the fair queue write lock purely in the extra
> conditional testing for whether the lock was supposed to be fair or
> not, and now that you dropped that, it's fast? If so, then that's an
> extra argument for the old conditional fair/unfair being complete
> garbage.

Yes, the extra latency of the fair lock in earlier patch is due to the 
need to do a second cmpxchg(). That can be avoided by doing a read 
first, but that is not good for good cache.  So I optimized it for the 
default unfair lock. By supporting only one version, there is no need to 
do a second cmpxchg anymore.

> Alternatively, maybe you just took the old timings, and the above
> numbers are for the old unfair code, and *not* for the actual patch
> you sent out?
>
> So please double-check and verify.
>
>                Linus

I reran the timing test on the 2.93GHz processor. The timing is the 
practically the same. I reused the old one for the 2.4GHz processor.

Regards,
Longman
