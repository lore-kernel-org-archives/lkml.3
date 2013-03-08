Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab3CHTUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 14:20:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab3CHTUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 14:20:46 -0500
Date: Fri, 8 Mar 2013 14:20:42 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
Message-ID: <20130308192042.GA10305@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <20130307021645.GA10173@redhat.com>
 <20130308150408.GA25399@redhat.com>
 <CA+55aFxAfWHdSH+45qgids1ByBxzieZnz_ujRXYGY-at1mg5eg@mail.gmail.com>
 <20130308191804.GA9774@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130308191804.GA9774@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 02:18:04PM -0500, Dave Jones wrote:
 > On Fri, Mar 08, 2013 at 10:51:03AM -0800, Linus Torvalds wrote:
 >  > On Fri, Mar 8, 2013 at 7:04 AM, Dave Jones <davej@redhat.com> wrote:
 >  > >
 >  > > Managed to trigger this one from a different path..
 >  > >
 >  > > kernel BUG at fs/namei.c:1439!
 >  > > Call Trace:
 >  > >  [<ffffffff811c973e>] path_lookupat+0x71e/0x740
 >  > >  [<ffffffff811c9794>] filename_lookup+0x34/0xc0
 >  > >  [<ffffffff811cc58e>] user_path_at_empty+0x8e/0x110
 >  > >  [<ffffffff811cc621>] user_path_at+0x11/0x20
 >  > >  [<ffffffff811e4347>] sys_lgetxattr+0x37/0xa0
 >  > >  [<ffffffff816d11c2>] system_call_fastpath+0x16/0x1b
 >  > >
 >  > > What can I dump here that might give us more clues ?
 >  > 
 >  > I think we should do the same thing and print out dentry names to give
 >  > us clues about where in /proc the problem happens.
 >  > 
 >  > And it doesn't really have to be proc - because of the symlinks in
 >  > /proc, we could easily get to /sys through processes like udev etc..
 >  > 
 >  > So how about just replaving that BUG_ON() with a
 >  > 
 >  >     if (WARN_ON(nd->inode != parent->d_inode)) {
 >  >         printk("%s -> %s (%s)\n", parent->d_name.name,
 >  > path->dentry->d_name.name, nd->last.name);
 >  >         return -EINVAL;
 >  >     }
 >  > 
 >  > or something like that.
 > 
 > Ugh, something in there is NULL..
 > 
 > BUG: unable to handle kernel NULL pointer dereference at           (null)
 > IP: [<          (null)>]           (null)
 > PGD 10883f067 PUD 10883e067 PMD 0 
 > Oops: 0010 [#1] PREEMPT SMP DEBUG_PAGEALLOC
 > Modules linked in: decnet ipx p8023 p8022 af_rxrpc appletalk psnap can rose af_key ax25 caif_socket caif crc_ccitt nfc atm llc2 phonet llc x25 lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables btusb bluetooth snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm usb_debug edac_core microcode serio_raw pcspkr rfkill snd_page_alloc snd_timer snd r8169 soundcore mii vhost_net tun macvtap macvlan kvm_amd kvm radeon backlight drm_kms_helper ttm
 > CPU 2 
 > Pid: 942, comm: trinity-child2 Not tainted 3.9.0-rc1+ #79 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
 > RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
 > RSP: 0018:ffff88010885ddc0  EFLAGS: 00010246
 > RAX: ffffffff8181f540 RBX: ffff88010b3eb090 RCX: 0000000000000000
 > RDX: 0000000000000600 RSI: ffff88010b3eb090 RDI: ffff88010b359be8
 > RBP: ffff88010885dde8 R08: 0000000000000001 R09: 0000000000000000
 > R10: 0000000000000001 R11: 0000000000000000 R12: ffff88010b3e9720
 > R13: ffff88010885df38 R14: 0000000000000000 R15: 000000006a59949a
 > FS:  00007feff7939740(0000) GS:ffff88012aa00000(0000) knlGS:0000000000000000
 > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 > CR2: 0000000000000000 CR3: 0000000108840000 CR4: 00000000000007e0
 > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 > Process trinity-child2 (pid: 942, threadinfo ffff88010885c000, task ffff88011939a490)
 > Stack:
 >  ffffffff811c62fd ffff88010b3e9720 ffff88010885df38 0000000000000000
 >  0000000000000600 ffff88010885de18 ffffffff811c6518 ffff88010885de28
 >  0100000000000000 0000000000000000 0000000000000000 ffff88010885de28
 > Call Trace:
 >  [<ffffffff811c62fd>] ? lookup_real+0x1d/0x60
 >  [<ffffffff811c6518>] __lookup_hash+0x38/0x50
 >  [<ffffffff811c6549>] lookup_hash+0x19/0x20
 >  [<ffffffff811c9983>] kern_path_create+0x93/0x170
 >  [<ffffffff811c7e36>] ? getname_flags.part.33+0x86/0x150
 >  [<ffffffff811c9aaa>] user_path_create+0x4a/0x70
 >  [<ffffffff811cc87c>] sys_mknodat+0xac/0x1d0
 >  [<ffffffff816d1242>] system_call_fastpath+0x16/0x1b
 > Code:  Bad RIP value.
 > RIP  [<          (null)>]           (null)
 >  RSP <ffff88010885ddc0>
 > CR2: 0000000000000000
 > 
 > I'll turn off DEBUG_PAGEALLOC again, so I can get the RIP and figure out which deref it is.
 
Wait, it has to be that path->dentry->d_name.name.
The other derefs are the same as before.

	Dave

