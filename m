Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab3JWKQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 06:16:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32310 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab3JWKQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 06:16:51 -0400
X-IronPort-AV: E=Sophos;i="4.93,553,1378828800"; 
   d="scan'208";a="8838789"
Message-ID: <5267A0B7.7000202@cn.fujitsu.com>
Date: Wed, 23 Oct 2013 18:11:03 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: jaegeuk.kim@samsung.com
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] f2fs: delete and free dirty dir freeing inode entry when
 sync dirty dir inodes
References: <5264D574.6000105@cn.fujitsu.com> <1382440544.992.64.camel@kjgkr>
In-Reply-To: <1382440544.992.64.camel@kjgkr>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/23 18:14:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/23 18:14:18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,
On 10/22/2013 07:15 PM, Jaegeuk Kim wrote:

> 2013-10-21 (월), 15:19 +0800, Gu Zheng:
>> In sync_dirty_dir_inodes(), remove_dirty_dir_inode() will be called
>> in the callback of filemap_flush to delete and free dirty dir inode entry.
>> But for the freeing inode entry, missed this step after sbumit data bio,
>> and this may lead to a dead loop if these is freeing inode entry in
>> dir_inode_list. So add the delete and free step to fix it.
> 
> Hi Gu,
> 
> This dirty inode will be removed by f2fs_evict_inode() after submitting
> any pending bio, f2fs_submit_bio().

Yeah, got it, thanks for your direction, please ignore this patch.

Regards,
Gu

> Thanks,
> 
>>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> ---
>>  fs/f2fs/checkpoint.c |    9 +++++++++
>>  1 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
>> index 8d16071..f61838f 100644
>> --- a/fs/f2fs/checkpoint.c
>> +++ b/fs/f2fs/checkpoint.c
>> @@ -600,7 +600,16 @@ retry:
>>  		 * wribacking dentry pages in the freeing inode.
>>  		 */
>>  		f2fs_submit_bio(sbi, DATA, true);
>> +
>> +		spin_lock(&sbi->dir_inode_lock);
>> +		list_del(&entry->list);
>> +#ifdef CONFIG_F2FS_STAT_FS
>> +		sbi->n_dirty_dirs--;
>> +#endif
>> +		spin_unlock(&sbi->dir_inode_lock);
>> +		kmem_cache_free(inode_entry_slab, entry);
>>  	}
>> +
>>  	goto retry;
>>  }
>>  
> 


