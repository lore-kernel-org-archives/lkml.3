Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab3DJKOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:14:01 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63571 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113Ab3DJKOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:14:00 -0400
Date: Wed, 10 Apr 2013 11:13:36 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: Re: [PATCH 1/4] Documentation: Add memory mapped ARM architected
 timer binding
Message-ID: <20130410101336.GB8799@e106331-lin.cambridge.arm.com>
References: <1365474623-29181-1-git-send-email-sboyd@codeaurora.org>
 <1365474623-29181-2-git-send-email-sboyd@codeaurora.org>
 <20130409090843.GS23725@e106331-lin.cambridge.arm.com>
 <516444FE.2080200@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516444FE.2080200@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 05:42:38PM +0100, Stephen Boyd wrote:
> On 04/09/13 02:08, Mark Rutland wrote:
> > On Tue, Apr 09, 2013 at 03:30:20AM +0100, Stephen Boyd wrote:
> >>  
> >> -** Timer node properties:
> >> +** CP15 Timer node properties:
> >>  
> >>  - compatible : Should at least contain one of
> >>  	"arm,armv7-timer"
> >> @@ -26,3 +30,55 @@ Example:
> >>  			     <1 10 0xf08>;
> >>  		clock-frequency = <100000000>;
> >>  	};
> >> +
> >> +** Memory mapped timer node properties
> >> +
> >> +- compatible : Should at least contain "arm,armv7-timer-mem".
> >> +
> >> +- #address-cells : Must be 1.
> > What about LPAE systems?
> >
> > How about something like the following:
> >
> > #address-cells : If the ranges property is empty, the same value as the
> >                  parent node's #address-cells property. Otherwise, a
> > 		 value such that the ranges property specifies a
> > 		 mapping to the parent node's address space.            
> 
> Yes that is much better. I wasn't trying to preclude LPAE or 64 bit systems.

Great.

> 
> >> +
> >> +- #size-cells : Must be 1.
> >> +
> >> +- ranges : Indicates parent and child bus address space are the same.
> >> +
> > Similarly, what if someone wants to write a more complex mapping for some
> > reason?
> >
> > We should be able to handle it if we use the standard accessors.
> 
> Maybe I should just leave this part out? They are standard DT properties
> so I could assume DT writers know what to do.

I'd be happy with that. It may be worth describing them as "as necessary" or
something to that effect.

> 
> >> +- clock-frequency : The frequency of the main counter, in Hz. Optional.
> >> +
> >> +- reg : The control frame base address.
> >> +
> >> +Frame:
> >> +
> >> +- frame-id: Encoded as follows:
> >> +		bits[3:0]  frame number: 0 to 7.
> >> +		bits[10:8] frame usage:
> >> +			0 - user/kernel
> >> +			1 - hyp
> >> +			2 - secure
> >> +
> > Could we not just have a disabled status property for those frames claimed by a
> > higher level (either secure firmware or hypervisor)? Or have I missed something
> > here?
> 
> Using disabled status would work. I was also thinking maybe we should
> use a compatible string in each frame's node. Then we could match
> against compatible children like "frame-user", "frame-kernel",
> "frame-hyp", "frame-secure", "frame-user-kernel", etc. It allows us
> flexibility if we should need to add something else in the future.

I can see why we need to specify secure/non-secure, but I'm not sure why we
need to specify hyp/user/kernel usage. Could we not leave this up to the kernel
to figure out?

A basic overveiew for those that don't know about the memory mapped timers:

* There's one control frame CNTCTLBase. Some registers in this frame are only
  available for secure accesses, including CNTNSAR which sets whether the
  counter frames are accessible from the non-secure side.

* There are up to 8 timer frames, which have their own CNTVOFF and
  physical/virtual timers. Each frame CNTBaseN is duplicated at CNTPL0BaseN
  with CNTVOFF and CNTPL0ACR (which controls PL0 accesses) inaccessible.

I can see that we might have frames/registers we can't access (if we were
booted on the non-secure side), but I can't see anything limiting whether we
use a frame for kernel/hyp/user beyond that. Have I missed something?

Could we not have something like the following for each frame:

frame0 {
	frame-id = <0>;
	status = "disabled"; /* booted NS, secure firmware has not enabled access */
	reg = <0x... 0x1000>, /* CNTBase0 */
	      <0x... 0x1000>; /* CNTPL0Base0 */
};

> 
> Also to get the frame number, I was thinking maybe we should expand the
> reg property to have two address cells. Then we could have reg = <0
> 0xf0001000 0x1000>.

We could do that, but then you definitely need a more complex ranges property,
and additional parsing code to handle grabbing it out of the reg property. I
can't see what it buys us.

Mark.
