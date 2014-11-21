Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaKUXED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 18:04:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbaKUXEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 18:04:01 -0500
Message-ID: <546FC4D9.6010600@redhat.com>
Date: Fri, 21 Nov 2014 18:03:53 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Rafael Aquini <aquini@redhat.com>
Subject: Re: [PATCH] ipc,sem block sem_lock on sma->lock during sma initialization
References: <20141121145226.2ac598af@annuminas.surriel.com>	<20141121120930.3cd8d0f233f9670d689de672@linux-foundation.org>	<546FA0A7.2010507@redhat.com> <20141121124229.933a9b6ef9725a4032c95d45@linux-foundation.org>
In-Reply-To: <20141121124229.933a9b6ef9725a4032c95d45@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/21/2014 03:42 PM, Andrew Morton wrote:
> On Fri, 21 Nov 2014 15:29:27 -0500 Rik van Riel <riel@redhat.com>
> wrote:
> 
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
>>> 
>>> What are the runtime effects of the bug?
>>> 
>> 
>> NULL pointer dereference in spin_lock from sem_lock, if it is
>> called before sma->sem_base has been pointed somewhere valid.
> 
> Help us out here.  People need to use this description to work out 
> which kernel versions need the patch and whether to backport the
> fix into their various kernels.  Other people will be starting at
> this changelog wondering "will this fix the bug my customer has
> reported".
> 
> Is there some bug report people can look at?
> 
> What userspace actions trigger this bug?

The reason the bug took almost two years to get noticed is that
it takes one task doing a semop on a semaphore in an array that
is still getting instantiated by newary (getsem) from another
task.

In other words, if you try to use a semaphore array before
getsem returns, you can oops the task that calls semop.

It should not cause any damage to long-living kernel data
structures.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUb8TZAAoJEM553pKExN6DzJUH/RYSovikk+36KH0uFQN44txj
ZkEM6BsT7I6W9zBiK4OCPpwYCr5gy2xsXH7bLzCgzRV/YmjLFdw20DhDfSo14GO/
1ByYcsUcsZ+lPJZ+g4IKi57VW4T+NLa1T4CoJ84+1QVGKYlpc7mlwc8suTGBhKvQ
5Eq1o1KOE9ZtAG5Go8OYH7frwalkrYE0YJbGN9PW0pUvZ7FilEiMJIkznIetRS6K
WK05dK52DMKeXFxzuxVhSRcCZb2+bHZn3qFOmon6kHbMqgzRZCKMcdydtoIvcFq7
cA5eTt6V6je3XVhc4lsSfP9cHraLDZZIjkaJ856fBpgJ30ypsHcpVY6UKTbFSHo=
=u1Vg
-----END PGP SIGNATURE-----
