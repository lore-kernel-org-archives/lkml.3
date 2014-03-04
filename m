Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbaCDAu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 19:50:27 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:35140 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286AbaCDAu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 19:50:26 -0500
Date: Tue, 4 Mar 2014 02:50:01 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ning Qu <quning@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, linux-mm <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/1] mm, shmem: map few pages around fault address if
 they are in page cache
Message-ID: <20140304005001.GA21508@node.dhcp.inet.fi>
References: <1393625931-2858-1-git-send-email-quning@google.com>
 <CACQD4-5U3P+QiuNKzt5+VdDDi0ocphR+Jh81eHqG6_+KeaHyRw@mail.gmail.com>
 <20140228174150.8ff4edca.akpm@linux-foundation.org>
 <CACQD4-7UUDMeXdR-NaAAXvk-NRYqW7mHJkjDUM=JRvL54b_Xsg@mail.gmail.com>
 <CACQD4-5SmUf+krLbef9Yg9HhJ-ipT2QKKq-NW=2C6G=XwXcMcQ@mail.gmail.com>
 <20140303143834.90ebe8ec5c6a369e54a599ec@linux-foundation.org>
 <CA+55aFzvCF-tWg7qx2_Om+Y64uJy6ujEyWgcq87UkzSkfbVGqw@mail.gmail.com>
 <20140303153707.beced5c271179d1b1658a246@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140303153707.beced5c271179d1b1658a246@linux-foundation.org>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 03:37:07PM -0800, Andrew Morton wrote:
> On Mon, 3 Mar 2014 15:29:00 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Mon, Mar 3, 2014 at 2:38 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > When the file is uncached, results are peculiar:
> > >
> > > 0.00user 2.84system 0:50.90elapsed 5%CPU (0avgtext+0avgdata 4198096maxresident)k
> > > 0inputs+0outputs (1major+49666minor)pagefaults 0swaps
> > >
> > > That's approximately 3x more minor faults.
> > 
> > This is not peculiar.
> > 
> > When the file is uncached, some pages will obviously be under IO due
> > to readahead etc. And the fault-around code very much on purpose will
> > *not* try to wait for those pages, so any busy pages will just simply
> > not be faulted-around.
> 
> Of course.
> 
> > So you should still have fewer minor faults than faulting on *every*
> > page (ie the non-fault-around case), but I would very much expect that
> > fault-around will not see the full "one sixteenth" reduction in minor
> > faults.
> > 
> > And the order of IO will not matter, since the read-ahead is
> > asynchronous wrt the page-faults.
> 
> When a pagefault hits a locked, not-uptodate page it is going to block.
> Once it wakes up we'd *like* to find lots of now-uptodate pages in
> that page's vicinity.  Obviously, that is happening, but not to the
> fullest possible extent.  We _could_ still achieve the 16x if readahead
> was cooperating in an ideal fashion.
> 
> I don't know what's going on in there to produce this consistent 3x
> factor.

In my VM numbers are different (fault in 1G):

cold cache: 2097352inputs+0outputs (2major+25048minor)pagefaults 0swaps
hot cache: 0inputs+0outputs (0major+16450minor)pagefaults 0swaps

~1.5x more page faults with cold cache comparing to hot cache.

BTW, moving do_fault_around() below __do_fault() doesn't make much better:

cold cache: 2097200inputs+0outputs (1major+24641minor)pagefaults 0swaps

-- 
 Kirill A. Shutemov
