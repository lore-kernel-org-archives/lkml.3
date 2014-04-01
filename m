Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbaDACY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 22:24:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54059 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbaDACY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 22:24:56 -0400
X-IronPort-AV: E=Sophos;i="4.97,769,1389715200"; 
   d="scan'208";a="9803919"
Message-ID: <533A2144.8040607@cn.fujitsu.com>
Date: Tue, 01 Apr 2014 10:15:32 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Chao Yu <chao2.yu@samsung.com>
CC: "'???'" <jaegeuk.kim@samsung.com>, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [f2fs-dev] [PATCH 2/2] f2fs: use list_for_each_entry{_safe} for
 simplyfying code
References: <000001cf4aff$baaf99e0$300ecda0$@samsung.com> <53393E47.5070600@cn.fujitsu.com> <000001cf4d4c$374e5f10$a5eb1d30$@samsung.com>
In-Reply-To: <000001cf4d4c$374e5f10$a5eb1d30$@samsung.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/04/01 10:21:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/04/01 10:21:36,
	Serialize complete at 2014/04/01 10:21:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yu,
On 04/01/2014 09:45 AM, Chao Yu wrote:

> Hi Gu,
> 
>> -----Original Message-----
>> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
>> Sent: Monday, March 31, 2014 6:07 PM
>> To: Chao Yu
>> Cc: ???; linux-f2fs-devel@lists.sourceforge.net; linux-fsdevel@vger.kernel.org;
>> linux-kernel@vger.kernel.org
>> Subject: Re: [f2fs-dev] [PATCH 2/2] f2fs: use list_for_each_entry{_safe} for simplyfying code
>>
>> Hi Yu,
>> On 03/29/2014 11:33 AM, Chao Yu wrote:
>>
>>> This patch use list_for_each_entry{_safe} instead of list_for_each{_safe} for
>>> simplfying code.
>>>
>>> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
>>> ---
>>>  fs/f2fs/checkpoint.c |   37 ++++++++++++++-----------------------
>>>  fs/f2fs/node.c       |   16 ++++++----------
>>>  fs/f2fs/recovery.c   |    6 ++----
>>>  fs/f2fs/segment.c    |    6 ++----
>>>  4 files changed, 24 insertions(+), 41 deletions(-)
>>>
>>> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
>>> index d877f46..4aa521a 100644
>>> --- a/fs/f2fs/checkpoint.c
>>> +++ b/fs/f2fs/checkpoint.c
>>> @@ -308,16 +308,15 @@ void release_orphan_inode(struct f2fs_sb_info *sbi)
>>>
>>>  void add_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
>>>  {
>>> -	struct list_head *head, *this;
>>> -	struct orphan_inode_entry *new = NULL, *orphan = NULL;
>>> +	struct list_head *head;
>>> +	struct orphan_inode_entry *new, *orphan;
>>>
>>>  	new = f2fs_kmem_cache_alloc(orphan_entry_slab, GFP_ATOMIC);
>>>  	new->ino = ino;
>>>
>>>  	spin_lock(&sbi->orphan_inode_lock);
>>>  	head = &sbi->orphan_inode_list;
>>> -	list_for_each(this, head) {
>>> -		orphan = list_entry(this, struct orphan_inode_entry, list);
>>> +	list_for_each_entry(orphan, head, list) {
>>>  		if (orphan->ino == ino) {
>>>  			spin_unlock(&sbi->orphan_inode_lock);
>>>  			kmem_cache_free(orphan_entry_slab, new);
>>> @@ -326,14 +325,10 @@ void add_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
>>>
>>>  		if (orphan->ino > ino)
>>>  			break;
>>> -		orphan = NULL;
>>>  	}
>>>
>>> -	/* add new_oentry into list which is sorted by inode number */
>>> -	if (orphan)
>>> -		list_add(&new->list, this->prev);
>>> -	else
>>> -		list_add_tail(&new->list, head);
>>> +	/* add new orphan entry into list which is sorted by inode number */
>>> +	list_add_tail(&new->list, &orphan->list);
>>
>> It seems that the logic can not be changed here, otherwise the orphan list will not be in order
>> if
>> the new ino is bigger than all the in-list ones.
>> E.g.
>> ino:5
>> 1-->2-->3-->4
>> ==>
>> 1-->2-->3-->5-->4
> 
> As I checked, if new ino is bigger than all, it will break from list_for_each_entry because
> &orphan->list is pointing to head. So list_add_tail can add the new entry before head to make
> this list in order.

Oh...Yes, you are right.
Thanks for correcting me.

Regards,
Gu

> 
> Thanks.
> 
>>
>> Regards,
>> Gu
>>
> 
> [snip]
> 
> 


