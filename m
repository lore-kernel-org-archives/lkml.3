Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbaEGTVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:21:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52554 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaEGTVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:21:24 -0400
Date: Wed, 7 May 2014 12:18:33 -0700
From: tip-bot for Vineet Gupta <tipbot@zytor.com>
Message-ID: <tip-69902c718c0b476e94ed7fccd3cf29ca39fe433a@git.kernel.org>
Cc: mingo@kernel.org, rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        Vineet.Gupta1@synopsys.com, rdunlap@infradead.org, arnd@arndb.de,
        jeremy@goop.org, dl9pf@gmx.de, sparse@chrisli.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com,
        Anton.Kolesov@synopsys.com, anil.s.keshavamurthy@intel.com,
        davem@davemloft.net, ananth@in.ibm.com, vgupta@synopsys.com,
        masami.hiramatsu.pt@hitachi.com, chrisw@sous-sol.org,
        akataria@vmware.com
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org,
        rusty@rustcorp.com.au, Vineet.Gupta1@synopsys.com,
        rdunlap@infradead.org, arnd@arndb.de, jeremy@goop.org, dl9pf@gmx.de,
        sparse@chrisli.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com, Anton.Kolesov@synopsys.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, vgupta@synopsys.com,
        chrisw@sous-sol.org, akataria@vmware.com
In-Reply-To: <5361DB14.7010406@synopsys.com>
References: <5361DB14.7010406@synopsys.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/kprobes] kprobes: Ensure blacklist data is aligned
Git-Commit-ID: 69902c718c0b476e94ed7fccd3cf29ca39fe433a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  69902c718c0b476e94ed7fccd3cf29ca39fe433a
Gitweb:     http://git.kernel.org/tip/69902c718c0b476e94ed7fccd3cf29ca39fe433a
Author:     Vineet Gupta <Vineet.Gupta1@synopsys.com>
AuthorDate: Thu, 1 May 2014 10:56:44 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 21:04:57 +0200

kprobes: Ensure blacklist data is aligned

ARC Linux (not supporting native unaligned access) was failing
to boot because __start_kprobe_blacklist was not aligned.

This was because per generated vmlinux.lds it was emitted right
next to .rodata with strings etc hence could be randomly
unaligned.

Fix that by ensuring a word alignment. While 4 would suffice for
32bit arches and problem at hand, it is probably better to put 8.

| Path: (null) CPU: 0 PID: 1 Comm: swapper Not tainted
| 3.15.0-rc3-next-20140430 #2
| task: 8f044000 ti: 8f01e000 task.ti: 8f01e000
|
| [ECR   ]: 0x00230400 => Misaligned r/w from 0x800fb0d3
| [EFA   ]: 0x800fb0d3
| [BLINK ]: do_one_initcall+0x86/0x1bc
| [ERET  ]: init_kprobes+0x52/0x120

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: <torvalds@linux-foundation.org>
Cc: <rusty@rustcorp.com.au>
Cc: <rdunlap@infradead.org>
Cc: <jeremy@goop.org>
Cc: <arnd@arndb.de>
Cc: <dl9pf@gmx.de>
Cc: <sparse@chrisli.org>
Cc: <anil.s.keshavamurthy@intel.com>
Cc: <davem@davemloft.net>
Cc: <ananth@in.ibm.com>
Cc: <masami.hiramatsu.pt@hitachi.com>
Cc: <chrisw@sous-sol.org>
Cc: <akataria@vmware.com>
Cc: anton Kolesov <Anton.Kolesov@synopsys.com>
Link: http://lkml.kernel.org/r/5361DB14.7010406@synopsys.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/asm-generic/vmlinux.lds.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 40ceb3c..8e0204a 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -110,7 +110,8 @@
 #endif
 
 #ifdef CONFIG_KPROBES
-#define KPROBE_BLACKLIST()	VMLINUX_SYMBOL(__start_kprobe_blacklist) = .; \
+#define KPROBE_BLACKLIST()	. = ALIGN(8);				      \
+				VMLINUX_SYMBOL(__start_kprobe_blacklist) = .; \
 				*(_kprobe_blacklist)			      \
 				VMLINUX_SYMBOL(__stop_kprobe_blacklist) = .;
 #else
