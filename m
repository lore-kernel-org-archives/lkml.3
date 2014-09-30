Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbaI3DL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 23:11:57 -0400
Received: from outbound-smtp05.blacknight.com ([81.17.249.38]:38843 "EHLO
	outbound-smtp05.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755232AbaI3DLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 23:11:55 -0400
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
To: mingo@redhat.com, davej@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        hmh@hmh.eng.br, x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCH 0/3] Quark X1000 Cache/TLB reporting/fixes
Date: Tue, 30 Sep 2014 04:11:47 +0100
Message-Id: <1412046710-2686-1-git-send-email-pure.logic@nexus-software.ie>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First patch:
legacy_cache_size is currently not reachable code from kernels compiled
CONFIG_X86_32 despite most/all legacy_cache_size code being ifdef'd
CONFIG_X86_32. Added to which for Intel, AMD and VIA processors that return
a valid vendor string via cpuid and hook code into c_init and friends the
legacy_cache_size code won't run. So the first patch adds in a call to
default_init when the x86_vendor is valid i.e. when
x86_vendor != X86_VENDOR_UNKNOWN. This ensures for processors that report
a vendor string like "GenuineIntel" that the legacy_cache_size code will
still run.

Second patch:
Quark X1000 contains a 16k 4-way set associative unified L1 cache
with 256 sets. The second patch gets Quark X1000 reporting 16k of
cache in-line with other legacy reporting processors like PIII Tualatin

Third patch:
Final patch adds a comment to arch/x86/kernel/setup.c. Quark SoC X1000
advertises PGE via cpuid but doesn't infact implement the functionality
to support global pages in the TLB.
Linux will by default toggle CR4.PGE for processors that advertise PGE
A fix is already in place to ensure __flush_tlb() as opposed to
__flush_tlb_all() is called during normal operation.

Since __flush_tlb() just rewrites CR3 there's no need to take any further
action on Quark after writing CR3 in setup.c to flush the TLB. We comment
that behaviour. Note cpu_has_pge() will be nuked later in the boot but,
changing the value at this phase of the boot is considered harmful and so
instead we have agreed to comment the existing code

Bryan O'Donoghue (3):
  x86: Bugfix bit-rot in the calling of legacy_cache_size
  x86: Quark: Update cache reporting, add Quark SoC X1000 string
  x86: Quark: Comment setup_arch for TLB/PGE bugfix

 arch/x86/kernel/cpu/common.c | 13 ++++++++++---
 arch/x86/kernel/cpu/intel.c  | 20 ++++++++++++++++++--
 arch/x86/kernel/setup.c      | 12 ++++++++++++
 3 files changed, 40 insertions(+), 5 deletions(-)

-- 
1.9.1

