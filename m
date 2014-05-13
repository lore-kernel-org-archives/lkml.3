Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbaEMTrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:47:22 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:56407 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbaEMTrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:47:08 -0400
Message-ID: <537276B4.10209@hp.com>
Date: Tue, 13 May 2014 15:47:00 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v10 03/19] qspinlock: Add pending bit
References: <1399474907-22206-1-git-send-email-Waiman.Long@hp.com> <1399474907-22206-4-git-send-email-Waiman.Long@hp.com> <20140512152208.GA12309@potion.brq.redhat.com>
In-Reply-To: <20140512152208.GA12309@potion.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 11:22 AM, Radim Krčmář wrote:
> 2014-05-07 11:01-0400, Waiman Long:
>> From: Peter Zijlstra<peterz@infradead.org>
>>
>> Because the qspinlock needs to touch a second cacheline; add a pending
>> bit and allow a single in-word spinner before we punt to the second
>> cacheline.
> I think there is an unwanted scenario on virtual machines:
> 1) VCPU sets the pending bit and start spinning.
> 2) Pending VCPU gets descheduled.
>      - we have PLE and lock holder isn't running [1]
>      - the hypervisor randomly preempts us
> 3) Lock holder unlocks while pending VCPU is waiting in queue.
> 4) Subsequent lockers will see free lock with set pending bit and will
>     loop in trylock's 'for (;;)'
>      - the worst-case is lock starving [2]
>      - PLE can save us from wasting whole timeslice
>
> Retry threshold is the easiest solution, regardless of its ugliness [4].

Yes, that can be a real issue. Some sort of retry threshold, as you 
said, should be able to handle it.

BTW, the relevant patch should be 16/19 where the PV spinlock stuff 
should be discussed. This patch is perfectly fine.

> Another minor design flaw is that formerly first VCPU gets appended to
> the tail when it decides to queue;
> is the performance gain worth it?
>
> Thanks.

Yes, the performance gain is worth it. The primary goal is to be not 
worse than ticket spinlock in light load situation which is the most 
common case. This feature is need to achieve that.

-Longman
