Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423026Ab3FUGZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:25:54 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:59151 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030278Ab3FUGZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:25:52 -0400
MIME-Version: 1.0
In-Reply-To: <0000013f620f4699-f484f28e-3d12-4560-adfe-3b00af995fd9-000000@email.amazonses.com>
References: <20130606124351.GZ27176@twins.programming.kicks-ass.net>
 <0000013f1ad00ec0-9574a936-3a75-4ccc-a84c-4a12a7ea106e-000000@email.amazonses.com>
 <20130607110344.GA27176@twins.programming.kicks-ass.net> <0000013f1f1f79d1-2cf8cb8c-7e63-4e83-9f2b-7acc0e0638a1-000000@email.amazonses.com>
 <20130617110832.GP3204@twins.programming.kicks-ass.net> <0000013f536c60ee-9a1ca9da-b798-416a-a32e-c896813d3bac-000000@email.amazonses.com>
 <20130620114943.GB12125@gmail.com> <0000013f620f4699-f484f28e-3d12-4560-adfe-3b00af995fd9-000000@email.amazonses.com>
From: Roland Dreier <roland@kernel.org>
Date: Thu, 20 Jun 2013 23:25:31 -0700
X-Google-Sender-Auth: 374OuyKwrpt2LUw7XeHvR3D5asE
Message-ID: <CAG4TOxNp8hrsC-1hbxGaR+xoUJYqUNv+sen4baukNCtASCwXOw@mail.gmail.com>
Subject: Re: [PATCH] mm: Revert pinned_vm braindamage
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Motohiro KOSAKI <kosaki.motohiro@gmail.com>, penberg@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 7:48 AM, Christoph Lameter <cl@linux.com> wrote:
> There is no way that user space can initiate a page pin right now. Perf is
> pinning the page from the kernel. Similarly the IB subsystem pins memory
> meeded for device I/O.

Christoph, your argument would be a lot more convincing if you stopped
repeating this nonsense.  Sure, in a strict sense, it might be true
that the IB subsystem in the kernel is the code that actually pins
memory, but given that unprivileged userspace can tell the kernel to
pin arbitrary parts of its memory for any amount of time, is that
relevant?  And in fact taking your "initiate" word choice above, I
don't even think your statement is true -- userspace initiates the
pinning by, for example, doing an IB memory registration (libibverbs
ibv_reg_mr() call), which turns into a system call, which leads to the
kernel trying to pin pages.  The pages aren't unpinned until userspace
unregisters the memory (or causes a cleanup by closing the context
fd).

Here's an argument by analogy.  Would it make any sense for me to say
userspace can't mlock memory, because only the kernel can set
VM_LOCKED on a vma?  Of course not.  Userspace has the mlock() system
call, and although the actual work happens in the kernel, we clearly
want to be able to limit the amount of memory locked by the kernel ON
BEHALF OF USERSPACE.

 - R.
