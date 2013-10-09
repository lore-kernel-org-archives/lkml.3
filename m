Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab3JIF63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 01:58:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38795 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3JIF6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 01:58:08 -0400
X-AuditID: cbfee6a2-b7f6b6d000003aba-6d-5254f06ed4a6
Date: Wed, 09 Oct 2013 05:58:06 +0000 (GMT)
From: Yuan Zhong <yuan.mark.zhong@samsung.com>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: avoid congestion_wait when
 do_checkpoint for better performance
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        "linux-f2fs-devel@lists.sourceforge.net" 
	<linux-f2fs-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        shu tan <shu.tan@samsung.com>
Reply-to: yuan.mark.zhong@samsung.com
MIME-version: 1.0
X-MTR: 20131009052250286@yuan.mark.zhong
Msgkey: 20131009052250286@yuan.mark.zhong
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20131009052250286@yuan.mark.zhong
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <4777476.286991381298285831.JavaMail.weblogic@epv6ml05>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t/tGbp5H0KCDP73WFtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Ms+cusxdsi6x41vGJrYGxJ7yLkZNDSEBL4v2Ph8wgtoSAicT3
	abvYIWwxiQv31rN1MXIB1cxnlLi1diVYgkVAReL+jiksIDabgL7EnX37GEFsYYEMiZeTFgMN
	4uAQEdCQeNHoCdLLLLCcSaJv7l8mkLiQgKrE8bWlIOW8AoISJ2c+YYHYpSFxe/IvRoi4psS5
	eYdZIeJyEkumXmaCsHklZrQ/ZYGJT/u6BupmaYnzszYwwty8+PtjqDi/xLHbO8DWgvQ+uR8M
	M2b35i9sELaAxNQzB6FadSXO3v8ItYpPYs3CtywwY3adWs4M03t/y1ywGmYBRYkp3Q/ZIWwD
	iSOL5rCie4tXwFniypHbbBMY5WYhSc1C0j4LSTuymgWMLKsYRVMLkguKk9IrjPSKE3OLS/PS
	9ZLzczcxgqP82aIdjP/OWx9iFOBgVOLhfcAfEiTEmlhWXJl7iFGCg1lJhDdvIVCINyWxsiq1
	KD++qDQntfgQozQHi5I477NW60AhgfTEktTs1NSC1CKYLBMHp1QDY8mhmHyWCadN49ebWmSa
	XZa9OnNawQp2o5rWiNSaIOUt+yt27srUZf7j/rN17d+EifduKd43Dd3k+lpu1UmLUhvLld1x
	ylrvtJlu8Xy+Nnku18Rmxq5ztjtd7po/WlG853fZE8udco8/HC13zt5t5CL3dsvGsEvWlbOm
	ZUxME+E6+Nl117m735RYijMSDbWYi4oTAThCUSbuAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r995wjU8009560

Hi Gu,

> Hi Yuan,
> On 10/08/2013 07:30 PM, Yuan Zhong wrote:
>
>> Hi Gu,
>> 
>>> Hi Yuan,
>>> On 10/08/2013 04:30 PM, Yuan Zhong wrote:
>> 
>>>> Previously, do_checkpoint() will call congestion_wait() for waiting the pages (previous submitted node/meta/data pages) to be written back.
>>>> Because congestion_wait() will set a regular period (e.g. HZ / 50 ) for waiting.
>>>> For this reason, there is a situation that after the pages have been written back, 
>>>> but the checkpoint thread still wait for congestion_wait to exit.
>> 
>>> How do you confirm this issue? 
>> 
>>   I traced the execution path.
>>   In f2fs_end_io_write, dec_page_count(p->sbi, F2FS_WRITEBACK) will be called.
>>   And I found that, when pages of F2FS_WRITEBACK has been zero, but
>>   checkpoint thread still congestion_wait for pages of F2FS_WRITEBACK to be zero.
>
>Yes, it maybe. Congestion_wait add the task to a global wait queue which related to
>all back devices, so if F2FS_WRITEBACK has been zero, but other io may be still going on.
>Anyway, using a private wait queue to hold is a better choose.:)
>
>	
>>   So, I think this point could be improved.
>>   And I wrote a simple test case and tested on Micro-SD card, the steps as following:
>>       (a) create a fixed-size file (4KB)
>>       (b) go on to sync the file 
>>       (c) go back to step #a (fixed numbers of cycling:1024)	
>>    The results indicated that the execution time is reduced greatly by using this patch.
>
>Yes, the change is an improvement if the issue is existent.
>
>  
>> 
>> 
>>> I suspect that the block-core does not have a wake-up mechanism
>>> when the back device is uncongested.
>> 
>> 
>>   Yes, you are right.
>>   So I wake up the checkpoint thread by myself, when pages of F2FS_WRITEBACK to be zero.
>>   In f2fs_end_io_write, f2fs_writeback_wake is called.
>>   you cloud find this code in my patch. 
>
>Saw it.:)
>But one problem is that the checkpoint routine always is singleton, so the wait queue just
>services only one body, it seems not very worthy. How about just schedule and wake up it
>directly? See the following one.


Yes, your point is right.
My reason for using wait queue is that I am influenced by congestion_wait function.
The inner function of congesiton_wait is also using wait_queue.
And, I think, your patch is also a more efficient method.


>
>Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>---
> fs/f2fs/checkpoint.c |   11 +++++++++--
> fs/f2fs/f2fs.h       |    1 +
> fs/f2fs/segment.c    |    4 ++++
> 3 files changed, 14 insertions(+), 2 deletions(-)
>
>diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
>index d808827..2a5999d 100644
>--- a/fs/f2fs/checkpoint.c
>+++ b/fs/f2fs/checkpoint.c
>@@ -757,8 +757,15 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
> 	f2fs_put_page(cp_page, 1);
> 
> 	/* wait for previous submitted node/meta pages writeback */
>-	while (get_pages(sbi, F2FS_WRITEBACK))
>-		congestion_wait(BLK_RW_ASYNC, HZ / 50);
>+	sbi->cp_task = current;
>+	while (get_pages(sbi, F2FS_WRITEBACK)) {
>+		set_current_state(TASK_UNINTERRUPTIBLE);
>+		if (!get_pages(sbi, F2FS_WRITEBACK))
>+			break;
>+		io_schedule();
>+	}
>+	__set_current_state(TASK_RUNNING);
>+	sbi->cp_task = NULL;
> 
> 	filemap_fdatawait_range(sbi->node_inode->i_mapping, 0, LONG_MAX);
> 	filemap_fdatawait_range(sbi->meta_inode->i_mapping, 0, LONG_MAX);
>diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
>index a955a59..408ace7 100644
>--- a/fs/f2fs/f2fs.h
>+++ b/fs/f2fs/f2fs.h
>@@ -365,6 +365,7 @@ struct f2fs_sb_info {
> 	struct mutex writepages;		/* mutex for writepages() */
> 	int por_doing;				/* recovery is doing or not */
> 	int on_build_free_nids;			/* build_free_nids is doing */
>+	struct task_struct *cp_task;		/* checkpoint task */
> 
> 	/* for orphan inode management */
> 	struct list_head orphan_inode_list;	/* orphan inode list */
>diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
>index bd79bbe..3b20359 100644
>--- a/fs/f2fs/segment.c
>+++ b/fs/f2fs/segment.c
>@@ -597,6 +597,10 @@ static void f2fs_end_io_write(struct bio *bio, int err)
> 
> 	if (p->is_sync)
> 		complete(p->wait);
>+
>+	if (!get_pages(p->sbi, F2FS_WRITEBACK) && p->sbi->cp_task)
>+		wake_up_process(p->sbi->cp_task);
>+
> 	kfree(p);
> 	bio_put(bio);
> }
>-- 
>1.7.7
>
>Regards,
>Gu 
>


Regards,
Yuan


>> 
>> 
>>>> This is a problem here, especially, when sync a large number of small files or dirs.
>>>> In order to avoid this, a wait_list is introduced, 
>>>> the checkpoint thread will be dropped into the wait_list if the pages have not been written back, 
>>>> and will be waked up by contrast.
>> 
>>> Please pay some attention to the mail form, this mail is out of format in my mail client.
>> 
>>> Regards,
>>> Gu
>> 
>> Regards,
>> Yuan
>> 
>>>>
>>>> Signed-off-by: Yuan Zhong <yuan.mark.zhong@samsung.com>
>>>> ---  
>>>>  fs/f2fs/checkpoint.c |    3 +--
>>>>  fs/f2fs/f2fs.h       |   19 +++++++++++++++++++
>>>>  fs/f2fs/segment.c    |    1 +
>>>>  fs/f2fs/super.c      |    1 +
>>>>  4 files changed, 22 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
>>>> index ca39442..5d69ae0 100644
>>>> --- a/fs/f2fs/checkpoint.c
>>>> +++ b/fs/f2fs/checkpoint.c
>>>> @@ -758,8 +758,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
>>>>  	f2fs_put_page(cp_page, 1);
>>>>  
>>>>  	/* wait for previous submitted node/meta pages writeback */
>>>> -	while (get_pages(sbi, F2FS_WRITEBACK))
>>>> -		congestion_wait(BLK_RW_ASYNC, HZ / 50);
>>>> +	f2fs_writeback_wait(sbi);
>>>>  
>>>>  	filemap_fdatawait_range(sbi->node_inode->i_mapping, 0, LONG_MAX);
>>>>  	filemap_fdatawait_range(sbi->meta_inode->i_mapping, 0, LONG_MAX);
>>>> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
>>>> index 7fd99d8..4b0d70e 100644
>>>> --- a/fs/f2fs/f2fs.h
>>>> +++ b/fs/f2fs/f2fs.h
>>>> @@ -18,6 +18,8 @@
>>>>  #include <linux/crc32.h>
>>>>  #include <linux/magic.h>
>>>>  #include <linux/kobject.h>
>>>> +#include <linux/wait.h>
>>>> +#include <linux/sched.h>
>>>>  
>>>>  /*
>>>>   * For mount options
>>>> @@ -368,6 +370,7 @@ struct f2fs_sb_info {
>>>>  	struct mutex fs_lock[NR_GLOBAL_LOCKS];	/* blocking FS operations */
>>>>  	struct mutex node_write;		/* locking node writes */
>>>>  	struct mutex writepages;		/* mutex for writepages() */
>>>> +	wait_queue_head_t writeback_wqh;	/* wait_queue for writeback */
>>>>  	unsigned char next_lock_num;		/* round-robin global locks */
>>>>  	int por_doing;				/* recovery is doing or not */
>>>>  	int on_build_free_nids;			/* build_free_nids is doing */
>>>> @@ -961,6 +964,22 @@ static inline int f2fs_readonly(struct super_block *sb)
>>>>  	return sb->s_flags & MS_RDONLY;
>>>>  }
>>>>  
>>>> +static inline void f2fs_writeback_wait(struct f2fs_sb_info *sbi)
>>>> +{
>>>> +	DEFINE_WAIT(wait);
>>>> +
>>>> +	prepare_to_wait(&sbi->writeback_wqh, &wait, TASK_UNINTERRUPTIBLE);
>>>> +	if (get_pages(sbi, F2FS_WRITEBACK))
>>>> +		io_schedule();
>>>> +	finish_wait(&sbi->writeback_wqh, &wait);
>>>> +}
>>>> +
>>>> +static inline void f2fs_writeback_wake(struct f2fs_sb_info *sbi)
>>>> +{
>>>> +	if (!get_pages(sbi, F2FS_WRITEBACK))
>>>> +		wake_up_all(&sbi->writeback_wqh);
>>>> +}
>>>> +
>>>>  /*
>>>>   * file.c
>>>>   */
>>>> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
>>>> index bd79bbe..0708aa9 100644
>>>> --- a/fs/f2fs/segment.c
>>>> +++ b/fs/f2fs/segment.c
>>>> @@ -597,6 +597,7 @@ static void f2fs_end_io_write(struct bio *bio, int err)
>>>>  
>>>>  	if (p->is_sync)
>>>>  		complete(p->wait);
>>>> +	f2fs_writeback_wake(p->sbi);
>>>>  	kfree(p);
>>>>  	bio_put(bio);
>>>>  }
>>>> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
>>>> index 094ccc6..3ac6d85 100644
>>>> --- a/fs/f2fs/super.c
>>>> +++ b/fs/f2fs/super.c
>>>> @@ -835,6 +835,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
>>>>  	mutex_init(&sbi->gc_mutex);
>>>>  	mutex_init(&sbi->writepages);
>>>>  	mutex_init(&sbi->cp_mutex);
>>>> +	init_waitqueue_head(&sbi->writeback_wqh);
>>>>  	for (i = 0; i < NR_GLOBAL_LOCKS; i++)
>>>>  		mutex_init(&sbi->fs_lock[i]);
>>>>  	mutex_init(&sbi->node_write);
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
