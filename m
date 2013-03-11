Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab3CKUCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:02:12 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:45340 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab3CKUCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:02:09 -0400
MIME-Version: 1.0
In-Reply-To: <87ip4xlo4y.fsf@xmission.com>
References: <20130311191156.GA17763@www.outflux.net>
	<20130311192805.GA19428@redhat.com>
	<CAGXu5jJEhDHgVR_iAdf27G0+Mip82vYBHv-r0Q_vZwDodfADRQ@mail.gmail.com>
	<87ip4xlo4y.fsf@xmission.com>
Date: Mon, 11 Mar 2013 13:02:08 -0700
X-Google-Sender-Auth: BrNiA5sWdE2pb5l1-P30rGPnlVE
Message-ID: <CAGXu5jJ8ZSjeyeJJqqAQeAqufKAAJfDMNWYY5QUqeEWQpFqEBA@mail.gmail.com>
Subject: Re: [PATCH] signal: always clear sa_restorer on execve
From: Kees Cook <keescook@chromium.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 12:42 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Kees Cook <keescook@chromium.org> writes:
>
>> On Mon, Mar 11, 2013 at 12:28 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>>> On 03/11, Kees Cook wrote:
>>>>
>>>> When the new signal handlers are set up for a fork, the location of
>>>> sa_restorer is not cleared, leaking a parent process's address space
>>>> location to children. This allows for a potential bypass of the parent's
>>>> ASLR by examining the sa_restorer value returned when calling sigaction().
>>>
>>> I don't understand.
>>>
>>> fork() should not change restorer/etc, and the child has the same address
>>> space anyway. There is no any leak and the patch can't make any difference
>>> in this case because flush_signal_handlers() is not called by fork().
>>
>> I probably failed to explain this correctly. From the perspective of
>> what should be considered "secret", it only matters across the exec,
>> not the fork (since the VMAs haven't changed until the exec). But the
>> info leak is easy to see, and this patch fixes it. As you say, since
>> other things were reset, so should sa_restorer.
>
> At the very least please correct the explanation in your patch
> description.
>
> Too often I have had seen a confused patch description, indicate
> confusion elsewhere in the patch.  Let's make it easy for reviewers
> and future bisectors to understand what is intended.

Sounds good. I'll re-attempt and send a v2.

>>>> @@ -485,6 +485,9 @@ flush_signal_handlers(struct task_struct *t, int force_default)
>>>>               if (force_default || ka->sa.sa_handler != SIG_IGN)
>>>>                       ka->sa.sa_handler = SIG_DFL;
>>>>               ka->sa.sa_flags = 0;
>>>> +#ifdef __ARCH_HAS_SA_RESTORER
>>>> +             ka->sa.sa_restorer = NULL;
>>>> +#endif
>
> Also I am inclined to suggest this should be an inline function in a
> header.
>                 clear_sa_restorer(ka);
>
> Just so we don't litter the code with #ifdefs.

Yeah, I took a look, and the code was already using the __ARCH_HAS...
ifdef, so I went with that. I can respin with some kind of
set_sa_restorer() for the other places sa_restorer is used.

-Kees

-- 
Kees Cook
Chrome OS Security
