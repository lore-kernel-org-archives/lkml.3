Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbbAMK3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:29:07 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:32782 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbbAMK3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:29:02 -0500
Date: Tue, 13 Jan 2015 10:28:51 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rik van Riel <riel@redhat.com>
Cc: David Lang <david@lang.hm>, Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Mark Langsdorf <mlangsdo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Linux 3.19-rc3
Message-ID: <20150113102850.GA16524@e104818-lin.cambridge.arm.com>
References: <20150108134520.GC14200@e104818-lin.cambridge.arm.com>
 <54AEBE84.6090307@redhat.com>
 <20150108173408.GF17290@e104818-lin.cambridge.arm.com>
 <54AED10C.7090305@redhat.com>
 <CA+55aFwpwkjRnTzBe2K0y+2DOH1F=5SpJkYe=P5z8ps5_1PQHQ@mail.gmail.com>
 <20150109232707.GA6325@e104818-lin.cambridge.arm.com>
 <20150110003540.GA32037@node.dhcp.inet.fi>
 <CA+55aFz74hjhCcdz5J4r-xK4KW7oqNDA3i=jXHW0prGMMwgMvw@mail.gmail.com>
 <alpine.DEB.2.02.1501091849250.3078@nftneq.ynat.uz>
 <54B491F8.1070909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B491F8.1070909@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 03:33:12AM +0000, Rik van Riel wrote:
> On 01/09/2015 09:51 PM, David Lang wrote:
> > On Fri, 9 Jan 2015, Linus Torvalds wrote:
> > 
> >> Big pages are a bad bad bad idea. They work fine for databases,
> >> and that's pretty much just about it. I'm sure there are some
> >> other loads, but they are few and far between.
> > 
> > what about a dedicated virtualization host (where your workload is
> > a handful of virtual machines), would the file cache issue still
> > be overwelming, even though it's the virtual machines accessing
> > things?
> 
> You would still have page cache inside the guest.
> 
> Using large pages in the host, and small pages in the guest
> would not give you the TLB benefits, and that is assuming
> that different page sizes in host and guest even work...

This works on ARM. The TLB caching the full VA->PA translation would
indeed stick to the guest page size as that's the input. But, depending
on the TLB implementation, it may also cache the guest PA -> real PA
translation (a TLB with the guest/Intermediate PA as input; ARMv8 also
introduces TLB invalidation ops that take such IPA as input). A miss in
the stage 1 (guest) TLB would be cheaper if it hits in the stage 2 TLB,
especially when it needs to look up the stage 2 for each level in the
stage 1 table.

But when it doesn't hit in any of the stages, it's still beneficial to
have smaller number of levels at stage 2 (host) and that's what 64KB
pages bring on ARM. If you use the maximum 4 levels in both host and
guest, a TLB miss in the guest requires 24 memory accesses to populate
it (each guest page table level entry needs a stage 2 look-up). In
practice, you may get some locality but I think the guest page table
access pattern can get quite sparse. In addition, stage 2 entries are
not as volatile as they are per VM rather than per process as the stage
1 entries.

> Using large pages in the guests gets you back to the wasted
> memory, except you are now wasting memory in a situation where
> you have less memory available in each guest. Density is a real
> consideration for virtualization.

I agree. I think guests should stick to 4KB pages (well, unless all they
need to do is mmap large database files).

-- 
Catalin
