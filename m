Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbaIRXlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 19:41:16 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:42393 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaIRXlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 19:41:14 -0400
Date: Fri, 19 Sep 2014 08:41:07 +0900 (JST)
Message-Id: <20140919.084107.1306407610758412217.konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andreas Rohner <andreas.rohner@gmx.net>
Subject: Re: [PATCH] nilfs2: fix data loss with mmap()
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20140918121708.c9e9678c9ea76b057377d843@linux-foundation.org>
References: <1411052185-8118-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1411052185-8118-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<20140918121708.c9e9678c9ea76b057377d843@linux-foundation.org>
X-Mailer: Mew version 6.5 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2014 12:17:08 -0700, Andrew Morton wrote:
> On Thu, 18 Sep 2014 23:56:25 +0900 Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:
> 
>> From: Andreas Rohner <andreas.rohner@gmx.net>
>> 
>> This bug leads to reproducible silent data loss, despite the use of
>> msync(), sync() and a clean unmount of the file system. It is easily
>> reproducible with the following script:
>> 
>> ...
>>
>> --- a/fs/nilfs2/inode.c
>> +++ b/fs/nilfs2/inode.c
>> @@ -219,10 +219,10 @@ static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
>>  
>>  static int nilfs_set_page_dirty(struct page *page)
>>  {
>> +	struct inode *inode = page->mapping->host;
>>  	int ret = __set_page_dirty_nobuffers(page);
>>  
>>  	if (page_has_buffers(page)) {
>> -		struct inode *inode = page->mapping->host;
>>  		unsigned nr_dirty = 0;
>>  		struct buffer_head *bh, *head;
>>  
>> @@ -245,6 +245,10 @@ static int nilfs_set_page_dirty(struct page *page)
>>  
>>  		if (nr_dirty)
>>  			nilfs_set_file_dirty(inode, nr_dirty);
>> +	} else if (ret) {
>> +		unsigned nr_dirty = 1 << (PAGE_SHIFT - inode->i_blkbits);
> 
> It's quite cosmetic, but it is conventional to use PAGE_CACHE_SHIFT here.

Agreed.

Thanks,
Ryusuke Konishi
