Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964875Ab3GEPKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 11:10:50 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:46161 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757374Ab3GEPKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 11:10:48 -0400
Date: Fri, 5 Jul 2013 16:10:02 +0100
From: Dave P Martin <Dave.Martin@arm.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, Joseph Lo <josephl@nvidia.com>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: move body of head-common.S back to text section
Message-ID: <20130705151001.GF2932@localhost.localdomain>
References: <1372805629-18382-1-git-send-email-swarren@wwwdotorg.org>
 <20130702232259.GH11625@codeaurora.org>
 <51D39004.9000907@wwwdotorg.org>
 <20130703051907.GA22702@windriver.com>
 <20130703100044.GG24642@n2100.arm.linux.org.uk>
 <20130703153012.GK22702@windriver.com>
 <20130703172001.GH24642@n2100.arm.linux.org.uk>
 <20130704002235.GL22702@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130704002235.GL22702@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 08:22:35PM -0400, Paul Gortmaker wrote:
> [Re: [PATCH] ARM: move body of head-common.S back to text section] On 03/07/2013 (Wed 18:20) Russell King - ARM Linux wrote:
> 
> > On Wed, Jul 03, 2013 at 11:30:12AM -0400, Paul Gortmaker wrote:
> > > [Re: [PATCH] ARM: move body of head-common.S back to text section] On 03/07/2013 (Wed 11:00) Russell King - ARM Linux wrote:
> > > 
> > > > On Wed, Jul 03, 2013 at 01:19:07AM -0400, Paul Gortmaker wrote:
> > > > > As an aside, I'm now thinking any __INIT that implicitly rely on EOF for
> > > > > closure are nasty traps waiting to happen and it might be worthwhile to
> > > > > audit and explicitly __FINIT them before someone appends to the file...
> > > > 
> > > > That hides a different kind of bug though - I hate __FINIT for exactly
> > > > that reason.  Consider this:
> > > 
> > > Agreed - perhaps masking that it is a ".previous" just hides the fact
> > > that it is more like a pop operation vs. an on/off operation, or per
> > > function as we have in C.
> > 
> > I read the info pages, because I thought it was a pop operation too.
> > I was concerned that .section didn't push the previous section onto the
> > stack.
> > 
> > However, .popsection is the pseudio-op which pops.  .previous just toggles
> > the current section with the section immediately before it.
> > 
> > So:
> > 
> > 	.text
> > 	.data
> > 	.previous
> > 	/* this is .text */
> > 	.previous
> > 	/* this is .data */
> > 	.previous
> > 	/* this is .text */
> > 	.previous
> > 	/* this is .data */
> 
> Cool -- I bet we weren't the only ones thinking it was a pop.  Thanks.
> 
> Does that make __FINIT less evil than we previously assumed?  I think
> your example was the following pseudo-patch:
> 
> 
> 	.text
> 	<some text>
> +	.data
> + 	<some data>
> 	__INIT
> 	<big hunk of init>
> 	__FINIT
> 	/* this below used to be text */
> 	<more stuff that was originally meant for text>
> 
> Even if it is a toggle (vs. pop), the end text will now become data,
> so the no-op __FINIT with an explicit section called out just below
> it may still be the most unambiguous way to indicate what is going on.
> 
> > 
> > > That seems reasonable to me.  I can't think of any self auditing that is
> > > reasonably simple to implement.  One downside of __FINIT as a no-op vs.
> > > what it is today, is that a dangling __FINIT in a file with no other
> > > previous sections will emit a warning.  But that is a small low value
> > > corner case I think.
> > 
> > That warning from __FINIT will only happen if there has been no section
> > or .text or .data statement in the file at all.  As soon as you have any
> > statement setting any kind of section, .previous doesn't warn.
> > 
> > So:
> > 
> > 	.text
> > 	...
> > 	__FINIT
> > 
> > produces no warning.o
> 
> Yep -- we are both saying the same thing here - hence why I called it a
> small low value corner case.

Note that .previous has another important gotcha.  Consider:

	__INIT
	/* now in .text.init */
	ALT_UP(...)
	/* now in .text.init */
	__FINIT

	/* now in .alt.smp.text! */


.previous (or macros containing a dangling .previous) shouldn't be used
unless you're absolutely certain what the previous section was.

In general:

	label:
		<stuff>

		.previous

restores to the section which was current at label, only if there are
no section directives in <stuff>, nor anything which could contain a
section directive after macro expansion.

The same goes for the hidden, dangling .previous embedded in __FINIT
and friends.

Cheers
---Dave
