Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab3KVHpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 02:45:12 -0500
Received: from plane.gmane.org ([80.91.229.3]:57217 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab3KVHpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 02:45:09 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Roman Peniaev <r.peniaev@gmail.com>
Subject: Re: [PATCH 6/7] Squashfs: Directly decompress into the page cache for file data
Date: Fri, 22 Nov 2013 07:40:32 +0000 (UTC)
Message-ID: <loom.20131122T083329-218@post.gmane.org>
References: <1384912091-11092-1-git-send-email-phillip@squashfs.org.uk> <1384912091-11092-6-git-send-email-phillip@squashfs.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 210.94.41.89 (Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/5.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; .NET4.0C; MS-RTC LM 8))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Phillip.

one remark below:

> 
> +static int squashfs_read_cache(struct page *target_page, u64 block, int 
bsize,
> +	int pages, struct page **page)
> +{
> +	struct inode *i = target_page->mapping->host;
> +	struct squashfs_cache_entry *buffer = squashfs_get_datablock(i-
>i_sb,
> +						 block, bsize);
> +	int bytes = buffer->length, res = buffer->error, n, offset = 0;
> +	void *pageaddr;
> +
> +	if (res) {
> +		ERROR("Unable to read page, block %llx, size %x\n", block,
> +			bsize);
> +		goto out;


have you forgotten to unlock the pages on error path?

in case of error squashfs_readpage will unlock only target page.


> +	}
> +
> +	for (n = 0; n < pages && bytes > 0; n++,
> +			bytes -= PAGE_CACHE_SIZE, offset += 
PAGE_CACHE_SIZE) {
> +		int avail = min_t(int, bytes, PAGE_CACHE_SIZE);


