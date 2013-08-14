Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972Ab3HNPja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 11:39:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60656 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758769Ab3HNPj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 11:39:27 -0400
Message-ID: <1376494751.7355.28.camel@marge.simpson.net>
Subject: Re: [RFC][PATCH 0/5] preempt_count rework
From: Mike Galbraith <bitbucket@online.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Date: Wed, 14 Aug 2013 17:39:11 +0200
In-Reply-To: <520B8A81.1080405@zytor.com>
References: <20130814131539.790947874@chello.nl>
	 <520B8A81.1080405@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:eA/oUHYtesKC1XeQdGLHrgzaXA58KObPYuS7p0NZTRC
 w4YV52IYjjuXANTsPrI4FbiKWlkqSy5eKFrBpdqRTwqv2jc9xT
 mSBE1O0Y0Oi3uGM3uoR6BPd9pdfPMrH4NDU7yV8uEF/HWbcIZk
 H8qvX61vSfzNmewvD//trgQho+W2X5343m21YQROLs95idr3d7
 9S/hyklQTt+piKZNVXLPIKEvg927FSnKe/8S8h975ywM2YZnKT
 Skq84aAyliZzZ5i2dtDzKanDn52YB8mFii1n30HdloJlPCUiey
 9P4oXyHpA0HwoKukYIoBYA1euczEcyDLNDVuaQM30ArbCucy5W
 Z73qViZdt8kTY6rhRUWq+MzHpwNohtPN4aS8mKKfLjikDZpuHm
 KP8E6B8QhPNvg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-14 at 06:47 -0700, H. Peter Anvin wrote:

> On x86, you never want to take the address of a percpu variable if you
> can avoid it, as you end up generating code like:
> 
> 	movq %fs:0,%rax
> 	subl $1,(%rax)

Hmmm..

#define cpu_rq(cpu)             (&per_cpu(runqueues, (cpu)))
#define this_rq()               (&__get_cpu_var(runqueues))

ffffffff81438c7f:       48 c7 c3 80 11 01 00    mov    $0x11180,%rbx
        /*
         * this_rq must be evaluated again because prev may have moved
         * CPUs since it called schedule(), thus the 'rq' on its stack
         * frame will be invalid.
         */
        finish_task_switch(this_rq(), prev);
ffffffff81438c86:       e8 25 b4 c0 ff          callq  ffffffff810440b0 <finish_task_switch>
                 * The context switch have flipped the stack from under us
                 * and restored the local variables which were saved when
                 * this task called schedule() in the past. prev == current
                 * is still correct, but it can be moved to another cpu/rq.
                 */
                cpu = smp_processor_id();
ffffffff81438c8b:       65 8b 04 25 b8 c5 00    mov    %gs:0xc5b8,%eax
ffffffff81438c92:       00
                rq = cpu_rq(cpu);
ffffffff81438c93:       48 98                   cltq
ffffffff81438c95:       48 03 1c c5 00 f3 bb    add    -0x7e440d00(,%rax,8),%rbx

..so could the rq = cpu_rq(cpu) sequence be improved cycle expenditure
wise by squirreling rq pointer away in a percpu this_rq, and replacing
cpu_rq(cpu) above with a __this_cpu_read(this_rq) version of this_rq()?

-Mike

