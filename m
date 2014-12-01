Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbaLAWJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:09:03 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26095 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932660AbaLAWIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:08:51 -0500
Date: Mon, 1 Dec 2014 11:51:55 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Waiman Long <waiman.long@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>
Subject: Re: [PATCH v12 09/11] pvqspinlock, x86: Add para-virtualization
 support
Message-ID: <20141201165155.GH3180@laptop.dumpdata.com>
References: <1413483040-58399-1-git-send-email-Waiman.Long@hp.com>
 <1413483040-58399-10-git-send-email-Waiman.Long@hp.com>
 <20141024085437.GV21513@worktop.programming.kicks-ass.net>
 <544E830C.6070307@hp.com>
 <20141027180252.GC12989@laptop.dumpdata.com>
 <54751FF6.5050808@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54751FF6.5050808@hp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 07:33:58PM -0500, Waiman Long wrote:
> On 10/27/2014 02:02 PM, Konrad Rzeszutek Wilk wrote:
> >On Mon, Oct 27, 2014 at 01:38:20PM -0400, Waiman Long wrote:
> >>
> >>My concern is that spin_unlock() can be called in many places, including
> >>loadable kernel modules. Can the paravirt_patch_ident_32() function able to
> >>patch all of them in reasonable time? How about a kernel module loaded later
> >>at run time?
> >It has too. When the modules are loaded the .paravirt symbols are exposed
> >and the module loader patches that.
> >
> >And during bootup time (before modules are loaded) it also patches everything
> >- when it only runs on one CPU.
> >
> 
> I have been changing the patching code to patch the unlock call sites and it
> seems to be working now. However, when I manually inserted a kernel module
> using insmod and run the code in the newly inserted module, I got memory
> access violation as follows:
> 
> BUG: unable to handle kernel NULL pointer dereference at           (null)
> IP: [<          (null)>]           (null)
> PGD 18d62f3067 PUD 18d476f067 PMD 0
> Oops: 0010 [#1] SMP
> Modules linked in: locktest(OE) ebtable_nat ebtables xt_CHECKSUM
> iptable_mangle bridge autofs4 8021q garp stp llc ipt_REJECT
> nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT
> nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter
> ip6_tables ipv6 vhost_net macvtap macvlan vhost tun uinput ppdev parport_pc
> parport sg microcode pcspkr virtio_balloon snd_hda_codec_generic
> virtio_console snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep
> snd_seq snd_seq_device snd_pcm snd_timer snd soundcore virtio_net i2c_piix4
> i2c_core ext4(E) jbd2(E) mbcache(E) floppy(E) virtio_blk(E) sr_mod(E)
> cdrom(E) virtio_pci(E) virtio_ring(E) virtio(E) pata_acpi(E) ata_generic(E)
> ata_piix(E) dm_mirror(E) dm_region_hash(E) dm_log(E) dm_mod(E) [last
> unloaded: speedstep_lib]
> CPU: 1 PID: 3907 Comm: run-locktest Tainted: G        W  OE  3.17.0-pvqlock
> #3
> Hardware name: Red Hat KVM, BIOS Bochs 01/01/2011
> task: ffff8818cc5baf90 ti: ffff8818b7094000 task.ti: ffff8818b7094000
> RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
> RSP: 0018:ffff8818b7097db0  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 00000000004c4b40 RCX: 0000000000000000
> RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8818d3f052c0
> RBP: ffff8818b7097dd8 R08: 0000000080522014 R09: 0000000000000000
> R10: 0000000000001000 R11: 0000000000000001 R12: 0000000000000001
> R13: 0000000000000000 R14: 0000000000000001 R15: ffff8818b7097ea0
> FS:  00007fb828ece700(0000) GS:ffff88193ec20000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 00000018cc7e9000 CR4: 00000000000006e0
> Stack:
>  ffffffffa06ff395 ffff8818d465e000 ffffffff8164bec0 0000000000000001
>  0000000000000050 ffff8818b7097e18 ffffffffa06ff785 ffff8818b7097e38
>  0000000000000246 0000000054755e3a 0000000039f8ba72 ffff8818c174f000
> Call Trace:
>  [<ffffffffa06ff395>] ? test_spinlock+0x65/0x90 [locktest]
>  [<ffffffffa06ff785>] etime_show+0xd5/0x120 [locktest]
>  [<ffffffff812a2dc6>] kobj_attr_show+0x16/0x20
>  [<ffffffff8121a7fa>] sysfs_kf_seq_show+0xca/0x1b0
>  [<ffffffff81218a13>] kernfs_seq_show+0x23/0x30
>  [<ffffffff811c82db>] seq_read+0xbb/0x400
>  [<ffffffff812197e5>] kernfs_fop_read+0x35/0x40
>  [<ffffffff811a4223>] vfs_read+0xa3/0x110
>  [<ffffffff811a47e6>] SyS_read+0x56/0xd0
>  [<ffffffff810f3e16>] ? __audit_syscall_exit+0x216/0x2c0
>  [<ffffffff815b3ca9>] system_call_fastpath+0x16/0x1b
> Code:  Bad RIP value.
>  RSP <ffff8818b7097db0>
> CR2: 0000000000000000
> ---[ end trace 69d0e259c9ec632f ]---
> 
> It seems like call site patching isn't properly done or the kernel module
> that I built was missing some critical information necessary for the proper

Did the readelf give you the paravirt note section?
> linking. Anyway, I will include the unlock call patching code as a separate
> patch as it seems there may be problem under certain circumstance.

one way to troubleshoot those is to enable the paravirt patching code to
actually print where it is patching the code. That way when you load the
module you can confirm it has done its job.

Then you can verify that the address  where the code is called:

ffffffffa06ff395

is indeed patched. You might as well also do a hexdump in the module loading
to confim that the patching had been done correctly.
> 
> BTW, the kernel panic problem that your team reported had been fixed. The
> fix will be in the next version of the patch.
> 
> -Longman
