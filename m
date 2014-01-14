Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaANTh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:37:58 -0500
Received: from relay2.sgi.com ([192.48.179.30]:46635 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751274AbaANThz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:37:55 -0500
Date: Tue, 14 Jan 2014 13:38:01 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>, linux-mm@kvack.org,
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
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: thp: Add per-mm_struct flag to control THP
Message-ID: <20140114193801.GV10649@sgi.com>
References: <1389383718-46031-1-git-send-email-athorlton@sgi.com>
 <20140110202310.GB1421@node.dhcp.inet.fi>
 <20140110220155.GD3066@sgi.com>
 <20140110221010.GP31570@twins.programming.kicks-ass.net>
 <20140110223909.GA8666@sgi.com>
 <20140114154457.GD4963@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114154457.GD4963@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 03:44:57PM +0000, Mel Gorman wrote:
> On Fri, Jan 10, 2014 at 04:39:09PM -0600, Alex Thorlton wrote:
> > On Fri, Jan 10, 2014 at 11:10:10PM +0100, Peter Zijlstra wrote:
> > > We already have the information to determine if a page is shared across
> > > nodes, Mel even had some prototype code to do splits under those
> > > conditions.
> > 
> > I'm aware that we can determine if pages are shared across nodes, but I
> > thought that Mel's code to split pages under these conditions had some
> > performance issues.  I know I've seen the code that Mel wrote to do
> > this, but I can't seem to dig it up right now.  Could you point me to
> > it?
> > 
> 
> It was a lot of revisions ago! The git branches no longer exist but the
> diff from the monolithic patches is below. The baseline was v3.10 and
> this will no longer apply but you'll see the two places where I added a
> split_huge_page and prevented khugepaged collapsing them again. 

Thanks, Mel.  I remember seeing this code a while back when we were
discussing THP/locality issues.

> At the time, the performance with it applied was much worse but it was a
> 10 minute patch as a distraction. There was a range of basic problems that
> had to be tackled before there was any point looking at splitting THP due
> to locality. I did not pursue it further and have not revisited it since.

So, in your opinion, is this something we should look into further
before moving towards the per-mm switch that I propose here?  I
personally think that it will be tough to get this to perform as well as
a method that totally disables THP when requested, or a method that
tries to prevent THPs from being handed out in certain situations, since
we'll be doing the work of both making and splitting a THP in the case
where remote accesses are made to the page.

I also think there could be some issues with over-zealously splitting
pages, since it sounds like we can only determine if an access is from a
remote node.  We don't have a good way of determining how many accesses
are remote vs. local, or how many separate nodes are accessing a page.

For example, I can see this being a problem if we have a large
multi-node system, where only two nodes are accessing a THP.  We might
end up splitting that THP, but if relatively few remote nodes are
accessing it, it may not be worth the time.  The split only seems
worthwhile to me if the majority of accesses are remote, which sounds
like it would be hard to determine.

One thing we could possibly do would be to add some structures to do a
bit of accounting work into the mm_struct or some other appropriate
location, then we could keep track of how many distinct remote nodes are
accessing a THP and decide to split based on that.  However, there's
still the overhead to creating/splitting the THP, and the extra
space/time needed to do the proper accounting work may be
counterproductive (if this is even possible, I'm just thinking out loud
here).

- Alex
