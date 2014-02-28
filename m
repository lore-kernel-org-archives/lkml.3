Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaB1ALA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 19:11:00 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:50118 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbaB1AK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 19:10:59 -0500
Date: Fri, 28 Feb 2014 02:10:39 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, Ning Qu <quning@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 0/2] mm: map few pages around fault address if they are
 in page cache
Message-ID: <20140228001039.GB8034@node.dhcp.inet.fi>
References: <1393530827-25450-1-git-send-email-kirill.shutemov@linux.intel.com>
 <CA+55aFwOe_m3cfQDGxmcBavhyQTqQQNGvACR4YPLaazM_0oyUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwOe_m3cfQDGxmcBavhyQTqQQNGvACR4YPLaazM_0oyUw@mail.gmail.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 01:28:22PM -0800, Linus Torvalds wrote:
> On Thu, Feb 27, 2014 at 11:53 AM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> > Here's new version of faultaround patchset. It took a while to tune it and
> > collect performance data.
> 
> Andrew, mind taking this into -mm with my acks? It's based on top of
> Kirill's cleanup patches that I think are also in your tree.
> 
> Kirill - no complaints from me. I do have two minor issues that you
> might satisfy, but I think the patch is fine as-is.
> 
> The issues/questions are:
> 
>  (a) could you test this on a couple of different architectures? Even
> if you just have access to intel machines, testing it across a couple
> of generations of microarchitectures would be good. The reason I say
> that is that from my profiles, it *looks* like the page fault costs
> are relatively higher on Ivybridge/Haswell than on some earlier
> uarchs.

These numbers were from Ivy Bridge.
I'll bring some numbers for Westmere and Haswell.

>  (b) I suspect we should try to strongly discourage filesystems from
> actually using map_pages unless they use the standard
> filemap_map_pages function as-is. Even with the fairly clean
> interface, and forcing people to use "do_set_pte()", I think the docs
> might want to try to more explicitly discourage people from using this
> to do their own hacks..

We would need ->map_pages() at least for shmem/tmpfs. It should be
benefitial there.

Also Matthew noticed that some drivers do ugly hacks like fault in whole
VMA on first page fault. IIUC, it's for performance reasons. See
psbfb_vm_fault() or ttm_bo_vm_fault().

I thought it could be reasonable to have ->map_pages() there and do VMA
population get_user_pages() on mmap() instead.

What do you think?

-- 
 Kirill A. Shutemov
