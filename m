Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbaGNMJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 08:09:05 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:31963 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753942AbaGNMIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 08:08:55 -0400
Date: Mon, 14 Jul 2014 13:08:39 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Jean-Francois Moine <moinejf@free.fr>,
        Jason Cooper <jason@lakedaemon.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: Fix preemption disable in iwmmxt_task_enable()
Message-ID: <20140714120839.GB31617@localhost>
References: <1405069813-9270-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1405163130-3927-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405163130-3927-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 12:05:30PM +0100, Sebastian Hesselbarth wrote:
> commit 431a84b1a4f7d1a0085d5b91330c5053cc8e8b12
>  ("ARM: 8034/1: Disable preemption in iwmmxt_task_enable()")
> introduced macros {inc,dec}_preempt_count to iwmmxt_task_enable
> to make it run with preemption disabled.
> 
> Unfortunately, other functions in iwmmxt.S also use concan_{save,dump,load}
> sections located in iwmmxt_task_enable() to deal with iWMMXt coprocessor.
> This causes an unbalanced preempt_count due to excessive dec_preempt_count
> and destroyed return addresses in callers of concan_ labels due to a register
> collision:
> 
> Linux version 3.16.0-rc3-00062-gd92a333-dirty (jef@armhf) (gcc version 4.8.3 (Debian 4.8.3-4) ) #5 PREEMPT Thu Jul 3 19:46:39 CEST 2014
> CPU: ARMv7 Processor [560f5815] revision 5 (ARMv7), cr=10c5387d
> CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction cache
> Machine model: SolidRun CuBox
> ...
> PJ4 iWMMXt v2 coprocessor enabled.
> ...
> Unable to handle kernel paging request at virtual address fffffffe
> pgd = bb25c000
> [fffffffe] *pgd=3bfde821, *pte=00000000, *ppte=00000000
> Internal error: Oops: 80000007 [#1] PREEMPT ARM
> Modules linked in:
> CPU: 0 PID: 62 Comm: startpar Not tainted 3.16.0-rc3-00062-gd92a333-dirty #5
> task: bb230b80 ti: bb256000 task.ti: bb256000
> PC is at 0xfffffffe
> LR is at iwmmxt_task_copy+0x44/0x4c
> pc : [<fffffffe>]    lr : [<800130ac>]    psr: 40000033
> sp : bb257de8  ip : 00000013  fp : bb257ea4
> r10: bb256000  r9 : fffffdfe  r8 : 76e898e6
> r7 : bb257ec8  r6 : bb256000  r5 : 7ea12760  r4 : 000000a0
> r3 : ffffffff  r2 : 00000003  r1 : bb257df8  r0 : 00000000
> Flags: nZcv  IRQs on  FIQs on  Mode SVC_32  ISA Thumb  Segment user
> Control: 10c5387d  Table: 3b25c019  DAC: 00000015
> Process startpar (pid: 62, stack limit = 0xbb256248)
> 
> This patch fixes the issue by moving concan_{save,dump,load} into separate
> code sections and make iwmmxt_task_enable() call them in the same way the
> other functions use concan_ symbols. The test for valid ownership is moved
> to concan_save and is safe for the other user of it, iwmmxt_task_disable().
> The register collision is also resolved by moving concan_ symbols as
> {inc,dec}_preempt_count are now local to iwmmxt_task_enable().
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Reported-by: Jean-Francois Moine <moinejf@free.fr>
> Fixes: 431a84b1a4f7 ("ARM: 8034/1: Disable preemption in iwmmxt_task_enable()")
> ---
> The offending commit was intoduced past v3.15-rc1 and the corresponding fix
> should also be queued up for stable v3.15+
> 
> Changelog
> v1->v2:
> - return immediately from concan_ instead of branch to 3f, i.e. replace
>   'beq 3f' with 'moveq pc, lr' (Suggested by Catalin Marinas)
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Jean-Francois Moine <moinejf@free.fr>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
