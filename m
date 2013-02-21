Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab3BUARo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 19:17:44 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:58120 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab3BUARm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 19:17:42 -0500
MIME-Version: 1.0
In-Reply-To: <20130220152446.a65ff84f.akpm@linux-foundation.org>
References: <20130220223013.GA15760@redhat.com>
	<1361402236-28644-1-git-send-email-msb@chromium.org>
	<20130220152446.a65ff84f.akpm@linux-foundation.org>
Date: Wed, 20 Feb 2013 16:17:39 -0800
X-Google-Sender-Auth: RhBvAb0IfG99bPAOw1YXzbeBeXw
Message-ID: <CACBanvr+1VEM6UqfNVx+KiuehZejwqpGp6djPN5kTgYD-umP2g@mail.gmail.com>
Subject: Re: [PATCH v4] lockdep: check that no locks held at freeze time
From: Mandeep Singh Baines <msb@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 3:24 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 20 Feb 2013 15:17:16 -0800
> Mandeep Singh Baines <msb@chromium.org> wrote:
>
>> We shouldn't try_to_freeze if locks are held.
>>
>> ...
>>
>> @@ -43,6 +44,9 @@ extern void thaw_kernel_threads(void);
>>
>> +     if (!(current->flags & PF_NOFREEZE))
>> +             debug_check_no_locks_held(current,
>> +
>>                                         "lock held while trying to freeze");
>> ...
>>
>> +     debug_check_no_locks_held(tsk, "lock held at task exit time");
>
> There doesn't seem much point in adding the `msg' to
> debug_check_no_locks_held() - the dump_stack() in
> print_held_locks_bug() will tell us the same thing.  Maybe just change

dump_stack() can be confusing when there is inlining. On occasion I've
looked at the wrong mutex_lock, for example, when there was another
mutex_lock that was inlined. Of course, you can start objdump and
verify the offsets. But that requires that you have the object file.
You could have a try_to_freeze added to do_exit. I was thinking of
adding another locks_held in the return from syscall path.

How about if we did some inlining and printed out the function, file
and line number where the check was placed:

#define debug_check_no_locks_held() do { \
        if (unlikely(current->lockdep_depth > 0)) { \
                printk("BUG: locks helds at %s:%d/%s()!\n", __FILE__,
__LINE__, __func__); \
                print_held_locks_bug(); \
        } \
} while (0)

That we avoid any potential confusion.

> the print_held_locks_bug() messages so they stop assuming they were
> called from do_exit()?
>
> Also, I wonder if the `tsk' arg is needed.  In both callers
> tsk==current.  Is it likely that we'll ever call
> debug_check_no_locks_held() for any task other than `current'?
>

I agree. I'll add that change to the patch once we decide what to about msg.

Regards,
Mandeep
