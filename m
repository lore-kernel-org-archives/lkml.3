Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751052AbaI2Jm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:42:28 -0400
Received: from mail-bn1bon0110.outbound.protection.outlook.com ([157.56.111.110]:41440
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751501AbaI2JmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:42:25 -0400
Date: Mon, 29 Sep 2014 17:42:55 +0800
From: Chenhui Zhao <chenhui.zhao@freescale.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>, <leoli@freescale.com>,
        <Jason.Jin@freescale.com>, <Zhuoyu.Zhang@freescale.com>
Subject: Re: [PATCH 3/3] arm: pm: add deep sleep support for LS1
Message-ID: <20140929094255.GA14086@udp189498uds.ap.freescale.net>
References: <1411730703-25836-1-git-send-email-chenhui.zhao@freescale.com>
 <1411730703-25836-4-git-send-email-chenhui.zhao@freescale.com>
 <20140926121427.GO5182@n2100.arm.linux.org.uk>
 <20140928110640.GB9797@udp189498uds.ap.freescale.net>
 <20140928142632.GG5182@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140928142632.GG5182@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(51704005)(24454002)(33656002)(26826002)(31966008)(84676001)(83506001)(87936001)(92566001)(83322001)(85852003)(92726001)(83072002)(6806004)(68736004)(76176999)(44976005)(47776003)(46406003)(50986999)(20776003)(54356999)(97756001)(102836001)(86362001)(64706001)(104016003)(57986006)(93886004)(76482002)(85306004)(107046002)(23726002)(10300001)(99396003)(21056001)(90102001)(4396001)(50466002)(97736003)(120916001)(80022003)(74662003)(110136001)(76506005)(74502003)(105606002)(95666004)(79102003)(81542003)(77982003)(81342003)(106466001)(46102003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB380;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB380;
X-Forefront-PRVS: 034902F5BC
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=chenhui.zhao@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB1141;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 03:26:33PM +0100, Russell King - ARM Linux wrote:
> On Sun, Sep 28, 2014 at 07:06:40PM +0800, Chenhui Zhao wrote:
> > On Fri, Sep 26, 2014 at 01:14:27PM +0100, Russell King - ARM Linux wrote:
> > > On Fri, Sep 26, 2014 at 07:25:03PM +0800, Chenhui Zhao wrote:
> > > > +/*
> > > > + * r0: the physical entry address of SRAM code
> > > > + *
> > > > + */
> > > > +ENTRY(ls1_do_deepsleep)
> > > > +	mov	r13, r0
> > > > +
> > > > +	/* flush cache */
> > > > +	bl	v7_flush_dcache_all
> > > 
> > > Please explain the purpose of this call via a comment in the code.
> > > 
> > > The generic code will have saved the CPU state, and will have called
> > > flush_cache_louis() to flush the caches to the point of unification.
> > > 
> > > The only data which will have been loaded into the cache between that
> > > point is the stack for the return from __cpu_suspend_save, and
> > > speculative prefetches.
> > > 
> > > So, the only reason I can gather is that you need to flush data from
> > > lower levels of the cache below the point of unification.
> > > 
> > 
> > In deep sleep process, all caches will lost, so flush all caches to prevent
> > data loss.
> 
> You haven't answered my question.
> 

I want to flush L1 and L2 caches of Cortex-A7 in LS1021. However,
flush_cache_louis() only flushed L1 cache. Therefore, call
v7_flush_dcache_all() to flush L1 and L2 cache. 

> > > > +
> > > > +	/* disable cache, C bit in SCTLR */
> > > > +	mrc	p15, 0, r0, c1, c0, 0
> > > > +	bic	r0, r0, #(1 << 2)
> > > > +	mcr	p15, 0, r0, c1, c0, 0
> > > > +	isb
> > > > +
> > > > +	/* disable coherency, SMP bit in ACTLR */
> > > > +	mrc	p15, 0, r0, c1, c0, 1
> > > > +	bic	r0, r0, #(1 << 6)
> > > > +	mcr	p15, 0, r0, c1, c0, 1
> > > > +	isb
> > > > +	dsb
> > > > +
> > > > +	/* disable MMU, M bit in SCTLR */
> > > > +	mrc	p15, 0, r0, c1, c0, 0
> > > > +	bic	r0, r0, #1
> > > > +	mcr	p15, 0, r0, c1, c0, 0
> > > > +	isb
> > > > +
> > > > +	/* jump to sram code using physical address */
> > > > +	bx	r13
> > > 
> > > This looks extremely fragile.  You are running in virtual space, and you
> > > turn the MMU off.  You are reliant on the MMU still being on for the
> > > following instructions to already be in the pipeline.  That's not a
> > > very good assumption to make (we've made it in the past and it breaks
> > > every so often when things change, eg when the code is no longer laid
> > > out how we expect.)
> > > 
> > > You need to disable the MMU safely, which means using the identity map
> > > page tables and executing code in the identity map region.
> > 
> > Yes, the code will switch off MMU, and switch to physical address space.
> > On LS1021, the DDR memory located at the physical address space started from
> > 0x80000000, the kernel space also started at 0x80000000 (CONFIG_PAGE_OFFSET = 0x80000000).
> > So the virtual address of kernel code is equal to the physical address.
> 
> You can't rely on that.
> 
> Sorry, NAK.

I'll try to use a safer method to implement it.

Chenhui
