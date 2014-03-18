Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbaCRXTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 19:19:21 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:4178
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758068AbaCRXTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 19:19:03 -0400
Message-ID: <1395184734.12479.250.camel@snotra.buserror.net>
Subject: Re: [PATCH 9/9] powerpc/pm: support deep sleep feature on T1040
From: Scott Wood <scottwood@freescale.com>
To: Kevin Hao <haokexin@gmail.com>
CC: Chenhui Zhao <chenhui.zhao@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>,
        <Jason.Jin@freescale.com>
Date: Tue, 18 Mar 2014 18:18:54 -0500
In-Reply-To: <20140316045801.GA32188@pek-khao-d1.corp.ad.wrs.com>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
	 <1394168285-32275-9-git-send-email-chenhui.zhao@freescale.com>
	 <1394586624.13761.132.camel@snotra.buserror.net>
	 <20140312055755.GA17203@pek-khao-d1.corp.ad.wrs.com>
	 <1394646185.13761.145.camel@snotra.buserror.net>
	 <20140313074613.GD26692@pek-khao-d1.corp.ad.wrs.com>
	 <1394835987.12479.119.camel@snotra.buserror.net>
	 <20140316045801.GA32188@pek-khao-d1.corp.ad.wrs.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BY2PR02CA004.namprd02.prod.outlook.com (10.255.247.24) To
 BL2PR03MB388.namprd03.prod.outlook.com (10.141.91.153)
X-Forefront-PRVS: 0154C61618
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(377424004)(57704003)(51704005)(199002)(189002)(4396001)(31966008)(95416001)(74502001)(69226001)(81342001)(80022001)(92566001)(74876001)(92726001)(74706001)(65816001)(33646001)(50466002)(94946001)(63696002)(74366001)(74662001)(20776003)(85306002)(81542001)(47446002)(47776003)(93516002)(93916002)(1411001)(50226001)(86362001)(47976001)(97336001)(62966002)(51856001)(77156001)(94316002)(80976001)(42186004)(50986001)(47736001)(49866001)(87976001)(79102001)(76786001)(551934002)(90146001)(76482001)(56776001)(85852003)(81816001)(93136001)(23676002)(97186001)(83072002)(87266001)(95666003)(53806001)(77096001)(81686001)(88136002)(46102001)(59766001)(77982001)(56816005)(87286001)(76796001)(54316002)(83322001)(89996001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB388;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:CA27DCD5.AFE65011.BDF07DBB.82A6F9DE.2062A;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-16 at 12:58 +0800, Kevin Hao wrote:
> On Fri, Mar 14, 2014 at 05:26:27PM -0500, Scott Wood wrote:
> > On Thu, 2014-03-13 at 15:46 +0800, Kevin Hao wrote:
> > > On Wed, Mar 12, 2014 at 12:43:05PM -0500, Scott Wood wrote:
> > > > > Shouldn't we use "readback, sync" here? The following is quoted form t4240RM:
> > > > >   To guarantee that the results of any sequence of writes to configuration
> > > > >   registers are in effect, the final configuration register write should be
> > > > >   immediately followed by a read of the same register, and that should be
> > > > >   followed by a SYNC instruction. Then accesses can safely be made to memory
> > > > >   regions affected by the configuration register write.
> > > > 
> > > > I agree that the sync before the readback is probably not necessary,
> > > > since transactions to the same address should already be ordered.
> > > > 
> > > > A sync after the readback helps if you're trying to order the readback
> > > > with subsequent memory accesses, though in that case wouldn't a sync
> > > > alone (no readback) be adequate?
> > > 
> > > No, we don't just want to order the subsequent memory access here.
> > > The 'write, readback, sync' is the required sequence if we want to make
> > > sure that the writing to CCSR register does really take effect.
> > > 
> > > >  Though maybe not always -- see the
> > > > comment near the end of fsl_elbc_write_buf() in
> > > > drivers/mtd/nand_fsl_elbc.c.  I guess the readback does more than just
> > > > make sure the device has seen the write, ensuring that the device has
> > > > finished the transaction to the point of acting on another one.
> > > 
> > > Agree.
> > > 
> > > > 
> > > > The data dependency plus isync sequence, which is done by the normal I/O
> > > > accessors used from C code, orders the readback versus all future
> > > > instructions (not just I/O).  The delay loop is not I/O.
> > > 
> > > According to the PowerISA, the sequence 'load, date dependency, isync' only
> > > order the load accesses. 
> > 
> > The point is to order the delay loop after the load, not to order
> > storage versus storage.
> 
> I think the point is to make sure that the writing of the CCSR_DDR_SDRAM_CFG_2
> does really take effect before we begin to delay loop.

Yes.

>  The sequence "write, readback, sync" will guarantee this according to the manual. 

If you're referring to the section you quoted above, the manual does not
say that.  It only talks about when accesses "to memory regions affected
by the configuration register write" can be safely made.

> If we just want to
> order the delay loop after the load, the following sequence should be enough:
> 	store to CCSR_DDR_SDRAM_CFG_2
> 	load from CCSR_DDR_SDRAM_CFG_2
> 	isync or sync
> 	delay loop
> 
> Why do we need the 'date dependency' here? According to the e6500 manual, the
> instructions can execute out of order, but complete in order. So I am really
> wondering why we need to order the load and the following delay loop if there
> is no intention to order the storage access? 

The data (not date) dependency means that the twi will not execute until
after the load instruction returns data (thus, after the device has
responded to the load).  The twi, being a flow control instruction
rather than a storage instruction, should be fully ordered by isync.

>From the isync description in the ISA: "Except as described in the
preceding sentence, the isync instruction may complete before storage
accesses associated with instructions preceding the
isync instruction have been performed."

I don't know if that really applies to loads (as opposed to stores), and
it probably doesn't apply to guarded loads, but I feel safer leaving the
twi in.

As for sync instead of isync, I see nothing to indicate that it would be
adequate (though it may be that the only reason there needed to be a
delay loop in the first place was the lack of a readback/sync before
doing other I/O, in which case this is moot).

> > This is a sequence we're already using on all of our I/O loads
> > (excluding accesses like in this patch that don't use the standard
> > accessors).  I'm confident that it works even if it's not
> > architecturally guaranteed.
> 
> This sequence is used to order the load and the followed storage access.

It's also used to order loads versus other things, such as enabling
MSR[EE].

> And this is guaranteed by the architecture. But I don't think it is suitable
> for a case like this. The following is quoted from PowerISA:
>   Because stores cannot be performed “out-of-order”
>   (see Book III), if a Store instruction depends on the
>   value returned by a preceding Load instruction
>   (because the value returned by the Load is used to
>   compute either the effective address specified by the
>   Store or the value to be stored), the corresponding stor-
>   age accesses are performed in program order. The
>   same applies if whether the Store instruction is exe-
>   cuted depends on a conditional Branch instruction that
>   in turn depends on the value returned by a preceding
>   Load instruction.
>   
>   Because an isync instruction prevents the execution of
>   instructions following the isync until instructions pre-
>   ceding the isync have completed, if an isync follows a
>   conditional Branch instruction that depends on the
>   value returned by a preceding Load instruction, the
>   load on which the Branch depends is performed before
>   any loads caused by instructions following the isync.
> 
> I think the above description would guarantee that the load will be performed
> before any storage access (both load and store) following the isync in the
> following scenario:
> 	lwz	r4, 0(r3)
> 	twi	0, r4, 0
> 	isync

I think it's a poorly worded section, but yes, it guarantees both loads
and stores -- unnecessarily doing so in separate places with different
wording.  But by the definition of isync I don't see why it does not
apply to *any* instruction after the isync, not just loads and stores.

> >  I'm not sure that there exists a clear
> > architectural way of synchronizing non-storage instructions relative to
> > storage instructions.
> 
> Isn't what the execution synchronization instructions such as sync, isync, mtmsr
> do?

No.  Execution synchronizing just says that the previous instructions
"have completed to a point at which they have reported all the
exceptions they will cause" (I'm assuming this doesn't include machine
check error reports), and that the previous instructions won't be
affected by context changes after the execution synchronizing
instruction, not that the previous instructions are fully completed.
 
> > Given that isync is documented as preventing any execution of
> > instructions after the isync until all previous instructions complete,
> > it doesn't seem to make sense for the architecture to explicitly talk
> > about loads (as opposed to any other instruction) following a load,
> > dependent conditional branch, isync sequence.
> 
> Sorry, I didn't get what you mean.

I mean that I do not understand why it says, "the load on which the
Branch depends is performed before any loads caused by instructions
following the isync" rather than "the Load on which the Branch depends
is performed before any instructions following the isync".

> > > So if we want to order all the storage access as well
> > > as execution synchronization, we should choose sync here.
> > 
> > Do we need execution synchronization or context synchronization?
> 
> There is no context-altering instruction here, so I think an execution
> synchronizing instruction should be enough here.

Is the ISA ever explicit about what constitutes "context"?  In any case,
just because we don't need that aspect of context synchronization
doesn't mean execution synchronization is enough.  The behavior we want
is described in the isync instruction specifically, not in "context
synchronization" or "execution synchronization".
 
> > The t4240 RM section that talks about a readback and a sync is in the
> > context of subsequent memory operations ("Then accesses can safely be
> > made to memory regions affected..."), not arbitrary instructions.
> 
> I assume that this sequence also guarantee that the writing does take effect.

You may assume that, but the manual doesn't say that.  Sync could
(AFAIK) be implemented by emitting a barrier on the bus, or delaying
future storage accesses, rather than waiting for everything to have
finished before proceeding.

> > In any case, this is not performance critical and thus it's better to
> > oversynchronize than undersynchronize.
> 
> On the contrary I think that sync is oversynchronize instead of
> undersynchronize. It not only provide the execution synchronizing but also
> order all the storage accesses. That is why I prefer the sync. :-)

sync is not a superset of isync.  isync is not a superset of sync.  If
you want to oversynchronize to be safe, do both (though even that isn't
equivalent to a barrier that orders everything, which is partly why a
readback is needed).

-Scott


