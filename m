Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab3CAGnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 01:43:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab3CAGm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 01:42:59 -0500
Message-ID: <51304DDA.40808@redhat.com>
Date: Fri, 01 Mar 2013 01:42:34 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>,
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
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket
 lock out of line
References: <20130206150403.006e5294@cuia.bos.redhat.com> <511C24A6.8020409@redhat.com> <CA+55aFws80EEJQskqiP+a5J-HOGu=M1Fe=uCs50ifedVxPxT1Q@mail.gmail.com> <512E376D.70105@redhat.com> <CA+55aFzPxJ3rfZvAvrP9LxCXfDU8AAVvhMZnP-OAoe-ycc70aw@mail.gmail.com> <512E6443.9050603@redhat.com> <CA+55aFwHxv9RH75BoXYcwdKeHx+otOOpg9494TTdFwQe3biOhw@mail.gmail.com> <512E80E3.7060800@redhat.com> <CA+55aFwa0EjGG2NUDYVLVBmXJa2k81YiuNO2yggk=GLRQxhhUQ@mail.gmail.com> <512EC7F0.60103@redhat.com> <1362024397.1867.28.camel@buesod1.americas.hpqcorp.net> <CA+55aFygzjuNYiG4MTPMzimEjQ92rpS-rNJr7HD4OQCAqze5zg@mail.gmail.com> <512F7429.4020103@redhat.com> <CA+55aFw3t+sC-zv6njxdJ6hB0arJnZzoGNO9W7o8h=tcUo5P_Q@mail.gmail.com> <CA+55aFwEshukBGU5YCtKL=7c-43guMuGSHTnXo02rLxZWGQWTw@mail.gmail.com> <512FC89B.6030507@redhat.com> <CA+55aFxbm83Oc2g55868HA2xCytsJzTxWGE0w_pMUzKaU5mJMw@mail.gmail.com> <512FDC82.2060606@redhat.com> <CA+55aFyitxgooTYq27eK4fO___R4uRrNhoPwDWxULeUkejH0ZA@mail.gmail.com>
In-Reply-To: <CA+55aFyitxgooTYq27eK4fO___R4uRrNhoPwDWxULeUkejH0ZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 06:09 PM, Linus Torvalds wrote:

> So I almost think that *everything* there in the semaphore code could
> be done under RCU. The actual spinlock doesn't seem to much matter, at
> least for semaphores. The semaphore values themselves seem to be
> protected by the atomic operations, but I might be wrong about that, I
> didn't even check.

Checking try_atomic_semop and do_smart_update, it looks like neither
is using atomic operations. That part of the semaphore code would
still benefit from spinlocks.

The way the code handles a whole batch of semops all at once,
potentially to multiple semaphores at once, and with the ability
to undo all of the operations, it looks like the spinlock will
still need to be per block of semaphores.

I guess the code may still benefit from Michel's locking code,
after the permission stuff has been moved from under the spinlock.

Two remaining worries are the security_sem_free call and the
non-RCU list_del calls from freeary, called from the SEM_RMID
code. They are probably fine, but worth another pair of eyes...

-- 
All rights reversed
