Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761715Ab3DBQ03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:26:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:37224 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761692Ab3DBQ00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:26:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,394,1363158000"; 
   d="scan'208";a="279722308"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
In-Reply-To: <1363283435-7666-21-git-send-email-kirill.shutemov@linux.intel.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1363283435-7666-21-git-send-email-kirill.shutemov@linux.intel.com>
Subject: RE: [PATCHv2, RFC 20/30] ramfs: enable transparent huge page cache
Content-Transfer-Encoding: 7bit
Message-Id: <20130402162813.0B4CBE0085@blue.fi.intel.com>
Date: Tue,  2 Apr 2013 19:28:12 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> ramfs is the most simple fs from page cache point of view. Let's start
> transparent huge page cache enabling here.
> 
> For now we allocate only non-movable huge page. It's not yet clear if
> movable page is safe here and what need to be done to make it safe.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  fs/ramfs/inode.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
> index c24f1e1..da30b4f 100644
> --- a/fs/ramfs/inode.c
> +++ b/fs/ramfs/inode.c
> @@ -61,7 +61,11 @@ struct inode *ramfs_get_inode(struct super_block *sb,
>  		inode_init_owner(inode, dir, mode);
>  		inode->i_mapping->a_ops = &ramfs_aops;
>  		inode->i_mapping->backing_dev_info = &ramfs_backing_dev_info;
> -		mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
> +		/*
> +		 * TODO: what should be done to make movable safe?
> +		 */
> +		mapping_set_gfp_mask(inode->i_mapping,
> +				GFP_TRANSHUGE & ~__GFP_MOVABLE);

Hugh, I've found old thread with the reason why we have GFP_HIGHUSER here, not
GFP_HIGHUSER_MOVABLE:

http://lkml.org/lkml/2006/11/27/156

It seems the origin reason is not longer valid, correct?

-- 
 Kirill A. Shutemov
