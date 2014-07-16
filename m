Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395AbaGPHgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 03:36:17 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:54767 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755AbaGPHgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 03:36:15 -0400
Message-ID: <53C62B68.50702@redhat.com>
Date: Wed, 16 Jul 2014 09:36:08 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Borkmann <dborkman@redhat.com>, Gleb Natapov <gleb@kernel.org>
CC: Andy Lutomirski <luto@amacapital.net>, kvm@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        x86@kernel.org, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/4] random,x86,kvm: Add and use MSR_KVM_GET_RNG_SEED
References: <cover.1405477965.git.luto@amacapital.net> <20140716064110.GV18167@minantech.com> <53C62563.6050106@redhat.com>
In-Reply-To: <53C62563.6050106@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 16/07/2014 09:10, Daniel Borkmann ha scritto:
> On 07/16/2014 08:41 AM, Gleb Natapov wrote:
>> On Tue, Jul 15, 2014 at 07:48:06PM -0700, Andy Lutomirski wrote:
>>> virtio-rng is both too complicated and insufficient for initial rng
>>> seeding.  It's far too complicated to use for KASLR or any other
>>> early boot random number needs.  It also provides /dev/random-style
>>> bits, which means that making guest boot wait for virtio-rng is
>>> unacceptably slow, and doing it asynchronously means that
>>> /dev/urandom might be predictable when userspace starts.
>>>
>>> This introduces a very simple synchronous mechanism to get
>>> /dev/urandom-style bits.
>>
>> Why can't you use RDRAND instruction for that?
>
> You mean using it directly? I think simply for the very same reasons
> as in c2557a303a ...

No, this is very different.  This mechanism "provides no guarantee that 
the result contains any actual entropy".  In fact, patch 3 adds a call 
to the new arch_get_slow_rng_u64 just below a call to 
arch_get_random_lang aka RDRAND.  I agree with Gleb that it's simpler to 
just expect a relatively recent processor and use RDRAND.

BTW, the logic for crediting entropy to RDSEED but not RDRAND escapes 
me.  If you trust the processor, you could use Intel's algorithm to 
force reseeding of RDRAND.  If you don't trust the processor, the same 
paranoia applies to RDRAND and RDSEED.

In a guest you must trust the hypervisor anyway to use RDRAND or RDSEED, 
since the hypervisor can trap it.  A malicious hypervisor is no 
different from a malicious processor.

In any case, is there a matching QEMU patch somewhere?

Paolo
