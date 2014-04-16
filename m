Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaDPQqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:46:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbaDPQq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:46:27 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 0/6] Emulator speedups - avoid initializations where possible
Date: Wed, 16 Apr 2014 12:46:08 -0400
Message-Id: <1397666774-24713-1-git-send-email-bsd@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While initializing emulation context structure, kvm memsets to 0 a
number of fields some of which are redundant since they get set
eventually in x86_decode_insn. Cleanup unnecessary initializations
and remove some fields.

This is on top of Paolo's RFC
KVM: x86: speedups for emulator memory accesses
https://lkml.org/lkml/2014/4/1/494

Here are the new realmode.flat numbers with improvement
wrt unpatched kernel -

639 cycles/emulated jump instruction (4.3%)
776 cycles/emulated move instruction (7.5%)
791 cycles/emulated arithmetic instruction (11%)
943 cycles/emulated memory load instruction (5.2%)
948 cycles/emulated memory store instruction (7.6%)
929 cycles/emulated memory RMW instruction (9.0%)

v1 numbers - 
639 cycles/emulated jump instruction
786 cycles/emulated move instruction
802 cycles/emulated arithmetic instruction
936 cycles/emulated memory load instruction
970 cycles/emulated memory store instruction
1000 cycles/emulated memory RMW instruction

v3:
Minor changes as proposed in review
 - 3/6 - cleanup typos
 - 6/6 - change comment in struct x86_emulate_ctxt and add back a missing 
       	 if in decode_modrm
 
v2:
All thanks and credit to Paolo!
 - 1/6 - no change
 - 2/6 - new patch, inercept and check_perm replaced with checks for bits in ctxt->d
 - 3/6 - new patch, remove if condition in decode_rm and rearrange bit operations
 - 4/6 - remove else conditions from v1 and misc cleanups
 - 5/6 - new patch, remove seg_override and related fields and functions
 - 6/6 - new patch, remove memopp and move rip_relative to a local variable in
         decode_modrm

Bandan Das (6):
  KVM: emulate: move init_decode_cache to emulate.c
  KVM: emulate: Remove ctxt->intercept and ctxt->check_perm checks
  KVM: emulate: cleanup decode_modrm
  KVM: emulate: clean up initializations in init_decode_cache
  KVM: emulate: rework seg_override
  KVM: emulate: remove memopp and rip_relative

 arch/x86/include/asm/kvm_emulate.h | 26 +++++++-----
 arch/x86/kvm/emulate.c             | 85 ++++++++++++++++++--------------------
 arch/x86/kvm/x86.c                 | 13 ------
 3 files changed, 56 insertions(+), 68 deletions(-)

-- 
1.8.3.1

