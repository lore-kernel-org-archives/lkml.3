Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab3EUWns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:43:48 -0400
Received: from www.sr71.net ([198.145.64.142]:45972 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab3EUWnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:43:46 -0400
Message-ID: <519BF8A0.5000103@sr71.net>
Date: Tue, 21 May 2013 15:43:44 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 26/39] ramfs: enable transparent huge page cache
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com> <1368321816-17719-27-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1368321816-17719-27-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2013 06:23 PM, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> ramfs is the most simple fs from page cache point of view. Let's start
> transparent huge page cache enabling here.
> 
> For now we allocate only non-movable huge page. ramfs pages cannot be
> moved yet.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  fs/ramfs/inode.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
> index c24f1e1..54d69c7 100644
> --- a/fs/ramfs/inode.c
> +++ b/fs/ramfs/inode.c
> @@ -61,7 +61,11 @@ struct inode *ramfs_get_inode(struct super_block *sb,
>  		inode_init_owner(inode, dir, mode);
>  		inode->i_mapping->a_ops = &ramfs_aops;
>  		inode->i_mapping->backing_dev_info = &ramfs_backing_dev_info;
> -		mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
> +		/*
> +		 * TODO: make ramfs pages movable
> +		 */
> +		mapping_set_gfp_mask(inode->i_mapping,
> +				GFP_TRANSHUGE & ~__GFP_MOVABLE);

So, before these patches, ramfs was movable.  Now, even on architectures
or configurations that have no chance of using THP-pagecache, ramfs
pages are no longer movable.  Right?

That seems unfortunate, and probably not something we want to
intentionally merge in this state.

Worst-case, we should at least make sure the pages remain movable in
configurations where THP-pagecache is unavailable.
