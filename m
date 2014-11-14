Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934949AbaKNBDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:03:44 -0500
Received: from mail-bl2on0105.outbound.protection.outlook.com ([65.55.169.105]:46708
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934582AbaKNBDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:03:42 -0500
Date: Thu, 13 Nov 2014 18:58:21 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: Pranith Kumar <bobby.prani@gmail.com>
CC: <paulmck@linux.vnet.ibm.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@freescale.com>,
        Michael Neuling <mikey@neuling.org>,
        "Wolfram Sang" <wsa@the-dreams.de>,
        Cristian Stoica <cristian.stoica@freescale.com>,
        open list:
	CRYPTO API <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, ;
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	;
			^-missing semicolon to end mail group, extraneous tokens in mailbox, missing end of mailbox
Subject: Re: [PATCH 01/16] crypto: caam - Remove unnecessary
 smp_read_barrier_depends()
Message-ID: <20141113185821.2d40f2decabaa7fac13cb816@freescale.com>
In-Reply-To: <546527D0.9040806@gmail.com>
References: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
	<1415906662-4576-2-git-send-email-bobby.prani@gmail.com>
	<20141113201001.GQ4460@linux.vnet.ibm.com>	<546527D0.9040806@gmail.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(199003)(51704005)(189002)(377454003)(479174003)(164054003)(33646002)(93916002)(92726001)(31966008)(87286001)(92566001)(88136002)(102836001)(77156002)(44976005)(62966003)(19580405001)(20776003)(84676001)(47776003)(87936001)(46102003)(6806004)(19580395003)(68736004)(104016003)(93886004)(104166001)(110136001)(21056001)(50466002)(100306002)(107046002)(106466001)(95666004)(105606002)(50226001)(99396003)(46406003)(23726002)(120916001)(86362001)(97736003)(64706001)(50986999)(36756003)(76176999)(4396001)(89996001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB399;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB399;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB399;
X-Forefront-PRVS: 03950F25EC
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB399;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014 16:51:12 -0500
Pranith Kumar <bobby.prani@gmail.com> wrote:

> On 11/13/2014 03:10 PM, Paul E. McKenney wrote:
> > On Thu, Nov 13, 2014 at 02:24:07PM -0500, Pranith Kumar wrote:
> >> Recently lockless_dereference() was added which can be used in place of
> >> hard-coding smp_read_barrier_depends(). The following PATCH makes the change.
> >>
> >> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> >> ---
> >>  drivers/crypto/caam/jr.c | 3 ---
> >>  1 file changed, 3 deletions(-)
> >>
> >> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
> >> index bae20d8..9b3ef1bc 100644
> >> --- a/drivers/crypto/caam/jr.c
> >> +++ b/drivers/crypto/caam/jr.c
> >> @@ -181,8 +181,6 @@ static void caam_jr_dequeue(unsigned long devarg)
> >>  		for (i = 0; CIRC_CNT(head, tail + i, JOBR_DEPTH) >= 1; i++) {
> >>  			sw_idx = (tail + i) & (JOBR_DEPTH - 1);
> >>
> >> -			smp_read_barrier_depends();
> >> -
> > 
> > Did you mean to add a lockless_dereference() somewhere?  I would guess
> > that one is required on the load into sw_idx before the "for" loop,
> > but I cannot claim to be familiar with this code.
> 
> No, I could not understand why the barrier was here in the first place. The change log does not reflect the subject line.
> 
> sw_idx is a local variable and is used to index the entinfo array. It does not seem like the barrier is needed. If not a comment saying why could be added I guess.

I likely misinterpreted the "read index before reading contents at
that index" instructions in early circular buffer documentation, and
left it in for the benefit of the doubt.  Now it looks to me it's not
necessary, given both sw_idx and tail are just being computed within
a lock, and removing both barriers doesn't affect the compiler
output, so:

Reviewed-by: Kim Phillips <kim.phillips@freescale.com>

Thanks,

Kim
