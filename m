Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab3IBMaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 08:30:06 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:34321 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab3IBMaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 08:30:04 -0400
Date: Mon, 2 Sep 2013 15:28:45 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: [sched next] overflowed cpu time for kernel threads in
 /proc/PID/stat
Message-ID: <20130902122845.GA2457@swordfish.minsk.epam.com>
References: <20130820111426.GA27828@swordfish.datadirectnet.com>
 <20130820151509.GA17441@somewhere>
 <20130820153549.GB2315@swordfish.minsk.epam.com>
 <20130820154257.GD17441@somewhere>
 <20130821153957.GA2969@swordfish.minsk.epam.com>
 <20130830230402.GA14760@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130830230402.GA14760@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (08/31/13 01:04), Frederic Weisbecker wrote:
> > in cputime_adjust() `stime' is greater than `rtime', so `utime = rtime - stime'
> > sets wrong value.
> 
> But stime should always be below rtime due to the calculation done by scale_stime()
> which roughly sums up to:
> 
>       stime = (stime / stime + utime) * rtime
> 
> So this shouldn't happen.
> 
> I couldn't manage to reproduce it though. Can you still trigger it with latest -next?
>

Hope this may help.
I've added a silly check to make sure that `stime < rtime'

@@ -579,6 +582,10 @@ static void cputime_adjust(struct task_cputime *curr,
        if (total) {
                stime = scale_stime((__force u64)stime,
                                    (__force u64)rtime, (__force u64)total);
+               if (stime > rtime) {
+                       printk(KERN_ERR "Ooops: stime:%llu rtime:%llu\n", stime, rtime);
+                       WARN_ON(1);
+               }
                utime = rtime - stime;
        } else {
                stime = rtime;


and got the following results:


[ 1295.311056] Ooops: stime:4622750929 rtime:4622750928
[ 1295.311063] ------------[ cut here ]------------
[ 1295.311072] WARNING: CPU: 1 PID: 2167 at kernel/sched/cputime.c:584 cputime_adjust+0x132/0x140()
[ 1295.311123] CPU: 1 PID: 2167 Comm: top Tainted: G         C   3.11.0-rc7-next-20130902-dbg-dirty #2
[ 1295.311126] Hardware name: Acer             Aspire 5741G    /Aspire 5741G    , BIOS V1.20 02/08/2011
[ 1295.311128]  0000000000000009 ffff880099937c50 ffffffff8162fc85 0000000000000000
[ 1295.311134]  ffff880099937c88 ffffffff8104ee2d ffff8801530bb158 ffff880099937df0
[ 1295.311139]  00000001138994d0 00000001138994d1 ffff880153118ff0 ffff880099937c98
[ 1295.311145] Call Trace:
[ 1295.311155]  [<ffffffff8162fc85>] dump_stack+0x4e/0x82
[ 1295.311162]  [<ffffffff8104ee2d>] warn_slowpath_common+0x7d/0xa0
[ 1295.311166]  [<ffffffff8104ef0a>] warn_slowpath_null+0x1a/0x20
[ 1295.311170]  [<ffffffff8108db72>] cputime_adjust+0x132/0x140
[ 1295.311175]  [<ffffffff8108e941>] thread_group_cputime_adjusted+0x41/0x50
[ 1295.311182]  [<ffffffff811f3ac4>] do_task_stat+0x9c4/0xb50
[ 1295.311188]  [<ffffffff811f4904>] proc_tgid_stat+0x14/0x20
[ 1295.311192]  [<ffffffff811edac4>] proc_single_show+0x54/0xa0
[ 1295.311198]  [<ffffffff811a6d24>] seq_read+0x164/0x3d0
[ 1295.311204]  [<ffffffff811805e1>] vfs_read+0xa1/0x180
[ 1295.311208]  [<ffffffff8118119c>] SyS_read+0x4c/0xa0
[ 1295.311213]  [<ffffffff8163ad06>] tracesys+0xd4/0xd9
[ 1295.311216] ---[ end trace bab1e899ff45eea2 ]---

[ 1301.384396] Ooops: stime:4654072951 rtime:4654072950
[ 1301.384401] ------------[ cut here ]------------
[ 1301.384409] WARNING: CPU: 0 PID: 2167 at kernel/sched/cputime.c:584 cputime_adjust+0x132/0x140()
[ 1301.384450] CPU: 0 PID: 2167 Comm: top Tainted: G        WC   3.11.0-rc7-next-20130902-dbg-dirty #2
[ 1301.384452] Hardware name: Acer             Aspire 5741G    /Aspire 5741G    , BIOS V1.20 02/08/2011
[ 1301.384454]  0000000000000009 ffff880099937c50 ffffffff8162fc85 0000000000000000
[ 1301.384458]  ffff880099937c88 ffffffff8104ee2d ffff8801530bb158 ffff880099937df0
[ 1301.384462]  0000000115678476 0000000115678477 ffff880153118ff0 ffff880099937c98
[ 1301.384466] Call Trace:
[ 1301.384475]  [<ffffffff8162fc85>] dump_stack+0x4e/0x82
[ 1301.384481]  [<ffffffff8104ee2d>] warn_slowpath_common+0x7d/0xa0
[ 1301.384484]  [<ffffffff8104ef0a>] warn_slowpath_null+0x1a/0x20
[ 1301.384487]  [<ffffffff8108db72>] cputime_adjust+0x132/0x140
[ 1301.384491]  [<ffffffff8108e941>] thread_group_cputime_adjusted+0x41/0x50
[ 1301.384497]  [<ffffffff811f3ac4>] do_task_stat+0x9c4/0xb50
[ 1301.384501]  [<ffffffff811f4904>] proc_tgid_stat+0x14/0x20
[ 1301.384504]  [<ffffffff811edac4>] proc_single_show+0x54/0xa0
[ 1301.384509]  [<ffffffff811a6d24>] seq_read+0x164/0x3d0
[ 1301.384514]  [<ffffffff811805e1>] vfs_read+0xa1/0x180
[ 1301.384517]  [<ffffffff8118119c>] SyS_read+0x4c/0xa0
[ 1301.384521]  [<ffffffff8163ad06>] tracesys+0xd4/0xd9
[ 1301.384523] ---[ end trace bab1e899ff45eea3 ]---

and so on.


$ dmesg | grep Ooops
[ 1295.311056] Ooops: stime:4622750929 rtime:4622750928
[ 1301.384396] Ooops: stime:4654072951 rtime:4654072950
[ 1307.438935] Ooops: stime:4687858107 rtime:4687858106
[ 1313.493462] Ooops: stime:4724166945 rtime:4724166944
[ 1316.521740] Ooops: stime:4741142233 rtime:4741142232
[ 1325.605625] Ooops: stime:4793906690 rtime:4793906688
[ 1331.648611] Ooops: stime:4308413629 rtime:4308413628
[ 1337.708468] Ooops: stime:4510156747 rtime:4510156746
[ 1340.744586] Ooops: stime:4880584390 rtime:4880584389
[ 1343.773111] Ooops: stime:4442005879 rtime:4442005878
[ 1343.773362] Ooops: stime:4558310943 rtime:4558310942
[ 1349.815797] Ooops: stime:4927379646 rtime:4927379645
[ 1352.836936] Ooops: stime:4942782836 rtime:4942782834
[ 1358.885232] Ooops: stime:4979031940 rtime:4979031938
[ 1364.977902] Ooops: stime:5019633914 rtime:5019633912
[ 1364.978283] Ooops: stime:4601969101 rtime:4601969100
[ 1364.978623] Ooops: stime:4826393815 rtime:4826393814
[ 1371.034265] Ooops: stime:4894272175 rtime:4894272174
[ 1374.077150] Ooops: stime:4688831829 rtime:4688831828
[ 1374.077519] Ooops: stime:4916319315 rtime:4916319314
[ 1377.110416] Ooops: stime:5084174048 rtime:5084174047
[ 1377.111043] Ooops: stime:4949250198 rtime:4949250196
[ 1380.137382] Ooops: stime:5096963048 rtime:5096963046
[ 1380.137739] Ooops: stime:4975014880 rtime:4975014879
[ 1383.161441] Ooops: stime:5002466396 rtime:5002466394
[ 1389.212166] Ooops: stime:5140400038 rtime:5140400036
[ 1392.239303] Ooops: stime:5082051028 rtime:5082051027
[ 1395.270391] Ooops: stime:5170118636 rtime:5170118634
[ 1398.303593] Ooops: stime:5184355318 rtime:5184355316


	-ss
