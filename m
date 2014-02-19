Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbaBSGVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:21:46 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:41822 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaBSGVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:21:42 -0500
MIME-Version: 1.0
In-Reply-To: <1392729681-21022-1-git-send-email-iivanov@mm-sol.com>
References: <1392729681-21022-1-git-send-email-iivanov@mm-sol.com>
Date: Tue, 18 Feb 2014 22:21:41 -0800
Message-ID: <CA+bK7J7D1bgehNMaMtWWggZ5KDBfZ8LK0bEYUARmc8OD3wa89Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] usb: chipidea: msm: Clean and fix glue layer driver
From: Tim Bird <tbird20d@gmail.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Peter Chen <Peter.Chen@freescale.com>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Brown <davidb@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan,

I'm having tremendous problems getting this driver to initialize.  For
some reason, I can't get the driver to actually transition the
hardware into peripheral mode.  At first I was getting a lot of probe
deferrals, based on not finding the regulators early enough in the
boot, and I thought it was an issue with the gadget drivers loading
before the driver could complete its setup.  However, I switched
everything to loading via modules, and now have less probe deferrals,
but I still can't get the driver to activate.  I see zero interrupts.
In particular the routine hw_device_state (which turns on interrupts
in the controller) is never called, because I can't get
msm_otg_start_peripheral to actually kick the hardware.

I've sprinkled the code in drivers/usb/chipidea and
drivers/usb/phy/phy-msm-usb.c liberally with printks and WARNs to help
me see what's going on, but I'm having a hard time tracing it down.
I'm pretty sure I've got the DTS correct, but my USB config might not
match yours.  (Would you mind sharing your config?).

I tried configuring the qcom,otg-control for user controlled mode
setting (via debugfs), and even with doing "echo "peripheral"
>/sys/kernel/debug/msm_otg/mode, it just wouldn't start the hardware
(call hw_device_state(...1)).

Any ideas you can provide would be welcome (e.g. for things to try,
look at, etc.)

My kernel is based on an internal Sony 3.13-rc6 kernel with clock and
regulator patches applied, as well as your phy-msm-usb.c patches from
November and your chipidea patches from yesterday.

Thanks,
 -- Tim


In the printk dump below,
  UBTO=udc_bind_to_driver
  CIS=ci_udc_start
  MOSP=msm_otg_set_peripheral
  MOSW=msm_otg_sm_work

[10] platform_init()
[10] target_init()
[10] Display Init: Start
[10] display_init(),target_id=10.
[30] Config MIPI_VIDEO_PANEL.
[30] Turn on MIPI_VIDEO_PANEL.
[50] Video lane tested successfully
[50] Display Init: Done
[70] partition misc doesn't exist
[80] error in emmc_recovery_init
[80] No 'misc' partition found
[80] Error reading MISC partition
[80] failed to get ffbm cookie[90] use_signed_kernel=1, is_unlocked=0,
is_tampered=1.
[90] Loading boot image (7829504): start
[550] Loading boot image (7829504): done
[550] Found Appeneded Flattened Device tree
[550] cmdline: console=ttyMSM,115200,n8 androidboot.hardware=qcom
user_debug=31 maxcpus=2 msm_rtb.filter=0x37 ehci-hcd.park=3 earl
yprintk debug androidboot.emmc=true androidboot.serialno=40081a14
androidboot.baseband=apq
[570] Updating device tree: start
[570] Updating device tree: done
[580] booting linux @ 0x8000, ramdisk @ 0x2000000 (4234892),
tags/device tree @ 0x1e00000
[580] Turn off MIPI_VIDEO_PANEL.
[580] Continuous splash enabled, keeping panel alive.
Uncompressing Linux... done, booting the kernel.
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] TRB: version 88888
[    0.000000] Linux version 3.13.0-rc6-00147-g00bb56a-dirty
(10102229@ussvlx8980) (gcc version 4.6.x-google 20120106 (prerelease)
 (GCC) ) #40 SMP PREEMPT Tue Feb 18 19:24:12 PST 2014
[    0.000000] CPU: ARMv7 Processor [512f06f0] revision 0 (ARMv7), cr=10c5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction cache
[    0.000000] Machine model: Qualcomm APQ8074 Dragonboard
[    0.000000] bootconsole [earlycon0] enabled
[    0.000000] Memory policy: Data cache writealloc
[    0.000000] On node 0 totalpages: 524288
[    0.000000] free_area_init_node: node 0, pgdat c0908d80,
node_mem_map c0980000
[    0.000000]   Normal zone: 1520 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 194560 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2576 pages used for memmap
[    0.000000]   HighMem zone: 329728 pages, LIFO batch:31
[    0.000000] PERCPU: Embedded 8 pages/cpu @c1993000 s12224 r8192 d12352 u32768
[    0.000000] pcpu-alloc: s12224 r8192 d12352 u32768 alloc=8*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 522768
[    0.000000] Kernel command line: console=ttyMSM,115200,n8
androidboot.hardware=qcom user_debug=31 maxcpus=2 msm_rtb.filter=0x37
 ehci-hcd.park=3 earlyprintk debug androidboot.emmc=true
androidboot.serialno=40081a14 androidboot.baseband=apq
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Memory: 2067932K/2097152K available (4734K kernel code,
262K rwdata, 1912K rodata, 287K init, 446K bss, 29220K rese
rved, 1318912K highmem)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xf0000000 - 0xff000000   ( 240 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xef800000   ( 760 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
[    0.000000]       .text : 0xc0208000 - 0xc0885ddc   (6648 kB)
[    0.000000]       .init : 0xc0886000 - 0xc08cdfc0   ( 288 kB)
[    0.000000]       .data : 0xc08ce000 - 0xc090fa2c   ( 263 kB)
[    0.000000]        .bss : 0xc090fa2c - 0xc097f41c   ( 447 kB)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] Architected cp15 and mmio timer(s) running at 19.20MHz
(virt/virt).
[    0.000000] sched_clock: 56 bits at 19MHz, resolution 52ns, wraps
every 3579139424256ns
[    0.000000] Switching to timer-based delay loop
[    0.000000] Console: colour dummy device 80x30
[    0.009136] Calibrating delay loop (skipped), value calculated
using timer frequency.. 38.40 BogoMIPS (lpj=192000)
[    0.019534] pid_max: default: 32768 minimum: 301
[    0.024381] Mount-cache hash table entries: 512
[    0.029531] CPU: Testing write buffer coherency: ok
[    0.033968] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.039532] Setting up static identity map for 0x67ea90 - 0x67eae8
[    0.119863] CPU1: failed to boot: -38
[    0.139882] CPU2: failed to boot: -38
[    0.159917] CPU3: failed to boot: -38
[    0.162642] Brought up 1 CPUs
[    0.165659] SMP: Total of 1 processors activated.
[    0.170461] CPU: All CPU(s) started in SVC mode.
[    0.184193] VFP support v0.3: implementor 51 architecture 0 part 6f
variant 2 rev 0
[    0.191979] pinctrl core: initialized pinctrl subsystem
[    0.196492] regulator-dummy: no parameters
[    0.200452] TRB: in really_probe, ret=0
[    0.204515] NET: Registered protocol family 16
[    0.209063] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.219081] TRB: in really_probe, ret=0
[    0.222545] hw-breakpoint: found 5 (+1 reserved) breakpoint and 4
watchpoint registers.
[    0.230052] hw-breakpoint: maximum watchpoint size is 8 bytes.
[    0.240106] bio: create slab <bio-0> at 0
[    0.243778] SCSI subsystem initialized
[    0.247152] usbcore: registered new interface driver usbfs
[    0.252612] usbcore: registered new interface driver hub
[    0.258004] usbcore: registered new device driver usb
[    0.263289] Advanced Linux Sound Architecture Driver Initialized.
[    0.270010] Switched to clocksource arch_sys_counter
[    0.274304] cfg80211: Calling CRDA to update world regulatory domain
[    0.309937] NET: Registered protocol family 2
[    0.313777] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    0.320513] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    0.327045] TCP: Hash tables configured (established 8192 bind 8192)
[    0.333444] TCP: reno registered
[    0.336696] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.342714] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.349283] NET: Registered protocol family 1
[    0.353842] RPC: Registered named UNIX socket transport module.
[    0.359519] RPC: Registered udp transport module.
[    0.364333] RPC: Registered tcp transport module.
[    0.369068] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.375803] Trying to unpack rootfs image as initramfs...
[    0.638795] Freeing initrd memory: 4132K (c2000000 - c2409000)
[    0.644038] using sfpb hardware mutex registers (auto)
[    0.649016] smem_of_init: initialized successfully
[    0.654077] parse_smd_devicetree: enable_irq_wake() failed on 57
[    0.659856] parse_smsm_devicetree: enable_irq_wake() failed on 58
[    0.666077] parse_smd_devicetree: enable_irq_wake() failed on 188
[    0.672205] parse_smsm_devicetree: enable_irq_wake() failed on 189
[    0.678432] parse_smd_devicetree: enable_irq_wake() failed on 174
[    0.684613] parse_smsm_devicetree: enable_irq_wake() failed on 176
[    0.690865] parse_smd_devicetree: enable_irq_wake() failed on 200
[    0.696972] SMD successfully initialized
[    0.701124] TRB: in really_probe, ret=0
[    0.786129] bounce pool size: 64 pages
[    0.794349] NFS: Registering the id_resolver key type
[    0.798479] Key type id_resolver registered
[    0.802739] Key type id_legacy registered
[    0.807215] fuse init (API version 7.22)
[    0.811077] msgmni has been set to 1471
[    0.816107] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[    0.822620] io scheduler noop registered
[    0.826538] io scheduler deadline registered
[    0.831027] io scheduler cfq registered (default)
[    0.835887] msm_serial:
detecte���~�`���怞f���x���~��f��~������xx`���怞f��f�x�~x��������fxf���~`ff�f��~�
f������x����������f������f��fx�f�ff~`��x������r²������msm_serial:
console setup on port #0
[    0.867420] console [ttyMSM0] enabled
[    0.867420] console [ttyMSM0] enabled
[    0.874815] bootconsole [earlycon0] disabled
[    0.874815] bootconsole [earlycon0] disabled
[    0.883530] TRB: in really_probe, ret=0
[    0.883579] msm_serial: driver initialized
[    0.891693] brd: module loaded
[    0.894145] loop: module loaded
[    0.894631] SCSI Media Changer driver v0.25
[    0.897697] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels,
max=256) (6 bit encapsulation enabled).
[    0.901819] CSLIP: code copyright 1989 Regents of the University of
California.
[    0.911274] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.918459] ehci_hcd: block sizes: qh 80 qtd 96 itd 160 sitd 96
[    0.925083] ehci-platform: EHCI generic platform driver
[    0.931057] mousedev: PS/2 mouse device common for all mice
[    0.936125] i2c /dev entries driver
[    0.941730] TRB: in really_probe, ret=0
[    0.945275] usbcore: registered new interface driver usbhid
[    0.948923] usbhid: USB HID core driver
[    0.954802] TRB: in really_probe, ret=0
[    0.958479] oprofile: no performance counters
[    0.962228] oprofile: using timer interrupt.
[    0.966744] TCP: cubic registered
[    0.970994] NET: Registered protocol family 17
[    0.974277] Key type dns_resolver registered
[    0.978649] Registering SWP/SWPB emulation handler
[    0.983713] 8841_s1: 675 <--> 1050 mV at 0 mV normal idle
[    0.987620] TRB: in really_probe, ret=0
[    0.993342] 8841_s1_ao: 675 <--> 1050 mV at 0 mV normal idle
[    0.996805] TRB: in really_probe, ret=0
[    1.002873] 8841_s1_so: 675 <--> 1050 mV at 675 mV normal idle
[    1.006355] TRB: in really_probe, ret=0
[    1.012231] TRB: in really_probe, ret=0
[    1.016323] 8841_s2: 500 <--> 1050 mV at 0 mV normal idle
[    1.019895] TRB: in really_probe, ret=0
[    1.025627] 8841_s2_corner: 0 <--> 0 mV at 0 mV normal idle
[    1.029183] TRB: in really_probe, ret=0
[    1.035252] 8841_s2_corner_ao: 0 <--> 0 mV at 0 mV normal idle
[    1.038656] TRB: in really_probe, ret=0
[    1.044715] 8841_s2_floor_corner: 0 <--> 0 mV at 0 mV normal idle
[    1.048373] TRB: in really_probe, ret=0
[    1.054592] TRB: in really_probe, ret=0
[    1.058597] 8841_s3: 1050 mV normal idle
[    1.062188] TRB: in really_probe, ret=0
[    1.066292] TRB: in really_probe, ret=0
[    1.070249] 8841_s4: 815 <--> 900 mV at 0 mV normal idle
[    1.073807] TRB: in really_probe, ret=0
[    1.079501] 8841_s4_corner: 0 <--> 0 mV at 0 mV normal idle
[    1.083026] TRB: in really_probe, ret=0
[    1.089056] 8841_s4_floor_corner: 0 <--> 0 mV at 0 mV normal idle
[    1.092488] TRB: in really_probe, ret=0
[    1.098671] TRB: in really_probe, ret=0
[    1.102721] 8941_s1: 1300 mV normal idle
[    1.106276] TRB: in really_probe, ret=0
[    1.110409] TRB: in really_probe, ret=0
[    1.114333] 8941_s2: 2150 mV normal idle
[    1.117899] TRB: in really_probe, ret=0
[    1.122041] TRB: in really_probe, ret=0
[    1.125965] 8941_s3: 1800 mV normal idle
[    1.129531] TRB: in really_probe, ret=0
[    1.133673] TRB: in really_probe, ret=0
[    1.137588] 8941_l1: 1225 mV normal idle
[    1.141192] TRB: in really_probe, ret=0
[    1.145285] TRB: in really_probe, ret=0
[    1.149226] 8941_l2: 1200 mV normal idle
[    1.152815] TRB: in really_probe, ret=0
[    1.156917] TRB: in really_probe, ret=0
[    1.160884] 8941_l3: 1200 mV normal idle
[    1.164426] TRB: in really_probe, ret=0
[    1.168548] TRB: in really_probe, ret=0
[    1.172515] 8941_l4: 1225 mV normal idle
[    1.176070] TRB: in really_probe, ret=0
[    1.180202] TRB: in really_probe, ret=0
[    1.184129] 8941_l5: 1800 mV normal idle
[    1.187691] TRB: in really_probe, ret=0
[    1.191833] TRB: in really_probe, ret=0
[    1.195758] 8941_l6: 1800 mV normal idle
[    1.199322] TRB: in really_probe, ret=0
[    1.203464] TRB: in really_probe, ret=0
[    1.207404] 8941_l7: 1800 mV normal idle
[    1.210972] TRB: in really_probe, ret=0
[    1.215077] TRB: in really_probe, ret=0
[    1.218824] TRB: in really_probe, ret=0
[    1.222858] 8941_l9: 1800 <--> 2950 mV at 2950 mV normal idle
[    1.226410] TRB: in really_probe, ret=0
[    1.232283] TRB: in really_probe, ret=0
[    1.236297] 8941_l10: 1800 <--> 2950 mV at 2950 mV normal idle
[    1.239861] TRB: in really_probe, ret=0
[    1.245738] TRB: in really_probe, ret=0
[    1.249827] 8941_l11: 1300 mV normal idle
[    1.253429] TRB: in really_probe, ret=0
[    1.257524] TRB: in really_probe, ret=0
[    1.261566] 8941_l12: 1800 mV normal idle
[    1.265119] TRB: in really_probe, ret=0
[    1.269432] 8941_l12_ao: 1800 mV normal idle
[    1.273039] TRB: in really_probe, ret=0
[    1.277489] TRB: in really_probe, ret=0
[    1.281449] 8941_l13: 1800 <--> 2950 mV at 2950 mV normal idle
[    1.284999] TRB: in really_probe, ret=0
[    1.290877] TRB: in really_probe, ret=0
[    1.294971] 8941_l14: 1800 mV normal idle
[    1.298542] TRB: in really_probe, ret=0
[    1.302682] TRB: in really_probe, ret=0
[    1.306687] 8941_l15: 2050 mV normal idle
[    1.310286] TRB: in really_probe, ret=0
[    1.314383] TRB: in really_probe, ret=0
[    1.318410] 8941_l16: 2700 mV normal idle
[    1.322002] TRB: in really_probe, ret=0
[    1.326100] TRB: in really_probe, ret=0
[    1.330150] 8941_l17: 2700 mV normal idle
[    1.333695] TRB: in really_probe, ret=0
[    1.337819] TRB: in really_probe, ret=0
[    1.341870] 8941_l18: 2850 mV normal idle
[    1.345415] TRB: in really_probe, ret=0
[    1.349539] TRB: in really_probe, ret=0
[    1.353590] 8941_l19: 3300 mV normal idle
[    1.357134] TRB: in really_probe, ret=0
[    1.361276] TRB: in really_probe, ret=0
[    1.365283] 8941_l20: 2950 mV normal idle
[    1.368852] TRB: in really_probe, ret=0
[    1.372996] TRB: in really_probe, ret=0
[    1.377007] 8941_l21: 2950 mV normal idle
[    1.380600] TRB: in really_probe, ret=0
[    1.384694] TRB: in really_probe, ret=0
[    1.388724] 8941_l22: 3000 mV normal idle
[    1.392312] TRB: in really_probe, ret=0
[    1.396413] TRB: in really_probe, ret=0
[    1.400467] 8941_l23: 2800 mV normal idle
[    1.404014] TRB: in really_probe, ret=0
[    1.408132] TRB: in really_probe, ret=0
[    1.412188] 8941_l24: 3075 mV normal idle
[    1.415728] TRB: in really_probe, ret=0
[    1.419850] TRB: in really_probe, ret=0
[    1.423897] 8941_lvs1: no parameters
[    1.427436] TRB: in really_probe, ret=0
[    1.431242] TRB: in really_probe, ret=0
[    1.435067] 8941_lvs2: no parameters
[    1.438634] TRB: in really_probe, ret=0
[    1.442439] TRB: in really_probe, ret=0
[    1.446267] 8941_lvs3: no parameters
[    1.449843] TRB: in really_probe, ret=0
[    1.453640] TRB: in really_probe, ret=0
[    1.457178] msm_rpm_dev_probe(): RPM probe completed successfully
[    1.461009] TRB: in really_probe, ret=0
[    1.467843] /home/CORPUSERS/10102229/work/dragonboard/APQ8074_M8974AAAAANLYA31050138_JB_V11/kernel-14-test-usb/drivers/rtc/hcto
sys.c: unable to open rtc device (rtc0)
[    1.471215] ALSA device list:
[    1.485853]   No soundcards found.
[    1.489327] Freeing unused kernel memory: 284K (c0886000 - c08cd000)
mkdir: can't create directory '/dev': File exists
sh: can't access tty; job control turned off
/ # cd lib
/lib # cd modules
/lib/modules # ls
ansi_cprng.ko        libcomposite.ko      udc-core.ko
ci_hdrc.ko           loadem.sh            usb_f_ecm.ko
ci_hdrc_imx.ko       phy-msm-usb.ko       usb_f_ecm_subset.ko
ci_hdrc_msm.ko       u_ether.ko           usb_f_rndis.ko
g_ether.ko           u_rndis.ko           usbmisc_imx.ko
/lib/modules # cat loadem.sh
#!/bin/sh

#insmod usb_common.ko
insmod phy-msm-usb.ko
insmod udc-core.ko
insmod ci_hdrc.ko
insmod ci_hdrc_msm.ko
insmod libcomposite.ko
insmod u_ether.ko
insmod u_rndis.ko
insmod usb_f_rndis.ko
insmod usb_f_ecm.ko
insmod usb_f_subset.ko
insmod ansi_cprng.ko
insmod g_ether.ko
/lib/modules # ./loadem.sh
[   22.390454] ------------[ cut here ]------------
[   22.390494] WARNING: CPU: 0 PID: 88 at
/home/CORPUSERS/10102229/work/dragonboard/APQ8074_M8974AAAAANLYA31050138_JB_V11/kernel-1
4-test-usb/drivers/usb/phy/phy-msm-usb.c:1581 msm_otg_probe+0x24/0x904
[phy_msm_usb]()
[   22.394146] TRB: in msm_otg_probe
[   22.426106] Modules linked in: phy_msm_usb(+)
[   22.429337] CPU: 0 PID: 88 Comm: insmod Not tainted
3.13.0-rc6-00147-g00bb56a-dirty #40
[   22.429629] [<c0214144>] (unwind_backtrace+0x0/0xf8) from
[<c0211ba8>] (show_stack+0x10/0x14)
[   22.437471] [<c0211ba8>] (show_stack+0x10/0x14) from [<c0674bec>]
(dump_stack+0x64/0xb4)
[   22.446132] [<c0674bec>] (dump_stack+0x64/0xb4) from [<c022afd8>]
(warn_slowpath_common+0x68/0x88)
[   22.454287] [<c022afd8>] (warn_slowpath_common+0x68/0x88) from
[<c022b08c>] (warn_slowpath_fmt+0x30/0x40)
[   22.463060] [<c022b08c>] (warn_slowpath_fmt+0x30/0x40) from
[<bf005024>] (msm_otg_probe+0x24/0x904 [phy_msm_usb])
[   22.472703] [<bf005024>] (msm_otg_probe+0x24/0x904 [phy_msm_usb])
from [<c04e2968>] (platform_drv_probe+0x18/0x48)
[   22.482936] [<c04e2968>] (platform_drv_probe+0x18/0x48) from
[<c04e10b4>] (driver_probe_device+0x18c/0x23c)
[   22.493176] [<c04e10b4>] (driver_probe_device+0x18c/0x23c) from
[<c04e11f0>] (__driver_attach+0x8c/0x90)
[   22.502812] [<c04e11f0>] (__driver_attach+0x8c/0x90) from
[<c04df910>] (bus_for_each_dev+0x60/0x94)
[   22.512531] [<c04df910>] (bus_for_each_dev+0x60/0x94) from
[<c04e0800>] (bus_add_driver+0xdc/0x1d0)
[   22.521300] [<c04e0800>] (bus_add_driver+0xdc/0x1d0) from
[<c04e180c>] (driver_register+0x78/0xf4)
[   22.530328] [<c04e180c>] (driver_register+0x78/0xf4) from
[<c0208860>] (do_one_initcall+0x110/0x174)
[   22.539340] [<c0208860>] (do_one_initcall+0x110/0x174) from
[<c0285740>] (load_module+0x185c/0x1c6c)
[   22.548646] [<c0285740>] (load_module+0x185c/0x1c6c) from
[<c0285c40>] (SyS_init_module+0xf0/0x100)
[   22.557759] [<c0285c40>] (SyS_init_module+0xf0/0x100) from
[<c020e3c0>] (ret_fast_syscall+0x0/0x30)
[   22.566534] ---[ end trace 9c437930835a2046 ]---
[   22.575629] TRB: in msm_otg_read_dt
[   22.580403] TRB: in msm_otg_read_dt, mode=2
[   22.583635] msm_otg f9a55000.usb: OTG regs = f009e000
[   22.588136] TRB: voltage initialized status=0
[   22.593864] TRB: in msm_usb_reset
[   22.597306] TRB: msm_otg_link_clk_reset, assert=1
[   22.601873] TRB: msm_otg_link_clk_reset, assert=0
[   22.605297] TRB: in msm_otg_reset
[   22.710108] TRB: in msm_otg_probe, mode=2, otg_control=1
[   22.710127] TRB: in really_probe, ret=0
[   22.790271] ------------[ cut here ]------------
[   22.790306] WARNING: CPU: 0 PID: 97 at
/home/CORPUSERS/10102229/work/dragonboard/APQ8074_M8974AAAAANLYA31050138_JB_V11/kernel-1
4-test-usb/drivers/usb/chipidea/ci_hdrc_msm.c:65
ci_hdrc_msm_probe+0x1c/0xc0 [ci_hdrc_msm]()
[   22.793963] TRB: in ci_hdrc_msm_probe()
[   22.819817] Modules linked in: ci_hdrc_msm(+) ci_hdrc udc_core phy_msm_usb
[   22.825309] CPU: 0 PID: 97 Comm: insmod Tainted: G        W
3.13.0-rc6-00147-g00bb56a-dirty #40
[   22.825686] [<c0214144>] (unwind_backtrace+0x0/0xf8) from
[<c0211ba8>] (show_stack+0x10/0x14)
[   22.834563] [<c0211ba8>] (show_stack+0x10/0x14) from [<c0674bec>]
(dump_stack+0x64/0xb4)
[   22.843144] [<c0674bec>] (dump_stack+0x64/0xb4) from [<c022afd8>]
(warn_slowpath_common+0x68/0x88)
[   22.851298] [<c022afd8>] (warn_slowpath_common+0x68/0x88) from
[<c022b08c>] (warn_slowpath_fmt+0x30/0x40)
[   22.860068] [<c022b08c>] (warn_slowpath_fmt+0x30/0x40) from
[<bf01c114>] (ci_hdrc_msm_probe+0x1c/0xc0 [ci_hdrc_msm])
[   22.869693] [<bf01c114>] (ci_hdrc_msm_probe+0x1c/0xc0
[ci_hdrc_msm]) from [<c04e2968>] (platform_drv_probe+0x18/0x48)
[   22.880298] [<c04e2968>] (platform_drv_probe+0x18/0x48) from
[<c04e10b4>] (driver_probe_device+0x18c/0x23c)
[   22.890796] [<c04e10b4>] (driver_probe_device+0x18c/0x23c) from
[<c04e11f0>] (__driver_attach+0x8c/0x90)
[   22.900343] [<c04e11f0>] (__driver_attach+0x8c/0x90) from
[<c04df910>] (bus_for_each_dev+0x60/0x94)
[   22.910064] [<c04df910>] (bus_for_each_dev+0x60/0x94) from
[<c04e0800>] (bus_add_driver+0xdc/0x1d0)
[   22.918814] [<c04e0800>] (bus_add_driver+0xdc/0x1d0) from
[<c04e180c>] (driver_register+0x78/0xf4)
[   22.927860] [<c04e180c>] (driver_register+0x78/0xf4) from
[<c0208860>] (do_one_initcall+0x110/0x174)
[   22.936892] [<c0208860>] (do_one_initcall+0x110/0x174) from
[<c0285740>] (load_module+0x185c/0x1c6c)
[   22.946178] [<c0285740>] (load_module+0x185c/0x1c6c) from
[<c0285c40>] (SyS_init_module+0xf0/0x100)
[   22.955291] [<c0285c40>] (SyS_init_module+0xf0/0x100) from
[<c020e3c0>] (ret_fast_syscall+0x0/0x30)
[   22.964063] ---[ end trace 9c437930835a2047 ]---
[   22.973172] TRB: done with WARN
[   22.977915] msm_hsusb f9a55000.gadget: ci_hdrc_msm_probe fa-la-la-la-la
[   22.980830] TRB: in ci_get_platdata
[   22.987375] TRB: in ci_get_platdata, dr_mode=2
[   22.991202] TRB: in hw_alloc_regmap, is_lpg=0
[   22.995364] TRB: ci hw_read: reg=f0192108, mask=00020000, val=00000000
[   22.999790] TRB: in hw_alloc_regmap, is_lpg=0
[   23.018442] TRB: ci hw_read: reg=f0192124, mask=0000001f, val=00000010
[   23.018465] TRB: ci hw_read: reg=f0192184, mask=00800000, val=00000000
[   23.023883] TRB: ci hw_write: reg=f0192148, mask=ffffffff, data=00000000
[   23.030391] TRB: ci hw_write: reg=f0192144, mask=ffffffff, data=ffffffff
[   23.037225] ci_hdrc ci_hdrc.0: ChipIdea HDRC found, lpm: 0; cap:
f0192100 op: f0192140
[   23.043932] ------------[ cut here ]------------
[   23.051666] WARNING: CPU: 0 PID: 97 at
/home/CORPUSERS/10102229/work/dragonboard/APQ8074_M8974AAAAANLYA31050138_JB_V11/kernel-1
4-test-usb/drivers/usb/phy/phy-msm-usb.c:461 msm_phy_init+0x1c/0x16c
[phy_msm_usb]()
[   23.056417] TRB: in msm_phy_init
[   23.074915] Modules linked in: ci_hdrc_msm(+) ci_hdrc udc_core phy_msm_usb
[   23.084785] CPU: 0 PID: 97 Comm: insmod Tainted: G        W
3.13.0-rc6-00147-g00bb56a-dirty #40
[   23.085153] [<c0214144>] (unwind_backtrace+0x0/0xf8) from
[<c0211ba8>] (show_stack+0x10/0x14)
[   23.094032] [<c0211ba8>] (show_stack+0x10/0x14) from [<c0674bec>]
(dump_stack+0x64/0xb4)
[   23.102624] [<c0674bec>] (dump_stack+0x64/0xb4) from [<c022afd8>]
(warn_slowpath_common+0x68/0x88)
[   23.110780] [<c022afd8>] (warn_slowpath_common+0x68/0x88) from
[<c022b08c>] (warn_slowpath_fmt+0x30/0x40)
[   23.119527] [<c022b08c>] (warn_slowpath_fmt+0x30/0x40) from
[<bf001af4>] (msm_phy_init+0x1c/0x16c [phy_msm_usb])
[   23.129195] [<bf001af4>] (msm_phy_init+0x1c/0x16c [phy_msm_usb])
from [<bf00f4e8>] (ci_hdrc_probe+0x218/0x7b4 [ci_hdrc])
[   23.139438] [<bf00f4e8>] (ci_hdrc_probe+0x218/0x7b4 [ci_hdrc]) from
[<c04e2968>] (platform_drv_probe+0x18/0x48)
[   23.150282] [<c04e2968>] (platform_drv_probe+0x18/0x48) from
[<c04e10b4>] (driver_probe_device+0x18c/0x23c)
[   23.160089] [<c04e10b4>] (driver_probe_device+0x18c/0x23c) from
[<c04df884>] (bus_for_each_drv+0x5c/0x88)
[   23.169785] [<c04df884>] (bus_for_each_drv+0x5c/0x88) from
[<c04e0ef4>] (device_attach+0x80/0x98)
[   23.179532] [<c04e0ef4>] (device_attach+0x80/0x98) from
[<c04e05d8>] (bus_probe_device+0x84/0xa8)
[   23.188386] [<c04e05d8>] (bus_probe_device+0x84/0xa8) from
[<c04debec>] (device_add+0x3a8/0x4d0)
[   23.197241] [<c04debec>] (device_add+0x3a8/0x4d0) from [<c04e25ac>]
(platform_device_add+0x100/0x22c)
[   23.206101] [<c04e25ac>] (platform_device_add+0x100/0x22c) from
[<bf00fdac>] (ci_hdrc_add_device+0x190/0x1dc [ci_hdrc])
[   23.215219] [<bf00fdac>] (ci_hdrc_add_device+0x190/0x1dc [ci_hdrc])
from [<bf01c168>] (ci_hdrc_msm_probe+0x70/0xc0 [ci_hdrc_msm
])
[   23.225806] [<bf01c168>] (ci_hdrc_msm_probe+0x70/0xc0
[ci_hdrc_msm]) from [<c04e2968>] (platform_drv_probe+0x18/0x48)
[   23.237608] [<c04e2968>] (platform_drv_probe+0x18/0x48) from
[<c04e10b4>] (driver_probe_device+0x18c/0x23c)
[   23.248197] [<c04e10b4>] (driver_probe_device+0x18c/0x23c) from
[<c04e11f0>] (__driver_attach+0x8c/0x90)
[   23.257745] [<c04e11f0>] (__driver_attach+0x8c/0x90) from
[<c04df910>] (bus_for_each_dev+0x60/0x94)
[   23.267465] [<c04df910>] (bus_for_each_dev+0x60/0x94) from
[<c04e0800>] (bus_add_driver+0xdc/0x1d0)
[   23.276234] [<c04e0800>] (bus_add_driver+0xdc/0x1d0) from
[<c04e180c>] (driver_register+0x78/0xf4)
[   23.285260] [<c04e180c>] (driver_register+0x78/0xf4) from
[<c0208860>] (do_one_initcall+0x110/0x174)
[   23.294288] [<c0208860>] (do_one_initcall+0x110/0x174) from
[<c0285740>] (load_module+0x185c/0x1c6c)
[   23.303577] [<c0285740>] (load_module+0x185c/0x1c6c) from
[<c0285c40>] (SyS_init_module+0xf0/0x100)
[   23.312694] [<c0285c40>] (SyS_init_module+0xf0/0x100) from
[<c020e3c0>] (ret_fast_syscall+0x0/0x30)
[   23.321464] ---[ end trace 9c437930835a2048 ]---
[   23.330483] TRB: ulpi_init() 1
[   23.335303] TRB: ulpi_init() 2
[   23.338168] TRB: ulpi_init() 3
[   23.341355] TRB: ulpi: write 0x63 to 0x81
[   23.344246] TRB: ulpi_init() 4
[   23.348325] TRB: ulpi_write 00000063 to reg 00000081
[   23.351322] TRB: ulpi_init() 5
[   23.356398] TRB: ulpi_init() 6
[   23.359261] TRB: ulpi_init() 7 - done
[   23.362338] TRB: did I see ulpi_init???
[   23.366075] TRB: ulpi_write 00000004 to reg 0000000d
[   23.369683] TRB: ulpi_write 00000004 to reg 00000010
[   23.374914] TRB: ci hw_read: reg=f0192124, mask=00000180, val=00000180
[   23.379843] ci_hdrc ci_hdrc.0: It is OTG capable controller
[   23.386194] TRB: ci hw_write: reg=f01921a4, mask=7f000000, data=00000000
[   23.391665] TRB: ci hw_write: reg=f01921a4, mask=007f0000, data=007f0000
[   23.398594] TRB: ci hw_read: reg=f0192124, mask=00000080, val=00000080
[   23.405352] TRB: in usb_add_gadget_udc_release()
[   23.411626] ------------[ cut here ]------------
[   23.416398] WARNING: CPU: 0 PID: 97 at
/home/CORPUSERS/10102229/work/dragonboard/APQ8074_M8974AAAAANLYA31050138_JB_V11/kernel-1
4-test-usb/drivers/usb/gadget/udc-core.c:206
usb_add_gadget_udc_release+0x28/0x1e0 [udc_core]()
[   23.421020] TRB: in usb_add_gadget_udc_release()
[   23.440531] Modules linked in: ci_hdrc_msm(+) ci_hdrc udc_core phy_msm_usb
[   23.451712] CPU: 0 PID: 97 Comm: insmod Tainted: G        W
3.13.0-rc6-00147-g00bb56a-dirty #40
[   23.452079] [<c0214144>] (unwind_backtrace+0x0/0xf8) from
[<c0211ba8>] (show_stack+0x10/0x14)
[   23.460951] [<c0211ba8>] (show_stack+0x10/0x14) from [<c0674bec>]
(dump_stack+0x64/0xb4)
[   23.469522] [<c0674bec>] (dump_stack+0x64/0xb4) from [<c022afd8>]
(warn_slowpath_common+0x68/0x88)
[   23.477702] [<c022afd8>] (warn_slowpath_common+0x68/0x88) from
[<c022b08c>] (warn_slowpath_fmt+0x30/0x40)
[   23.486475] [<c022b08c>] (warn_slowpath_fmt+0x30/0x40) from
[<bf008744>] (usb_add_gadget_udc_release+0x28/0x1e0 [udc_core])
[   23.496121] [<bf008744>] (usb_add_gadget_udc_release+0x28/0x1e0
[udc_core]) from [<bf012f0c>] (ci_hdrc_gadget_init+0x264/0x2d8
[ci_hdrc])
[   23.507057] [<bf012f0c>] (ci_hdrc_gadget_init+0x264/0x2d8
[ci_hdrc]) from [<bf00f7d4>] (ci_hdrc_probe+0x504/0x7b4 [ci_hdrc])
[   23.519552] [<bf00f7d4>] (ci_hdrc_probe+0x504/0x7b4 [ci_hdrc]) from
[<c04e2968>] (platform_drv_probe+0x18/0x48)
[   23.530831] [<c04e2968>] (platform_drv_probe+0x18/0x48) from
[<c04e10b4>] (driver_probe_device+0x18c/0x23c)
[   23.540639] [<c04e10b4>] (driver_probe_device+0x18c/0x23c) from
[<c04df884>] (bus_for_each_drv+0x5c/0x88)
[   23.550360] [<c04df884>] (bus_for_each_drv+0x5c/0x88) from
[<c04e0ef4>] (device_attach+0x80/0x98)
[   23.560080] [<c04e0ef4>] (device_attach+0x80/0x98) from
[<c04e05d8>] (bus_probe_device+0x84/0xa8)
[   23.568914] [<c04e05d8>] (bus_probe_device+0x84/0xa8) from
[<c04debec>] (device_add+0x3a8/0x4d0)
[   23.577789] [<c04debec>] (device_add+0x3a8/0x4d0) from [<c04e25ac>]
(platform_device_add+0x100/0x22c)
[   23.586650] [<c04e25ac>] (platform_device_add+0x100/0x22c) from
[<bf00fdac>] (ci_hdrc_add_device+0x190/0x1dc [ci_hdrc])
[   23.595768] [<bf00fdac>] (ci_hdrc_add_device+0x190/0x1dc [ci_hdrc])
from [<bf01c168>] (ci_hdrc_msm_probe+0x70/0xc0 [ci_hdrc_msm
])
[   23.606356] [<bf01c168>] (ci_hdrc_msm_probe+0x70/0xc0
[ci_hdrc_msm]) from [<c04e2968>] (platform_drv_probe+0x18/0x48)
[   23.618158] [<c04e2968>] (platform_drv_probe+0x18/0x48) from
[<c04e10b4>] (driver_probe_device+0x18c/0x23c)
[   23.628745] [<c04e10b4>] (driver_probe_device+0x18c/0x23c) from
[<c04e11f0>] (__driver_attach+0x8c/0x90)
[   23.638294] [<c04e11f0>] (__driver_attach+0x8c/0x90) from
[<c04df910>] (bus_for_each_dev+0x60/0x94)
[   23.648015] [<c04df910>] (bus_for_each_dev+0x60/0x94) from
[<c04e0800>] (bus_add_driver+0xdc/0x1d0)
[   23.656783] [<c04e0800>] (bus_add_driver+0xdc/0x1d0) from
[<c04e180c>] (driver_register+0x78/0xf4)
[   23.665809] [<c04e180c>] (driver_register+0x78/0xf4) from
[<c0208860>] (do_one_initcall+0x110/0x174)
[   23.674839] [<c0208860>] (do_one_initcall+0x110/0x174) from
[<c0285740>] (load_module+0x185c/0x1c6c)
[   23.684126] [<c0285740>] (load_module+0x185c/0x1c6c) from
[<c0285c40>] (SyS_init_module+0xf0/0x100)
[   23.693241] [<c0285c40>] (SyS_init_module+0xf0/0x100) from
[<c020e3c0>] (ret_fast_syscall+0x0/0x30)
[   23.701998] ---[ end trace 9c437930835a2049 ]---
[   23.711326] TRB: in msm_otg_set_peripheral
[   23.715861] TRB: MOSP 1
[   23.719765] TRB: MOSP 6
[   23.734335] peripheral driver registered w/ tranceiver
[   23.734356] TRB: msm_otg_start_peripheral, on=1
[   23.738351] TRB: msm_otg_start_peripheral, gadget on
[   23.742828] ------------[ cut here ]------------
[   23.748004] WARNING: CPU: 0 PID: 97 at
/home/CORPUSERS/10102229/work/dragonboard/APQ8074_M8974AAAAANLYA31050138_JB_V11/kernel-1
4-test-usb/drivers/usb/chipidea/udc.c:1456
ci_udc_vbus_session+0x20/0x128 [ci_hdrc]()
[   23.752782] TRB: ci_udc_vbus_session - who's calling?
[   23.771466] Modules linked in: ci_hdrc_msm(+) ci_hdrc udc_core phy_msm_usb
[   23.782882] CPU: 0 PID: 97 Comm: insmod Tainted: G        W
3.13.0-rc6-00147-g00bb56a-dirty #40
[   23.783250] [<c0214144>] (unwind_backtrace+0x0/0xf8) from
[<c0211ba8>] (show_stack+0x10/0x14)
[   23.792126] [<c0211ba8>] (show_stack+0x10/0x14) from [<c0674bec>]
(dump_stack+0x64/0xb4)
[   23.800716] [<c0674bec>] (dump_stack+0x64/0xb4) from [<c022afd8>]
(warn_slowpath_common+0x68/0x88)
[   23.808853] [<c022afd8>] (warn_slowpath_common+0x68/0x88) from
[<c022b08c>] (warn_slowpath_fmt+0x30/0x40)
[   23.817650] [<c022b08c>] (warn_slowpath_fmt+0x30/0x40) from
[<bf010dd4>] (ci_udc_vbus_session+0x20/0x128 [ci_hdrc])
[   23.827286] [<bf010dd4>] (ci_udc_vbus_session+0x20/0x128 [ci_hdrc])
from [<bf000148>] (msm_otg_start_peripheral+0x6c/0xcc [phy_
msm_usb])
[   23.837528] [<bf000148>] (msm_otg_start_peripheral+0x6c/0xcc
[phy_msm_usb]) from [<bf0004d4>] (msm_otg_set_peripheral+0xdc/0x16
4 [phy_msm_usb])
[   23.850036] [<bf0004d4>] (msm_otg_set_peripheral+0xdc/0x164
[phy_msm_usb]) from [<bf00f808>] (ci_hdrc_probe+0x538/0x7b4 [ci_hdr
c])
[   23.862616] [<bf00f808>] (ci_hdrc_probe+0x538/0x7b4 [ci_hdrc]) from
[<c04e2968>] (platform_drv_probe+0x18/0x48)
[   23.874416] [<c04e2968>] (platform_drv_probe+0x18/0x48) from
[<c04e10b4>] (driver_probe_device+0x18c/0x23c)
[   23.884395] [<c04e10b4>] (driver_probe_device+0x18c/0x23c) from
[<c04df884>] (bus_for_each_drv+0x5c/0x88)
[   23.894117] [<c04df884>] (bus_for_each_drv+0x5c/0x88) from
[<c04e0ef4>] (device_attach+0x80/0x98)
[   23.903839] [<c04e0ef4>] (device_attach+0x80/0x98) from
[<c04e05d8>] (bus_probe_device+0x84/0xa8)
[   23.912691] [<c04e05d8>] (bus_probe_device+0x84/0xa8) from
[<c04debec>] (device_add+0x3a8/0x4d0)
[   23.921548] [<c04debec>] (device_add+0x3a8/0x4d0) from [<c04e25ac>]
(platform_device_add+0x100/0x22c)
[   23.930409] [<c04e25ac>] (platform_device_add+0x100/0x22c) from
[<bf00fdac>] (ci_hdrc_add_device+0x190/0x1dc [ci_hdrc])
[   23.939504] [<bf00fdac>] (ci_hdrc_add_device+0x190/0x1dc [ci_hdrc])
from [<bf01c168>] (ci_hdrc_msm_probe+0x70/0xc0 [ci_hdrc_msm
])
[   23.950116] [<bf01c168>] (ci_hdrc_msm_probe+0x70/0xc0
[ci_hdrc_msm]) from [<c04e2968>] (platform_drv_probe+0x18/0x48)
[   23.961915] [<c04e2968>] (platform_drv_probe+0x18/0x48) from
[<c04e10b4>] (driver_probe_device+0x18c/0x23c)
[   23.972502] [<c04e10b4>] (driver_probe_device+0x18c/0x23c) from
[<c04e11f0>] (__driver_attach+0x8c/0x90)
[   23.982051] [<c04e11f0>] (__driver_attach+0x8c/0x90) from
[<c04df910>] (bus_for_each_dev+0x60/0x94)
[   23.991772] [<c04df910>] (bus_for_each_dev+0x60/0x94) from
[<c04e0800>] (bus_add_driver+0xdc/0x1d0)
[   24.000539] [<c04e0800>] (bus_add_driver+0xdc/0x1d0) from
[<c04e180c>] (driver_register+0x78/0xf4)
[   24.009549] [<c04e180c>] (driver_register+0x78/0xf4) from
[<c0208860>] (do_one_initcall+0x110/0x174)
[   24.018595] [<c0208860>] (do_one_initcall+0x110/0x174) from
[<c0285740>] (load_module+0x185c/0x1c6c)
[   24.027885] [<c0285740>] (load_module+0x185c/0x1c6c) from
[<c0285c40>] (SyS_init_module+0xf0/0x100)
[   24.037000] [<c0285c40>] (SyS_init_module+0xf0/0x100) from
[<c020e3c0>] (ret_fast_syscall+0x0/0x30)
[   24.045756] ---[ end trace 9c437930835a204a ]---
[   24.054776] TRB: ci_udc_vbus_session, is_active=1
[   24.059620] TRB: ci_udc_vbus_session, gadget_ready=0
[   24.064265] TRB: MOSP 7
[   24.069250] TRB: MOSP 8
[   24.071444] TRB: MOSP 9
[   24.073860] TRB: in msm_otg_sm_work: state=0
[   24.076284] TRB: MOSW 1 OTG_STATE_UNDEFINED state
[   24.080915] TRB: ci hw_read: reg=f01921a4, mask=ffffffff, val=00201000
[   24.085403] ------------[ cut here ]------------
[   24.091860] TRB: in msm_otg_reset
[   24.096602] TRB: msm_otg_init_sm, mode=2
[   24.099809] TRB: MOSW 2 OTG_STATE_B_IDLE state
[   24.103841] WARNING: CPU: 0 PID: 97 at
/home/CORPUSERS/10102229/work/dragonboard/APQ8074_M8974AAAAANLYA31050138_JB_V11/kernel-1
4-test-usb/drivers/usb/chipidea/udc.c:1456
ci_udc_vbus_session+0x20/0x128 [ci_hdrc]()
[   24.108076] TRB: ci_udc_vbus_session - who's calling?
[   24.127117] Modules linked in: ci_hdrc_msm(+) ci_hdrc udc_core phy_msm_usb
[   24.138524] CPU: 0 PID: 97 Comm: insmod Tainted: G        W
3.13.0-rc6-00147-g00bb56a-dirty #40
[   24.138891] [<c0214144>] (unwind_backtrace+0x0/0xf8) from
[<c0211ba8>] (show_stack+0x10/0x14)
[   24.147765] [<c0211ba8>] (show_stack+0x10/0x14) from [<c0674bec>]
(dump_stack+0x64/0xb4)
[   24.156356] [<c0674bec>] (dump_stack+0x64/0xb4) from [<c022afd8>]
(warn_slowpath_common+0x68/0x88)
[   24.164516] [<c022afd8>] (warn_slowpath_common+0x68/0x88) from
[<c022b08c>] (warn_slowpath_fmt+0x30/0x40)
[   24.173290] [<c022b08c>] (warn_slowpath_fmt+0x30/0x40) from
[<bf010dd4>] (ci_udc_vbus_session+0x20/0x128 [ci_hdrc])
[   24.182930] [<bf010dd4>] (ci_udc_vbus_session+0x20/0x128 [ci_hdrc])
from [<bf0102ac>] (ci_handle_vbus_change+0x74/0x7c [ci_hdrc
])
[   24.193171] [<bf0102ac>] (ci_handle_vbus_change+0x74/0x7c
[ci_hdrc]) from [<bf00f674>] (ci_hdrc_probe+0x3a4/0x7b4 [ci_hdrc])
[   24.204976] [<bf00f674>] (ci_hdrc_probe+0x3a4/0x7b4 [ci_hdrc]) from
[<c04e2968>] (platform_drv_probe+0x18/0x48)
[   24.216256] [<c04e2968>] (platform_drv_probe+0x18/0x48) from
[<c04e10b4>] (driver_probe_device+0x18c/0x23c)
[   24.226062] [<c04e10b4>] (driver_probe_device+0x18c/0x23c) from
[<c04df884>] (bus_for_each_drv+0x5c/0x88)
[   24.235783] [<c04df884>] (bus_for_each_drv+0x5c/0x88) from
[<c04e0ef4>] (device_attach+0x80/0x98)
[   24.245505] [<c04e0ef4>] (device_attach+0x80/0x98) from
[<c04e05d8>] (bus_probe_device+0x84/0xa8)
[   24.254359] [<c04e05d8>] (bus_probe_device+0x84/0xa8) from
[<c04debec>] (device_add+0x3a8/0x4d0)
[   24.263214] [<c04debec>] (device_add+0x3a8/0x4d0) from [<c04e25ac>]
(platform_device_add+0x100/0x22c)
[   24.272074] [<c04e25ac>] (platform_device_add+0x100/0x22c) from
[<bf00fdac>] (ci_hdrc_add_device+0x190/0x1dc [ci_hdrc])
[   24.281192] [<bf00fdac>] (ci_hdrc_add_device+0x190/0x1dc [ci_hdrc])
from [<bf01c168>] (ci_hdrc_msm_probe+0x70/0xc0 [ci_hdrc_msm
])
[   24.291780] [<bf01c168>] (ci_hdrc_msm_probe+0x70/0xc0
[ci_hdrc_msm]) from [<c04e2968>] (platform_drv_probe+0x18/0x48)
[   24.303583] [<c04e2968>] (platform_drv_probe+0x18/0x48) from
[<c04e10b4>] (driver_probe_device+0x18c/0x23c)
[   24.314171] [<c04e10b4>] (driver_probe_device+0x18c/0x23c) from
[<c04e11f0>] (__driver_attach+0x8c/0x90)
[   24.323717] [<c04e11f0>] (__driver_attach+0x8c/0x90) from
[<c04df910>] (bus_for_each_dev+0x60/0x94)
[   24.333438] [<c04df910>] (bus_for_each_dev+0x60/0x94) from
[<c04e0800>] (bus_add_driver+0xdc/0x1d0)
[   24.342208] [<c04e0800>] (bus_add_driver+0xdc/0x1d0) from
[<c04e180c>] (driver_register+0x78/0xf4)
[   24.351235] [<c04e180c>] (driver_register+0x78/0xf4) from
[<c0208860>] (do_one_initcall+0x110/0x174)
[   24.360263] [<c0208860>] (do_one_initcall+0x110/0x174) from
[<c0285740>] (load_module+0x185c/0x1c6c)
[   24.369530] [<c0285740>] (load_module+0x185c/0x1c6c) from
[<c0285c40>] (SyS_init_module+0xf0/0x100)
[   24.378665] [<c0285c40>] (SyS_init_module+0xf0/0x100) from
[<c020e3c0>] (ret_fast_syscall+0x0/0x30)
[   24.387422] ---[ end trace 9c437930835a204b ]---
[   24.396442] TRB: ci_udc_vbus_session, is_active=0
[   24.401303] TRB: ci_udc_vbus_session, gadget_ready=0
[   24.405888] TRB: ci hw_write: reg=f01921a4, mask=007f0000, data=00080000
[   24.410942] TRB: ci hw_write: reg=f01921a4, mask=08000000, data=08000000
[   24.417623] TRB: Creating device files for ci_hdrc.0
[   24.424361] TRB: in really_probe, ret=0
[   24.429264] TRB: in really_probe, ret=0
insmod: can't read 'usb_f_subset.ko': No such file or directory
[   24.547285] TRB: usb_gadget_probe_driver
[   24.547308] ------------[ cut here ]------------
[   24.560166] WARNING: CPU: 0 PID: 117 at
/home/CORPUSERS/10102229/work/dragonboard/APQ8074_M8974AAAAANLYA31050138_JB_V11/kernel-
14-test-usb/drivers/usb/gadget/udc-core.c:416
usb_gadget_probe_driver+0x20/0x100 [udc_core]()
[   24.560206] TRB: usb_gadget_probe_driver
[   24.584972] Modules linked in: g_ether(+) ansi_cprng usb_f_ecm
usb_f_rndis u_rndis u_ether libcomposite ci_hdrc_msm ci_hdrc udc
_core phy_msm_usb
[   24.596540] CPU: 0 PID: 117 Comm: insmod Tainted: G        W
3.13.0-rc6-00147-g00bb56a-dirty #40
[   24.596917] [<c0214144>] (unwind_backtrace+0x0/0xf8) from
[<c0211ba8>] (show_stack+0x10/0x14)
[   24.605804] [<c0211ba8>] (show_stack+0x10/0x14) from [<c0674bec>]
(dump_stack+0x64/0xb4)
[   24.614462] [<c0674bec>] (dump_stack+0x64/0xb4) from [<c022afd8>]
(warn_slowpath_common+0x68/0x88)
[   24.622615] [<c022afd8>] (warn_slowpath_common+0x68/0x88) from
[<c022b08c>] (warn_slowpath_fmt+0x30/0x40)
[   24.631389] [<c022b08c>] (warn_slowpath_fmt+0x30/0x40) from
[<bf008bec>] (usb_gadget_probe_driver+0x20/0x100 [udc_core])
[   24.641027] [<bf008bec>] (usb_gadget_probe_driver+0x20/0x100
[udc_core]) from [<c0208860>] (do_one_initcall+0x110/0x174)
[   24.651962] [<c0208860>] (do_one_initcall+0x110/0x174) from
[<c0285740>] (load_module+0x185c/0x1c6c)
[   24.662807] [<c0285740>] (load_module+0x185c/0x1c6c) from
[<c0285c40>] (SyS_init_module+0xf0/0x100)
[   24.671922] [<c0285c40>] (SyS_init_module+0xf0/0x100) from
[<c020e3c0>] (ret_fast_syscall+0x0/0x30)
[   24.680691] ---[ end trace 9c437930835a204c ]---
[   24.689682] TRB: in udc_bind_to_driver
[   24.694645] udc ci_hdrc.0: registering UDC driver [g_ether]
[   24.698103] TRB: UBTO 1
[   24.703643] using random self ethernet address
[   24.706008] using random host ethernet address
[   24.730244] usb0: HOST MAC 0e:02:1b:fe:4d:1d
[   24.730296] usb0: MAC 2e:f3:d5:6d:9f:9c
[   24.733598] using random self ethernet address
[   24.737133] using random host ethernet address
[   24.757815] g_ether gadget: adding config #2 'RNDIS'/bf0533d8
[   24.757839] rndis_register: configNr = 0
[   24.762561] g_ether gadget: adding 'rndis'/ef3e16c0 to config
'RNDIS'/bf0533d8
[   24.766536] rndis_set_param_medium: 0 0
[   24.773581] g_ether gadget: RNDIS: dual speed IN/ep1in OUT/ep1out
NOTIFY/ep2in
[   24.777290] g_ether gadget: cfg 2/bf0533d8 speeds: high full
[   24.784606] g_ether gadget:   interface 0 = rndis/ef3e16c0
[   24.790434] g_ether gadget:   interface 1 = rndis/ef3e16c0
[   24.795691] g_ether gadget: adding config #1 'CDC Ethernet (ECM)'/bf05332c
[   24.801203] g_ether gadget: adding 'cdc_ethernet'/ef3e1780 to
config 'CDC Ethernet (ECM)'/bf05332c
[   24.808027] g_ether gadget: CDC Ethernet: dual speed IN/ep1in
OUT/ep1out NOTIFY/ep2in
[   24.817376] g_ether gadget: cfg 1/bf05332c speeds: high full
[   24.824898] g_ether gadget:   interface 0 = cdc_ethernet/ef3e1780
[   24.830626] g_ether gadget:   interface 1 = cdc_ethernet/ef3e1780
[   24.836580] g_ether gadget: Ethernet Gadget, version: Memorial Day 2008
[   24.842672] g_ether gadget: g_ether ready
[   24.849071] TRB: UBTO 2
[   24.853251] TRB: UBTO 3 - calling usb_gadget_udc_start
[   24.855494] TRB: calling through gadget->ops->udc_start()
[   24.860721] TRB: ci_udc_start()
[   24.866169] TRB: CIS 1
[   24.869119] TRB: CIS 2
[   24.871566] TRB: CIS 3
[   24.873893] TRB: CIS 4
[   24.876236] TRB: CIS 5
[   24.878580] TRB: CIS 6
[   24.880942] TRB: UBTO 4
[   24.883268] TRB: UBTO 5
[   24.885611] TRB: UBTO 6
[   24.888222] TRB: UBTO 7
/lib/modules #

On Tue, Feb 18, 2014 at 5:21 AM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>
> Hi,
>
> This series intend to fix driver, which was broken for a while.
> It is used to create peripheral role device, which in coordination
> with phy-usb-msm driver will provide USB2.0 gadget support for
> Qualcomm targets.
>
> Changes since initial version.
>
>  - Address comments from Peter - better description of the changes.
>  - Drop patch 4 - till USB PHY driver is ready
>
> Ivan T. Ivanov (3):
>   usb: chipidea: msm: Add device tree binding information
>   usb: chipidea: msm: Add device tree support
>   usb: chipidea: msm: Initialize offset of the capability registers
>
>  .../devicetree/bindings/usb/msm-hsusb.txt          |   17 ++++++++++++++
>  drivers/usb/chipidea/ci_hdrc_msm.c                 |   24 +++++++++++++++++++-
>  2 files changed, 40 insertions(+), 1 deletion(-)
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
 -- Tim Bird
Senior Software Engineer, Sony Mobile
Architecture Group Chair, CE Workgroup, Linux Foundation
