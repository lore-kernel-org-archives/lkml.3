Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936572Ab3DJV0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 17:26:18 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:44006 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935371Ab3DJV0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 17:26:16 -0400
Message-ID: <5165D8F4.7010701@hp.com>
Date: Wed, 10 Apr 2013 17:26:12 -0400
From: Waiman Long <Waiman.Long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120601 Thunderbird/10.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
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
References: <1365087258-7169-1-git-send-email-Waiman.Long@hp.com> <1365087258-7169-2-git-send-email-Waiman.Long@hp.com> <20130408124223.GA10093@gmail.com> <CA+55aFztAtpiGK9e_Ed=Kk4jAWNTahv9OEb0+fgp52Api1s7Mw@mail.gmail.com> <5163042F.9000404@hp.com> <20130410103144.GC28505@gmail.com> <51658ADB.4050204@hp.com> <20130410171654.GD21951@gmail.com>
In-Reply-To: <20130410171654.GD21951@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 01:16 PM, Ingo Molnar wrote:
> * Waiman Long<Waiman.Long@hp.com>  wrote:
>
>> On 04/10/2013 06:31 AM, Ingo Molnar wrote:
>>> * Waiman Long<Waiman.Long@hp.com>   wrote:
>>>
>>>>> That said, the MUTEX_SHOULD_XCHG_COUNT macro should die. Why shouldn't all
>>>>> architectures just consider negative counts to be locked? It doesn't matter
>>>>> that some might only ever see -1.
>>>> I think so too. However, I don't have the machines to test out other
>>>> architectures. The MUTEX_SHOULD_XCHG_COUNT is just a safety measure to make sure
>>>> that my code won't screw up the kernel in other architectures. Once it is
>>>> confirmed that a negative count other than -1 is fine for all the other
>>>> architectures, the macro can certainly go.
>>> I'd suggest to just remove it in an additional patch, Cc:-ing
>>> linux-arch@vger.kernel.org. The change is very likely to be fine, if not then it's
>>> easy to revert it.
>>>
>>> Thanks,
>>>
>>> 	Ingo
>> Yes, I can do that. So can I put your name down as reviewer or ack'er for the
>> 1st patch?
> Since I'll typically the maintainer applying&  pushing kernel/mutex.c changes to
> Linus via the locking tree, the commit will get a Signed-off-by from me once you
> resend the latest state of things - no need to add my Acked-by or Reviewed-by
> right now.
Thank for the explanation. I am still pretty new to this process of 
upstream kernel development.

> I'm still hoping for another patch from you that adds queueing to the spinners ...
> That approach could offer better performance than current patches 1,2,3. In
> theory.
>
> I'd prefer that approach because you have a testcase that shows the problem and
> you are willing to maximize performance with it - so we could make sure we have
> reached maximum performance instead of dropping patches #2, #3, reaching partial
> performance with patch #1, without having a real full resolution.
>
That is what I hope too. I am going to work on another patch to add 
spinner queuing to see how much performance impact it will have.

BTW, I have also been thinking about extracting the spinlock out from 
the mutex structure for some busy mutex by adding a pointer to an 
external auxiliary structure (separately allocated at init time). The 
idea is to use the external spinlock if available. Otherwise, the 
internal one will be used. That should reduce cacheline contention for 
some of the busiest mutex. The spinner queuing tickets can be in the 
external structure too. However, it requires a one line change in each 
of the mutex initialization code. I haven't actually made the code 
change and try it yet, but that is something that I am thinking of doing 
when I have time.

Thanks,
Longman
