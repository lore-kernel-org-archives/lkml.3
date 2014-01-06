Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbaAFKEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 05:04:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55048 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaAFKEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 05:04:43 -0500
Date: Mon, 6 Jan 2014 11:04:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, akpm@linux-foundation.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC 1/2] mm: additional page lock debugging
Message-ID: <20140106100408.GC31570@twins.programming.kicks-ass.net>
References: <1388281504-11453-1-git-send-email-sasha.levin@oracle.com>
 <20131230114317.GA8117@node.dhcp.inet.fi>
 <52C1A06B.4070605@oracle.com>
 <20131230224808.GA11674@node.dhcp.inet.fi>
 <52C2385A.8020608@oracle.com>
 <20131231162636.GD16438@laptop.programming.kicks-ass.net>
 <52C2F3DC.2020106@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C2F3DC.2020106@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 31, 2013 at 11:42:04AM -0500, Sasha Levin wrote:
> On 12/31/2013 11:26 AM, Peter Zijlstra wrote:
> >On Mon, Dec 30, 2013 at 10:22:02PM -0500, Sasha Levin wrote:
> >
> >>I really want to use lockdep here, but I'm not really sure how to handle locks which live
> >>for a rather long while instead of being locked and unlocked in the same function like
> >>most of the rest of the kernel. (Cc Ingo, PeterZ).
> >
> >Uh what? Lockdep doesn't care about which function locks and unlocks a
> >particular lock. Nor does it care how long its held for.
> 
> Sorry, I messed up trying to explain that.
> 
> There are several places in the code which lock a large amount of pages, something like:
> 
> 	for (i = 0; i < (1 << order); i++)
> 		lock_page(&pages[i]);
> 
> 
> This triggers two problems:
> 
>  - lockdep complains about deadlock since we try to lock another page while one is already
> locked. I can clear that by allowing page locks to nest within each other, but that seems
> wrong and we'll miss actual deadlock cases.

Right,.. I think we can cobble something together like requiring we
always lock pages in pfn order or somesuch.

>  - We may leave back to userspace with pages still locked. This is valid behaviour but lockdep
> doesn't like that.

Where do we actually do this? BTW its not only lockdep not liking that,
Linus was actually a big fan of that check.

ISTR there being some filesystem freezer issues with that too, where the
freeze ioctl would return to userspace with 'locks' held and that's
cobbled around (or maybe gone by now -- who knows).

My initial guess would be that this is AIO/DIO again, those two seem to
be responsible for the majority of ugly around there.
