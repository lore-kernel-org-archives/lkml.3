Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaBFUUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 15:20:01 -0500
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:43400
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751799AbaBFUUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 15:20:00 -0500
Message-ID: <1391717992.6733.232.camel@snotra.buserror.net>
Subject: Re: [PATCH] Convert powerpc simple spinlocks into ticket locks
From: Scott Wood <scottwood@freescale.com>
To: Torsten Duwe <duwe@lst.de>
CC: Peter Zijlstra <peterz@infradead.org>, <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        <linuxppc-dev@lists.ozlabs.org>, Ingo Molnar <mingo@kernel.org>
Date: Thu, 6 Feb 2014 14:19:52 -0600
In-Reply-To: <20140206173727.GA13048@lst.de>
References: <20140206103736.GA18054@lst.de>
	 <20140206163837.GT2936@laptop.programming.kicks-ass.net>
	 <20140206173727.GA13048@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: DM2PR04CA001.namprd04.prod.outlook.com (10.141.96.11) To
 DM2PR03MB398.namprd03.prod.outlook.com (10.141.84.140)
X-Forefront-PRVS: 0114FF88F6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(377424004)(199002)(189002)(24454002)(51704005)(81542001)(74876001)(94946001)(33646001)(94316002)(74366001)(50986001)(93916002)(50466002)(23676002)(77096001)(50226001)(95416001)(93136001)(65816001)(46102001)(76786001)(76796001)(47776003)(80022001)(63696002)(74706001)(77982001)(42186004)(87266001)(79102001)(85306002)(74502001)(54316002)(74662001)(92566001)(80976001)(4396001)(88136002)(92726001)(87286001)(90146001)(81686001)(81816001)(31966008)(56776001)(69226001)(47976001)(59766001)(62966002)(83322001)(81342001)(93516002)(86362001)(53806001)(47446002)(85852003)(47736001)(56816005)(76482001)(49866001)(89996001)(87976001)(83072002)(51856001)(77156001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB398;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:CCBFFC6F.86360644.F7F49DA2.44EB4AEC.202F0;InfoNoRecordsA:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-06 at 18:37 +0100, Torsten Duwe wrote:
> On Thu, Feb 06, 2014 at 05:38:37PM +0100, Peter Zijlstra wrote:
> > On Thu, Feb 06, 2014 at 11:37:37AM +0100, Torsten Duwe wrote:
> > > x86 has them, MIPS has them, ARM has them, even ia64 has them:
> > > ticket locks. They reduce memory bus and cache pressure especially
> > > for contended spinlocks, increasing performance.
> > > 
> > > This patch is a port of the x86 spin locks, mostly written in C,
> > > to the powerpc, introducing inline asm where needed. The pSeries
> > > directed yield for vCPUs is taken care of by an additional "holder"
> > > field in the lock.
> > > 
> > 
> > A few questions; what's with the ppc64 holder thing? Not having a 32bit
> > spinlock_t is sad.
> 
> I must admit that I haven't tested the patch on non-pseries ppc64 nor on
> ppc32. Only ppc64 has the ldarx and I tried to atomically replace the 
> holder along with the locks. That might prove unneccessary.

Why is the functionality of holder only required on 64-bit?  We have too
many 32/64 differences as is.  Perhaps on 32-bit a lower max number of
CPUs could be assumed, to make it fit in one word.

> > Can you pair lwarx with sthcx ? I couldn't immediately find the answer
> > in the PowerISA doc. If so I think you can do better by being able to
> > atomically load both tickets but only storing the head without affecting
> > the tail.
> 
> V2.06b, Book II, Chapter 3, "sthcx" says:
> | If a reservation exists and the length associated [...] is not 2 bytes,
> | it is undefined whether (RS)_48:63 are stored [...]
> 
> That doesn't make me feel comfortable :(

Plus, sthcx doesn't exist on all PPC chips.

-Scott


