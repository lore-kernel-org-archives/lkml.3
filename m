Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab3DTE10 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 00:27:26 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:51179 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab3DTE1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 00:27:25 -0400
MIME-Version: 1.0
In-Reply-To: <20130420022415.GA24713@kroah.com>
References: <1366421634-20773-1-git-send-email-anatol.pomozov@gmail.com>
	<20130420022415.GA24713@kroah.com>
Date: Fri, 19 Apr 2013 21:27:20 -0700
Message-ID: <CAOMFOmU2ig8JXb_+YtQGHkU5+c19S7Y=qWXjb+0HE1TwmLO3kw@mail.gmail.com>
Subject: Re: [PATCH] kref: minor cleanup
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Apr 19, 2013 at 7:24 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Apr 19, 2013 at 06:33:54PM -0700, Anatol Pomozov wrote:
>> Follow-up for https://lkml.org/lkml/2013/4/12/391
>>
>> * make warning smp-safe
>> * result of atomic _unless_zero functions should be checked by caller
>>     to avoid use-after-free error
>>
>> Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
>> ---
>>  include/linux/kref.h | 9 ++++++---
>>  lib/kobject.c        | 3 ++-
>>  2 files changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/kref.h b/include/linux/kref.h
>> index 4972e6e..092529a 100644
>> --- a/include/linux/kref.h
>> +++ b/include/linux/kref.h
>> @@ -39,8 +39,11 @@ static inline void kref_init(struct kref *kref)
>>   */
>>  static inline void kref_get(struct kref *kref)
>>  {
>> -     WARN_ON(!atomic_read(&kref->refcount));
>> -     atomic_inc(&kref->refcount);
>> +     /* If refcount was 0 before incrementing then we have a race
>> +      * condition when this kref is freing by some other thread right now.
>> +      * In this case one should use kref_get_unless_zero()
>> +      */
>> +     WARN_ON(atomic_inc_return(&kref->refcount) < 2);
>
> What happens if you disable WARN_ON(), does the atomic_inc_return() go
> away as well?  Or did we fix that?

If we disable warnings then expression still evaluated, this is true
for BUG_ON as well. It is how the functions are implemented now.

Tejun Heo once mentioned that such behavior is specification of the
functions. So I believe it is safe to execute code inside WARN_ON.

>>  /**
>> @@ -100,7 +103,7 @@ static inline int kref_put_mutex(struct kref *kref,
>>                                struct mutex *lock)
>>  {
>>       WARN_ON(release == NULL);
>> -        if (unlikely(!atomic_add_unless(&kref->refcount, -1, 1))) {
>> +     if (unlikely(!atomic_add_unless(&kref->refcount, -1, 1))) {
>>               mutex_lock(lock);
>>               if (unlikely(!atomic_dec_and_test(&kref->refcount))) {
>>                       mutex_unlock(lock);
>> diff --git a/lib/kobject.c b/lib/kobject.c
>> index a654866..bbd7362 100644
>> --- a/lib/kobject.c
>> +++ b/lib/kobject.c
>> @@ -529,7 +529,8 @@ struct kobject *kobject_get(struct kobject *kobj)
>>       return kobj;
>>  }
>>
>> -static struct kobject *kobject_get_unless_zero(struct kobject *kobj)
>> +static struct kobject *__must_check kobject_get_unless_zero(
>> +             struct kobject *kobj)
>
> __must_check needs to be in the .h file, not the .c file.

This function is static and defined in *.c. But I think the function
should be declared in *.h as it might be useful for others. I'll
resend patch tomorrow.
