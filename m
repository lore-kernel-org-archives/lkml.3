Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaHNFoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 01:44:14 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34388 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaHNFoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 01:44:13 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, x86@kernel.org
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Honig <ahonig@google.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v6 0/7] random,x86,kvm: Rework arch RNG seeds and get some from kvm
Date: Wed, 13 Aug 2014 22:43:54 -0700
Message-Id: <cover.1407994704.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces and uses a very simple synchronous mechanism to get
/dev/urandom-style bits appropriate for initial KVM PV guest RNG
seeding.

It also re-works the way that architectural random data is fed into
random.c's pools.  Timekeeping randomness now comes directly from
the timekeeping core rather than being pulled in from init_std_data,
and timekeeping randomness is added both on boot and on resume.  I
added a new arch hook called arch_rng_init.  The default
implementation is more or less the same as the current code, except
that random_get_entropy is now called unconditionally.  We now also
call init_std_data on resume.

x86 gets a custom arch_rng_init.  It will use KVM_GET_RNG_SEED if
available, and, if it does anything, it will log the number of bits
collected from each available architectural source.  If more
paravirt seed sources show up, it will be a natural place to add
them.

I sent the corresponding kvm-unit-tests and qemu changes separately.

Changes from v5:
 - Moved the generic changes to the beginning.
 - Renamed arch_get_rng_seed to arch_rng_init.
 - The timekeeping change is new.
 - random.c registers a syscore callback to reseed on resume.

Changes from v4:
 - Got rid of the RDRAND behavior change.  If this series is accepted,
   I may resend it separately, but I think it's an unrelated issue.
 - Fix up the changelog entries -- I misunderstood how the old code
   worked.
 - Avoid lots of failed attempts to use KVM_GET_RNG_SEED if it's not
   available.

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

Andy Lutomirski (7):
  random: Add and use arch_rng_init
  random, timekeeping: Collect timekeeping entropy in the timekeeping
    code
  random: Reseed pools on resume
  x86,kvm: Add MSR_KVM_GET_RNG_SEED and a matching feature bit
  x86,random: Add an x86 implementation of arch_rng_init
  x86,random,kvm: Use KVM_GET_RNG_SEED in arch_rng_init
  x86,kaslr: Use MSR_KVM_GET_RNG_SEED for KASLR if available

 Documentation/virtual/kvm/cpuid.txt  |  3 ++
 arch/x86/Kconfig                     |  4 ++
 arch/x86/boot/compressed/aslr.c      | 27 +++++++++++++
 arch/x86/include/asm/archrandom.h    |  6 +++
 arch/x86/include/asm/kvm_guest.h     |  9 +++++
 arch/x86/include/asm/processor.h     | 21 ++++++++--
 arch/x86/include/uapi/asm/kvm_para.h |  2 +
 arch/x86/kernel/Makefile             |  2 +
 arch/x86/kernel/archrandom.c         | 74 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/kvm.c                | 10 +++++
 arch/x86/kvm/cpuid.c                 |  3 +-
 arch/x86/kvm/x86.c                   |  4 ++
 drivers/char/random.c                | 42 ++++++++++++++++----
 include/linux/random.h               | 40 +++++++++++++++++++
 kernel/time/timekeeping.c            | 11 ++++++
 15 files changed, 246 insertions(+), 12 deletions(-)
 create mode 100644 arch/x86/kernel/archrandom.c

-- 
1.9.3

