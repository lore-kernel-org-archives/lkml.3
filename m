Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab3DMKqg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 06:46:36 -0400
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:57794 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab3DMKqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 06:46:34 -0400
Subject: [RFC PATCH 0/6] Add AVX2 accelerated implementations for Blowfish,
 Twofish, Serpent and Camellia
To: linux-crypto@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>
Date: Sat, 13 Apr 2013 13:46:29 +0300
Message-ID: <20130413104245.10667.62267.stgit@localhost6.localdomain6>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements four block ciphers - Blowfish, Twofish, Serpent
and Camellia - using AVX2 instruction set. This work on AVX2 implementations
started over year ago and have been available at
	https://github.com/jkivilin/crypto-avx2

The Serpent and Camellia implementations are directly based on the word-sliced
and byte-sliced AVX implementations and have been extended to use the 256-bit
YMM registers. As such the performance should be better than with the 128-bit
wide AVX implementations. (Camellia implementation needs some extra handling
for the AES-NI as AES instructions have remained only 128-bit wide.)

Blowfish and Twofish implementations utilize the new vpgatherdd instruction to
perform eight vectorized 8x32-bit table look-ups at once. This is different
from the previous word-sliced AVX implementations, where table look-ups have
to performed through general purpose registers. AVX2 implementations thus
avoid additional moving of data between the SIMD and general purpose registers
and therefore should be faster.

For obvious reasons, I have not tested these implementations on real hardware.
Kernel tcrypt tests have been run under Bochs, which should contain somewhat
working AVX2 implementation. But I cannot be sure, even the Intel SDE emulator
that I used for testing these implementations did not quite follow the specs
(a past version of SDE that I initially used allowed vector registers to
vgather be same, whereas specs say that in such case exception should be
raised). Because of this, the first versions of patchset in above repository
are broken.

So since I'm unable to verify that these implementations work on real hardware
and are unable to conduct real performance evaluation, I'm sending this
patchset as RFC. Maybe someone can actually test these on real hardware and
maybe give acked-by in case these look ok(?). If such is not possible, I'll
do the testing myself when those Haswell processors come available where I
live.

-Jussi

---

Jussi Kivilinna (6):
      crypto: testmgr - extend camellia test-vectors for camellia-aesni/avx2
      crypto: tcrypt - add async cipher speed tests for blowfish
      crypto: blowfish - add AVX2/x86_64 implementation of blowfish cipher
      crypto: twofish - add AVX2/x86_64 assembler implementation of twofish cipher
      crypto: serpent - add AVX2/x86_64 assembler implementation of serpent cipher
      crypto: camellia - add AVX2/AES-NI/x86_64 assembler implementation of camellia cipher


 arch/x86/crypto/Makefile                     |   17 
 arch/x86/crypto/blowfish-avx2-asm_64.S       |  449 +++++++++
 arch/x86/crypto/blowfish_avx2_glue.c         |  585 +++++++++++
 arch/x86/crypto/blowfish_glue.c              |   32 -
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S | 1368 ++++++++++++++++++++++++++
 arch/x86/crypto/camellia_aesni_avx2_glue.c   |  586 +++++++++++
 arch/x86/crypto/camellia_aesni_avx_glue.c    |   17 
 arch/x86/crypto/glue_helper-asm-avx2.S       |  180 +++
 arch/x86/crypto/serpent-avx2-asm_64.S        |  800 +++++++++++++++
 arch/x86/crypto/serpent_avx2_glue.c          |  562 +++++++++++
 arch/x86/crypto/serpent_avx_glue.c           |   62 +
 arch/x86/crypto/twofish-avx2-asm_64.S        |  600 +++++++++++
 arch/x86/crypto/twofish_avx2_glue.c          |  584 +++++++++++
 arch/x86/crypto/twofish_avx_glue.c           |   14 
 arch/x86/include/asm/cpufeature.h            |    1 
 arch/x86/include/asm/crypto/blowfish.h       |   43 +
 arch/x86/include/asm/crypto/camellia.h       |   19 
 arch/x86/include/asm/crypto/serpent-avx.h    |   24 
 arch/x86/include/asm/crypto/twofish.h        |   18 
 crypto/Kconfig                               |   88 ++
 crypto/tcrypt.c                              |   15 
 crypto/testmgr.c                             |   51 +
 crypto/testmgr.h                             | 1100 ++++++++++++++++++++-
 23 files changed, 7128 insertions(+), 87 deletions(-)
 create mode 100644 arch/x86/crypto/blowfish-avx2-asm_64.S
 create mode 100644 arch/x86/crypto/blowfish_avx2_glue.c
 create mode 100644 arch/x86/crypto/camellia-aesni-avx2-asm_64.S
 create mode 100644 arch/x86/crypto/camellia_aesni_avx2_glue.c
 create mode 100644 arch/x86/crypto/glue_helper-asm-avx2.S
 create mode 100644 arch/x86/crypto/serpent-avx2-asm_64.S
 create mode 100644 arch/x86/crypto/serpent_avx2_glue.c
 create mode 100644 arch/x86/crypto/twofish-avx2-asm_64.S
 create mode 100644 arch/x86/crypto/twofish_avx2_glue.c
 create mode 100644 arch/x86/include/asm/crypto/blowfish.h

-- 

