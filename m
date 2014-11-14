Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965057AbaKNJ43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 04:56:29 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:49234 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751AbaKNJ40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 04:56:26 -0500
Date: Fri, 14 Nov 2014 09:56:21 +0000
From: Peter Griffin <peter.griffin@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
        patrice.chotard@st.com, devicetree@vger.kernel.org,
        lee.jones@linaro.org
Subject: Re: [PATCH v2 13/14] ARM: STi: DT: STiH410: Add usb2 picophy dt nodes
Message-ID: <20141114095621.GA1648@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1415876417-28728-1-git-send-email-peter.griffin@linaro.org>
 <3348806.YN8XP4V4uc@wuerfel>
 <20141113145419.GA30296@griffinp-ThinkPad-X1-Carbon-2nd>
 <2401196.5cvW5dPSz2@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2401196.5cvW5dPSz2@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Thu, 13 Nov 2014, Arnd Bergmann wrote:

> On Thursday 13 November 2014 14:54:19 Peter Griffin wrote:
> > 
> > > 
> > > It also seems that you have put the node in the wrong place, as the reg
> > > property apparently refers to a different address space. Did you mean
> > > to put this under the syscfg_core node?
> > 
> > Your correct in that it refers to the syscfg_core address space.
> > However I intentionaly didn't put it under the syscfg_core node.
> > 
> > The phy is more unique than most other devices in that in this instance it
> > is only controlled from two syscfg_core registers which happen to be in the same
> > sysconf bank.
> >
> > However most other devices tend to have a combination of some memory mapped
> > registers and also some sysconfig registers which does then create a conflict
> > over where the dt node should live.
> > 
> > Currently I can't find an example but there is also no guarentee that a
> > device will not have some configuration bits in syscfg_core and some
> > other bits in syscfg_rear/front registers. The phy for example could
> > have had one register in each, which would make deciding where to put
> > it difficult.
> > 
> > So to create coherency / conformity we decided to put all the IP blocks under the soc node.
> > 
> > Also its worth pointing if your not already aware that sysconf_core/rear/front isn't
> > really a device, it's just a regmap abstraction of some memory mapped configuration
> > registers where a bunch of seemingly random control bits get stuffed.
> > 
> > Of course if you feel strongly about it I can of course change it like you suggested,
> > but that is the reasoning / rationale of why it was done like this initially.
> 
> The problem is your use of the 'reg' property. If it doesn't refer to the
> node's address space, it shouldn't be called 'reg'.
> 
> Please fix the binding.

I'll appologize in advance as I'm not sure I've understood you correctly, definately your answer
has given me a bunch more questions to clarify my understanding...

In the case of this particular node, then both reg properties refer to the syscfg_core address space
as both <0xf8 0x04> and <0xf4 0x04> are offsets into syscfg_core registers. So moving it under
the syscfg_core like you originaly suggested I believe would meet the definition of 'reg' ("describes the
address of the device's resources within the address space defined by its parent bus").

Or maybe you meant, if I want to keep the picophy node where it is (under soc), I need to stop using the reg
property?

The other problem I was describing is a device with some memory mapped registers and some
sysconfig registers you can find examples already upstream in stih416.dtsi file with the
ethernet0 and miphy365x_phy nodes.

Here the first 1/2 reg properties are expressed as a 32 bit physical address and size (meets the spec definition),
and the last is expressed as a sysconfig offset and size (which AFAIK doesn't match the spec definition).
This change in address space is however documented in the bindings documentation.

How should devices which have multiple address spaces ideally be handled?

>From looking around in the source I see a few different ways people have done this: -

1) Some drivers encode the data statically into the source and make a decision based on compatible string.
2) Some drivers add a couple of extra dt properties to encode the offset (spifsm in stih416)
3) Some drivers mix address spaces in the reg properties (examples given above) 
3) Probably some other ways I've not found yet

Is there a blessed way of doing this? It would be nice at least for all the drivers in STI to be doing
it the same as currently there seems to be a mix of implementations.

For the moment I think we can forget the third example in my previous email as it is currently hypothetical.

regards,

Peter.
