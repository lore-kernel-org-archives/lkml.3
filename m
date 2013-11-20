Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab3KTJyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 04:54:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:40178 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab3KTJyh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 04:54:37 -0500
X-IronPort-AV: E=Sophos;i="4.93,735,1378828800"; 
   d="scan'208";a="9084664"
Message-ID: <528C8559.6040909@cn.fujitsu.com>
Date: Wed, 20 Nov 2013 17:48:09 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: jaegeuk.kim@samsung.com
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] f2fs: move the list_head initialization into the
 lock protection region
References: <528B3783.2040905@cn.fujitsu.com> <1384911101.26319.37.camel@kjgkr>
In-Reply-To: <1384911101.26319.37.camel@kjgkr>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/20 17:52:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/20 17:52:40
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,
On 11/20/2013 09:31 AM, Jaegeuk Kim wrote:

> Hi Gu,
> 
> IMO, there is no reason to cover the list header by the lock.
> In any flows, sbi should have the header all the time.

Yes, you're right.

> What is your opinion?

Moving the list_head initialization into the lock protection region, so
that we can ignore the list change during the gap(initialization<-->use).
And on the other side, it can keep the code style uniform for better
maintenance.

Regards,
Gu

> 
> Thanks,
> 
> 2013-11-19 (화), 18:03 +0800, Gu Zheng:
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> ---
>>  fs/f2fs/checkpoint.c |   15 ++++++++++-----
>>  1 files changed, 10 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
>> index f884589..1de70cc 100644
>> --- a/fs/f2fs/checkpoint.c
>> +++ b/fs/f2fs/checkpoint.c
>> @@ -511,8 +511,8 @@ void add_dirty_dir_inode(struct inode *inode)
>>  void remove_dirty_dir_inode(struct inode *inode)
>>  {
>>  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
>> -	struct list_head *head = &sbi->dir_inode_list;
>> -	struct list_head *this;
>> +
>> +	struct list_head *this, *head;
>>  
>>  	if (!S_ISDIR(inode->i_mode))
>>  		return;
>> @@ -523,6 +523,7 @@ void remove_dirty_dir_inode(struct inode *inode)
>>  		return;
>>  	}
>>  
>> +	head = &sbi->dir_inode_list;
>>  	list_for_each(this, head) {
>>  		struct dir_inode_entry *entry;
>>  		entry = list_entry(this, struct dir_inode_entry, list);
>> @@ -544,11 +545,13 @@ void remove_dirty_dir_inode(struct inode *inode)
>>  
>>  struct inode *check_dirty_dir_inode(struct f2fs_sb_info *sbi, nid_t ino)
>>  {
>> -	struct list_head *head = &sbi->dir_inode_list;
>> -	struct list_head *this;
>> +
>> +	struct list_head *this, *head;
>>  	struct inode *inode = NULL;
>>  
>>  	spin_lock(&sbi->dir_inode_lock);
>> +
>> +	head = &sbi->dir_inode_list;
>>  	list_for_each(this, head) {
>>  		struct dir_inode_entry *entry;
>>  		entry = list_entry(this, struct dir_inode_entry, list);
>> @@ -563,11 +566,13 @@ struct inode *check_dirty_dir_inode(struct f2fs_sb_info *sbi, nid_t ino)
>>  
>>  void sync_dirty_dir_inodes(struct f2fs_sb_info *sbi)
>>  {
>> -	struct list_head *head = &sbi->dir_inode_list;
>> +	struct list_head *head;
>>  	struct dir_inode_entry *entry;
>>  	struct inode *inode;
>>  retry:
>>  	spin_lock(&sbi->dir_inode_lock);
>> +
>> +	head = &sbi->dir_inode_list;
>>  	if (list_empty(head)) {
>>  		spin_unlock(&sbi->dir_inode_lock);
>>  		return;
> 


