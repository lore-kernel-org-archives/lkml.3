Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933732Ab3FSAiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 20:38:09 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:62006 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824Ab3FSAiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 20:38:06 -0400
Date: Wed, 19 Jun 2013 08:38:02 +0800
From: majianpeng <majianpeng@gmail.com>
To: sage <sage@inktank.com>
Cc: ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: Re: Re: [PATCH] ceph: fix sleeping function called from invalid context.
References: <201306181930448773810@gmail.com>, 
	<alpine.DEB.2.00.1306180807210.23632@cobra.newdream.net>
X-Priority: 3
X-GUID: F08EB29F-F164-4E2A-ADF1-17D2BE0C32E6
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201306190837590546663@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5J0cfp3004852

>On Tue, 18 Jun 2013, majianpeng wrote:
>> [ 1121.231883] BUG: sleeping function called from invalid context at kernel/rwsem.c:20
>> [ 1121.231935] in_atomic(): 1, irqs_disabled(): 0, pid: 9831, name: mv
>> [ 1121.231971] 1 lock held by mv/9831:
>> [ 1121.231973]  #0:  (&(&ci->i_ceph_lock)->rlock){+.+...}, at:[<ffffffffa02bbd38>] ceph_getxattr+0x58/0x1d0 [ceph]
>> [ 1121.231998] CPU: 3 PID: 9831 Comm: mv Not tainted 3.10.0-rc6+ #215
>> [ 1121.232000] Hardware name: To Be Filled By O.E.M. To Be Filled By
>> O.E.M./To be filled by O.E.M., BIOS 080015  11/09/2011
>> [ 1121.232027]  ffff88006d355a80 ffff880092f69ce0 ffffffff8168348c ffff880092f69cf8
>> [ 1121.232045]  ffffffff81070435 ffff88006d355a20 ffff880092f69d20 ffffffff816899ba
>> [ 1121.232052]  0000000300000004 ffff8800b76911d0 ffff88006d355a20 ffff880092f69d68
>> [ 1121.232056] Call Trace:
>> [ 1121.232062]  [<ffffffff8168348c>] dump_stack+0x19/0x1b
>> [ 1121.232067]  [<ffffffff81070435>] __might_sleep+0xe5/0x110
>> [ 1121.232071]  [<ffffffff816899ba>] down_read+0x2a/0x98
>> [ 1121.232080]  [<ffffffffa02baf70>] ceph_vxattrcb_layout+0x60/0xf0 [ceph]
>> [ 1121.232088]  [<ffffffffa02bbd7f>] ceph_getxattr+0x9f/0x1d0 [ceph]
>> [ 1121.232093]  [<ffffffff81188d28>] vfs_getxattr+0xa8/0xd0
>> [ 1121.232097]  [<ffffffff8118900b>] getxattr+0xab/0x1c0
>> [ 1121.232100]  [<ffffffff811704f2>] ? final_putname+0x22/0x50
>> [ 1121.232104]  [<ffffffff81155f80>] ? kmem_cache_free+0xb0/0x260
>> [ 1121.232107]  [<ffffffff811704f2>] ? final_putname+0x22/0x50
>> [ 1121.232110]  [<ffffffff8109e63d>] ? trace_hardirqs_on+0xd/0x10
>> [ 1121.232114]  [<ffffffff816957a7>] ? sysret_check+0x1b/0x56
>> [ 1121.232120]  [<ffffffff81189c9c>] SyS_fgetxattr+0x6c/0xc0
>> [ 1121.232125]  [<ffffffff81695782>] system_call_fastpath+0x16/0x1b
>> [ 1121.232129] BUG: scheduling while atomic: mv/9831/0x10000002
>> [ 1121.232154] 1 lock held by mv/9831:
>> [ 1121.232156]  #0:  (&(&ci->i_ceph_lock)->rlock){+.+...}, at:
>> [<ffffffffa02bbd38>] ceph_getxattr+0x58/0x1d0 [ceph]
>> 
>> I think move the ci->i_ceph_lock down is safe because we can't free
>> ceph_inode_info at there.
>> 
>> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
>> ---
>>  fs/ceph/xattr.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
>> index 9b6b2b6..4efde06 100644
>> --- a/fs/ceph/xattr.c
>> +++ b/fs/ceph/xattr.c
>> @@ -675,7 +675,6 @@ ssize_t ceph_getxattr(struct dentry *dentry, const char *name, void *value,
>>         if (!ceph_is_valid_xattr(name))
>>                 return -ENODATA;
>>  
>> -       spin_lock(&ci->i_ceph_lock);
>>         dout("getxattr %p ver=%lld index_ver=%lld\n", inode,
>>              ci->i_xattrs.version, ci->i_xattrs.index_version);
>
>Unfortunately these intervening lines neext i_ceph_lock to prevent the 
>i_xattrs struct contents from shifting underneath us.  It is more 
IMHO,for those line
>         vxattr = ceph_match_vxattr(inode, name);
>         if (vxattr && !(vxattr->exists_cb && !vxattr->exists_cb(ci))) {
>                 err = vxattr->getxattr_cb(ci, value, size);
It's no need to protect by i_ceph_lock.
Can you expalin in detail?
>expensive for the general getxattr case, but a simpler fix is to take 
>map_sem outside of i_ceph_lock.
[snip]


Thanks
Jianpeng Maÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
