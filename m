Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab3HUXbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 19:31:21 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:23340 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752589Ab3HUXbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 19:31:19 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zzbb2dI98dI9371I936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1377127873.5029.72.camel@snotra.buserror.net>
Subject: Re: [PATCH v7 2/3] DMA: Freescale: Add new 8-channel DMA engine
 device tree nodes
From: Scott Wood <scottwood@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: <hongbo.zhang@freescale.com>, <vinod.koul@intel.com>, <djbw@fb.com>,
        <leoli@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Wed, 21 Aug 2013 18:31:13 -0500
In-Reply-To: <52154A22.4090809@wwwdotorg.org>
References: <1375094944-3343-1-git-send-email-hongbo.zhang@freescale.com>
	  <1375094944-3343-3-git-send-email-hongbo.zhang@freescale.com>
	  <521541EE.4010303@wwwdotorg.org>
	 <1377125827.5029.50.camel@snotra.buserror.net>
	 <52154A22.4090809@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-21 at 17:15 -0600, Stephen Warren wrote:
> On 08/21/2013 04:57 PM, Scott Wood wrote:
> > On Wed, 2013-08-21 at 16:40 -0600, Stephen Warren wrote:
> >> On 07/29/2013 04:49 AM, hongbo.zhang@freescale.com wrote:
> 
> >>> +- ranges            : describes the mapping between the address space of the
> >>> +                      DMA channels and the address space of the DMA controller
> >>
> >> Oh, so looking at the example, this is simply about being able to write
> >> the reg value in the child nodes more easily without having to write out
> >> the full based address of the controller in each child node.
> >>
> >> I don't think the binding document should require this;
> > 
> > It doesn't.  It just requires that there be a mapping; it doesn't have
> > to be any particular mapping.
> > 
> >> all the binding document should care about is that the child nodes have a valid reg
> >> value. Whether that reg value is <0x100100 0x80> without a ranges in the
> >> top-level DMA
> > 
> > Without a ranges property there is no translation and the registers
> > would not be memory mappable.  Linux may treat the absence of ranges as
> > an identity mapping for compatibility with some broken OF trees, but
> > it's not standard.
> 
> I would argue that missing ranges meaning 1:1 translation is now a
> standard, given that it must be true to support some DTs, it therefore
> can now be assumed?

"Some broken tree does it therefore it's fine for everyone to do it" is
awful.  We have standards documents for a reason.

Plus, not all OSes need to run on hardware with that broken firmware.
For example, the Freescale Embedded Hypervisor will not accept a missing
ranges in that way.  U-Boot does accept it, but only because the code
was copied from Linux (including the comment that says it's not supposed
to work that way).

If anything, we should remove the hack from U-Boot, and fix Linux to
only apply it in situations where it's known to be needed.

> >> Why do the channel nodes even need a compatible value? Presumably the
> >> driver for the top-level DMA node will scan these dma-channel nodes to
> >> extract the information it needs and will simply assume that all these
> >> nodes are DMA channel nodes rather than something else? I suppose this
> >> doesn't hurt, it just seems unnecessary unless you foresee other child
> >> nodes types existing in the future and hence a need to differentiate
> >> different types of nodes.
> > 
> > Other than "this is how the existing binding works and we're not going
> > to break compatibility", it allows the OS more flexibility to choose
> > whether to bind to controllers or directly to the channels.  Sometimes a
> > channel will be labelled with a different compatible if it has a fixed
> > purpose such as being connected to audio hardware (e.g. mpc8610_hpcd.dts
> > where some channels are "fsl,ssi-dma-channel").
> 
> That sounds terribly like encoding policy into DT rather than it being a
> HW description.

It is hardware description.  Those DMA channels are physically wired
into the audio hardware.  Other DMA channels in the same system aren't.

The only thing that's even slightly policy is that it assumes you aren't
going to ignore the audio device altogether, and use it as an extra
generic DMA channel.  I'm not sure that it's worthwhile to care in this
case.  If you want to be 100% policy-free then we shouldn't be
specifying a lot of the addresses we currently do, since that's actually
just how U-Boot configured things.  Sometimes simplifying assumptions
get made, when what the hardware people actually came up with is too
awkward to be worth describing directly.  In any case, this is not new,
nor is it relevant to the hardware we're currently adding support for,
and we're not going to break compatibility now.

-Scott



