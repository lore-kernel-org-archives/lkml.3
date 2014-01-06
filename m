Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbaAFIW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:22:26 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:61101 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaAFIWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:22:24 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: catalin.marinas@arm.com, will.deacon@arm.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, hpa@zytor.com, ak@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, mingo@redhat.com, nico@linaro.org,
        x86@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/8] arm64: udev autoloaded module for Crypto Extensions sync AES
Date: Mon,  6 Jan 2014 09:22:08 +0100
Message-Id: <1388996536-27014-1-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is mostly a repost of patches that I have proposed (and that have
been discussed) on the list previously. This time, I am resending it as a
coherent series to try and make a stronger case for the features I am proposing.

Patch #8 implements the core AES cipher. It relies on patches 2, 3 and 5 to
support udev autoloading of the module if the AES extension is supported by the
CPU it is running on. Patches 6 and 7 are required because the core AES cipher
may be called from interrupt context.

Patch #1 is included as a bonus/reference *only*. It is not intended to be
merged, but it allows those who would like to try this code to do so on a system
or emulator that does not have the Crypto Extensions implemented.

Patch #2 moves arch_cpu_uevent() from x86 to generic code, as it is generic in
nature and can be reused by other archs.

Patch #3 introduces a generic 'cpu' modalias type which can be used to autoload
modules based on whether the CPU supports a certain optional feature. How IDs
map to features is not specified, this is up to the arch.

Patch #4 changes the x86 specific 'x86cpu' modalias so it adheres to the syntax
introduced in patch #3. This is not strictly necessary, but it was suggested in
a discussion between H. Peter Anvin, Andi Kleen and myself, i.e., that a generic
solution should also cover the x86 use case (which has 320 feature bits already)
[http://marc.info/?l=linux-kernel&m=138384467604799&w=2]

@Peter, Andi: could I please have your ack(s) on patch #2, and possibly on
patch #4 if you still feel that all archs should use the same modalias syntax
(and you are happy with the way I implemented that)

Patch #5 enables the generic 'cpu' feature matching introduced in patch 3 for
arm64.

Patch #6 is an optimization to the arm64 kernel mode NEON code that tries to
avoid pointless saves/restores of the NEON register file.

Patch #7 adds support to the kernel mode NEON code for being called from 
interrupt context. It also adds support for partial saves/restores.

Patch #8 implements the AES core cipher.

The series depends on 4bff28ccda2b ("arm64: Add hwcaps for crypto and CRC32
extensions.") which is already in Catalin's tree and in linux-next.

Ard Biesheuvel (8):
  arm64: add kernel emulation for AES instructions
  x86: move arch_cpu_uevent() to generic code
  cpu: advertise CPU features over udev in a generic way
  x86: align with generic cpu modalias
  arm64: advertise CPU features for modalias matching
  arm64: defer reloading a task's FPSIMD state to userland resume
  arm64: add support for kernel mode NEON in atomic context
  arm64: add Crypto Extensions based synchronous core AES cipher

 arch/arm64/Kconfig                    |   3 +
 arch/arm64/Makefile                   |   2 +
 arch/arm64/crypto/Makefile            |  13 ++
 arch/arm64/crypto/aes-ce-cipher.c     | 112 ++++++++++++
 arch/arm64/emu/Makefile               |  11 ++
 arch/arm64/emu/ce-aes.c               | 331 ++++++++++++++++++++++++++++++++++
 arch/arm64/include/asm/fpsimd.h       |  20 ++
 arch/arm64/include/asm/fpsimdmacros.h |  37 ++++
 arch/arm64/include/asm/neon.h         |   6 +-
 arch/arm64/include/asm/thread_info.h  |   4 +-
 arch/arm64/include/asm/traps.h        |  10 +
 arch/arm64/kernel/entry-fpsimd.S      |  24 +++
 arch/arm64/kernel/entry.S             |   6 +-
 arch/arm64/kernel/fpsimd.c            | 108 +++++++++--
 arch/arm64/kernel/process.c           |   3 +-
 arch/arm64/kernel/setup.c             |  20 ++
 arch/arm64/kernel/signal.c            |   3 +
 arch/arm64/kernel/traps.c             |  49 +++++
 arch/x86/kernel/cpu/match.c           |  14 +-
 crypto/Kconfig                        |   6 +
 drivers/base/cpu.c                    |  15 +-
 include/linux/cpu.h                   |   1 -
 include/linux/mod_devicetable.h       |  15 ++
 scripts/mod/devicetable-offsets.c     |   3 +
 scripts/mod/file2alias.c              |  20 +-
 25 files changed, 793 insertions(+), 43 deletions(-)
 create mode 100644 arch/arm64/crypto/Makefile
 create mode 100644 arch/arm64/crypto/aes-ce-cipher.c
 create mode 100644 arch/arm64/emu/Makefile
 create mode 100644 arch/arm64/emu/ce-aes.c

-- 
1.8.3.2

