Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaBKVfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:35:31 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:50349 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaBKVf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:35:29 -0500
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140211131927.f180ac29dede51b2733b92a6@linux-foundation.org>
References: <1392101400-14550-1-git-send-email-jiel@marvell.com>
	<20140211131927.f180ac29dede51b2733b92a6@linux-foundation.org>
Date: Tue, 11 Feb 2014 22:35:28 +0100
Message-ID: <CAKMK7uF22rLhEsQaksb5WMny-aTy9tDmbsN4BYhv-oJUp3Q1Vg@mail.gmail.com>
Subject: Re: [PATCH] printk: fix one circular lockdep warning about console_lock
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jane Li <jiel@marvell.com>, Joe Perches <joe@perches.com>,
        Tejun Heo <tj@kernel.org>, fweisbec@gmail.com,
        David Miller <davem@davemloft.net>, Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aside: I've suggested this fix (but was too lazy to write the actual
patch), hence also my sob on it.

On Tue, Feb 11, 2014 at 10:19 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>> --- a/kernel/printk/printk.c
>> +++ b/kernel/printk/printk.c
>> @@ -1893,6 +1893,20 @@ void resume_console(void)
>>  }
>>
>>  /**
>> + * console_flush - flush dmesg if console isn't suspended
>> + *
>> + * console_unlock always flushes the dmesg buffer, so just try to
>> + * grab&drop the console lock. If that fails we know that the current
>> + * holder will eventually drop the console lock and so flush the dmesg
>> + * buffers at the earliest possible time.
>> + */
>
> The comment should describe why we added this code, please: talk about
> cpu_hotplug.lock and console_lock.

I've suggested this since it's the generic way to flush out dmesg. The
printk functions also use this trick, but with the complication that
console_trylock_for_printk also drops the logbuf log. So imo this is a
general helper to flush the console buffer in odd circumstances and
not specific to the cpu lockdep issue at hand. At least my idea was
that this could be useful to untangle other issues around
console_lock.

>> +void console_flush(void)
>> +{
>> +     if (console_trylock())
>> +             console_unlock();
>> +}
>> +
>> +/**
>>   * console_cpu_notify - print deferred console messages after CPU hotplug
>>   * @self: notifier struct
>>   * @action: CPU hotplug event
>> @@ -1911,8 +1925,7 @@ static int console_cpu_notify(struct notifier_block *self,
>>       case CPU_DEAD:
>>       case CPU_DOWN_FAILED:
>>       case CPU_UP_CANCELED:
>> -             console_lock();
>> -             console_unlock();
>> +             console_flush();
>>       }
>>       return NOTIFY_OK;
>
> Well, this is a bit hacky and makes the already-far-too-complex code
> even more complex.  If it is indeed the case that the deadlock cannot
> really occur then let's try to find a way of suppressing the lockdep
> warning without making runtime changes.
>
> What I'm struggling with is what *should* the ranking of these locks be?
> From a conceptual high-level design standpoint, which is the
> "innermost" lock?  I tend to think that it is console_lock, because
> blocking CPU hotplug is a quite high-level operation.
>
> But console_lock is such a kooky special-case in the way it is used to
> control the printk corking that it is hard to take general rules and
> apply them here.

console_lock is one giant disaster imo, at least from my experience
with it's interactions in fbdev/drm/gpu code - due to bonghits around
how the fbcon code is structured we need to run the entire initial
modeset under the console_lock, which means if anything goes wrong we
can't even dump to net/serial console.

Hence why I've proposed the trylock "fix", prettied up in the
console_flush helper to duct-tape over the lockdep splat at hand. It
actually achieves exactly what the code sets out to do (flush dmesg as
soon as possible) without extending the reach of insane console_lock
interactions into even more code. Because that way lies madness, at
least when I look at our vain attempts to make fbcon and drm work
together properly ...

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
