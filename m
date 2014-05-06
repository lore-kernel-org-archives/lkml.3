Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbaEFSQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 14:16:26 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:44490 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaEFSQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 14:16:22 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, bsd@redhat.com
Subject: [RFC PATCH 0/4] KVM: emulator: speed up instruction fetch
Date: Tue,  6 May 2014 20:16:11 +0200
Message-Id: <1399400175-23754-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small series provides another ~6% speedup on top of Bandan's patches.
It does so by speeding up instruction fetches.  The three tricks, one per
patch, are to help the compiler a bit by redistributing the work between
do_insn_fetch_byte and do_insn_fetch, to avoid repeated checks on the
boundary of the fetch cache, and to exploit the processor's support for
unaligned accesses.

Before:
   819 cycles/emulated jump instruction
   1020 cycles/emulated move instruction
   1026 cycles/emulated arithmetic instruction
   1264 cycles/emulated memory load instruction
   1182 cycles/emulated memory store instruction
   1299 cycles/emulated memory RMW instruction

After:
   771 cycles/emulated jump instruction
   963 cycles/emulated move instruction
   960 cycles/emulated arithmetic instruction
   1192 cycles/emulated memory load instruction
   1110 cycles/emulated memory store instruction
   1228 cycles/emulated memory RMW instruction

Paolo Bonzini (4):
  KVM: emulate: speed up do_insn_fetch
  KVM: emulate: avoid repeated calls to do_insn_fetch_bytes
  KVM: emulate: avoid per-byte copying in instruction fetches
  KVM: emulate: put pointers in the fetch_cache

 arch/x86/include/asm/kvm_emulate.h |  4 +-
 arch/x86/kvm/emulate.c             | 97 ++++++++++++++++++++------------------
 arch/x86/kvm/trace.h               |  6 +--
 3 files changed, 57 insertions(+), 50 deletions(-)

-- 
1.8.3.1

