Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642Ab3DXXs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 19:48:27 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:49309 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757971Ab3DXXsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 19:48:23 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1366846719.1863.1.camel@buesod1.americas.hpqcorp.net>
References: <CA+icZUWXpaXi9GwB37hLaPbZaAi2aOMXez1f79DDtb_22ZY1jQ@mail.gmail.com>
	<CA+icZUXmsvbj2km=PxbAs5K+hoP+zjcXqG_wCdKR9akWF5Eucw@mail.gmail.com>
	<CA+55aFw5J+DFgQjAdhUnhitHw+wHEmspeZP9jbyZowqNE6Nafg@mail.gmail.com>
	<CA+icZUXHkcj_bAuPcfghZMHjRTud2jN91hjpOUiLaXd0yN9diw@mail.gmail.com>
	<1366741069.1802.12.camel@buesod1.americas.hpqcorp.net>
	<1366741394.1802.13.camel@buesod1.americas.hpqcorp.net>
	<CA+icZUV48SZeNt4GRKi8yDKbsO_c7ApUOgb4mRX67=d_ridE8w@mail.gmail.com>
	<CA+55aFxh_-3BSBXrm8j1-3bN_oLLA66ApykRcfFFKRvrb6MDkQ@mail.gmail.com>
	<1366841773.1790.7.camel@buesod1.americas.hpqcorp.net>
	<CA+icZUUY1U=gxxT8hbU-JyyuoRgaht=KUwttQT=yh4_Yh32VnQ@mail.gmail.com>
	<1366846719.1863.1.camel@buesod1.americas.hpqcorp.net>
Date: Thu, 25 Apr 2013 01:48:21 +0200
Message-ID: <CA+icZUXwfvCMhP0BJAcxNNMPuKELxav6QmN0MCfd-swRV+4g=g@mail.gmail.com>
Subject: Re: [PATCH -next] ipc: make refcounter atomic (was Re: linux-next:
 Tree for Apr 23 [ Call-Traces: lib/debugobjects.c | kernel/rcupdate.c |
 kernel/rcutree.c ])
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Paul McKenney <paul.mckenney@linaro.org>,
        Emmanuel Benisty <benisty.e@gmail.com>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 1:38 AM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> On Thu, 2013-04-25 at 01:05 +0200, Sedat Dilek wrote:
>> On Thu, Apr 25, 2013 at 12:16 AM, Davidlohr Bueso
>> <davidlohr.bueso@hp.com> wrote:
>> > From: Davidlohr Bueso <davidlohr.bueso@hp.com>
>> >
>> > Sedat reported an issue leading to a NULL dereference in update_queue():
>> >
>> > [  178.490583] BUG: spinlock bad magic on CPU#1, sh/8066
>> > [  178.490595]  lock: 0xffff88008b53ea18, .magic: 6b6b6b6b, .owner: make/8068, .owner_cpu: 3
>> > [  178.490599] BUG: unable to handle kernel NULL pointer dereference at           (null)
>> > [  178.490608] IP: [<ffffffff812bacd0>] update_queue+0x70/0x210
>> > [  178.490610] PGD 0
>> > [  178.490612] Oops: 0000 [#1] SMP
>> > ...
>> > [  178.490704] Call Trace:
>> > [  178.490710]  [<ffffffff812baf51>] do_smart_update+0xe1/0x140
>> > [  178.490713]  [<ffffffff812bd6e1>] exit_sem+0x2b1/0x350
>> > [  178.490718]  [<ffffffff8105de80>] do_exit+0x290/0xa70
>> > [  178.490721]  [<ffffffff8105e6f4>] do_group_exit+0x44/0xa0
>> > [  178.490724]  [<ffffffff8105e767>] SyS_exit_group+0x17/0x20
>> > [  178.490728]  [<ffffffff816ce15d>] system_call_fastpath+0x1a/0x1f
>> >
>> > Linus pin-pointed the problem to a race in the reference counter. To quote:
>> >
>> > "That dmesg spew very much implies that the same RCU head got added twice to the RCU
>> > freeing list, and the only way that happens is if the refcount goes to
>> > zero twice. Which implies that either we increment a zero, or we lack
>> > locking and the coherency of the non-atomic access goes away."
>> >
>> > This patch converts the IPC RCU header's reference counter to atomic_t. The return of
>> > ipc_rcu_getref() is modified to inform the callers if it actually succeeded.
>> >
>> > Now all callers return -EIDRM upon failure and abort the current operation. Two exceptions are
>> > in semaphore code where sem_getref_and_unlock() and sem_getref() trigger a warning but proceed
>> > to freeing up any held locks.
>> >
>> > Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
>> > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
>> > CC: Rik van Riel <riel@surriel.com>
>> > CC: Paul McKenney <paul.mckenney@linaro.org>
>> > CC: Sedat Dilek <sedat.dilek@gmail.com>
>> > CC: Emmanuel Benisty <benisty.e@gmail.com>
>> > CC: Andrew Morton <akpm@linux-foundation.org>
>>
>> Missing my Reported-by ...!
>
> Not trying to take away credit or efforts from you, just wanted you to
> reconfirm that *this* actual patch fixes things for you :)
>

No, I am not of those "bad guys" in OSS.
I would not have invested so much time in helping to get this fixed.

Did my usual test-case:
A kernel-rebuild within same kernel-environment with no breakage or
abnormalities in the logs.

Hope I could help.

- Sedat -

> Thanks,
> Davidlohr
>
