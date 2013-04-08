Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935440Ab3DHRyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:54:00 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:37012 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934750Ab3DHRx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:53:59 -0400
Message-ID: <5163042F.9000404@hp.com>
Date: Mon, 08 Apr 2013 13:53:51 -0400
From: Waiman Long <Waiman.Long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120601 Thunderbird/10.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH RFC 1/3] mutex: Make more scalable by doing less atomic
 operations
References: <1365087258-7169-1-git-send-email-Waiman.Long@hp.com> <1365087258-7169-2-git-send-email-Waiman.Long@hp.com> <20130408124223.GA10093@gmail.com> <CA+55aFztAtpiGK9e_Ed=Kk4jAWNTahv9OEb0+fgp52Api1s7Mw@mail.gmail.com>
In-Reply-To: <CA+55aFztAtpiGK9e_Ed=Kk4jAWNTahv9OEb0+fgp52Api1s7Mw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 10:38 AM, Linus Torvalds wrote:
> On Mon, Apr 8, 2013 at 5:42 AM, Ingo Molnar<mingo@kernel.org>  wrote:
>> AFAICS the main performance trade-off is the following: when the owner CPU unlocks
>> the mutex, we'll poll it via a read first, which turns the cacheline into
>> shared-read MESI state. Then we notice that its content signals 'lock is
>> available', and we attempt the trylock again.
>>
>> This increases lock latency in the few-contended-tasks case slightly - and we'd
>> like to know by precisely how much, not just for a generic '10-100 users' case
>> which does not tell much about the contention level.
> We had this problem for *some* lock where we used a "read + cmpxchg"
> in the hotpath and it caused us problems due to two cacheline state
> transitions (first to shared, then to exclusive). It was faster to
> just assume it was unlocked and try to do an immediate cmpxchg.
>
> But iirc it is a non-issue for this case, because this is only about
> the contended slow path.
>
> I forget where we saw the case where we should *not* read the initial
> value, though. Anybody remember?
>
> That said, the MUTEX_SHOULD_XCHG_COUNT macro should die. Why shouldn't
> all architectures just consider negative counts to be locked? It
> doesn't matter that some might only ever see -1.

I think so too. However, I don't have the machines to test out other 
architectures. The MUTEX_SHOULD_XCHG_COUNT is just a safety measure to 
make sure that my code won't screw up the kernel in other architectures. 
Once it is confirmed that a negative count other than -1 is fine for all 
the other architectures, the macro can certainly go.

Regards,
Longman
