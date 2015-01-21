Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbbAUJuC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:50:02 -0500
Received: from mail-bn1on0113.outbound.protection.outlook.com ([157.56.110.113]:22174
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751017AbbAUJtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:49:55 -0500
Message-ID: <1421833786.4961.222.camel@freescale.com>
Subject: Re: [PATCH] powerpc/mpic: Add DT option to skip readback after EOI
From: Scott Wood <scottwood@freescale.com>
To: Purcareata Bogdan <b43198@freescale.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Date: Wed, 21 Jan 2015 03:49:46 -0600
In-Reply-To: <54BF72D1.3000302@freescale.com>
References: <1421236622-29366-1-git-send-email-bogdan.purcareata@freescale.com>
	 <1421258312.4961.133.camel@freescale.com> <54BF72D1.3000302@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: DM2PR11CA0005.namprd11.prod.outlook.com (25.160.91.15) To
 BY2PR0301MB0728.namprd03.prod.outlook.com (25.160.63.18)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=scottwood@freescale.com; 
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY2PR0301MB0728;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0728;
X-Forefront-PRVS: 04631F8F77
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(377424004)(51704005)(189002)(54094003)(24454002)(199003)(62966003)(77156002)(40100003)(68736005)(36756003)(50466002)(87976001)(2950100001)(97736003)(122386002)(23676002)(50226001)(110136001)(103116003)(46102003)(33646002)(42186005)(86362001)(106356001)(105586002)(92566002)(101416001)(47776003)(76176999)(50986999)(64706001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0728;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0728;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2015 09:49:52.7037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0728
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-21 at 11:35 +0200, Purcareata Bogdan wrote:
> On 14.01.2015 19:58, Scott Wood wrote:
> > On Wed, 2015-01-14 at 11:57 +0000, Bogdan Purcareata wrote:
> >> The readback is necessary in order to handle PCI posted
> >> writes,
> >
> > That is unclear.
> 
> I'm going to try an venture a different explanation here.
> 
> I found a good explanation in Writing PCI Drivers [1] as to why it's 
> necessary that a read is performed before returning from an EOI write:
> 
> "A good example of such a case is when a driver’s Interrupt Service 
> Routine (ISR) is dealing with the Interrupt Request Register (IRR) on a 
> card. Clearing a bit in the register indicates that the interrupt has 
> been serviced. This is done by posting a write to the register. If the 
> driver posts this write and exits its ISR, it could get interrupted 
> again immediately because the write hadn’t yet reached the bit in the 
> IRR to tell it to stop trying to interrupt. One solution to this 
> potential problem is to make sure to read back the value in the IRR 
> before exiting from the ISR. Most drivers do this anyway so they can 
> handle multiple interrupts in the same ISR visit."

That's an issue of ordering the device write versus the EOI -- it
doesn't explain why we'd need to order the EOI versus rfi, except maybe
that the extra delay just happens to be enough to give the device the
time it needs to deassert the second interrupt before it gets to the
point of interrupting the CPU.

FWIW, I'm skeptical of the "most drivers do this anyway" claim.

> >>   or when the MPIC is handling interrupts in a loop
> >> (ppc_md.get_irq).
> >
> > I'm questioning this one as well -- if reading WHOAMI is sufficient to
> > sync with the EOI, why wouldn't reading INTACK work as well?
> 
> I think I'm going to drop this part of the description. However, I don't 
> think reading INTACK is good, since it has some additional side effects 
> - interrupt pending register is cleared for edge-sensitive interrupts, 
> the in-service register is updated, and the int output signal from the 
> MPIC is negated. This is available for Freescale SoCs. This also 
> signifies entering the processing cycle of a new interrupt.

I wasn't suggesting that we start reading INTACK there.  I'm asking why,
back when we did read INTACK in a loop, that wasn't ordered relative to
the EOI write (but reading WHOAMI was).

> Normally, the readback should be done on the EOI register - this is 
> stated in the OpenPIC specification and actually was the initial 
> implementation of the driver. However, this can't be done since, at 
> least for Freescale SoCs, the EOI register is write only.
> 
> However, in the light of the above explanation related to PCI posted 
> writes, I don't see how performing a readback on the WHOAMI register, 
> which is specific to the MPIC, would have any effect in synchronizing 
> with the PCI device registers. I guess it's related to the bus 
> interconnect on the SoC.

I wonder if anyone has checked whether the spurious interrupts that
reading EOI got rid of have come back on those systems, now that we read
WHOAMI instead.

-Scott


