Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab3HBBTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 21:19:46 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:57873 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab3HBBTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 21:19:44 -0400
MIME-Version: 1.0
In-Reply-To: <51F9D288.5040905@cn.fujitsu.com>
References: <1375281181-15526-1-git-send-email-linkinjeon@gmail.com>
	<51F9D288.5040905@cn.fujitsu.com>
Date: Fri, 2 Aug 2013 10:19:43 +0900
Message-ID: <CAKYAXd-P+XDAOrXPSXH2fCePgMnCY8Hoj1_tN8QFxP7MKLSq1A@mail.gmail.com>
Subject: Re: [PATCH 1/2] f2fs: add sysfs support for controlling the gc_thread
From: Namjae Jeon <linkinjeon@gmail.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: jaegeuk.kim@samsung.com, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
>> index 78777cd..63813be 100644
>> --- a/fs/f2fs/f2fs.h
>> +++ b/fs/f2fs/f2fs.h
>> @@ -430,6 +430,10 @@ struct f2fs_sb_info {
>>  #endif
>>  	unsigned int last_victim[2];		/* last victim segment # */
>>  	spinlock_t stat_lock;			/* lock for stat operations */
>> +
>> +	/* For sysfs suppport */
>> +	struct kobject s_kobj;
>> +	struct completion s_kobj_unregister;
>
Hi. Gu.
> What is this completion used for? Or it's an ahead design? I do not find
> synchronization
> routines use it. Am I missing something?
You're right. it is my mistake. I will update it on next version patch.

>
>
>>  };
>>
>>  /*
>> diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
>> index 35f9b1a..60d4f67 100644
>> --- a/fs/f2fs/gc.c
>> +++ b/fs/f2fs/gc.c
>> @@ -29,10 +29,11 @@ static struct kmem_cache *winode_slab;
>>  static int gc_thread_func(void *data)
>>  {
>>  	struct f2fs_sb_info *sbi = data;
>> +	struct f2fs_gc_kthread *gc_th = sbi->gc_thread;
>>  	wait_queue_head_t *wq = &sbi->gc_thread->gc_wait_queue_head;
>>  	long wait_ms;
>>
>> -	wait_ms = GC_THREAD_MIN_SLEEP_TIME;
>> +	wait_ms = gc_th->min_sleep_time;
>>
>>  	do {
>>  		if (try_to_freeze())
>> @@ -45,7 +46,7 @@ static int gc_thread_func(void *data)
>>  			break;
>>
>>  		if (sbi->sb->s_writers.frozen >= SB_FREEZE_WRITE) {
>> -			wait_ms = GC_THREAD_MAX_SLEEP_TIME;
>> +			wait_ms = increase_sleep_time(gc_th, wait_ms);
>>  			continue;
>>  		}
>>
>> @@ -66,15 +67,15 @@ static int gc_thread_func(void *data)
>>  			continue;
>>
>>  		if (!is_idle(sbi)) {
>> -			wait_ms = increase_sleep_time(wait_ms);
>> +			wait_ms = increase_sleep_time(gc_th, wait_ms);
>>  			mutex_unlock(&sbi->gc_mutex);
>>  			continue;
>>  		}
>>
>>  		if (has_enough_invalid_blocks(sbi))
>> -			wait_ms = decrease_sleep_time(wait_ms);
>> +			wait_ms = decrease_sleep_time(gc_th, wait_ms);
>>  		else
>> -			wait_ms = increase_sleep_time(wait_ms);
>> +			wait_ms = increase_sleep_time(gc_th, wait_ms);
>>
>>  #ifdef CONFIG_F2FS_STAT_FS
>>  		sbi->bg_gc++;
>> @@ -82,7 +83,7 @@ static int gc_thread_func(void *data)
>>
>>  		/* if return value is not zero, no victim was selected */
>>  		if (f2fs_gc(sbi))
>> -			wait_ms = GC_THREAD_NOGC_SLEEP_TIME;
>> +			wait_ms = gc_th->no_gc_sleep_time;
>>  	} while (!kthread_should_stop());
>>  	return 0;
>>  }
>> @@ -101,6 +102,10 @@ int start_gc_thread(struct f2fs_sb_info *sbi)
>>  		goto out;
>>  	}
>>
>> +	gc_th->min_sleep_time = DEF_GC_THREAD_MIN_SLEEP_TIME;
>> +	gc_th->max_sleep_time = DEF_GC_THREAD_MAX_SLEEP_TIME;
>> +	gc_th->no_gc_sleep_time = DEF_GC_THREAD_NOGC_SLEEP_TIME;
>> +
>>  	sbi->gc_thread = gc_th;
>>  	init_waitqueue_head(&sbi->gc_thread->gc_wait_queue_head);
>>  	sbi->gc_thread->f2fs_gc_task = kthread_run(gc_thread_func, sbi,
>> diff --git a/fs/f2fs/gc.h b/fs/f2fs/gc.h
>> index 2c6a6bd..f4bf44c 100644
>> --- a/fs/f2fs/gc.h
>> +++ b/fs/f2fs/gc.h
>> @@ -13,9 +13,9 @@
>>  						 * whether IO subsystem is idle
>>  						 * or not
>>  						 */
>> -#define GC_THREAD_MIN_SLEEP_TIME	30000	/* milliseconds */
>> -#define GC_THREAD_MAX_SLEEP_TIME	60000
>> -#define GC_THREAD_NOGC_SLEEP_TIME	300000	/* wait 5 min */
>> +#define DEF_GC_THREAD_MIN_SLEEP_TIME	30000	/* milliseconds */
>> +#define DEF_GC_THREAD_MAX_SLEEP_TIME	60000
>> +#define DEF_GC_THREAD_NOGC_SLEEP_TIME	300000	/* wait 5 min */
>>  #define LIMIT_INVALID_BLOCK	40 /* percentage over total user space */
>>  #define LIMIT_FREE_BLOCK	40 /* percentage over invalid + free space */
>>
>> @@ -25,6 +25,11 @@
>>  struct f2fs_gc_kthread {
>>  	struct task_struct *f2fs_gc_task;
>>  	wait_queue_head_t gc_wait_queue_head;
>> +
>> +	/* for gc sleep time */
>> +	unsigned int min_sleep_time;
>> +	unsigned int max_sleep_time;
>> +	unsigned int no_gc_sleep_time;
>
> Though these attributes are used for gc thread, and in current design
> gc_thread is always
> singleton per f2fs_sb, but thare're in fact f2fs sb infos. So I think it's
> to attach
> these to f2fs_sb_info. What's your opinion?
It does not matter wherever it is. but I think that these gc time are
for gc thread.
So I put gc time to gc thread.

Thanks for review :)
>
> Thanks,
> Gu
>
>>  };
