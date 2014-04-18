Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbaDRGEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 02:04:37 -0400
Received: from mail.ispras.ru ([83.149.199.45]:55529 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbaDRGEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 02:04:32 -0400
Message-ID: <5350C06A.4090807@ispras.ru>
Date: Thu, 17 Apr 2014 23:04:26 -0700
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: jaegeuk.kim@samsung.com
CC: Andrey Tsyvarev <tsyvarev@ispras.ru>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: f2fs: BUG_ON() is triggered when mount valid f2fs filesystem
References: <52F320FC.50803@ispras.ru> <534BC29B.3020408@ispras.ru> <1397559864.7727.5.camel@kjgkr> <534E494C.7050909@ispras.ru> <1397691337.7727.18.camel@kjgkr> <534F2A32.9030405@ispras.ru> <1397720720.7727.28.camel@kjgkr>
In-Reply-To: <1397720720.7727.28.camel@kjgkr>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.04.2014 00:45, Jaegeuk Kim wrote:
> Hi,
>
> 2014-04-16 (수), 18:11 -0700, Alexey Khoroshilov:
>> Hi,
>>
>> But would not ability to trigger BUG_ON by mounting a crafted image
>> considered as an issue having security implications?
> Sorry, I can't come up with you.
> Could you please explain why this can be related to the security hole?
> Did you mean it needs to avoid such the BUG_ONs if the image has
> obsolete data being used before?
An ability to trigger a BUG_ON assert by mounting a crafted image is
usually considered as a local denial of service [1-3]. As far as I
understand, the reason is that some kernel data may become inconsistent
that can lead to further problems.

[1] http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2011-3353
[2] http://www.openwall.com/lists/oss-security/2011/06/24/4
[3] http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2011-2928
etc.

--
Alexey


> On 16.04.2014 16:35, Jaegeuk Kim wrote:
>>> Hi,
>>>
>>> 2014-04-16 (수), 13:11 +0400, Andrey Tsyvarev:
>>>> Hi,
>>>>
>>>> With this patch mounting of the image continues to fail (with similar 
>>>> BUG_ON).
>>>> But when image is formatted again (and steps mentioned in the previous 
>>>> message are performed),
>>>> mounting of it is now succeed.
>>>>
>>>> Is this is a true purpose of the patch?
>>> Indeed. The patch solves there-in root cause.
>>> But, if you're trying to use the failed image again, simply you can skip
>>> the errorneous part by:
>>>
>>> # mount ... -o disable_roll_forward ...
>>>
>>> Once sync or umount whatever checkpoint is done after that, the image
>>> will be mounted without "disable_roll_forward".
>>>
>>> Thanks,
>>>
>>>> 15.04.2014 15:04, Jaegeuk Kim пишет:
>>>>> Hi,
>>>>>
>>>>> Thank you for the report.
>>>>> I retrieved the fault image and found out that previous garbage data
>>>>> wreak such the wrong behaviors.
>>>>> So, I wrote the following patch that fills one zero-block at the
>>>>> checkpoint procedure.
>>>>> If the underlying device supports discard, I expect that it mostly
>>>>> doesn't incur any performance regression significantly.
>>>>>
>>>>> Could you test this patch?
>>>>>
>>>>> >From 60588ceb7277aae2a79e7f67f5217d1256720d78 Mon Sep 17 00:00:00 2001
>>>>> From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
>>>>> Date: Tue, 15 Apr 2014 13:57:55 +0900
>>>>> Subject: [PATCH] f2fs: avoid to conduct roll-forward due to the remained
>>>>>   garbage blocks
>>>>>
>>>>> The f2fs always scans the next chain of direct node blocks.
>>>>> But some garbage blocks are able to be remained due to no discard
>>>>> support or
>>>>> SSR triggers.
>>>>> This occasionally wreaks recovering wrong inodes that were used or
>>>>> BUG_ONs
>>>>> due to reallocating node ids as follows.
>>>>>
>>>>> When mount this f2fs image:
>>>>> http://linuxtesting.org/downloads/f2fs_fault_image.zip
>>>>> BUG_ON is triggered in f2fs driver (messages below are generated on
>>>>> kernel 3.13.2; for other kernels output is similar):
>>>>>
>>>>> kernel BUG at fs/f2fs/node.c:215!
>>>>>   Call Trace:
>>>>>   [<ffffffffa032ebad>] recover_inode_page+0x1fd/0x3e0 [f2fs]
>>>>>   [<ffffffff811446e7>] ? __lock_page+0x67/0x70
>>>>>   [<ffffffff81089990>] ? autoremove_wake_function+0x50/0x50
>>>>>   [<ffffffffa0337788>] recover_fsync_data+0x1398/0x15d0 [f2fs]
>>>>>   [<ffffffff812b9e5c>] ? selinux_d_instantiate+0x1c/0x20
>>>>>   [<ffffffff811cb20b>] ? d_instantiate+0x5b/0x80
>>>>>   [<ffffffffa0321044>] f2fs_fill_super+0xb04/0xbf0 [f2fs]
>>>>>   [<ffffffff811b861e>] ? mount_bdev+0x7e/0x210
>>>>>   [<ffffffff811b8769>] mount_bdev+0x1c9/0x210
>>>>>   [<ffffffffa0320540>] ? validate_superblock+0x210/0x210 [f2fs]
>>>>>   [<ffffffffa031cf8d>] f2fs_mount+0x1d/0x30 [f2fs]
>>>>>   [<ffffffff811b9497>] mount_fs+0x47/0x1c0
>>>>>   [<ffffffff81166e00>] ? __alloc_percpu+0x10/0x20
>>>>>   [<ffffffff811d4032>] vfs_kern_mount+0x72/0x110
>>>>>   [<ffffffff811d6763>] do_mount+0x493/0x910
>>>>>   [<ffffffff811615cb>] ? strndup_user+0x5b/0x80
>>>>>   [<ffffffff811d6c70>] SyS_mount+0x90/0xe0
>>>>>   [<ffffffff8166f8d9>] system_call_fastpath+0x16/0x1b
>>>>>
>>>>> Found by Linux File System Verification project (linuxtesting.org).
>>>>>
>>>>> Reported-by: Andrey Tsyvarev <tsyvarev@ispras.ru>
>>>>> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
>>>>> ---
>>>>>   fs/f2fs/checkpoint.c |  6 ++++++
>>>>>   fs/f2fs/f2fs.h       |  1 +
>>>>>   fs/f2fs/segment.c    | 17 +++++++++++++++--
>>>>>   3 files changed, 22 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
>>>>> index 4aa521a..890e23d 100644
>>>>> --- a/fs/f2fs/checkpoint.c
>>>>> +++ b/fs/f2fs/checkpoint.c
>>>>> @@ -762,6 +762,12 @@ static void do_checkpoint(struct f2fs_sb_info *sbi,
>>>>> bool is_umount)
>>>>>   	void *kaddr;
>>>>>   	int i;
>>>>>   
>>>>> +	/*
>>>>> +	 * This avoids to conduct wrong roll-forward operations and uses
>>>>> +	 * metapages, so should be called prior to sync_meta_pages below.
>>>>> +	 */
>>>>> +	discard_next_dnode(sbi);
>>>>> +
>>>>>   	/* Flush all the NAT/SIT pages */
>>>>>   	while (get_pages(sbi, F2FS_DIRTY_META))
>>>>>   		sync_meta_pages(sbi, META, LONG_MAX);
>>>>> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
>>>>> index 2ecac83..2c5a5da 100644
>>>>> --- a/fs/f2fs/f2fs.h
>>>>> +++ b/fs/f2fs/f2fs.h
>>>>> @@ -1179,6 +1179,7 @@ int f2fs_issue_flush(struct f2fs_sb_info *);
>>>>>   void invalidate_blocks(struct f2fs_sb_info *, block_t);
>>>>>   void refresh_sit_entry(struct f2fs_sb_info *, block_t, block_t);
>>>>>   void clear_prefree_segments(struct f2fs_sb_info *);
>>>>> +void discard_next_dnode(struct f2fs_sb_info *);
>>>>>   int npages_for_summary_flush(struct f2fs_sb_info *);
>>>>>   void allocate_new_segments(struct f2fs_sb_info *);
>>>>>   struct page *get_sum_page(struct f2fs_sb_info *, unsigned int);
>>>>> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
>>>>> index 1e264e7..9993f94 100644
>>>>> --- a/fs/f2fs/segment.c
>>>>> +++ b/fs/f2fs/segment.c
>>>>> @@ -335,13 +335,26 @@ static void locate_dirty_segment(struct
>>>>> f2fs_sb_info *sbi, unsigned int segno)
>>>>>   	mutex_unlock(&dirty_i->seglist_lock);
>>>>>   }
>>>>>   
>>>>> -static void f2fs_issue_discard(struct f2fs_sb_info *sbi,
>>>>> +static int f2fs_issue_discard(struct f2fs_sb_info *sbi,
>>>>>   				block_t blkstart, block_t blklen)
>>>>>   {
>>>>>   	sector_t start = SECTOR_FROM_BLOCK(sbi, blkstart);
>>>>>   	sector_t len = SECTOR_FROM_BLOCK(sbi, blklen);
>>>>> -	blkdev_issue_discard(sbi->sb->s_bdev, start, len, GFP_NOFS, 0);
>>>>>   	trace_f2fs_issue_discard(sbi->sb, blkstart, blklen);
>>>>> +	return blkdev_issue_discard(sbi->sb->s_bdev, start, len, GFP_NOFS, 0);
>>>>> +}
>>>>> +
>>>>> +void discard_next_dnode(struct f2fs_sb_info *sbi)
>>>>> +{
>>>>> +	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_WARM_NODE);
>>>>> +	block_t blkaddr = NEXT_FREE_BLKADDR(sbi, curseg);
>>>>> +
>>>>> +	if (f2fs_issue_discard(sbi, blkaddr, 1)) {
>>>>> +		struct page *page = grab_meta_page(sbi, blkaddr);
>>>>> +		/* zero-filled page */
>>>>> +		set_page_dirty(page);
>>>>> +		f2fs_put_page(page, 1);
>>>>> +	}
>>>>>   }
>>>>>   
>>>>>   static void add_discard_addrs(struct f2fs_sb_info *sbi,
>>

