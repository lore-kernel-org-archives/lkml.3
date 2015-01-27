Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbbA0Vzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:55:53 -0500
Received: from axentia.se ([87.96.186.132]:61321 "EHLO EMAIL.axentia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755780AbbA0Vzv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:55:51 -0500
From: Peter Rosin <peda@axentia.se>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Wenyou Yang <wenyou.yang@atmel.com>,
        "nicolas.ferre@atmel.com" <nicolas.ferre@atmel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "sylvain.rochet@finsecur.com" <sylvain.rochet@finsecur.com>,
        "linux@maxim.org.za" <linux@maxim.org.za>
Subject: RE: [PATCH v3 03/13] pm: at91: Workaround DDRSDRC self-refresh bug
 with LPDDR1 memories.
Thread-Topic: [PATCH v3 03/13] pm: at91: Workaround DDRSDRC self-refresh bug
 with LPDDR1 memories.
Thread-Index: AQHQOiScCWovuWdO7UeEO88uR6g8+JzT2PoggACLsXA=
Date: Tue, 27 Jan 2015 21:55:52 +0000
Message-ID: <6740d1ada0cb4c8bbf765728c7443918@EMAIL.axentia.se>
References: <1422337810-3257-1-git-send-email-wenyou.yang@atmel.com>
 <1422338006-3371-1-git-send-email-wenyou.yang@atmel.com>
 <54C7675D.8000204@cogentembedded.com> 
Accept-Language: en-US, sv-SE
Content-Language: sv-SE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [217.210.101.82]
x-gfi-smtp-submission: 1
x-gfi-smtp-hellodomain: EMAIL.axentia.se
x-gfi-smtp-remoteip: 192.168.2.5
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Sergei Shtylyov wrote:
> > On 1/27/2015 8:53 AM, Wenyou Yang wrote:
> >
> > > From: Peter Rosin <peda@axentia.se>
> >
> > > The DDRSDR controller fails miserably to put LPDDR1 memories in
> > > self-refresh. Force the controller to think it has DDR2 memories
> > > during the self-refresh period, as the DDR2 self-refresh spec is
> > > equivalent to LPDDR1, and is correctly implemented in the controller.
> >
> > > Assume that the second controller has the same fault, but that is
> > > untested.
> >
> > > Signed-off-by: Peter Rosin <peda@axentia.se>
> > > Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > > ---
> > >   arch/arm/mach-at91/pm_slowclock.S  |   43
> > +++++++++++++++++++++++++++++++-----
> > >   include/soc/at91/at91sam9_ddrsdr.h |    2 +-
> > >   2 files changed, 39 insertions(+), 6 deletions(-)
> >
> > > diff --git a/arch/arm/mach-at91/pm_slowclock.S
> > > b/arch/arm/mach-at91/pm_slowclock.S
> > > index e2bfaf5..1155217 100644
> > > --- a/arch/arm/mach-at91/pm_slowclock.S
> > > +++ b/arch/arm/mach-at91/pm_slowclock.S
> > [...]
> > > @@ -108,14 +118,26 @@ ddr_sr_enable:
> > >
> > >   	/* figure out if we use the second ram controller */
> > >   	cmp	ramc1, #0
> > > -	ldrne	tmp2, [ramc1, #AT91_DDRSDRC_LPR]
> > > -	strne	tmp2, .saved_sam9_lpr1
> > > -	bicne	tmp2, #AT91_DDRSDRC_LPCB
> > > -	orrne	tmp2, #AT91_DDRSDRC_LPCB_SELF_REFRESH
> > > +	beq	ddr_no_2nd_ctrl
> > > +
> > > +	ldr	tmp2, [ramc1, #AT91_DDRSDRC_MDR]
> > > +	str	tmp2, .saved_sam9_mdr1
> > > +	bic	tmp2, tmp2, #~AT91_DDRSDRC_MD
> > > +	cmp	tmp2, #AT91_DDRSDRC_MD_LOW_POWER_DDR
> > > +	ldreq	tmp2, [ramc1, #AT91_DDRSDRC_MDR]
> > > +	biceq	tmp2, tmp2, #AT91_DDRSDRC_MD
> >
> >     Didn't you forget ~? Either that, or ~ above is not needed, I think.
> 
> The code is correct, the first bic with ~ clears bits not in the relevant
> field in order to compare if LPDDR mode is active. The second bic(eq)
> w/o ~ clears the field, to make way for the bits in the below orreq
> when actually changing the register content into DDR2 mode.
> 
> > > +	orreq	tmp2, tmp2, #AT91_DDRSDRC_MD_DDR2
> > > +	streq	tmp2, [ramc1, #AT91_DDRSDRC_MDR]
> > > +
> > > +	ldr	tmp2, [ramc1, #AT91_DDRSDRC_LPR]
> > > +	str	tmp2, .saved_sam9_lpr1
> > > +	bic	tmp2, #AT91_DDRSDRC_LPCB
> >
> >     Didn't you forget ~? And isn't it 3-operand instruction (as seen in the above
> > code)?
> 
> The logic for the LPR register is from the old code, the "only" thing
> I did to it was changing the instruction sequence to not have the
> ???ne form, i.e. ldrne, strne, bicne, orrne became ldr, str, bic, orr
> with a jump around it instead. So, the original code also had a two
> argument bic(ne), which indeed is strange, and I don't know why
> there is no warning from the assembler. Since there is no warning,
> my guess is that the assembler somehow mends it? Or does the
> patch actually break the second controller? It would be a surprise
> it the assembler handles 2-operand bicne differently from a

s/it the/if the/

> 2-operand bic, no?
> 
> > > +	orr	tmp2, #AT91_DDRSDRC_LPCB_SELF_REFRESH
> >
> >     Only 2 operands?
> 
> Same argument as above. I didn't touch it (sort of...)
> 
> Should I update the patch and fix this collateral 2-operand problem as
> well? To me, it feels like a separate patch, no?

I have now checked the assembler output, and apparently it mends the
input, just as I thought. That might be a fluke, of course, or it might be a
deliberate shorthand when the destination register is the same as the
following operand? But I also note that there are more instances of this
2 vs. 3 argument syntax, and I suggest that they are all fixed in one go,
if it is determined that they need fixing. I am obviously not an authority
when it comes to arm assembler syntax, so someone else will have to
advise...

Cheers,
Peter

