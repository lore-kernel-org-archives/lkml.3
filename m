Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382AbaAJWKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 17:10:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42576 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758359AbaAJWKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 17:10:49 -0500
Date: Fri, 10 Jan 2014 23:10:10 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Thorlton <athorlton@sgi.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-mm@kvack.org,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [RFC PATCH] mm: thp: Add per-mm_struct flag to control THP
Message-ID: <20140110221010.GP31570@twins.programming.kicks-ass.net>
References: <1389383718-46031-1-git-send-email-athorlton@sgi.com>
 <20140110202310.GB1421@node.dhcp.inet.fi>
 <20140110220155.GD3066@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140110220155.GD3066@sgi.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 04:01:55PM -0600, Alex Thorlton wrote:
> On Fri, Jan 10, 2014 at 10:23:10PM +0200, Kirill A. Shutemov wrote:
> > Do you know what cause the difference? I prefer to fix THP instead of
> > adding new knob to disable it.
> 
> The issue is that when you touch 1 byte of an untouched, contiguous 2MB
> chunk, a THP will be handed out, and the THP will be stuck on whatever
> node the chunk was originally referenced from.  If many remote nodes
> need to do work on that same chunk, they'll be making remote accesses.
> With THP disabled, 4K pages can be handed out to separate nodes as
> they're needed, greatly reducing the amount of remote accesses to
> memory.  I give a bit better description here:
> 
> https://lkml.org/lkml/2013/8/27/397
> 
> I had been looking into better ways to handle this issues, but after
> spinning through a few other ideas:
> 
> - Per cpuset flag to control THP:
> https://lkml.org/lkml/2013/6/10/331
> 
> - Threshold to determine when to hand out THPs:
> https://lkml.org/lkml/2013/12/12/394
> 
> We've arrived back here.  Andrea seemed to think that this is an
> acceptable approach to solve the problem, at least as a starting point:
> 
> https://lkml.org/lkml/2013/12/17/397
> 
> I agree that we should, ideally, come up with a way to appropriately
> handle this problem in the kernel, but as of right now, it appears that
> that might be a rather large undertaking.

We already have the information to determine if a page is shared across
nodes, Mel even had some prototype code to do splits under those
conditions.
