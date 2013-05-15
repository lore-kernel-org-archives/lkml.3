Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab3EOHWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 03:22:30 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:18835 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab3EOHW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 03:22:29 -0400
Message-ID: <51933770.4060607@huawei.com>
Date: Wed, 15 May 2013 15:21:20 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: majianpeng <majianpeng@gmail.com>
CC: Jaegeuk Kim <jaegeuk.kim@samsung.com>, <peterz@infradead.org>,
        <mingo@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-f2fs <linux-f2fs-devel@lists.sourceforge.net>
Subject: Re: [RFC][PATCH] f2fs: Avoid print false deadlock messages.
References: <5193322D.1080009@gmail.com>
In-Reply-To: <5193322D.1080009@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/15 14:58, majianpeng wrote:
> By adding some messages, i found this problem because the gcc
> optimizing. For those codes:
>> >        for (i = 0; i < NR_GLOBAL_LOCKS; i++)
>> >                mutex_init(&sbi->fs_lock[i]);
> The defination of mutex_init is:
>> > #define mutex_init(mutex)
>> >do {
>> >
>> >        static struct lock_class_key __key;
>> >
>> >                                                                      
>> >        __mutex_init((mutex), #mutex, &__key);
>> >
>> >} while (0)
> Because the optimizing of gcc, there are only one __key rather than
> NR_GLOBAL_LOCKS times.
> 
> Add there is other problems about lockname.Using 'for()' the lockname is
> the same which is '&sbi->fs_lock[i]'.If it met problem about
> mutex-operation, it can't find which one.
> 
> Although my patch can work,i think it's not best.Because if
> NR_GLOBAL_LOCKS changed, we may leak to change this.
> 
> BTY, if who know how to avoid optimize, please tell me. Thanks!
> 
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  fs/f2fs/super.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index 8555f7d..ce08b96 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -520,7 +520,6 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
>      struct buffer_head *raw_super_buf;
>      struct inode *root;
>      long err = -EINVAL;
> -    int i;
>  
>      /* allocate memory for f2fs-specific super block info */
>      sbi = kzalloc(sizeof(struct f2fs_sb_info), GFP_KERNEL);
> @@ -578,8 +577,16 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
>      mutex_init(&sbi->gc_mutex);
>      mutex_init(&sbi->writepages);
>      mutex_init(&sbi->cp_mutex);
> -    for (i = 0; i < NR_GLOBAL_LOCKS; i++)
> -        mutex_init(&sbi->fs_lock[i]);
> +

 you can try barrier() or mb()  to avoid compile optimization.

