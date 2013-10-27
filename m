Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab3J0DXq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 23:23:46 -0400
Received: from mail.ispras.ru ([83.149.199.45]:32942 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab3J0DXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 23:23:45 -0400
Message-ID: <526C873A.1040705@ispras.ru>
Date: Sun, 27 Oct 2013 07:23:38 +0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
CC: linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: f2fs: deadlock in mkdir if ACL is enabled
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jaegeuk,

Testing F2FS in the following configuration:
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
CONFIG_F2FS_FS_SECURITY=y

I have got a deadlock:

[16921.437845] INFO: task fs-driver-tests:12695 blocked for more than 
120 seconds.
[16921.437899]       Tainted: G        W    3.12-rc6-284-generic #1
[16921.437941] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[16921.437980] fs-driver-tests D ffff88007dd3fb78     0 12695  12361 
0x00000000
[16921.438017]  ffff88007dd3fae8 0000000000000092 ffff880036c4bfa0 
ffff88007dd3ffd8
[16921.438049]  ffff88007dd3ffd8 ffff88007dd3ffd8 ffffffff81c104e0 
ffff880036c4bfa0
[16921.438078]  ffff880036c4bfa0 ffff880082a14858 0000000000000002 
ffffffff8113f600
[16921.438106] Call Trace:
[16921.438156]  [<ffffffff8113f600>] ? __lock_page+0x70/0x70
[16921.438196]  [<ffffffff8165e599>] schedule+0x29/0x70
[16921.438229]  [<ffffffff8165e66f>] io_schedule+0x8f/0xd0
[16921.438257]  [<ffffffff8113f60e>] sleep_on_page+0xe/0x20
[16921.438281]  [<ffffffff8165a53d>] __wait_on_bit_lock+0x5d/0xc0
[16921.438302]  [<ffffffff8113f5f7>] __lock_page+0x67/0x70
[16921.438323]  [<ffffffff81077760>] ? wake_atomic_t_function+0x40/0x40
[16921.438340]  [<ffffffff811402b1>] find_lock_page+0x61/0x90
[16921.438355]  [<ffffffff8114040f>] find_or_create_page+0x3f/0xb0
[16921.438375]  [<ffffffffa02b6979>] get_node_page+0x39/0x180 [f2fs]
[16921.438398]  [<ffffffffa02aa723>] update_inode_page+0x23/0x70 [f2fs]
[16921.438412]  [<ffffffffa02b6da8>] sync_inode_page+0xd8/0xe0 [f2fs]
[16921.438425]  [<ffffffffa02b7068>] new_node_page+0x2b8/0x2e0 [f2fs]
[16921.438438]  [<ffffffffa02c0c2c>] f2fs_setxattr+0x44c/0x650 [f2fs]
[16921.438451]  [<ffffffffa02c1205>] f2fs_set_acl+0x235/0x350 [f2fs]
[16921.438462]  [<ffffffffa02c179a>] ? f2fs_get_acl+0x8a/0xc0 [f2fs]
[16921.438473]  [<ffffffffa02c19d0>] f2fs_init_acl+0x140/0x170 [f2fs]
[16921.438483]  [<ffffffffa02a7a46>] __f2fs_add_link+0x276/0x720 [f2fs]
[16921.438494]  [<ffffffffa02ab866>] f2fs_mkdir+0x116/0x1b0 [f2fs]
[16921.438503]  [<ffffffff811ab744>] ? __inode_permission+0x64/0xe0
[16921.438512]  [<ffffffff811aecf6>] vfs_mkdir+0xa6/0x130
[16921.438521]  [<ffffffff811b0d2a>] SyS_mkdirat+0xaa/0xf0
[16921.438530]  [<ffffffff811b0d89>] SyS_mkdir+0x19/0x20
[16921.438540]  [<ffffffff81668e92>] system_call_fastpath+0x16/0x1b
[16921.438545] 4 locks held by fs-driver-tests/12695:
[16921.438550]  #0:  (sb_writers#11){.+.+.+}, at: [<ffffffff811c0504>] 
mnt_want_write+0x24/0x50
[16921.438559]  #1:  (&type->i_mutex_dir_key#3/1){+.+.+.}, at: 
[<ffffffff811acec7>] kern_path_create+0x87/0x170
[16921.438567]  #2:  (&sbi->fs_lock[i]){+.+.+.}, at: 
[<ffffffffa02ab81c>] f2fs_mkdir+0xcc/0x1b0 [f2fs]
[16921.438576]  #3:  (&sbi->fs_lock[i]){+.+.+.}, at: 
[<ffffffffa02c08a4>] f2fs_setxattr+0xc4/0x650 [f2fs]

Analysis shown the following problem:

sys_mkdir() calls
   -> f2fs_add_link()
     -> __f2fs_add_link()
       -> init_inode_metadata():
static struct page *init_inode_metadata(struct inode *inode,
         struct inode *dir, const struct qstr *name)
{
     struct page *page;
     int err;

     if (is_inode_flag_set(F2FS_I(inode), FI_NEW_INODE)) {
         page = new_inode_page(inode, name); <--- NEW PAGE CAME LOCKED HERE
         if (IS_ERR(page))
             return page;

         if (S_ISDIR(inode->i_mode)) {
             err = make_empty_dir(inode, dir, page);
             if (err)
                 goto error;
         }

         err = f2fs_init_acl(inode, dir);
         ...........
         return page;
         PAGE IS RETURNED FROM init_inode_metadata() LOCKED

But
f2fs_init_acl() calls
   -> f2fs_set_acl(inode, ACL_TYPE_DEFAULT, acl);
     -> f2fs_setxattr(inode, ...)
-> write_all_xattrs(inode, ...)
         -> new_node_page(&dn, ...), where dn->inode = inode
           -> sync_inode_page(dn)
             -> update_inode_page(dn->inode):
               -> get_node_page(sbi, inode->i_ino):
struct page *get_node_page(struct f2fs_sb_info *sbi, pgoff_t nid)
{
     struct address_space *mapping = sbi->node_inode->i_mapping;
     struct page *page;
     int err;
repeat:
     page = grab_cache_page(mapping, nid); <-- DEADLOCK: PAGE IS ALREADY 
LOCKED


Found by Linux File System Verification project (linuxtesting.org).

--
Best regards,
Alexey Khoroshilov
Linux Verification Center, ISPRAS
web: http://linuxtesting.org

