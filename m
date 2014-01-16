Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaAPSFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:05:42 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:64584 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaAPSFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:05:33 -0500
Date: Thu, 16 Jan 2014 10:05:32 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Kernel stack overflows due to  "powerpc: Remove ksp_limit on ppc64"
 with v3.13-rc8 on ppc32 (P2020)
Message-ID: <20140116180532.GA1616@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am getting kernel stack overflows with v3.13-rc8 on a system with P2020 CPU.
The kernel is patched for the target, but I don't think that is related.
Stack overflows are in different areas, but always in calls from __do_softirq.

Crashes happen reliably either during boot or if I put any kind of load
onto the system.

Example:

Kernel stack overflow in process eb3e5a00, r1=eb79df90
CPU: 0 PID: 2838 Comm: ssh Not tainted 3.13.0-rc8-juniper-00146-g19eca00 #4
task: eb3e5a00 ti: c0616000 task.ti: ef440000
NIP: c003a420 LR: c003a410 CTR: c0017518
REGS: eb79dee0 TRAP: 0901   Not tainted (3.13.0-rc8-juniper-00146-g19eca00)
MSR: 00029000 <CE,EE,ME>  CR: 24008444  XER: 00000000
GPR00: c003a410 eb79df90 eb3e5a00 00000000 eb05d900 00000001 65d87646 00000000
GPR08: 00000000 020b8000 00000000 00000000 44008442
NIP [c003a420] __do_softirq+0x94/0x1ec
LR [c003a410] __do_softirq+0x84/0x1ec
Call Trace:
[eb79df90] [c003a410] __do_softirq+0x84/0x1ec (unreliable)
[eb79dfe0] [c003a970] irq_exit+0xbc/0xc8
[eb79dff0] [c000cc1c] call_do_irq+0x24/0x3c
[ef441f20] [c00046a8] do_IRQ+0x8c/0xf8
[ef441f40] [c000e7f4] ret_from_except+0x0/0x18
--- Exception: 501 at 0xfcda524
    LR = 0x10024900
Instruction dump:
7c781b78 3b40000a 3a73b040 543c0024 3a800000 3b3913a0 7ef5bb78 48201bf9
5463103a 7d3b182e 7e89b92e 7c008146 <3ba00000> 7e7e9b78 48000014 57fff87f
Kernel panic - not syncing: kernel stack overflow
CPU: 0 PID: 2838 Comm: ssh Not tainted 3.13.0-rc8-juniper-00146-g19eca00 #4
Call Trace:
Rebooting in 180 seconds..

Reverting the following commit fixes the problem.

cbc9565ee8 "powerpc: Remove ksp_limit on ppc64"

Should I submit a patch reverting this commit, or is there a better way to fix
the problem on short notice (given that 3.13 is close) ?

Thanks,
Guenter
