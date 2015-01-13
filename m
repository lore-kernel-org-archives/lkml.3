Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbbAMVj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:39:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:55539 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbbAMVj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:39:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,751,1413270000"; 
   d="scan'208";a="650629044"
Date: Tue, 13 Jan 2015 16:39:03 -0500
From: Matthew Wilcox <willy@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        willy@linux.intel.com
Subject: Re: [PATCH v12 07/20] dax,ext2: Replace ext2_clear_xip_target with
 dax_clear_blocks
Message-ID: <20150113213903.GJ5661@wil.cx>
References: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
 <1414185652-28663-8-git-send-email-matthew.r.wilcox@intel.com>
 <20150112150947.eb6ccb5c45edb4e83cd48b28@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112150947.eb6ccb5c45edb4e83cd48b28@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 03:09:47PM -0800, Andrew Morton wrote:
> > +int dax_clear_blocks(struct inode *inode, sector_t block, long size)
> > +{
...
> > +			if (pgsz < PAGE_SIZE)
> > +				memset(addr, 0, pgsz);
> > +			else
> > +				clear_page(addr);
> 
> Are there any cache issues in all this code? flush_dcache_page(addr)?

Here, no.  This is only called to initialise a newly allocated block.

Elsewhere, maybe.  When i was originally working on this, I think I had
code that forced mmaps of DAX files to be aligned to SHMLBA, because I
remember noticing a bug in sparc64's remap_file_range().  Unfortunately,
in the various rewrites, that got lost.  So it needs to be put back in.

flush_dcache_page() in particular won't work because it needs a struct
page.

