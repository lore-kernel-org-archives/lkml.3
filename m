Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaB1MuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 07:50:12 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:52459 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751157AbaB1MuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 07:50:10 -0500
Message-ID: <531085FE.2050902@hurleysoftware.com>
Date: Fri, 28 Feb 2014 07:50:06 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>, Davidlohr Bueso <davidlohr@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rkuo@codeaurora.org" <rkuo@codeaurora.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "paulus@samba.org" <paulus@samba.org>
Subject: Re: [PATCH 1/2] asm-generic: rwsem: ensure sem->cnt is only accessed
 via atomic_long_*
References: <1393003347-24958-1-git-send-email-will.deacon@arm.com> <1393478904.3884.6.camel@buesod1.americas.hpqcorp.net> <20140228121314.GC674@mudshark.cambridge.arm.com>
In-Reply-To: <20140228121314.GC674@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2014 07:13 AM, Will Deacon wrote:
> On Thu, Feb 27, 2014 at 05:28:24AM +0000, Davidlohr Bueso wrote:
>> On Fri, 2014-02-21 at 17:22 +0000, Will Deacon wrote:
>>> The asm-generic rwsem implementation directly acceses sem->cnt when
>>> performing a __down_read_trylock operation. Whilst this is probably safe
>>> on all architectures, we should stick to the atomic_long_* API and use
>>> atomic_long_read instead.
>>>
>>> Signed-off-by: Will Deacon <will.deacon@arm.com>
>>> ---
>>>   include/asm-generic/rwsem.h | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/include/asm-generic/rwsem.h b/include/asm-generic/rwsem.h
>>> index bb1e2cdeb9bf..75af612f54f8 100644
>>> --- a/include/asm-generic/rwsem.h
>>> +++ b/include/asm-generic/rwsem.h
>>> @@ -41,7 +41,7 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
>>>   {
>>>   	long tmp;
>>>
>>> -	while ((tmp = sem->count) >= 0) {
>>> +	while ((tmp = atomic_long_read((atomic_long_t *)&sem->count)) >= 0) {
>>
>> That's pretty ugly, how about having infinite look and just do the tmp
>> assign separately from the conditional?
>>
>> It also looks like a cpu_relax() could help here between iterations.

This is the read trylock so no cpu_relax().

>> Other than that:
>>
>> Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>
>
> Actually, we should make that cmpxchg an atomic_long_cmpxchg, so the extra
> diff ends up looking like below. It's ugly adding a cpu_relax(), since you
> only want it when the cmpxchg fails (and we don't have such logic in the
> asm-generic __atomic_add_unless, for example).
>
> Will
>
> --->8
>
> diff --git a/include/asm-generic/rwsem.h b/include/asm-generic/rwsem.h
> index 603a0a11e592..2b6401f9e428 100644
> --- a/include/asm-generic/rwsem.h
> +++ b/include/asm-generic/rwsem.h
> @@ -40,14 +40,16 @@ static inline void __down_read(struct rw_semaphore *sem)
>   static inline int __down_read_trylock(struct rw_semaphore *sem)
>   {
>          long tmp;
> +       atomic_long_t *cnt = (atomic_long_t *)&sem->count;

The shared rwsem failure paths (kernel/locking/rwsem_xadd.c) peek at
sem->count as long type, so this isn't really necessary.

>
> -       while ((tmp = atomic_long_read((atomic_long_t *)&sem->count)) >= 0) {
> -               if (tmp == cmpxchg(&sem->count, tmp,
> -                                  tmp + RWSEM_ACTIVE_READ_BIAS)) {
> -                       return 1;
> -               }
> -       }
> -       return 0;
> +       do {
> +               tmp = atomic_long_read(cnt);
> +               if (tmp < 0)
> +                       return 0;
> +       } while (tmp != atomic_long_cmpxchg(cnt, tmp,
> +                                           tmp + RWSEM_ACTIVE_READ_BIAS));
> +
> +       return 1;
>   }

Regards,
Peter Hurley
