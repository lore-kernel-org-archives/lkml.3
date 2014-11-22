Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaKVDk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 22:40:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbaKVDk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 22:40:28 -0500
Message-ID: <547005A0.8020208@redhat.com>
Date: Fri, 21 Nov 2014 22:40:16 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Davidlohr Bueso <dave@stgolabs.net>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Manfred Spraul <manfred@colorfullife.com>,
        Rafael Aquini <aquini@redhat.com>
Subject: Re: [PATCH] ipc,sem block sem_lock on sma->lock during sma initialization
References: <20141121145226.2ac598af@annuminas.surriel.com>	 <20141121120930.3cd8d0f233f9670d689de672@linux-foundation.org>	 <546FA0A7.2010507@redhat.com>	 <20141121124229.933a9b6ef9725a4032c95d45@linux-foundation.org>	 <546FC4D9.6010600@redhat.com> <1416617795.17594.14.camel@linux-t7sj.site>
In-Reply-To: <1416617795.17594.14.camel@linux-t7sj.site>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/21/2014 07:56 PM, Davidlohr Bueso wrote:
> On Fri, 2014-11-21 at 18:03 -0500, Rik van Riel wrote:

>> In other words, if you try to use a semaphore array before getsem
>> returns, you can oops the task that calls semop.
> 
> This seems bogus from an application level: how can you call semop
> if you don't have the semid yet returned from semget? And the fact
> that the race is with newary, means that the call is in fact
> creating a *new* set, as opposed to plugging into an already
> existing set.

Agreed, this is bogus from userspace.

However, userspace doing bogus things should not lead to a
kernel crash.

> The fix in newary() being before the actual creation of the id
> seems even stranger:
> 
> sma->complex_count = 1; id = ipc_addid(&sem_ids(ns),
> &sma->sem_perm, ns->sc_semmni);
> 
> As for semtimedop() before even getting to sem_lock(), we first
> call:
> 
> sma = sem_obtain_object_check(ns, semid);
> 
> So shouldn't that fail anyway before we even consider acquiring the
> lock?

newary initializes a bunch of things after the call to
ipc_addid, however some things are initialized inside
ipc_addid as well

Looking closer at newary, I suppose that it should be
possible to move those other initializations before
the call to ipc_addid.  That would likely get rid of
the problem, too.

However, I also see this line in newary, and I have
no idea what protects that data:

        ns->used_sems += nsems;

I don't see any locking around ns->used_sems for
simultaneous getsem & RMID...

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUcAWfAAoJEM553pKExN6D4n4H/jogtT4f/cWvMI4be3MlfE2x
sAIuC0Z6Fqqzm60XB2OB4/yIAZU1JDmsUrmUVqwh3R/G2mQygpkrM9ZKW4dkxtyd
MZ0IWtx74OSb376mDcmhk8vI8xh5/j/bWTx2oxP7IFZf4imVFGeZmlG/YLKGSnLS
lO9ehr9wkyzoyo1wgpuWhKdxDTEaeZd8C6Ij6bVylWybuWVripN9eX13vWyDmKJ8
P754efTIDu+PWCaEdNA7eKTMlydkXqjPwUpSnSE/bs2ngFhlAkZqkWmTEu54Wc32
yoyEqFNdMvAV8QCHLeR8Uqf53PNhncz7S7RfX58wgdQ5bKO3ATuJ8jbTT5ZXVZ8=
=xg+y
-----END PGP SIGNATURE-----
