Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaBKIaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:30:05 -0500
Received: from smtp.ispras.ru ([83.149.199.79]:48300 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbaBKIaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:30:00 -0500
Message-ID: <52F9DF85.7040402@ispras.ru>
Date: Tue, 11 Feb 2014 12:29:57 +0400
From: Andrey Tsyvarev <tsyvarev@ispras.ru>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: jaegeuk.kim@samsung.com
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] f2fs: f2fs unmount hangs if f2fs_init_acl() fails
 during mkdir syscall
References: <52F320FC.50803@ispras.ru> <1391666564.25542.78.camel@kjgkr> <52F37D67.208@ispras.ru> <1391734185.25542.80.camel@kjgkr> <1391749933.25542.83.camel@kjgkr>
In-Reply-To: <1391749933.25542.83.camel@kjgkr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> It turns out that make_bad_inode prior to iput sets i_mode to a regular
> file, so that f2fs_evict_inode -> truncate_inode_pages ->
> f2fs_invalidate_data_page doesn't decrement dirty_dents.
>
It seems that remove_dirty_dir_inode() call should also be added to the 
error-path of
init_inode_metadata, because its functionality is also based on 
inode->i_mode field
which is changed by make_bad_inode().

Otherwise memory leak is reported when f2fs module is unloaded:

[  231.378192] BUG f2fs_dirty_dir_entry (Tainted: GF          O): 
Objects remaining in f2fs_dirty_dir_entry on kmem_cache_close()
[  231.378193] 
-----------------------------------------------------------------------------

[  231.378194] Disabling lock debugging due to kernel taint
[  231.378195] INFO: Slab 0xffffea0000437200 objects=102 used=1 
fp=0xffff880010dc8fc8 flags=0x3fffc000000080
[  231.378197] CPU: 0 PID: 2605 Comm: rmmod Tainted: GF   B      O 
3.14.0-rc1fs #4
[  231.378198] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS 
VirtualBox 12/01/2006
[  231.378199]  ffff88000e5e3200 ffff88000cc9bd40 ffffffff8166fd7e 
ffffea0000437200
[  231.378202]  ffff88000cc9be28 ffffffff811c3fdf ffff88003fc10066 
ffffffff0cc9bda0
[  231.378203]  ffffffff00000020 ffff88000cc9be38 ffff88000cc9bde0 
656a624f00000296
[  231.378205] Call Trace:
[  231.378210]  [<ffffffff8166fd7e>] dump_stack+0x45/0x56
[  231.378213]  [<ffffffff811c3fdf>] slab_err+0xaf/0xc0
[  231.378215]  [<ffffffff811c84a3>] ? kmem_cache_close+0x133/0x340
[  231.378216]  [<ffffffff811c6b55>] ? __kmalloc+0x1f5/0x250
[  231.378218]  [<ffffffff811c84c3>] kmem_cache_close+0x153/0x340
[  231.378221]  [<ffffffff81193417>] ? kmem_cache_destroy+0x27/0xf0
[  231.378223]  [<ffffffff811c86c4>] __kmem_cache_shutdown+0x14/0x80
[  231.378224]  [<ffffffff81193431>] kmem_cache_destroy+0x41/0xf0
[  231.378229]  [<ffffffffa01eab91>] destroy_checkpoint_caches+0x21/0x30 
[f2fs]
[  231.378232]  [<ffffffffa01facda>] exit_f2fs_fs+0x28/0x34e [f2fs]
[  231.378235]  [<ffffffff810ffe32>] SyS_delete_module+0x152/0x1f0
[  231.378237]  [<ffffffff8111d85c>] ? __audit_syscall_entry+0x9c/0xf0
[  231.378239]  [<ffffffff81680729>] system_call_fastpath+0x16/0x1b
[  231.378242] INFO: Object 0xffff880010dc8000 @offset=0
[  231.378245] kmem_cache_destroy f2fs_dirty_dir_entry: Slab cache still 
has objects
[  231.378247] CPU: 0 PID: 2605 Comm: rmmod Tainted: GF   B      O 
3.14.0-rc1fs #4
[  231.378247] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS 
VirtualBox 12/01/2006
[  231.378248]  ffff88000e5e3268 ffff88000cc9beb8 ffffffff8166fd7e 
ffff88000e5e3200
[  231.378250]  ffff88000cc9bed8 ffffffff811934cf 0000000000000000 
ffffffffa0204f60
[  231.378251]  ffff88000cc9bee8 ffffffffa01eab91 ffff88000cc9bef8 
ffffffffa01facda
[  231.378253] Call Trace:
[  231.378255]  [<ffffffff8166fd7e>] dump_stack+0x45/0x56
[  231.378256]  [<ffffffff811934cf>] kmem_cache_destroy+0xdf/0xf0
[  231.378259]  [<ffffffffa01eab91>] destroy_checkpoint_caches+0x21/0x30 
[f2fs]
[  231.378262]  [<ffffffffa01facda>] exit_f2fs_fs+0x28/0x34e [f2fs]
[  231.378263]  [<ffffffff810ffe32>] SyS_delete_module+0x152/0x1f0
[  231.378265]  [<ffffffff8111d85c>] ? __audit_syscall_entry+0x9c/0xf0
[  231.378266]  [<ffffffff81680729>] system_call_fastpath+0x16/0x1b


Stack of allocation (obtained with KEDR, which is also used for fault 
simulation):

[  231.414875] [leak_check] Address: 0xffff880010dc8000, size: 24; stack 
trace of the allocation:
[  231.414886] [leak_check] [<ffffffffa01e9d72>] 
set_dirty_dir_page+0x62/0xe0 [f2fs]
[  231.414893] [leak_check] [<ffffffffa01ec9be>] 
f2fs_set_data_page_dirty+0x4e/0x90 [f2fs]
[  231.414898] [leak_check] [<ffffffff8117b02a>] set_page_dirty+0x3a/0x60
[  231.414904] [leak_check] [<ffffffffa01dfeb2>] 
__f2fs_add_link+0x732/0x7d0 [f2fs]
[  231.414909] [leak_check] [<ffffffffa01e2f1b>] f2fs_mkdir+0xbb/0x150 
[f2fs]
[  231.414914] [leak_check] [<ffffffff811f2a37>] vfs_mkdir+0xb7/0x160
[  231.414918] [leak_check] [<ffffffff811f367f>] SyS_mkdir+0x5f/0xc0
[  231.414923] [leak_check] [<ffffffff81680729>] 
system_call_fastpath+0x16/0x1b
[  231.414931] [leak_check] [<ffffffffffffffff>] 0xffffffffffffffff


P.S. It was required to add 'slub_debug' kernel options for make SLUB 
output correct cache name,
otherwise cache "f2fs_dirty_dir_entry" was merged into "free_nid" one. 
It was surprise for me,
that's why patch investigation took so long time.

-- 
Best regards,
Andrey Tsyvarev
Linux Verification Center, ISPRAS
web:http://linuxtesting.org

