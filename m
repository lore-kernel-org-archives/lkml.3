Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbaIEKad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:30:33 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:37488 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756478AbaIEKab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:30:31 -0400
X-IronPort-AV: E=Sophos;i="5.04,471,1406563200"; 
   d="scan'208";a="35569468"
Message-ID: <54098D9E.3070400@cn.fujitsu.com>
Date: Fri, 5 Sep 2014 18:17:02 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Chao Yu <chao2.yu@samsung.com>
CC: <jaegeuk@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>
Subject: Re: [f2fs-dev] [PATCH] f2fs: use lock-less list(llist) to simplify
 the flush cmd management
References: <1409735782-7831-1-git-send-email-guz.fnst@cn.fujitsu.com> <002101cfc8d8$1963b650$4c2b22f0$@samsung.com>
In-Reply-To: <002101cfc8d8$1963b650$4c2b22f0$@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yu,

On 09/05/2014 03:07 PM, Chao Yu wrote:

> Hi Gu,
> 
>> -----Original Message-----
>> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
>> Sent: Wednesday, September 03, 2014 5:16 PM
>> To: jaegeuk@kernel.org
>> Cc: Gu Zheng; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
>> Subject: [f2fs-dev] [PATCH] f2fs: use lock-less list(llist) to simplify the flush cmd management
>>
>> We use flush cmd control to collect many flush cmds, and flush them
>> together. In this case, we use two list to manage the flush cmds
>> (collect and dispatch), and one spin lock is used to protect this.
>> In fact, the lock-less list(llist) is very suitable to this case,
>> and we use simplify this routine.
> 
> Good catch for finding this scenario with llist!
> 
>>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> ---
>>  fs/f2fs/f2fs.h    |    7 +++----
>>  fs/f2fs/segment.c |   31 +++++++++----------------------
>>  2 files changed, 12 insertions(+), 26 deletions(-)
>>
>> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
>> index e921242..1dd861c 100644
>> --- a/fs/f2fs/f2fs.h
>> +++ b/fs/f2fs/f2fs.h
>> @@ -334,16 +334,15 @@ enum {
>>  struct flush_cmd {
>>  	struct flush_cmd *next;
> 
> No needed here, we can remove it.
> 
>>  	struct completion wait;
>> +	struct llist_node llnode;
>>  	int ret;
>>  };
>>
>>  struct flush_cmd_control {
>>  	struct task_struct *f2fs_issue_flush;	/* flush thread */
>>  	wait_queue_head_t flush_wait_queue;	/* waiting queue for wake-up */
>> -	struct flush_cmd *issue_list;		/* list for command issue */
>> -	struct flush_cmd *dispatch_list;	/* list for command dispatch */
>> -	spinlock_t issue_lock;			/* for issue list lock */
>> -	struct flush_cmd *issue_tail;		/* list tail of issue list */
>> +	struct llist_head issue_list;		/* list for command issue */
>> +	struct llist_node *dispatch_list;	/* list for command dispatch */
>>  };
>>
>>  struct f2fs_sm_info {
>> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
>> index 0aa337c..2db1f95 100644
>> --- a/fs/f2fs/segment.c
>> +++ b/fs/f2fs/segment.c
>> @@ -205,24 +205,19 @@ repeat:
>>  	if (kthread_should_stop())
>>  		return 0;
>>
>> -	spin_lock(&fcc->issue_lock);
>> -	if (fcc->issue_list) {
>> -		fcc->dispatch_list = fcc->issue_list;
>> -		fcc->issue_list = fcc->issue_tail = NULL;
>> -	}
>> -	spin_unlock(&fcc->issue_lock);
>> -
>> -	if (fcc->dispatch_list) {
>> +	if (!llist_empty(&fcc->issue_list)) {
>>  		struct bio *bio = bio_alloc(GFP_NOIO, 0);
>> -		struct flush_cmd *cmd, *next;
>> +		struct flush_cmd *cmd;
>>  		int ret;
>>
>> +		fcc->dispatch_list = llist_del_all(&fcc->issue_list);
>> +		fcc->dispatch_list = llist_reverse_order(fcc->dispatch_list);
>> +
>>  		bio->bi_bdev = sbi->sb->s_bdev;
>>  		ret = submit_bio_wait(WRITE_FLUSH, bio);
>>
>> -		for (cmd = fcc->dispatch_list; cmd; cmd = next) {
>> +		llist_for_each_entry(cmd, fcc->dispatch_list, llnode) {
> 
> Please use llist_for_each_entry_safe, Otherwise we might encounter oops as below:
> 
> [18727.381582] Call Trace:
> [18727.381613]  [<c107c0bf>] __wake_up_locked+0x1f/0x30
> [18727.381626]  [<c107c886>] complete+0x36/0x50
> [18727.381645]  [<f0a01313>] issue_flush_thread+0x93/0x140 [f2fs]
> [18727.381658]  [<c107c530>] ? add_wait_queue+0x50/0x50
> [18727.381672]  [<f0a01280>] ? add_sit_entry+0xc0/0xc0 [f2fs]
> [18727.381687]  [<c105fabb>] kthread+0x9b/0xb0
> [18727.381701]  [<c159ad81>] ret_from_kernel_thread+0x21/0x30
> [18727.381714]  [<c105fa20>] ? flush_kthread_worker+0x80/0x80

Thanks very much. Fixed all in the new version.

Regards,
Gu

> 
> Thanks,
> Yu
> 
>>  			cmd->ret = ret;
>> -			next = cmd->next;
>>  			complete(&cmd->wait);
>>  		}
>>  		bio_put(bio);
>> @@ -230,7 +225,7 @@ repeat:
>>  	}
>>
>>  	wait_event_interruptible(*q,
>> -			kthread_should_stop() || fcc->issue_list);
>> +		kthread_should_stop() || !llist_empty(&fcc->issue_list));
>>  	goto repeat;
>>  }
>>
>> @@ -249,17 +244,10 @@ int f2fs_issue_flush(struct f2fs_sb_info *sbi)
>>  		return blkdev_issue_flush(sbi->sb->s_bdev, GFP_KERNEL, NULL);
>>
>>  	init_completion(&cmd.wait);
>> -	cmd.next = NULL;
>>
>> -	spin_lock(&fcc->issue_lock);
>> -	if (fcc->issue_list)
>> -		fcc->issue_tail->next = &cmd;
>> -	else
>> -		fcc->issue_list = &cmd;
>> -	fcc->issue_tail = &cmd;
>> -	spin_unlock(&fcc->issue_lock);
>> +	llist_add(&cmd.llnode, &fcc->issue_list);
>>
>> -	if (!fcc->dispatch_list)
>> +	if (fcc->dispatch_list == NULL)
>>  		wake_up(&fcc->flush_wait_queue);
>>
>>  	wait_for_completion(&cmd.wait);
>> @@ -276,7 +264,6 @@ int create_flush_cmd_control(struct f2fs_sb_info *sbi)
>>  	fcc = kzalloc(sizeof(struct flush_cmd_control), GFP_KERNEL);
>>  	if (!fcc)
>>  		return -ENOMEM;
>> -	spin_lock_init(&fcc->issue_lock);
>>  	init_waitqueue_head(&fcc->flush_wait_queue);
>>  	SM_I(sbi)->cmd_control_info = fcc;
>>  	fcc->f2fs_issue_flush = kthread_run(issue_flush_thread, sbi,
>> --
>> 1.7.7
>>
>>
>> ------------------------------------------------------------------------------
>> Slashdot TV.
>> Video for Nerds.  Stuff that matters.
>> http://tv.slashdot.org/
>> _______________________________________________
>> Linux-f2fs-devel mailing list
>> Linux-f2fs-devel@lists.sourceforge.net
>> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
> 
> .
> 


