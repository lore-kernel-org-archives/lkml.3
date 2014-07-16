Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbaGPVpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:45:47 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:53407 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbaGPVpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:45:45 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, x86@kernel.org
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        bsd@redhat.com, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 0/5] random,x86,kvm: Add and use MSR_KVM_GET_RNG_SEED
Date: Wed, 16 Jul 2014 14:45:32 -0700
Message-Id: <cover.1405546879.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces and uses a very simple synchronous mechanism to get
/dev/urandom-style bits appropriate for initial KVM PV guest RNG
seeding.

virtio-rng is not suitable for this purpose.  It's too difficult to
enumerate for use in early boot (e.g. KASLR, which runs before we
even have an IDT).  It also provides /dev/random-style bits, which
means that making guest boot wait for virtio-rng is unacceptably
slow, and doing it asynchronously means that /dev/urandom might
still be predictable when userspace starts.

I sent the corresponding kvm-unit-tests and qemu changes separately.

There's room for bikeshedding on the same arch_get_slow_rng_u64.  I
considered arch_get_rng_seed_u64, but that could be confused with
arch_get_random_seed_long, which is not interchangeable.

Changes from v2:
 - Bisection fix (patch 2 had a misplaced brace).  The final states is
   identical to that of v2.
 - Improve the 0/5 description a little bit.

Changes from v1:
 - Split patches 2 and 3
 - Log all arch sources in init_std_data
 - Fix the 32-bit kaslr build

Andy Lutomirski (5):
  x86,kvm: Add MSR_KVM_GET_RNG_SEED and a matching feature bit
  random,x86: Add arch_get_slow_rng_u64
  random: Seed pools from arch_get_slow_rng_u64 at startup
  random: Log how many bits we managed to seed with in init_std_data
  x86,kaslr: Use MSR_KVM_GET_RNG_SEED for KASLR if available

 Documentation/virtual/kvm/cpuid.txt  |  3 +++
 arch/x86/Kconfig                     |  4 ++++
 arch/x86/boot/compressed/aslr.c      | 27 +++++++++++++++++++++++++++
 arch/x86/include/asm/archslowrng.h   | 30 ++++++++++++++++++++++++++++++
 arch/x86/include/asm/processor.h     | 21 ++++++++++++++++++---
 arch/x86/include/uapi/asm/kvm_para.h |  2 ++
 arch/x86/kernel/kvm.c                | 22 ++++++++++++++++++++++
 arch/x86/kvm/cpuid.c                 |  3 ++-
 arch/x86/kvm/x86.c                   |  4 ++++
 drivers/char/random.c                | 20 ++++++++++++++++++--
 include/linux/random.h               |  9 +++++++++
 11 files changed, 139 insertions(+), 6 deletions(-)
 create mode 100644 arch/x86/include/asm/archslowrng.h

-- 
1.9.3

