Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab3E3SaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:30:11 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40307 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab3E3SaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:30:05 -0400
Date: Thu, 30 May 2013 14:29:48 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: WARNING: at /home/konrad/linux-linus/kernel/time/tick-sched.c:935
 tick_nohz_idle_exit+0x195/0x1b0() on v3.10-rc3
Message-ID: <20130530182948.GA11612@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I had not yet done a full git bisection run but since this is new code added
in v3.10. I did not see this in v3.9. I think I saw this in v3.10-rc1 but never
got to look at it in depth.

Either way on a PV guest, if I do:

echo 0 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu1/online

I get this fat warning:

[   39.946760] Broke affinity for irq 16
[   40.071242] installing Xen timer for CPU 1
[   40.076109] cpu 1 spinlock event irq 48
[   40.081207] ------------[ cut here ]------------
[   40.085841] WARNING: at /home/konrad/linux-linus/kernel/time/tick-sched.c:935 tick_nohz_idle_exit+0x195/0x1b0()
[   40.095970] Modules linked in: dm_multipath dm_mod xen_evtchn iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi libcrc32c crc32c i915 radeon sg sd_mod mperf skge e1000 sata_nv nouveau ata_generic libata fbcon tileblit font bitblit scsi_mod ttm softcursor drm_kms_helper mxm_wmi video wmi xen_blkfront xen_netfront fb_sys_fops sysimgblt sysfillrect syscopyarea xenfs xen_privcmd
[   40.130893] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.10.0-rc3upstream-00068-gdcdbe33 #1
[   40.139212] Hardware name: BIOSTAR Group N61PB-M2S/N61PB-M2S, BIOS 6.00 PG 09/03/2009
[   40.147098]  ffffffff8193b448 ffff880039da5e60 ffffffff816707c8 ffff880039da5ea0
[   40.154550]  ffffffff8108ce8b ffff880039da4010 ffff88003fa8e500 ffff880039da4010
[   40.162004]  0000000000000001 ffff880039da4000 ffff880039da4010 ffff880039da5eb0
[   40.169458] Call Trace:
[   40.171977]  [<ffffffff816707c8>] dump_stack+0x19/0x1b
[   40.177175]  [<ffffffff8108ce8b>] warn_slowpath_common+0x6b/0xa0
[   40.183243]  [<ffffffff8108ced5>] warn_slowpath_null+0x15/0x20
[   40.189134]  [<ffffffff810e4745>] tick_nohz_idle_exit+0x195/0x1b0
[   40.195287]  [<ffffffff810da755>] cpu_startup_entry+0x205/0x250
[   40.201268]  [<ffffffff81661070>] cpu_bringup_and_idle+0x13/0x15
[   40.207332] ---[ end trace 915c8c486004dda1 ]---


which I presume is b/c the code does not expect to be run _after_ it has
offlined. However, under the PV code, the mechanism is that that a CPU
that has been offlined, can resume (if it is onlined). If you look at:

445 static void __cpuinit xen_play_dead(void) /* used only with HOTPLUG_CPU */      
446 {                                                                               
447         play_dead_common();                                                     
448         HYPERVISOR_vcpu_op(VCPUOP_down, smp_processor_id(), NULL);              
449         cpu_bringup();                                                          
450 }                               

That is called right after the CPU is put to sleep and the hypercall 
VCPUOP_down blocks - until the CPU is brough back up. And which point
we end up calling cpu_bringup - which sets up the clockevets, timers, etc.

I am wondering if part of this is that the ts->inidle gets reset
b/c we end up resetting all the timers but then when xen_play_dead
exits, it ends up right back in the cpu_idle_loop() loop - and we
call tick_nohz_idle_exit().

Thoughts?
