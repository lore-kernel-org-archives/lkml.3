Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbaAPGqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 01:46:25 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:4508 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaAPGqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 01:46:23 -0500
Message-ID: <1389854777.2126.20.camel@j-VirtualBox>
Subject: Re: [RFC 3/3] mutex: When there is no owner, stop spinning after
 too many tries
From: Jason Low <jason.low2@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Peter Anvin <hpa@zytor.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Date: Wed, 15 Jan 2014 22:46:17 -0800
In-Reply-To: <CA+55aFwszXHtjOW53eBLV4aMD-cv0dg7xyBa0BtN1LS4XajwLw@mail.gmail.com>
References: <1389745990-7069-1-git-send-email-jason.low2@hp.com>
	 <1389745990-7069-4-git-send-email-jason.low2@hp.com>
	 <1389840330.2944.104.camel@j-VirtualBox>
	 <CA+55aFwszXHtjOW53eBLV4aMD-cv0dg7xyBa0BtN1LS4XajwLw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-16 at 10:14 +0700, Linus Torvalds wrote:
> On Thu, Jan 16, 2014 at 9:45 AM, Jason Low <jason.low2@hp.com> wrote:
> >
> > Any comments on the below change which unlocks the mutex before taking
> > the lock->wait_lock to wake up a waiter? Thanks.
> 
> Hmm. Doesn't that mean that a new lock owner can come in *before*
> you've called debug_mutex_unlock and the lockdep stuff, and get the
> lock? And then debug_mutex_lock() will be called *before* the unlocker
> called debug_mutex_unlock(), which I'm sure confuses things.

If obtaining the wait_lock for debug_mutex_unlock is the issue, then
perhaps we can address that by taking care of
#ifdef CONFIG_DEBUG_MUTEXES. In the CONFIG_DEBUG_MUTEXES case, we can
take the wait_lock first, and in the regular case, take the wait_lock
after releasing the mutex.

#ifdef CONFIG_DEBUG_MUTEXES
	spin_lock_mutex(&lock->wait_lock, flags);
#endif

        mutex_release(&lock->dep_map, nested, _RET_IP_);
        debug_mutex_unlock(lock);
        if (__mutex_slowpath_needs_to_unlock())
                atomic_set(&lock->count, 1);

#ifndef CONFIG_DEBUG_MUTEXES
	spin_lock_mutex(&lock->wait_lock, flags);
#endif

