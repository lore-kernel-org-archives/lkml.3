Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbaDBN4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:56:34 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:24007
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758600AbaDBNzv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:55:51 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Andy Whitcroft <apw@canonical.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Hyper-V balloon memory hotplug deadlock?
Thread-Topic: Hyper-V balloon memory hotplug deadlock?
Thread-Index: AQHPP6jvvgZvmW0s80e4hVU7CKQhapr+dfFw
Date: Wed, 2 Apr 2014 13:55:37 +0000
Message-ID: <3ac39fd3990d43ddb635692230bf850e@BY2PR03MB299.namprd03.prod.outlook.com>
References: <20140314171455.GB3497@dm>
In-Reply-To: <20140314171455.GB3497@dm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.19.246.69]
x-forefront-prvs: 0169092318
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(13464003)(51704005)(377454003)(74366001)(94316002)(97186001)(79102001)(2656002)(94946001)(81816001)(81542001)(69226001)(74876001)(86362001)(86612001)(99286001)(87936001)(92566001)(63696002)(81686001)(87266001)(47446002)(20776003)(31966008)(95666003)(19580395003)(93516002)(33646001)(98676001)(76482001)(93136001)(74502001)(4396001)(56816005)(83072002)(90146001)(80022001)(76786001)(81342001)(76576001)(74316001)(76796001)(54356001)(85852003)(77982001)(59766001)(66066001)(19580405001)(65816001)(56776001)(50986001)(47736001)(47976001)(53806001)(74706001)(83322001)(54316002)(49866001)(51856001)(99396002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB297;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:A02EDEEA.C013BB49.8CDB1274.410B5BB8.205D8;MLV:sfv;PTR:InfoNoRecords;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Andy Whitcroft [mailto:apw@canonical.com]
> Sent: Friday, March 14, 2014 10:15 AM
> To: linux-mm@kvack.org; KY Srinivasan
> Cc: Greg Kroah-Hartman; linux-kernel@vger.kernel.org
> Subject: Hyper-V balloon memory hotplug deadlock?
> 
> We are seeing machines lockup with what appears to be an ABBA deadlock in
> the memory hotplug system.  These are from the 3.13.6 based Ubuntu
> kernels.
> The hv_balloon driver is adding memory using add_memory() which takes
> the hotplug lock, and then emits a udev event, and then attempts to lock the
> sysfs device.  In response to the udev event udev opens the sysfs device and
> locks it, then attempts to grab the hotplug lock to online the memory.  This
> seems to be inverted nesting in the two cases, leading to the hangs below:
> 
>     [  240.608612] INFO: task kworker/0:2:861 blocked for more than 120
> seconds.
>     [  240.608705] INFO: task systemd-udevd:1906 blocked for more than 120
> seconds.
> 
> I note that the device hotplug locking allows complete retries (via
> ERESTARTSYS) and if we could detect this at the online stage it could be used
> to get us out.  But before I go down this road I wanted to make sure I am
> reading this right.  Or indeed if the hv_balloon driver is just doing this wrong.
> 
> Fuller details are below including stacks and snippets of the locking in
> question.
> 
> Thoughts?

Andy,

Did you get to the bottom of this. From the balloon driver, I am using the exported APIs for
bringing the memory online - this condition you describe is independent of the client trying to
bring memory online.

I do have patches that can bring the memory online in the same context as hot-adding the memory.
These patches have not been acked by the upstream maintainers of this code yet though.

Regards,

K. Y
> 
> -apw
> 
> Stack from kworker:
> 
>     [  240.608612] INFO: task kworker/0:2:861 blocked for more than 120
> seconds.
>     [  240.608617]       Not tainted 3.13.0-17-generic #37-Ubuntu
>     [  240.608618] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
>     [  240.608620] kworker/0:2     D ffff88001e414440     0   861      2 0x00000000
>     [  240.608628] Workqueue: events hot_add_req [hv_balloon]
>     [  240.608630]  ffff88001a00fb30 0000000000000002 ffff88001a6f8000
> ffff88001a00ffd8
>     [  240.608632]  0000000000014440 0000000000014440 ffff88001a6f8000
> ffff88001aac6c98
>     [  240.608635]  ffff88001aac6c9c ffff88001a6f8000 00000000ffffffff
> ffff88001aac6ca0
>     [  240.608637] Call Trace:
>     [  240.608643]  [<ffffffff817159f9>] schedule_preempt_disabled+0x29/0x70
>     [  240.608645]  [<ffffffff81717865>] __mutex_lock_slowpath+0x135/0x1b0
>     [  240.608647]  [<ffffffff817178ff>] mutex_lock+0x1f/0x2f
>     [  240.608651]  [<ffffffff8148a5bd>] device_attach+0x1d/0xa0
>     [  240.608653]  [<ffffffff81489a38>] bus_probe_device+0x98/0xc0
>     [  240.608656]  [<ffffffff81487895>] device_add+0x4c5/0x640
>     [  240.608658]  [<ffffffff81487a2a>] device_register+0x1a/0x20
>     [  240.608661]  [<ffffffff8149e000>] init_memory_block+0xd0/0xf0
>     [  240.608663]  [<ffffffff8149e141>] register_new_memory+0x91/0xa0
>     [  240.608666]  [<ffffffff81700d10>] __add_pages+0x140/0x240
>     [  240.608670]  [<ffffffff81055649>] arch_add_memory+0x59/0xd0
>     [  240.608672]  [<ffffffff81700fe4>] add_memory+0xe4/0x1f0
>     [  240.608675]  [<ffffffffa00411cf>] hot_add_req+0x31f/0x1150
> [hv_balloon]
>     [  240.608679]  [<ffffffff810824a2>] process_one_work+0x182/0x450
>     [  240.608681]  [<ffffffff81083241>] worker_thread+0x121/0x410
>     [  240.608683]  [<ffffffff81083120>] ? rescuer_thread+0x3e0/0x3e0
>     [  240.608686]  [<ffffffff81089ed2>] kthread+0xd2/0xf0
>     [  240.608688]  [<ffffffff81089e00>] ?
> kthread_create_on_node+0x190/0x190
>     [  240.608691]  [<ffffffff817219bc>] ret_from_fork+0x7c/0xb0
>     [  240.608693]  [<ffffffff81089e00>] ?
> kthread_create_on_node+0x190/0x190
> 
> kworker looks to be blocked on the device lock in device_attach:
> 
>     int device_attach(struct device *dev)
>     {
> 	int ret = 0;
> 
> 	device_lock(dev);
> 	[...]
>     }
> 
> If we follow the call trace we take mem_hotplug_mutex in add_memory():
> 
>     int __ref add_memory(int nid, u64 start, u64 size)
>     {
> 	[...]
>         lock_memory_hotplug();
>     }
> 
> We later call device_add which triggers the udev event for this block:
> 
>     int device_add(struct device *dev)
>     {
>         kobject_uevent(&dev->kobj, KOBJ_ADD);
>     [...]
>     }
> 
> Finally, after emitting this event and and while holding that we call
> device_attach() above, nesting the device_lock(dev) inside the memory
> hotplug lock.
> 
> 
> Stack from systemd-udevd:
> 
>     [  240.608705] INFO: task systemd-udevd:1906 blocked for more than 120
> seconds.
>     [  240.608706]       Not tainted 3.13.0-17-generic #37-Ubuntu
>     [  240.608707] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
>     [  240.608708] systemd-udevd   D ffff88001e414440     0  1906    404
> 0x00000004
>     [  240.608710]  ffff88001a97bd20 0000000000000002 ffff8800170e0000
> ffff88001a97bfd8
>     [  240.608712]  0000000000014440 0000000000014440 ffff8800170e0000
> ffffffff81c620e0
>     [  240.608714]  ffffffff81c620e4 ffff8800170e0000 00000000ffffffff
> ffffffff81c620e8
>     [  240.608716] Call Trace:
>     [  240.608719]  [<ffffffff817159f9>] schedule_preempt_disabled+0x29/0x70
>     [  240.608721]  [<ffffffff81717865>] __mutex_lock_slowpath+0x135/0x1b0
>     [  240.608725]  [<ffffffff8115a8ae>] ? lru_cache_add+0xe/0x10
>     [  240.608727]  [<ffffffff817178ff>] mutex_lock+0x1f/0x2f
>     [  240.608729]  [<ffffffff817019c3>] online_pages+0x33/0x570
>     [  240.608731]  [<ffffffff8149dd98>] memory_subsys_online+0x68/0xd0
>     [  240.608733]  [<ffffffff814881e5>] device_online+0x65/0x90
>     [  240.608735]  [<ffffffff8149da24>] store_mem_state+0x64/0x160
>     [  240.608738]  [<ffffffff81485748>] dev_attr_store+0x18/0x30
>     [  240.608742]  [<ffffffff8122e698>] sysfs_write_file+0x128/0x1c0
>     [  240.608745]  [<ffffffff811b88c4>] vfs_write+0xb4/0x1f0
>     [  240.608747]  [<ffffffff811b92f9>] SyS_write+0x49/0xa0
>     [  240.608749]  [<ffffffff81721c7f>] tracesys+0xe1/0xe6
> 
> udevd seems to be blocked on the hotplug lock:
> 
>     int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int
> online_type)
>     {
>     [...]
> 	lock_memory_hotplug();
>     [...]
> 	mutex_lock(&zonelists_mutex);
>     [...]
>     }
> 
> Note that udevd would have taken the device lock in device_online():
> 
>     int device_online(struct device *dev)
>     {
>         int ret = 0;
> 
>         device_lock(dev);
>     [...]
>     }
> 
> And while holding this we call online_pages() as above, nesting the memory
> hotplug lock inside the device_lock(dev).
> 
> This looks to be an ABBA deadlock, assuming dev is the same in these two
> cases which seems plausible as we emit the udev event in the middle.
