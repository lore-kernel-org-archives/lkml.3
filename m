Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaEUUoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 16:44:20 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:16353 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaEUUoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 16:44:17 -0400
Message-ID: <1400704507.18128.23.camel@misato.fc.hp.com>
Subject: Re: [PATCH v7 07/22] Replace the XIP page fault handler with the
 DAX page fault handler
From: Toshi Kani <toshi.kani@hp.com>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, willy@linux.intel.com
Date: Wed, 21 May 2014 14:35:07 -0600
In-Reply-To: <c2e602f401a580c4fac54b9b8f4a6f8dd0ac1071.1395591795.git.matthew.r.wilcox@intel.com>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
	 <c2e602f401a580c4fac54b9b8f4a6f8dd0ac1071.1395591795.git.matthew.r.wilcox@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-03-23 at 15:08 -0400, Matthew Wilcox wrote:
 :
> +static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
> +			get_block_t get_block)
> +{
 :
> +	error = dax_get_pfn(inode, &bh, &pfn);
> +	if (error > 0)
> +		error = vm_insert_mixed(vma, vaddr, pfn);
> +	mutex_unlock(&mapping->i_mmap_mutex);
> +
> +	if (page) {
> +		delete_from_page_cache(page);
> +		unmap_mapping_range(mapping, vmf->pgoff << PAGE_SHIFT,
> +							PAGE_CACHE_SIZE, 0);
> +		unlock_page(page);
> +		page_cache_release(page);

Hi Matthew,

I am seeing a problem in this code path, where it deletes a page cache
page mapped to a hole. Sometimes, page->_mapcount is 0, not -1, which
leads __delete_from_page_cache(), called from delete_from_page_cache(),
to hit the following BUG_ON.

  BUG_ON(page_mapped(page))

I suppose such page has a shared mapping. Does this code need to take
care of replacing shared mappings in such case?

Thanks,
-Toshi



