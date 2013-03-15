Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab3COTKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:10:44 -0400
Received: from ns.iliad.fr ([212.27.33.1]:38964 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755156Ab3COTKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:10:43 -0400
Message-ID: <51437232.8000509@freebox.fr>
Date: Fri, 15 Mar 2013 20:10:42 +0100
From: Nicolas Schichan <nschichan@freebox.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Will Drewry <wad@chromium.org>, Mircea Gherzan <mgherzan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 1/3] seccomp: add generic code for jitted seccomp
 filters.
References: <1363372123-8861-1-git-send-email-nschichan@freebox.fr> <1363372123-8861-2-git-send-email-nschichan@freebox.fr> <CAGXu5jLMPFoeAD5uXaMf-CS9yz_8_1zRJEkzxT7R6U4HruJSjQ@mail.gmail.com>
In-Reply-To: <CAGXu5jLMPFoeAD5uXaMf-CS9yz_8_1zRJEkzxT7R6U4HruJSjQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 07:45 PM, Kees Cook wrote:
> On Fri, Mar 15, 2013 at 11:28 AM, Nicolas Schichan <nschichan@freebox.fr> wrote:
>> +/**
>> + * struct seccomp_filter - container for seccomp BPF programs
>> + *
>> + * @usage: reference count to manage the object lifetime.
>> + *         get/put helpers should be used when accessing an instance
>> + *         outside of a lifetime-guarded section.  In general, this
>> + *         is only needed for handling filters shared across tasks.
>> + * @prev: points to a previously installed, or inherited, filter
>> + * @len: the number of instructions in the program
>> + * @insns: the BPF program instructions to evaluate
>
> This should be updated to include the new bpf_func field.

Sure, I'll fix this in a re-spin of the patch serie.

> Regardless, it'd be better to not expose this structure to userspace.

Yes, I did not realise that this header was exported to userspace. Do you know 
any place not exported to userspace where the structure definition would be 
appropriate ?

>> @@ -213,7 +185,7 @@ static u32 seccomp_run_filters(int syscall)
>>           * value always takes priority (ignoring the DATA).
>>           */
>>          for (f = current->seccomp.filter; f; f = f->prev) {
>> -               u32 cur_ret = sk_run_filter(NULL, f->insns);
>> +               u32 cur_ret = f->bpf_func(NULL, f->insns);
>
> This will make bpf_func a rather attractive target inside the kernel.
> I wonder if there could be ways to harden it against potential attack.

I'm not sure I follow, but is it because any user can install a SECCOMP filter 
which will trigger JIT code generation with potential JIT spraying attack 
payload ?

In that case, the same problem exists with struct sk_filter->bpf_func, as 
SO_ATTACH_FILTER, with BPT JIT enabled, does not require any particular 
privilege AFAICS.

Regarding JIT spraying, I believe ARM is actually worse than x86 in that 
regard, since the values appearing in the literal pool can be quite easily 
controlled by an attacker.

Thanks for the review.

Regards,

-- 
Nicolas Schichan
Freebox SAS
