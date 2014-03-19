Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965459AbaCSP0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 11:26:33 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:50778 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965071AbaCSP0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 11:26:31 -0400
Date: Wed, 19 Mar 2014 20:56:19 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: davidlohr@hp.com
Cc: torvalds@linux-foundation.org, tglx@linutronix.de, peterz@infradead.org,
        mingo@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org,
        paulus@samba.org
Subject: Tasks stuck in futex code (in 3.14-rc6)
Message-ID: <20140319152619.GB10406@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031915-7014-0000-0000-000004896E48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

When running specjbb on a power7 numa box, I am seeing java threads
getting stuck in futex 

#  ps -Ao pid,tt,user,fname,tmout,f,wchan | grep futex
 14808 pts/0    root     java         - 0 futex_wait_queue_me
 14925 pts/0    root     java         - 0 futex_wait_queue_me
#

stack traces, I see
[ 1843.426591] Call Trace:
[ 1843.426595] [c0000017101d74d0] [0000000000000020] 0x20 (unreliable)
[ 1843.426601] [c0000017101d76a0] [c000000000014c50] .__switch_to+0x1e0/0x390
[ 1843.426607] [c0000017101d7750] [c0000000006ed314] .__schedule+0x364/0x8c0
[ 1843.426613] [c0000017101d79d0] [c000000000139c28] .futex_wait_queue_me+0xf8/0x1a0
[ 1843.426619] [c0000017101d7a60] [c00000000013afbc] .futex_wait+0x17c/0x2a0
[ 1843.426626] [c0000017101d7c10] [c00000000013cee4] .do_futex+0x254/0xd80
[ 1843.426631] [c0000017101d7d60] [c00000000013db2c] .SyS_futex+0x11c/0x1d0
[ 1843.426638] [c0000017101d7e30] [c000000000009efc] syscall_exit+0x0/0x7c
[ 1843.426643] java            S 00003fffa08b16a0     0 14812  14203 0x00000080
[ 1843.426650] Call Trace:
[ 1843.426653] [c00000170c6034d0] [c000001710b09cf8] 0xc000001710b09cf8 (unreliable)
[ 1843.426660] [c00000170c6036a0] [c000000000014c50] .__switch_to+0x1e0/0x390
[ 1843.426666] [c00000170c603750] [c0000000006ed314] .__schedule+0x364/0x8c0
[ 1843.426672] [c00000170c6039d0] [c000000000139c28] .futex_wait_queue_me+0xf8/0x1a0
[ 1843.426679] [c00000170c603a60] [c00000000013afbc] .futex_wait+0x17c/0x2a0
[ 1843.453383] [c00000170c603c10] [c00000000013cee4] .do_futex+0x254/0xd80
[ 1843.453389] [c00000170c603d60] [c00000000013db2c] .SyS_futex+0x11c/0x1d0
[ 1843.453395] [c00000170c603e30] [c000000000009efc] syscall_exit+0x0/0x7c
[ 1843.453400] java            S 00003fffa08b1a74     0 14813  14203 0x00000080
[ 1843.453407] Call Trace:

There are 332 tasks all stuck in futex_wait_queue_me().
I am able to reproduce this consistently.

Infact I can reproduce this if the java_constraint is either node, socket, system.
However I am not able to reproduce if java_constraint is set to core.

I ran git bisect between v3.12 and v3.14-rc6 and found that

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=b0c29f79ecea0b6fbcefc999e70f2843ae8306db

commit b0c29f79ecea0b6fbcefc999e70f2843ae8306db
Author: Davidlohr Bueso <davidlohr@hp.com>
Date:   Sun Jan 12 15:31:25 2014 -0800

futexes: Avoid taking the hb->lock if there's nothing to wake up

was the commit thats causing the threads to be stuck in futex.

I reverted b0c29f79ecea0b6fbcefc999e70f2843ae8306db on top of v3.14-rc6 and confirmed that
reverting the commit solved the problem.

-- 
Thanks and Regards
Srikar Dronamraju

