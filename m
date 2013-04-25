Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab3DYBiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 21:38:18 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:43334 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab3DYBiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 21:38:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130420223413.GB15927@kroah.com>
References: <1366421634-20773-1-git-send-email-anatol.pomozov@gmail.com>
	<1366474510-9427-1-git-send-email-anatol.pomozov@gmail.com>
	<20130420223413.GB15927@kroah.com>
Date: Wed, 24 Apr 2013 18:38:15 -0700
Message-ID: <CAOMFOmUY=XbVbuM8awWfib-3DqpQPF1cf+nz7iuRUdMDwz6Ovg@mail.gmail.com>
Subject: Re: [PATCH] kref: minor cleanup
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sat, Apr 20, 2013 at 3:34 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sat, Apr 20, 2013 at 09:15:10AM -0700, Anatol Pomozov wrote:
>> Follow-up for https://lkml.org/lkml/2013/4/12/391
>
> That's not needed in a changelog comment.
>
>> * make warning smp-safe
>> * result of atomic _unless_zero functions should be checked by caller
>>     to avoid use-after-free error
>
> You also do other things you don't list here.
>
>>
>> Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
>> ---
>>  include/linux/kobject.h | 1 +
>>  include/linux/kref.h    | 9 ++++++---
>>  lib/kobject.c           | 2 +-
>>  3 files changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/kobject.h b/include/linux/kobject.h
>> index 939b112..bfad936 100644
>> --- a/include/linux/kobject.h
>> +++ b/include/linux/kobject.h
>> @@ -101,6 +101,7 @@ extern int __must_check kobject_rename(struct kobject *, const char *new_name);
>>  extern int __must_check kobject_move(struct kobject *, struct kobject *);
>>
>>  extern struct kobject *kobject_get(struct kobject *kobj);
>> +extern struct kobject * __must_check kobject_get_unless_zero(struct kobject *kobj);
>
> Don't add apis that no one uses.

I am puzzled should I add the function to *.h or not? From my point of
view this function might be useful for other people.

But in any case "__must_check" should be added to the function
signature. Users suppose to check the return value otherwise they
might have use-after-free race condition.

> And even if you did, you forgot to export it to modules :(
>
>
>>  extern void kobject_put(struct kobject *kobj);
>>
>>  extern char *kobject_get_path(struct kobject *kobj, gfp_t flag);
>> diff --git a/include/linux/kref.h b/include/linux/kref.h
>> index 4972e6e..817d7f1 100644
>> --- a/include/linux/kref.h
>> +++ b/include/linux/kref.h
>> @@ -39,8 +39,11 @@ static inline void kref_init(struct kref *kref)
>>   */
>>  static inline void kref_get(struct kref *kref)
>>  {
>> -     WARN_ON(!atomic_read(&kref->refcount));
>> -     atomic_inc(&kref->refcount);
>> +     /* If refcount was 0 before incrementing then we have a race
>> +      * condition when this kref is freeing by some other thread right now.
>> +      * In this case one should use kref_get_unless_zero()
>> +      */
>
> Did you use scripts/checkpatch.pl?
>
>> +     WARN_ON(atomic_inc_return(&kref->refcount) < 2);
>
> As this is just a warning, I really doubt this type of change is needed

Warning is needed. And the check should be SMP-safe to avoid situation
when kref_put happens between refcount check and refcount increment.

> have you ever hit it?
> This is to catch people who forget to initialize a kref before doing the
> first kref_get(), it's a help in debugging their code, nothing
> "critical".

Users also hit this warning they when try to kobject_get() an element
that has refcount equal to zero (i.e. kobject in destroy path). One
situation when it might happen is iterating kset->list and the element
is removing by someone else. In this situation object is visible in
the list but one cannot use it as it is destroying right now. If one
tries to use it it'll get use-after-free bug. On debug kernel with
DEBUG_PAGEALLOC enabled it will cause a crash, without the flag it
will silently use corrupted data.

Having this warning (+ my comment) will at least give developers a
clue what is going on here.
