Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab3BWBG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 20:06:28 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:39304 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab3BWBGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 20:06:25 -0500
Date: Fri, 22 Feb 2013 20:06:07 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Samu Kallio <samu.kallio@aberdeencloud.com>, mingo@redhat.com
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
        xen-devel@lists.xensource.com
Subject: Re: x86: mm: Fix vmalloc_fault oops during lazy MMU updates.
Message-ID: <20130223010607.GA15337@phenom.dumpdata.com>
References: <1361068552-21529-1-git-send-email-samu.kallio@aberdeencloud.com>
 <20130221123306.GA6781@phenom.dumpdata.com>
 <CAOn_CrHifkBieZumEBje1FiSU3abJrZ8QRKK4FGkKbp217He9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOn_CrHifkBieZumEBje1FiSU3abJrZ8QRKK4FGkKbp217He9w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 05:56:35PM +0200, Samu Kallio wrote:
> On Thu, Feb 21, 2013 at 2:33 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > On Sun, Feb 17, 2013 at 02:35:52AM -0000, Samu Kallio wrote:
> >> In paravirtualized x86_64 kernels, vmalloc_fault may cause an oops
> >> when lazy MMU updates are enabled, because set_pgd effects are being
> >> deferred.
> >>
> >> One instance of this problem is during process mm cleanup with memory
> >> cgroups enabled. The chain of events is as follows:
> >>
> >> - zap_pte_range enables lazy MMU updates
> >> - zap_pte_range eventually calls mem_cgroup_charge_statistics,
> >>   which accesses the vmalloc'd mem_cgroup per-cpu stat area
> >> - vmalloc_fault is triggered which tries to sync the corresponding
> >>   PGD entry with set_pgd, but the update is deferred
> >> - vmalloc_fault oopses due to a mismatch in the PUD entries
> >>
> >> Calling arch_flush_lazy_mmu_mode immediately after set_pgd makes the
> >> changes visible to the consistency checks.
> >
> > How do you reproduce this? Is there a BUG() or WARN() trace that
> > is triggered when this happens?
> 
> In my case I've seen this triggered on an Amazon EC2 (Xen PV) instance
> under heavy load spawning many LXC containers. The best I can say at
> this point is that the frequency of this bug seems to be linked to how
> busy the machine is.
> 
> The earliest report of this problem was from 3.3:
>     http://comments.gmane.org/gmane.linux.kernel.cgroups/5540
> I can personally confirm the issue since 3.5.
> 
> Here's a sample bug report from a 3.7 kernel (vanilla with Xen XSAVE patch
> for EC2 compatibility). The latest kernel version I have tested and seen this
> problem occur is 3.7.9.

Ingo,

I am OK with this patch. Are you OK taking this in or should I take
it (and add the nice RIP below)?

It should also have CC: stable@vger.kernel.org on it.

FYI, There is also a Red Hat bug for this: https://bugzilla.redhat.com/show_bug.cgi?id=914737

> 
> [11852214.733630] ------------[ cut here ]------------
> [11852214.733642] kernel BUG at arch/x86/mm/fault.c:397!
> [11852214.733648] invalid opcode: 0000 [#1] SMP
> [11852214.733654] Modules linked in: veth xt_nat xt_comment fuse btrfs
> libcrc32c zlib_deflate ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat
> xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack
> bridge stp llc iptable_filter ip_tables x_tables ghash_clmulni_intel
> aesni_intel aes_x86_64 ablk_helper cryptd xts lrw gf128mul microcode
> ext4 crc16 jbd2 mbcache
> [11852214.733695] CPU 1
> [11852214.733700] Pid: 1617, comm: qmgr Not tainted 3.7.0-1-ec2 #1
> [11852214.733705] RIP: e030:[<ffffffff8143018d>]  [<ffffffff8143018d>]
> vmalloc_fault+0x14b/0x249
> [11852214.733725] RSP: e02b:ffff88083e57d7f8  EFLAGS: 00010046
> [11852214.733730] RAX: 0000000854046000 RBX: ffffe8ffffc80d70 RCX:
> ffff880000000000
> [11852214.733736] RDX: 00003ffffffff000 RSI: ffff880854046ff8 RDI:
> 0000000000000000
> [11852214.733744] RBP: ffff88083e57d818 R08: 0000000000000000 R09:
> ffff880000000ff8
> [11852214.733750] R10: 0000000000007ff0 R11: 0000000000000001 R12:
> ffff880854686e88
> [11852214.733758] R13: ffffffff8180ce88 R14: ffff88083e57d948 R15:
> 0000000000000000
> [11852214.733768] FS:  00007ff3bf0f8740(0000)
> GS:ffff88088b480000(0000) knlGS:0000000000000000
> [11852214.733777] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> [11852214.733782] CR2: ffffe8ffffc80d70 CR3: 0000000854686000 CR4:
> 0000000000002660
> [11852214.733790] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [11852214.733796] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [11852214.733803] Process qmgr (pid: 1617, threadinfo
> ffff88083e57c000, task ffff88084474b3e0)
> [11852214.733810] Stack:
> [11852214.733814]  0000000000000029 0000000000000002 ffffe8ffffc80d70
> ffff88083e57d948
> [11852214.733828]  ffff88083e57d928 ffffffff8103e0c7 0000000000000000
> ffff88083e57d8d0
> [11852214.733840]  ffff88084474b3e0 0000000000000060 0000000000000000
> 0000000000006cf6
> [11852214.733852] Call Trace:
> [11852214.733861]  [<ffffffff8103e0c7>] __do_page_fault+0x2c7/0x4a0
> [11852214.733871]  [<ffffffff81004ac2>] ? xen_mc_flush+0xb2/0x1b0
> [11852214.733880]  [<ffffffff810032ce>] ? xen_end_context_switch+0x1e/0x30
> [11852214.733888]  [<ffffffff810043cb>] ? xen_write_msr_safe+0x9b/0xc0
> [11852214.733900]  [<ffffffff810125b3>] ? __switch_to+0x163/0x4a0
> [11852214.733907]  [<ffffffff8103e2de>] do_page_fault+0xe/0x10
> [11852214.733919]  [<ffffffff81437f98>] page_fault+0x28/0x30
> [11852214.733930]  [<ffffffff8115e873>] ?
> mem_cgroup_charge_statistics.isra.12+0x13/0x50
> [11852214.733940]  [<ffffffff8116012e>] __mem_cgroup_uncharge_common+0xce/0x2d0
> [11852214.733948]  [<ffffffff81007fee>] ? xen_pte_val+0xe/0x10
> [11852214.733958]  [<ffffffff8116391a>] mem_cgroup_uncharge_page+0x2a/0x30
> [11852214.733966]  [<ffffffff81139e78>] page_remove_rmap+0xf8/0x150
> [11852214.733976]  [<ffffffff8112d78a>] ? vm_normal_page+0x1a/0x80
> [11852214.733984]  [<ffffffff8112e5b3>] unmap_single_vma+0x573/0x860
> [11852214.733994]  [<ffffffff81114520>] ? release_pages+0x1f0/0x230
> [11852214.734004]  [<ffffffff810054aa>] ? __xen_pgd_walk+0x16a/0x260
> [11852214.734018]  [<ffffffff8112f0b2>] unmap_vmas+0x52/0xa0
> [11852214.734026]  [<ffffffff81136e08>] exit_mmap+0x98/0x170
> [11852214.734034]  [<ffffffff8104b929>] mmput+0x59/0x110
> [11852214.734043]  [<ffffffff81053d95>] exit_mm+0x105/0x130
> [11852214.734051]  [<ffffffff814376e0>] ? _raw_spin_lock_irq+0x10/0x40
> [11852214.734059]  [<ffffffff81053f27>] do_exit+0x167/0x900
> [11852214.734070]  [<ffffffff8106093d>] ? __sigqueue_free+0x3d/0x50
> [11852214.734079]  [<ffffffff81060b9e>] ? __dequeue_signal+0x10e/0x1f0
> [11852214.734087]  [<ffffffff810549ff>] do_group_exit+0x3f/0xb0
> [11852214.734097]  [<ffffffff81063431>] get_signal_to_deliver+0x1c1/0x5e0
> [11852214.734107]  [<ffffffff8101334f>] do_signal+0x3f/0x960
> [11852214.734114]  [<ffffffff811aae61>] ? ep_poll+0x2a1/0x360
> [11852214.734122]  [<ffffffff81083420>] ? try_to_wake_up+0x2d0/0x2d0
> [11852214.734129]  [<ffffffff81013cd8>] do_notify_resume+0x48/0x60
> [11852214.734138]  [<ffffffff81438a5a>] int_signal+0x12/0x17
> [11852214.734143] Code: ff ff 3f 00 00 48 21 d0 4c 8d 0c 30 ff 14 25
> b8 f3 81 81 48 21 d0 48 01 c6 48 83 3e 00 0f 84 fa 00 00 00 49 8b 39
> 48 85 ff 75 02 <0f> 0b ff 14 25 e0 f3 81 81 49 89 c0 48 8b 3e ff 14 25
> e0 f3 81
> [11852214.734212] RIP  [<ffffffff8143018d>] vmalloc_fault+0x14b/0x249
> [11852214.734222]  RSP <ffff88083e57d7f8>
> [11852214.734231] ---[ end trace 81ac798210f95867 ]---
> [11852214.734237] Fixing recursive fault but reboot is needed!
> 
> > Also pls next time also CC me.
> 
> Will do, I originally CC'd Jeremy since made some lazy MMU related
> cleanups in arch/x86/mm/fault.c, and I thought he might have a comment
> on this.
