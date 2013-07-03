Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab3GCPaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 11:30:55 -0400
Received: from mail1.windriver.com ([147.11.146.13]:55108 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab3GCPax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 11:30:53 -0400
Date: Wed, 3 Jul 2013 11:30:12 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Will Deacon <will.deacon@arm.com>,
        <linux-kernel@vger.kernel.org>, Joseph Lo <josephl@nvidia.com>,
        <linux-tegra@vger.kernel.org>, Stephen Warren <swarren@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: move body of head-common.S back to text section
Message-ID: <20130703153012.GK22702@windriver.com>
References: <1372805629-18382-1-git-send-email-swarren@wwwdotorg.org>
 <20130702232259.GH11625@codeaurora.org>
 <51D39004.9000907@wwwdotorg.org>
 <20130703051907.GA22702@windriver.com>
 <20130703100044.GG24642@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130703100044.GG24642@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [PATCH] ARM: move body of head-common.S back to text section] On 03/07/2013 (Wed 11:00) Russell King - ARM Linux wrote:

> On Wed, Jul 03, 2013 at 01:19:07AM -0400, Paul Gortmaker wrote:
> > As an aside, I'm now thinking any __INIT that implicitly rely on EOF for
> > closure are nasty traps waiting to happen and it might be worthwhile to
> > audit and explicitly __FINIT them before someone appends to the file...
> 
> That hides a different kind of bug though - I hate __FINIT for exactly
> that reason.  Consider this:

Agreed - perhaps masking that it is a ".previous" just hides the fact
that it is more like a pop operation vs. an on/off operation, or per
function as we have in C.

> 
> 	.text
> 	blah blah blah
> 	__INIT
> 	lots of init stuff
> 	__FINIT
> 	more .text stuff
> 
> Now, someone comes along and modifies this to be:
> 
> 	.text
> 	blah blah blah
> 	.data
> 	something else

Yeah, that would be kind of careless; not putting .data above the .text,
or at least closing with a .previous, but sure it could sneak past
review.

> 	__INIT
> 	lots of init stuff
> 	__FINIT

The presence of the above 3 lines of init block (i.e. here or not)
doesn't really change the fact that the .data guy broke the below .text
code by grandfathering it into .data -- But you could argue that him
seeing the 1st __INIT and that influenced him to decide to not read any
further down into the file -- which probably does happen, though.... :(

> 	more .text stuff
> 
> Now, what is the effect of that __FINIT now?  You get the following .text
> emitted into the .data section instead.  This is basically the same problem
> you've just encounted.
> 
> Maybe:
> 
> 	__FINIT
> 	.text
> 
> is the safest solution - and __FINIT becomes just a no-op marker to avoid
> anyone relying on its properties.

That seems reasonable to me.  I can't think of any self auditing that is
reasonably simple to implement.  One downside of __FINIT as a no-op vs.
what it is today, is that a dangling __FINIT in a file with no other
previous sections will emit a warning.  But that is a small low value
corner case I think.
