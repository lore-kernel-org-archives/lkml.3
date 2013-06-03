Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759148Ab3FCWiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:38:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34388 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758739Ab3FCWik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:38:40 -0400
Date: Mon, 3 Jun 2013 23:38:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Brian Swetland <swetland@google.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] ARM: avoid mis-detecting some V7 cores in the
	decompressor
Message-ID: <20130603223829.GQ18614@n2100.arm.linux.org.uk>
References: <1368049671-22879-1-git-send-email-sboyd@codeaurora.org> <5193E424.9090605@codeaurora.org> <519E57D2.3050000@codeaurora.org> <20130523231531.GT18614@n2100.arm.linux.org.uk> <20130524220539.GB599@codeaurora.org> <51AD0703.6050408@codeaurora.org> <alpine.LFD.2.03.1306031726410.1200@syhkavp.arg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.03.1306031726410.1200@syhkavp.arg>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 05:33:45PM -0400, Nicolas Pitre wrote:
> > On 05/24/13 15:05, Stephen Boyd wrote:
> > > I see a few solutions.
> > >
> > >  1) Relocate with caches off and then turn on caches after we're
> > >     running in a location where we won't overwrite ourselves.
> 
> Due to the cost of doing memory copy with the cache off, thisoption 
> should be conditionally used and only when there is an actual conflict.
> 
> > >  2) Have temporary page tables for the relocation phase that live
> > >     just below the location we're going to relocate to.
> > >
> > >  3) Force bootloaders loading these types of images to load the
> > >     zImage at least as high as the TEXT_OFFSET is compiled to.
> > >
> > > I don't think we can convince everyone that #3 is ok to do. I'm
> > > leaning towards #2 since we get all the benefits of the cache
> > > during the relocation phase but #1 is the obviously simple fix.
> 
> I'd consider #2 too.

The problem with #2 is the added complexity it brings.  The _whole_
point of loading the kernel at RAM+32K is so that we know that the
32K below the image is available for our use cheaply without playing
all sorts of stupid games with turning caches on and off multiple
times, or changing page tables and such like.

The initialization is already complicated enough, it doesn't need to
become any more complicated.

An even simpler solution to this would be to pad the decompressor
with a branch, and 32K-4 of zeros.  That removes the whole problem
without adding much more code, but at the expense of 32K of bloat.
32K is nothing compared to the >1.5MB zImage size we have today.
