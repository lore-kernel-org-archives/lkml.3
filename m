Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaI1LGM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 07:06:12 -0400
Received: from mail-by2on0109.outbound.protection.outlook.com ([207.46.100.109]:21271
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753809AbaI1LGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 07:06:09 -0400
X-Greylist: delayed 171693 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Sep 2014 07:06:09 EDT
Date: Sun, 28 Sep 2014 19:06:40 +0800
From: Chenhui Zhao <chenhui.zhao@freescale.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>, <leoli@freescale.com>,
        <Jason.Jin@freescale.com>, <Zhuoyu.Zhang@freescale.com>
Subject: Re: [PATCH 3/3] arm: pm: add deep sleep support for LS1
Message-ID: <20140928110640.GB9797@udp189498uds.ap.freescale.net>
References: <1411730703-25836-1-git-send-email-chenhui.zhao@freescale.com>
 <1411730703-25836-4-git-send-email-chenhui.zhao@freescale.com>
 <20140926121427.GO5182@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140926121427.GO5182@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(24454002)(51704005)(90102001)(106466001)(104016003)(57986006)(102836001)(110136001)(21056001)(107046002)(77982003)(81542003)(46102003)(81342003)(74662003)(74502003)(50986999)(54356999)(76176999)(79102003)(80022003)(85306004)(50466002)(97756001)(23726002)(95666004)(47776003)(20776003)(76506005)(76482002)(87936001)(64706001)(92726001)(105606002)(92566001)(44976005)(83506001)(86362001)(83322001)(33656002)(6806004)(85852003)(31966008)(83072002)(97736003)(4396001)(10300001)(120916001)(68736004)(26826002)(99396003)(84676001)(46406003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR03MB155;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB155;
X-Forefront-PRVS: 03484C0ABF
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=chenhui.zhao@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 01:14:27PM +0100, Russell King - ARM Linux wrote:
> On Fri, Sep 26, 2014 at 07:25:03PM +0800, Chenhui Zhao wrote:
> > +static int ls1_start_deepsleep(unsigned long addr)
> > +{
> > +	ls1_do_deepsleep(addr);
> > +
> > +	return 0;
> > +}
> ...
> > +	cpu_suspend(SRAM_CODE_BASE_PHY, ls1_start_deepsleep);
> 
> What's the point of this function?  Why can't ls1_do_deepsleep() just
> return zero?

Just leave space for adding C code in the future.

> 
> > +/*
> > + * r0: the physical entry address of SRAM code
> > + *
> > + */
> > +ENTRY(ls1_do_deepsleep)
> > +	mov	r13, r0
> > +
> > +	/* flush cache */
> > +	bl	v7_flush_dcache_all
> 
> Please explain the purpose of this call via a comment in the code.
> 
> The generic code will have saved the CPU state, and will have called
> flush_cache_louis() to flush the caches to the point of unification.
> 
> The only data which will have been loaded into the cache between that
> point is the stack for the return from __cpu_suspend_save, and
> speculative prefetches.
> 
> So, the only reason I can gather is that you need to flush data from
> lower levels of the cache below the point of unification.
> 

In deep sleep process, all caches will lost, so flush all caches to prevent
data loss.

> > +
> > +	/* disable cache, C bit in SCTLR */
> > +	mrc	p15, 0, r0, c1, c0, 0
> > +	bic	r0, r0, #(1 << 2)
> > +	mcr	p15, 0, r0, c1, c0, 0
> > +	isb
> > +
> > +	/* disable coherency, SMP bit in ACTLR */
> > +	mrc	p15, 0, r0, c1, c0, 1
> > +	bic	r0, r0, #(1 << 6)
> > +	mcr	p15, 0, r0, c1, c0, 1
> > +	isb
> > +	dsb
> > +
> > +	/* disable MMU, M bit in SCTLR */
> > +	mrc	p15, 0, r0, c1, c0, 0
> > +	bic	r0, r0, #1
> > +	mcr	p15, 0, r0, c1, c0, 0
> > +	isb
> > +
> > +	/* jump to sram code using physical address */
> > +	bx	r13
> 
> This looks extremely fragile.  You are running in virtual space, and you
> turn the MMU off.  You are reliant on the MMU still being on for the
> following instructions to already be in the pipeline.  That's not a
> very good assumption to make (we've made it in the past and it breaks
> every so often when things change, eg when the code is no longer laid
> out how we expect.)
> 
> You need to disable the MMU safely, which means using the identity map
> page tables and executing code in the identity map region.

Yes, the code will switch off MMU, and switch to physical address space.
On LS1021, the DDR memory located at the physical address space started from
0x80000000, the kernel space also started at 0x80000000 (CONFIG_PAGE_OFFSET = 0x80000000).
So the virtual address of kernel code is equal to the physical address.

Chenhui
