Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbaJHULP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:11:15 -0400
Received: from mta-out1.inet.fi ([62.71.2.234]:43404 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbaJHULN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:11:13 -0400
Date: Wed, 8 Oct 2014 23:11:00 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH v1 5/7] dax: Add huge page fault support
Message-ID: <20141008201100.GB9232@node.dhcp.inet.fi>
References: <1412774729-23956-1-git-send-email-matthew.r.wilcox@intel.com>
 <1412774729-23956-6-git-send-email-matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412774729-23956-6-git-send-email-matthew.r.wilcox@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 09:25:27AM -0400, Matthew Wilcox wrote:
> +
> +	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
> +	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +	if (pgoff >= size)
> +		return VM_FAULT_SIGBUS;
> +	/* If the PMD would cover blocks out of the file */
> +	if ((pgoff | PG_PMD_COLOUR) >= size)
> +		return VM_FAULT_FALLBACK;

IIUC, zero pading would work too.

> +
> +	memset(&bh, 0, sizeof(bh));
> +	block = ((sector_t)pgoff & ~PG_PMD_COLOUR) << (PAGE_SHIFT - blkbits);
> +
> +	/* Start by seeing if we already have an allocated block */
> +	bh.b_size = PMD_SIZE;
> +	length = get_block(inode, block, &bh, 0);

This makes me confused. get_block() return zero on success, right?
Why the var called 'lenght'?

> +	sector = bh.b_blocknr << (blkbits - 9);
> +	length = bdev_direct_access(bh.b_bdev, sector, &kaddr, &pfn, bh.b_size);
> +	if (length < 0)
> +		goto sigbus;
> +	if (length < PMD_SIZE)
> +		goto fallback;
> +	if (pfn & PG_PMD_COLOUR)
> +		goto fallback;	/* not aligned */

So, are you rely on pure luck to make get_block() allocate 2M aligned pfn?
Not really productive. You would need assistance from fs and
arch_get_unmapped_area() sides.

-- 
 Kirill A. Shutemov
