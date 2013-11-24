Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab3KXBTP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 20:19:15 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:48742 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab3KXBTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 20:19:14 -0500
Message-ID: <5291540D.10001@gmail.com>
Date: Sun, 24 Nov 2013 01:19:09 +0000
From: Phillip Lougher <phillip.lougher@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Roman Peniaev <r.peniaev@gmail.com>
Subject: Re: [PATCH 6/7] Squashfs: Directly decompress into the page cache
 for file data
References: <1384912091-11092-1-git-send-email-phillip@squashfs.org.uk> <1384912091-11092-6-git-send-email-phillip@squashfs.org.uk> <loom.20131122T083329-218@post.gmane.org>
In-Reply-To: <loom.20131122T083329-218@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/11/13 07:40, Roman Peniaev wrote:
> Hello, Phillip.
>
> one remark below:
>
>>
>> +static int squashfs_read_cache(struct page *target_page, u64 block, int
> bsize,
>> +	int pages, struct page **page)
>> +{
>> +	struct inode *i = target_page->mapping->host;
>> +	struct squashfs_cache_entry *buffer = squashfs_get_datablock(i-
>> i_sb,
>> +						 block, bsize);
>> +	int bytes = buffer->length, res = buffer->error, n, offset = 0;
>> +	void *pageaddr;
>> +
>> +	if (res) {
>> +		ERROR("Unable to read page, block %llx, size %x\n", block,
>> +			bsize);
>> +		goto out;
>
>
> have you forgotten to unlock the pages on error path?
>
> in case of error squashfs_readpage will unlock only target page.

Yup, a fix for -rc1 is on its way.

This error path failed to trigger in my stress tests because it is
pretty hard to hit, because it relies on decompress failure at the
same time as we've raced against another process also grabbing
the pages.

Phillip


>
>
>> +	}
>> +
>> +	for (n = 0; n < pages && bytes > 0; n++,
>> +			bytes -= PAGE_CACHE_SIZE, offset +=
> PAGE_CACHE_SIZE) {
>> +		int avail = min_t(int, bytes, PAGE_CACHE_SIZE);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

