Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab3FZRRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 13:17:18 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60625 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893Ab3FZRRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 13:17:17 -0400
Date: Wed, 26 Jun 2013 18:16:49 +0100
From: Will Deacon <will.deacon@arm.com>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arch@vger.kernel.org'" <linux-arch@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: ARM pagetable setting in Linux
Message-ID: <20130626171649.GG10333@mudshark.cambridge.arm.com>
References: <35FD53F367049845BC99AC72306C23D19441BF5863@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <35FD53F367049845BC99AC72306C23D19441BF5863@CNBJMBX05.corpusers.net>
Thread-Topic: ARM pagetable setting in Linux
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding the ARM list -- please try and remember to do that in future]

On Wed, Jun 26, 2013 at 03:41:40AM +0100, Wang, Yalin wrote:
> Hi  Will,

Hello,

> I have a question about  arm pagetable setting in Linux .
> 
> From armV6,  there is TTBR0 and TTBR1  translation base address registers  in mmu .
> But I  found linux only use TTBR0 for translation base address ,
> Could we use TTBR0 and TTBR1 to split user task and kernel pagetables (swapper_pg_dir)？ 
> 
> But I found this need set TTBCR.N   ,
> If PAGE_OFFSET==0xc0000000  ,   set TTBCR.N=0x2 ,
> Will not work , because   only ensure 0--0x00FFFFFF  MVA use TTBCR0 
> And other  MVA　will use TTBCR1 ,
> But if we set PAGE_OFFSET==0x80000000  (2GB split )  ,
> And set  TTBCR.N=0x1 ,
> This will make sure user task MVA use TTBCR0 and kernel  MVA 
> Use TTBCR1 , this  will make some improvement for the system .
> 
> 1. Because we don’t need copy kernel first –level pagetables into every 
> User task’s pagetables and flush tlb (for example fork() a new process).

Well, you still need the TLB maintenance for setting up CoW, so this win is
probably not very big.

> 2. And don’t need handle kernel page fault because that user task’s kernel 
> Pagetable when it is not set up , need copy again( for example vmalloc()  ioremap()  kmap()  will change 
> Kernel pagetables and need update to every task pagetables ) .

Is that really a fastpath?

> 3. We  even can only allocate 8KB first level pagetables for user task to save 
> Memorys .

That would be a nice gain, but there are a number of factors here:

	1. Pre-ARMv6 only have one ttbr, so you'd end up needing to support
	   both configurations in the same kernel source.

	2. The module area lives below PAGE_OFFSET, so you still have to
	   deal with that correctly (mitigating some of your earlier points)

	3. PAGE_OFFSET is not fixed at 2GB, so you constrain your use-case
	   even further.

	4. We do actually use TTBR1 to hold an identity mapping at the
	   moment. This could probably be fixed, but would require some
	   thought.

There's undoubtedly other problems that haven't immediately come to me but,
all in all, I don't think this is a significant enough win to justify the
effort and maintenance headache.

Cheers,

Will
