Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbaAMJo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 04:44:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:35618 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbaAMJox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:44:53 -0500
X-IronPort-AV: E=Sophos;i="4.95,651,1384272000"; 
   d="scan'208";a="9409890"
Message-ID: <52D3B397.1010908@cn.fujitsu.com>
Date: Mon, 13 Jan 2014 17:36:23 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Chao Yu <chao2.yu@samsung.com>
CC: "'Kim'" <jaegeuk.kim@samsung.com>,
        "'fsdevel'" <linux-fsdevel@vger.kernel.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'f2fs'" <linux-f2fs-devel@lists.sourceforge.net>
Subject: Re: [f2fs-dev] [PATCH 1/3] f2fs: move grabing orphan pages out of
 protection region
References: <52CFC6BE.7020609@cn.fujitsu.com> <000001cf0e6c$77982430$66c86c90$@samsung.com>
In-Reply-To: <000001cf0e6c$77982430$66c86c90$@samsung.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/13 17:42:40,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/13 17:42:41,
	Serialize complete at 2014/01/13 17:42:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yu,
On 01/11/2014 09:27 AM, Chao Yu wrote:

> Hi Gu,
> 
>> -----Original Message-----
>> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
>> Sent: Friday, January 10, 2014 6:09 PM
>> To: Kim
>> Cc: fsdevel; linux-kernel; f2fs
>> Subject: [f2fs-dev] [PATCH 1/3] f2fs: move grabing orphan pages out of protection region
>>
>> Move grabing orphan block page out of protection region, and grab all
>> the orphan block pages ahead.
>>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> 
> Reviewed-by: Chao Yu <chao2.yu@samsung.com>
> 
>> ---
>>  fs/f2fs/checkpoint.c |   15 +++++++++------
>>  1 files changed, 9 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
>> index 0d78bbe..af92c74 100644
>> --- a/fs/f2fs/checkpoint.c
>> +++ b/fs/f2fs/checkpoint.c
>> @@ -303,22 +303,25 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t
>> start_blk)
>>  {
>>  	struct list_head *head;
>>  	struct f2fs_orphan_block *orphan_blk = NULL;
>> -	struct page *page = NULL;
>>  	unsigned int nentries = 0;
>> -	unsigned short index = 1;
>> -	unsigned short orphan_blocks;
>> +	unsigned short index;
>> +	unsigned short orphan_blocks = (unsigned short)((sbi->n_orphans +
>> +		(F2FS_ORPHANS_PER_BLOCK - 1)) / F2FS_ORPHANS_PER_BLOCK);
>> +	struct page *page = NULL;
>> +	struct page *pages[orphan_blocks];
>>  	struct orphan_inode_entry *orphan = NULL;
>>
>> -	orphan_blocks = (unsigned short)((sbi->n_orphans +
>> -		(F2FS_ORPHANS_PER_BLOCK - 1)) / F2FS_ORPHANS_PER_BLOCK);
>> +	for (index = 0; index < orphan_blocks; index++)
>> +		pages[index] = grab_meta_page(sbi, start_blk + index);
>>
>> +	index = 1;
>>  	mutex_lock(&sbi->orphan_inode_mutex);
>>  	head = &sbi->orphan_inode_list;
>>
>>  	/* loop for each orphan inode entry and write them in Jornal block */
>>  	list_for_each_entry(orphan, head, list) {
>>  		if (!page) {
>> -			page = grab_meta_page(sbi, start_blk);
>> +			page = pages[index - 1];
>>  			orphan_blk =
>>  				(struct f2fs_orphan_block *)page_address(page);
>>  			memset(orphan_blk, 0, sizeof(*orphan_blk));
> 
> It seems that we could remove the following code in write_orphan_inodes.
> 			start_blk++;

Yes, you're right, thanks for your review.

Regards,
Gu

> 
>> --
>> 1.7.7
>>
>>
>> ------------------------------------------------------------------------------
>> CenturyLink Cloud: The Leader in Enterprise Cloud Services.
>> Learn Why More Businesses Are Choosing CenturyLink Cloud For
>> Critical Workloads, Development Environments & Everything In Between.
>> Get a Quote or Start a Free Trial Today.
>> http://pubads.g.doubleclick.net/gampad/clk?id=119420431&iu=/4140/ostg.clktrk
>> _______________________________________________
>> Linux-f2fs-devel mailing list
>> Linux-f2fs-devel@lists.sourceforge.net
>> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
> 
> 


