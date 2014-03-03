Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaCCJ0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 04:26:21 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:53253 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbaCCJ0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 04:26:13 -0500
Message-ID: <53144A57.4040204@huawei.com>
Date: Mon, 3 Mar 2014 17:24:39 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
CC: Li Zefan <lizefan@huawei.com>, Zhangwei <jovi.zhangwei@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [BUGREPORT] Tasklet scheduled issue in Linux 3.4.x-rt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,
   I found a tasklet related issue in linux-stable-rt 3.4.

And after I revert following commit, the test result seems ok(test lasted 40hours).

commit 0d9f73fc1e7270a3f8709c59c913408153d9d9f8
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Nov 29 20:18:22 2011 -0500

    tasklet: Prevent tasklets from going into infinite spin in RT


I test FC driver IO in this kernel, and after a few hours test, FC IO will abort, I found a lot of tasklet WARNING Call Trace in kernel message,like:

[2012-03-26 18:55:43][  929.252289] ------------[ cut here ]------------
[2012-03-26 18:55:43][  929.252312] WARNING: at kernel/softirq.c:773 __tasklet_action+0x51/0x1a0()
[2012-03-26 18:55:43][  929.252314] Hardware name: Romley
[2012-03-26 18:55:43][  929.252316] Modules linked in: isd_fid(O) ivs_edft(O) ivs_emp(O) ivs_xnet(O) isd_rds(O) isd_idm(O) isd_dft(O) isd_base(O) sdm(O) isd_cmm(O) isd_ibc(O) isd_lib(O) xve_hab(PO) xve_net(PO) xve_cls_msg_filter(PO) xve_dscp(PO) pagepool(PO) iod(O) cmm(PO) util(PO) intel_t10(PO) itest_nid(PO) dmi(PO) bsp_adapter(PO) mpa(O) ipmi_si ipmi_devintf ipmi_msghandler iscsi_sw(PO) iscsi_prot(O) iscsi_seg(PO) iscsi_comm(PO) iscsi_initiator(PO) 8192cu(O) pciehp(PO) pcieaer(PO) pciecore(PO) drvinstallthird(PO) quark(O) sal(O) pmsas(O) foe(O) lfcoe(O) libfc(O) ib_uverbs(O) ibtgt(O) ib_srpt(O) ib_cm(O) ib_sa(O) mlx4_ib(O) ib_umad(O) ib_mad(O) mlx4_core(O) ib_core(O) drvtom(O) cxgb4(O) drvtoecore(O) fcdrv(PO) unflowlevel(PO) unfcommon(O) drvmml(PO) scsi_transport_fc scsi_tgt memtest(PO) drv_iosubsys_ini(O) iocount(O) bsp_mml(PO) agetty_query(PO) cpufreq_powersave af_packet nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_limit xt_tcpudp xt_multiport nf_conntr!
ack_ipv4
 nf_defrag_ipv4 xt_state nf_conntrack usr_cache(O) acpi_cpufreq mperf processor thermal_sys sg hwmon iptable_filter ip_tables x_tables ixgbe(O) igb(O) bonding(O) tg(O) netmgmt(O) drvinstall(PO) dal(PO) dca usb_storage(O) uhci_hcd ehci_hcd usbcore(O) usb_common sata_mml(O) ahci(O) libata(O) satahp(O) drvframe(PO) sd_mod crc_t10dif scsi_mod agetty_interface(PO) ext3 jbd mbcache nvram_printk(PO) os_feeddog(PO) os_debug(O) osp_proc(PO) os_rnvramdev(PO) vos(O) bsp(PO) os_die_handler(O) os_oom_handler(O) os_panic_handler(O) biosnvramdriver(O) kbox(O)
[2012-03-26 18:55:43][  929.252460] Pid: 17495, comm: 3th SioT Tainted: P           O 3.4.24.15-0.11-default #1
[2012-03-26 18:55:43][  929.252463] Call Trace:
[2012-03-26 18:55:43][  929.252465]  <IRQ>  [<ffffffff810413d1>] ? __tasklet_action+0x51/0x1a0
[2012-03-26 18:55:43][  929.252481]  [<ffffffff81039e4a>] warn_slowpath_common+0x7a/0xb0
[2012-03-26 18:55:43][  929.252486]  [<ffffffff81039e95>] warn_slowpath_null+0x15/0x20
[2012-03-26 18:55:43][  929.252490]  [<ffffffff810413d1>] __tasklet_action+0x51/0x1a0
[2012-03-26 18:55:43][  929.252494]  [<ffffffff810415c9>] tasklet_action+0x59/0x60
[2012-03-26 18:55:43][  929.252498]  [<ffffffff81041a90>] handle_pending_softirqs+0xb0/0x170
[2012-03-26 18:55:43][  929.252502]  [<ffffffff81041b99>] __do_softirq+0x49/0xa0
[2012-03-26 18:55:43][  929.252513]  [<ffffffff8144e7dc>] call_softirq+0x1c/0x30
[2012-03-26 18:55:43][  929.252519]  [<ffffffff81004415>] do_softirq+0x65/0xa0
[2012-03-26 18:55:43][  929.252523]  [<ffffffff810418a5>] irq_exit+0xc5/0xe0
[2012-03-26 18:55:43][  929.252526]  [<ffffffff81003b74>] do_IRQ+0x64/0xe0
[2012-03-26 18:55:43][  929.252534]  [<ffffffff8144576a>] common_interrupt+0x6a/0x6a
[2012-03-26 18:55:43][  929.252536]  <EOI>  [<ffffffff81445506>] ? _raw_spin_unlock_irqrestore+0x16/0x30
[2012-03-26 18:55:43][  929.252565]  [<ffffffffa334ea84>] SDM_SDGetDisk+0x64/0x100 [sdm]
[2012-03-26 18:55:43][  929.252575]  [<ffffffffa334af47>] SDM_FRAMESdGetDisk+0x17/0x80 [sdm]
[2012-03-26 18:55:43][  929.252585]  [<ffffffffa33687e3>] SDM_ERRAddTimer+0x33/0x370 [sdm]
[2012-03-26 18:55:43][  929.252594]  [<ffffffffa334a747>] SDM_FRAMEErrAddTimer+0x17/0x80 [sdm]
[2012-03-26 18:55:43][  929.252604]  [<ffffffffa335b697>] SDM_SIOQueueReqProcess+0x67/0x7d0 [sdm]
[2012-03-26 18:55:43][  929.252612]  [<ffffffffa335bf42>] SDM_SIOQueueThread+0x142/0x310 [sdm]
[2012-03-26 18:55:43][  929.252618]  [<ffffffff8144e6e4>] kernel_thread_helper+0x4/0x10
[2012-03-26 18:55:43][  929.252627]  [<ffffffffa335be00>] ? SDM_SIOQueueReqProcess+0x7d0/0x7d0 [sdm]
[2012-03-26 18:55:43][  929.252632]  [<ffffffff8144e6e0>] ? gs_change+0x13/0x13
[2012-03-26 18:55:43][  929.252635] ---[ end trace a82addcbe6cbf131 ]---
.......[snip].........
[2012-03-27 03:41:06][ 3647.885973] ------------[ cut here ]------------
[2012-03-27 03:41:06][ 3647.886005] WARNING: at kernel/softirq.c:773 __tasklet_action+0x51/0x1a0()
[2012-03-27 03:41:06][ 3647.886010] Hardware name: Romley
[2012-03-27 03:41:06][ 3647.886012] Modules linked in: isd_fid(O) ivs_edft(O) ivs_emp(O) ivs_xnet(O) isd_rds(O) isd_idm(O) isd_dft(O) isd_base(O) sdm(O) isd_cmm(O) isd_ibc(O) isd_lib(O) xve_hab(PO) xve_net(PO) xve_cls_msg_filter(PO) xve_dscp(PO) pagepool(PO) iod(O) cmm(PO) util(PO) intel_t10(PO) itest_nid(PO) dmi(PO) bsp_adapter(PO) mpa(O) ipmi_si ipmi_devintf ipmi_msghandler iscsi_sw(PO) iscsi_prot(O) iscsi_seg(PO) iscsi_comm(PO) iscsi_initiator(PO) 8192cu(O) pciehp(PO) pcieaer(PO) pciecore(PO) drvinstallthird(PO) quark(O) sal(O) pmsas(O) foe(O) lfcoe(O) libfc(O) ib_uverbs(O) ibtgt(O) ib_srpt(O) ib_cm(O) ib_sa(O) mlx4_ib(O) ib_umad(O) ib_mad(O) mlx4_core(O) ib_core(O) drvtom(O) cxgb4(O) drvtoecore(O) fcdrv(PO) unflowlevel(PO) unfcommon(O) drvmml(PO) scsi_transport_fc scsi_tgt memtest(PO) drv_iosubsys_ini(O) iocount(O) bsp_mml(PO) agetty_query(PO) cpufreq_powersave af_packet nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_limit xt_tcpudp xt_multiport nf_conntr!
ack_ipv4
 nf_defrag_ipv4 xt_state nf_conntrack usr_cache(O) acpi_cpufreq mperf processor thermal_sys sg hwmon iptable_filter ip_tables x_tables ixgbe(O) igb(O) bonding(O) tg(O) netmgmt(O) drvinstall(PO) dal(PO) dca usb_storage(O) uhci_hcd ehci_hcd usbcore(O) usb_common sata_mml(O) ahci(O) libata(O) satahp(O) drvframe(PO) sd_mod crc_t10dif scsi_mod agetty_interface(PO) ext3 jbd mbcache nvram_printk(PO) os_feeddog(PO) os_debug(O) osp_proc(PO) os_rnvramdev(PO) vos(O) bsp(PO) os_die_handler(O) os_oom_handler(O) os_panic_handler(O) biosnvramdriver(O) kbox(O)
[2012-03-27 03:41:06][ 3647.886175] Pid: 21635, comm: sdtester Tainted: P        W  O 3.4.24.15-0.11-default #1
[2012-03-27 03:41:06][ 3647.886179] Call Trace:
[2012-03-27 03:41:06][ 3647.886182]  <IRQ>  [<ffffffff810413d1>] ? __tasklet_action+0x51/0x1a0
[2012-03-27 03:41:06][ 3647.886197]  [<ffffffff81039e4a>] warn_slowpath_common+0x7a/0xb0
[2012-03-27 03:41:06][ 3647.886201]  [<ffffffff81039e95>] warn_slowpath_null+0x15/0x20
[2012-03-27 03:41:06][ 3647.886205]  [<ffffffff810413d1>] __tasklet_action+0x51/0x1a0
[2012-03-27 03:41:06][ 3647.886209]  [<ffffffff810415c9>] tasklet_action+0x59/0x60
[2012-03-27 03:41:06][ 3647.886213]  [<ffffffff81041a90>] handle_pending_softirqs+0xb0/0x170
[2012-03-27 03:41:06][ 3647.886217]  [<ffffffff81041b99>] __do_softirq+0x49/0xa0
[2012-03-27 03:41:06][ 3647.886228]  [<ffffffff8144e7dc>] call_softirq+0x1c/0x30
[2012-03-27 03:41:06][ 3647.886234]  [<ffffffff81004415>] do_softirq+0x65/0xa0
[2012-03-27 03:41:06][ 3647.886238]  [<ffffffff810418a5>] irq_exit+0xc5/0xe0
[2012-03-27 03:41:06][ 3647.886243]  [<ffffffff81003b74>] do_IRQ+0x64/0xe0
[2012-03-27 03:41:06][ 3647.886252]  [<ffffffff8144576a>] common_interrupt+0x6a/0x6a
[2012-03-27 03:41:06][ 3647.886254]  <EOI>  [<ffffffff814454e0>] ? _raw_spin_unlock_irq+0x10/0x20
[2012-03-27 03:41:06][ 3647.886264]  [<ffffffff814454d9>] ? _raw_spin_unlock_irq+0x9/0x20
[2012-03-27 03:41:06][ 3647.886275]  [<ffffffff8118e8d2>] kiocb_batch_refill+0x2c2/0x2e0
[2012-03-27 03:41:06][ 3647.886279]  [<ffffffff8118eb0c>] io_submit_one+0x21c/0x2b0
[2012-03-27 03:41:06][ 3647.886284]  [<ffffffff8118ed0a>] do_io_submit+0x16a/0x360
[2012-03-27 03:41:06][ 3647.886288]  [<ffffffff8118ef0b>] sys_io_submit+0xb/0x10
[2012-03-27 03:41:06][ 3647.886293]  [<ffffffff8144d3f9>] system_call_fastpath+0x16/0x1b
[2012-03-27 03:41:06][ 3647.886297] ---[ end trace a82addcbe6cbf137 ]---
[2012-03-27 03:42:04][ 3705.434405] ------------[ cut here ]------------
[2012-03-27 03:42:04][ 3705.434418] WARNING: at kernel/softirq.c:799 __tasklet_action+0xae/0x1a0()
[2012-03-27 03:42:04][ 3705.434421] Hardware name: Romley
[2012-03-27 03:42:04][ 3705.434423] Modules linked in: isd_fid(O) ivs_edft(O) ivs_emp(O) ivs_xnet(O) isd_rds(O) isd_idm(O) isd_dft(O) isd_base(O) sdm(O) isd_cmm(O) isd_ibc(O) isd_lib(O) xve_hab(PO) xve_net(PO) xve_cls_msg_filter(PO) xve_dscp(PO) pagepool(PO) iod(O) cmm(PO) util(PO) intel_t10(PO) itest_nid(PO) dmi(PO) bsp_adapter(PO) mpa(O) ipmi_si ipmi_devintf ipmi_msghandler iscsi_sw(PO) iscsi_prot(O) iscsi_seg(PO) iscsi_comm(PO) iscsi_initiator(PO) 8192cu(O) pciehp(PO) pcieaer(PO) pciecore(PO) drvinstallthird(PO) quark(O) sal(O) pmsas(O) foe(O) lfcoe(O) libfc(O) ib_uverbs(O) ibtgt(O) ib_srpt(O) ib_cm(O) ib_sa(O) mlx4_ib(O) ib_umad(O) ib_mad(O) mlx4_core(O) ib_core(O) drvtom(O) cxgb4(O) drvtoecore(O) fcdrv(PO) unflowlevel(PO) unfcommon(O) drvmml(PO) scsi_transport_fc scsi_tgt memtest(PO) drv_iosubsys_ini(O) iocount(O) bsp_mml(PO) agetty_query(PO) cpufreq_powersave af_packet nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_limit xt_tcpudp xt_multiport nf_conntr!
ack_ipv4
 nf_defrag_ipv4 xt_state nf_conntrack usr_cache(O) acpi_cpufreq mperf processor thermal_sys sg hwmon iptable_filter ip_tables x_tables ixgbe(O) igb(O) bonding(O) tg(O) netmgmt(O) drvinstall(PO) dal(PO) dca usb_storage(O) uhci_hcd ehci_hcd usbcore(O) usb_common sata_mml(O) ahci(O) libata(O) satahp(O) drvframe(PO) sd_mod crc_t10dif scsi_mod agetty_interface(PO) ext3 jbd mbcache nvram_printk(PO) os_feeddog(PO) os_debug(O) osp_proc(PO) os_rnvramdev(PO) vos(O) bsp(PO) os_die_handler(O) os_oom_handler(O) os_panic_handler(O) biosnvramdriver(O) kbox(O)
[2012-03-27 03:42:04][ 3705.434574] Pid: 11, comm: ksoftirqd/1 Tainted: P        W  O 3.4.24.15-0.11-default #1
[2012-03-27 03:42:04][ 3705.434577] Call Trace:
[2012-03-27 03:42:04][ 3705.434586]  [<ffffffff8104142e>] ? __tasklet_action+0xae/0x1a0
[2012-03-27 03:42:04][ 3705.434592]  [<ffffffff81039e4a>] warn_slowpath_common+0x7a/0xb0
[2012-03-27 03:42:04][ 3705.434596]  [<ffffffff81039e95>] warn_slowpath_null+0x15/0x20
[2012-03-27 03:42:04][ 3705.434600]  [<ffffffff8104142e>] __tasklet_action+0xae/0x1a0
[2012-03-27 03:42:04][ 3705.434604]  [<ffffffff810415c9>] tasklet_action+0x59/0x60
[2012-03-27 03:42:04][ 3705.434608]  [<ffffffff81041a90>] handle_pending_softirqs+0xb0/0x170
[2012-03-27 03:42:04][ 3705.434613]  [<ffffffff81041b99>] __do_softirq+0x49/0xa0
[2012-03-27 03:42:04][ 3705.434616]  [<ffffffff81041d35>] run_ksoftirqd+0x145/0x160
[2012-03-27 03:42:04][ 3705.434620]  [<ffffffff81041bf0>] ? __do_softirq+0xa0/0xa0
[2012-03-27 03:42:04][ 3705.434623]  [<ffffffff81041bf0>] ? __do_softirq+0xa0/0xa0
[2012-03-27 03:42:04][ 3705.434629]  [<ffffffff8105c3ee>] kthread+0x9e/0xb0
[2012-03-27 03:42:04][ 3705.434637]  [<ffffffff8144e6e4>] kernel_thread_helper+0x4/0x10
[2012-03-27 03:42:04][ 3705.434641]  [<ffffffff8105c350>] ? __init_kthread_worker+0x40/0x40
[2012-03-27 03:42:04][ 3705.434646]  [<ffffffff8144e6e0>] ? gs_change+0x13/0x13
[2012-03-27 03:42:04][ 3705.434648] ---[ end trace a82addcbe6cbf138 ]---


I tested my FC IO in my platform(x86 smp machine, which have 8 cpus), after FC IO
running a few hours(sometimes 1-2h), I found FC IO abort. We found FC driver tasklet
can not run in current CPU(which received interrupts).

In our FC driver, the process flow:

FC card hardware  -------> FC driver interrupt handler  --------->tasklet_schedule(fc driver tasklet) ------->tasklet running, call function process FC IO data.
                        here will disable FC card interrupt                                                     here will enable FC card interrupt again

After the issue occur, OS can not receive the interrupt again(we check the FC hardware and the interrupt is disabled).
At this time, for debug, we force FC hardware reset to send a interrupt to OS,
and we track this interrupt in FC driver interrupt handler.
We found the tasklet state is 0x1(mean state is TASKLET_STATE_SCHED),count is 0, before we call tasklet_schedule().
So the new tasklet can not add to CPU list.

............
    if (TRUE == fcinterrupthandler(&(pstHba->hpRoot)))    ------------> disable FC card interrupt here.
    {
        set_bit(TADRV_DPC_INT, (void *)&(pstHba->ulDelayProcessFlag));
        /* use schedule_task because some of the OS callback events
        * allocate memory which we can not do in the immediate queue.
        */
        tasklet_schedule(&pstHba->stDelayProcessTasklet);
        spin_unlock(pstHba->pstPortLock);//È¥µôirq save
        return IRQ_HANDLED;
    }
............

And I also add some dynamic debug in __tasklet_action(); after the issue occur, I open the dynamic debug.
After we force the hardware reset to interrupt OS, we never found the FC driver tasklet running in dmesg(I identify the tasklet by its data).
I guess the FC tasklet is not in CPU global tasklet list.

So I suspect the FC driver tasklet maybe lost with the patch 0d9f73fc1e.
Further more, I tested the kernel without this patch(0d9f73fc1e), I tested the FC IO exceed 40 hours, and the result is ok.

I hope somebody can help to look at it. If I missing something, let me know.



Thanks!
Yijing.



-- 
Thanks!
Yijing

