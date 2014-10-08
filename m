Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbaJHJEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:04:32 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:51045 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755684AbaJHJE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 05:04:26 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Wed, 8 Oct 2014 10:03:36 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>,
        yrl.pp-manager.tt@hitachi.com, Borislav Petkov <bpetkov@suse.de>,
        Ingo Molnar <mingo@kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: i915.ko WC writes are slow after ea8596bb2d8d379
Message-ID: <20141008090336.GD12897@nuc-i3427.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I ran into a problem on a Sandybridge i5-2500s whilst measuring the
performance of GTT write-combining access. I found subsequent runs were
about 10-40x slower than the first. For example,

igt/gem_gtt_speed:

Time to read 16k through a GTT map:             325.285탎
Time to write 16k through a GTT map:              4.729탎
Time to clear 16k through a GTT map:              4.584탎
Time to clear 16k through a cached GTT map:       1.342탎

on the second run became:

Time to read 16k through a GTT map:             332.148탎
Time to write 16k through a GTT map:            209.411탎
Time to clear 16k through a GTT map:             56.460탎
Time to clear 16k through a cached GTT map:      50.897탎

Naively I would say that we lost the wc on our ioremap.
/sys/kernel/debug/x86/pat_memtype_list remained the same across repeated
runs.

A bisection pointed to 

commit ea8596bb2d8d37957f3e92db9511c50801689180
Author: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date:   Thu Jul 18 20:47:53 2013 +0900

    kprobes/x86: Remove unused text_poke_smp() and text_poke_smp_batch() functions

of which the active ingredient was just

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b32ebf9..f4001e0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2334,7 +2334,6 @@ config HAVE_ATOMIC_IOMAP
 
 config HAVE_TEXT_POKE_SMP
        bool
-       select STOP_MACHINE if SMP
 
 config X86_DEV_DMA_OPS
        bool

and adding that back into the current build, e.g.

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3632743..48a8a69 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -87,6 +87,7 @@ config X86
        select HAVE_USER_RETURN_NOTIFIER
        select ARCH_BINFMT_ELF_RANDOMIZE_PIE
        select HAVE_ARCH_JUMP_LABEL
+       select STOP_MACHINE
        select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
        select SPARSE_IRQ
        select GENERIC_FIND_FIRST_BIT

fixes the regression.

For the record, this kernel build doesn't use modules, which seems relevant
in light of ea8596bb2 "fixes a Kconfig dependency issue on STOP_MACHINE
in the case of CONFIG_SMP && !CONFIG_MODULE_UNLOAD".
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
