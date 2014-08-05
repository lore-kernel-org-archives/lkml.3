Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaHEVrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 17:47:00 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:52149 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbaHEVq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 17:46:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140806074430.102121ae@notabene.brown>
References: <1407268348-25949-1-git-send-email-steven@uplinklabs.net>
	<20140806074430.102121ae@notabene.brown>
Date: Tue, 5 Aug 2014 14:46:55 -0700
Message-ID: <CAKbGBLgh+qHu3zC=qD1CYRFbmdkci6GE-0MZ=wS3EqeQuh8YbQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] lockref: make lockref count signed
From: Steven Noonan <steven@uplinklabs.net>
To: NeilBrown <neilb@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2014 at 2:44 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue,  5 Aug 2014 12:52:27 -0700 Steven Noonan <steven@uplinklabs.net>
> wrote:
>
>> There are numerous places where this is casted to a signed value anyway, for
>> comparisons checking that the value hasn't been set to the 'dead' value of
>> -128. This change turns the count value into a signed integer, which is how
>> it's already being treated anyway. This reduces the chance for developer errors
>> when making those comparisons.
>>
>> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
>> Cc: NeilBrown <neilb@suse.de>
>> Cc: Al Viro <viro@ZenIV.linux.org.uk>
>> Signed-off-by: Steven Noonan <steven@uplinklabs.net>
>
> Thanks!  But you missed one "(int)" removal :-)
>
> fs/autofs4/root.c:              if ((int) d_count(active) <= 0)

Ahh, yeah. The return type of d_count() also needs to be fixed up.
I'll send a new version in a few minutes...

> NeilBrown
>
>> ---
>>  fs/dcache.c             | 6 +++---
>>  include/linux/lockref.h | 2 +-
>>  lib/lockref.c           | 4 ++--
>>  3 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/dcache.c b/fs/dcache.c
>> index 06f6585..f7a592e 100644
>> --- a/fs/dcache.c
>> +++ b/fs/dcache.c
>> @@ -479,7 +479,7 @@ static void __dentry_kill(struct dentry *dentry)
>>        * dentry_iput drops the locks, at which point nobody (except
>>        * transient RCU lookups) can reach this dentry.
>>        */
>> -     BUG_ON((int)dentry->d_lockref.count > 0);
>> +     BUG_ON(dentry->d_lockref.count > 0);
>>       this_cpu_dec(nr_dentry);
>>       if (dentry->d_op && dentry->d_op->d_release)
>>               dentry->d_op->d_release(dentry);
>> @@ -532,7 +532,7 @@ static inline struct dentry *lock_parent(struct dentry *dentry)
>>       struct dentry *parent = dentry->d_parent;
>>       if (IS_ROOT(dentry))
>>               return NULL;
>> -     if (unlikely((int)dentry->d_lockref.count < 0))
>> +     if (unlikely(dentry->d_lockref.count < 0))
>>               return NULL;
>>       if (likely(spin_trylock(&parent->d_lock)))
>>               return parent;
>> @@ -848,7 +848,7 @@ static void shrink_dentry_list(struct list_head *list)
>>                * We found an inuse dentry which was not removed from
>>                * the LRU because of laziness during lookup. Do not free it.
>>                */
>> -             if ((int)dentry->d_lockref.count > 0) {
>> +             if (dentry->d_lockref.count > 0) {
>>                       spin_unlock(&dentry->d_lock);
>>                       if (parent)
>>                               spin_unlock(&parent->d_lock);
>> diff --git a/include/linux/lockref.h b/include/linux/lockref.h
>> index 4bfde0e..8558ff1 100644
>> --- a/include/linux/lockref.h
>> +++ b/include/linux/lockref.h
>> @@ -28,7 +28,7 @@ struct lockref {
>>  #endif
>>               struct {
>>                       spinlock_t lock;
>> -                     unsigned int count;
>> +                     int count;
>>               };
>>       };
>>  };
>> diff --git a/lib/lockref.c b/lib/lockref.c
>> index d2233de..e4c4255 100644
>> --- a/lib/lockref.c
>> +++ b/lib/lockref.c
>> @@ -158,7 +158,7 @@ int lockref_get_not_dead(struct lockref *lockref)
>>
>>       CMPXCHG_LOOP(
>>               new.count++;
>> -             if ((int)old.count < 0)
>> +             if (old.count < 0)
>>                       return 0;
>>       ,
>>               return 1;
>> @@ -166,7 +166,7 @@ int lockref_get_not_dead(struct lockref *lockref)
>>
>>       spin_lock(&lockref->lock);
>>       retval = 0;
>> -     if ((int) lockref->count >= 0) {
>> +     if (lockref->count >= 0) {
>>               lockref->count++;
>>               retval = 1;
>>       }
>
