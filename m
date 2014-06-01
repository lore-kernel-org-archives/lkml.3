Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaFAUxx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 16:53:53 -0400
Received: from blu004-omc2s3.hotmail.com ([65.55.111.78]:51271 "EHLO
	BLU004-OMC2S3.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaFAUxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 16:53:52 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Jun 2014 16:53:52 EDT
X-TMN: [jnN4dcytO/Xo1+OcO65wWdUWNvx3LTwk]
X-Originating-Email: [dave.anglin@bell.net]
Message-ID: <BLU0-SMTP387BD0AE22A4EAD432D65F97210@phx.gbl>
From: John David Anglin <dave.anglin@bell.net>
To: Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20140601192026.GE16155@laptop.programming.kicks-ass.net>
Subject: Re: [PATCH] fix a race condition in cancelable mcs spinlocks
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com> <20140601192026.GE16155@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0 (Apple Message framework v936)
Date: Sun, 1 Jun 2014 16:46:26 -0400
CC: Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, jejb@parisc-linux.org,
        deller@gmx.de, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, chegu_vinod@hp.com,
        paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com, tglx@linutronix.de,
        riel@redhat.com, akpm@linux-foundation.org, davidlohr@hp.com,
        hpa@zytor.com, andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        Jason Low <jason.low2@hp.com>
X-Mailer: Apple Mail (2.936)
X-OriginalArrivalTime: 01 Jun 2014 20:46:43.0749 (UTC) FILETIME=[98D54550:01CF7DDA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1-Jun-14, at 3:20 PM, Peter Zijlstra wrote:

>> If you write to some variable with ACCESS_ONCE and use cmpxchg or  
>> xchg at
>> the same time, you break it. ACCESS_ONCE doesn't take the hashed  
>> spinlock,
>> so, in this case, cmpxchg or xchg isn't really atomic at all.
>
> And this is really the first place in the kernel that breaks like  
> this?
> I've been using xchg() and cmpxchg() without such consideration for
> quite a while.

I believe Mikulas is correct.  Even in a controlled situation where a  
cmpxchg operation
is used to implement pthread_spin_lock() in userspace, we found  
recently that the lock
must be released with a  cmpxchg operation and not a simple write on  
SMP systems.
There is a race in the cache operations or instruction ordering that's  
not present with
the ldcw instruction.

Dave
--
John David Anglin	dave.anglin@bell.net



