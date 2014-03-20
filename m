Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148AbaCTXdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 19:33:20 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:46682
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759912AbaCTXdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 19:33:18 -0400
Message-ID: <1395358390.12479.350.camel@snotra.buserror.net>
Subject: Re: [PATCH 9/9] powerpc/pm: support deep sleep feature on T1040
From: Scott Wood <scottwood@freescale.com>
To: Chenhui Zhao <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>
Date: Thu, 20 Mar 2014 18:33:10 -0500
In-Reply-To: <20140319005607.GB9735@localhost.localdomain>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
	 <1394168285-32275-9-git-send-email-chenhui.zhao@freescale.com>
	 <1394586624.13761.132.camel@snotra.buserror.net>
	 <20140312104005.GH4706@localhost.localdomain>
	 <1394839107.12479.154.camel@snotra.buserror.net>
	 <20140317111957.GD6204@localhost.localdomain>
	 <1395182529.12479.223.camel@snotra.buserror.net>
	 <20140319005607.GB9735@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BL2PR03CA016.namprd03.prod.outlook.com (10.141.66.24) To
 DM2PR03MB398.namprd03.prod.outlook.com (10.141.84.140)
X-Forefront-PRVS: 01565FED4C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(51704005)(199002)(189002)(377424004)(79102001)(95666003)(59766001)(80022001)(77156001)(76796001)(76786001)(65816001)(77096001)(77982001)(87286001)(94946001)(87266001)(63696002)(20776003)(47776003)(86362001)(92566001)(95416001)(74502001)(69226001)(92726001)(93916002)(87976001)(94316002)(74662001)(47446002)(90146001)(85306002)(76482001)(93516002)(83072002)(93136001)(33646001)(54316002)(56776001)(56816005)(89996001)(53806001)(42186004)(23676002)(4396001)(47736001)(49866001)(74876001)(50986001)(47976001)(74366001)(46102001)(51856001)(74706001)(97336001)(62966002)(83322001)(85852003)(80976001)(81342001)(31966008)(97186001)(81816001)(81542001)(81686001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB398;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:FE3FFAEC.2F2694E3.FFF75564.42E8E939.204AA;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-19 at 08:56 +0800, Chenhui Zhao wrote:
> On Tue, Mar 18, 2014 at 05:42:09PM -0500, Scott Wood wrote:
> > On Mon, 2014-03-17 at 19:19 +0800, Chenhui Zhao wrote:
> > > On Fri, Mar 14, 2014 at 06:18:27PM -0500, Scott Wood wrote:
> > > > Why do you need the entry mapping on 32-bit but not 64-bit?
> > > 
> > > fsl_booke_entry_mapping.S is for 32-bit. 64-bit calls
> > > initial_tlb_book3e() in exceptions-64e.S.
> > 
> > The answer I was looking for is that __entry_deep_sleep calls
> > start_initialization_book3e which calls the code to handle it.
> > 
> > But why is it driven from sleep.S on 64-bit but not on 32-bit?  Why
> > can't you make it so that the 32-bit TLB setup can be called into in a
> > similar manner?
> 
> Yes. I also wish to do like this. As I mentioned, the problem in 32-bit
> is that the TLB setup code in fsl_booke_entry_mapping.S only setups a temp
> mapping of 4KB, so these code only can run in this 4KB address space. But the
> code in sleep.S is outside of the 4KB space. So can't put the TLB setup
> code in sleep.S. There are two method to solve it.
> 1) The current method is running the TLB setup code of fsl_booke_entry_mapping.S in the 4KB
> space, then jump to the code of sleep.S.
> 2) extend the temp mapping space in the TLB setup code to cover kernel, say 4MB or 8MB. But
> not sure if there are any side effects.

fsl_booke_entry_mapping.S creates a 64M entry.  The 4K entry is only
temporary while in AS1 -- it shouldn't matter if the address you return
to when leaving fsl_booke_entry_mapping.S is outside the 4K, as long as
it's within the 64M entry.

Or am I missing something?

> > > > > > > +#define FSLDELAY(count)		\
> > > > > > > +	li	r3, (count)@l;	\
> > > > > > > +	slwi	r3, r3, 10;	\
> > > > > > > +	mtctr	r3;		\
> > > > > > > +101:	nop;			\
> > > > > > > +	bdnz	101b;
> > > > > > 
> > > > > > You don't need a namespace prefix on local macros in a non-header file.
> > > > > > 
> > > > > > Is the timebase stopped where you're calling this from?
> > > > > 
> > > > > No. My purpose is to avoid jump in the last stage of entering deep sleep.
> > > > > Jump may cause problem at that time.
> > > > 
> > > > "bdnz" is a jump.
> > > > 
> > > > What problems do you think a jump will cause?
> > > 
> > > I mean a far jump which can jump to an address which has not been prefetched in
> > > advance. I wish the code is executed in a restricted environment (predictable code
> > > and address).
> > 
> > Why would a timebase loop require a "far" jump?
> 
> I mean there is far jump in udely().
> 
> Do you mean using a timebase loop in the macro FSLDELAY? If so, I agree.

Yes, I meant a timebase loop, not udelay().

> > > > > > You also probably want to do a "sync, readback, data dependency, isync"
> > > > > > sequence to make sure that the store has hit CCSR before you begin your
> > > > > > delay (or is a delay required at all if you do that?).
> > > > > 
> > > > > Yes. It is safer with a sync sequence.
> > > > > 
> > > > > The DDR controller need some time to signal the external DDR modules to
> > > > > enter self refresh mode.
> > > > 
> > > > Is it documented how much time it requires?
> > > > 
> > > > -Scott
> > > 
> > > No.
> > 
> > How do you know the current delay is adequate in all circumstances (e.g
> > clock speeds), much less on future chips?  Is it documented that a delay
> > is needed at all, or is this just something that appeared to make it
> > work?  If the latter, what happens if you put the synchronization in,
> > but leave out the delay?
> > 
> > -Scott
> 
> The code controls external parts (FPGA/CPLD, DDR module) to act, and
> the sequent code must wait until external parts complete. We can't get
> an ack from external parts, so use delay to make sure the sequence and
> insert enough time to wait.

It would be good if you could get the hardware designers to provide an
upper bound for how long we need to wait.

-Scott


