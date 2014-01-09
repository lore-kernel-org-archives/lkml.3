Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbaAIVig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 16:38:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbaAIVia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 16:38:30 -0500
Date: Thu, 9 Jan 2014 22:36:57 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v2 1/1] mm: fix the theoretical compound_lock() vs
 prep_new_page() race
Message-ID: <20140109213657.GD1141@redhat.com>
References: <20140103130023.fdbf96fc95c702bf63871b56@linux-foundation.org>
 <20140104164347.GA31359@redhat.com>
 <20140108115400.GD27046@suse.de>
 <20140108161338.GA10434@redhat.com>
 <20140108180202.GL27046@suse.de>
 <20140108190443.GA17282@redhat.com>
 <20140109112736.GR27046@suse.de>
 <20140109140447.GA25391@redhat.com>
 <20140109185254.GC1141@redhat.com>
 <20140109194350.GA22436@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109194350.GA22436@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 08:43:50PM +0100, Oleg Nesterov wrote:
> get_page_unless_zero(), and recently it was documented that the kernel can
> rely on the control dependency to serialize LOAD + STORE.

Ok, that's cheap then.

> 
> But we probably need barrier() in between, we can't use ACCESS_ONCE().

After get_page_unless_zero I don't think there's any need of
barrier(). barrier() should have been implicit in __atomic_add_unless
in fact it should be a full smp_mb() equivalent too. Memory is always
clobbered there and the asm is volatile.

My wondering was only about the runtime (not compiler) barrier after
running PageTail and before compound_lock, because bit_spin_lock has
only acquire semantics so in absence of the branch that bails out the
lock, the spinlock could run before PageTail. If the branch is good
enough guarantee for all archs it's good and cheap solution. Clearly
this is not an x86 concern, which is always fine without anything when
surrounded by locked ops like here.

> Yes. But in this case I really think we should cleanup get/put first
> and add the helper, like the patch I mentioned does.

Ok, up to you, I'll check it.

> Oh, I don't think this highly theoreitical fix should be backported
> but I agree, lets fix the bug first.

I think it should, but the risk free version of it, so either a few
liner addition before compound_lock or the previous with smp_wmb()
inside the ifdef (considering it only matters on x86 where smp_wmb is
zero cost and the only operational change is actually the reordering
of the set_page_refcounted not the smp_wmb irrelevant for x86).
