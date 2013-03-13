Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030Ab3CMN2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 09:28:40 -0400
Received: from mta-out.inet.fi ([195.156.147.13]:45679 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab3CMN2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 09:28:39 -0400
From: Timo Juhani Lindfors <timo.lindfors@iki.fi>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Kosina <jkosina@suse.cz>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        yrl.pp-manager.tt@hitachi.com, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip ] [BUGFIX] kprobes: Move hash_64() into .text.kprobe section
References: <20130311142233.19885.10567.stgit@mhiramat-M0-7522>
	<CA+55aFz28CvntOMF-Te0x=gn=XQcU8Zzi6E0iAhZb9mG5J-Ppg@mail.gmail.com>
	<514023AA.4070004@hitachi.com>
Date: Wed, 13 Mar 2013 15:28:29 +0200
In-Reply-To: <514023AA.4070004@hitachi.com> (Masami Hiramatsu's message of
	"Wed, 13 Mar 2013 15:58:50 +0900")
Message-ID: <847glb8m4i.fsf@sauna.l.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:
> OK, then I'll update it to just use __always_inline.

I get a similar case of infinite recursion if I try to kprobe
"inat_get_opcode_attribute":

PID: 3028   TASK: ffff88003c67e8c0  CPU: 1   COMMAND: "insmod"
 #0 [ffff88003d60b9b8] __schedule at ffffffff813777f8
 #1 [ffff88003d60b9d0] inat_get_opcode_attribute at ffffffff811c95a9
 #2 [ffff88003d60b9e0] notifier_call_chain at ffffffff8137b5a3
 #3 [ffff88003d60ba20] notify_die at ffffffff8137b60c
 #4 [ffff88003d60ba50] do_int3 at ffffffff81378fa0
 #5 [ffff88003d60ba70] xen_int3 at ffffffff8137887e
    [exception RIP: inat_get_opcode_attribute+1]
    RIP: ffffffff811c95a9  RSP: ffff88003d60bb20  RFLAGS: 00000006
    RAX: 0000000000000200  RBX: ffffffffa00070f0  RCX: 00000000ffffffff
    RDX: ffff88003f80dd90  RSI: ffff88003d60bcc8  RDI: 0000000000000040
    RBP: ffffffffa019b000   R8: 0000000000000000   R9: ffffffff81629b10
    R10: 00000000000066a8  R11: ffffffffa019b000  R12: ffff88003f80dd90
    R13: ffffffff811c95a8  R14: ffffffff811c95a9  R15: ffffffffa019b010
    ORIG_RAX: ffffffffffffffff  CS: 10000e030  SS: e02b
 #6 [ffff88003d60bb20] skip_prefixes at ffffffff81379b6e
 #7 [ffff88003d60bb30] set_current_kprobe.isra.4 at ffffffff81379bb0
 #8 [ffff88003d60bb40] kprobe_exceptions_notify at ffffffff8137a446
 #9 [ffff88003d60bba0] notifier_call_chain at ffffffff8137b5a3
#10 [ffff88003d60bbe0] notify_die at ffffffff8137b60c
#11 [ffff88003d60bc10] do_int3 at ffffffff81378fa0
#12 [ffff88003d60bc30] xen_int3 at ffffffff8137887e
    [exception RIP: inat_get_opcode_attribute+1]
    RIP: ffffffff811c95a9  RSP: ffff88003d60bce0  RFLAGS: 00000246
    RAX: 0000000000000001  RBX: ffff88003d60bdb0  RCX: 0000000000000000
    RDX: ffff88003d60be10  RSI: ffff88003d60be10  RDI: 0000000000000040
    RBP: 0000000000000000   R8: ffff88003d60bdb0   R9: ffffffff811c95a8
    R10: 00000000000066a8  R11: ffffffffa019b000  R12: ffffffff811c9540
    R13: ffffffff811c95ad  R14: 0000000000000000  R15: ffffffffa019b010
    ORIG_RAX: ffffffffffffffff  CS: e030  SS: e02b
#13 [ffff88003d60bce0] insn_get_prefixes at ffffffff811c9721
#14 [ffff88003d60bd10] insn_get_opcode at ffffffff811c9923
#15 [ffff88003d60bd30] insn_get_modrm at ffffffff811c9a2e
#16 [ffff88003d60bd50] insn_get_sib at ffffffff811c9af8
#17 [ffff88003d60bd60] insn_get_displacement at ffffffff811c9b5d
#18 [ffff88003d60bd70] insn_get_immediate at ffffffff811c9c48
#19 [ffff88003d60bd80] insn_get_length at ffffffff811c9f97
#20 [ffff88003d60bd90] can_optimize at ffffffff8137a96e
#21 [ffff88003d60be50] arch_prepare_optimized_kprobe at ffffffff8137ab2c
#22 [ffff88003d60bea0] alloc_aggr_kprobe.isra.17 at ffffffff8137bb9b
#23 [ffff88003d60bec0] register_kprobe at ffffffff8137cf16
#24 [ffff88003d60bf00] init_module at ffffffffa001101b [testcase1]
#25 [ffff88003d60bf10] do_one_initcall at ffffffff810020b6
#26 [ffff88003d60bf40] sys_init_module at ffffffff81083c4f
#27 [ffff88003d60bf80] system_call_fastpath at ffffffff8137d6e9
    RIP: 00007f0fec23814a  RSP: 00007fff29328218  RFLAGS: 00000206
    RAX: 00000000000000af  RBX: ffffffff8137d6e9  RCX: 00007f0fec23448a
    RDX: 00007f0fed0b0010  RSI: 000000000002be0b  RDI: 00007f0fec8df000
    RBP: 00007f0fed0b11d0   R8: 0000000000000003   R9: 0000000000000000
    R10: 00007f0fec23448a  R11: 0000000000000206  R12: 00007f0fed0b0010
    R13: 00007f0fed0b12a0  R14: 00007f0fed0b00c0  R15: 0000000000000000
    ORIG_RAX: 00000000000000af  CS: e033  SS: e02b
