Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaCJFqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 01:46:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:1460 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbaCJFqm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 01:46:42 -0400
X-IronPort-AV: E=Sophos;i="4.97,622,1389715200"; 
   d="scan'208";a="9670036"
Message-ID: <531D4F9E.9070804@cn.fujitsu.com>
Date: Mon, 10 Mar 2014 13:37:34 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: jaegeuk.kim@samsung.com
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?5L+e6LaF?= <chao2.yu@samsung.com>
Subject: Re: [PATCH 5/5] f2fs: add a wait queue to avoid unnecessary, build_free_nid
References: <5319A2DB.8040705@cn.fujitsu.com> <1394427024.3870.94.camel@kjgkr>
In-Reply-To: <1394427024.3870.94.camel@kjgkr>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/10 13:43:39,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/10 13:43:46
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,
On 03/10/2014 12:50 PM, Jaegeuk Kim wrote:

> Hi Gu,
> 
> 2014-03-07 (금), 18:43 +0800, Gu Zheng:
>> Previously, when we try to alloc free nid while the build free nid
>> is going, the allocer will be run into the flow that waiting for
>> "nm_i->build_lock", see following:
>> 	/* We should not use stale free nids created by build_free_nids */
>> ---->	if (nm_i->fcnt && !on_build_free_nids(nm_i)) {
>> 		f2fs_bug_on(list_empty(&nm_i->free_nid_list));
>> 		list_for_each(this, &nm_i->free_nid_list) {
>> 			i = list_entry(this, struct free_nid, list);
>> 			if (i->state == NID_NEW)
>> 				break;
>> 		}
>>
>> 		f2fs_bug_on(i->state != NID_NEW);
>> 		*nid = i->nid;
>> 		i->state = NID_ALLOC;
>> 		nm_i->fcnt--;
>> 		spin_unlock(&nm_i->free_nid_list_lock);
>> 		return true;
>> 	}
>> 	spin_unlock(&nm_i->free_nid_list_lock);
>>
>> 	/* Let's scan nat pages and its caches to get free nids */
>> ---->	mutex_lock(&nm_i->build_lock);
>> 	build_free_nids(sbi);
>> 	mutex_unlock(&nm_i->build_lock);
>> and this will cause another unnecessary building free nid if the current
>> building free nid job is done.
> 
> Could you support any performance number for this?

I just run some common test via fio with simulated ssd(via loop).

> Since, IMO, the contended building processes will be released right away
> because of the following condition check inside build_free_nids().
> 
> if (nm_i->fcnt > NAT_ENTRY_PER_BLOCK)
> 	return;

It does. But, IMO, we can not promise nm_i->fcnt > NAT_ENTRY_PER_BLOCK when the
contended building process entering, especially in high concurrency condition.

> 
> So, I don't think this gives us any high latency.
> Can the wakeup_all() become another overhead all the time?

Yeah, maybe we must test whether it can also cause the performance regression,
because the wakeup_all also introduce overhand as you said.
But what is bad is that I do not have a production environment to test it, as you
know the simulated environment is not strict.

cc Yu,
Could you please help to test it?

Regards,
Gu

> Thanks,
> 
>> So here we introduce a wait_queue to avoid this issue.
>>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> ---
>>  fs/f2fs/f2fs.h |    1 +
>>  fs/f2fs/node.c |   10 +++++++++-
>>  2 files changed, 10 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
>> index f845e92..7ae193e 100644
>> --- a/fs/f2fs/f2fs.h
>> +++ b/fs/f2fs/f2fs.h
>> @@ -256,6 +256,7 @@ struct f2fs_nm_info {
>>  	spinlock_t free_nid_list_lock;	/* protect free nid list */
>>  	unsigned int fcnt;		/* the number of free node id */
>>  	struct mutex build_lock;	/* lock for build free nids */
>> +	wait_queue_head_t build_wq;	/* wait queue for build free nids */
>>  
>>  	/* for checkpoint */
>>  	char *nat_bitmap;		/* NAT bitmap pointer */
>> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
>> index 4b7861d..ab44711 100644
>> --- a/fs/f2fs/node.c
>> +++ b/fs/f2fs/node.c
>> @@ -1422,7 +1422,13 @@ retry:
>>  	spin_lock(&nm_i->free_nid_list_lock);
>>  
>>  	/* We should not use stale free nids created by build_free_nids */
>> -	if (nm_i->fcnt && !on_build_free_nids(nm_i)) {
>> +	if (on_build_free_nids(nm_i)) {
>> +		spin_unlock(&nm_i->free_nid_list_lock);
>> +		wait_event(nm_i->build_wq, !on_build_free_nids(nm_i));
>> +		goto retry;
>> +	}
>> +
>> +	if (nm_i->fcnt) {
>>  		f2fs_bug_on(list_empty(&nm_i->free_nid_list));
>>  		list_for_each(this, &nm_i->free_nid_list) {
>>  			i = list_entry(this, struct free_nid, list);
>> @@ -1443,6 +1449,7 @@ retry:
>>  	mutex_lock(&nm_i->build_lock);
>>  	build_free_nids(sbi);
>>  	mutex_unlock(&nm_i->build_lock);
>> +	wake_up_all(&nm_i->build_wq);
>>  	goto retry;
>>  }
>>  
>> @@ -1813,6 +1820,7 @@ static int init_node_manager(struct f2fs_sb_info *sbi)
>>  	INIT_LIST_HEAD(&nm_i->dirty_nat_entries);
>>  
>>  	mutex_init(&nm_i->build_lock);
>> +	init_waitqueue_head(&nm_i->build_wq);
>>  	spin_lock_init(&nm_i->free_nid_list_lock);
>>  	rwlock_init(&nm_i->nat_tree_lock);
>>  
> 


