Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab3D2LF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 07:05:57 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41301 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757589Ab3D2LFz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 07:05:55 -0400
MIME-Version: 1.0
In-Reply-To: <1367203280.16581.3.camel@kjgkr>
References: <1367107458-2439-1-git-send-email-linkinjeon@gmail.com>
	<1367203280.16581.3.camel@kjgkr>
Date: Mon, 29 Apr 2013 20:05:54 +0900
Message-ID: <CAKYAXd85tdou4JX=a0jcWQ+9YrT16GD5tHdZrgX1hCCrdKzm7Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] f2fs: reorganize f2fs_vm_page_mkwrite
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/29, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> Hi,
Hi. Jaegeuk.
>
> 2013-04-28 (일), 09:04 +0900, Namjae Jeon:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> Few things can be changed in the default mkwrite function
>> 1) Make file_update_time at the start before acquiring any lock
>> 2) the condition page_offset(page) >= i_size_read(inode) should be
>>  changed to page_offset(page) > i_size_read
>> 3) Move wait_on_page_writeback.
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
>> ---
>>  fs/f2fs/file.c |   12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
>> index 5cc4dd8..dc76f9b 100644
>> --- a/fs/f2fs/file.c
>> +++ b/fs/f2fs/file.c
>> @@ -63,9 +63,10 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct
>> *vma,
>>  	f2fs_put_dnode(&dn);
>>  	mutex_unlock_op(sbi, ilock);
>>
>> +	file_update_time(vma->vm_file);
>
> Should we update time even if error is occurred below?
Should we update time even if error is occurred below?
Even though the original time change position regarding
file_update_time is correct with respect to the failure conditions,
but we referred the code in other file systems.
We found that file_update_time in page fault is not critical part, so
first thing is to move this out of the locking.
We can see the following comment in block_page_mkwrite.
/*
	 * Update file times before taking page lock. We may end up failing the
	 * fault so this update may be superfluous but who really cares...
	 */
	
Most filesystems use it regardless of below condition. Ext4 also does
this at the beginning of mkwrite-> just after
sb_start_pagefault(inode->i_sb);
>
>>  	lock_page(page);
>>  	if (page->mapping != inode->i_mapping ||
>> -			page_offset(page) >= i_size_read(inode) ||
>> +			page_offset(page) > i_size_read(inode) ||
>
> Why? IMO, there was no problem.
There is no problem and we could not find a test case either, but
looking at the code we thought it could be an alignment issue if due
to index, the page_offset() and i_size_read() ? may cause some
boundary condition.
The above changes were introduced without citing any issues, but just
to align the code.
So we can ignore this changed line :)

Thanks~
>
>>  			!PageUptodate(page)) {
>>  		unlock_page(page);
>>  		err = -EFAULT;
>> @@ -76,10 +77,7 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct
>> *vma,
>>  	 * check to see if the page is mapped already (no holes)
>>  	 */
>>  	if (PageMappedToDisk(page))
>> -		goto out;
>> -
>> -	/* fill the page */
>> -	wait_on_page_writeback(page);
>> +		goto mapped;
>>
>>  	/* page is wholly or partially inside EOF */
>>  	if (((page->index + 1) << PAGE_CACHE_SHIFT) > i_size_read(inode)) {
>> @@ -90,7 +88,9 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct
>> *vma,
>>  	set_page_dirty(page);
>>  	SetPageUptodate(page);
>>
>> -	file_update_time(vma->vm_file);
>> +mapped:
>> +	/* fill the page */
>> +	wait_on_page_writeback(page);
>>  out:
>>  	sb_end_pagefault(inode->i_sb);
>>  	return block_page_mkwrite_return(err);
>
> --
> Jaegeuk Kim
> Samsung
>
