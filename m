Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab3CASSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 13:18:36 -0500
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:20017 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3CASSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 13:18:34 -0500
Message-ID: <1362161912.12277.10.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket
 lock out of line
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        linux-tip-commits@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>
Date: Fri, 01 Mar 2013 10:18:32 -0800
In-Reply-To: <51304DDA.40808@redhat.com>
References: <20130206150403.006e5294@cuia.bos.redhat.com>
	 <511C24A6.8020409@redhat.com>
	 <CA+55aFws80EEJQskqiP+a5J-HOGu=M1Fe=uCs50ifedVxPxT1Q@mail.gmail.com>
	 <512E376D.70105@redhat.com>
	 <CA+55aFzPxJ3rfZvAvrP9LxCXfDU8AAVvhMZnP-OAoe-ycc70aw@mail.gmail.com>
	 <512E6443.9050603@redhat.com>
	 <CA+55aFwHxv9RH75BoXYcwdKeHx+otOOpg9494TTdFwQe3biOhw@mail.gmail.com>
	 <512E80E3.7060800@redhat.com>
	 <CA+55aFwa0EjGG2NUDYVLVBmXJa2k81YiuNO2yggk=GLRQxhhUQ@mail.gmail.com>
	 <512EC7F0.60103@redhat.com>
	 <1362024397.1867.28.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFygzjuNYiG4MTPMzimEjQ92rpS-rNJr7HD4OQCAqze5zg@mail.gmail.com>
	 <512F7429.4020103@redhat.com>
	 <CA+55aFw3t+sC-zv6njxdJ6hB0arJnZzoGNO9W7o8h=tcUo5P_Q@mail.gmail.com>
	 <CA+55aFwEshukBGU5YCtKL=7c-43guMuGSHTnXo02rLxZWGQWTw@mail.gmail.com>
	 <512FC89B.6030507@redhat.com>
	 <CA+55aFxbm83Oc2g55868HA2xCytsJzTxWGE0w_pMUzKaU5mJMw@mail.gmail.com>
	 <512FDC82.2060606@redhat.com>
	 <CA+55aFyitxgooTYq27eK4fO___R4uRrNhoPwDWxULeUkejH0ZA@mail.gmail.com>
	 <51304DDA.40808@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-01 at 01:42 -0500, Rik van Riel wrote:
> On 02/28/2013 06:09 PM, Linus Torvalds wrote:
> 
> > So I almost think that *everything* there in the semaphore code could
> > be done under RCU. The actual spinlock doesn't seem to much matter, at
> > least for semaphores. The semaphore values themselves seem to be
> > protected by the atomic operations, but I might be wrong about that, I
> > didn't even check.
> 
> Checking try_atomic_semop and do_smart_update, it looks like neither
> is using atomic operations. That part of the semaphore code would
> still benefit from spinlocks.

Agreed.

> 
> The way the code handles a whole batch of semops all at once,
> potentially to multiple semaphores at once, and with the ability
> to undo all of the operations, it looks like the spinlock will
> still need to be per block of semaphores.
> 
> I guess the code may still benefit from Michel's locking code,
> after the permission stuff has been moved from under the spinlock.

How about splitting ipc_lock()/ipc_lock_control() in two calls: one to
obtain the ipc object (rcu_read_lock + idr_find), which can be called
when performing the permissions and security checks, and another to
obtain the ipcp->lock [q_]spinlock when necessary.


