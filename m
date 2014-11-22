Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaKVUOu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 15:14:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbaKVUOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 15:14:48 -0500
Message-ID: <5470EEAB.4050106@redhat.com>
Date: Sat, 22 Nov 2014 15:14:35 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Davidlohr Bueso <davidlohr@hp.com>, Rafael Aquini <aquini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ipc,sem block sem_lock on sma->lock during sma initialization
References: <20141121145226.2ac598af@annuminas.surriel.com> <20141121120930.3cd8d0f233f9670d689de672@linux-foundation.org> <546FA0A7.2010507@redhat.com> <5470E0AC.50609@colorfullife.com>
In-Reply-To: <5470E0AC.50609@colorfullife.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/22/2014 02:14 PM, Manfred Spraul wrote:
> On 11/21/2014 09:29 PM, Rik van Riel wrote:
>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA1
>> 
>> On 11/21/2014 03:09 PM, Andrew Morton wrote:
>>> On Fri, 21 Nov 2014 14:52:26 -0500 Rik van Riel
>>> <riel@redhat.com> wrote:
>>> 
>>>> When manipulating just one semaphore with semop, sem_lock
>>>> only takes that single semaphore's lock. This creates a
>>>> problem during initialization of the semaphore array, when
>>>> the data structures used by sem_lock have not been set up
>>>> yet. The sma->lock is already held by newary, and we just
>>>> have to make sure everything else waits on that lock during
>>>> initialization.
>>>> 
>>>> Luckily it is easy to make sem_lock wait on the sma->lock,
>>>> by pretending there is a complex operation in progress while
>>>> the sma is being initialized.
>>>> 
>>>> The newary function already zeroes sma->complex_count before 
>>>> unlocking the sma->lock.
>>> What are the runtime effects of the bug?
>>> 
>> NULL pointer dereference in spin_lock from sem_lock, if it is
>> called before sma->sem_base has been pointed somewhere valid.
> No, this can't happen: - sma is initialized to 0 with memset() -
> sma->sem_nsems is set last. - semtimedop() contains a "max >=
> sma->sem_nsems".
> 
> with sma->sem_nsems==0, this will always fail and therefore
> sem_lock() can't be reached.

You're right. The reported race must have been semop vs RMID.

The kernel tree in question was missing this changeset:

commit 6e224f94597842c5eb17f1fc2208d20b6f7f7d49
Author: Manfred Spraul <manfred@colorfullife.com>
Date:   Wed Oct 16 13:46:45 2013 -0700

    ipc/sem.c: synchronize semop and semctl with IPC_RMID


- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEbBAEBAgAGBQJUcO6rAAoJEM553pKExN6DPXkH+Ot5H94no3DJ6b1WdhOhDMUM
sQaWErEcSJ2dxzVES4WUMzqnnEZPokG2uK4z2PVUWjE+YA1U7hGfctLg/Eabr5tV
tD+uZhrbSbJVT7HiS5wyqmyzCV5eUV+2Am19pqwa6gyfB30cAYA/GtYfnMhKRGR0
l9hcvyzhci59d/2V2/Y5cGrxvQaWued33JZYfjp2TCl1GDpPD1bocptc3BO0DbwO
iHMZBcWfjR5t/EJ2Pg9gwu8X4C7amHsaNM58yTU6o93dE4bpS//A7WtwlLHJ/WEE
tD9zoOMnv7o8B5AHl3UDUJJ+JjieQU498AC3IganXQE8WrsZMJWZXo1OZtQP7A==
=vZEa
-----END PGP SIGNATURE-----
