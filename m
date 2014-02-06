Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbaBFRwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 12:52:10 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55117 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbaBFRwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 12:52:08 -0500
Date: Thu, 6 Feb 2014 18:52:01 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 5/5] arch: Sanitize atomic_t bitwise ops
Message-ID: <20140206175201.GH5002@laptop.programming.kicks-ass.net>
References: <20140206134825.305510953@infradead.org>
 <20140206135001.333583247@infradead.org>
 <CA+55aFwzn09dPJekgCbO2VRO8j3=eEt2j_QFd=Gd4MXTA2gm9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwzn09dPJekgCbO2VRO8j3=eEt2j_QFd=Gd4MXTA2gm9g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 08:53:02AM -0800, Linus Torvalds wrote:
> On Thu, Feb 6, 2014 at 5:48 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > Many archs have atomic_{set,clear}_mask() but not all. Remove these
> > and provide a comprehensive set of bitops:
> >
> >   atomic{,64}_{and,or,xor}{,_return}()
> 
> Who uses these, and why?

s390 is stuffed with atomic_{set,clear}_mask usage, no clue whatfor.

There's 2 atomic_set_mask() users in drm/i915, again haven't looked if
it makes sense.

Various archs use atomic_set_mask() for their tlb flush mask, which
arguably should be done using the bitmap functions we have.

> The "_return()" versions of atomic ops are noticeably slower and more
> complex on common architectures (ie x86), and apparently there is no
> use of them since they didn't exist.
> 
> So why add them? Just to encourage people to do bad things?

Fair enough, they're mostly an accident of how I implemented the macro
generation magic. I suppose I can change that and avoid generating the
_return thingies.

I don't particularly care for this patch too much; but I do dislike the
atomic_{set,clear}_mask() things -- mostly because they don't really fit
the normal atomic_t functions and because some archs have then and
others do no.

And atomic_{set,clear}_mask() can be used for setting/clearing multiple
bits as opposed to {set,clear}_bit, which only does a single bit.


