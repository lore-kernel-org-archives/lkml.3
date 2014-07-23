Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678AbaGWO15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:27:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:21905 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbaGWO14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:27:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,717,1400050800"; 
   d="scan'208";a="566062986"
Date: Wed, 23 Jul 2014 10:27:45 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 05/22] Add vm_replace_mixed()
Message-ID: <20140723142745.GD6754@linux.intel.com>
References: <cover.1406058387.git.matthew.r.wilcox@intel.com>
 <b1052af08b49965fd0e6b87b6733b89294c8cc1e.1406058387.git.matthew.r.wilcox@intel.com>
 <20140723114540.GD10317@node.dhcp.inet.fi>
 <20140723135221.GA6754@linux.intel.com>
 <20140723142048.GA11963@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723142048.GA11963@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 05:20:48PM +0300, Kirill A. Shutemov wrote:
> On Wed, Jul 23, 2014 at 09:52:22AM -0400, Matthew Wilcox wrote:
> > I'd love to use a lighter-weight weapon!  What would you recommend using,
> > zap_pte_range()?
> 
> The most straight-forward way: extract body of pte cycle from
> zap_pte_range() to separate function -- zap_pte() -- and use it.

OK, I can do that.  What about the other parts of zap_page_range(),
do I need to call them?

        lru_add_drain();
        tlb_gather_mmu(&tlb, mm, address, end);
        update_hiwater_rss(mm);
        mmu_notifier_invalidate_range_start(mm, address, end);
[       unmap_single_vma(&tlb, vma, address, end, details);]
        mmu_notifier_invalidate_range_end(mm, address, end);
        tlb_finish_mmu(&tlb, address, end);

> > 	if ((fd = open(argv[1], O_CREAT|O_RDWR, 0666)) < 0) {
> > 		perror(argv[1]);
> > 		exit(1);
> > 	}
> > 
> > 	if (ftruncate(fd, 4096) < 0) {
> 
> Shouldn't this be ftruncate(fd, 0)? Otherwise the memcpy() below will
> fault in page from backing storage, not hole and write will not replace
> anything.

Ah, it was starting with a new file, hence the O_CREAT up above.

