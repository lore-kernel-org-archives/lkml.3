Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbaCXOmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 10:42:35 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:27885 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbaCXOmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 10:42:33 -0400
Message-ID: <53304451.7030800@oracle.com>
Date: Mon, 24 Mar 2014 10:42:25 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fs: gpf in simple_setattr
References: <52B23CEA.7090405@oracle.com> <52CD762B.7020600@oracle.com> <53123D81.6080003@oracle.com> <20140303214040.GA15265@quack.suse.cz> <53166920.709@oracle.com> <20140305124536.GA32371@quack.suse.cz> <53189BF8.1010308@oracle.com> <531A7CFD.9030603@oracle.com> <20140310104350.GB28797@quack.suse.cz> <531DC89A.9010601@oracle.com>
In-Reply-To: <531DC89A.9010601@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 10:13 AM, Sasha Levin wrote:
> On 03/10/2014 06:43 AM, Jan Kara wrote:
>>    By garbage, do you mean that it is a poison, completely random data or does
>> inode->i_sb look like a valid pointer but just superblock isn't where it
>> points to?
>
> It's poison.
>
>>> >Any way I could get anything useful any other way?
>>    Hum, can you dump the whole contents of 'dentry' at that place? Maybe it
>> will tell us something.
>
> I'll give it a go, will update when it happens again.

Okay, I've added this:

diff --git a/fs/libfs.c b/fs/libfs.c
index a184424..2492dc4 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -377,6 +377,7 @@ int simple_setattr(struct dentry *dentry, struct iattr *iattr)
         if (iattr->ia_valid & ATTR_SIZE)
                 truncate_setsize(inode, iattr->ia_size);
         setattr_copy(inode, iattr);
+       printk(KERN_ERR "** %u %p %s %p %s %p %p %p\n", dentry->d_flags, dentry->d_pare
         mark_inode_dirty(inode);
         return 0;
  }

And got the following:

[  339.948946] ** 4194304 ffff8805ac03ba38 [eventpoll] ffff8806ec051fe0 [eventpoll] ffffffff84666040 ffff88056c73e7b0           (null)
[  339.956028] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  339.958199] Dumping ftrace buffer:
[  339.959158]    (ftrace buffer empty)
[  339.960075] Modules linked in:
[  339.960712] CPU: 2 PID: 9702 Comm: trinity-c2 Tainted: G        W     3.14.0-rc7-next-20140321-sasha-00018-g0516fe6-dirty #266
[  339.962657] task: ffff88012b8b0000 ti: ffff88012b88a000 task.ti: ffff88012b88a000
[  339.964089] RIP: 0010:[<ffffffff8133af2c>]  [<ffffffff8133af2c>] __mark_inode_dirty+0x10c/0x4a0
[  339.965274] RSP: 0018:ffff88012b88bdb8  EFLAGS: 00010206
[  339.965274] RAX: 6b6b6b6b6b6b6b6b RBX: ffff8806ec051fe0 RCX: 0000000000000006
[  339.965274] RDX: 0000000000008a90 RSI: 0000000000000007 RDI: ffff8806ec051fe0
[  339.965274] RBP: ffff88012b88bdd8 R08: 0000000000000000 R09: 0000000000000000
[  339.965274] R10: 0000000000000001 R11: 3330636135303838 R12: 0000000000000007
[  339.965274] R13: ffff8806ec051fe0 R14: ffff8806ec6bb3d8 R15: ffff8806ec051fe0
[  339.965274] FS:  00007f1993d82700(0000) GS:ffff8800bec00000(0000) knlGS:0000000000000000
[  339.965274] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  339.974036] CR2: 0000000000000000 CR3: 0000000123b16000 CR4: 00000000000006a0
[  339.974036] DR0: 0000000000698000 DR1: 0000000000000000 DR2: 0000000000000000
[  339.974036] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  339.974036] Stack:
[  339.974036]  0000000000000000 ffff8805ac03ba38 ffff8806ec051fe0 ffff88012b88bec8
[  339.974036]  ffff88012b88be28 ffffffff81336f7b ffffffff84666040 ffff88056c73e7b0
[  339.974036]  0000000000000000 ffff8806ec0520c8 0000000000000041 ffff88012b88bec8
[  339.974036] Call Trace:
[  339.974036]  [<ffffffff81336f7b>] simple_setattr+0xab/0xd0
[  339.974036]  [<ffffffff8132b148>] notify_change+0x258/0x390
[  339.974036]  [<ffffffff81307db2>] ? chmod_common+0x72/0x150
[  339.974036]  [<ffffffff81307df4>] chmod_common+0xb4/0x150
[  339.974036]  [<ffffffff8132c274>] ? __fget_light+0xe4/0x130
[  339.974036]  [<ffffffff81309382>] SyS_fchmod+0x62/0xa0
[  339.974036]  [<ffffffff84506a58>] tracesys+0xe1/0xe6
[  339.974036] Code: 8b 45 00 0f 1f 40 00 49 8b 7d 08 44 89 e2 49 83 c5 10 48 89 de ff d0 49 8b 45 00 48 85 c0 75 e7 eb c5 0f 1f 44 00 00 49 8b 46 30 <48> 8b 40 10 48 85 c0 74 08 44 89 e6 48 89 df ff d0 66 66 66 66
[  339.974036] RIP  [<ffffffff8133af2c>] __mark_inode_dirty+0x10c/0x4a0
[  339.974036]  RSP <ffff88012b88bdb8>


Thanks,
Sasha
