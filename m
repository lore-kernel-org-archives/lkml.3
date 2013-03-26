Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238Ab3CZTsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:48:43 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:28620
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754236Ab3CZTsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:48:40 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VPS-9(zz98dI9371I1432I179dNzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MKA9OX-01-090-02
X-M-MSG: 
Date: Tue, 26 Mar 2013 14:48:32 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linaro-kernel@lists.linaro.org>, <robin.randhawa@arm.com>,
        <Steve.Bannister@arm.com>, <Liviu.Dudau@arm.com>,
        <charles.garcia-tobin@arm.com>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>
Subject: Re: [PATCH V3 2/4] cpufreq: governor: Implement per policy instances
 of governors
Message-ID: <20130326194832.GB24945@jshin-Toonie>
References: <cover.1362381470.git.viresh.kumar@linaro.org>
 <0823a96fea2d8284b7d83cee390dd5973fdaaa94.1362381470.git.viresh.kumar@linaro.org>
 <CAKohponTZ29BX6CrUvFMy9RXV==0wRFu4C-W1xd6t1RmLASTvQ@mail.gmail.com>
 <2565053.YP0dCLmaW9@vostro.rjw.lan>
 <20130326152059.GA1698@jshin-Toonie>
 <CAKohpons4Tr8F2RuRGCxbOFmJaK9YbAafV-3v6=cijRupe2hUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKohpons4Tr8F2RuRGCxbOFmJaK9YbAafV-3v6=cijRupe2hUA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 01:02:15AM +0530, Viresh Kumar wrote:
> On 26 March 2013 20:50, Jacob Shin <jacob.shin@amd.com> wrote:
> > Hi, latest bleeding-edge is spewing this out on boot:
> >
> > [    3.585157] ------------[ cut here ]------------
> > [    3.592227] WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0xc8/0x100()
> > [    3.599521] Hardware name: Dinar
> > [    3.606878] sysfs: cannot create duplicate filename '/devices/system/cpu/cpufreq/ondemand'
> > [    3.614634] Modules linked in:
> > [    3.622382] Pid: 1, comm: swapper/0 Not tainted 3.9.0-rc4+ #7
> > [    3.630305] Call Trace:
> > [    3.638251]  [<ffffffff810589cf>] warn_slowpath_common+0x7f/0xc0
> > [    3.646435]  [<ffffffff81058ac6>] warn_slowpath_fmt+0x46/0x50
> > [    3.654586]  [<ffffffff8133e2f0>] ? strlcat+0x60/0x80
> > [    3.662765]  [<ffffffff811fe7d8>] sysfs_add_one+0xc8/0x100
> > [    3.670977]  [<ffffffff811fe9cc>] create_dir+0x7c/0xd0
> > [    3.679239]  [<ffffffff811fecaf>] sysfs_create_subdir+0x1f/0x30
> > [    3.687601]  [<ffffffff812006c4>] internal_create_group+0x64/0x210
> > [    3.696098]  [<ffffffff812008a3>] sysfs_create_group+0x13/0x20
> > [    3.704700]  [<ffffffff816bf800>] cpufreq_governor_dbs+0x400/0x590
> > [    3.713401]  [<ffffffff816bdc37>] od_cpufreq_governor_dbs+0x17/0x20
> > [    3.722191]  [<ffffffff816bb437>] __cpufreq_governor+0x47/0xc0
> > [    3.731071]  [<ffffffff816bb94d>] __cpufreq_set_policy+0x19d/0x1b0
> > [    3.739968]  [<ffffffff816bca89>] cpufreq_add_dev_interface+0x259/0x2b0
> > [    3.748960]  [<ffffffff813cdce6>] ? acpi_processor_get_performance_info+0x21c/0x452
> > [    3.758099]  [<ffffffff816bc210>] ? cpufreq_update_policy+0x130/0x130
> > [    3.767366]  [<ffffffff816bce90>] cpufreq_add_dev+0x3b0/0x4d0
> > [    3.776659]  [<ffffffff821579d4>] ? cpufreq_gov_dbs_init+0x12/0x12
> > [    3.785985]  [<ffffffff814e6a39>] subsys_interface_register+0x89/0xd0
> > [    3.795452]  [<ffffffff816baf5e>] cpufreq_register_driver+0x8e/0x180
> > [    3.804919]  [<ffffffff82157aca>] acpi_cpufreq_init+0xf6/0x1f8
> > [    3.814360]  [<ffffffff814f5030>] ? set_trace_device+0x80/0x80
> > [    3.823558]  [<ffffffff8100206f>] do_one_initcall+0x3f/0x170
> > [    3.832476]  [<ffffffff8211b00a>] kernel_init_freeable+0x13e/0x1cd
> > [    3.841131]  [<ffffffff8211a88e>] ? do_early_param+0x86/0x86
> > [    3.849506]  [<ffffffff817f4c20>] ? rest_init+0x80/0x80
> > [    3.857557]  [<ffffffff817f4c2e>] kernel_init+0xe/0xf0
> > [    3.865260]  [<ffffffff8181edec>] ret_from_fork+0x7c/0xb0
> > [    3.872886]  [<ffffffff817f4c20>] ? rest_init+0x80/0x80
> > [    3.880456] ---[ end trace 1a5c6247c6d9b0ac ]---
> > [    3.888201] ------------[ cut here ]------------
> >
> > This warning is repeated for number of cpus - 1 times.
> >
> > And when I do:
> >
> > $ cat /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
> >
> > [  489.103388] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
> > [  489.112064] IP: [<ffffffff816be02c>] show_up_threshold+0x1c/0x30
> > [  489.120511] PGD a285e6067 PUD a27085067 PMD 0
> > [  489.128690] Oops: 0000 [#1] SMP
> > [  489.136521] Modules linked in:
> > [  489.144134] CPU 15
> > [  489.144229] Pid: 1565, comm: cat Tainted: G        W    3.9.0-rc4+ #7 AMD Dinar/Dinar
> > [  489.159654] RIP: 0010:[<ffffffff816be02c>]  [<ffffffff816be02c>] show_up_threshold+0x1c/0x30
> > [  489.167864] RSP: 0018:ffff880423859e88  EFLAGS: 00010246
> > [  489.176043] RAX: 0000000000000000 RBX: ffff880a271188c0 RCX: ffffffff81a41810
> > [  489.184372] RDX: 0000000000000000 RSI: ffffffff81e02dae RDI: ffffffff820d7860
> > [  489.184373] RBP: ffff880423859e88 R08: ffffea0028b6df80 R09: 00000000001f05b8
> > [  489.184374] R10: 0000000000001b97 R11: 0000000000000246 R12: ffff880423859f50
> > [  489.184374] R13: 0000000000008000 R14: ffff880a271188a0 R15: ffff8804251aa070
> > [  489.184377] FS:  00007f3278b31700(0000) GS:ffff880a2fcc0000(0000) knlGS:0000000000000000
> > [  489.184378] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  489.184378] CR2: 0000000000000010 CR3: 0000000a2db82000 CR4: 00000000000407e0
> > [  489.184380] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [  489.184381] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > [  489.184382] Process cat (pid: 1565, threadinfo ffff880423858000, task ffff880424805c00)
> > [  489.184382] Stack:
> > [  489.184389]  ffff880423859e98 ffffffff8133814f ffff880423859ef8 ffffffff811fd62a
> > [  489.184394]  000000002bf67be2 ffff8808260b7a80 ffffffff81a41810 00000000012c8000
> > [  489.184399]  ffff880423859ef8 0000000000008000 00000000012c8000 ffff880423859f50
> > [  489.184400] Call Trace:
> > [  489.184406]  [<ffffffff8133814f>] kobj_attr_show+0xf/0x30
> > [  489.184411]  [<ffffffff811fd62a>] sysfs_read_file+0xaa/0x190
> > [  489.184415]  [<ffffffff81187e30>] vfs_read+0xb0/0x180
> > [  489.184418]  [<ffffffff81187f52>] sys_read+0x52/0xa0
> > [  489.184422]  [<ffffffff8181a7fe>] ? do_page_fault+0xe/0x10
> > [  489.184426]  [<ffffffff8181ee99>] system_call_fastpath+0x16/0x1b
> > [  489.184441] Code: 52 08 e8 78 2c c8 ff 5d 48 98 c3 0f 1f 40 00 66 66 66 66 90 55 48 8b 57 70 48 89 f0 48 89 c7 48 c7 c6 ae 2d e0 81 31 c0 48 89 e5 <48> 8b 52 10 8b 52 0c e8 48 2c c8 ff 5d 48 98 c3 0f 1f 40 00 66
> > [  489.184443] RIP  [<ffffffff816be02c>] show_up_threshold+0x1c/0x30
> > [  489.184443]  RSP <ffff880423859e88>
> > [  489.184444] CR2: 0000000000000010
> > [  489.184507] ---[ end trace 1a5c6247c6d9b0c3 ]---
> >
> > Any ideas?
> 
> Yes, i believe i have enough idea about it :)
> 
> There are two kind of systems i know:
> 1 - Single group of cpus controlled by a single clock line,
>      i.e. only one policy instance at any time
> 2 - multipolicy systems where we have more than one group of cpus
>      and every group have one clock line.
> 
> For the second case also there are two cases:
> 2.1 - support have_multiple_policies (i.e. have separate instance of governor
>         for each policy struct)
> 2.2 - doesn't support have_multiple_policies
> 
> The last one (2.2) is broken with my patch and attached is the fix. I
> have tested
> it on my Lenovo Thinkpad which is more like 2.2 case.
> 
> cat of cpufreq/ondemand/** is still broken and i am too tired of
> fixing it now...
> Its already midnight here 01:01 AM.
> 
> --
> viresh
>
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index 41e5e56..f29feb4 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -29,6 +29,9 @@
> 
>  #include "cpufreq_governor.h"
> 
> +/* Common data for platforms that don't need governor instance per policy */
> +struct dbs_data *gdbs_data;
> +

Hmm .. I don't think this works for both ondemand and conservative
governors running at the same time .

