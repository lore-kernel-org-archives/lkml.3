Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3LPIIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 03:08:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab3LPIIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 03:08:52 -0500
Date: Mon, 16 Dec 2013 00:10:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rui Xiang <rui.xiang@huawei.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] romfs: remove an redundant if condition in
 romfs_readpage
Message-Id: <20131216001027.5e1e0a7e.akpm@linux-foundation.org>
In-Reply-To: <1385455149-20752-2-git-send-email-rui.xiang@huawei.com>
References: <1385455149-20752-1-git-send-email-rui.xiang@huawei.com>
	<1385455149-20752-2-git-send-email-rui.xiang@huawei.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Nov 2013 16:39:09 +0800 Rui Xiang <rui.xiang@huawei.com> wrote:

> Here ret always equals 0, so SetPageUptodate directly.
> 
> ...
>
> --- a/fs/romfs/super.c
> +++ b/fs/romfs/super.c
> @@ -129,8 +129,7 @@ static int romfs_readpage(struct file *file, struct page *page)
>  
>  	if (fillsize < PAGE_SIZE)
>  		memset(buf + fillsize, 0, PAGE_SIZE - fillsize);
> -	if (ret == 0)
> -		SetPageUptodate(page);
> +	SetPageUptodate(page);
>  
>  	flush_dcache_page(page);
>  	kunmap(page);

Nope, `ret' can be -EIO:

	ret = 0;
	if (offset < size) {
		size -= offset;
		fillsize = size > PAGE_SIZE ? PAGE_SIZE : size;

		pos = ROMFS_I(inode)->i_dataoffset + offset;

		ret = romfs_dev_read(inode->i_sb, pos, buf, fillsize);
		if (ret < 0) {
			SetPageError(page);
			fillsize = 0;
-->>			ret = -EIO;
		}
	}

	if (fillsize < PAGE_SIZE)
		memset(buf + fillsize, 0, PAGE_SIZE - fillsize);
	if (ret == 0)
		SetPageUptodate(page);


It was a bit rude to overwrite the romfs_dev_read() return code though.
