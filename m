Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbaGPCsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 22:48:24 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60946 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaGPCsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 22:48:22 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, x86@kernel.org
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/4] random,x86,kvm: Add and use MSR_KVM_GET_RNG_SEED
Date: Tue, 15 Jul 2014 19:48:06 -0700
Message-Id: <cover.1405477965.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio-rng is both too complicated and insufficient for initial rng
seeding.  It's far too complicated to use for KASLR or any other
early boot random number needs.  It also provides /dev/random-style
bits, which means that making guest boot wait for virtio-rng is
unacceptably slow, and doing it asynchronously means that
/dev/urandom might be predictable when userspace starts.

This introduces a very simple synchronous mechanism to get
/dev/urandom-style bits.

This is a KVM change: am I supposed to write a unit test somewhere?

Andy Lutomirski (4):
  x86,kvm: Add MSR_KVM_GET_RNG_SEED and a matching feature bit
  random,x86: Add arch_get_slow_rng_u64
  random: Seed pools from arch_get_slow_rng_u64 at startup
  x86,kaslr: Use MSR_KVM_GET_RNG_SEED for KASLR if available

 Documentation/virtual/kvm/cpuid.txt  |  3 +++
 arch/x86/Kconfig                     |  4 ++++
 arch/x86/boot/compressed/aslr.c      | 27 +++++++++++++++++++++++++++
 arch/x86/include/asm/archslowrng.h   | 30 ++++++++++++++++++++++++++++++
 arch/x86/include/uapi/asm/kvm_para.h |  2 ++
 arch/x86/kernel/kvm.c                | 22 ++++++++++++++++++++++
 arch/x86/kvm/cpuid.c                 |  3 ++-
 arch/x86/kvm/x86.c                   |  4 ++++
 drivers/char/random.c                | 14 +++++++++++++-
 include/linux/random.h               |  9 +++++++++
 10 files changed, 116 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/include/asm/archslowrng.h

-- 
1.9.3

