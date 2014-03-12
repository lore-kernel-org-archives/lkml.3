Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbaCLRp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:45:58 -0400
Received: from [207.46.163.138] ([207.46.163.138]:9509 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755726AbaCLRpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:45:53 -0400
Message-ID: <1394646185.13761.145.camel@snotra.buserror.net>
Subject: Re: [PATCH 9/9] powerpc/pm: support deep sleep feature on T1040
From: Scott Wood <scottwood@freescale.com>
To: Kevin Hao <haokexin@gmail.com>
CC: Chenhui Zhao <chenhui.zhao@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>,
        <Jason.Jin@freescale.com>
Date: Wed, 12 Mar 2014 12:43:05 -0500
In-Reply-To: <20140312055755.GA17203@pek-khao-d1.corp.ad.wrs.com>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
	 <1394168285-32275-9-git-send-email-chenhui.zhao@freescale.com>
	 <1394586624.13761.132.camel@snotra.buserror.net>
	 <20140312055755.GA17203@pek-khao-d1.corp.ad.wrs.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.255.93.4]
X-ClientProxiedBy: BY2PR03CA001.namprd03.prod.outlook.com (10.255.93.18) To
 DM2PR03MB399.namprd03.prod.outlook.com (10.141.84.148)
X-Forefront-PRVS: 01480965DA
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(24454002)(377424004)(51704005)(23676002)(76786001)(77096001)(47446002)(47776003)(20776003)(77156001)(63696002)(77982001)(59766001)(79102001)(81542001)(31966008)(81342001)(80022001)(62966002)(65816001)(69226001)(53806001)(47736001)(50226001)(42186004)(49866001)(51856001)(4396001)(74876001)(81816001)(95416001)(97186001)(33646001)(47976001)(50986001)(97336001)(80976001)(74366001)(19580405001)(83322001)(46102001)(74706001)(81686001)(50466002)(92726001)(93516002)(94946001)(83072002)(89996001)(85852003)(90146001)(56816005)(56776001)(93136001)(87976001)(1411001)(94316002)(86362001)(92566001)(87266001)(95666003)(76482001)(85306002)(87286001)(54316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB399;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:EE3BD0D4.AFF41729.FDF0154F.AD8CFCD.203C7;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-12 at 13:57 +0800, Kevin Hao wrote:
> On Tue, Mar 11, 2014 at 08:10:24PM -0500, Scott Wood wrote:
> > > +	FSL_DIS_ALL_IRQ
> > > +
> > > +	/*
> > > +	 * Place DDR controller in self refresh mode.
> > > +	 * From here on, DDR can't be access any more.
> > > +	 */
> > > +	lwz	r10, 0(r13)
> > > +	oris	r10, r10, CCSR_DDR_SDRAM_CFG_2_FRC_SR@h
> > > +	stw	r10, 0(r13)
> > > +
> > > +	/* can't call udelay() here, so use a macro to delay */
> > > +	FSLDELAY(50)
> > 
> > A timebase loop doesn't require accessing DDR.
> > 
> > You also probably want to do a "sync, readback, data dependency, isync"
> > sequence to make sure that the store has hit CCSR before you begin your
> > delay (or is a delay required at all if you do that?).
> 
> Shouldn't we use "readback, sync" here? The following is quoted form t4240RM:
>   To guarantee that the results of any sequence of writes to configuration
>   registers are in effect, the final configuration register write should be
>   immediately followed by a read of the same register, and that should be
>   followed by a SYNC instruction. Then accesses can safely be made to memory
>   regions affected by the configuration register write.

I agree that the sync before the readback is probably not necessary,
since transactions to the same address should already be ordered.

A sync after the readback helps if you're trying to order the readback
with subsequent memory accesses, though in that case wouldn't a sync
alone (no readback) be adequate?  Though maybe not always -- see the
comment near the end of fsl_elbc_write_buf() in
drivers/mtd/nand_fsl_elbc.c.  I guess the readback does more than just
make sure the device has seen the write, ensuring that the device has
finished the transaction to the point of acting on another one.

The data dependency plus isync sequence, which is done by the normal I/O
accessors used from C code, orders the readback versus all future
instructions (not just I/O).  The delay loop is not I/O.

> > > +	/* Enable SCU15 to trigger on RCPM Concentrator 0 */
> > > +	lwz	r10, 0(r15)
> > > +	oris	r10, r10, DCSR_EPU_EPECR15_IC0@h
> > > +	stw	r10, 0(r15)
> > > +
> > > +	/* put Core0 in PH15 mode, trigger EPU FSM */
> > > +	lwz	r10, 0(r12)
> > > +	ori	r10, r10, CCSR_RCPM_PCPH15SETR_CORE0
> > > +	stw	r10, 0(r12)
> > 
> > Shouldn't there be a sync to ensure that the previous I/O happens before
> > the final store to enter PH15?
> 
> Do we really need a sync here? According to the PowerISA, the above stores
> should be performed in program order.
>   If two Store instructions or two Load instructions
>   specify storage locations that are both Caching
>   Inhibited and Guarded, the corresponding storage
>   accesses are performed in program order with
>   respect to any processor or mechanism.

OK, wasn't aware of that.

-Scott


