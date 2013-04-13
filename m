Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab3DMPlI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 11:41:08 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:33081 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab3DMPlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 11:41:04 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzxxGBU3AOeNg3UEicHrx3nzWRyo5DOd=hh6SHJfYvB3g@mail.gmail.com>
References: <1365805938-22826-1-git-send-email-anatol.pomozov@gmail.com>
	<CA+55aFzxxGBU3AOeNg3UEicHrx3nzWRyo5DOd=hh6SHJfYvB3g@mail.gmail.com>
Date: Sat, 13 Apr 2013 08:41:02 -0700
Message-ID: <CAOMFOmVO47+AuC1UgZQX1K0oSMSZ4DCzDEuJGF99ARTfnCDTpw@mail.gmail.com>
Subject: Re: [PATCH] module: Fix race condition between load and unload module
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Salman Qazi <sqazi@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Apr 12, 2013 at 4:47 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Apr 12, 2013 at 3:32 PM, Anatol Pomozov
> <anatol.pomozov@gmail.com> wrote:
>>
>> Here is timeline for the crash in case if kset_find_obj() searches for
>> an object tht nobody holds and other thread is doing kobject_put()
>> on the same kobject:
>>
>> THREAD A (calls kset_find_obj())     THREAD B (calls kobject_put())
>> splin_lock()
>>                                      atomic_dec_return(kobj->kref), counter gets zero here
>>                                      ... starts kobject cleanup ....
>>                                      spin_lock() // WAIT thread A in kobj_kset_leave()
>> iterate over kset->list
>> atomic_inc(kobj->kref) (counter becomes 1)
>> spin_unlock()
>>                                      spin_lock() // taken
>>                                      // it does not know that thread A increased counter so it
>>                                      remove obj from list
>>                                      spin_unlock()
>>                                      vfree(module) // frees module object with containing kobj
>>
>> // kobj points to freed memory area!!
>> koubject_put(kobj) // OOPS!!!!
>
> This is a much more generic bug in kobjects, and I would hate to add
> some random workaround for just one case of this bug like you do. The
> more fundamental bug needs to be fixed too.
>
> I think the more fundamental bugfix is to just fix kobject_get() to
> return NULL if the refcount was zero, because in that case the kobject
> no longer really exists.
>
> So instead of having
>
>     kref_get(&kobj->kref);
>
> it should do
>
>     if (!atomic_inc_not_zero(&kobj->kref.refcount))
>         kobj = NULL;

Does it make sense to move it to a separate function in kref.h?

/** Useful when kref_get is racing with kref_put and refcounter might be 0 */
int kref_get_not_zero(kref* ref) {
    return atomic_inc_not_zero(&kref->refcount);
}

or maybe instead change default behavior of kref_get() to
atomic_inc_not_zero and force callers check the return value from
kref_get()?

>
> and I think that should fix your race automatically, no? Proper patch
> attached (but TOTALLY UNTESTED - it seems to compile, though).
>
> The problem is that we lose the warning for when the refcount is zero
> and somebody does a kobject_get(), but that is ok *assuming* that
> people actually check the return value of kobject_get() rather than
> just "know" that if they passed in a non-NULL kobj, they'll get it
> right back.
>
> Greg - please take a look... I'm adding Al to the discussion too,
> because Al just *loooves* these kinds of races ;)
>
>                   Linus
