Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbaGJQyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 12:54:54 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:42352 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaGJQyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 12:54:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140710152418.GB20861@redhat.com>
References: <1403911380-27787-1-git-send-email-keescook@chromium.org>
	<1403911380-27787-10-git-send-email-keescook@chromium.org>
	<20140709184215.GA4866@redhat.com>
	<20140709185549.GB4866@redhat.com>
	<CAGXu5jL6q1d16uA1Yu+QO4eV7zWwcWEWgkZrwmsfymbMvEr6+Q@mail.gmail.com>
	<20140710152418.GB20861@redhat.com>
Date: Thu, 10 Jul 2014 09:54:49 -0700
X-Google-Sender-Auth: -1xDtbhzyZz9fuaIc0D4utRPZ44
Message-ID: <CAGXu5jKNUn0OcXPyTmqbHwQ_GPMNTeajyrxpd2xAtzjTRFyhpg@mail.gmail.com>
Subject: Re: [PATCH v9 09/11] seccomp: introduce writer locking
From: Kees Cook <keescook@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-arch <linux-arch@vger.kernel.org>, linux-mips@linux-mips.org,
        Will Drewry <wad@chromium.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Julien Tinnes <jln@chromium.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Drysdale <drysdale@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alexei Starovoitov <ast@plumgrid.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 8:24 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 07/10, Kees Cook wrote:
>>
>> On Wed, Jul 9, 2014 at 11:55 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> > On 07/09, Oleg Nesterov wrote:
>> >>
>> >> On 06/27, Kees Cook wrote:
>> >> >
>> >> >  static u32 seccomp_run_filters(int syscall)
>> >> >  {
>> >> > -   struct seccomp_filter *f;
>> >> > +   struct seccomp_filter *f = ACCESS_ONCE(current->seccomp.filter);
>> >>
>> >> I am not sure...
>> >>
>> >> This is fine if this ->filter is the 1st (and only) one, in this case
>> >> we can rely on rmb() in the caller.
>> >>
>> >> But the new filter can be installed at any moment. Say, right after that
>> >> rmb() although this doesn't matter. Either we need smp_read_barrier_depends()
>> >> after that, or smp_load_acquire() like the previous version did?
>> >
>> > Wait... and it seems that seccomp_sync_threads() needs smp_store_release()
>> > when it sets thread->filter = current->filter by the same reason?
>> >
>> > OTOH. smp_store_release() in seccomp_attach_filter() can die, "current"
>> > doesn't need a barrier to serialize with itself.
>>
>> I have lost track of what you're suggesting to change. :)
>
> Perhaps I am just trying to confuse you and myself ;)
>
> But,
>
>> Since rmb() happens before run_filters, isn't the ACCESS_ONCE
>> sufficient?
>
> Yes. But see above. ACCESS_ONCE is sufficient if we read the first filter
> installed by another thread, in this case rmb() pairs with mb_before_atomic()
> before set_bit(TIF_SECCOMP).
>
> IOW, if this threads sees TIF_SECCOMP, it should also see all modifications
> which were done before set_bit, including the data in ->filter points to.
>
>> We only care that TIF_SECCOMP, mode, and some filter is
>> valid. In a tsync thread race, it's okay to use not use the deepest
>> filter node in the list,
>
> Yes, it is fine if we miss yet another filter which was just installed by
> another thread.
>
> But, unless I missed something, the problem is that we can get this new
> filter.
>
> Just to simplify. Suppose TIF_SECCOMP was set a long ago. This thread
> has a single filter F1 and it enters seccomp_run_filters().
>
> Right before it does ACCESS_ONCE() to read the pointer, another thread
> does seccomp_sync_threads() and sets .filter = F2.
>
> If ACCESS_ONCE() returns F1 - everything is fine. But it can see the new
> pointer F2, and in this case we need a barrier to ensure that, say,
> LOAD(F2->prog) will see all the preceding changes in this memory.

And the rmb() isn't sufficient for that? Is another barrier needed
before assigning the filter pointer to make sure the contents it
points to are flushed?

What's the least time-consuming operation I can use in run_filters?

-Kees

-- 
Kees Cook
Chrome OS Security
