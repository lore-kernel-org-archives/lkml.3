Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907Ab3ICUuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 16:50:20 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:39529 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760722Ab3ICUuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 16:50:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130903202755.GA26033@gmail.com>
References: <CACT4Y+ZLN+22hSKSQBbAc14cDi69gm9A+DK54K9hMa5VVi=mUw@mail.gmail.com>
 <CACT4Y+artcxiies1q3XP3+yCh+QzPZQ96dDttpdYXoQ+w2xosQ@mail.gmail.com>
 <CACT4Y+YobKoy9Yp5b6eM21oQrt+bj74qW6uM_DYPkeL-TVA3dQ@mail.gmail.com> <20130903202755.GA26033@gmail.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Wed, 4 Sep 2013 00:49:58 +0400
Message-ID: <CACT4Y+YjAHgN2fvUsDZ2VZyBVmYacKZdwHJSCJXoHh_P=3dOaQ@mail.gmail.com>
Subject: Re: Potential use-after-free in ____call_usermodehelper
To: Dan Aloni <alonid@stratoscale.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrey Konovalov <andreyknvl@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Alexander Potapenko <glider@google.com>,
        Evgeniy Stepanov <eugenis@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 12:27 AM, Dan Aloni <alonid@stratoscale.com> wrote:
> On Tue, Sep 03, 2013 at 05:49:03PM +0400, Dmitry Vyukov wrote:
>> Is anybody reading this? Is it a correct place to post such things?
>> Maybe there is a more appropriate place?
>
> This is the correct place, and people are reading this. However, the
> bug is not an obvious one, and you mentioned that this bug reproduces
> on a tree with significant deviation from vanilla in core kernel code
> (i.e. memory allocations) with potential bugs, and it also relies on a
> gcc feature not used by the kernel yet.
>
> Because of that it went down in priority compared to other kernel bugs
> that are currently being investigated.

Thanks Dan!

I am new here, so I was thinking maybe I am doing something wrong.


> Your work and contribution is appreciated nonetheless, but your bug
> report needs to pertain closer to the work the core kernel hackers
> are doing.

What exactly do you mean?


> Despite that, I did look into your report, and I'll address your analysis:
>
>> >> I've looked at the sources, but I can't say that I fully understand
>> >> them. The report looks valid, though. I see several potential issues
>> >> in the code.
>> >>
>> >> 1. When wait=UMH_WAIT_EXEC and do_execve() fails,
>> >> ____call_usermodehelper() writes sub_info->retval=retval to freed
>> >> memory. This is the use-after-free reported by the tool.
>
> The 'pid = kernel_thread(call_helper, sub_info, CLONE_VFORK | SIGCHLD);'
> call is designed to block until either do_execve() succeeds or the kernel
> thread exits - that happens after the store that triggers the issue,
> so the use-after-free cannot occur in that case.
>
> This is thanks to the CLONE_VFORK flag, and I doubt it is broken.

Aha! I've missed VFORK. It's all like in userspace, right? I will redo
my analysis.


>> >> 2. When wait=UMH_NO_WAIT, __call_usermodehelper() starts child thread
>> >> and instantly frees subprocess_info. The child thread reads
>> >> subprocess_info. Looks like another use-after-free.
>
> Same, kernel_thread() would be blocking because of CLONE_VFORK.
>
>> >> 3. UMH_WAIT_EXEC does not actually wait for exec, it only waits for
>> >> starting the child thread that will do exec. I don't know whether it's
>> >> a problem with the code or with the name.
>
> Same.
>
>> >>
>> >> The kernel version is 3.11-rc4 (last commit:
>> >> b7bc9e7d808ba55729bd263b0210cda36965be32).
>> >>
>> >> Please help to confirm these issues, and advice what to do next with them.
>
> Theory aside, I tried in practice to confirm the suggested issues and was
> unsuccessful, CLONE_VFORK seems to work as expected. Note that
> /sys/kernel/uevent_helper is empty in recent distros, so I had to put a
> non-existing executable path in there, for the relevant code path to run.
>
> Concerning the original reporting, my suggestion is that you take the
> patch below or a similar idea and try to reproduce the assert it adds
> with the *vanilla* kernel. i.e, take the unmodified b7bc9e7d808ba5 version
> (or better - v3.11), and apply it. Also, you must remove the standard
> memory debugging options from the config of the kernel you that build, so
> that kfree would not zero out the memory (I think this is the default
> behavior in non-debug kernel, for performance).
>
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index 8241906..d10eab6 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -244,6 +244,7 @@ static int ____call_usermodehelper(void *data)
>
>         /* Exec failed? */
>  fail:
> +       BUG_ON(sub_info->retval == 0x12345678);
>         sub_info->retval = retval;
>         do_exit(0);
>  }
> @@ -259,6 +260,7 @@ static void call_usermodehelper_freeinfo(struct subprocess_info *info)
>  {
>         if (info->cleanup)
>                 (*info->cleanup)(info);
> +       info->retval = 0x12345678;
>         kfree(info);
>  }
>
> This should help to prove it or not, and if it does prove it would be
> appealing to more eyes. Please try the same approach with similar future
> issues.


OK, I will try to do it. It may be possible for this "bug", because
it's triggered quite often. It may not be possible for all similar
issues, because I've seen some of them only once.

Btw, is it better to report such things here or file on bugzilla.kernel.org?

Thanks again!
