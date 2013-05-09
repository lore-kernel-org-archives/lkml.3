Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab3EIEfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 00:35:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab3EIEfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 00:35:38 -0400
Date: Thu, 9 May 2013 00:35:32 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, davidlohr.bueso@hp.com,
        riel@redhat.com, viro@zeniv.linux.org.uk
Subject: SHM oops in newseg()
Message-ID: <20130509043532.GA28235@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, davidlohr.bueso@hp.com,
	riel@redhat.com, viro@zeniv.linux.org.uk
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just saw this on v3.9-11789-ge0fd9af while fuzz-testing.

[  163.917836] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[  163.918984] IP: [<ffffffff812c48ed>] newseg+0x10d/0x390
[  163.919705] PGD cf8c1067 PUD cf8c2067 PMD 0 
[  163.920326] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  163.921096] Modules linked in: hidp bnep l2tp_ppp l2tp_netlink l2tp_core ipt_ULOG rfcomm can_bcm cmtp kernelcapi nfnetlink scsi_transport_iscsi can_raw ipx p8023 pppoe p8022 phonet af_rxrpc pppox caif_socket ppp_generic caif rose af_802154 slhc llc2 nfc appletalk decnet atm rds psnap llc can netrom af_key x25 ax25 irda crc_ccitt lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek snd_hda_intel raid0 snd_hda_codec kvm_amd snd_pcm kvm btusb bluetooth microcode serio_raw snd_page_alloc snd_timer pcspkr snd rfkill edac_core soundcore r8169 mii radeon backlight drm_kms_helper ttm
[  163.929949] CPU: 2 PID: 7636 Comm: trinity-child2 Not tainted 3.9.0+ #67
[  163.931276] Hardware name: Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H, BIOS F12a 04/23/2010
[  163.932551] task: ffff88011bc04a00 ti: ffff8800cf920000 task.ti: ffff8800cf920000
[  163.933541] RIP: 0010:[<ffffffff812c48ed>]  [<ffffffff812c48ed>] newseg+0x10d/0x390
[  163.934573] RSP: 0018:ffff8800cf921e78  EFLAGS: 00010246
[  163.935281] RAX: 0000000000000000 RBX: ffffffff81c77a20 RCX: 0000000000000009
[  163.936225] RDX: ffffffff82ab62b8 RSI: 0000000000001000 RDI: 0000000000008000
[  163.937169] RBP: ffff8800cf921ec8 R08: 0000000000000010 R09: 000000000000000f
[  163.938113] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000001fff
[  163.939057] R13: ffff8800cfa30b80 R14: 000000003f43df5b R15: 0000000000000000
[  163.940005] FS:  00007f8391182740(0000) GS:ffff88012aa00000(0000) knlGS:0000000000000000
[  163.941077] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  163.941843] CR2: 0000000000000008 CR3: 00000000cf8c0000 CR4: 00000000000007e0
[  163.942789] Stack:
[  163.943067]  0000000f81c77c50 0000000000000002 3056535953c77c50 0030303030303030
[  163.944115]  00000000bf3b8607 0000000000000000 0000000000000010 ffffffff81c77c50
[  163.948881]  00000000000000e8 0000000000000002 ffff8800cf921f40 ffffffff812be322
[  163.953629] Call Trace:
[  163.957706]  [<ffffffff812be322>] ipcget+0x182/0x380
[  163.962123]  [<ffffffff810b99a5>] ? trace_hardirqs_on_caller+0x115/0x1e0
[  163.966752]  [<ffffffff812c559a>] SyS_shmget+0x5a/0x60
[  163.971163]  [<ffffffff812c47e0>] ? shm_close+0x140/0x140
[  163.975590]  [<ffffffff812c3e60>] ? shm_release+0x50/0x50
[  163.979991]  [<ffffffff812c3df0>] ? shm_get_unmapped_area+0x20/0x20
[  163.984499]  [<ffffffff816caa14>] tracesys+0xdd/0xe2
[  163.988868] Code: c6 00 08 00 00 0f 84 f3 00 00 00 45 89 f1 41 c1 e9 1a 0f 85 2e 01 00 00 8b 05 70 1e 7f 01 48 69 c0 98 04 00 00 48 05 20 5e ab 82 <8b> 48 08 b8 00 10 00 00 4c 89 f2 48 c1 e2 09 48 8d 7d c3 41 b8 
[  164.000083] RIP  [<ffffffff812c48ed>] newseg+0x10d/0x390
[  164.004681]  RSP <ffff8800cf921e78>
[  164.009000] CR2: 0000000000000008
[  164.064784] ---[ end trace e74858ae5e89f4a7 ]---


That Code: line decoded seems to point at..

static inline unsigned long huge_page_size(struct hstate *h)
{
        return (unsigned long)PAGE_SIZE << h->order;
     bfd:       8b 48 08                mov    0x8(%rax),%ecx
     c00:       b8 00 10 00 00          mov    $0x1000,%eax

