Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab3DMVKO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 17:10:14 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:56981 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab3DMVKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 17:10:13 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxhwYO8wrHXHH6ry0pfpPHURsjN_aotT0xsDwZZZj7wvQ@mail.gmail.com>
References: <1365805938-22826-1-git-send-email-anatol.pomozov@gmail.com>
	<CA+55aFzxxGBU3AOeNg3UEicHrx3nzWRyo5DOd=hh6SHJfYvB3g@mail.gmail.com>
	<CAOMFOmVO47+AuC1UgZQX1K0oSMSZ4DCzDEuJGF99ARTfnCDTpw@mail.gmail.com>
	<CA+55aFxhwYO8wrHXHH6ry0pfpPHURsjN_aotT0xsDwZZZj7wvQ@mail.gmail.com>
Date: Sat, 13 Apr 2013 14:10:11 -0700
Message-ID: <CAOMFOmVqL4Ypd804obxoLVh7ntZeRZ66OT6v0rxTgcmwvgiynA@mail.gmail.com>
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

On Sat, Apr 13, 2013 at 10:53 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, Apr 13, 2013 at 8:41 AM, Anatol Pomozov
> <anatol.pomozov@gmail.com> wrote:
>>
>> Does it make sense to move it to a separate function in kref.h?
>>
>> /** Useful when kref_get is racing with kref_put and refcounter might be 0 */
>> int kref_get_not_zero(kref* ref) {
>>     return atomic_inc_not_zero(&kref->refcount);
>> }
>
> It turns out we have that, except it's called "unless_zero", because
> it uses "atomic_add_unless(x,1,0)", rather than the simplified
> "atomic_inc_not_zero(x)".
>
>> or maybe instead change default behavior of kref_get() to
>> atomic_inc_not_zero and force callers check the return value from
>> kref_get()?
>
> That would be painful, and _most_ users should have a preexisting
> refcount. So it's probably better in the long run to just keep the
> warning (but perhaps fix it to be SMP-safe). So I think the part of
> your patch that made kref_get() use atomic_inc_return() is probably a
> good idea regardless.
>
> Also, I changed my patch to be minimal, and not change other users of
> kobject_get(). So other users (not kset_find_obj()) will continue to
> get the warning, and kset_find_obj() uses the safe version.
Looks good to me.

> So this is
> what I'm planning on committing as the minimal patch and marking for
> stable. The rest (including that atomic_inc_return() in kref_get)
> would be cleanup.
>
> Can you give this a quick test?

I ran the test case for ~60 minutes with XFS tests in parallel - no any issues.
