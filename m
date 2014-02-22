Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbaBVCbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 21:31:50 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:57893 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbaBVCbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 21:31:49 -0500
Date: Sat, 22 Feb 2014 04:31:44 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Jay Cornwall <jay@jcornwall.me>
Cc: linux-kernel@vger.kernel.org
Subject: Re: put_page on transparent huge page leaks?
Message-ID: <20140222023144.GB18046@node.dhcp.inet.fi>
References: <ff08f2ccbcd50d2d353392a81defe619@jcornwall.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff08f2ccbcd50d2d353392a81defe619@jcornwall.me>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 11:23:39AM -0600, Jay Cornwall wrote:
> Hi,
> 
> I'm tracking a possible memory leak in iommu/amd. The driver uses this logic
> to fault a page in response to a PRI from a device:
> 
> npages = get_user_pages(fault->state->task, fault->state->mm,
>                         fault->address, 1, write, 0, &page, NULL);
> 
> if (npages == 1)
>         put_page(page);
> else
>         ...
> 
> This works correctly when get_user_pages returns a 4KB page. When
> transparent huge pages are enabled any 2MB page returned by this call
> appears to leak on process exit. The non-cached memory usage stays elevated
> by the set of faulted 2MB pages. This behavior is not observed when the
> exception handler demand faults 2MB pages.
> 
> I notice there is a difference in reference count between the 4KB/2MB paths.
> 
> get_user_pages (4KB): page_count()=3, page_mapcount()=1
> put_page       (4KB): page_count()=2, page_mapcount()=1
> 
> get_user_pages (2MB): page_count()=3, page_mapcount()=1
> put_page       (2MB): page_count()=3, page_mapcount()=0
> 
> I'm concerned that the driver appears to be holding a reference count after
> put_page(). Am I interpreting this observation correctly?

Could you show output of dump_page() on 2M pages for both points?

My guess is that your page is PageTail(). Refcounting for tail pages is
different: on get_page() we increase *->_mapcount* of tail and increase
->_count of relevant head page. ->_count of tail pages should always be
zero, but it's 3 in your case which is odd.

BTW, I don't see where you take mmap_sem in drivers/iommu/amd_iommu_v2.c,
which is required for gup. Do I miss something?

-- 
 Kirill A. Shutemov
