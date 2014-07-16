Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965598AbaGPSEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 14:04:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965263AbaGPSEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 14:04:10 -0400
From: Bandan Das <bsd@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, x86@kernel.org,
        Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 0/5] random,x86,kvm: Add and use MSR_KVM_GET_RNG_SEED
References: <cover.1405532533.git.luto@amacapital.net>
Date: Wed, 16 Jul 2014 14:02:41 -0400
In-Reply-To: <cover.1405532533.git.luto@amacapital.net> (Andy Lutomirski's
	message of "Wed, 16 Jul 2014 10:45:55 -0700")
Message-ID: <jpgwqbdxjum.fsf@nelium.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> virtio-rng is both too complicated and insufficient for initial rng
> seeding.  It's far too complicated to use for KASLR or any other
> early boot random number needs.  It also provides /dev/random-style
> bits, which means that making guest boot wait for virtio-rng is
> unacceptably slow, and doing it asynchronously means that
> /dev/urandom might be predictable when userspace starts.
>
> This introduces a very simple synchronous mechanism to get
> /dev/urandom-style bits.

Whoa! the cover letter seems more like virtio-rng bashing rather than
introduction to the patchset (and/or it's advantages over existing methods)
:) That's ok though I guess, these won't be in the commit log.

> I sent the corresponding kvm-unit-tests and qemu changes separately.
>
> There's room for bikeshedding on the same arch_get_slow_rng_u64.  I
> considered arch_get_rng_seed_u64, but that could be confused with
> arch_get_random_seed_long, which is not interchangeable.
>
> Changes from v1:
>  - Split patches 2 and 3
>  - Log all arch sources in init_std_data
>  - Fix the 32-bit kaslr build
>
> Andy Lutomirski (5):
>   x86,kvm: Add MSR_KVM_GET_RNG_SEED and a matching feature bit
>   random,x86: Add arch_get_slow_rng_u64
>   random: Seed pools from arch_get_slow_rng_u64 at startup
>   random: Log how many bits we managed to seed with in init_std_data
>   x86,kaslr: Use MSR_KVM_GET_RNG_SEED for KASLR if available
>
>  Documentation/virtual/kvm/cpuid.txt  |  3 +++
>  arch/x86/Kconfig                     |  4 ++++
>  arch/x86/boot/compressed/aslr.c      | 27 +++++++++++++++++++++++++++
>  arch/x86/include/asm/archslowrng.h   | 30 ++++++++++++++++++++++++++++++
>  arch/x86/include/asm/processor.h     | 21 ++++++++++++++++++---
>  arch/x86/include/uapi/asm/kvm_para.h |  2 ++
>  arch/x86/kernel/kvm.c                | 22 ++++++++++++++++++++++
>  arch/x86/kvm/cpuid.c                 |  3 ++-
>  arch/x86/kvm/x86.c                   |  4 ++++
>  drivers/char/random.c                | 20 ++++++++++++++++++--
>  include/linux/random.h               |  9 +++++++++
>  11 files changed, 139 insertions(+), 6 deletions(-)
>  create mode 100644 arch/x86/include/asm/archslowrng.h
