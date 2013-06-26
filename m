Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab3FZRyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 13:54:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46606 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3FZRyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 13:54:46 -0400
Date: Wed, 26 Jun 2013 18:54:30 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Will Deacon <will.deacon@arm.com>
Cc: "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        "'linux-arch@vger.kernel.org'" <linux-arch@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: ARM pagetable setting in Linux
Message-ID: <20130626175430.GH2718@n2100.arm.linux.org.uk>
References: <35FD53F367049845BC99AC72306C23D19441BF5863@CNBJMBX05.corpusers.net> <20130626171649.GG10333@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130626171649.GG10333@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I don't have the original mail (because it wasn't copied to the right
list) I can't reply to the original author, so I'll do it like this
instead.

On Wed, Jun 26, 2013 at 06:16:49PM +0100, Will Deacon wrote:
> [adding the ARM list -- please try and remember to do that in future]
> 
> On Wed, Jun 26, 2013 at 03:41:40AM +0100, Wang, Yalin wrote:
> > Hi  Will,
> 
> Hello,
> 
> > I have a question about  arm pagetable setting in Linux .
> > 
> > From armV6,  there is TTBR0 and TTBR1  translation base address registers  in mmu .
> > But I  found linux only use TTBR0 for translation base address ,
> > Could we use TTBR0 and TTBR1 to split user task and kernel pagetables (swapper_pg_dir)？ 

We don't use TTBR1 because the configurable page table splits between
TTBR0 and TTBR1 are not appropriate for Linux kernels.  The common
configuration is to have 3GB of userspace and 1GB of kernel space.

However, the TTBR splits supported are 2GB, 1GB, 512MB etc.  As I had
prior knowledge of ARMv6 before it was released, I raised this point
with ARM Ltd because I knew that it would not be appropriate for Linux.
Unfortunately, the response was basically that they didn't want to know.
So, as the hardware provided support mismatches what we want, we don't
use the feature.

It's as simple as that; had we been listened to and the architecture
altered to do what we required, then we'd be using it...

> > 1. Because we don’t need copy kernel first –level pagetables into every 
> > User task’s pagetables and flush tlb (for example fork() a new process).
> 
> Well, you still need the TLB maintenance for setting up CoW, so this win is
> probably not very big.
> 
> > 2. And don’t need handle kernel page fault because that user task’s kernel 
> > Pagetable when it is not set up , need copy again( for example vmalloc()  ioremap()  kmap()  will change 
> > Kernel pagetables and need update to every task pagetables ) .
> 
> Is that really a fastpath?

No it isn't, because for all of the above cases we're talking about copying
L1 page table entries, not the individual L2 page table entries between
threads.

Every page table above TASK_SIZE gets shared between processes, and once
it's been shared to a process, any new process forked from that gets its
own pointer to that 2nd level page table immediately.

So, during the initial boot there will be a number of the L1 copies, but
the system will stabilize and there will be no further L1 faulted copies
needed.
