Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab3LQTpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:45:23 -0500
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:3638
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752989Ab3LQTpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:45:20 -0500
Message-ID: <1387309507.10013.432.camel@snotra.buserror.net>
Subject: Re: [PATCH] DTS: DMA: Fix DMA3 interrupts
From: Scott Wood <scottwood@freescale.com>
To: Li Yang <leoli@freescale.com>
CC: Hongbo Zhang <hongbo.zhang@freescale.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>
Date: Tue, 17 Dec 2013 13:45:07 -0600
In-Reply-To: <CADRPPNRy9SLauRPy0Ucm-xffuAhA7bMsA+9X4a=8XNRaJVMH5A@mail.gmail.com>
References: <1385712446-28221-1-git-send-email-hongbo.zhang@freescale.com>
	 <1386357684.7375.124.camel@snotra.buserror.net>
	 <52A6EDE8.5060903@freescale.com>
	 <1386700403.10013.109.camel@snotra.buserror.net>
	 <CADRPPNRy9SLauRPy0Ucm-xffuAhA7bMsA+9X4a=8XNRaJVMH5A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BN1PR09CA005.namprd09.prod.outlook.com (10.255.197.45) To
 DM2PR03MB399.namprd03.prod.outlook.com (10.141.84.148)
X-Forefront-PRVS: 006339698F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(377454003)(377424004)(189002)(24454002)(199002)(51704005)(51856001)(74502001)(47446002)(46102001)(74662001)(31966008)(88136002)(85852003)(83072002)(77156001)(77096001)(69226001)(50466002)(81542001)(89996001)(63696002)(47736001)(47976001)(56816005)(49866001)(4396001)(50226001)(50986001)(74876001)(33646001)(81816001)(53806001)(85306002)(87266001)(42186004)(76482001)(59766001)(81686001)(79102001)(81342001)(62966002)(54316002)(76786001)(65816001)(76796001)(80976001)(80022001)(74706001)(83322001)(19580405001)(87976001)(56776001)(47776003)(90146001)(77982001)(74366001)(19580395003)(87286001)(23676002)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB399;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-17 at 16:48 +0800, Li Yang wrote:
> On Wed, Dec 11, 2013 at 2:33 AM, Scott Wood <scottwood@freescale.com> wrote:
> > On Tue, 2013-12-10 at 18:33 +0800, Hongbo Zhang wrote:
> >> Scott,
> >> This issue is due to the non-continuous MPIC register, I think there is
> >> two ways to fix it.
> >>
> >> The first one is as what we are discussing, in fact the Bman/Qman DT
> >> author had introduced this way, and I had to follow it, it is a trick,
> >> adding 208 is a bit ugly I think, and even difficult to explain it to
> >> customers etc, but this way changes less codes.
> >>
> >> The second one is editing MPIC related codes without adding 208 to high
> >> interrupts. The point of translate interrupt number to MPIC register
> >> address is a so called 'isu' mechanism, we can do like the following
> >> example codes, then the tricky adding 208 isn't needed any more.
> >>
> >> Which one do you prefer?
> >> In fact I myself prefer the second, if the idea is acceptable, I will
> >> send a patch instead of this one. (and also alone with the internal
> >> patch decreasing 208 for the Bman/Qman)
> >>
> >> void __init corenet_ds_pic_init(void)
> >> {
> >>      ......
> >>
> >>      mpic = mpic_alloc(NULL, 0, flags, 0, 512, "OpenPIC");
> >>      BUG_ON(mpic == NULL);
> >>
> >> // Add this start
> >>      for (i = 0; i < 17; i++) {
> >>          if (i < 11)
> >>              addr_off = 0x10000 + 0x20 * 16 * i;
> >>          else
> >>              addr_off = 0x13000 + 0x20 * 16 * (i - 11);  /* scape the
> >> address not for interrupts */
> >>          mpic_assign_isu(mpic, i, mpic->paddr + addr_off);
> >>      }
> >> // Add this end
> >>
> >>      mpic_init(mpic);
> >> }
> >
> > NACK
> >
> > We already have a binding that states that the interrupt number is based
> > on the register offset, rather than whatever arbitrary numbers hardware
> > documenters decide to use next week.
> >
> > While I'm not terribly happy with the usability of this, especially now
> > that it's not a simple "add 16", redefining the existing binding is not
> > OK (and in any case the code above seems obfuscatory).  If we decide to
> > do something other than continue with register offset divided by 32,
> > then we need to define a new interrupt type (similar to current defined
> > types of error interrupt, timer, and IPI) for the new numberspace -- and
> > it should be handled when decoding that type of interrupt specifier,
> > rather than with the isu mechanism.
> 
> I had to say that the current binding is terribly confusing.  I know a
> lot of people who were confused while looking into the device tree and
> I had to help them out now and then.  I even got confused for some
> time at the very beginning.  :(  If we want to keep the current
> binding, a big warning message is well deserved at the very beginning
> of the binding document to clarify that the interrupt number used in
> device tree has nothing to do with the interrupt number mentioned in
> the silicon reference manuals.  I think we should even mention the
> "add 16" magic rule also to make it more intuitive.

I suggested some explanatory text in another thread.

> Adding a new interrupt type for external interrupts is good to make
> the interrupt number consistent with the Reference Manuals.  But doing
> that requires changing all the device trees that used the previous
> binding, 

We may want to change them all for clarity, but there's no compatibility
issue.  Old device trees must continue to be supported.

> and we need a mechanism of judging which binding a device
> tree is complying to.

If it uses the new interrupt type number, then it's the new binding.
Otherwise, it's the old.  The binding would only be added to, not
changed.

I'm not convinced it's worth adding at this point, though -- let's add
some helpful text to the binding and see how much that helps.

-Scott


