Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbaGQSW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 14:22:28 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:58425 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbaGQSW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 14:22:26 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, x86@kernel.org
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        bsd@redhat.com, Andrew Honig <ahonig@google.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v4 0/5] random,x86,kvm: Rework arch RNG seeds and get some from kvm
Date: Thu, 17 Jul 2014 11:22:15 -0700
Message-Id: <cover.1405620944.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces and uses a very simple synchronous mechanism to get
/dev/urandom-style bits appropriate for initial KVM PV guest RNG
seeding.

It also re-works the way that architectural random data is fed into
random.c's pools.  I added a new arch hook called arch_get_rng_seed.
The default implementation uses arch_get_random_seed_long and
arch_get_random_long, but not quite the same way as before.

x86 gets a custom arch_get_rng_seed, which is significantly enhanced
over the generic implementation.  It uses RDSEED less aggressively (the
old implementation requested 4x or 8x as many bits as would fit in the
pool, depending on kernel bitness), but, if using RDRAND, it requests
enough bits to comply with Intel's recommendations.

x86's arch_get_rng_seed will also use KVM_GET_RNG_SEED if available.
If more paravirt seed sources show up, it will be a natural place
to add them.

I sent the corresponding kvm-unit-tests and qemu changes separately.

Changes from v3:
 - Other than KASLR, the guest pieces are completely rewritten.
   Patches 2-4 have essentially nothing in common with v2.

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
  random: Add and use arch_get_rng_seed
  x86,random: Add an x86 implementation of arch_get_rng_seed
  x86,random,kvm: Use KVM_GET_RNG_SEED in arch_get_rng_seed
  x86,kaslr: Use MSR_KVM_GET_RNG_SEED for KASLR if available

 Documentation/virtual/kvm/cpuid.txt  |  3 ++
 arch/x86/Kconfig                     |  4 ++
 arch/x86/boot/compressed/aslr.c      | 27 ++++++++++
 arch/x86/include/asm/archrandom.h    |  6 +++
 arch/x86/include/asm/kvm_guest.h     |  9 ++++
 arch/x86/include/asm/processor.h     | 21 ++++++--
 arch/x86/include/uapi/asm/kvm_para.h |  2 +
 arch/x86/kernel/Makefile             |  2 +
 arch/x86/kernel/archrandom.c         | 99 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/kvm.c                | 10 ++++
 arch/x86/kvm/cpuid.c                 |  3 +-
 arch/x86/kvm/x86.c                   |  4 ++
 drivers/char/random.c                | 14 +++--
 include/linux/random.h               | 40 +++++++++++++++
 14 files changed, 237 insertions(+), 7 deletions(-)
 create mode 100644 arch/x86/kernel/archrandom.c

-- 
1.9.3

