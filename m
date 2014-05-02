Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbaEBVCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 17:02:35 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:50051 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaEBVCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 17:02:32 -0400
Date: Fri, 2 May 2014 23:02:23 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140502210223.GA32527@tucsk.piliscsaba.szeredi.hu>
References: <20140429191015.GK18016@ZenIV.linux.org.uk>
 <20140429211851.GA32204@dastard>
 <20140429214842.GL18016@ZenIV.linux.org.uk>
 <CA+55aFwcWcyRpwv3us9BbnsjUEfEr1mRjz4RWbcy_tSnZjc_Sw@mail.gmail.com>
 <20140429232013.GM18016@ZenIV.linux.org.uk>
 <20140430023142.GN18016@ZenIV.linux.org.uk>
 <CA+55aFypNxsjJTq_rc2Jx4p_3scJo2VWdt=e8n-9eJ-ZQphnpQ@mail.gmail.com>
 <20140430091515.GB3113@tucsk.piliscsaba.szeredi.hu>
 <20140502055127.GH18016@ZenIV.linux.org.uk>
 <CAELBmZC9g91+8B6HsnbmwWJBmiYXgMW6QfdREJYyd8EP5RpRpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAELBmZC9g91+8B6HsnbmwWJBmiYXgMW6QfdREJYyd8EP5RpRpQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 11:00:04AM +0200, Szeredi Miklos wrote:

> The bug is private, but I'll ask if I can repost it.  The first thing
> is a a warning from the D_FLAG_VERIFY() in d_shrink_del() from
> shrink_dentry_list().  They added printks that show that the dentry
> has DCACHE_DENTRY_KILLED.
> 
> We could ask for a dump, but this is the only rational explanation I
> could find for this (and a shrink list with two dentries, with racing
> dput on both nicely explains the case where the shrink list's prev
> pointer still points to the already killed dentry).

Bug details:

==============================================================================
WARNING: at
/home/abuild/rpmbuild/BUILD/kernel-default-3.12.15/linux-3.12/fs/dcache.c:392
 Modules linked in: iptable_filter ip_tables x_tables rpcsec_gss_krb5
auth_rpcgss nfsv4 dns_resolver nfs lockd sunrpc fscache af_pac        ket xfs
libcrc32c dm_mod autofs4 btrfs xor sr_mod cdrom usb_storage raid6_pq sd_mod
crc_t10dif ibmvscsi(X) scsi_transport_srp scsi_        tgt ibmveth(X) ohci_pci
ohci_hcd ehci_hcd usbcore usb_common sg scsi_mod
 Supported: Yes
 CPU: 7 PID: 25685 Comm: host01 Tainted: G              X 3.12.15-3-default #1
 task: c0000003f7fb68f0 ti: c0000003f31f4000 task.ti: c0000003f31f4000
 NIP: c00000000024552c LR: c0000000002462b8 CTR: c0000000002aad40
 REGS: c0000003f31f7530 TRAP: 0700   Tainted: G              X 
(3.12.15-3-default)
 MSR: 8000000100029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 24242448  XER: 20000000
 SOFTE: 1
 CFAR: c0000000002454b0

 GPR00: c0000000002462b8 c0000003f31f77b0 c000000000f10fb0 c0000003dfa7f028
 GPR04: 0000000000000001 c000000000e4fe00 0000000000000000 0600000000000000
 GPR08: c000000000e30fb0 0000000000000001 0000000000000000 0000000000000000
 GPR12: 0000000024242442 c00000000fe41880 0000000000000000 0000000000000000
 GPR16: 0000000000000000 0000010013556de0 0000000000006458 0000000000000002
 GPR20: 0000000000000000 c00000000084e940 0000000000000004 c0000003f8afa400
 GPR24: 0000000000006457 c0000003fde09e68 0000000000000000 0000000000000000
 GPR28: c0000003dfa7f028 c0000003dfa7f028 c0000003f31f7948 c0000003dfa7f0a8
 NIP [c00000000024552c] .d_shrink_del+0x9c/0xc0
 LR [c0000000002462b8] .shrink_dentry_list+0xc8/0x160
 PACATMSCRATCH [8000000100009033]
 Call Trace:
 [c0000003f31f77b0] [c0000003f8f1ef80] 0xc0000003f8f1ef80 (unreliable)
 [c0000003f31f7820] [c0000000002462b8] .shrink_dentry_list+0xc8/0x160
 [c0000003f31f78d0] [c000000000246754] .shrink_dcache_parent+0x44/0xa0
 [c0000003f31f7980] [c0000000002b0a0c] .proc_flush_task+0xbc/0x1f0
 [c0000003f31f7a70] [c00000000008e554] .release_task+0x94/0x530
 [c0000003f31f7b50] [c00000000008efb8] .wait_task_zombie+0x5c8/0x750
 [c0000003f31f7c10] [c00000000008fa80] .do_wait+0x120/0x2c0
 [c0000003f31f7cd0] [c000000000091040] .SyS_wait4+0x90/0x130
 [c0000003f31f7dc0] [c0000000000910fc] .SyS_waitpid+0x1c/0x30
 [c0000003f31f7e30] [c000000000009dfc] syscall_exit+0x0/0x7c
 Instruction dump:
 7d09502a 3908ffff 7d09512a 4bdcaf19 60000000 38210070 e8010010 7c0803a6
 4e800020 3d02fff2 8928dfd6 69290001 <0b090000> 2fa90000 41feff80 39200001
 ---[ end trace 56e8481827564dc3 ]---
==============================================================================
I forgot to mention that the TCP test used in the recreates is from the LTP
suite from http://ltp.sourceforge.net

It has been observed that each time we run into it so far, the host01 test is
the one running.
==============================================================================
After installing the kernel with some conditional printk statements in it, the
condition hit and I caught a glimpse of it. I then dropped the system into xmon
to dump out some further info:

When we first detect that the dentry->d_flags is missing these flags
DCACHE_SHRINK_LIST | DCACHE_LRU_LIST we start to dump some information about
the dentry from within shrink_dentry_list() and got:

dentry c0000003d6240ce8 name 5 lockcnt -128 flags 1048780
post-shrink-del: dentry c0000003d6240ce8 name 5 lockcnt -128
dentry c0000003d6240ce8 lockcnt -128
dentry c0000003d6240ce8 name 5 lockcnt -128 flags 1048780
post-shrink-del: dentry c0000003d6240ce8 name 5 lockcnt -128
dentry c0000003d6240ce8 lockcnt -128
dentry c0000003d6240ce8 name 5 lockcnt -128 flags 1048780

and this repeats over and over...

The code (with printks) looks like this:

 899         for (;;) {
 900                 dentry = list_entry_rcu(list->prev, struct dentry, d_lru);
 901                 if (&dentry->d_lru == list)
 902                         break; /* empty */
 903 
 904                 if (print_more)
 905                         printk(KERN_WARNING "dentry %p lockcnt %d\n",
 906                                 dentry, dentry->d_lockref.count);
 907 
 908                 /*
 909                  * Get the dentry lock, and re-verify that the dentry is
 910                  * this on the shrinking list. If it is, we know that
 911                  * DCACHE_SHRINK_LIST and DCACHE_LRU_LIST are set.
 912                  */
 913                 spin_lock(&dentry->d_lock);
 914                 if (dentry != list_entry(list->prev, struct dentry,
d_lru)) {
 915                         spin_unlock(&dentry->d_lock);
 916                         continue;
 917                 }
 918 
 919                 /*
 920                  * Check that both bits are set before calling
d_shrink_del()
 921                  * If we find out they are not print out some information
on
 922                  * the dentry and enable the tracing on the rest of the
code
 923                  * path.
 924                  */
 925                 if (D_FLAG_VERIFY(dentry, DCACHE_SHRINK_LIST |
DCACHE_LRU_LIST)) {
 926                         printk(KERN_WARNING "dentry %p name %s lockcnt %d
flags %d\n",
 927                                 dentry, dentry->d_name.name,
 928                                 dentry->d_lockref.count
 929                                 dentry->d_flags);
 930                         print_more = true;
 931                 }
 932 
 933                 /*
 934                  * The dispose list is isolated and dentries are not
accounted
 935                  * to the LRU here, so we can simply remove it from the
list
 936                  * here regardless of whether it is referenced or not.
 937                  */
 938                 d_shrink_del(dentry);
 939 
 940                 /*
 941                  * We found an inuse dentry which was not removed from
 942                  * the LRU because of laziness during lookup. Do not free
it.
 943                  */
 944                 if (dentry->d_lockref.count) {
 945                         spin_unlock(&dentry->d_lock);
 946                         if (print_more)
 947                                 printk(KERN_WARNING "post-shrink-del:
dentry %p name %s lockcnt %d\n",
 948                                         dentry, dentry->d_name.name,
 949                                         dentry->d_lockref.count);
 950                         continue;
 951                 }

and based on the debug output we seem to be processing the same "dentry" each
time. The dentry->d_lockref.count being negative seems bad.

After breaking into xmon and dumping said dentry, it looks like this:

0:mon> d c0000003d6240ce8 200
c0000003d6240ce8 cc00100004000000 0000000000000000  |................|
c0000003d6240cf8 0000000000000000 2851fcfd030000c0  |........(Q......|
c0000003d6240d08 9124000001000000 200d24d6030000c0  |.$...... .$.....|
c0000003d6240d18 0000000000000000 3500740073797374  |........5.t.syst|
c0000003d6240d28 656d73005861004e 00000000ff000000  |ems.Xa.N........|
c0000003d6240d38 0000000000010000 0000000080ffffff  |................|
c0000003d6240d48 8093f900000000c0 80b6a8f8030000c0  |................|
c0000003d6240d58 0000000010010000 0000000000000000  |................|
c0000003d6240d68 680d24d6030000c0 680d24d6030000c0  |h.$.....h.$.....|
c0000003d6240d78 a08d07d6030000c0 489dfe00000000c0  |........H.......|
c0000003d6240d88 880d24d6030000c0 880d24d6030000c0  |..$.......$.....|
c0000003d6240d98 0000000000000000 0000000000000000  |................|
c0000003d6240da8 cc00080002000000 0000000000000000  |................|
c0000003d6240db8 b0b22200000000d0 e8601afd030000c0  |.."......`......|
c0000003d6240dc8 49218a0104000000 e00d24d6030000c0  |I!........$.....|
c0000003d6240dd8 381359d6030000c0 64617461004e4b00  |8.Y.....data.NK.|
c0000003d6240de8 6b0073006f2e3000 002e300054010000  |k.s.o.0...0.T...|
c0000003d6240df8 0000000000000000 0000000000000000  |................|
c0000003d6240e08 00878f05000000d0 80c213f6030000c0  |................|
c0000003d6240e18 0000000000000000 0000000000000000  |................|
c0000003d6240e28 284d24d6030000c0 28ce24d6030000c0  |(M$.....(.$.....|
c0000003d6240e38 38ce24d6030000c0 384d24d6030000c0  |8.$.....8M$.....|
c0000003d6240e48 480e24d6030000c0 480e24d6030000c0  |H.$.....H.$.....|
c0000003d6240e58 0000000000000000 501459d6030000c0  |........P.Y.....|
c0000003d6240e68 cc00080002000000 0000000000000000  |................|
c0000003d6240e78 c0e77100000000d0 28e41ffd030000c0  |..q.....(.......|
c0000003d6240e88 19f7f3ba06000000 a00e24d6030000c0  |..........$.....|
c0000003d6240e98 f09a33d6030000c0 6465766963650000  |..3.....device..|
c0000003d6240ea8 6b007300e84b0e72 86dc4788485bcc3e  |k.s..K.r..G.H[.>|
c0000003d6240eb8 d306777b71e75300 0000000000000000  |..w{q.S.........|
c0000003d6240ec8 009b7000000000c0 80614df6030000c0  |..p......aM.....|
c0000003d6240ed8 cb569d7ccbb353b1 302e71f2030000c0  |.V.|..S.0.q.....|
