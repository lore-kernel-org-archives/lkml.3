Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbaHMCk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 22:40:29 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:30251 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaHMCk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 22:40:28 -0400
Message-ID: <1407897625.4216.1.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ipc/sem.c: [RFC] memory barrier in sem_lock()
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@redhat.com>, 1vier1@web.de
Date: Tue, 12 Aug 2014 19:40:25 -0700
In-Reply-To: <1407872586-2738-1-git-send-email-manfred@colorfullife.com>
References: <1407872586-2738-1-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-12 at 21:43 +0200, Manfred Spraul wrote:
> sem_lock right now contains an smp_mb().
> I think smp_rmb() would be sufficient - and performance of semop() with rmb()
> is up to 10% faster. It would be a pairing of rmb() with spin_unlock().
> 
> The race we must protect against is:
> 
> sem->lock is free
> sma->complex_count = 0
> sma->sem_perm.lock held by thread B
> 
> thread A:
> 
> A: spin_lock(&sem->lock)
> 
> 			B: sma->complex_count++; (now 1)
> 			B: spin_unlock(&sma->sem_perm.lock);
> 
> A: spin_is_locked(&sma->sem_perm.lock);
> A: XXXXX which memory barrier is necessary?
> A: if (sma->complex_count == 0)
> 
> Thread A must read the increased complex_count value, i.e. the read must
> not be reordered with the read of sem_perm.lock done by spin_is_locked().
> 
> But that's it, there are no writes that must be ordered.

Looks right. You might also replace the current (useless) comment with
the patch's changelog, describing why the barrier is there.

Thanks,
Davidlohr

