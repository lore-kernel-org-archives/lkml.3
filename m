Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaKWQt3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 11:49:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27297 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbaKWQt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 11:49:28 -0500
Date: Sun, 23 Nov 2014 11:49:02 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: New crashes walking proc with Saturday's git
To: Borislav Petkov <bp@alien8.de>
CC: <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Message-ID: <1416761342.24312.15@mail.thefacebook.com>
In-Reply-To: <20141123163258.GB6436@pd.tnic>
References: <20141123010239.GA12691@ret.masoncoding.com>
	<1416758187.24312.12@mail.thefacebook.com> <20141123161120.GB7070@pd.tnic>
	<1416759411.24312.13@mail.thefacebook.com> <20141123163258.GB6436@pd.tnic>
X-Mailer: geary/0.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-23_03:2014-11-21,2014-11-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=5.55111512312578e-17 kscore.compositescore=0
 circleOfTrustscore=13.3549515528058 compositescore=0.939076664828693
 urlsuspect_oldscore=0.939076664828693 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.939076664828693 spamscore=0
 recipient_to_sender_domain_totalscore=4 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1411230142
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 11:32 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Sun, Nov 23, 2014 at 11:16:51AM -0500, Chris Mason wrote:
>>  It must be:
>> 
>>  commit 6e998916dfe327e785e7c2447959b2c1a3ea4930
>>  Author: Stanislaw Gruszka <sgruszka@redhat.com>
>>  Date:   Wed Nov 12 16:58:44 2014 +0100
>> 
>>     sched/cputime: Fix clock_nanosleep()/clock_gettime() 
>> inconsistency
>> 
>>  I'll do two runs to confirm, but it's the only related patch 
>> between rc5 and
>>  now.

I've adding Ingo and Stanislaw to the cc.  With 
6e998916dfe327e785e7c2447959b2c1a3ea4930 reverted, I'm no longer 
crashing.

Repeating the stack trace for the new cc list.  I see the crash with 
atop or similar walkers of /proc racing against exiting programs.  
Given the NULL rip, this line from the patch is probably broken, but it 
really feels like we should be falling over on p->sched_class and not 
on the update_curr func.

+               p->sched_class->update_curr(rq);

I'm leaving my fork bomb running on two machines with the patch 
reverted to make sure.

[ 1053.317472] BUG: unable to handle kernel NULL pointer dereference at 
          (null)
[ 1053.333312] IP: [<          (null)>]           (null)
[ 1053.343498] PGD 1050f5c067 PUD 1044f86067 PMD 0
[ 1053.352874] Oops: 0010 [#1] SMP
[ 1053.359457] Modules linked in: loop k10temp coretemp hwmon btrfs 
raid6_pq zlib_deflate lzo_compress xor fuse tcp_diag inet_diag nfsv
_tables x_tables nfsv3 nfs lockd grace mptctl netconsole autofs4 
rpcsec_gss_krb5 auth_rpcgss oid_registry sunrpc ipv6 ext3 jbd dm_mod r
shpchp ehci_pci ehci_hcd mlx4_en ptp pps_core mlx4_core sg ses 
enclosure button megaraid_sas
[ 1053.460866] CPU: 19 PID: 8404 Comm: atop Not tainted 
3.18.0-rc5-mason+ #35
[ 1053.474665] Hardware name: ZTSYSTEMS Echo Ridge T4  /A9DRPF-10D, 
BIOS 1.07 05/10/2012
[ 1053.490444] task: ffff8810449d0000 ti: ffff88103a1e0000 task.ti: 
ffff88103a1e0000
[ 1053.505527] RIP: 0010:[<0000000000000000>]  [<          (null)>]     
      (null)
[ 1053.520637] RSP: 0018:ffff88103a1e3bb0  EFLAGS: 00010096
[ 1053.531307] RAX: ffffffff8180dd80 RBX: ffff8810547b6040 RCX: 
0056d214af400000
[ 1053.545632] RDX: 000000f53e9ce885 RSI: 00000000000001d1 RDI: 
ffff88107fc32d80
[ 1053.559954] RBP: ffff88103a1e3be8 R08: 0000000000000001 R09: 
0000000000000000
[ 1053.574274] R10: 0000000000000001 R11: 0000000000000246 R12: 
ffff88107fc32d80
[ 1053.588596] R13: ffff88103a1e3c68 R14: ffff8810547b6040 R15: 
0000000000000000
[ 1053.602917] FS:  00007f37b298e700(0000) GS:ffff88085fd60000(0000) 
knlGS:0000000000000000
[ 1053.619215] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1053.630759] CR2: 0000000000000000 CR3: 000000104652d000 CR4: 
00000000000407e0
[ 1053.645084] Stack:
[ 1053.649176]  ffffffff81077d4b ffff88103a1e3be8 ffffffff811c18bf 
ffff88087fffcd80
[ 1053.664201]  0000000000000086 ffff8810547b6040 ffff8808542381ac 
ffff88103a1e3c58
[ 1053.679233]  ffffffff8107f94a ffff8810449d07c0 ffff8808542381a8 
0000000000000000
[ 1053.694263] Call Trace:
[ 1053.699227]  [<ffffffff81077d4b>] ? task_sched_runtime+0xab/0xb0
[ 1053.711288]  [<ffffffff811c18bf>] ? seq_open+0x4f/0xc0
[ 1053.721623]  [<ffffffff8107f94a>] thread_group_cputime+0xda/0x190
[ 1053.733868]  [<ffffffff8107fa32>] 
thread_group_cputime_adjusted+0x32/0x60
[ 1053.747498]  [<ffffffff8105e381>] ? __lock_task_sighand+0x51/0xb0
[ 1053.759741]  [<ffffffff81208348>] do_task_stat+0x8b8/0xb00
[ 1053.770769]  [<ffffffff812085a4>] proc_tgid_stat+0x14/0x20
[ 1053.781801]  [<ffffffff81205114>] proc_single_show+0x64/0x90
[ 1053.793177]  [<ffffffff811c1bbb>] seq_read+0xbb/0x410
[ 1053.803342]  [<ffffffff8119d143>] vfs_read+0xa3/0x110
[ 1053.813506]  [<ffffffff811ba753>] ? __fdget+0x13/0x20
[ 1053.823672]  [<ffffffff8119d6fa>] SyS_read+0x5a/0xd0
[ 1053.833664]  [<ffffffff816427d2>] system_call_fastpath+0x12/0x17
[ 1053.845733] Code:  Bad RIP value.
[ 1053.852490] RIP  [<          (null)>]           (null)
[ 1053.862854]  RSP <ffff88103a1e3bb0>
[ 1053.869883] CR2: 0000000000000000
[ 1053.877131] ---[ end trace a218425ffc5c90cd ]---



