Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbaGYGB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:01:26 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:3233 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753813AbaGYGBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:01:25 -0400
X-IronPort-AV: E=Sophos;i="5.00,959,1396972800"; 
   d="scan'208";a="33765383"
Message-ID: <53D1EFD3.3070905@cn.fujitsu.com>
Date: Fri, 25 Jul 2014 13:49:07 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Chao Yu <chao2.yu@samsung.com>
CC: "'Andrey Tsyvarev'" <tsyvarev@ispras.ru>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Alexey Khoroshilov'" <khoroshilov@ispras.ru>,
        <linux-f2fs-devel@lists.sourceforge.net>
Subject: Re: [f2fs-dev] f2fs: Possible use-after-free when umount filesystem
References: <52F320FC.50803@ispras.ru> <534BC29B.3020408@ispras.ru> <53CCF1EC.30008@ispras.ru> <53CDC9AF.2050605@cn.fujitsu.com> <53CE3722.60307@ispras.ru> <000001cfa61b$c693b350$53bb19f0$@samsung.com> <53CF2E61.3000601@cn.fujitsu.com> <53D0DC8C.7050406@ispras.ru> <002a01cfa7b7$d79edc40$86dc94c0$@samsung.com>
In-Reply-To: <002a01cfa7b7$d79edc40$86dc94c0$@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 11:22 AM, Chao Yu wrote:

> Hi,
> 
> To Andrey:
> Thanks for your test on this patch!
> 
> To Gu:
> If you do not object, let me make and resend a patch base on the one which
> skip invalidating pages.

Please go ahead.:)

Thanks,
Gu

> 
> Regards,
> Yu
> 
>> -----Original Message-----
>> From: Andrey Tsyvarev [mailto:tsyvarev@ispras.ru]
>> Sent: Thursday, July 24, 2014 6:15 PM
>> To: Gu Zheng; Chao Yu
>> Cc: 'Jaegeuk Kim'; 'linux-kernel'; 'Alexey Khoroshilov';
>> linux-f2fs-devel@lists.sourceforge.net
>> Subject: Re: [f2fs-dev] f2fs: Possible use-after-free when umount filesystem
>>
>> Hi,
>>
>> With patch skipping invalidating pages for node_inode and meta_inode
>> use-after-free error disappears too.
>>
>> 23.07.2014 7:39, Gu Zheng пишет:
>>> Hi,
>>> On 07/23/2014 10:12 AM, Chao Yu wrote:
>>>
>>>> Hi Andrey Gu,
>>>>
>>>>> -----Original Message-----
>>>>> From: Andrey Tsyvarev [mailto:tsyvarev@ispras.ru]
>>>>> Sent: Tuesday, July 22, 2014 6:04 PM
>>>>> To: Gu Zheng
>>>>> Cc: Jaegeuk Kim; linux-kernel; Alexey Khoroshilov; linux-f2fs-devel@lists.sourceforge.net
>>>>> Subject: Re: [f2fs-dev] f2fs: Possible use-after-free when umount filesystem
>>>>>
>>>>> Hi Gu,
>>>>>
>>>>>>> Investigation shows, that f2fs_evict_inode, when called for 'meta_inode', uses
>>>>> invalidate_mapping_pages() for 'node_inode'.
>>>>>>> But 'node_inode' is deleted before 'meta_inode' in f2fs_put_super via iput().
>>>>>>>
>>>>>>> It seems that in common usage scenario this use-after-free is benign, because 'node_inode'
>>>>> remains partially valid data even after kmem_cache_free().
>>>>>>> But things may change if, while 'meta_inode' is evicted in one f2fs filesystem, another
>> (mounted)
>>>>> f2fs filesystem requests inode from cache, and formely
>>>>>>> 'node_inode' of the first filesystem is returned.
>>>>>> The analysis seems reasonable. Have you tried to swap the reclaim order of node_inde
>>>>>> and meta_inode?
>>>>>>
>>>>>> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
>>>>>> index 870fe19..e114418 100644
>>>>>> --- a/fs/f2fs/super.c
>>>>>> +++ b/fs/f2fs/super.c
>>>>>> @@ -430,8 +430,8 @@ static void f2fs_put_super(struct super_block *sb)
>>>>>>           if (sbi->s_dirty && get_pages(sbi, F2FS_DIRTY_NODES))
>>>>>>                   write_checkpoint(sbi, true);
>>>>>>
>>>>>> -       iput(sbi->node_inode);
>>>>>>           iput(sbi->meta_inode);
>>>>>> +       iput(sbi->node_inode);
>>>>>>
>>>>>>           /* destroy f2fs internal modules */
>>>>>>           destroy_node_manager(sbi);
>>>>>>
>>>>>> Thanks,
>>>>>> Gu
>>>>> With reclaim order of node_inode and meta_inode swapped, use-after-free
>>>>> error disappears.
>>>>>
>>>>> But shouldn't initialization order of these inodes be swapped too?
>>>>> As meta_inode uses node_inode, it seems logical that it should be
>>>>> initialized after it.
>>> The initialization order dose not affect anything, so swapping the order dose not
>>> make more sense here.
>>>
>>>> IMO, it's not easy to exchange order of initialization between meta_inode and
>>>> node_inode, because we should use meta_inode in get_valid_checkpoint for valid
>>>> cp first for usual verification, then init node_inode.
>>> Yeah, but I think just moving node_inode's initialization to the front of meta_inode
>>> dose not break anything.
>>>
>>>> As I checked, nids for both meta_inode and node_inode are reservation, so it's not
>>>> necessary for us to invalidate pages which will never alloced.
>>>>
>>>> How about skipping it as following?
>>> It seems the right way to fix this issue.
>>>
>>> To Andrey:
>>> Could you please try this one?
>>>
>>> Thanks,
>>> Gu
>>>
>>>> diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
>>>> index 2cf6962..cafba3c 100644
>>>> --- a/fs/f2fs/inode.c
>>>> +++ b/fs/f2fs/inode.c
>>>> @@ -273,7 +273,7 @@ void f2fs_evict_inode(struct inode *inode)
>>>>
>>>>   	if (inode->i_ino == F2FS_NODE_INO(sbi) ||
>>>>   			inode->i_ino == F2FS_META_INO(sbi))
>>>> -		goto no_delete;
>>>> +		goto out_clear;
>>>>
>>>>   	f2fs_bug_on(get_dirty_dents(inode));
>>>>   	remove_dirty_dir_inode(inode);
>>>> @@ -295,6 +295,7 @@ void f2fs_evict_inode(struct inode *inode)
>>>>
>>>>   	sb_end_intwrite(inode->i_sb);
>>>>   no_delete:
>>>> -	clear_inode(inode);
>>>>   	invalidate_mapping_pages(NODE_MAPPING(sbi), inode->i_ino, inode->i_ino);
>>>> +out_clear:
>>>> +	clear_inode(inode);
>>>>   }
>>>>
>>>>> --
>>>>> Best regards,
>>>>>
>>>>> Andrey Tsyvarev
>>>>> Linux Verification Center, ISPRAS
>>>>> web:http://linuxtesting.org
>>>>>
>>>>>
>>>>> ------------------------------------------------------------------------------
>>>>> Want fast and easy access to all the code in your enterprise? Index and
>>>>> search up to 200,000 lines of code with a free copy of Black Duck
>>>>> Code Sight - the same software that powers the world's largest code
>>>>> search on Ohloh, the Black Duck Open Hub! Try it now.
>>>>> http://p.sf.net/sfu/bds
>>>>> _______________________________________________
>>>>> Linux-f2fs-devel mailing list
>>>>> Linux-f2fs-devel@lists.sourceforge.net
>>>>> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
>>>> .
>>>>
>>>
>>>
>>
>> --
>> Best regards,
>>
>> Andrey Tsyvarev
>> Linux Verification Center, ISPRAS
>> web:http://linuxtesting.org
> 
> .
> 


