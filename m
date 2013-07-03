Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab3GCKCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 06:02:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35449 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932445Ab3GCKCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 06:02:19 -0400
Date: Wed, 3 Jul 2013 11:00:44 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, Joseph Lo <josephl@nvidia.com>,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: move body of head-common.S back to text section
Message-ID: <20130703100044.GG24642@n2100.arm.linux.org.uk>
References: <1372805629-18382-1-git-send-email-swarren@wwwdotorg.org> <20130702232259.GH11625@codeaurora.org> <51D39004.9000907@wwwdotorg.org> <20130703051907.GA22702@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130703051907.GA22702@windriver.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 01:19:07AM -0400, Paul Gortmaker wrote:
> As an aside, I'm now thinking any __INIT that implicitly rely on EOF for
> closure are nasty traps waiting to happen and it might be worthwhile to
> audit and explicitly __FINIT them before someone appends to the file...

That hides a different kind of bug though - I hate __FINIT for exactly
that reason.  Consider this:

	.text
	blah blah blah
	__INIT
	lots of init stuff
	__FINIT
	more .text stuff

Now, someone comes along and modifies this to be:

	.text
	blah blah blah
	.data
	something else
	__INIT
	lots of init stuff
	__FINIT
	more .text stuff

Now, what is the effect of that __FINIT now?  You get the following .text
emitted into the .data section instead.  This is basically the same problem
you've just encounted.

Maybe:

	__FINIT
	.text

is the safest solution - and __FINIT becomes just a no-op marker to avoid
anyone relying on its properties.
