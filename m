Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbaDBHOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:14:54 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:47903 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989AbaDBHOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:14:52 -0400
Date: Wed, 2 Apr 2014 09:14:45 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [GIT PULL] s390 patches for the 3.15 merge window
Message-ID: <20140402091445.65c6b660@mschwide>
In-Reply-To: <alpine.LFD.2.11.1404010827140.26309@i7.linux-foundation.org>
References: <20140331092400.17071766@mschwide>
	<CA+55aFzPP6kBzWrcvps6NVu=f-FUtrfs1U6DyRpdwX6hH6PM-Q@mail.gmail.com>
	<20140401085218.72f67e51@mschwide>
	<alpine.LFD.2.11.1404010827140.26309@i7.linux-foundation.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040207-6892-0000-0000-000008538B21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2014 08:40:41 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 1 Apr 2014, Martin Schwidefsky wrote:
> > 
> > I gave up after a few hours trying to solve the header dependencies, the two
> > trouble makes are alpha with the task_thread_info call in mmu_context.h and
> > arm with the preempt_enable_no_resched call. Welcome to include file hell.
> 
> I don't understand. The only file <asm/mmu_context.h> should need is 
> <linux/mm.h>. Maybe <kernel/sched.h>.
> 
> Look at mm/mmu_context.c, for example. It includes <asm/mmu_context.h> 
> without having included very many header files at all. So we *know* that 
> that small set is sufficient. 
> 
> And there aren't very many users of <linux/mmu_context.h> and none of them 
> are other header files, so there's no point in trying to religiously avoid 
> including one or two header files from it.
> 
> So I'm thinking something like this should work. It's untested, and maybe 
> some architecture really needs some other header file, but it looks quite 
> likely to work. No?

I had a patch quite similar to yours and I ended up with the error report
from the kbuild robot. Just tried yours with the corgi_defconfig and got
this:

In file included from include/linux/mmu_context.h:6,
                 from drivers/usb/gadget/inode.c:27:
/home4/mschwide/linux/arch/arm/include/asm/mmu_context.h: In function 'finish_arch_post_lock_switch':
/home4/mschwide/linux/arch/arm/include/asm/mmu_context.h:82: error: implicit declaration of function 'preempt_enable_no_resched'

Part of the problem is this lovely piece from include/linux/preempt.h:

#ifdef MODULE
/*
 * Modules have no business playing preemption tricks.
 */
#undef sched_preempt_enable_no_resched
#undef preempt_enable_no_resched
#undef preempt_enable_no_resched_notrace
#undef preempt_check_resched
#endif

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

