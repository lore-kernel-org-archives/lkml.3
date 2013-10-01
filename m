Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239Ab3JAE6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 00:58:19 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:65067 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab3JAE6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 00:58:18 -0400
MIME-Version: 1.0
In-Reply-To: <20131001031356.GP19582@linux.vnet.ibm.com>
References: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com>
	<1380581522.6396.20.camel@pasglop>
	<23118.1380587771@ale.ozlabs.ibm.com>
	<CA+55aFwi5sZK4mFxs3PT1wU4_vNzsLOFiocqi3g14fPamKXYsw@mail.gmail.com>
	<1380593103.6396.38.camel@pasglop>
	<20131001031356.GP19582@linux.vnet.ibm.com>
Date: Tue, 1 Oct 2013 14:52:28 +1000
X-Google-Sender-Auth: A3VrjOOWBzfXSHxqTc59-oACXss
Message-ID: <CAEjGV6xuscOh=t6BhbdRKAPcZ1DOJkD6ZcB1wgTf9-AedKSaxA@mail.gmail.com>
Subject: Re: Avoiding the dentry d_lock on final dput(), part deux:
 transactional memory
From: Michael Neuling <mikey@neuling.org>
To: paulmck@linux.vnet.ibm.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Well we don't have to, I think Mikey wasn't totally clear about that
>> "making all registers volatile" business :-) This is just something we
>> need to handle in assembly if we are going to reclaim the suspended
>> transaction.

Yeah, sorry.  The slow path with all registers as volatile is only
needed if we get pre-empted during the transaction.

>>
>> So basically, what we need is something along the lines of
>> enable_kernel_tm() which checks if there's a suspended user transaction
>> and if yes, kills/reclaims it.
>>
>> Then we also need to handle in our interrupt handlers that we have an
>> active/suspended transaction from a kernel state, which we don't deal
>> with at this point, and do whatever has to be done to kill it... we
>> might get away with something simple if we can state that we only allow
>> kernel transactions at task level and not from interrupt/softirq
>> contexts, at least initially.
>
> Call me a coward, but this is starting to sound a bit scary.  ;-)

We are just wanting to prototype it for now to see if we could make it
go faster.  If it's worth it, then we'd consider the additional
complexity this would bring.

I don't think it'll be that bad, but I'd certainly want to make sure
it's worth it before trying :-)

Mikey
