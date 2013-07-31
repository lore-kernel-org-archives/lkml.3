Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718Ab3GaCCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 22:02:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:4427 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab3GaCCx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 22:02:53 -0400
X-IronPort-AV: E=Sophos;i="4.89,783,1367942400"; 
   d="scan'208";a="8072448"
Message-ID: <51F86F67.1070605@cn.fujitsu.com>
Date: Wed, 31 Jul 2013 09:59:03 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: jaegeuk.kim@samsung.com
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] f2fs: add a wait step when submit bio with {READ,WRITE}_SYNC
References: <51F7901E.3010204@cn.fujitsu.com> <1375187398.26443.69.camel@kjgkr>
In-Reply-To: <1375187398.26443.69.camel@kjgkr>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/31 10:00:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/31 10:00:39
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

On 07/30/2013 08:29 PM, Jaegeuk Kim wrote:

> Hi Gu,
> 
> The original read flow was to avoid redandunt lock/unlock_page() calls.

Right, this can gain better read performance. But is the wait step after 
submitting bio with READ_SYNC needless too?

> And we should not wait for WRITE_SYNC, since it is just for write
> priority, not for synchronization of the file system.

Got it, thanks for your explanation.:) 

Best regards,
Gu

> Thanks,
> 
> 2013-07-30 (화), 18:06 +0800, Gu Zheng:
>> When we submit bio with READ_SYNC or WRITE_SYNC, we need to wait a
>> moment for the io completion, current codes only find_data_page() follows the
>> rule, other places missing this step, so add it.
>>
>> Further more, moving the PageUptodate check into f2fs_readpage() to clean up
>> the codes.
>>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> ---
>>  fs/f2fs/checkpoint.c |    1 -
>>  fs/f2fs/data.c       |   39 +++++++++++++++++----------------------
>>  fs/f2fs/node.c       |    1 -
>>  fs/f2fs/recovery.c   |    2 --
>>  fs/f2fs/segment.c    |    2 +-
>>  5 files changed, 18 insertions(+), 27 deletions(-)
>>
>> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
>> index fe91773..e376a42 100644
>> --- a/fs/f2fs/checkpoint.c
>> +++ b/fs/f2fs/checkpoint.c
>> @@ -64,7 +64,6 @@ repeat:
>>  	if (f2fs_readpage(sbi, page, index, READ_SYNC))
>>  		goto repeat;
>>  
>> -	lock_page(page);
>>  	if (page->mapping != mapping) {
>>  		f2fs_put_page(page, 1);
>>  		goto repeat;
>> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
>> index 19cd7c6..b048936 100644
>> --- a/fs/f2fs/data.c
>> +++ b/fs/f2fs/data.c
>> @@ -216,13 +216,11 @@ struct page *find_data_page(struct inode *inode, pgoff_t index, bool sync)
>>  
>>  	err = f2fs_readpage(sbi, page, dn.data_blkaddr,
>>  					sync ? READ_SYNC : READA);
>> -	if (sync) {
>> -		wait_on_page_locked(page);
>> -		if (!PageUptodate(page)) {
>> -			f2fs_put_page(page, 0);
>> -			return ERR_PTR(-EIO);
>> -		}
>> -	}
>> +	if (err)
>> +		return ERR_PTR(err);
>> +
>> +	if (sync)
>> +		unlock_page(page);
>>  	return page;
>>  }
>>  
>> @@ -267,11 +265,6 @@ repeat:
>>  	if (err)
>>  		return ERR_PTR(err);
>>  
>> -	lock_page(page);
>> -	if (!PageUptodate(page)) {
>> -		f2fs_put_page(page, 1);
>> -		return ERR_PTR(-EIO);
>> -	}
>>  	if (page->mapping != mapping) {
>>  		f2fs_put_page(page, 1);
>>  		goto repeat;
>> @@ -325,11 +318,7 @@ repeat:
>>  		err = f2fs_readpage(sbi, page, dn.data_blkaddr, READ_SYNC);
>>  		if (err)
>>  			return ERR_PTR(err);
>> -		lock_page(page);
>> -		if (!PageUptodate(page)) {
>> -			f2fs_put_page(page, 1);
>> -			return ERR_PTR(-EIO);
>> -		}
>> +
>>  		if (page->mapping != mapping) {
>>  			f2fs_put_page(page, 1);
>>  			goto repeat;
>> @@ -399,6 +388,16 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
>>  
>>  	submit_bio(type, bio);
>>  	up_read(&sbi->bio_sem);
>> +
>> +	if (type == READ_SYNC) {
>> +		wait_on_page_locked(page);
>> +		lock_page(page);
>> +		if (!PageUptodate(page)) {
>> +			f2fs_put_page(page, 1);
>> +			return -EIO;
>> +		}
>> +	}
>> +
>>  	return 0;
>>  }
>>  
>> @@ -679,11 +678,7 @@ repeat:
>>  		err = f2fs_readpage(sbi, page, dn.data_blkaddr, READ_SYNC);
>>  		if (err)
>>  			return err;
>> -		lock_page(page);
>> -		if (!PageUptodate(page)) {
>> -			f2fs_put_page(page, 1);
>> -			return -EIO;
>> -		}
>> +
>>  		if (page->mapping != mapping) {
>>  			f2fs_put_page(page, 1);
>>  			goto repeat;
>> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
>> index f5172e2..f061554 100644
>> --- a/fs/f2fs/node.c
>> +++ b/fs/f2fs/node.c
>> @@ -1534,7 +1534,6 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
>>  		if (f2fs_readpage(sbi, page, addr, READ_SYNC))
>>  			goto out;
>>  
>> -		lock_page(page);
>>  		rn = F2FS_NODE(page);
>>  		sum_entry->nid = rn->footer.nid;
>>  		sum_entry->version = 0;
>> diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
>> index 639eb34..ec68183 100644
>> --- a/fs/f2fs/recovery.c
>> +++ b/fs/f2fs/recovery.c
>> @@ -140,8 +140,6 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
>>  		if (err)
>>  			goto out;
>>  
>> -		lock_page(page);
>> -
>>  		if (cp_ver != cpver_of_node(page))
>>  			break;
>>  
>> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
>> index 9b74ae2..bcd19db 100644
>> --- a/fs/f2fs/segment.c
>> +++ b/fs/f2fs/segment.c
>> @@ -639,7 +639,7 @@ static void do_submit_bio(struct f2fs_sb_info *sbi,
>>  
>>  		trace_f2fs_do_submit_bio(sbi->sb, btype, sync, sbi->bio[btype]);
>>  
>> -		if (type == META_FLUSH) {
>> +		if ((type == META_FLUSH) || (rw & WRITE_SYNC)) {
>>  			DECLARE_COMPLETION_ONSTACK(wait);
>>  			p->is_sync = true;
>>  			p->wait = &wait;
> 


