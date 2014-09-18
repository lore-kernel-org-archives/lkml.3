Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbaIRTRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 15:17:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaIRTRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 15:17:09 -0400
Date: Thu, 18 Sep 2014 12:17:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Rohner <andreas.rohner@gmx.net>
Subject: Re: [PATCH] nilfs2: fix data loss with mmap()
Message-Id: <20140918121708.c9e9678c9ea76b057377d843@linux-foundation.org>
In-Reply-To: <1411052185-8118-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1411052185-8118-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1411052185-8118-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2014 23:56:25 +0900 Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> From: Andreas Rohner <andreas.rohner@gmx.net>
> 
> This bug leads to reproducible silent data loss, despite the use of
> msync(), sync() and a clean unmount of the file system. It is easily
> reproducible with the following script:
> 
> ...
>
> --- a/fs/nilfs2/inode.c
> +++ b/fs/nilfs2/inode.c
> @@ -219,10 +219,10 @@ static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
>  
>  static int nilfs_set_page_dirty(struct page *page)
>  {
> +	struct inode *inode = page->mapping->host;
>  	int ret = __set_page_dirty_nobuffers(page);
>  
>  	if (page_has_buffers(page)) {
> -		struct inode *inode = page->mapping->host;
>  		unsigned nr_dirty = 0;
>  		struct buffer_head *bh, *head;
>  
> @@ -245,6 +245,10 @@ static int nilfs_set_page_dirty(struct page *page)
>  
>  		if (nr_dirty)
>  			nilfs_set_file_dirty(inode, nr_dirty);
> +	} else if (ret) {
> +		unsigned nr_dirty = 1 << (PAGE_SHIFT - inode->i_blkbits);

It's quite cosmetic, but it is conventional to use PAGE_CACHE_SHIFT here.
