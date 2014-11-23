Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaKWPC6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 10:02:58 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35193 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273AbaKWPC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 10:02:56 -0500
Date: Sun, 23 Nov 2014 10:02:45 -0500
From: Chris Mason <clm@fb.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: New crashes walking proc with Saturday's git
Message-ID: <20141123010239.GA12691@ret.masoncoding.com>
Mail-Followup-To: Chris Mason <clm@fb.com>, torvalds@linux-foundation.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-23_02:2014-11-21,2014-11-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.65423230669148e-14 kscore.compositescore=0
 circleOfTrustscore=7.0302659978126 compositescore=0.939076664828693
 urlsuspect_oldscore=0.939076664828693 suspectscore=1
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.939076664828693 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1411230125
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I was running some tests on Saturday before my pull, and I'm now hitting
this consistently across two boxes.  One box has plain linus git:

commit cb95413971d605b0d152d3ceecc47ba8991d66fb
Merge: ecde006 6bab4a8
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Nov 22 14:33:11 2014 -0800

The other has the btrfs locking fix I wanted to send in on top.  The
tests are just normal xfstests, and I don't think they are causing this.

The process triggering this is dynoProcMon, which is an internal
facebook program that walks proc and apparently checks process stats.
It's not part of the xfstests run, just internal monitoring.

I had the same xfstests in a loop on Friday with plain 3.18-rc5 trying to
trigger the skbuff memory corruption fixed by Dave's pull.  This
crash in /proc wasn't triggering then.

It's possible that dynoProcMon was changed to hammer on proc in new
ways.  These utils do get updated in the background sometimes (I'll
check).

It takes about an hour to crash, so not really bisectable.  I left
the boxes idle overnight and they were both dead in the morning.

Since it looks like a race between process exit and /proc, I'll try to
hammer on that for a better reproduction.  But, here's hoping that
someone has already seen this one:

[ 1333.162263] BUG: unable to handle kernel NULL pointer dereference at           (null)
[ 1333.178174] IP: [<          (null)>]           (null)
[ 1333.188406] PGD 10153db067 PUD 10398d8067 PMD 0 
[ 1333.197825] Oops: 0010 [#1] SMP DEBUG_PAGEALLOC
[ 1333.207051] Modules linked in: fuse k10temp coretemp hwmon btrfs raid6_pq zlib_deflate lzo_compress xor xfs exportfs libcrc32c tcp_d
iag inet_diag nfsv4 loop ip6table_filter ip6_tables xt_NFLOG nfnetlink_log nfnetlink xt_comment xt_statistic iptable_filter ip_tables x
_tables nfsv3 nfs lockd grace mptctl netconsole autofs4 rpcsec_gss_krb5 auth_rpcgss oid_registry sunrpc ipv6 ext3 jbd dm_mod iTCO_wdt i
TCO_vendor_support pcspkr i2c_i801 shpchp lpc_ich mfd_core ehci_pci ehci_hcd mlx4_en ptp pps_core mlx4_core rtc_cmos ipmi_si ipmi_msgha
ndler ses enclosure sg button megaraid_sas
[ 1333.310989] CPU: 12 PID: 8309 Comm: dynoProcMon Not tainted 3.18.0-rc5-mason+ #66
[ 1333.326070] Hardware name: ZTSYSTEMS Echo Ridge T4  /A9DRPF-10D, BIOS 1.07 05/10/2012
[ 1333.341847] task: ffff881035795cd0 ti: ffff88100b29c000 task.ti: ffff88100b29c000
[ 1333.356927] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[ 1333.372052] RSP: 0018:ffff88100b29fb90  EFLAGS: 00010092
[ 1333.382740] RAX: ffffffff8180dd80 RBX: ffff880853389390 RCX: 006a6f3444800000
[ 1333.397066] RDX: 0000013666a9a100 RSI: 00000000000001d1 RDI: ffff88085fd13a00
[ 1333.411385] RBP: ffff88100b29fbc8 R08: 0000000000000000 R09: 0000000000000000
[ 1333.425705] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88085fd13a00
[ 1333.440029] R13: ffff88100b29fc18 R14: ffff880853389390 R15: ffff880853389390
[ 1333.454349] FS:  00007f02f55fd700(0000) GS:ffff881077c80000(0000) knlGS:0000000000000000
[ 1333.470650] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1333.482207] CR2: 0000000000000000 CR3: 00000010153da000 CR4: 00000000000407e0
[ 1333.496530] Stack:
[ 1333.500624]  ffffffff8107e3ab 0000000000000000 ffff88100b29fc68 ffff880853389390
[ 1333.515665]  0000000000000086 ffff88100b29fc68 0000000000000000 ffff88100b29fc58
[ 1333.530714]  ffffffff81082f41 ffffffff81083042 ffffffff81060800 0000000000000000
[ 1333.545744] Call Trace:
[ 1333.550712]  [<ffffffff8107e3ab>] ? task_sched_runtime+0xab/0xb0
[ 1333.562783]  [<ffffffff81082f41>] thread_group_cputime+0x161/0x230
[ 1333.575198]  [<ffffffff81083042>] ? thread_group_cputime_adjusted+0x32/0x60
[ 1333.589180]  [<ffffffff81060800>] ? __sigqueue_alloc+0x140/0x150
[ 1333.601242]  [<ffffffff81083042>] thread_group_cputime_adjusted+0x32/0x60
[ 1333.614875]  [<ffffffff8121f058>] do_task_stat+0x8b8/0xb00
[ 1333.625901]  [<ffffffff8121f2b4>] proc_tgid_stat+0x14/0x20
[ 1333.636934]  [<ffffffff8121b474>] proc_single_show+0x64/0x90
[ 1333.648309]  [<ffffffff811d6716>] seq_read+0xc6/0x430
[ 1333.658474]  [<ffffffff811afed3>] vfs_read+0xa3/0x110
[ 1333.668637]  [<ffffffff811b04cd>] SyS_read+0x5d/0xd0
[ 1333.678629]  [<ffffffff81676ad2>] system_call_fastpath+0x12/0x17
[ 1333.690698] Code:  Bad RIP value.

