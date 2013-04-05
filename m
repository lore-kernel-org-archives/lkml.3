Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161777Ab3DENwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 09:52:25 -0400
Received: from a9-54.smtp-out.amazonses.com ([54.240.9.54]:58236 "EHLO
	a9-54.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161553Ab3DENwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 09:52:24 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Apr 2013 09:52:24 EDT
Date: Fri, 5 Apr 2013 13:46:23 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Minchan Kim <minchan@kernel.org>
cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Ying Han <yinghan@google.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2, RFC 20/30] ramfs: enable transparent huge page cache
In-Reply-To: <20130405083112.GD32126@blaptop>
Message-ID: <0000013dda72b161-378f03f8-2ed6-4a03-81e5-104df52a67f1-000000@email.amazonses.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com> <1363283435-7666-21-git-send-email-kirill.shutemov@linux.intel.com> <20130402162813.0B4CBE0085@blue.fi.intel.com> <alpine.LNX.2.00.1304021422460.19363@eggly.anvils>
 <20130403011104.GF16026@blaptop> <515E737D.8030204@gmail.com> <20130405080106.GB32126@blaptop> <515e89d2.e725320a.3a74.7fe7SMTPIN_ADDED_BROKEN@mx.google.com> <20130405083112.GD32126@blaptop>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.05-54.240.9.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Apr 2013, Minchan Kim wrote:

> > >> How about add a knob?
> > >
> > >Maybe, volunteering?
> >
> > Hi Minchan,
> >
> > I can be the volunteer, what I care is if add a knob make sense?
>
> Frankly sepaking, I'd like to avoid new knob but there might be
> some workloads suffered from mlocked page migration so we coudn't
> dismiss it. In such case, introducing the knob would be a solution
> with default enabling. If we don't have any report for a long time,
> we can remove the knob someday, IMHO.

No Knob please. A new implementation for page pinning that avoids the
mlock crap.

1. It should be available for device drivers to pin their memory (they are
now elevating the ref counter which means page migration will have to see
if it can account for all references before giving up and it does that
quite frequently). So there needs to be an in kernel API, a syscall API as
well as a command line one. Preferably as similar as possible.

2. A sane API for marking pages as mlocked. Maybe part of MMAP? I hate the
command line tools and the APIs for doing that right now.

3. The reservation scheme for mlock via ulimit is broken. We have per
process constraints only it seems. If you start enough processes you can
still make the kernel go OOM.

4. mlock semantics are prescribed by posix which states that the page
stays in memory. I think we should stay with that narrow definition for
mlock.

5. Pinning could also mean that page faults on the page are to be avoided.
COW could occur on fork and page table entries could be instantated at
mmap/fork time. Pinning could mean that minor/major faults will not occur
on a page.

