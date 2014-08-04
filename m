Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaHDXfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 19:35:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47124 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbaHDXfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 19:35:43 -0400
Date: Mon, 04 Aug 2014 16:35:42 -0700 (PDT)
Message-Id: <20140804.163542.2163737198733907800.davem@davemloft.net>
To: npiggin@kernel.dk
Cc: cat.schulze@alice-dsl.net, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: overzealous TLB flushing by lazy VMAP flushing
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140804.162314.315898378388489145.davem@davemloft.net>
References: <20140804.162314.315898378388489145.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 Aug 2014 16:35:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 04 Aug 2014 16:23:14 -0700 (PDT)

Sorry, I screwed up the lkml CC:, fixing that here.

> Hey Nick,
> 
> The lazy VMAP flushing in mm/vmalloc.c seems to make various
> assumptions about vmalloc area layout.
> 
> In particular it assumes that if there are pending VMAP flushes
> in multiple regions managed by vmap/vunmap, it's safe to queue
> up a range flush from the lowest such address to the highest
> such address.
> 
> This is problematic and causes problems on sparc64 as diagnosed by
> Christopher (CC:'d).
> 
> On sparc64 we have the following regions:
> 
> modules		0x010000000 --> 0x0f0000000
> openfirmware	0x0f0000000 --> 0x100000000
> vmalloc		0x100000000 --> 0x10000000000
> 
> So if a module is unloaded as well as some vfree()'s occur, the next
> lazy VMAP flush will flush a range that covers all of openfirmware.
> 
> This will flush the firmware's locked TLB entries, which in turn cause
> all sorts of problems.
> 
> It is not possible to adjust where these ranges are in order to make
> the vmalloc and module ranges be right next to eachother.  The
> firmware area is fixed, first of all.  Second of all the module area
> has to be in the low 4GB because of the code model we compile the
> kernel with (all symbols are 32-bit), and we want to use as little of
> the sub-4GB area as possible because it has to fit the main kernel
> image, modules, and the firmware region.
> 
> We could add all sorts of range logic to the flush_tlb_range()
> implementation on sparc64, but I really think that the kernel should
> not trigger a TLB flush across a range for which it never managed any
> mappings.
> 
> I also think that the lazy VMAP flusher should be mindful of this for
> another reason.  Specifically, issuing such an enormous flush range is
> going to be expensive, more expensive that whatever we were gaining by
> batching these flushes.
> 
> Unlike for userspace mappings, for kernel mappings we can't have a
> cutoff for page-by-page flushes and just do a context based TLB flush.
> We always have to do page-by-page flushes.  So these huge ranges
> really do hurt.
