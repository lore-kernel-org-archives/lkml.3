Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808Ab3CHXHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 18:07:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757067Ab3CHXHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 18:07:39 -0500
Date: Fri, 8 Mar 2013 18:07:34 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
Message-ID: <20130308230734.GA28317@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <20130307021645.GA10173@redhat.com>
 <20130308150408.GA25399@redhat.com>
 <CA+55aFxAfWHdSH+45qgids1ByBxzieZnz_ujRXYGY-at1mg5eg@mail.gmail.com>
 <20130308191804.GA9774@redhat.com>
 <20130308192042.GA10305@redhat.com>
 <20130308193652.GA11692@redhat.com>
 <CA+55aFyE12rZ3DZUtTkonPjbcQiZNdAmys7w5zf7_Xry2z=-2A@mail.gmail.com>
 <20130308210432.GA21500@redhat.com>
 <CA+55aFyNAA3u2k_38iqRPN0EqtP=qXu1wu_vnXnAgQmp6NwGJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyNAA3u2k_38iqRPN0EqtP=qXu1wu_vnXnAgQmp6NwGJA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 02:41:19PM -0800, Linus Torvalds wrote:
 > On Fri, Mar 8, 2013 at 1:04 PM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > queue up the sad trombone noises.
 > >
 > > One of the things trinity passes syscalls is a page of deformed unicode.
 > > Apparently this page is so fucked up, that it crashes *printk*.
 > 
 > It's probably my debug stuff that is bogus. One of the string pointers
 > passed to printk %s seems bad, and instead of being a proper kernel
 > pointer it's "0xaf0f48ef7bdef7bd". So trying to access it causes a GP
 > fault (it's not a validly formed pointer)
 > 
 > I'm not seeing what the problem is, but I'll mull on it..

Ok, got something more meaningful out of the lookup_slow trace.

[   66.082984] parent->dname.name  (06b6b6b6b6b6b6b)
[   66.083637] parent = 

At first I thought AH-HA! SLAB POISON!
But look closer.. it's shifted by 8 bits.

Also, this isn't a pointer, that's the output of..

                printk("parent->dname.name %s (%x%x%x%x%x%x%x%x)\n", parent->d_name.name,
                        parent->d_name.name[0],
                        parent->d_name.name[1],
                        parent->d_name.name[2],
                        parent->d_name.name[3],
                        parent->d_name.name[4],
                        parent->d_name.name[5],
                        parent->d_name.name[6],
                        parent->d_name.name[7]);

Interestingly, that pattern always seems to be the same across different reboots.

parent seems to be a pointer to "\0".


Another oddball crash..



BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<          (null)>]           (null)
PGD 10f366067 PUD 10f36c067 PMD 0 
Oops: 0010 [#1] PREEMPT SMP 
Modules linked in: can_bcm irda pppoe pppox ppp_generic can slhc af_802154 atm rds af_key phonet nfc ipx p8023 p8022 af_rxrpc caif_socket caif crc_ccitt decnet netrom appletalk x25 psnap llc rose ax25 lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm btusb bluetooth usb_debug snd_page_alloc microcode snd_timer rfkill snd serio_raw pcspkr edac_core soundcore r8169 mii vhost_net tun macvtap macvlan kvm_amd kvm radeon backlight drm_kms_helper ttm
CPU 0 
Pid: 822, comm: trinity-child0 Not tainted 3.9.0-rc1+ #85 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
RSP: 0018:ffff88010f033db0  EFLAGS: 00010246
RAX: ffffffff8181f540 RBX: ffff8800cf49c940 RCX: 0000000000000000
RDX: 0000000000000600 RSI: ffff8800cf49c940 RDI: ffff8800cf492170
RBP: ffff88010f033dd8 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff8800cf49f530
R13: ffff88010f033f28 R14: 0000000000000000 R15: ffffffffa0000000
FS:  00007f29dffed740(0000) GS:ffff88012ae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000010f365000 CR4: 00000000000007f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process trinity-child0 (pid: 822, threadinfo ffff88010f032000, task ffff8801103ec920)
Stack:
 ffffffff811c5fad ffff8800cf49f530 ffff88010f033f28 0000000000000000
 0000000000000600 ffff88010f033e08 ffffffff811c61c8 ffff88010f033e18
 0100000000000000 0000000000000000 0000000000000000 ffff88010f033e18
Call Trace:
 [<ffffffff811c5fad>] ? lookup_real+0x1d/0x60
 [<ffffffff811c61c8>] __lookup_hash+0x38/0x50
 [<ffffffff811c61f9>] lookup_hash+0x19/0x20
 [<ffffffff811c96a5>] kern_path_create+0x95/0x170
 [<ffffffff811c7b56>] ? getname_flags.part.33+0x86/0x150
 [<ffffffffa0000000>] ? 0xffffffff9fffffff
 [<ffffffff811c97ca>] user_path_create+0x4a/0x70
 [<ffffffff811cc66c>] sys_mknodat+0xac/0x1d0
 [<ffffffff8134b4be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffffa0000000>] ? 0xffffffff9fffffff
 [<ffffffff811cc7ad>] sys_mknod+0x1d/0x20
 [<ffffffff816d1142>] system_call_fastpath+0x16/0x1b
 [<ffffffffa0000000>] ? 0xffffffff9fffffff
Code:  Bad RIP value.
RIP  [<          (null)>]           (null)
 RSP <ffff88010f033db0>
CR2: 0000000000000000
---[ end trace f74c72ebf05e8c15 ]---

I'll add some similar printk's to lookup_real and see what falls out.

	Dave

