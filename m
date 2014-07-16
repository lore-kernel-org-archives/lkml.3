Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934194AbaGPOIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:08:21 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:43916 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759202AbaGPOIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:08:20 -0400
MIME-Version: 1.0
In-Reply-To: <53C62B68.50702@redhat.com>
References: <cover.1405477965.git.luto@amacapital.net> <20140716064110.GV18167@minantech.com>
 <53C62563.6050106@redhat.com> <53C62B68.50702@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 16 Jul 2014 07:07:58 -0700
Message-ID: <CALCETrVLJ7qH3y04K9Sz1pU3i9+H9Cq_RoDfBeWnsH0VC68qKw@mail.gmail.com>
Subject: Re: [PATCH 0/4] random,x86,kvm: Add and use MSR_KVM_GET_RNG_SEED
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Daniel Borkmann <dborkman@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        kvm list <kvm@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 12:36 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 16/07/2014 09:10, Daniel Borkmann ha scritto:
>
>> On 07/16/2014 08:41 AM, Gleb Natapov wrote:
>>>
>>> On Tue, Jul 15, 2014 at 07:48:06PM -0700, Andy Lutomirski wrote:
>>>>
>>>> virtio-rng is both too complicated and insufficient for initial rng
>>>> seeding.  It's far too complicated to use for KASLR or any other
>>>> early boot random number needs.  It also provides /dev/random-style
>>>> bits, which means that making guest boot wait for virtio-rng is
>>>> unacceptably slow, and doing it asynchronously means that
>>>> /dev/urandom might be predictable when userspace starts.
>>>>
>>>> This introduces a very simple synchronous mechanism to get
>>>> /dev/urandom-style bits.
>>>
>>>
>>> Why can't you use RDRAND instruction for that?
>>
>>
>> You mean using it directly? I think simply for the very same reasons
>> as in c2557a303a ...
>
>
> No, this is very different.  This mechanism "provides no guarantee that the
> result contains any actual entropy".  In fact, patch 3 adds a call to the
> new arch_get_slow_rng_u64 just below a call to arch_get_random_lang aka
> RDRAND.  I agree with Gleb that it's simpler to just expect a relatively
> recent processor and use RDRAND.
>
> BTW, the logic for crediting entropy to RDSEED but not RDRAND escapes me.
> If you trust the processor, you could use Intel's algorithm to force
> reseeding of RDRAND.  If you don't trust the processor, the same paranoia
> applies to RDRAND and RDSEED.
>
> In a guest you must trust the hypervisor anyway to use RDRAND or RDSEED,
> since the hypervisor can trap it.  A malicious hypervisor is no different
> from a malicious processor.
>

This patch has nothing whatsoever to do with how much I trust the CPU
vs the hypervisor.  It's for the enormous installed base of machines
without RDRAND.

hpa suggested emulating RDRAND awhile ago, but I think that'll
unusably slow -- the kernel uses RDRAND in various places where it's
expected to be fast, and not using it at all will be preferable to
causing a VM exit for every few bytes.  I've been careful to only use
this in the guest in places where a few hundred to a few thousand
cycles per 64 bits of RNG seed is acceptable.

> In any case, is there a matching QEMU patch somewhere?

What QEMU change is needed?  I admit I'm a bit vague on how QEMU and
KVM cooperate here, but there's no state to save and restore.  I guess
that QEMU wants the ability to turn this on and off for migration.
How does that work?  I couldn't spot the KVM code that allows this
type of control.

--Andy
