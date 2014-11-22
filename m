Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbaKVTO5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 14:14:57 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:62338 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbaKVTO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 14:14:56 -0500
Message-ID: <5470E0AC.50609@colorfullife.com>
Date: Sat, 22 Nov 2014 20:14:52 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Davidlohr Bueso <davidlohr@hp.com>, Rafael Aquini <aquini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ipc,sem block sem_lock on sma->lock during sma initialization
References: <20141121145226.2ac598af@annuminas.surriel.com> <20141121120930.3cd8d0f233f9670d689de672@linux-foundation.org> <546FA0A7.2010507@redhat.com>
In-Reply-To: <546FA0A7.2010507@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2014 09:29 PM, Rik van Riel wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 11/21/2014 03:09 PM, Andrew Morton wrote:
>> On Fri, 21 Nov 2014 14:52:26 -0500 Rik van Riel <riel@redhat.com>
>> wrote:
>>
>>> When manipulating just one semaphore with semop, sem_lock only
>>> takes that single semaphore's lock. This creates a problem during
>>> initialization of the semaphore array, when the data structures
>>> used by sem_lock have not been set up yet. The sma->lock is
>>> already held by newary, and we just have to make sure everything
>>> else waits on that lock during initialization.
>>>
>>> Luckily it is easy to make sem_lock wait on the sma->lock, by
>>> pretending there is a complex operation in progress while the sma
>>> is being initialized.
>>>
>>> The newary function already zeroes sma->complex_count before
>>> unlocking the sma->lock.
>> What are the runtime effects of the bug?
>>
> NULL pointer dereference in spin_lock from sem_lock,
> if it is called before sma->sem_base has been pointed
> somewhere valid.
No, this can't happen:
- sma is initialized to 0 with memset()
- sma->sem_nsems is set last.
- semtimedop() contains a "max >= sma->sem_nsems".

with sma->sem_nsems==0, this will always fail and therefore sem_lock() 
can't be reached.

The only misbehavior (apart from returning -EFBIG) is that 
find_alloc_undo() could allocate a wrong-sized undo structure.
Would cause random memory corruptions - but not NULL pointer dereference.

Which which kernel version have you seen the NULL pointer dereference?

--
     Manfred
