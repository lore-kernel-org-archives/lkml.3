Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab3CHTg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 14:36:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab3CHTg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 14:36:56 -0500
Date: Fri, 8 Mar 2013 14:36:52 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
Message-ID: <20130308193652.GA11692@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <20130307021645.GA10173@redhat.com>
 <20130308150408.GA25399@redhat.com>
 <CA+55aFxAfWHdSH+45qgids1ByBxzieZnz_ujRXYGY-at1mg5eg@mail.gmail.com>
 <20130308191804.GA9774@redhat.com>
 <20130308192042.GA10305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130308192042.GA10305@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 02:20:42PM -0500, Dave Jones wrote:

 >  > I'll turn off DEBUG_PAGEALLOC again, so I can get the RIP and figure out which deref it is.
 >  
 > Wait, it has to be that path->dentry->d_name.name.
 > The other derefs are the same as before.

I changed it to do this..

diff --git a/fs/namei.c b/fs/namei.c
index 961bc12..c1ca29e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -689,8 +689,6 @@ void nd_jump_link(struct nameidata *nd, struct path *path)
        nd->path = *path;
        nd->inode = nd->path.dentry->d_inode;
        nd->flags |= LOOKUP_JUMPED;
-
-       BUG_ON(nd->inode->i_op->follow_link);
 }
 
 static inline void put_link(struct nameidata *nd, struct path *link, void *cookie)
@@ -1438,7 +1436,13 @@ static int lookup_slow(struct nameidata *nd, struct path *path)
        int err;
 
        parent = nd->path.dentry;
-       BUG_ON(nd->inode != parent->d_inode);
+
+    if (WARN_ON(nd->inode != parent->d_inode)) {
+        printk("%s -> %p (%s)\n", parent->d_name.name, path->dentry, nd->last.name);
+        return -EINVAL;
+    }
+
+
 
        mutex_lock(&parent->d_inode->i_mutex);
        dentry = __lookup_hash(&nd->last, parent, nd->flags);


And now I'm getting a different BUG_ON

[  170.860317] kernel BUG at fs/namei.c:2737!
[  170.860855] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  170.861719] Modules linked in: irda can phonet ipx p8023 p8022 af_rxrpc atm x25 af_802154 llc2 pppoe pppox ppp_generic slhc netrom decnet af_key rose nfc ax25 appletalk psnap llc caif_socket caif crc_ccitt rds lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables btusb bluetooth snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_page_alloc microcode usb_debug snd_timer vhost_net snd rfkill serio_raw tun edac_core pcspkr macvtap soundcore macvlan kvm_amd r8169 mii kvm radeon backlight drm_kms_helper ttm
[  170.869795] CPU 1 
[  170.870063] Pid: 998, comm: trinity-child1 Not tainted 3.9.0-rc1+ #80 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
[  170.871541] RIP: 0010:[<ffffffff811cbe34>]  [<ffffffff811cbe34>] do_last+0xda4/0xe30
[  170.872561] RSP: 0018:ffff880108577cc8  EFLAGS: 00010206
[  170.873250] RAX: 0000000000000001 RBX: ffff880108577e58 RCX: 0000000000000000
[  170.874162] RDX: 000000000000006d RSI: ffff880108819660 RDI: 0000000000000001
[  170.875073] RBP: ffff880108577d98 R08: 0000000000000001 R09: 0000000000000000
[  170.875986] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000008000
[  170.876898] R13: ffff880108577df8 R14: ffff880108577f28 R15: ffff88010875c840
[  170.877810] FS:  00007f5651395740(0000) GS:ffff88012a800000(0000) knlGS:0000000000000000
[  170.878838] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  170.879580] CR2: 0000000000fe1418 CR3: 0000000108655000 CR4: 00000000000007e0
[  170.880491] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  170.881402] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  170.882314] Process trinity-child1 (pid: 998, threadinfo ffff880108576000, task ffff880108578000)
[  170.883436] Stack:
[  170.883696]  ffff8801159b5e48 ffff880108578000 ffff880108577ce8 ffffffff811c8088
[  170.884746]  ffff880108577d98 ffffffff811c8305 ffff880122444620 ffff880122444600
[  170.885806]  ffff880108577d28 ffff880108578000 ffff880108578000 ffff880108577d58
[  170.886840] Call Trace:
[  170.887181]  [<ffffffff811c8088>] ? inode_permission+0x18/0x50
[  170.887939]  [<ffffffff811c8305>] ? link_path_walk+0x245/0x880
[  170.888697]  [<ffffffff811cbf7a>] path_openat+0xba/0x500
[  170.889392]  [<ffffffff810b2868>] ? trace_hardirqs_off_caller+0x28/0xc0
[  170.890245]  [<ffffffff810b2792>] ? get_lock_stats+0x22/0x70
[  170.890980]  [<ffffffff810b2bfe>] ? put_lock_stats.isra.23+0xe/0x40
[  170.891790]  [<ffffffff811cc681>] do_filp_open+0x41/0xa0
[  170.892485]  [<ffffffff811dbe99>] ? __alloc_fd+0x179/0x230
[  170.893200]  [<ffffffff811bb764>] do_sys_open+0xf4/0x1e0
[  170.893893]  [<ffffffff811bb894>] sys_openat+0x14/0x20
[  170.894565]  [<ffffffff816d1202>] system_call_fastpath+0x16/0x1b
[  170.895342] Code: 66 f8 ff ff 41 ba e6 ff ff ff e9 b2 f8 ff ff 0f 8c eb f4 ff ff 48 8b 75 90 c6 45 ac 00 48 8b 76 30 48 39 73 30 0f 84 8a f5 ff ff <0f> 0b be e9 09 00 00 48 c7 c7 37 8c a0 81 4c 89 9d 48 ff ff ff 

BUG_ON(nd->inode != dir->d_inode);


It also looks like that printk didn't fire.  Hmm.. Different bug ?
Christ, I'm having a hard time keeping track of all these.

	Dave

