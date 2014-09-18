Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbaIRRWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 13:22:52 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34436 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714AbaIRRWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 13:22:51 -0400
From: bsegall@google.com
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: NULL ptr deref in update_blocked_averages
References: <5419FD5F.7090407@oracle.com>
Date: Thu, 18 Sep 2014 10:22:48 -0700
In-Reply-To: <5419FD5F.7090407@oracle.com> (Sasha Levin's message of "Wed, 17
	Sep 2014 17:30:07 -0400")
Message-ID: <xm26fvforggn.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <sasha.levin@oracle.com> writes:

> Hi all,
>
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel, I've stumbled on the following spew:
>
> [  688.177091] BUG: unable to handle kernel NULL pointer dereference at 00000000000000e0
> [  688.184049] IP: update_blocked_averages (kernel/sched/fair.c:5512 (discriminator 17) kernel/sched/fair.c:5557 (discriminator 17))
> [  688.186981] PGD 66fe03067 PUD 66f550067 PMD 0
> [  688.186981] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [  688.186981] Dumping ftrace buffer:
> [  688.186981]    (ftrace buffer empty)
> [  688.186981] Modules linked in:
> [  688.186981] CPU: 2 PID: 14377 Comm: trinity-c269 Tainted: G        W      3.17.0-rc5-next-20140917-sasha-00041-gd01267b #1198
> [  688.186981] task: ffff88068c02b000 ti: ffff8806478ec000 task.ti: ffff8806478ec000
> [  688.186981] RIP: update_blocked_averages (kernel/sched/fair.c:5512 (discriminator 17) kernel/sched/fair.c:5557 (discriminator 17))
...
> [ 688.186981] Code: 30 09 00 00 4d 8d a5 40 ff ff ff 4d 39 ef 0f 84 95 02 00 00 0f 1f 84 00 00 00 00 00 49 8b 84 24 d0 00 00 00 48 63 93 f8 09 00 00 <48> 8b 88 e0 00 00 00 4c 8b 2c d1 66 66 66 66 90 48 8b 80 d8 00
> All code
> ========
>    0:	30 09                	xor    %cl,(%rcx)
>    2:	00 00                	add    %al,(%rax)
>    4:	4d 8d a5 40 ff ff ff 	lea    -0xc0(%r13),%r12
>    b:	4d 39 ef             	cmp    %r13,%r15
>    e:	0f 84 95 02 00 00    	je     0x2a9
>   14:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
>   1b:	00
>   1c:	49 8b 84 24 d0 00 00 	mov    0xd0(%r12),%rax
>   23:	00
>   24:	48 63 93 f8 09 00 00 	movslq 0x9f8(%rbx),%rdx
>   2b:*	48 8b 88 e0 00 00 00 	mov    0xe0(%rax),%rcx		<-- trapping instruction
>   32:	4c 8b 2c d1          	mov    (%rcx,%rdx,8),%r13
>   36:	66 66 66 66 90       	data32 data32 data32 xchg %ax,%ax

I believe this is the tg->cfs_rq deference failing in
__update_blocked_averages_cpu, ie tg == NULL, which means that some
cfs_rq->tg is NULL, but tg is set on cgroup creation and never cleared.
I don't see a plausible use-after-free, but I don't know the cgroup rules.
