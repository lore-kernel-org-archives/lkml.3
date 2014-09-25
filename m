Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaIYUGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 16:06:08 -0400
Received: from mail-bn1bon0136.outbound.protection.outlook.com ([157.56.111.136]:32947
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750933AbaIYUGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 16:06:06 -0400
Message-ID: <1411675555.13320.200.camel@snotra.buserror.net>
Subject: Re: [PATCH 1/3 v2] drivers/bus: Added Freescale Management Complex
 APIs
From: Scott Wood <scottwood@freescale.com>
To: German Rivera <German.Rivera@freescale.com>
CC: Kim Phillips <kim.phillips@freescale.com>, <gregkh@linuxfoundation.org>,
        <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        <stuart.yoder@freescale.com>, <agraf@suse.de>,
        <linuxppc-release@linux.freescale.net>,
        Erez Nir-RM30794 <nir.erez@freescale.com>
Date: Thu, 25 Sep 2014 15:05:55 -0500
In-Reply-To: <5424466A.1010103@freescale.com>
References: <1411166981-3610-1-git-send-email-German.Rivera@freescale.com>
			<1411166981-3610-2-git-send-email-German.Rivera@freescale.com>
			<20140923194901.894483bfaef97d13d12c75a5@freescale.com>
			<54237CBF.2010706@freescale.com>
		 <20140924224006.f924cefdd347464519da8190@freescale.com>
		 <54243873.9060509@freescale.com>
	 <1411661796.13320.191.camel@snotra.buserror.net>
	 <5424466A.1010103@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:416f:c6f:49e6:9e61]
X-ClientProxiedBy: BN1PR08CA0031.namprd08.prod.outlook.com (10.242.217.159) To
 DM2PR0301MB0735.namprd03.prod.outlook.com (25.160.97.143)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0735;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(199003)(51444003)(189002)(479174003)(377454003)(377424004)(24454002)(31966008)(83072002)(23676002)(85306004)(77156001)(42186005)(83322001)(93886004)(62966002)(92566001)(99396003)(77096002)(97736003)(50986999)(105586002)(50466002)(104166001)(88136002)(120916001)(10300001)(90102001)(92726001)(47776003)(64706001)(76176999)(21056001)(33646002)(4396001)(107046002)(81542003)(74662003)(106356001)(89996001)(79102003)(74502003)(110136001)(85852003)(93916002)(103116003)(81342003)(87286001)(50226001)(77982003)(80022003)(87976001)(101416001)(95666004)(102836001)(20776003)(46102003)(76482002)(86362001)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0735;H:[IPv6:2601:2:5800:3f7:416f:c6f:49e6:9e61];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-25 at 11:44 -0500, German Rivera wrote:
> On 09/25/2014 11:16 AM, Scott Wood wrote:
> > Then again, the management complex is not supposed to be on the
> > performance critical path, so why not simplify by just always do the
> > locking here?
> >
> But about the few MC commands that need to run on interrupt context
> (such as to inspect or clear MC interrupts)?

I think that should be disallowed.  Unless you can guarantee that the MC
firmware will respond in a very short time, have those interrupts move
their work into a workqueue, with the MC interrupt masked until
completion.  We do similar things for interrupts from i2c devices, etc.

> >> The intent of doing the udelay() in the middle of the polling loop was
> >> to throttle down the frequency of I/Os done while polling for the
> >> completion of the command. Can you elaborate on why ".5ms udelay upsets
> >> basic kernel functionality"?
> >
> > It introduces latency, especially since it's possible for it to happen
> > with interrupts disabled.  And you're actually potentially blocking for
> > more than that, since 500us is just one iteration of the loop.
> >
> > The jiffies test for exiting the loop is 500ms, which is *way* too long
> > to spend in a critical section.
> >
> But that would be a worst case, since that is a timeout check.
> What timeout value do you think would be more appropriate in this case?

Worst case latency matters.  Some workloads would be bothered by an
occasional 500us.  Even normal interactive use would notice 500ms.

> >> Would it be better to just use "plain delay loop", instead of the udelay
> >> call, such as the following?
> >>
> >> for (i = 0; i < 1000; i++)
> >>      ;
> >
> > No, never do that.  You have no idea how long it will actually take.
> > GCC might even optimize it out entirely.
> >
> Ok, so udelay is not good here, a plain vanilla delay loop is not good 
> either. Are there other alternatives or we just don't worry about
> throttling down the frequency of I/Os done in the polling loop?

udelay is OK for this purpose, but not for so long, and find some way to
make the kernel preemptible between loop iterations.

> (Given the fact that MC commands are not expected to be executed that 
> frequently, to frequently cause a lot of I/O traffic with this polling loop)
> 
> >> I can see that in the cases where we use "completion interrupts", the
> >> ISR can signal the completion, and the polling loop can be replaced by
> >> waiting on the completion. However, I don't see how using a completion
> >> can help make a polling loop more efficient, if you don't have a
> >> "completion interrupt" to signal the completion.
> >
> > It's not about making it more efficient.  It's about not causing
> > problems for other things going on in the system.
> >
> But still I don't see how a completion can help here, unless
> you can signal the completion from an ISR.

Right, but you can still sleep on a timer instead of busy waiting if you
need such a long timeout.

-Scott


