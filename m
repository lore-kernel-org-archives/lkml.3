Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbaI1O0s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 10:26:48 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:45655 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753343AbaI1O0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 10:26:47 -0400
Date: Sun, 28 Sep 2014 15:26:33 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Chenhui Zhao <chenhui.zhao@freescale.com>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, leoli@freescale.com,
        Jason.Jin@freescale.com, Zhuoyu.Zhang@freescale.com
Subject: Re: [PATCH 3/3] arm: pm: add deep sleep support for LS1
Message-ID: <20140928142632.GG5182@n2100.arm.linux.org.uk>
References: <1411730703-25836-1-git-send-email-chenhui.zhao@freescale.com> <1411730703-25836-4-git-send-email-chenhui.zhao@freescale.com> <20140926121427.GO5182@n2100.arm.linux.org.uk> <20140928110640.GB9797@udp189498uds.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140928110640.GB9797@udp189498uds.ap.freescale.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 07:06:40PM +0800, Chenhui Zhao wrote:
> On Fri, Sep 26, 2014 at 01:14:27PM +0100, Russell King - ARM Linux wrote:
> > On Fri, Sep 26, 2014 at 07:25:03PM +0800, Chenhui Zhao wrote:
> > > +static int ls1_start_deepsleep(unsigned long addr)
> > > +{
> > > +	ls1_do_deepsleep(addr);
> > > +
> > > +	return 0;
> > > +}
> > ...
> > > +	cpu_suspend(SRAM_CODE_BASE_PHY, ls1_start_deepsleep);
> > 
> > What's the point of this function?  Why can't ls1_do_deepsleep() just
> > return zero?
> 
> Just leave space for adding C code in the future.
> 
> > 
> > > +/*
> > > + * r0: the physical entry address of SRAM code
> > > + *
> > > + */
> > > +ENTRY(ls1_do_deepsleep)
> > > +	mov	r13, r0
> > > +
> > > +	/* flush cache */
> > > +	bl	v7_flush_dcache_all
> > 
> > Please explain the purpose of this call via a comment in the code.
> > 
> > The generic code will have saved the CPU state, and will have called
> > flush_cache_louis() to flush the caches to the point of unification.
> > 
> > The only data which will have been loaded into the cache between that
> > point is the stack for the return from __cpu_suspend_save, and
> > speculative prefetches.
> > 
> > So, the only reason I can gather is that you need to flush data from
> > lower levels of the cache below the point of unification.
> > 
> 
> In deep sleep process, all caches will lost, so flush all caches to prevent
> data loss.

You haven't answered my question.

> > > +
> > > +	/* disable cache, C bit in SCTLR */
> > > +	mrc	p15, 0, r0, c1, c0, 0
> > > +	bic	r0, r0, #(1 << 2)
> > > +	mcr	p15, 0, r0, c1, c0, 0
> > > +	isb
> > > +
> > > +	/* disable coherency, SMP bit in ACTLR */
> > > +	mrc	p15, 0, r0, c1, c0, 1
> > > +	bic	r0, r0, #(1 << 6)
> > > +	mcr	p15, 0, r0, c1, c0, 1
> > > +	isb
> > > +	dsb
> > > +
> > > +	/* disable MMU, M bit in SCTLR */
> > > +	mrc	p15, 0, r0, c1, c0, 0
> > > +	bic	r0, r0, #1
> > > +	mcr	p15, 0, r0, c1, c0, 0
> > > +	isb
> > > +
> > > +	/* jump to sram code using physical address */
> > > +	bx	r13
> > 
> > This looks extremely fragile.  You are running in virtual space, and you
> > turn the MMU off.  You are reliant on the MMU still being on for the
> > following instructions to already be in the pipeline.  That's not a
> > very good assumption to make (we've made it in the past and it breaks
> > every so often when things change, eg when the code is no longer laid
> > out how we expect.)
> > 
> > You need to disable the MMU safely, which means using the identity map
> > page tables and executing code in the identity map region.
> 
> Yes, the code will switch off MMU, and switch to physical address space.
> On LS1021, the DDR memory located at the physical address space started from
> 0x80000000, the kernel space also started at 0x80000000 (CONFIG_PAGE_OFFSET = 0x80000000).
> So the virtual address of kernel code is equal to the physical address.

You can't rely on that.

Sorry, NAK.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
