Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaKWVDV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 16:03:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbaKWVDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 16:03:20 -0500
Message-ID: <54724B8A.8080607@redhat.com>
Date: Sun, 23 Nov 2014 16:03:06 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Rafael Aquini <aquini@redhat.com>,
        1vier1@web.de
Subject: Re: [PATCH] ipc,sem block sem_lock on sma->lock during sma initialization
References: <20141121145226.2ac598af@annuminas.surriel.com> <54722639.1040605@colorfullife.com>
In-Reply-To: <54722639.1040605@colorfullife.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/23/2014 01:23 PM, Manfred Spraul wrote:
> Hi Rik,
> 
> On 11/21/2014 08:52 PM, Rik van Riel wrote:
>> When manipulating just one semaphore with semop, sem_lock only
>> takes that single semaphore's lock. This creates a problem during
>> initialization of the semaphore array, when the data structures
>> used by sem_lock have not been set up yet. The sma->lock is
>> already held by newary, and we just have to make sure everything
>> else waits on that lock during initialization.
>> 
>> Luckily it is easy to make sem_lock wait on the sma->lock, by
>> pretending there is a complex operation in progress while the sma
>> is being initialized.
> That's not sufficient, as sma->sem_nsems is accessed before
> calling sem_lock(), both within find_alloc_undo() and within
> semtimedop().
> 
> The root problem is that sma->sem_nsems and sma->sem_base are
> accessed without any locks, this conflicts with the approach that
> sma starts to exist as not yet initialized but locked and is
> unlocked after the initialization is completed.
> 
> Attached is an idea. It did pass a few short tests. What do you
> think?

This was my other idea for fixing the issue; unfortunately
I didn't think of it until after I sent the first patch :)

You are right that without that change, we can return the
wrong error codes to userspace.

I will give the patch a try, though I have so far been unable
to reproduce the bug that the customer reported, so I am unlikely
to give much in the way of useful testing results...

Andrew, feel free to give Manfred's patch my

Acked-by: Rik van Riel <riel@redhat.com>

It closes off more things than my patch did, in a similar way
(doing something before ipc_addid)

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUckuKAAoJEM553pKExN6DfRoH/jjcBpLwKzrId8aFtuSWYgv3
I7LNzoGozb6Lvn1D1lt/sREdl74KIQptaVClQzphIubiAkQPJVgzqe43f01mqaPu
mSjGKarjfKXwUNfa+Q3pW7b2hnbdfTfyQDsTr6JhSpy0ynsmmNb1J2S7E2E2B40r
KbOETKeKRTq4vYCk4Em5S4OJg31AoXNoXMVwciOB0M/QDFCSB+4JdKrRsiz6Hm1o
+JlRtgwUY6m047Ur65MKeN1bkx1cgqK8tzayMpXW+PTI9cVs6153tlWXmQoXP+Co
lHrODmKkhOhJfOr3q0YvrwnaZOVKliKLVV0YkQ+6pi4SAqSjH7pV0jWr/FsaLIA=
=u6vO
-----END PGP SIGNATURE-----
