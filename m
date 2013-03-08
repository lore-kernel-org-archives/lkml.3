Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125Ab3CHVEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 16:04:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932408Ab3CHVEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 16:04:37 -0500
Date: Fri, 8 Mar 2013 16:04:32 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
Message-ID: <20130308210432.GA21500@redhat.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyE12rZ3DZUtTkonPjbcQiZNdAmys7w5zf7_Xry2z=-2A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 11:47:54AM -0800, Linus Torvalds wrote:
 > On Fri, Mar 8, 2013 at 11:36 AM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > I changed it to do this..
 > >
 > > diff --git a/fs/namei.c b/fs/namei.c
 > > index 961bc12..c1ca29e 100644
 > > --- a/fs/namei.c
 > > +++ b/fs/namei.c
 > > @@ -689,8 +689,6 @@ void nd_jump_link(struct nameidata *nd, struct path *path)
 > >         nd->path = *path;
 > >         nd->inode = nd->path.dentry->d_inode;
 > >         nd->flags |= LOOKUP_JUMPED;
 > > -
 > > -       BUG_ON(nd->inode->i_op->follow_link);
 > >  }
 > >
 > >  static inline void put_link(struct nameidata *nd, struct path *link, void *cookie)
 > > @@ -1438,7 +1436,13 @@ static int lookup_slow(struct nameidata *nd, struct path *path)
 > >         int err;
 > >
 > >         parent = nd->path.dentry;
 > > -       BUG_ON(nd->inode != parent->d_inode);
 > > +
 > > +    if (WARN_ON(nd->inode != parent->d_inode)) {
 > > +        printk("%s -> %p (%s)\n", parent->d_name.name, path->dentry, nd->last.name);
 > > +        return -EINVAL;
 > > +    }
 > 
 > Ok, it might be nice to print out the path dentry name if it has one,
 > but it may well be that this only happens with negative dentries in
 > proc or sysfs, since you said that you just added testing of that..
 > 
 > > And now I'm getting a different BUG_ON
 > 
 > Heh. It's the same BUG_ON(), it's just replicated (and "parent" is
 > called "dir" here).
 > 
 > Maybe you can make the WARN_ON_ONCE() version be a macro, because that
 > test exists in multiple places: unlazy_walk, complete_walk,
 > lookup_slow and do_last (and walk_component in a different guise).

queue up the sad trombone noises.

One of the things trinity passes syscalls is a page of deformed unicode.
Apparently this page is so fucked up, that it crashes *printk*.

	Dave


[  131.811418] WARNING: at fs/namei.c:2746 do_last+0xdb5/0xec0()
[  131.812156] Hardware name: GA-MA78GM-S2H
[  131.812659] Modules linked in: netrom(+) ax25 caif_socket caif irda crc_ccitt ipx af_802154 p8023 p8022 decnet appletalk psnap x25 llc af_rxrpc rds atm pppoe pppox ppp_generic slhc phonet nfc can_raw can lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek snd_hda_intel snd_hda_codec btusb bluetooth snd_pcm microcode snd_page_alloc rfkill snd_timer snd serio_raw edac_core vhost_net usb_debug pcspkr tun macvtap macvlan soundcore kvm_amd r8169 kvm mii radeon backlight drm_kms_helper ttm
[  131.838316] Pid: 742, comm: trinity-child2 Not tainted 3.9.0-rc1+ #82
[  131.848590] Call Trace:
[  131.848969]  [<ffffffff81045115>] warn_slowpath_common+0x75/0xa0
[  131.849742]  [<ffffffff8104515a>] warn_slowpath_null+0x1a/0x20
[  131.850495]  [<ffffffff811cbb35>] do_last+0xdb5/0xec0
[  131.851150]  [<ffffffff811c7d78>] ? inode_permission+0x18/0x50
[  131.851900]  [<ffffffff811c7ff5>] ? link_path_walk+0x245/0x880
[  131.852651]  [<ffffffff811cbcfa>] path_openat+0xba/0x500
[  131.853340]  [<ffffffff810b27f8>] ? trace_hardirqs_off_caller+0x28/0xc0
[  131.854186]  [<ffffffff810b2722>] ? get_lock_stats+0x22/0x70
[  131.854915]  [<ffffffff810b2b8e>] ? put_lock_stats.isra.23+0xe/0x40
[  131.855718]  [<ffffffff811cc401>] do_filp_open+0x41/0xa0
[  131.856407]  [<ffffffff811dbc19>] ? __alloc_fd+0x179/0x230
[  131.857116]  [<ffffffff811bb414>] do_sys_open+0xf4/0x1e0
[  131.857804]  [<ffffffff811bb521>] sys_open+0x21/0x30
[  131.858517]  [<ffffffff816d1082>] system_call_fastpath+0x16/0x1b
[  131.859303]  [<ffffffffa0001001>] ? ttm_dma_tt_fini+0x71/0xa0 [ttm]
[  131.937423] ---[ end trace cfbe25dc62f850d2 ]---
[  131.938049]  ->
[  131.938274] general protection fault: 0000 [#1] 
[  131.938896] PREEMPT SMP 
[  131.939097] Modules linked in: netrom ax25 caif_socket caif irda crc_ccitt ipx af_802154 p8023 p8022 decnet appletalk psnap x25 llc af_rxrpc rds atm pppoe pppox ppp_generic slhc phonet nfc can_raw can lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek snd_hda_intel snd_hda_codec btusb bluetooth snd_pcm microcode snd_page_alloc rfkill snd_timer snd serio_raw edac_core vhost_net usb_debug pcspkr tun macvtap macvlan soundcore kvm_amd r8169 kvm mii radeon backlight drm_kms_helper ttm
[  131.947457] CPU 2 
[  131.947733] Pid: 742, comm: trinity-child2 Tainted: G        W    3.9.0-rc1+ #82 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
[  131.949341] RIP: 0010:[<ffffffff81345fdd>]  [<ffffffff81345fdd>] strnlen+0xd/0x40
[  131.950362] RSP: 0018:ffff88011084bae8  EFLAGS: 00010086
[  131.951062] RAX: ffffffff819e980c RBX: ffffffff82074da0 RCX: fffffffffffffffe
[  131.951985] RDX: af0f48ef7bdef7bd RSI: ffffffffffffffff RDI: af0f48ef7bdef7bd
[  131.952907] RBP: ffff88011084bae8 R08: 000000000000ffff R09: 000000000000ffff
[  131.953829] R10: 0000000000000001 R11: 0000000000000000 R12: af0f48ef7bdef7bd
[  131.954751] R13: ffffffff82075180 R14: 000000000000ffff R15: 0000000000000000
[  131.955674] FS:  00007f376da9b740(0000) GS:ffff88012b200000(0000) knlGS:0000000000000000
[  131.956714] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  131.957466] CR2: 00007f772904d000 CR3: 000000011082e000 CR4: 00000000000007e0
[  131.958388] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  131.959310] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  131.960234] Process trinity-child2 (pid: 742, threadinfo ffff88011084a000, task ffff880113ccc920)
[  131.961370] Stack:
[  131.961629]  ffff88011084bb28 ffffffff813479ce ffffffff81c2c600 ffffffff82074da0
[  131.962730]  ffffffff82075180 ffff88011084bc70 ffffffff819e7b02 ffffffff819e7b02
[  131.963848]  ffff88011084bba8 ffffffff81348ba9 ffffffff81c2c5a0 ffffffff810b27f8
[  131.966843] Call Trace:
[  131.969052]  [<ffffffff813479ce>] string.isra.3+0x3e/0xc0
[  131.971642]  [<ffffffff81348ba9>] vsnprintf+0x1f9/0x610
[  131.974208]  [<ffffffff810b27f8>] ? trace_hardirqs_off_caller+0x28/0xc0
[  131.976927]  [<ffffffff81349081>] vscnprintf+0x11/0x30
[  131.979441]  [<ffffffff810478f1>] vprintk_emit+0x111/0x590
[  131.981987]  [<ffffffff811cbb35>] ? do_last+0xdb5/0xec0
[  131.984503]  [<ffffffff816bb79b>] printk+0x61/0x63
[  131.986960]  [<ffffffff811cbb6b>] do_last+0xdeb/0xec0
[  131.989446]  [<ffffffff811c7d78>] ? inode_permission+0x18/0x50
[  131.992041]  [<ffffffff811c7ff5>] ? link_path_walk+0x245/0x880
[  131.994631]  [<ffffffff811cbcfa>] path_openat+0xba/0x500
[  131.997141]  [<ffffffff810b27f8>] ? trace_hardirqs_off_caller+0x28/0xc0
[  131.999804]  [<ffffffff810b2722>] ? get_lock_stats+0x22/0x70
[  132.002334]  [<ffffffff810b2b8e>] ? put_lock_stats.isra.23+0xe/0x40
[  132.004941]  [<ffffffff811cc401>] do_filp_open+0x41/0xa0
[  132.007428]  [<ffffffff811dbc19>] ? __alloc_fd+0x179/0x230
[  132.009899]  [<ffffffff811bb414>] do_sys_open+0xf4/0x1e0
[  132.012297]  [<ffffffff811bb521>] sys_open+0x21/0x30
[  132.014603]  [<ffffffff816d1082>] system_call_fastpath+0x16/0x1b
[  132.016993]  [<ffffffffa0001001>] ? ttm_dma_tt_fini+0x71/0xa0 [ttm]
[  132.019385] Code: c0 80 38 00 75 f8 48 29 f8 5d c3 31 c0 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 85 f6 48 8d 4e ff 48 89 e5 74 28 <80> 3f 00 74 23 48 89 f8 31 d2 eb 0f 0f 1f 80 00 00 00 00 48 ff 
[  132.026917] RIP  [<ffffffff81345fdd>] strnlen+0xd/0x40
[  132.029301]  RSP <ffff88011084bae8>


It then goes into a death spiral recursing over the same trace.

	Dave

