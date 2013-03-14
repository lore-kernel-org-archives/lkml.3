Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab3CNNxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:53:00 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:53983 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab3CNNw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:52:56 -0400
Message-ID: <5141D5E6.4060001@gmail.com>
Date: Thu, 14 Mar 2013 21:51:34 +0800
From: Shuge <shugelinux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Kevin <kevin@allwinnertech.com>,
        linux-serial@vger.kernel.org
CC: Russell King <linux@arm.linux.org.uk>, Tejun Heo <tj@kernel.org>
Subject: [BUG]: when printk too more through serial, cpu up is failed.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
     When the kernel printk too many log, the cpu is failed to come online.
The problem is this:
For example, cpu0 bring up cpu1:

       a. cpu0 call cpu_up:
          cpu_up()
          ->_cpu_up()
             ->__cpu_notify(CPU_UP_PREPARE)
             ->__cpu_up()
                ->boot_secondary()
#       ->wait_for_completion_timeout(&cpu_running, msecs_to_jiffires(1000))
          -> if (!cpu_online(cpu)) {
                   pr_crit("CPU%u: failed to come online\n", cpu);
                   ret = -EIO;
               }
          ->cpu_notify(CPU_ONLINE)

       b. cpu1 enter kernel:
       secondary_start_kernel()
@   ->printk("CPU%u: Booted secondary processor\n", cpu)
*   ->calibrate_delay()
       ->set_cpu_online()
       ->complete(cpu_running)
         ->cpumask_set_cpu()

    While cpu0 run to mark #,  which wait that cpu1 complete 
cpu_running, and set online.
Generally, cpu0 can get it. But if the __log_buf is too large or other 
threads write
it unceasing, then cpu1 come to mark @ or * in this moment. Cpu1 is busy 
outputing
buffer, which cost time more than 1s, and cpu1 have not join in sched, 
so cpu0 wait it timeout.
    By reading printk.c, I found that can_use_console() always return 
true, which be called by
console_trylock_for_printk(). Because, have_callable_console() return 
ture always, if the console
driver set CON_ANYTIME flag. I think that cpu should not output the 
__log_buf in coming online,
even though have_callable_console() is true.

/*
  * Can we actually use the console at this time on this cpu?
  *
  * Console drivers may assume that per-cpu resources have
  * been allocated. So unless they're explicitly marked as
  * being able to cope (CON_ANYTIME) don't call them until
  * this CPU is officially up.
  */
static inline int can_use_console(unsigned int cpu)
{
     return cpu_online(cpu) || have_callable_console();
}

In can_use_console, why not is &&, but ||?

Kernel Version: 3.3.0
Arch: arm

This problem trace:
[ 1722.150286] CPU1: Booted secondary processor
[ 1722.154613] Calibrating delay loop (skipped) already calibrated this CPU
      .........
[ 1725.134687] CPU1: failed to come online
      .........
[ 1728.055547] ------------[ cut here ]------------
[ 1728.060219] kernel BUG at kernel/workqueue.c:3332!
[ 1728.065010] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[ 1728.070503] Modules linked in: cdc_ether rtl8150 mcs7830 qf9700 asix 
usbnet mma7660 sw_keyboard gt9xx g2d_33 sunxi_csi1 gc2035 ov5640 
videobuf_dma_contig videobuf_core dc_sunxi(O) pvrsrvkm(O) nand(O)
[ 1728.088474] CPU: 0    Tainted: G           O  (3.3.0 #9)
[ 1728.093796] PC is at trustee_thread+0x24/0x514
[ 1728.098239] LR is at trustee_thread+0x1c/0x514
[ 1728.102683] pc : [<c059c750>]    lr : [<c059c748>]    psr: 20000013
[ 1728.102690] sp : ec05bf68  ip : ec05bf68  fp : ec05bfb4
[ 1728.114161] r10: 00000000  r9 : 00000000  r8 : 00000000
[ 1728.119383] r7 : 00000013  r6 : c059c72c  r5 : 00000001  r4 : e5e162c0
[ 1728.125906] r3 : 00000000  r2 : 00000001  r1 : ec05bf40  r0 : 00000000
[ 1728.132432] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  
Segment kernel
[ 1728.139736] Control: 10c53c7d  Table: 6e35c06a  DAC: 00000015
      .........
[ 1728.709566] Process workqueue_trust (pid: 22196, stack limit = 
0xec05a2f8)
[ 1728.716436] Stack: (0xec05bf68 to 0xec05c000)
[ 1728.720796] bf60:                   c05a6c3c c007f98c c07ed100 
c07ed100 c05a788c ed089de0
[ 1728.728973] bf80: e5e162c0 c059c72c 00000013 ed089de0 e5e162c0 
c059c72c 00000013 00000000
[ 1728.737148] bfa0: 00000000 00000000 ec05bff4 ec05bfb8 c00732fc 
c059c738 00000000 00000000
[ 1728.745324] bfc0: e5e162c0 00000000 00000000 00000000 ec05bfd0 
ec05bfd0 00000000 ed089de0
[ 1728.753501] bfe0: c0073260 c0057d50 00000000 ec05bff8 c0057d50 
c007326c 00d851b1 da280100
[ 1728.761669] Backtrace:
[ 1728.764140] [<c059c72c>] (trustee_thread+0x0/0x514) from [<c00732fc>] 
(kthread+0x9c/0xa8)
[ 1728.772321] [<c0073260>] (kthread+0x0/0xa8) from [<c0057d50>] 
(do_exit+0x0/0x764)
[ 1728.779797]  r6:c0057d50 r5:c0073260 r4:ed089de0
[ 1728.784457] Code: e1a04000 ebf36dbd e1550000 0a000000 (e7f001f2)
[ 1729.130494] ---[ end trace 3deba094f67f9e11 ]---
[ 1729.140018] Kernel panic - not syncing: Fatal exception
[ 1730.355119] SMP: failed to stop secondary CPUs
