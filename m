Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423108Ab3FUOoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:44:39 -0400
Received: from a9-46.smtp-out.amazonses.com ([54.240.9.46]:34100 "EHLO
	a9-46.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161419Ab3FUOog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:44:36 -0400
Date: Fri, 21 Jun 2013 14:44:34 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Roland Dreier <roland@kernel.org>
cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Motohiro KOSAKI <kosaki.motohiro@gmail.com>, penberg@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH] mm: Revert pinned_vm braindamage
In-Reply-To: <CAG4TOxNp8hrsC-1hbxGaR+xoUJYqUNv+sen4baukNCtASCwXOw@mail.gmail.com>
Message-ID: <0000013f6731a2df-6b705743-51cd-44dd-959b-8f139d052f6c-000000@email.amazonses.com>
References: <20130606124351.GZ27176@twins.programming.kicks-ass.net> <0000013f1ad00ec0-9574a936-3a75-4ccc-a84c-4a12a7ea106e-000000@email.amazonses.com> <20130607110344.GA27176@twins.programming.kicks-ass.net> <0000013f1f1f79d1-2cf8cb8c-7e63-4e83-9f2b-7acc0e0638a1-000000@email.amazonses.com>
 <20130617110832.GP3204@twins.programming.kicks-ass.net> <0000013f536c60ee-9a1ca9da-b798-416a-a32e-c896813d3bac-000000@email.amazonses.com> <20130620114943.GB12125@gmail.com> <0000013f620f4699-f484f28e-3d12-4560-adfe-3b00af995fd9-000000@email.amazonses.com>
 <CAG4TOxNp8hrsC-1hbxGaR+xoUJYqUNv+sen4baukNCtASCwXOw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.06.21-54.240.9.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013, Roland Dreier wrote:

> Christoph, your argument would be a lot more convincing if you stopped
> repeating this nonsense.  Sure, in a strict sense, it might be true

Well this is regarding tracking of pages that need to stay resident and
since the kernel does the pinning through the IB subsystem it is trackable
right there.  No nonsense and no need for a separate pinning system call.

> that the IB subsystem in the kernel is the code thatactually pins
> memory, but given that unprivileged userspace can tell the kernel to
> pin arbitrary parts of its memory for any amount of time, is that
> relevant?  And in fact taking your "initiate" word choice above, I
> don't even think your statement is true -- userspace initiates the
> pinning by, for example, doing an IB memory registration (libibverbs
> ibv_reg_mr() call), which turns into a system call, which leads to the
> kernel trying to pin pages.  The pages aren't unpinned until userspace
> unregisters the memory (or causes a cleanup by closing the context
> fd).

In some sense userspace initiates everything since the kernels purpose
is to run applications. So you can say that everything is user initated if
you wanted.

However, the user visible mechanism here is a registration of memory with
the IB subsystem for RDMA. The primary intend is not to pin the pages but
to make memory available for remote I/O. The pages are pinned *because*
otherwise remote RDMA operations could corrupt memory due to the kernel
moving/evicting memory.

> Here's an argument by analogy.  Would it make any sense for me to say
> userspace can't mlock memory, because only the kernel can set
> VM_LOCKED on a vma?  Of course not.  Userspace has the mlock() system
> call, and although the actual work happens in the kernel, we clearly
> want to be able to limit the amount of memory locked by the kernel ON
> BEHALF OF USERSPACE.

I would think that mlock is a memory management function and therefore the
app/user directly says that the memory is not to be evicted from memory.

This is different for the IB subsystem which is dealing with I/O and only
indirectly with memory. Would we have a different mechanism to prevent
reclaim etc the we would not need to pin the pages.

Actual there is such a mechanism that could be used here. If you had a
reserved memory region that is not mapped by the kernel (boot time alloc,
device memory) then you can use VM_PFNMAP to refer to that region and the
kernel would not be able to do reclaim on that memory. No pinning
necessary if the IB subsystem would register that type of memory.



