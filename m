Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbaLFS63 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 13:58:29 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:40234 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaLFS61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 13:58:27 -0500
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Monakhov <dmonakhov@openvz.org>
Subject: next-20141204 crashing on ext4_fill_super()
Date: Sat, 06 Dec 2014 16:58:22 -0200
Message-ID: <2144577.XOl86X9GoH@laptop>
User-Agent: KMail/4.13.3 (Linux/3.13.0-40-generic; KDE/4.13.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, everyone.

next-20141204 started crashing on my laptop with the following error right 
after I enter my disk encryption password:

http://opsfelder.com/~murilo/lkml/next-20141204_crash.jpg

The previous version next-20141203 was working just fine.  next-20141205 is 
also crashing.

Git-bisect pointed me to the commit [1] 
d0079b903022160fee1d673a3c1f3154c84385eb "ext4: 
ext4_da_convert_inline_data_to_extent drop locked page after error".

I tried reverting it from next-20141204 but got no luck.

I'd be happy if someone can help me getting this fixed.

Thanks in advance.

[1]
commit d0079b903022160fee1d673a3c1f3154c84385eb
Author: Dmitry Monakhov <dmonakhov@openvz.org>
Date:   Tue Dec 2 18:46:20 2014 -0500

    ext4: ext4_da_convert_inline_data_to_extent drop locked page after error

    Testcase:
    xfstests generic/270
    MKFS_OPTIONS="-q -I 256 -O inline_data,64bit"

    Call Trace:
     [<ffffffff81144c76>] lock_page+0x35/0x39 -------> DEADLOCK
     [<ffffffff81145260>] pagecache_get_page+0x65/0x15a
     [<ffffffff811507fc>] truncate_inode_pages_range+0x1db/0x45c
     [<ffffffff8120ea63>] ? ext4_da_get_block_prep+0x439/0x4b6
     [<ffffffff811b29b7>] ? __block_write_begin+0x284/0x29c
     [<ffffffff8120e62a>] ? ext4_change_inode_journal_flag+0x16b/0x16b
     [<ffffffff81150af0>] truncate_inode_pages+0x12/0x14
     [<ffffffff81247cb4>] ext4_truncate_failed_write+0x19/0x25
     [<ffffffff812488cf>] ext4_da_write_inline_data_begin+0x196/0x31c
     [<ffffffff81210dad>] ext4_da_write_begin+0x189/0x302
     [<ffffffff810c07ac>] ? trace_hardirqs_on+0xd/0xf
     [<ffffffff810ddd13>] ? read_seqcount_begin.clone.1+0x9f/0xcc
     [<ffffffff8114309d>] generic_perform_write+0xc7/0x1c6
     [<ffffffff810c040e>] ? mark_held_locks+0x59/0x77
     [<ffffffff811445d1>] __generic_file_write_iter+0x17f/0x1c5
     [<ffffffff8120726b>] ext4_file_write_iter+0x2a5/0x354
     [<ffffffff81185656>] ? file_start_write+0x2a/0x2c
     [<ffffffff8107bcdb>] ? bad_area_nosemaphore+0x13/0x15
     [<ffffffff811858ce>] new_sync_write+0x8a/0xb2
     [<ffffffff81186e7b>] vfs_write+0xb5/0x14d
     [<ffffffff81186ffb>] SyS_write+0x5c/0x8c
     [<ffffffff816f2529>] system_call_fastpath+0x12/0x17

    Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

-- 
Murilo
