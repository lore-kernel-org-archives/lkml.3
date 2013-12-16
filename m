Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab3LPIZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 03:25:49 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:60185 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab3LPIZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 03:25:48 -0500
Message-ID: <52AEB8D5.8020705@huawei.com>
Date: Mon, 16 Dec 2013 16:24:53 +0800
From: Rui Xiang <rui.xiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] romfs: remove an redundant if condition in romfs_readpage
References: <1385455149-20752-1-git-send-email-rui.xiang@huawei.com>	<1385455149-20752-2-git-send-email-rui.xiang@huawei.com> <20131216001027.5e1e0a7e.akpm@linux-foundation.org>
In-Reply-To: <20131216001027.5e1e0a7e.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/16 16:10, Andrew Morton wrote:
> On Tue, 26 Nov 2013 16:39:09 +0800 Rui Xiang <rui.xiang@huawei.com> wrote:
> 
>> Here ret always equals 0, so SetPageUptodate directly.
>>
>> ...
>>
>> --- a/fs/romfs/super.c
>> +++ b/fs/romfs/super.c
>> @@ -129,8 +129,7 @@ static int romfs_readpage(struct file *file, struct page *page)
>>  
>>  	if (fillsize < PAGE_SIZE)
>>  		memset(buf + fillsize, 0, PAGE_SIZE - fillsize);
>> -	if (ret == 0)
>> -		SetPageUptodate(page);
>> +	SetPageUptodate(page);
>>  
>>  	flush_dcache_page(page);
>>  	kunmap(page);
> 
> Nope, `ret' can be -EIO:
> 
> 	ret = 0;
> 	if (offset < size) {
> 		size -= offset;
> 		fillsize = size > PAGE_SIZE ? PAGE_SIZE : size;
> 
> 		pos = ROMFS_I(inode)->i_dataoffset + offset;
> 
> 		ret = romfs_dev_read(inode->i_sb, pos, buf, fillsize);
> 		if (ret < 0) {
> 			SetPageError(page);
> 			fillsize = 0;
> -->>			ret = -EIO;
> 		}
> 	}
> 
> 	if (fillsize < PAGE_SIZE)
> 		memset(buf + fillsize, 0, PAGE_SIZE - fillsize);
> 	if (ret == 0)
> 		SetPageUptodate(page);
> 
> 
> It was a bit rude to overwrite the romfs_dev_read() return code though.
> 

Ah, my fault. Ignore that, please.



