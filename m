Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab3GCRVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 13:21:32 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35528 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab3GCRVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 13:21:31 -0400
Date: Wed, 3 Jul 2013 18:20:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, Joseph Lo <josephl@nvidia.com>,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: move body of head-common.S back to text section
Message-ID: <20130703172001.GH24642@n2100.arm.linux.org.uk>
References: <1372805629-18382-1-git-send-email-swarren@wwwdotorg.org> <20130702232259.GH11625@codeaurora.org> <51D39004.9000907@wwwdotorg.org> <20130703051907.GA22702@windriver.com> <20130703100044.GG24642@n2100.arm.linux.org.uk> <20130703153012.GK22702@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130703153012.GK22702@windriver.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 11:30:12AM -0400, Paul Gortmaker wrote:
> [Re: [PATCH] ARM: move body of head-common.S back to text section] On 03/07/2013 (Wed 11:00) Russell King - ARM Linux wrote:
> 
> > On Wed, Jul 03, 2013 at 01:19:07AM -0400, Paul Gortmaker wrote:
> > > As an aside, I'm now thinking any __INIT that implicitly rely on EOF for
> > > closure are nasty traps waiting to happen and it might be worthwhile to
> > > audit and explicitly __FINIT them before someone appends to the file...
> > 
> > That hides a different kind of bug though - I hate __FINIT for exactly
> > that reason.  Consider this:
> 
> Agreed - perhaps masking that it is a ".previous" just hides the fact
> that it is more like a pop operation vs. an on/off operation, or per
> function as we have in C.

I read the info pages, because I thought it was a pop operation too.
I was concerned that .section didn't push the previous section onto the
stack.

However, .popsection is the pseudio-op which pops.  .previous just toggles
the current section with the section immediately before it.

So:

	.text
	.data
	.previous
	/* this is .text */
	.previous
	/* this is .data */
	.previous
	/* this is .text */
	.previous
	/* this is .data */

> That seems reasonable to me.  I can't think of any self auditing that is
> reasonably simple to implement.  One downside of __FINIT as a no-op vs.
> what it is today, is that a dangling __FINIT in a file with no other
> previous sections will emit a warning.  But that is a small low value
> corner case I think.

That warning from __FINIT will only happen if there has been no section
or .text or .data statement in the file at all.  As soon as you have any
statement setting any kind of section, .previous doesn't warn.

So:

	.text
	...
	__FINIT

produces no warning.
