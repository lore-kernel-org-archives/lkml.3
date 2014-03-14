Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbaCNW0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 18:26:39 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:29759
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754873AbaCNW0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 18:26:38 -0400
Message-ID: <1394835987.12479.119.camel@snotra.buserror.net>
Subject: Re: [PATCH 9/9] powerpc/pm: support deep sleep feature on T1040
From: Scott Wood <scottwood@freescale.com>
To: Kevin Hao <haokexin@gmail.com>
CC: Chenhui Zhao <chenhui.zhao@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>,
        <Jason.Jin@freescale.com>
Date: Fri, 14 Mar 2014 17:26:27 -0500
In-Reply-To: <20140313074613.GD26692@pek-khao-d1.corp.ad.wrs.com>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
	 <1394168285-32275-9-git-send-email-chenhui.zhao@freescale.com>
	 <1394586624.13761.132.camel@snotra.buserror.net>
	 <20140312055755.GA17203@pek-khao-d1.corp.ad.wrs.com>
	 <1394646185.13761.145.camel@snotra.buserror.net>
	 <20140313074613.GD26692@pek-khao-d1.corp.ad.wrs.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: CO1PR04CA003.namprd04.prod.outlook.com (10.141.49.13) To
 DM2PR03MB398.namprd03.prod.outlook.com (10.141.84.140)
X-Forefront-PRVS: 0150F3F97D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(189002)(57704003)(199002)(51704005)(377424004)(74662001)(42186004)(97186001)(51856001)(551934002)(62966002)(74502001)(81342001)(56776001)(85306002)(1411001)(80976001)(46102001)(69226001)(54316002)(95666003)(74366001)(81686001)(53806001)(31966008)(81542001)(47446002)(33646001)(88136002)(86362001)(65816001)(80022001)(47736001)(76482001)(90146001)(92726001)(56816005)(77096001)(83072002)(85852003)(77156001)(76786001)(76796001)(74706001)(93516002)(59766001)(20776003)(23676002)(93916002)(50226001)(81816001)(92566001)(83322001)(87266001)(50466002)(89996001)(94946001)(87976001)(47776003)(47976001)(74876001)(49866001)(95416001)(94316002)(79102001)(63696002)(50986001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB398;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:CA27DC94.9FF55319.FDF01DAF.80A7D3DE.203D3;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-13 at 15:46 +0800, Kevin Hao wrote:
> On Wed, Mar 12, 2014 at 12:43:05PM -0500, Scott Wood wrote:
> > > Shouldn't we use "readback, sync" here? The following is quoted form t4240RM:
> > >   To guarantee that the results of any sequence of writes to configuration
> > >   registers are in effect, the final configuration register write should be
> > >   immediately followed by a read of the same register, and that should be
> > >   followed by a SYNC instruction. Then accesses can safely be made to memory
> > >   regions affected by the configuration register write.
> > 
> > I agree that the sync before the readback is probably not necessary,
> > since transactions to the same address should already be ordered.
> > 
> > A sync after the readback helps if you're trying to order the readback
> > with subsequent memory accesses, though in that case wouldn't a sync
> > alone (no readback) be adequate?
> 
> No, we don't just want to order the subsequent memory access here.
> The 'write, readback, sync' is the required sequence if we want to make
> sure that the writing to CCSR register does really take effect.
> 
> >  Though maybe not always -- see the
> > comment near the end of fsl_elbc_write_buf() in
> > drivers/mtd/nand_fsl_elbc.c.  I guess the readback does more than just
> > make sure the device has seen the write, ensuring that the device has
> > finished the transaction to the point of acting on another one.
> 
> Agree.
> 
> > 
> > The data dependency plus isync sequence, which is done by the normal I/O
> > accessors used from C code, orders the readback versus all future
> > instructions (not just I/O).  The delay loop is not I/O.
> 
> According to the PowerISA, the sequence 'load, date dependency, isync' only
> order the load accesses. 

The point is to order the delay loop after the load, not to order
storage versus storage.

This is a sequence we're already using on all of our I/O loads
(excluding accesses like in this patch that don't use the standard
accessors).  I'm confident that it works even if it's not
architecturally guaranteed.  I'm not sure that there exists a clear
architectural way of synchronizing non-storage instructions relative to
storage instructions.

Given that isync is documented as preventing any execution of
instructions after the isync until all previous instructions complete,
it doesn't seem to make sense for the architecture to explicitly talk
about loads (as opposed to any other instruction) following a load,
dependent conditional branch, isync sequence.

> So if we want to order all the storage access as well
> as execution synchronization, we should choose sync here.

Do we need execution synchronization or context synchronization?

The t4240 RM section that talks about a readback and a sync is in the
context of subsequent memory operations ("Then accesses can safely be
made to memory regions affected..."), not arbitrary instructions.  There
are also a couple other places in the RM where isync is recommended
instead (when setting LAWs or CCSRBAR), even though those also only
involve memory accesses.

In any case, this is not performance critical and thus it's better to
oversynchronize than undersynchronize.

-Scott


