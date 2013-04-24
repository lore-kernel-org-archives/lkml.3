Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab3DXPwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 11:52:38 -0400
Received: from ns.iliad.fr ([212.27.33.1]:41375 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756641Ab3DXPwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 11:52:37 -0400
Message-ID: <5177FFC2.5020102@freebox.fr>
Date: Wed, 24 Apr 2013 17:52:34 +0200
From: Nicolas Schichan <nschichan@freebox.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Serge Hallyn <serge.hallyn@canonical.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Mircea Gherzan <mgherzan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        James Morris <james.l.morris@oracle.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 1/3] seccomp: add generic code for jitted seccomp filters.
References: <1363618233-6375-1-git-send-email-nschichan@freebox.fr> <1363618233-6375-2-git-send-email-nschichan@freebox.fr> <20130417145628.88058f0f3104ab9ae551ddd3@linux-foundation.org> <51752D98.8070709@freebox.fr> <20130423164303.d2eb663c4a1becea4a185087@linux-foundation.org>
In-Reply-To: <20130423164303.d2eb663c4a1becea4a185087@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2013 01:43 AM, Andrew Morton wrote:
> On Mon, 22 Apr 2013 14:31:20 +0200 Nicolas Schichan <nschichan@freebox.fr> wrote:
>> Would including <uapi/linux/filter.h> instead of <linux/filter.h> in seccomp.h
>> be an acceptable solution ?
>>
>> I have tried that and (with an additional forward declaration of struct
>> sk_buff) an x86_64 "make clean; make allmodconfig" run finishes succesfully.
>>
>> If that's ok with you, I can resend the serie with that fix.
>
> It would be better to make the code and include tangle less complex,
> rather than more complex.
>
> Did we really need to move the `struct seccomp_filter' definition into
> the header file?  afaict that wasn't really necessary - we can add a
> few helper functions to kernel/seccomp.c and then have the remote code
> treat seccomp_filter in an opaque fashion rather than directly poking
> at its internals.

Hi,

I will resend a V3 of the patch serie with the accessors.

> btw, what on earth is going on with seccomp_jit_free()?  It does
> disturbing undocumented typecasting and it punts the module_free into a
> kernel thread for mysterious, undocumented and possibly buggy reasons.
>
> I realize it just copies bpf_jit_free().  The same observations apply there.

The reason for this hack for both seccomp filters and socket filters is that 
{seccomp,bpf}_jit_free are called from a softirq. module_free() cannot be 
called directly from softirq, as it will in turn call vfree() which will 
BUG_ON() if in_interrupt() is non zero. So to call module_free(), it is 
therefore required to be in a process context, which is provided by the work 
struct.

Here is the call stack for the socket filter case:

[<c0087bf8>] (vfree+0x28/0x2c) from [<c001fc5c>] (bpf_jit_free+0x10/0x18)
[<c001fc5c>] (bpf_jit_free+0x10/0x18) from 
[<c0231188>](sk_filter_release_rcu+0x10/0x1c)
[<c0231188>] (sk_filter_release_rcu+0x10/0x1c) from [<c0060bb4>] 
(__rcu_process_callbacks+0x98/0xac)
[<c0060bb4>] (__rcu_process_callbacks+0x98/0xac) from [<c0060bd8>] 
(rcu_process_callbacks+0x10/0x20)
[<c0060bd8>] (rcu_process_callbacks+0x10/0x20) from [<c0029498>] 
(__do_softirq+0xbc/0x194)
[<c0029498>] (__do_softirq+0xbc/0x194) from [<c00295b0>] (run_ksoftirqd+0x40/0x64)
[<c00295b0>] (run_ksoftirqd+0x40/0x64) from [<c0041954>] 
(smpboot_thread_fn+0x150/0x15c)
[<c0041954>] (smpboot_thread_fn+0x150/0x15c) from [<c003bb2c>] (kthread+0xa4/0xb0)
[<c003bb2c>] (kthread+0xa4/0xb0) from [<c0013450>] (ret_from_fork+0x14/0x24)

Here is the call stack for the seccomp filter case:

[<c0087c28>] (vfree+0x28/0x2c) from [<c0060834>] (put_seccomp_filter+0x6c/0x84)
[<c0060834>] (put_seccomp_filter+0x6c/0x84) from [<c0020db4>] 
(free_task+0x30/0x50)
[<c0020db4>] (free_task+0x30/0x50) from [<c0060be4>] 
(__rcu_process_callbacks+0x98/0xac)
[<c0060be4>] (__rcu_process_callbacks+0x98/0xac) from [<c0060c08>] 
(rcu_process_callbacks+0x10/0x20)
[<c0060c08>] (rcu_process_callbacks+0x10/0x20) from [<c00294c8>] 
(__do_softirq+0xbc/0x194)
[<c00294c8>] (__do_softirq+0xbc/0x194) from [<c00295e0>] (run_ksoftirqd+0x40/0x64)
[<c00295e0>] (run_ksoftirqd+0x40/0x64) from [<c0041984>] 
(smpboot_thread_fn+0x150/0x15c)
[<c0041984>] (smpboot_thread_fn+0x150/0x15c) from [<c003bb5c>] (kthread+0xa4/0xb0)
[<c003bb5c>] (kthread+0xa4/0xb0) from [<c0013450>] (ret_from_fork+0x14/0x24)

Regards,

-- 
Nicolas Schichan
Freebox SAS
