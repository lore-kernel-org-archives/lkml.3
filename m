Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab3CUVDC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:03:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab3CUVC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:02:59 -0400
Date: Thu, 21 Mar 2013 17:02:55 -0400
From: Dave Jones <davej@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: VFS deadlock ?
Message-ID: <20130321210255.GD16406@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130321190653.GA15479@redhat.com>
 <20130321192935.GY21522@ZenIV.linux.org.uk>
 <CA+55aFyvwJK99YvDLDsazD4tWT6sNQO6kGM_1WyDdvwPNDxbLw@mail.gmail.com>
 <20130321202635.GA16406@redhat.com>
 <CA+55aFwyK4uDgSKUpXBGS5zi16qd8STtrGi3kndunYi40dnj+A@mail.gmail.com>
 <20130321203639.GC16406@redhat.com>
 <20130321204704.GZ21522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321204704.GZ21522@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 08:47:04PM +0000, Al Viro wrote:
 > On Thu, Mar 21, 2013 at 04:36:39PM -0400, Dave Jones wrote:
 > > at some point during the fuzz run, this happened..
 > > 
 > > Mar 20 15:20:41 kernel: [ 7578.784674] fuse init (API version 7.21)
 > > Mar 20 15:20:41 systemd[1]: Mounting FUSE Control File System...
 > > Mar 20 15:20:41 systemd[1]: Mounted FUSE Control File System.
 > > 
 > > I guess something wandered into /dev/fuse and did something. Not sure why 
 > > systemd reacted though...
 > 
 > AFAICS, fuse uses d_materialise_unique() and d_splice_alias(), though, so
 > it's not too likely source of that crap; there's no d_instantiate() calls
 > at all and the sole d_add() is using an inode that has just been allocated,
 > so it won't be creating aliases either...

here we go...

WARNING: at fs/namei.c:2335 lock_rename+0x156/0x160()
Hardware name: GA-MA78GM-S2H
Modules linked in: vmw_vsock_vmci_transport vmw_vmci vsock hidp cmtp kernelcapi bnep caif_socket caif phonet nfnetlink rfcomm l2tp_ppp l2tp_netlink l2tp_core rose pppoe pppox ppp_generic slhc llc2 netrom af_key can_raw af_rxrpc scsi_transport_iscsi ipt_ULOG appletalk irda crc_ccitt decnet can_bcm can rds atm x25 ipx p8023 psnap p8022 llc ax25 nfc af_802154 lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek snd_hda_intel snd_hda_codec btusb snd_pcm bluetooth rfkill snd_page_alloc snd_timer microcode serio_raw pcspkr snd edac_core soundcore r8169 mii vhost_net tun macvtap macvlan kvm_amd kvm radeon backlight drm_kms_helper ttm
Pid: 5633, comm: trinity-child3 Not tainted 3.9.0-rc3+ #107
Call Trace:
 [<ffffffff810450f5>] warn_slowpath_common+0x75/0xa0
 [<ffffffff810451da>] warn_slowpath_null+0x1a/0x20
 [<ffffffff811c6df6>] lock_rename+0x156/0x160
 [<ffffffff811cd907>] sys_renameat+0x1f7/0x3b0
 [<ffffffff810b33a2>] ? get_lock_stats+0x22/0x70
 [<ffffffff810b6b95>] ? trace_hardirqs_on_caller+0x115/0x1a0
 [<ffffffff810b6b95>] ? trace_hardirqs_on_caller+0x115/0x1a0
 [<ffffffff8134a3ae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff816cd242>] system_call_fastpath+0x16/0x1b
---[ end trace 421592dfa22abfb0 ]---
p1=irda p2=irda



followed by...  


=====================================
[ BUG: bad unlock balance detected! ]
3.9.0-rc3+ #107 Tainted: G        W   
-------------------------------------
trinity-child3/5633 is trying to release lock (&type->i_mutex_dir_key) at:
[<ffffffff816c104e>] mutex_unlock+0xe/0x10
but there are no more locks to release!

other info that might help us debug this:
1 lock on stack by trinity-child3/5633:
 #0: blocked:  (sb_writers#4){.+.+.+}, instance: ffff8801292d17d8, at: [<ffffffff811df294>] mnt_want_write+0x24/0x50

stack backtrace:
Pid: 5633, comm: trinity-child3 Tainted: G        W    3.9.0-rc3+ #107
Call Trace:
 [<ffffffff816c104e>] ? mutex_unlock+0xe/0x10
 [<ffffffff810b4e10>] print_unlock_imbalance_bug+0x100/0x110
 [<ffffffff810b9417>] lock_release_non_nested+0x257/0x320
 [<ffffffff810b3288>] ? trace_hardirqs_off_caller+0x28/0xc0
 [<ffffffff816c104e>] ? mutex_unlock+0xe/0x10
 [<ffffffff816c104e>] ? mutex_unlock+0xe/0x10
 [<ffffffff810b9587>] lock_release+0xa7/0x310
 [<ffffffff816c0f4a>] __mutex_unlock_slowpath+0x8a/0x180
 [<ffffffff816c104e>] mutex_unlock+0xe/0x10
 [<ffffffff811c67f1>] unlock_rename+0x41/0x60
 [<ffffffff811cd996>] sys_renameat+0x286/0x3b0
 [<ffffffff810b33a2>] ? get_lock_stats+0x22/0x70
 [<ffffffff810b6b95>] ? trace_hardirqs_on_caller+0x115/0x1a0
 [<ffffffff810b6b95>] ? trace_hardirqs_on_caller+0x115/0x1a0
 [<ffffffff8134a3ae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff816cd242>] system_call_fastpath+0x16/0x1b

