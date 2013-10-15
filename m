Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782Ab3JOLJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 07:09:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:2392 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757990Ab3JOLJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 07:09:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,498,1378882800"; 
   d="scan'208";a="374924854"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Ning Qu <quning@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Hugh Dickins <hughd@google.com>, Wu Fengguang <fengguang.wu@intel.com>,
        Jan Kara <jack@suse.cz>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ning Qu <quning@google.com>
In-Reply-To: <20131015001826.GL3432@hippobay.mtv.corp.google.com>
References: <20131015001826.GL3432@hippobay.mtv.corp.google.com>
Subject: RE: [PATCH 11/12] mm, thp, tmpfs: enable thp page cache in tmpfs
Content-Transfer-Encoding: 7bit
Message-Id: <20131015110905.085B1E0090@blue.fi.intel.com>
Date: Tue, 15 Oct 2013 14:09:04 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ning Qu wrote:
> Signed-off-by: Ning Qu <quning@gmail.com>
> ---
>  mm/Kconfig | 4 ++--
>  mm/shmem.c | 5 +++++
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 562f12f..4d2f90f 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -428,8 +428,8 @@ config TRANSPARENT_HUGEPAGE_PAGECACHE
>  	help
>  	  Enabling the option adds support hugepages for file-backed
>  	  mappings. It requires transparent hugepage support from
> -	  filesystem side. For now, the only filesystem which supports
> -	  hugepages is ramfs.
> +	  filesystem side. For now, the filesystems which support
> +	  hugepages are: ramfs and tmpfs.
>  
>  config CROSS_MEMORY_ATTACH
>  	bool "Cross Memory Support"
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 75c0ac6..50a3335 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1672,6 +1672,11 @@ static struct inode *shmem_get_inode(struct super_block *sb, const struct inode
>  			break;
>  		case S_IFREG:
>  			inode->i_mapping->a_ops = &shmem_aops;
> +			/*
> +			 * TODO: make tmpfs pages movable
> +			 */
> +			mapping_set_gfp_mask(inode->i_mapping,
> +					     GFP_TRANSHUGE & ~__GFP_MOVABLE);

Unlike ramfs, tmpfs pages are movable before transparent page cache
patchset.
Making tmpfs pages non-movable looks like a big regression to me. It need
to be fixed before proposing it upstream.

-- 
 Kirill A. Shutemov
