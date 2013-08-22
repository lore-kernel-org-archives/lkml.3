Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab3HVFnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 01:43:31 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:46195 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab3HVFn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 01:43:29 -0400
Date: Wed, 21 Aug 2013 22:43:36 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Subject: Re: bcache: Fix a writeback performance regression
Message-ID: <20130822054336.GA14935@kmo-pixel>
References: <20130814225904.GA6427@kmo-pixel>
 <520C788A.1060208@profihost.ag>
 <520DFAB4.1050402@profihost.ag>
 <52114614.4070509@profihost.ag>
 <20130819222718.GA32104@kmo-pixel>
 <52132243.8050803@profihost.ag>
 <521323D1.1070503@profihost.ag>
 <20130821234715.GA4630@moria.home.lan>
 <5215A130.9080508@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5215A130.9080508@profihost.ag>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 07:27:12AM +0200, Stefan Priebe wrote:
> today i had this one:

Heh, I finally tracked it down earlier today. Turned out to be a rather
embarassing bug... schedule_timeout() is not the same as
schedule_timeout_interruptible().

I'll get the fix out in the morning, for the moment an easy workaround
is to set writeback_percent to 0.

> 
> 2013-08-22 06:28:55     [<ffffffff815247f4>] schedule+0x24/0x70
> 2013-08-22 06:28:55     [<ffffffff815248c7>] io_schedule+0x87/0xd0
> 2013-08-22 06:28:55     [<ffffffff810e6099>] sleep_on_page+0x9/0x10
> 2013-08-22 06:28:55     [<ffffffff81522dc7>] __wait_on_bit+0x57/0x80
> 2013-08-22 06:28:55     [<ffffffff810e5bbc>] ? find_get_pages_tag+0xcc/0x180
> 2013-08-22 06:28:55     [<ffffffff810e62ae>] wait_on_page_bit+0x6e/0x80
> 2013-08-22 06:28:55     [<ffffffff81070af0>] ?
> autoremove_wake_function+0x40/0x40
> 2013-08-22 06:28:55     [<ffffffff810f2660>] ? pagevec_lookup_tag+0x20/0x30
> 2013-08-22 06:28:55     [<ffffffff810e67ef>]
> filemap_fdatawait_range+0x10f/0x1b0
> 2013-08-22 06:28:55     [<ffffffff810e69b0>]
> filemap_write_and_wait_range+0x90/0xa0
> 2013-08-22 06:28:55     [<ffffffff811ef9c3>] xfs_file_fsync+0x63/0x1e0
> 2013-08-22 06:28:55     [<ffffffff8116d7c3>] vfs_fsync_range+0x23/0x30
> 2013-08-22 06:28:55     [<ffffffff8116d7e7>] vfs_fsync+0x17/0x20
> 2013-08-22 06:28:55     [<ffffffff8116da1c>] do_fsync+0x3c/0x60
> 2013-08-22 06:28:55     [<ffffffff8116da4e>] SyS_fdatasync+0xe/0x20
> 2013-08-22 06:28:55     [<ffffffff81526a92>] system_call_fastpath+0x16/0x1b
> 2013-08-22 06:28:54     [<ffffffff815247f4>] schedule+0x24/0x70
> 2013-08-22 06:28:54     [<ffffffff815248c7>] io_schedule+0x87/0xd0
> 2013-08-22 06:28:54     [<ffffffff810e6099>] sleep_on_page+0x9/0x10
> 2013-08-22 06:28:54     [<ffffffff81522dc7>] __wait_on_bit+0x57/0x80
> 2013-08-22 06:28:54     [<ffffffff810e5bbc>] ? find_get_pages_tag+0xcc/0x180
> 2013-08-22 06:28:54     [<ffffffff810e62ae>] wait_on_page_bit+0x6e/0x80
> 2013-08-22 06:28:54     [<ffffffff81070af0>] ?
> autoremove_wake_function+0x40/0x40
> 2013-08-22 06:28:54     [<ffffffff810f2660>] ? pagevec_lookup_tag+0x20/0x30
> 2013-08-22 06:28:54     [<ffffffff810e67ef>]
> filemap_fdatawait_range+0x10f/0x1b0
> 2013-08-22 06:28:54     [<ffffffff810e69b0>]
> filemap_write_and_wait_range+0x90/0xa0
> 2013-08-22 06:28:54     [<ffffffff811ef9c3>] xfs_file_fsync+0x63/0x1e0
> 2013-08-22 06:28:54     [<ffffffff8116d7c3>] vfs_fsync_range+0x23/0x30
> 2013-08-22 06:28:54     [<ffffffff8116d7e7>] vfs_fsync+0x17/0x20
> 2013-08-22 06:28:54     [<ffffffff8116da1c>] do_fsync+0x3c/0x60
> 2013-08-22 06:28:54     [<ffffffff8116da6b>] SyS_fsync+0xb/0x10
> 2013-08-22 06:28:54     [<ffffffff81526a92>] system_call_fastpath+0x16/0x1b
> 2013-08-22 06:28:54     INFO: task ceph-osd:3520 blocked for more
> than 120 seconds.
> 2013-08-22 06:28:54     "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> 2013-08-22 06:28:54     ceph-osd D ffffffff8160f760 0 3520 1 0x00000004
> 2013-08-22 06:28:54     ffff880c381d5c78 0000000000000086
> ffff880c381d5fd8 0000000000012c80
> 2013-08-22 06:28:54     ffff880c381d4010 0000000000012c80
> 0000000000012c80 0000000000012c80
> 2013-08-22 06:28:54     ffff880c381d5fd8 0000000000012c80
> ffff880c39100000 ffff880c48dd0000
> 2013-08-22 06:28:54     Call Trace:
> 2013-08-22 06:28:54     [<ffffffff810e6090>] ? __lock_page+0x70/0x70
> 2013-08-22 06:28:53     [<ffffffff810e5bbc>] ? find_get_pages_tag+0xcc/0x180
> 2013-08-22 06:28:53     [<ffffffff810e62ae>] wait_on_page_bit+0x6e/0x80
> 2013-08-22 06:28:53     [<ffffffff81070af0>] ?
> autoremove_wake_function+0x40/0x40
> 2013-08-22 06:28:53     [<ffffffff810f2660>] ? pagevec_lookup_tag+0x20/0x30
> 2013-08-22 06:28:53     [<ffffffff810e67ef>]
> filemap_fdatawait_range+0x10f/0x1b0
> 2013-08-22 06:28:53     [<ffffffff815247f4>] ? schedule+0x24/0x70
> 2013-08-22 06:28:53     [<ffffffff81522b3d>] ? schedule_timeout+0x16d/0x200
> 2013-08-22 06:28:53     [<ffffffff81068e9a>] ?
> __queue_delayed_work+0xaa/0x1a0
> 2013-08-22 06:28:53     [<ffffffff81068cf9>] ?
> try_to_grab_pending+0x109/0x190
> 2013-08-22 06:28:53     [<ffffffff810e68b3>] filemap_fdatawait+0x23/0x30
> 2013-08-22 06:28:53     [<ffffffff81166e35>] wait_sb_inodes+0xb5/0x110
> 2013-08-22 06:28:53     [<ffffffff81167a1c>] sync_inodes_sb+0x9c/0xd0
> 2013-08-22 06:28:53     [<ffffffff8116dc66>] __sync_filesystem+0x16/0x50
> 2013-08-22 06:28:53     [<ffffffff8116dce3>] sync_filesystem+0x43/0x60
> 2013-08-22 06:28:53     [<ffffffff8116dd50>] SyS_syncfs+0x50/0x90
> 2013-08-22 06:28:53     [<ffffffff81526a92>] system_call_fastpath+0x16/0x1b
> 2013-08-22 06:28:53     INFO: task ceph-osd:3516 blocked for more
> than 120 seconds.
> 2013-08-22 06:28:53     "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> 2013-08-22 06:28:53     ceph-osd D ffffffff8160f760 0 3516 1 0x00000004
> 2013-08-22 06:28:53     ffff880c383d3c78 0000000000000086
> ffff880c383d3fd8 0000000000012c80
> 2013-08-22 06:28:53     ffff880c383d2010 0000000000012c80
> 0000000000012c80 0000000000012c80
> 2013-08-22 06:28:53     ffff880c383d3fd8 0000000000012c80
> ffff880c428018e0 ffff880c48dd0000
> 2013-08-22 06:28:53     Call Trace:
> 2013-08-22 06:28:53     [<ffffffff810e6090>] ? __lock_page+0x70/0x70
> 2013-08-22 06:28:52     [<ffffffff81219983>] ? xfs_bmbt_get_all+0x13/0x20
> 2013-08-22 06:28:52     [<ffffffff81208a14>] xfs_attr_set_int+0x3a4/0x4f0
> 2013-08-22 06:28:52     [<ffffffff81208be1>] xfs_attr_set+0x81/0x90
> 2013-08-22 06:28:52     [<ffffffff81201462>] xfs_xattr_set+0x42/0x60
> 2013-08-22 06:28:52     [<ffffffff8116257b>] generic_setxattr+0x9b/0xb0
> 2013-08-22 06:28:52     [<ffffffff8116376f>] __vfs_setxattr_noperm+0x5f/0xe0
> 2013-08-22 06:28:52     [<ffffffff811638a4>] vfs_setxattr+0xb4/0xc0
> 2013-08-22 06:28:52     [<ffffffff8116396e>] setxattr+0xbe/0x200
> 2013-08-22 06:28:52     [<ffffffff81143261>] ? __sb_start_write+0x71/0x110
> 2013-08-22 06:28:52     [<ffffffff8115ce51>] ?
> __mnt_want_write_file+0x61/0x80
> 2013-08-22 06:28:52     [<ffffffff81163b56>] SyS_fsetxattr+0xa6/0xc0
> 2013-08-22 06:28:52     [<ffffffff81526a92>] system_call_fastpath+0x16/0x1b
> 2013-08-22 06:28:52     INFO: task ceph-osd:3508 blocked for more
> than 120 seconds.
> 2013-08-22 06:28:52     "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> 2013-08-22 06:28:52     ceph-osd D ffffffff8160f760 0 3508 1 0x00000004
> 2013-08-22 06:28:52     ffff880c2c1bfc28 0000000000000086
> ffff880c2c1bffd8 0000000000012c80
> 2013-08-22 06:28:52     ffff880c2c1be010 0000000000012c80
> 0000000000012c80 0000000000012c80
> 2013-08-22 06:28:52     ffff880c2c1bffd8 0000000000012c80
> ffff880c43eae380 ffff880c48dd4aa0
> 2013-08-22 06:28:52     Call Trace:
> 2013-08-22 06:28:52     [<ffffffff810e6090>] ? __lock_page+0x70/0x70
> 2013-08-22 06:28:52     [<ffffffff815247f4>] schedule+0x24/0x70
> 2013-08-22 06:28:52     [<ffffffff815248c7>] io_schedule+0x87/0xd0
> 2013-08-22 06:28:52     [<ffffffff810e6099>] sleep_on_page+0x9/0x10
> 2013-08-22 06:28:52     [<ffffffff81522dc7>] __wait_on_bit+0x57/0x80
> 2013-08-22 06:28:51     [<ffffffff81526a92>] system_call_fastpath+0x16/0x1b
> 2013-08-22 06:28:51     INFO: task ceph-osd:3467 blocked for more
> than 120 seconds.
> 2013-08-22 06:28:51     "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> 2013-08-22 06:28:51     ceph-osd D ffffffff8160f760 0 3467 1 0x00000004
> 2013-08-22 06:28:51     ffff880c375657e8 0000000000000086
> ffff880c37565fd8 0000000000012c80
> 2013-08-22 06:28:51     ffff880c37564010 0000000000012c80
> 0000000000012c80 0000000000012c80
> 2013-08-22 06:28:51     ffff880c37565fd8 0000000000012c80
> ffff880c3850caa0 ffff880c48dd4aa0
> 2013-08-22 06:28:51     Call Trace:
> 2013-08-22 06:28:51     [<ffffffff81245efe>] ? xlog_bdstrat+0x1e/0x60
> 2013-08-22 06:28:51     [<ffffffff815247f4>] schedule+0x24/0x70
> 2013-08-22 06:28:51     [<ffffffff81522b3d>] schedule_timeout+0x16d/0x200
> 2013-08-22 06:28:51     [<ffffffff8124653d>] ? xlog_sync+0x2ed/0x490
> 2013-08-22 06:28:51     [<ffffffff81523b7a>] __down+0x6a/0xa0
> 2013-08-22 06:28:51     [<ffffffff811eb747>] ? _xfs_buf_find+0x107/0x290
> 2013-08-22 06:28:51     [<ffffffff810757ac>] down+0x3c/0x50
> 2013-08-22 06:28:51     [<ffffffff811eb070>] xfs_buf_lock+0x40/0xe0
> 2013-08-22 06:28:51     [<ffffffff811eb747>] _xfs_buf_find+0x107/0x290
> 2013-08-22 06:28:51     [<ffffffff811ebb1f>] xfs_buf_get_map+0x2f/0x180
> 2013-08-22 06:28:51     [<ffffffff8124dc68>]
> xfs_trans_get_buf_map+0xc8/0x160
> 2013-08-22 06:28:51     [<ffffffff81224093>] xfs_da_get_buf+0xb3/0xe0
> 2013-08-22 06:28:51     [<ffffffff81209b20>]
> xfs_attr3_leaf_to_node+0xb0/0x240
> 2013-08-22 06:28:51     [<ffffffff8120d12b>] ?
> xfs_attr3_leaf_add+0x15b/0x1c0
> 2013-08-22 06:28:51     [<ffffffff8120843c>]
> xfs_attr_leaf_addname+0x14c/0x380
> 2013-08-22 06:28:51     [<ffffffff81243f68>] ? xfs_trans_add_item+0x28/0x70
> 2013-08-22 06:28:50     [<ffffffff810e8420>] ? mempool_alloc_slab+0x10/0x20
> 2013-08-22 06:28:50     [<ffffffff815239c2>] ? down_read+0x12/0x20
> 2013-08-22 06:28:50     [<ffffffffa010c38a>]
> request_write+0x8a/0x380 [bcache]
> 2013-08-22 06:28:50     [<ffffffffa010c8fb>]
> cached_dev_make_request+0x27b/0x350 [bcache]
> 2013-08-22 06:28:50     [<ffffffff81281982>] generic_make_request+0xc2/0x100
> 2013-08-22 06:28:50     [<ffffffff81281a27>] submit_bio+0x67/0x130
> 2013-08-22 06:28:50     [<ffffffff811e823f>] xfs_submit_ioend_bio+0x2f/0x40
> 2013-08-22 06:28:50     [<ffffffff811e8314>] xfs_submit_ioend+0xc4/0x130
> 2013-08-22 06:28:50     [<ffffffff811e98bb>] xfs_vm_writepage+0x2eb/0x590
> 2013-08-22 06:28:50     [<ffffffff810ef752>] __writepage+0x12/0x40
> 2013-08-22 06:28:50     [<ffffffff810f090b>] write_cache_pages+0x23b/0x4e0
> 2013-08-22 06:28:50     [<ffffffff81524437>] ? __schedule+0x3d7/0x6d0
> 2013-08-22 06:28:50     [<ffffffff810ef740>] ? set_page_dirty+0x60/0x60
> 2013-08-22 06:28:50     [<ffffffff810f0bfc>] generic_writepages+0x4c/0x70
> 2013-08-22 06:28:50     [<ffffffff811e810f>] xfs_vm_writepages+0x4f/0x60
> 2013-08-22 06:28:50     [<ffffffff810f0c3b>] do_writepages+0x1b/0x40
> 2013-08-22 06:28:50     [<ffffffff810e6911>]
> __filemap_fdatawrite_range+0x51/0x60
> 2013-08-22 06:28:50     [<ffffffff81097cf0>] ? futex_wake+0x110/0x120
> 2013-08-22 06:28:50     [<ffffffff810e699a>]
> filemap_write_and_wait_range+0x7a/0xa0
> 2013-08-22 06:28:50     [<ffffffff811ef9c3>] xfs_file_fsync+0x63/0x1e0
> 2013-08-22 06:28:50     [<ffffffff8116d7c3>] vfs_fsync_range+0x23/0x30
> 2013-08-22 06:28:50     [<ffffffff8116d7e7>] vfs_fsync+0x17/0x20
> 2013-08-22 06:28:50     [<ffffffff8116da1c>] do_fsync+0x3c/0x60
> 2013-08-22 06:28:50     [<ffffffff8116da4e>] SyS_fdatasync+0xe/0x20
> 2013-08-22 06:28:49     [<ffffffff810ef740>] ? set_page_dirty+0x60/0x60
> 2013-08-22 06:28:49     [<ffffffff810f0bfc>] generic_writepages+0x4c/0x70
> 2013-08-22 06:28:49     [<ffffffff811639a3>] ? setxattr+0xf3/0x200
> 2013-08-22 06:28:49     [<ffffffff811e810f>] xfs_vm_writepages+0x4f/0x60
> 2013-08-22 06:28:49     [<ffffffff810f0c3b>] do_writepages+0x1b/0x40
> 2013-08-22 06:28:49     [<ffffffff810e6911>]
> __filemap_fdatawrite_range+0x51/0x60
> 2013-08-22 06:28:49     [<ffffffff810e699a>]
> filemap_write_and_wait_range+0x7a/0xa0
> 2013-08-22 06:28:49     [<ffffffff811ef9c3>] xfs_file_fsync+0x63/0x1e0
> 2013-08-22 06:28:49     [<ffffffff8116d7c3>] vfs_fsync_range+0x23/0x30
> 2013-08-22 06:28:49     [<ffffffff8116d7e7>] vfs_fsync+0x17/0x20
> 2013-08-22 06:28:49     [<ffffffff8116da1c>] do_fsync+0x3c/0x60
> 2013-08-22 06:28:49     [<ffffffff8116da6b>] SyS_fsync+0xb/0x10
> 2013-08-22 06:28:49     [<ffffffff81526a92>] system_call_fastpath+0x16/0x1b
> 2013-08-22 06:28:49     INFO: task ceph-osd:3483 blocked for more
> than 120 seconds.
> 2013-08-22 06:28:49     "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> 2013-08-22 06:28:49     ceph-osd D ffffffff8160f760 0 3483 1 0x00000004
> 2013-08-22 06:28:49     ffff880c2c0d1910 0000000000000086
> ffff880c2c0d1fd8 0000000000012c80
> 2013-08-22 06:28:49     ffff880c2c0d0010 0000000000012c80
> 0000000000012c80 0000000000012c80
> 2013-08-22 06:28:49     ffff880c2c0d1fd8 0000000000012c80
> ffff880c3a14caa0 ffff880c48dd31c0
> 2013-08-22 06:28:49     Call Trace:
> 2013-08-22 06:28:49     [<ffffffff815247f4>] schedule+0x24/0x70
> 2013-08-22 06:28:49     [<ffffffff81525cfd>]
> rwsem_down_read_failed+0x9d/0xe5
> 2013-08-22 06:28:49     [<ffffffff812aa024>]
> call_rwsem_down_read_failed+0x14/0x30
> 2013-08-22 06:28:48     [<ffffffff81143261>] ? __sb_start_write+0x71/0x110
> 2013-08-22 06:28:48     [<ffffffff8115ce51>] ?
> __mnt_want_write_file+0x61/0x80
> 2013-08-22 06:28:48     [<ffffffff81163b56>] SyS_fsetxattr+0xa6/0xc0
> 2013-08-22 06:28:48     [<ffffffff81526a92>] system_call_fastpath+0x16/0x1b
> 2013-08-22 06:28:48     INFO: task ceph-osd:3482 blocked for more
> than 120 seconds.
> 2013-08-22 06:28:48     "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> 2013-08-22 06:28:48     ceph-osd D ffffffff8160f760 0 3482 1 0x00000004
> 2013-08-22 06:28:48     ffff880c2c0cf910 0000000000000086
> ffff880c2c0cffd8 0000000000012c80
> 2013-08-22 06:28:48     ffff880c2c0ce010 0000000000012c80
> 0000000000012c80 0000000000012c80
> 2013-08-22 06:28:48     ffff880c2c0cffd8 0000000000012c80
> ffff880c47768000 ffff880c48dd0000
> 2013-08-22 06:28:48     Call Trace:
> 2013-08-22 06:28:48     [<ffffffff815247f4>] schedule+0x24/0x70
> 2013-08-22 06:28:48     [<ffffffff81525cfd>]
> rwsem_down_read_failed+0x9d/0xe5
> 2013-08-22 06:28:48     [<ffffffff812aa024>]
> call_rwsem_down_read_failed+0x14/0x30
> 2013-08-22 06:28:48     [<ffffffff810e8420>] ? mempool_alloc_slab+0x10/0x20
> 2013-08-22 06:28:48     [<ffffffff815239c2>] ? down_read+0x12/0x20
> 2013-08-22 06:28:48     [<ffffffffa010c38a>]
> request_write+0x8a/0x380 [bcache]
> 2013-08-22 06:28:48     [<ffffffffa010c8fb>]
> cached_dev_make_request+0x27b/0x350 [bcache]
> 2013-08-22 06:28:48     [<ffffffff81281982>] generic_make_request+0xc2/0x100
> 2013-08-22 06:28:48     [<ffffffff81281a27>] submit_bio+0x67/0x130
> 2013-08-22 06:28:48     [<ffffffff811e823f>] xfs_submit_ioend_bio+0x2f/0x40
> 2013-08-22 06:28:48     [<ffffffff811e833e>] xfs_submit_ioend+0xee/0x130
> 2013-08-22 06:28:48     [<ffffffff811e98bb>] xfs_vm_writepage+0x2eb/0x590
> 2013-08-22 06:28:48     [<ffffffff810ef752>] __writepage+0x12/0x40
> 2013-08-22 06:28:48     [<ffffffff810f090b>] write_cache_pages+0x23b/0x4e0
> 2013-08-22 06:28:47     [<ffffffff812469b6>] _xfs_log_force+0x116/0x250
> 2013-08-22 06:28:47     [<ffffffff8124836a>] xfs_log_force+0x2a/0x90
> 2013-08-22 06:28:47     [<ffffffff811eb747>] ? _xfs_buf_find+0x107/0x290
> 2013-08-22 06:28:47     [<ffffffff811eb0a3>] xfs_buf_lock+0x73/0xe0
> 2013-08-22 06:28:47     [<ffffffff811eb747>] _xfs_buf_find+0x107/0x290
> 2013-08-22 06:28:47     [<ffffffff811ebb1f>] xfs_buf_get_map+0x2f/0x180
> 2013-08-22 06:28:47     [<ffffffff8124dc68>]
> xfs_trans_get_buf_map+0xc8/0x160
> 2013-08-22 06:28:47     [<ffffffff81224093>] xfs_da_get_buf+0xb3/0xe0
> 2013-08-22 06:28:47     [<ffffffff81209b20>]
> xfs_attr3_leaf_to_node+0xb0/0x240
> 2013-08-22 06:28:47     [<ffffffff8120d12b>] ?
> xfs_attr3_leaf_add+0x15b/0x1c0
> 2013-08-22 06:28:47     [<ffffffff8120843c>]
> xfs_attr_leaf_addname+0x14c/0x380
> 2013-08-22 06:28:47     [<ffffffff81243f68>] ? xfs_trans_add_item+0x28/0x70
> 2013-08-22 06:28:47     [<ffffffff81219983>] ? xfs_bmbt_get_all+0x13/0x20
> 2013-08-22 06:28:47     [<ffffffff81208a14>] xfs_attr_set_int+0x3a4/0x4f0
> 2013-08-22 06:28:47     [<ffffffff81208be1>] xfs_attr_set+0x81/0x90
> 2013-08-22 06:28:47     [<ffffffff81201462>] xfs_xattr_set+0x42/0x60
> 2013-08-22 06:28:47     [<ffffffff8116257b>] generic_setxattr+0x9b/0xb0
> 2013-08-22 06:28:47     [<ffffffff8116376f>] __vfs_setxattr_noperm+0x5f/0xe0
> 2013-08-22 06:28:47     [<ffffffff811638a4>] vfs_setxattr+0xb4/0xc0
> 2013-08-22 06:28:47     [<ffffffff8116396e>] setxattr+0xbe/0x200
> 2013-08-22 06:28:47     [<ffffffff811ec1ca>] xfs_buf_iorequest+0x4a/0xa0
> 2013-08-22 06:28:47     [<ffffffff81245efe>] xlog_bdstrat+0x1e/0x60
> 2013-08-22 06:28:47     [<ffffffff8124653d>] xlog_sync+0x2ed/0x490
> 2013-08-22 06:28:47     [<ffffffff8124686b>]
> xlog_state_release_iclog+0x8b/0xc0
> 2013-08-22 06:28:46     [<ffffffff8116dd50>] SyS_syncfs+0x50/0x90
> 2013-08-22 06:28:46     [<ffffffff81526a92>] system_call_fastpath+0x16/0x1b
> 2013-08-22 06:28:46     INFO: task ceph-osd:3481 blocked for more
> than 120 seconds.
> 2013-08-22 06:28:46     "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> 2013-08-22 06:28:46     ceph-osd D ffffffff8160f760 0 3481 1 0x00000004
> 2013-08-22 06:28:46     ffff880c2c0cd500 0000000000000086
> ffff880c2c0cdfd8 0000000000012c80
> 2013-08-22 06:28:46     ffff880c2c0cc010 0000000000012c80
> 0000000000012c80 0000000000012c80
> 2013-08-22 06:28:46     ffff880c2c0cdfd8 0000000000012c80
> ffff880c4776b1c0 ffff880c48dd4aa0
> 2013-08-22 06:28:46     Call Trace:
> 2013-08-22 06:28:46     [<ffffffff8124e5b6>] ? xfs_trans_brelse+0xb6/0x100
> 2013-08-22 06:28:46     [<ffffffff815247f4>] schedule+0x24/0x70
> 2013-08-22 06:28:46     [<ffffffff81525cfd>]
> rwsem_down_read_failed+0x9d/0xe5
> 2013-08-22 06:28:46     [<ffffffff812aa024>]
> call_rwsem_down_read_failed+0x14/0x30
> 2013-08-22 06:28:46     [<ffffffff810e8420>] ? mempool_alloc_slab+0x10/0x20
> 2013-08-22 06:28:46     [<ffffffff815239c2>] ? down_read+0x12/0x20
> 2013-08-22 06:28:46     [<ffffffffa010c38a>]
> request_write+0x8a/0x380 [bcache]
> 2013-08-22 06:28:46     [<ffffffffa010c8fb>]
> cached_dev_make_request+0x27b/0x350 [bcache]
> 2013-08-22 06:28:46     [<ffffffff81281982>] generic_make_request+0xc2/0x100
> 2013-08-22 06:28:46     [<ffffffff81281a27>] submit_bio+0x67/0x130
> 2013-08-22 06:28:46     [<ffffffff811eabf0>] xfs_buf_ioapply_map+0x180/0x1d0
> 2013-08-22 06:28:46     [<ffffffff811ead47>] _xfs_buf_ioapply+0x107/0x150
> 2013-08-22 06:28:46     [<ffffffff81245efe>] ? xlog_bdstrat+0x1e/0x60
> 2013-08-22 06:28:45     "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> 2013-08-22 06:28:45     ceph-osd D ffffffff8160f760 0 3462 1 0x00000004
> 2013-08-22 06:28:45     ffff880c375cdc28 0000000000000086
> ffff880c375cdfd8 0000000000012c80
> 2013-08-22 06:28:45     ffff880c375cc010 0000000000012c80
> 0000000000012c80 0000000000012c80
> 2013-08-22 06:28:45     ffff880c375cdfd8 0000000000012c80
> ffff880c46318000 ffff880c48dd6380
> 2013-08-22 06:28:45     Call Trace:
> 2013-08-22 06:28:45     [<ffffffff810e6090>] ? __lock_page+0x70/0x70
> 2013-08-22 06:28:45     [<ffffffff815247f4>] schedule+0x24/0x70
> 2013-08-22 06:28:45     [<ffffffff815248c7>] io_schedule+0x87/0xd0
> 2013-08-22 06:28:45     [<ffffffff810e6099>] sleep_on_page+0x9/0x10
> 2013-08-22 06:28:45     [<ffffffff81522dc7>] __wait_on_bit+0x57/0x80
> 2013-08-22 06:28:45     [<ffffffff810e5bbc>] ? find_get_pages_tag+0xcc/0x180
> 2013-08-22 06:28:45     [<ffffffff810e62ae>] wait_on_page_bit+0x6e/0x80
> 2013-08-22 06:28:45     [<ffffffff81070af0>] ?
> autoremove_wake_function+0x40/0x40
> 2013-08-22 06:28:45     [<ffffffff810f2660>] ? pagevec_lookup_tag+0x20/0x30
> 2013-08-22 06:28:45     [<ffffffff810e67ef>]
> filemap_fdatawait_range+0x10f/0x1b0
> 2013-08-22 06:28:45     [<ffffffff815247f4>] ? schedule+0x24/0x70
> 2013-08-22 06:28:45     [<ffffffff81522b3d>] ? schedule_timeout+0x16d/0x200
> 2013-08-22 06:28:45     [<ffffffff81068e9a>] ?
> __queue_delayed_work+0xaa/0x1a0
> 2013-08-22 06:28:45     [<ffffffff810e68b3>] filemap_fdatawait+0x23/0x30
> 2013-08-22 06:28:45     [<ffffffff81166e35>] wait_sb_inodes+0xb5/0x110
> 2013-08-22 06:28:45     [<ffffffff81167a1c>] sync_inodes_sb+0x9c/0xd0
> 2013-08-22 06:28:45     [<ffffffff8116dc66>] __sync_filesystem+0x16/0x50
> 2013-08-22 06:28:45     [<ffffffff8116dce3>] sync_filesystem+0x43/0x60
> 2013-08-22 06:28:44     [<ffffffffa010c8fb>]
> cached_dev_make_request+0x27b/0x350 [bcache]
> 2013-08-22 06:28:44     [<ffffffff81281982>] generic_make_request+0xc2/0x100
> 2013-08-22 06:28:44     [<ffffffff81281a27>] submit_bio+0x67/0x130
> 2013-08-22 06:28:44     [<ffffffff811e823f>] xfs_submit_ioend_bio+0x2f/0x40
> 2013-08-22 06:28:44     [<ffffffff811e833e>] xfs_submit_ioend+0xee/0x130
> 2013-08-22 06:28:44     [<ffffffff811e98bb>] xfs_vm_writepage+0x2eb/0x590
> 2013-08-22 06:28:44     [<ffffffff810ef752>] __writepage+0x12/0x40
> 2013-08-22 06:28:44     [<ffffffff810f090b>] write_cache_pages+0x23b/0x4e0
> 2013-08-22 06:28:44     [<ffffffff81524437>] ? __schedule+0x3d7/0x6d0
> 2013-08-22 06:28:44     [<ffffffff810ef740>] ? set_page_dirty+0x60/0x60
> 2013-08-22 06:28:44     [<ffffffff810f0bfc>] generic_writepages+0x4c/0x70
> 2013-08-22 06:28:44     [<ffffffff811e810f>] xfs_vm_writepages+0x4f/0x60
> 2013-08-22 06:28:44     [<ffffffff810f0c3b>] do_writepages+0x1b/0x40
> 2013-08-22 06:28:44     [<ffffffff810e6911>]
> __filemap_fdatawrite_range+0x51/0x60
> 2013-08-22 06:28:44     [<ffffffff81097cf0>] ? futex_wake+0x110/0x120
> 2013-08-22 06:28:44     [<ffffffff810e699a>]
> filemap_write_and_wait_range+0x7a/0xa0
> 2013-08-22 06:28:44     [<ffffffff811ef9c3>] xfs_file_fsync+0x63/0x1e0
> 2013-08-22 06:28:44     [<ffffffff8116d7c3>] vfs_fsync_range+0x23/0x30
> 2013-08-22 06:28:44     [<ffffffff8116d7e7>] vfs_fsync+0x17/0x20
> 2013-08-22 06:28:44     [<ffffffff8116da1c>] do_fsync+0x3c/0x60
> 2013-08-22 06:28:44     [<ffffffff8116da4e>] SyS_fdatasync+0xe/0x20
> 2013-08-22 06:28:44     [<ffffffff81526a92>] system_call_fastpath+0x16/0x1b
> 2013-08-22 06:28:44     INFO: task ceph-osd:3462 blocked for more
> than 120 seconds.
> 2013-08-22 06:28:43     INFO: task ceph-osd:24130 blocked for more
> than 120 seconds.
> 2013-08-22 06:28:43     "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> 2013-08-22 06:28:43     ceph-osd D ffffffff8160f760 0 24130 1 0x00000004
> 2013-08-22 06:28:43     ffff880c27fe98d8 0000000000000082
> ffff880c27fe9fd8 0000000000012c80
> 2013-08-22 06:28:43     ffff880c27fe8010 0000000000012c80
> 0000000000012c80 0000000000012c80
> 2013-08-22 06:28:43     ffff880c27fe9fd8 0000000000012c80
> ffff880c215e6380 ffff880c48decaa0
> 2013-08-22 06:28:43     Call Trace:
> 2013-08-22 06:28:43     [<ffffffff81170430>] ? __wait_on_buffer+0x30/0x30
> 2013-08-22 06:28:43     [<ffffffff815247f4>] schedule+0x24/0x70
> 2013-08-22 06:28:43     [<ffffffff815248c7>] io_schedule+0x87/0xd0
> 2013-08-22 06:28:43     [<ffffffff81170439>] sleep_on_buffer+0x9/0x10
> 2013-08-22 06:28:43     [<ffffffff81522dc7>] __wait_on_bit+0x57/0x80
> 2013-08-22 06:28:43     [<ffffffff81170430>] ? __wait_on_buffer+0x30/0x30
> 2013-08-22 06:28:43     [<ffffffff81522e63>]
> out_of_line_wait_on_bit+0x73/0x90
> 2013-08-22 06:28:43     [<ffffffff81070af0>] ?
> autoremove_wake_function+0x40/0x40
> 2013-08-22 06:28:43     [<ffffffff8116f64b>] ? submit_bh+0xb/0x10
> 2013-08-22 06:28:43     [<ffffffff81170426>] __wait_on_buffer+0x26/0x30
> 2013-08-22 06:28:43     [<ffffffff81172803>] __block_write_begin+0x383/0x530
> 2013-08-22 06:28:43     [<ffffffff811e9050>] ?
> xfs_get_blocks_direct+0x20/0x20
> 2013-08-22 06:28:43     [<ffffffff810e6d0f>] ?
> grab_cache_page_write_begin+0x9f/0xd0
> 2013-08-22 06:28:43     [<ffffffff811e802f>] xfs_vm_write_begin+0x5f/0xd0
> 2013-08-22 06:28:43     [<ffffffff810e55ba>]
> generic_perform_write+0xca/0x200
> 2013-08-22 06:28:43     [<ffffffff810e574f>]
> generic_file_buffered_write+0x5f/0x90
> 2013-08-22 06:28:43     [<ffffffff811f0275>]
> xfs_file_buffered_aio_write+0xf5/0x180
> 2013-08-22 06:28:43     [<ffffffff811f03ce>] xfs_file_aio_write+0xce/0x150
> 2013-08-22 06:28:43     [<ffffffff8114ac8d>] ? path_put+0x1d/0x30
> 2013-08-22 06:28:43     [<ffffffff81140788>] do_sync_readv_writev+0x68/0xa0
> 2013-08-22 06:28:43     [<ffffffff81142052>] do_readv_writev+0xf2/0x2e0
> 2013-08-22 06:28:43     [<ffffffff811f0300>] ?
> xfs_file_buffered_aio_write+0x180/0x180
> 2013-08-22 06:28:43     [<ffffffff811407c0>] ?
> do_sync_readv_writev+0xa0/0xa0
> 2013-08-22 06:28:43     [<ffffffff8114227e>] vfs_writev+0x3e/0x60
> 2013-08-22 06:28:43     [<ffffffff811423ca>] SyS_writev+0x5a/0xc0
> 2013-08-22 06:28:43     [<ffffffff811410d3>] ? SyS_lseek+0x53/0x80
> 2013-08-22 06:28:43     [<ffffffff81526a92>] system_call_fastpath+0x16/0x1b
> 2013-08-22 06:28:43     INFO: task ceph-osd:24134 blocked for more
> than 120 seconds.
> 2013-08-22 06:28:43     "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> 2013-08-22 06:28:43     ceph-osd D ffffffff8160f760 0 24134 1 0x00000004
> 2013-08-22 06:28:43     ffff880c23d31708 0000000000000082
> ffff880c23d31fd8 0000000000012c80
> 2013-08-22 06:28:43     ffff880c23d30010 0000000000012c80
> 0000000000012c80 0000000000012c80
> 2013-08-22 06:28:43     ffff880c23d31fd8 0000000000012c80
> ffff880c361e0000 ffff880c48dd4aa0
> 2013-08-22 06:28:43     Call Trace:
> 2013-08-22 06:28:43     [<ffffffff815247f4>] schedule+0x24/0x70
> 2013-08-22 06:28:43     [<ffffffff81524ae9>]
> schedule_preempt_disabled+0x9/0x10
> 2013-08-22 06:28:43     [<ffffffff81523664>]
> __mutex_lock_slowpath+0x194/0x240
> 2013-08-22 06:28:43     [<ffffffff81522e9e>] mutex_lock+0x1e/0x40
> 2013-08-22 06:28:43     [<ffffffffa00f891b>]
> bch_bucket_alloc_set+0x3b/0x80 [bcache]
> 2013-08-22 06:28:43     [<ffffffffa010ac1c>]
> bch_alloc_sectors+0x12c/0x4e0 [bcache]
> 2013-08-22 06:28:43     [<ffffffffa0104e15>] ?
> bch_generic_make_request_hack+0x25/0xc0 [bcache]
> 2013-08-22 06:28:43     [<ffffffffa0105013>] ?
> __bch_submit_bbio+0x73/0x80 [bcache]
> 2013-08-22 06:28:43     [<ffffffffa010bc98>]
> bch_insert_data_loop+0xf8/0x610 [bcache]
> 2013-08-22 06:28:43     [<ffffffffa010a335>] ?
> bch_get_congested+0x25/0x70 [bcache]
> 2013-08-22 06:28:43     [<ffffffffa010c1cd>]
> bch_insert_data+0x1d/0x20 [bcache]
> 2013-08-22 06:28:43     [<ffffffffa0116d13>] closure_queue+0x43/0x60
> [bcache]
> 2013-08-22 06:28:43     [<ffffffffa010c49e>]
> request_write+0x19e/0x380 [bcache]
> 
> Am 22.08.2013 01:47, schrieb Kent Overstreet:
> >On Tue, Aug 20, 2013 at 10:07:45AM +0200, Stefan Priebe - Profihost AG wrote:
> >>Am 20.08.2013 10:01, schrieb Stefan Priebe - Profihost AG:
> >>>Am 20.08.2013 00:27, schrieb Kent Overstreet:
> >>>>On Mon, Aug 19, 2013 at 12:09:24AM +0200, Stefan Priebe wrote:
> >>>>>
> >>>>>Vanilla 3.10.7 + bcache: Fix a writeback performance regression
> >>>>>
> >>>>>http://pastebin.com/raw.php?i=LXZk4cMH
> >>>>
> >>>>Whoops, at first I thought this was the same bug as one I'd already been
> >>>>chasing down that had been a harmless bug - turns out I didn't look
> >>>>closely enough at the backtrace.
> >>>>
> >>>>What happened is background writeback is deadlocking, because for some
> >>>>reason the workqueue it's running out of is a singlethreaded workqueue,
> >>>>so as soon as it decides to queue enough writeback bios that it has to
> >>>>sleep on that semaphore (which often won't happen due to the PD
> >>>>controller based ratelimiting) - boom, deadlock.
> >>>>
> >>>>Here's the fixup patch I just tested and am applying:
> >>
> >>Oh i'm now seeing very high CPU spikes of kworker... i don't see if i
> >>remove bcache: Fix a writeback performance regression.
> >
> >Are you able to reproduce it? I'm not having any luck reproducing it...
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
