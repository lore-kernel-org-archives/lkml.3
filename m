Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750809Ab3DNEmJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 00:42:09 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:40378 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab3DNEmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 00:42:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130414033539.GE4068@ZenIV.linux.org.uk>
References: <1365805938-22826-1-git-send-email-anatol.pomozov@gmail.com>
	<CA+55aFzxxGBU3AOeNg3UEicHrx3nzWRyo5DOd=hh6SHJfYvB3g@mail.gmail.com>
	<20130414033539.GE4068@ZenIV.linux.org.uk>
Date: Sat, 13 Apr 2013 21:42:06 -0700
Message-ID: <CAOMFOmVAbg3AVy95Q_O3ADf-kdaAGkBhNtqF6uc=TGZXWsXawA@mail.gmail.com>
Subject: Re: [PATCH] module: Fix race condition between load and unload module
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Salman Qazi <sqazi@google.com>, Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sat, Apr 13, 2013 at 8:35 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Apr 12, 2013 at 04:47:50PM -0700, Linus Torvalds wrote:
>> This is a much more generic bug in kobjects, and I would hate to add
>> some random workaround for just one case of this bug like you do. The
>> more fundamental bug needs to be fixed too.
>>
>> I think the more fundamental bugfix is to just fix kobject_get() to
>> return NULL if the refcount was zero, because in that case the kobject
>> no longer really exists.
>>
>> So instead of having
>>
>>     kref_get(&kobj->kref);
>>
>> it should do
>>
>>     if (!atomic_inc_not_zero(&kobj->kref.refcount))
>>         kobj = NULL;
>>
>> and I think that should fix your race automatically, no? Proper patch
>> attached (but TOTALLY UNTESTED - it seems to compile, though).
>>
>> The problem is that we lose the warning for when the refcount is zero
>> and somebody does a kobject_get(), but that is ok *assuming* that
>> people actually check the return value of kobject_get() rather than
>> just "know" that if they passed in a non-NULL kobj, they'll get it
>> right back.
>>
>> Greg - please take a look... I'm adding Al to the discussion too,
>> because Al just *loooves* these kinds of races ;)
>
> Unless I'm misreading what's going on, we have the following to thank for that:
>         /* remove from sysfs if the caller did not do it */
>         if (kobj->state_in_sysfs) {
>                 pr_debug("kobject: '%s' (%p): auto cleanup kobject_del\n",
>                          kobject_name(kobj), kobj);
>                 kobject_del(kobj);
>         }
> in kobject_cleanup().  Why don't we require kobject_del() before the final
> kobject_put(), if the sucker had been added?  FWIW, I thought it *was*
> required all along...

But kobject_release/kobject_cleanup function is called as a result of
atomic decrement_compare. Until we perform the atomic operation we
don't know whether it is final kobject_put() or not.

kobject_put() {
    if (atomic_sub_and_test(kobj->kref->refcount)) {
        // refcounter is decremented to 0 so cleanup sysfs
        kobject_release(kobj)
    }
}
