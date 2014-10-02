Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaJBK5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 06:57:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48795 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaJBK5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 06:57:42 -0400
Date: Thu, 2 Oct 2014 12:57:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <ak@linux.intel.com>, dave@sr71.net,
        linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        x86@kernel.org
Subject: Re: [PATCH 1/2] Use faster check for modules in backtrace on 64bit
Message-ID: <20141002105734.GD2849@worktop.programming.kicks-ass.net>
References: <1411774277-4198-1-git-send-email-andi@firstfloor.org>
 <1411774277-4198-2-git-send-email-andi@firstfloor.org>
 <20140929114212.GG5430@worktop>
 <20140929152145.GB1629@tassilo.jf.intel.com>
 <20140929203023.GA8196@two.firstfloor.org>
 <20140930085814.GS5430@worktop>
 <20140930200959.GB8196@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930200959.GB8196@two.firstfloor.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 10:10:00PM +0200, Andi Kleen wrote:
> > > Also I investigated it now, but we don't have RCU support for rbtrees.
> > > So it would need some kind of locking for the reader, which is a show
> > > stopper.
> > 
> > Nah, we can trivially do that with a seqlock. Not read side locking
> > required in the normal case.
> 
> I'm not convinced. It wouldn't surprise me if it was possible
> to generate endless cycles with rcu freed memory on some rebalancing
> operation.

I don't think so, every (tree) rotation still maintains the tree as a
tree, therefore downward iteration will always get you to the end.

You might temporarily run in circles until you observe the new pointers,
but that is not a problem, and strictly limited to however long it takes
for the new pointers to become visible on the iterating CPU.

Deletion should not be a problem either, if the deleted node retains
pointers, they'll point back into the tree, and by the previous
argument, downward iteration terminates.

> If you think I'm wrong please show working code.

That is unrelated to the above, you're just not willing to work on it.
Which is fine, then this problem will remain for a little while longer.

> Also please explain clearly for the module maintainers and me
> what the problem with my original simple trivially show
> to be correct solution is.

It is not correct, you yourself said there were false positives with it.
But the biggest issue is that its x86_64 only.
