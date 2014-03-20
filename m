Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964848AbaCTWR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 18:17:57 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:28802
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758484AbaCTWRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 18:17:55 -0400
Message-ID: <1395353868.12479.342.camel@snotra.buserror.net>
Subject: Re: [PATCH 9/9] powerpc/pm: support deep sleep feature on T1040
From: Scott Wood <scottwood@freescale.com>
To: Kevin Hao <haokexin@gmail.com>
CC: Chenhui Zhao <chenhui.zhao@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>,
        <Jason.Jin@freescale.com>
Date: Thu, 20 Mar 2014 17:17:48 -0500
In-Reply-To: <20140320114735.GD10182@pek-khao-d1.corp.ad.wrs.com>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
	 <1394168285-32275-9-git-send-email-chenhui.zhao@freescale.com>
	 <1394586624.13761.132.camel@snotra.buserror.net>
	 <20140312055755.GA17203@pek-khao-d1.corp.ad.wrs.com>
	 <1394646185.13761.145.camel@snotra.buserror.net>
	 <20140313074613.GD26692@pek-khao-d1.corp.ad.wrs.com>
	 <1394835987.12479.119.camel@snotra.buserror.net>
	 <20140316045801.GA32188@pek-khao-d1.corp.ad.wrs.com>
	 <1395184734.12479.250.camel@snotra.buserror.net>
	 <20140320114735.GD10182@pek-khao-d1.corp.ad.wrs.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BLUPR07CA029.namprd07.prod.outlook.com (10.141.20.44) To
 BL2PR03MB388.namprd03.prod.outlook.com (10.141.91.153)
X-Forefront-PRVS: 01565FED4C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(57704003)(24454002)(377424004)(189002)(199002)(87976001)(83322001)(87266001)(87286001)(51856001)(95666003)(85306002)(69226001)(80976001)(97336001)(97186001)(1411001)(42186004)(83072002)(47776003)(85852003)(93516002)(20776003)(63696002)(65816001)(81342001)(53806001)(23676002)(76786001)(62966002)(46102001)(93136001)(49866001)(80022001)(47736001)(92726001)(77982001)(81542001)(94316002)(92566001)(77156001)(76796001)(95416001)(94946001)(54316002)(56776001)(88136002)(4396001)(79102001)(90146001)(56816005)(86362001)(93916002)(76482001)(89996001)(47976001)(50986001)(50226001)(74662001)(81686001)(81816001)(74706001)(33646001)(59766001)(77096001)(74502001)(47446002)(74876001)(50466002)(31966008)(74366001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB388;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:6626D29D.960A8065.31D43F8B.C0FEDB4A.202DE;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-20 at 19:47 +0800, Kevin Hao wrote:
> OK, so the intention of 'twi, isync' following the load is not to order the
> following storage access, but order the following delay loop instructions,
> right? But according to the e6500 manual, the instructions complete in order.
> The following is the definition of 'complete':
>   Complete—An instruction is eligible to complete after it finishes executing
>   and makes its results available for subsequent instructions. Instructions
>   must complete in order from the bottom two entries of the
>   completion queue (CQ). The completion unit coordinates how instructions (which
>   may have executed out of order) affect architected registers to ensure the
>   appearance of serial execution. This guarantees that the completed instruction
>   and all previous instructions can cause no exceptions. An instruction completes
>   when it is retired, that is, deleted from the CQ.
> 
> So the following delay loop instructions should never complete before the
> complete of the load instruction.

We don't want the delay loop instructions to *start* until the load has
completed.  Completion of the loop only matters when ordering the loop
versus post-loop actions (and again, there we'd want the loop to
complete before subsequent actions start).

> > > > > So if we want to order all the storage access as well
> > > > > as execution synchronization, we should choose sync here.
> > > > 
> > > > Do we need execution synchronization or context synchronization?
> > > 
> > > There is no context-altering instruction here, so I think an execution
> > > synchronizing instruction should be enough here.
> > 
> > Is the ISA ever explicit about what constitutes "context"?
> 
> The following is the definition of context-altering instruction:
>   An instruction that alters the context in which data
>   addresses or instruction addresses are interpreted, or
>   in which instructions are executed or data accesses are
>   performed, is called a context-altering instruction.
> 
> So the context should be:
>   - in which data addresses or instruction addresses are interpreted
>   - in which instructions are executed
>   - in which data accesses are performed

By that definition, a store to CCSR could easily change the context in
which data accesses are performed, by changing a mapping.

But still, nothing in the above defines "context" -- or rather, it does
so circularly.  While it makes intuitive sense that it would be limited
to context that lives within the core, rather than the rest of the
system, I don't think the ISA generally distinguishes between the two.

-Scott


