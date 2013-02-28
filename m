Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab3B1WkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 17:40:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab3B1Wj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 17:39:58 -0500
Message-ID: <512FDC82.2060606@redhat.com>
Date: Thu, 28 Feb 2013 17:38:58 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
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
References: <20130206150403.006e5294@cuia.bos.redhat.com> <511C1204.9040608@redhat.com> <CA+55aFwxYK-BLH0crhySHaQvAYHOH-VGUi7WTd1aq-24+WTDYw@mail.gmail.com> <511C24A6.8020409@redhat.com> <CA+55aFws80EEJQskqiP+a5J-HOGu=M1Fe=uCs50ifedVxPxT1Q@mail.gmail.com> <512E376D.70105@redhat.com> <CA+55aFzPxJ3rfZvAvrP9LxCXfDU8AAVvhMZnP-OAoe-ycc70aw@mail.gmail.com> <512E6443.9050603@redhat.com> <CA+55aFwHxv9RH75BoXYcwdKeHx+otOOpg9494TTdFwQe3biOhw@mail.gmail.com> <512E80E3.7060800@redhat.com> <CA+55aFwa0EjGG2NUDYVLVBmXJa2k81YiuNO2yggk=GLRQxhhUQ@mail.gmail.com> <512EC7F0.60103@redhat.com> <1362024397.1867.28.camel@buesod1.americas.hpqcorp.net> <CA+55aFygzjuNYiG4MTPMzimEjQ92rpS-rNJr7HD4OQCAqze5zg@mail.gmail.com> <512F7429.4020103@redhat.com> <CA+55aFw3t+sC-zv6njxdJ6hB0arJnZzoGNO9W7o8h=tcUo5P_Q@mail.gmail.com> <CA+55aFwEshukBGU5YCtKL=7c-43guMuGSHTnXo02rLxZWGQWTw@mail.gmail.com> <512FC89B.6030507@redhat.com> <CA+55aFxbm83Oc2g55868HA2xCytsJzTxWGE0w_pMUzKaU5mJMw@mail.gmail.com>
In-Reply-To: <CA+55aFxbm83Oc2g55868HA2xCytsJzTxWGE0w_pMUzKaU5mJMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 04:58 PM, Linus Torvalds wrote:

> I'm not seeing any real reason the permission checking couldn't be
> done just under the RCU lock, before we get the spinlock. Except for
> the fact that the "helper" routines in ipc/util.c are written the way
> they are, so it's a layering violation. But I really think that would
> be a *reasonably* low-hanging fruit thing to do.

I could see doing the permission checks under a seq lock.

If the permissions, or any other aspect of the semaphore
array changed while we were doing our permission check,
we can simply jump back to the top of the function and
try again.

Protection against IPC_RMID (removal of the semaphore
block) can probably be done with RCU.

The ugliness of using two kinds of protection may be
necessary, since permissions can be modified in-place,
and RCU does not seem to do in-place modification...

I have been staring at the code for a bit this afternoon,
and have yet to come up with a nicer idea :(

I am always open to suggestions, though :)

> Changing the locking itself to be more fine-grained, and doing it
> across many different ipc semaphores would be a major pain. So I do
> suspect that the work Michel Lespinasse did is probably worth doing
> anyway in addition to at least trying to fix the horrible lack of
> scalability of the code a bit.

That would certainly be the easy fix.

