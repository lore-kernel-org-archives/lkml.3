Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbaGOEiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 00:38:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbaGOEiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 00:38:04 -0400
Date: Tue, 15 Jul 2014 00:36:13 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        acme@ghostprotocols.net, Thomas Gleixner <tglx@linutronix.de>,
        price@mit.edu
Subject: Re: BUG_ON drivers/char/random.c:986
Message-ID: <20140715043613.GA18575@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
	Thomas Gleixner <tglx@linutronix.de>, price@mit.edu
References: <5370EBE9.6@oracle.com>
 <20140516153455.GV11096@twins.programming.kicks-ass.net>
 <53763775.3040602@linux.intel.com>
 <20140516162117.GY11096@twins.programming.kicks-ass.net>
 <1400287582.11005.118359877.7B81534B@webmail.messagingengine.com>
 <20140517021840.GA5513@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140517021840.GA5513@thunk.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 10:18:40PM -0400, Theodore Ts'o wrote:
 > On Fri, May 16, 2014 at 05:46:22PM -0700, Hannes Frederic Sowa wrote:
 > > This should do the trick:
 > > dd if=/dev/urandom of=/dev/zero bs=67108707
 > > 
 > > I suspect ee1de406ba6eb1 ("random: simplify accounting logic") as the
 > > culprit.
 > 
 > Yep, that it's it.  Thanks for noticing this so quickly!  I'll push
 > the following patch to Linus.
 > 
 >     	      	    			- Ted
 > 
 > commit 29fb0ca5b3922288fba3f4c975a55032a51df0f0
 > Author: Theodore Ts'o <tytso@mit.edu>
 > Date:   Fri May 16 21:40:41 2014 -0400
 > 
 >     random: fix BUG_ON caused by accounting simplification

I just hit this bug again on 3.16rc5, which has this patch, so
there's still some corner case that isn't happy..

(old thread is here for reference: https://lkml.org/lkml/2014/5/16/724)

kernel BUG at drivers/char/random.c:986!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
CPU: 2 PID: 29845 Comm: trinity-c65 Not tainted 3.16.0-rc5+ #22
task: ffff880096f45880 ti: ffff88017dfe8000 task.ti: ffff88017dfe8000
RIP: 0010:[<ffffffff8d420c2c>]  [<ffffffff8d420c2c>] account+0x14c/0x150
RSP: 0018:ffff88017dfebd38  EFLAGS: 00010206
RAX: 0000000000002000 RBX: 000000000027ae6c RCX: 0000000000000000
RDX: 0000000000000000 RSI: 000000000027ae6c RDI: ffffffff8dcb6840
RBP: ffff88017dfebd98 R08: ffffffff8d423490 R09: 0000000000000000
R10: ffffffff8dcb68a4 R11: 0000000000000000 R12: 00007fe396cec000
R13: 0000000000000000 R14: ffffffff8dcb6840 R15: ffffffff8da85638
FS:  00007fe39a1e2700(0000) GS:ffff88024d100000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000012e5a3000 CR4: 00000000001407e0
DR0: 000000000111b000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Stack:
 ffffffff8d423340 00000000ffffffff 00000000a4c39e97 ffffffff8dcb6840
 0000000000000002 0000000000000000 00000000a4c39e97 00007fe396cec000
 000000000027ae6c 000000000000005a 000000000027ae6c ffffffff8d423490
Call Trace:
 [<ffffffff8d423340>] ? extract_entropy_user+0x60/0x1b0
 [<ffffffff8d423490>] ? extract_entropy_user+0x1b0/0x1b0
 [<ffffffff8d4234c7>] urandom_read+0x37/0x110
 [<ffffffff8d423490>] ? extract_entropy_user+0x1b0/0x1b0
 [<ffffffff8d1d06f3>] do_loop_readv_writev+0x63/0x90
 [<ffffffff8d423490>] ? extract_entropy_user+0x1b0/0x1b0
 [<ffffffff8d1d2588>] do_readv_writev+0x268/0x280
 [<ffffffff8d11d4eb>] ? __acct_update_integrals+0x8b/0x120
 [<ffffffff8d0a935b>] ? preempt_count_sub+0xab/0x100
 [<ffffffff8d343d53>] ? __this_cpu_preempt_check+0x13/0x20
 [<ffffffff8d1d25d6>] vfs_readv+0x36/0x50
 [<ffffffff8d1d269c>] SyS_readv+0x5c/0x100
 [<ffffffff8d74ff9f>] tracesys+0xdd/0xe2
Code: cb 8d e8 d8 e0 c9 ff ba 02 00 02 00 be 1d 00 00 00 48 c7 c7 40 20 00 8e e8 d2 45 dc ff 48 89 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 <0f> 0b 66 90 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 49 89 fe 41 
RIP  [<ffffffff8d420c2c>] account+0x14c/0x150
 RSP <ffff88017dfebd38>

