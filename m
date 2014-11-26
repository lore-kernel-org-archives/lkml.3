Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaKZPcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:32:21 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:52984 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbaKZPcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:32:17 -0500
Date: Wed, 26 Nov 2014 16:32:07 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        paulus@samba.org, akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
        schwidefsky@de.ibm.com, borntraeger@de.ibm.com, mingo@kernel.org
Subject: Re: [RFC 0/2] Reenable might_sleep() checks for might_fault() when
 atomic
Message-ID: <20141126163207.63810fcb@thinkpad-w530>
In-Reply-To: <20141126152334.GA9648@redhat.com>
References: <1416915806-24757-1-git-send-email-dahi@linux.vnet.ibm.com>
	<20141126070258.GA25523@redhat.com>
	<20141126110504.511b733a@thinkpad-w530>
	<20141126151729.GB9612@redhat.com>
	<20141126152334.GA9648@redhat.com>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112615-0021-0000-0000-000001EC6CFF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Nov 26, 2014 at 05:17:29PM +0200, Michael S. Tsirkin wrote:
> > On Wed, Nov 26, 2014 at 11:05:04AM +0100, David Hildenbrand wrote:
> > > > What's the path you are trying to debug?
> > > 
> > > Well, we had a problem where we held a spin_lock and called
> > > copy_(from|to)_user(). We experienced very random deadlocks that took some guy
> > > almost a week to debug. The simple might_sleep() check would have showed this
> > > error immediately.
> > 
> > This must have been a very old kernel.
> > A modern kernel will return an error from copy_to_user.
> > Which is really the point of the patch you are trying to revert.
> 
> That's assuming you disabled preemption. If you didn't, and take
> a spinlock, you have deadlocks even without userspace access.
> 

(Thanks for your resent, my first email was sent directly to you ... grml)

This is what happened on our side (very recent kernel):

spin_lock(&lock)
copy_to_user(...)
spin_unlock(&lock)

1. s390 locks/unlocks a spin lock with a compare and swap, using the _cpu id_
   as "old value"
2. we slept during copy_to_user()
3. the thread got scheduled onto another cpu
4. spin_unlock failed as the _cpu id_ didn't match (another cpu that locked
   the spinlock tried to unlocked it).
5. lock remained locked -> deadlock

Christian came up with the following explanation:
Without preemption, spin_lock() will not touch the preempt counter.
disable_pfault() will always touch it.

Therefore, with preemption disabled, copy_to_user() has no idea that it is
running in atomic context - and will therefore try to sleep.

So copy_to_user() will on s390:
1. run "as atomic" while spin_lock() with preemption enabled.
2. run "as not atomic" while spin_lock() with preemption disabled.
3.  run "as atomic" while pagefault_disabled() with preemption enabled or
disabled.
4. run "as not atomic" when really not atomic.

And exactly nr 2. is the thing that produced the deadlock in our scenario and
the reason why I want a might_sleep() :)

