Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157AbaCUVQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 17:16:45 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:41198
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750710AbaCUVQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 17:16:44 -0400
Message-ID: <1395436593.12479.379.camel@snotra.buserror.net>
Subject: Re: [PATCH 9/9] powerpc/pm: support deep sleep feature on T1040
From: Scott Wood <scottwood@freescale.com>
To: David Laight <David.Laight@ACULAB.COM>
CC: "'Kevin Hao'" <haokexin@gmail.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Chenhui Zhao <chenhui.zhao@freescale.com>,
        "Jason.Jin@freescale.com" <Jason.Jin@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 21 Mar 2014 16:16:33 -0500
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F6E40C4@AcuExch.aculab.com>
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
	 <063D6719AE5E284EB5DD2968C1650D6D0F6E33AE@AcuExch.aculab.com>
	 <1395353279.12479.335.camel@snotra.buserror.net>
	 <063D6719AE5E284EB5DD2968C1650D6D0F6E40C4@AcuExch.aculab.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: DM2PR04CA007.namprd04.prod.outlook.com (10.141.96.17) To
 DM2PR03MB398.namprd03.prod.outlook.com (10.141.84.140)
X-Forefront-PRVS: 0157DEB61B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(377424004)(189002)(199002)(24454002)(47736001)(49866001)(4396001)(50226001)(74366001)(74876001)(23676002)(47976001)(50466002)(50986001)(51856001)(46102001)(89996001)(33646001)(76482001)(56816005)(93516002)(93136001)(53806001)(42186004)(56776001)(81342001)(97186001)(88136002)(81542001)(81816001)(19580395003)(81686001)(90146001)(97336001)(19580405001)(85852003)(62966002)(31966008)(83322001)(54316002)(80976001)(76786001)(85306002)(95666003)(87266001)(87286001)(94946001)(77156001)(77096001)(74502001)(65816001)(94316002)(77982001)(59766001)(79102001)(80022001)(93916002)(92566001)(87976001)(92726001)(83072002)(74662001)(47446002)(47776003)(20776003)(63696002)(86362001)(95416001)(98676001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB398;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:B42FF0D5.8BFA43D8.F1F1158F.42E75109.20387;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-21 at 09:21 +0000, David Laight wrote:
> From: Scott Wood [mailto:scottwood@freescale.com]
> > On Thu, 2014-03-20 at 11:59 +0000, David Laight wrote:
> > > I tried to work out what the 'twi, isync' instructions were for (in in_le32()).
> > > The best I could come up with was to ensure a synchronous bus-fault.
> > > But bus faults are probably only expected during device probing - not
> > > normal operation, and the instructions will have a significant cost.
> > >
> > > Additionally in_le32() and out_le32() both start with a 'sync' instruction.
> > > In many cases that isn't needed either - an explicit iosync() can be
> > > used after groups of instructions.
> > 
> > The idea is that it's better to be maximally safe by default, and let
> > performance critical sections be optimized using raw accessors and
> > explicit synchronization if needed, than to have hard-to-debug bugs due
> > to missing/wrong sync.  A lot of I/O is slow enough that the performance
> > impact doesn't really matter, but the brain-time cost of getting the
> > sync right is still there.
> 
> Hmmm....
> 
> That might be an excuse for the 'sync', but not the twi and isync.

That might be true if I/O is always cache inhibited and guarded, in
which case I think we can rely on that to ensure that the load has
completed before we do things like wrtee or rfi.  In any case, I'd want
to hear Ben's explanation.

> I was setting up a dma request (for the ppc 83xx PCIe bridge) and
> was doing back to back little-endian writes into memory.
> I had difficulty finding and including header files containing
> the definitions for byteswapped accesses I needed.
> arch/powerpc/include/asm/swab.h contains some - but I couldn't
> work out how to get it included (apart from giving the full path).
> 
> In any case you need to understand when synchronisation is
> required - otherwise you will get it wrong.
> Especially since non-byteswapped accesses are done by direct
> access.

Yes, it's bad that rawness combines the lack of byteswapping with the
lack of synchronization.  Ideally the raw accessors would also come in
big and little endian form, plus a native endian form if it's really
needed.

-Scott


