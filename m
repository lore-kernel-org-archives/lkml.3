Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab3HUPq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:46:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab3HUPqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:46:55 -0400
Subject: Re: [PATCH] mm, fs: avoid page allocation beyond i_size on read
From: Steven Whitehouse <swhiteho@redhat.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>, NeilBrown <neilb@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1377099441-2224-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1377099441-2224-1-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 21 Aug 2013 16:46:52 +0100
Message-ID: <1377100012.2738.28.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2013-08-21 at 18:37 +0300, Kirill A. Shutemov wrote:
> I've noticed that we allocated unneeded page for cache on read beyond
> i_size. Simple test case (I checked it on ramfs):
> 
> $ touch testfile
> $ cat testfile
> 
> It triggers 'no_cached_page' code path in do_generic_file_read().
> 
> Looks like it's regression since commit a32ea1e. Let's fix it.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Acked-by: NeilBrown <neilb@suse.de>
> ---
>  mm/filemap.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 1905f0e..b1a4d35 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1163,6 +1163,10 @@ static void do_generic_file_read(struct file *filp, loff_t *ppos,
>  		loff_t isize;
>  		unsigned long nr, ret;
>  
> +		isize = i_size_read(inode);
> +		if (!isize || index > (isize - 1) >> PAGE_CACHE_SHIFT)
> +			goto out;
> +
>  		cond_resched();
>  find_page:
>  		page = find_get_page(mapping, index);

Please don't do that... there is no reason to think that i_size will be
correct at that moment. Why not just get readpage(s) to return the
correct return code in that case?

Steve.


