Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaB1DxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 22:53:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:48193 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbaB1Dw4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 22:52:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,559,1389772800"; 
   d="scan'208";a="463866145"
From: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Dave Chinner" <david@fromorbit.com>, Ning Qu <quning@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv3 0/2] mm: map few pages around fault address if they
 are in page cache
Thread-Topic: [PATCHv3 0/2] mm: map few pages around fault address if they
 are in page cache
Thread-Index: AQHPM/W2E09Mb2zMm0ekGRHcThO965rKI98AgAAtV4D//7afbA==
Date: Fri, 28 Feb 2014 03:52:54 +0000
Message-ID: <100D68C7BA14664A8938383216E40DE04062F3E9@FMSMSX114.amr.corp.intel.com>
References: <1393530827-25450-1-git-send-email-kirill.shutemov@linux.intel.com>
 <CA+55aFwOe_m3cfQDGxmcBavhyQTqQQNGvACR4YPLaazM_0oyUw@mail.gmail.com>,<20140228001039.GB8034@node.dhcp.inet.fi>
In-Reply-To: <20140228001039.GB8034@node.dhcp.inet.fi>
Accept-Language: en-CA, en-US
Content-Language: en-CA
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.19.9.46]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think the psbfb case is just horribly broken; they probably want to populate the entire VMA at mmap time rather than fault time.  It'll be less code for them.

ttm is more nuanced, and there're one or two other graphics drivers that have similar requirements of "faulting around".  But all of the ones that try it have the nasty feature of potentially faulting in some pages that weren't the one that actually faulted on, and then failing before faulting in the requested one, then returning to userspace.

Granted, this is a pretty rare case.  You'd have to be incredibly low on memory to fail to allocate a page table page.  But it can happen, and shouldn't.

So I was thinking about a helper that these drivers could use to "fault around" in ->fault, then Kirill let me in on ->map_pages, and I think this way could work too.

________________________________________
From: Kirill A. Shutemov [kirill@shutemov.name]
Sent: February 27, 2014 4:10 PM
To: Linus Torvalds
Cc: Kirill A. Shutemov; Andrew Morton; Mel Gorman; Rik van Riel; Andi Kleen; Wilcox, Matthew R; Dave Hansen; Alexander Viro; Dave Chinner; Ning Qu; linux-mm; linux-fsdevel; Linux Kernel Mailing List
Subject: Re: [PATCHv3 0/2] mm: map few pages around fault address if they are in page cache

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
