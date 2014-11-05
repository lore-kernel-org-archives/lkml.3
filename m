Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbaKEFO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 00:14:27 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:63474 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaKEFO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 00:14:26 -0500
Message-ID: <5459B21E.4030707@huawei.com>
Date: Wed, 5 Nov 2014 13:14:06 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>
CC: Weng Meiling <wengmeiling.weng@huawei.com>,
        Frans Klaver <fransklaver@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        <akpm@linux-foundation.org>, <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiang Rui <rui.xiang@huawei.com>, Li Zefan <lizefan@huawei.com>,
        Huang Qiang <h.huangqiang@huawei.com>,
        Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: Re: Subject: [PATCH] kobject: fix the race between kobject_del and
 get_device_parent
References: <543F25D3.8010708@huawei.com> <CAH6sp9PZYLRntXzmX14OmJpwWBu2_h=_h3oSvpaHE=gAG0meBw@mail.gmail.com> <543F7289.8010807@huawei.com> <20141016091328.GB24374@kroah.com> <544765D0.70302@huawei.com> <20141104191535.GI14459@htj.dyndns.org> <54598503.1060905@huawei.com> <20141105031345.GA29392@htj.dyndns.org> <5459992B.1040700@huawei.com> <20141105032943.GB29392@htj.dyndns.org> <20141105035224.GB9419@kroah.com>
In-Reply-To: <20141105035224.GB9419@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020201.5459B22C.01B3,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: d62fd44aa0b65d0dd98eecb70c94d65c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/5 11:52, Greg KH wrote:
> On Tue, Nov 04, 2014 at 10:29:43PM -0500, Tejun Heo wrote:
>> Hello,
>>
>> On Wed, Nov 05, 2014 at 11:27:39AM +0800, Yijing Wang wrote:
>>> Keep the parent directory looks good to me,  we could only add kobject_get(&parent)
>>> after the parent dir be created.
>>>
>>> ....
>>> 		/* or create a new class-directory at the parent device */
>>> 		k = class_dir_create_and_add(dev->class, parent_kobj);
>>> 		/* do not emit an uevent for this simple "glue" directory */
>>> 		kobject_get(k);  <--------add parent ref count for first child device.
>>
>> The created directory would already have the base ref.  I don't think
>> you need the above.  Just never put the parent once created.
>>
>> Greg, how does this sound to you?
> 
> It makes sense, but I don't understand, what "parent" directory is going
> away and causing problems?

Hi Greg,
   We have some devices be created under /sys/devices/virtual/block, i.e

linux-rh5885:/sys/devices/virtual/block # ls
DEV1 	DEV2 	DEV3

the "block" directory is created after the first child device DEV1 created.

Then we frequently add DEV1,DEV2,DEV3 and remove DEV1,DEV2,DEV3 (this is a stress test).

Then some happens as bellow.

path 1 (Add child device)								path 2 (Remove child device)

device_add()										device_del()
	get_device_parent()									cleanup_device_parent()
		find existent parent dir("block")							cleanup_glue_dir()
		if nothing found, create it.									kobject_put(glue_dir);
		...piece code..
		list_for_each_entry(k, &dev->class->p->glue_dirs.list, entry)
			if (k->parent == parent_kobj) {
				kobj = kobject_get(k);
				break;
			}	
		......
		k = class_dir_create_and_add(dev->class, parent_kobj);

In the path 2, if the child device is the last child device under "/sys/devices/virtual/block",
the parent dir "block" ref count will be decreased to 0. So if path 2 call cleanup_glue_dir() but before kobject_put(glue_dir);
the path 1 child device will find the parent glue dir "block" from the glue_dirs.list, but unfortunately, before the path1 child
device call kobject_get(k), the path 2 remove the parent glue dir, then finally, path 1 reports WARNING and BUG_ON.

The first child device created the glue dir, but not get its ref count, maybe it's a problem.

Kernel Calltrace as bellow:
--------------------
<4>[ 3965.441471] WARNING: at /usr/src/packages/BUILD/kernel-default-3.4.24.19/linux-3.4/include/linux/kref.h:41 kobject_get+0x33/0x40()
<4>[ 3965.441474] Hardware name: Romley
<4>[ 3965.441475] Modules linked in: isd_iop(O) isd_xda(O) ivs_edft(O) ivs_xnet(O) ivs_emp(O) isd_rds(O) isd_idm(O) isd_dft(O) isd_base(O) sdm(O) isd_startwork(O) isd_fid(O) isd_cmm(O) isd_ibc(O) isd_lib(O) xve_hab(PO) xve_net(PO) xve_cls_msg_filter(PO) xve_dscp(PO) pagepool(PO) quota(PO) iod(O) cmm(PO) util(PO) intel_t10(PO) itest_nid(PO) dmi(PO) bsp_adapter(PO) iscsi_sw(PO) iscsi_prot(O) iscsi_seg(PO) iscsi_comm(PO) iscsi_initiator(PO) pciehp(PO) pcieaer(PO) pciecore(PO) quark(O) sal(O) foe(O) lfcoe(O) libfc(O) ib_uverbs(O) ibtgt(PO) ib_srpt(O) ib_cm(O) ib_sa(O) mlx4_ib(O) ib_umad(O) ib_mad(O) mlx4_core(O) ib_core(O) drvtom(O) cxgb4(O) drvtoecore(O) fcdrv(PO) unflowlevel_ioc(PO) unflowlevel(PO) unfcommon(O) fcportft(PO) mpa(O) drvmml(PO) scsi_transport_fc scsi_tgt memtest(PO) drv_iosubsys_ini(O) iocount(O) bsp_mml(PO) agetty_query(PO) cpufreq_powersave nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_limit xt_tcpudp xt_multiport nf_conntrack_ipv4 nf_defrag_ip!
v4 xt_st
ate nf_conntrack usr_cache(O) af_packet acpi_cpufreq sg mperf processor thermal_sys hwmon iptable_filter ip_tables x_tables ixgbe(O) igb(O) bonding(O) tg(O) 8021q e1000e(O) netmgmt(O) dal(PO) dca usb_storage(O) uhci_hcd ehci_hcd usbcore(O) usb_common sata_mml(O) ahci(O) libata(O) satahp(O) drvframe(PO) sd_mod crc_t10dif scsi_mod agetty_interface(PO) os_flush_mgt_ip_config(PO) ipmi_devintf ipmi_msghandler raid1 ext3 jbd mbcache nvram_printk(PO) os_feeddog(PO) os_debug(O) osp_proc(PO) os_rnvramdev(PO) vos(O) zlib_deflate os_die_handler(O) os_oom_handler(O) os_panic_handler(O) bsp(PO) biosnvram_driver(O) kbox(O)
<4>[ 3965.441603] Pid: 318, comm: sched_work Tainted: P           O 3.4.24.19-0.11-default #1
<4>[ 3965.441605] Call Trace:
<4>[ 3965.441611]  [<ffffffff8103717a>] warn_slowpath_common+0x7a/0xb0
<4>[ 3965.441615]  [<ffffffff810371c5>] warn_slowpath_null+0x15/0x20
<4>[ 3965.441618]  [<ffffffff81215963>] kobject_get+0x33/0x40
<4>[ 3965.441624]  [<ffffffff812d1e45>] get_device_parent.isra.11+0x135/0x1f0
<4>[ 3965.441627]  [<ffffffff812d22d4>] device_add+0xd4/0x6d0
<4>[ 3965.441631]  [<ffffffff812d0dbc>] ? dev_set_name+0x3c/0x40
<4>[ 3965.441634]  [<ffffffff812030ac>] add_disk+0x1bc/0x490
<4>[ 3965.441648]  [<ffffffffa36a67c6>] SDM_BLKAddBlkDisk+0x86/0x290 [sdm]
<4>[ 3965.441658]  [<ffffffffa36a6a55>] SDM_BLKRegisterThread+0x85/0x330 [sdm]
<4>[ 3965.441680]  [<ffffffffa00dfb7e>] LVOS_SchedWorkThread+0xde/0x190 [vos]
<4>[ 3965.441686]  [<ffffffff8144a8a4>] kernel_thread_helper+0x4/0x10
<4>[ 3965.441700]  [<ffffffffa00dfaa0>] ? LVOS_CreateSchedWorkThread+0xd0/0xd0 [vos]
<4>[ 3965.441705]  [<ffffffff8144a8a0>] ? gs_change+0x13/0x13
<4>[ 3965.441707] ---[ end trace 814bfedb5cb27305 ]---

<4>[ 3965.441713] WARNING: at /usr/src/packages/BUILD/kernel-default-3.4.24.19/linux-3.4/lib/kobject.c:202 kobject_add_internal+0x11f/0x280()
<4>[ 3965.441716] Hardware name: Romley
<4>[ 3965.441718] kobject_add_internal failed for sd-1a (error: -2 parent: ?qF)
<4>[ 3965.441720] Modules linked in: isd_iop(O) isd_xda(O) ivs_edft(O) ivs_xnet(O) ivs_emp(O) isd_rds(O) isd_idm(O) isd_dft(O) isd_base(O) sdm(O) isd_startwork(O) isd_fid(O) isd_cmm(O) isd_ibc(O) isd_lib(O) xve_hab(PO) xve_net(PO) xve_cls_msg_filter(PO) xve_dscp(PO) pagepool(PO) quota(PO) iod(O) cmm(PO) util(PO) intel_t10(PO) itest_nid(PO) dmi(PO) bsp_adapter(PO) iscsi_sw(PO)
<1>[ 3965.441741] [00002][INFO][ISD][SDM_BLKUnRegisterThread,204][992864]Bd 2 Index 0 removed.
<4>[ 3965.441744]  iscsi_prot(O) iscsi_seg(PO) iscsi_comm(PO) iscsi_initiator(PO) pciehp(PO) pcieaer(PO) pciecore(PO) quark(O) sal(O) foe(O) lfcoe(O) libfc(O) ib_uverbs(O) ibtgt(PO) ib_srpt(O) ib_cm(O) ib_sa(O) mlx4_ib(O) ib_umad(O) ib_mad(O) mlx4_core(O) ib_core(O) drvtom(O) cxgb4(O) drvtoecore(O) fcdrv(PO) unflowlevel_ioc(PO) unflowlevel(PO) unfcommon(O) fcportft(PO) mpa(O) drvmml(PO) scsi_transport_fc scsi_tgt memtest(PO) drv_iosubsys_ini(O) iocount(O) bsp_mml(PO) agetty_query(PO) cpufreq_powersave nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_limit xt_tcpudp xt_multiport nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack usr_cache(O) af_packet acpi_cpufreq sg mperf processor thermal_sys hwmon iptable_filter ip_tables x_tables ixgbe(O) igb(O) bonding(O) tg(O) 8021q e1000e(O) netmgmt(O) dal(PO) dca usb_storage(O) uhci_hcd ehci_hcd usbcore(O) usb_common sata_mml(O) ahci(O) libata(O) satahp(O) drvframe(PO) sd_mod crc_t10dif scsi_mod agetty_interface(PO) !
os_flush
_mgt_ip_config(PO) ipmi_devintf ipmi_msghandler raid1 ext3 jbd mbcache nvram_printk(PO) os_feeddog(PO) os_debug(O) osp_proc(PO) os_rnvramdev(PO) vos(O) zlib_deflate os_die_handler(O) os_oom_handler(O) os_panic_handler(O) bsp(PO) biosnvram_driver(O) kbox(O)
<4>[ 3965.441815] Pid: 318, comm: sched_work Tainted: P        W  O 3.4.24.19-0.11-default #1
<4>[ 3965.441817] Call Trace:
<4>[ 3965.441820]  [<ffffffff8103717a>] warn_slowpath_common+0x7a/0xb0
<4>[ 3965.441823]  [<ffffffff81037251>] warn_slowpath_fmt+0x41/0x50
<4>[ 3965.441826]  [<ffffffff81215e0f>] kobject_add_internal+0x11f/0x280
<4>[ 3965.441830]  [<ffffffff81216267>] kobject_add+0x67/0xc0
<4>[ 3965.441833]  [<ffffffff812d2305>] device_add+0x105/0x6d0
<4>[ 3965.441836]  [<ffffffff812d0dbc>] ? dev_set_name+0x3c/0x40
<4>[ 3965.441839]  [<ffffffff812030ac>] add_disk+0x1bc/0x490
<4>[ 3965.441849]  [<ffffffffa36a67c6>] SDM_BLKAddBlkDisk+0x86/0x290 [sdm]
<4>[ 3965.441858]  [<ffffffffa36a6a55>] SDM_BLKRegisterThread+0x85/0x330 [sdm]
<4>[ 3965.441874]  [<ffffffffa00dfb7e>] LVOS_SchedWorkThread+0xde/0x190 [vos]
<4>[ 3965.441879]  [<ffffffff8144a8a4>] kernel_thread_helper+0x4/0x10
<4>[ 3965.441892]  [<ffffffffa00dfaa0>] ? LVOS_CreateSchedWorkThread+0xd0/0xd0 [vos]
<4>[ 3965.441897]  [<ffffffff8144a8a0>] ? gs_change+0x13/0x13
<4>[ 3965.441899] ---[ end trace 814bfedb5cb27306 ]---


<2>[ 3965.441912] kernel BUG at /usr/src/packages/BUILD/kernel-default-3.4.24.19/linux-3.4/fs/sysfs/group.c:65!
<4>[ 3965.441915] invalid opcode: 0000 [#1] SMP
<4>[ 3965.443707] calling kbox_sync :begin
<4>[ 3965.447262] sync kbox :begin
<4>[ 3965.450122] open all redirect device :begin
<4>[ 3965.454276] open all redirect device :end
<4>[ 3965.458257] flush kbox regions :begin
<4>[ 3965.461897] kbox region (die) is writing into (biosnvram), action is 202
<4>[ 3965.468556] test write len : 2009
<4>[ 3965.471847] first start addr : ffff88007e706000
<1>[ 3965.474542] [00002][INFO][ISD][ISD_EMMProcessBDMEvent,3778][992873]SCSI_DISK_EVENT_OUT BDM id is 2
<1>[ 3965.474546] [00002][INFO][ISD][ISD_EMMLunCheckSame,2131][992873]Find same ramdisk in list! BdmID(0x2)
<1>[ 3965.474549] [00002][INFO][ISD][ISD_EMMProcessDiskOut,3099][992873]No need to add ramdisk(DiskType:0xfc) to topo!
<1>[ 3965.474555] [00002][WARN][ISD][SDM_DEVDiskEventHandle,927][992873]Disk(disk id=2) type is peripheral lun, skip handle.
<4>[ 3965.515140] second start addr : ffff88007e706000
<4>[ 3965.519727] cur_index : 0, offset : 0, third start addr : ffff88007e706000
<4>[ 3965.526557] first length : 2009
<4>[ 3965.529676] cur_index : 1, record_number : 1, total_number : 4
<4>[ 3965.535471] kbox region (die) has been written into (biosnvram)
<4>[ 3965.541351] dev biosnvram is dirty
<4>[ 3965.544732] kbox region (console) is writing into (biosnvram), action is 202
<4>[ 3965.551733] test write len : 1211
<4>[ 3965.555022] first start addr : ffff88007e906000
<4>[ 3965.559521] second start addr : ffff88007e906000
<4>[ 3965.564107] cur_index : 0, offset : 0, third start addr : ffff88007e906000
<4>[ 3965.570935] first length : 1211
<4>[ 3965.574053] cur_index : 1, record_number : 1, total_number : 16
<4>[ 3965.579932] kbox region (console) has been written into (biosnvram)
<4>[ 3965.586155] dev biosnvram is dirty
<4>[ 3965.589531] kbox region (message) is writing into (biosnvram), action is 202
<4>[ 3965.596534] test write len : 65566
<4>[ 3965.599910] first start addr : ffff88007e806000
<4>[ 3965.604410] second start addr : ffff88007e806000
<4>[ 3965.608997] cur_index : 0, offset : 0, third start addr : ffff88007e806000
<4>[ 3965.615827] first length : 65566
<4>[ 3965.619040] cur_index : 1, record_number : 1, total_number : 4
<4>[ 3965.624835] kbox region (message) has been written into (biosnvram)
<4>[ 3965.631059] dev biosnvram is dirty
<4>[ 3965.634435] flush kbox regions :end
<4>[ 3965.637900] flush kbox superblock :begin
<4>[ 3965.641796] supperblock dev=biosnvram is dirty
<4>[ 3965.646211] flush kbox superblock: end
<4>[ 3965.649935] close all redirect device :begin
<4>[ 3965.654175] close all redirect device :end
<4>[ 3965.658242] sync kbox :end
<4>[ 3965.660929] calling kbox_sync :end
<4>[ 3965.664394] do nothing after die!
<4>[ 3965.664395] now, die chain processing!
<4>[ 3965.667636] OS_SaveKernSegToNVRAM save 4510065 bytes
<4>[ 3965.673276] OS_SaveModSegToNVRAM the modules addr:ffffffff818250e0
<4>[ 3965.677342] OS_SaveModSegToNVRAM, no size left to content more ,exit...
<4>[ 3965.684146] OS_SaveVmallocToNVRAM
<4>[ 3965.684185] the count:511
<4>[ 3965.684187] now crash happen, set bsp watchdog to 5 min.
<5>[ 3965.684193] [992925][5400040602c1][INF][Begin To Set Watchdog Level:0x3.][BSP][SP2_Watc.merSet,700][sched_work]
<4>[ 3965.684259] CPU 1
<4>[ 3965.684260] Modules linked in: isd_iop(O) isd_xda(O) ivs_edft(O) ivs_xnet(O) ivs_emp(O) isd_rds(O) isd_idm(O) isd_dft(O) isd_base(O) sdm(O) isd_startwork(O) isd_fid(O) isd_cmm(O) isd_ibc(O) isd_lib(O) xve_hab(PO) xve_net(PO) xve_cls_msg_filter(PO) xve_dscp(PO) pagepool(PO) quota(PO) iod(O) cmm(PO) util(PO) intel_t10(PO) itest_nid(PO) dmi(PO) bsp_adapter(PO) iscsi_sw(PO) iscsi_prot(O) iscsi_seg(PO) iscsi_comm(PO) iscsi_initiator(PO) pciehp(PO) pcieaer(PO) pciecore(PO) quark(O) sal(O) foe(O) lfcoe(O) libfc(O) ib_uverbs(O) ibtgt(PO) ib_srpt(O) ib_cm(O) ib_sa(O) mlx4_ib(O) ib_umad(O) ib_mad(O) mlx4_core(O) ib_core(O) drvtom(O) cxgb4(O) drvtoecore(O) fcdrv(PO) unflowlevel_ioc(PO) unflowlevel(PO) unfcommon(O) fcportft(PO) mpa(O) drvmml(PO) scsi_transport_fc scsi_tgt memtest(PO) drv_iosubsys_ini(O) iocount(O) bsp_mml(PO) agetty_query(PO) cpufreq_powersave nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_limit xt_tcpudp xt_multiport nf_conntrack_ipv4 nf_defrag_ip!
v4 xt_st
ate nf_conntrack usr_cache(O) af_packet acpi_cpufreq sg mperf processor thermal_sys hwmon iptable_filter ip_tables x_tables ixgbe(O) igb(O) bonding(O) tg(O) 8021q e1000e(O) netmgmt(O) dal(PO) dca usb_storage(O) uhci_hcd ehci_hcd usbcore(O) usb_common sata_mml(O) ahci(O) libata(O) satahp(O) drvframe(PO) sd_mod crc_t10dif scsi_mod agetty_interface(PO) os_flush_mgt_ip_config(PO) ipmi_devintf ipmi_msghandler raid1 ext3 jbd mbcache nvram_printk(PO) os_feeddog(PO) os_debug(O) osp_proc(PO) os_rnvramdev(PO) vos(O) zlib_deflate os_die_handler(O) os_oom_handler(O) os_panic_handler(O) bsp(PO) biosnvram_driver(O) kbox(O)
<4>[ 3965.684382]
<4>[ 3965.684385] Pid: 318, comm: sched_work Tainted: P        W  O 3.4.24.19-0.11-default #1 Huawei Technologies Co., Ltd. Romley/STL2SPCAC.
<4>[ 3965.684391] RIP: 0010:[<ffffffff811a6722>]  [<ffffffff811a6722>] internal_create_group+0x202/0x230
<4>[ 3965.686224] RSP: 0018:ffff8801046efd20  EFLAGS: 00010246
<4>[ 3965.686227] RAX: 00000000fffffffe RBX: ffff880030aa7000 RCX: 000000000018b2fc
<4>[ 3965.686229] RDX: ffffffff81828f00 RSI: 0000000000000000 RDI: ffff880030aa7078
<4>[ 3965.686232] RBP: ffff8801046efd70 R08: 00000000000183d0 R09: ffff88010ae383d0
<4>[ 3965.686234] R10: ffffea0000fb2180 R11: ffffffff812d23b1 R12: ffff880030aa7000
<4>[ 3965.686237] R13: ffffffff81828f00 R14: 0000000000000000 R15: ffff880030aa7068
<4>[ 3965.686240] FS:  00007f89c61ef700(0000) GS:ffff88010ae20000(0000) knlGS:0000000000000000
<4>[ 3965.686243] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
<4>[ 3965.686245] CR2: ffffffffff600400 CR3: 000000003bacc000 CR4: 00000000001407e0
<4>[ 3965.686248] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<4>[ 3965.686250] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<4>[ 3965.686253] Process sched_work (pid: 318, threadinfo ffff8801046ee000, task ffff880066392e40)
<4>[ 3965.686670] Stack:
<4>[ 3965.686672]  ffff880030aa7350 ffff880030aa7078 ffff8801046efd40 00000000000000dd
<4>[ 3965.686677]  ffff8801046efd70 ffff880030aa7000 ffff880030aa7000 ffff88003cdb90b0
<4>[ 3965.686682]  ffff880030aa7068 ffff880030aa7068 ffff8801046efd80 ffffffff811a677e
<4>[ 3965.686686]  ffff8801046efd90 ffffffff810cfb04 ffff8801046efde0 ffffffff811fcabb
<4>[ 3965.686691]  ffff8801046efdf0 ffff8801046efdb0 ffff880030aa7078 ffff880030aa7000
<4>[ 3965.686695]  ffff88003cdb90b0 ffff880030aa700c ffff880030aa7078 ffff880030aa7068
<4>[ 3965.686699]  ffff8801046efe40 ffffffff812030bc 0fd0004072982900 ffff880030aa7000
<4>[ 3965.686703]  ffff880030aa7000 ffff880030aa7000 ffff8801046efe40 ffff880030aa7000
<4>[ 3965.686707]  ffff880072982900 0000000000000000 0000000000000282 0000000000000000
<4>[ 3965.686711]  ffff8801046efe90 ffffffffa36a67c6 ffff8801046efea8 ffff8801046efe60
<4>[ 3965.686715]  dead000000100100 0000000000000282 ffff8801046efe90 ffff880072982900
<4>[ 3965.686719]  ffffffffa36dbc20 ffffffffa36dbc60 ffff8801046eff00 ffffffffa36a6a55
<4>[ 3965.686723]  00000000000f2660 0000000000000282 ffff8801046efec0 ffffffffa0104000
<4>[ 3965.686727]  ffff8801046efef0 ffffffffa36dbc40 0000000000000000 ffffffffa36dbc98
<4>[ 3965.686731]  0000000000000001 ffffffffa36dbc90 0000000000000000 0000000000000000
<4>[ 3965.686735]  ffff8801046eff40 ffffffffa00dfb7e
<4>[ 3965.686738] Call Trace:
<4>[ 3965.686743]  [<ffffffff811a677e>] sysfs_create_group+0xe/0x10
<4>[ 3965.686748]  [<ffffffff810cfb04>] blk_trace_init_sysfs+0x14/0x20
<4>[ 3965.686753]  [<ffffffff811fcabb>] blk_register_queue+0x3b/0x120
<4>[ 3965.686756]  [<ffffffff812030bc>] add_disk+0x1cc/0x490
<4>[ 3965.686770]  [<ffffffffa36a67c6>] SDM_BLKAddBlkDisk+0x86/0x290 [sdm]
<4>[ 3965.686780]  [<ffffffffa36a6a55>] SDM_BLKRegisterThread+0x85/0x330 [sdm]
<4>[ 3965.686801]  [<ffffffffa00dfb7e>] LVOS_SchedWorkThread+0xde/0x190 [vos]
<4>[ 3965.686806]  [<ffffffff8144a8a4>] kernel_thread_helper+0x4/0x10
<4>[ 3965.686821]  [<ffffffffa00dfaa0>] ? LVOS_CreateSchedWorkThread+0xd0/0xd0 [vos]
<4>[ 3965.686825]  [<ffffffff8144a8a0>] ? gs_change+0x13/0x13



> 
> thanks,
> 
> greg k-h
> 
> .
> 


-- 
Thanks!
Yijing

