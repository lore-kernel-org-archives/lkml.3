Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab3COTW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:22:57 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:64180 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab3COTW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:22:56 -0400
MIME-Version: 1.0
In-Reply-To: <51437232.8000509@freebox.fr>
References: <1363372123-8861-1-git-send-email-nschichan@freebox.fr>
	<1363372123-8861-2-git-send-email-nschichan@freebox.fr>
	<CAGXu5jLMPFoeAD5uXaMf-CS9yz_8_1zRJEkzxT7R6U4HruJSjQ@mail.gmail.com>
	<51437232.8000509@freebox.fr>
Date: Fri, 15 Mar 2013 12:22:55 -0700
X-Google-Sender-Auth: B6RNnByyrr4N6LbRZ_4Ph1qzSs0
Message-ID: <CAGXu5jJAbk_gZXkfftjD7U9dOmGSSW-PSqJ4JdV0frMnS6iwRQ@mail.gmail.com>
Subject: Re: [PATCH RFC 1/3] seccomp: add generic code for jitted seccomp filters.
From: Kees Cook <keescook@chromium.org>
To: Nicolas Schichan <nschichan@freebox.fr>
Cc: Will Drewry <wad@chromium.org>, Mircea Gherzan <mgherzan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 12:10 PM, Nicolas Schichan <nschichan@freebox.fr> wrote:
> On 03/15/2013 07:45 PM, Kees Cook wrote:
>>
>> On Fri, Mar 15, 2013 at 11:28 AM, Nicolas Schichan <nschichan@freebox.fr>
>> wrote:
>>>
>>> +/**
>>> + * struct seccomp_filter - container for seccomp BPF programs
>>> + *
>>> + * @usage: reference count to manage the object lifetime.
>>> + *         get/put helpers should be used when accessing an instance
>>> + *         outside of a lifetime-guarded section.  In general, this
>>> + *         is only needed for handling filters shared across tasks.
>>> + * @prev: points to a previously installed, or inherited, filter
>>> + * @len: the number of instructions in the program
>>> + * @insns: the BPF program instructions to evaluate
>>
>>
>> This should be updated to include the new bpf_func field.
>
> Sure, I'll fix this in a re-spin of the patch serie.
>
>> Regardless, it'd be better to not expose this structure to userspace.
>
> Yes, I did not realise that this header was exported to userspace. Do you
> know any place not exported to userspace where the structure definition
> would be appropriate ?

Nothing really jumps to mind. :( We should probably do the uapi split,
so that this can stay here, but the public stuff is in the other file.
I'm not actually sure what's needed to do that split, though.

>>> @@ -213,7 +185,7 @@ static u32 seccomp_run_filters(int syscall)
>>>           * value always takes priority (ignoring the DATA).
>>>           */
>>>          for (f = current->seccomp.filter; f; f = f->prev) {
>>> -               u32 cur_ret = sk_run_filter(NULL, f->insns);
>>> +               u32 cur_ret = f->bpf_func(NULL, f->insns);
>>
>> This will make bpf_func a rather attractive target inside the kernel.
>> I wonder if there could be ways to harden it against potential attack.
>
> I'm not sure I follow, but is it because any user can install a SECCOMP
> filter which will trigger JIT code generation with potential JIT spraying
> attack payload ?

I actually mean that when an arbitrary write vulnerability is used
against the kernel, finding bpf_func may make a good target since it
hangs off the process stack. There are plenty of targets, but just
wonder if there would be some trivial way to handle this. Probably
not. :)

> In that case, the same problem exists with struct sk_filter->bpf_func, as
> SO_ATTACH_FILTER, with BPT JIT enabled, does not require any particular
> privilege AFAICS.

Yeah, these problems aren't unique to seccomp, unfortunately.

> Regarding JIT spraying, I believe ARM is actually worse than x86 in that
> regard, since the values appearing in the literal pool can be quite easily
> controlled by an attacker.

Yeah, same for x86, really. Masking these would be nice, but is
probably a separate discussion.

> Thanks for the review.

Sure thing! I think Will Drewry may have more suggestions as well.

-Kees

-- 
Kees Cook
Chrome OS Security
