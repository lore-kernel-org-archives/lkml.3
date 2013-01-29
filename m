Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab3A2NtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 08:49:16 -0500
Received: from forward3.mail.yandex.net ([77.88.46.8]:46958 "EHLO
	forward3.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998Ab3A2NtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 08:49:14 -0500
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jan 2013 08:49:14 EST
Message-ID: <5107D1D3.6040105@yandex.ru>
Date: Tue, 29 Jan 2013 17:42:43 +0400
From: Mike Lykov <combr@yandex.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.10) Gecko/20121030 Thunderbird/10.0.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        kirill@shutemov.name
Subject: [BUG?] false positive in soft lockup detector while unlzma initramfs
 on slow cpu
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

I have "embedded" computer, based on  DM&P Vortex86DX (like 
i486/FPU/600Mhz/256Mb RAM).

I boot it with own builded kernel & own compressed initramfs based on 
ALTLinux. When I used initramfs compressed with gzip -9 it worked good. 
But now I need downsize initramfs, and try to change gzip -9 to lzma -9, 
and encounter a kernel BUG. Maybe it a false positive soft lockup detecting.

I compile kernel with this options:

CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1

gzip-compressed initramfs boot (~9 sec):

[ 0.344173] pci 0000:00:09.0: Firmware left e100 interrupts enabled; 
disabling
[ 0.435551] Unpacking initramfs...
[ 8.927297] Freeing initrd memory: 22900k freed
[ 9.059939] platform rtc_cmos: registered platform RTC device (no PNP 
device found)

lzma -3 initramfs compressed boot (~ 44 sec)

[ 0.344612] pci 0000:00:09.0: Firmware left e100 interrupts enabled; 
disabling
[ 0.437119] Unpacking initramfs...
[ 5.030218] sched: RT throttling activated
[ 44.175427] Freeing initrd memory: 17580k freed
[ 44.278414] platform rtc_cmos: registered platform RTC device (no PNP 
device found)

lzma -9 initramfs compressed boot (not finished)

[ 0.437111] Unpacking initramfs...
[ 28.056740] BUG: soft lockup - CPU#0 stuck for 23s! [swapper:1]
[ 28.056740]
[ 28.056740] Pid: 1, comm: swapper Not tainted 3.2.32VEP-01ML5-initramfs 
0000017
[ 28.056740] EIP: 0060:[<c03abcbf>] EFLAGS: 00000202 CPU: 0
[ 28.056740] EIP is at unlzma+0x346/0xac0
[ 28.056740] EAX: 0000012f EBX: 00000007 ECX: d481ce6c EDX: 00f70012
[ 28.056740] ESI: 02796020 EDI: 00000100 EBP: ce827f80 ESP: ce827ee8
[ 28.056740] DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[ 28.056740] Process swapper (pid: 1, ti=ce802000 task=ce80b410 
task.ti=ce826000)
[ 28.056740] Stack:
[ 28.056740] 1144f698 d481c0a2 00000000 00000003 cf0eb000 000000e8 
00000028 cf0eb000
[ 28.056740] 00000003 00000000 0adcda49 00004038 d481ce6c d481c000 
d080a000 00000070
[ 28.056740] 00001f00 00000024 ffffffff c03ab896 cfbb37a4 cf0eb000 
cffefa0b 00f04a0b
[ 28.056740] Call Trace:
[ 28.056740] [<c03ab896>] ? gunzip+0x25b/0x25b
[ 28.056740] [<c039ed46>] ? initrd_load+0x3b/0x3b
[ 28.056740] [<c03ab979>] ? rc_get_bit+0x7c/0x7c
[ 28.056740] [<c039f211>] unpack_to_rootfs+0x139/0x237
[ 28.056740] [<c039ef53>] ? write_buffer+0x2c/0x2c
[ 28.056740] [<c039ed46>] ? initrd_load+0x3b/0x3b
[ 28.056740] [<c039e791>] ? do_one_initcall+0x112/0x112
[ 28.056740] [<c039f9b4>] populate_rootfs+0x42/0x85
[ 28.056740] [<c039e6ef>] do_one_initcall+0x70/0x112
[ 28.056740] [<c039f972>] ? do_header+0x1d4/0x1d4
[ 28.056740] [<c039e791>] ? do_one_initcall+0x112/0x112
[ 28.056740] [<c039e810>] kernel_init+0x7f/0xf8
[ 28.056740] [<c02eb2b6>] kernel_thread_helper+0x6/0xd
[ 28.056740] Code: 2b 55 ac eb 02 01 c2 39 c2 73 fa 8b 7d a0 8a 04 17 0f 
b6 c0 89 45 a8 d1 65 a8 8b 7d a8 8b 45 f0 8b 4d 98 81 e7 00 01 00 00 01 
f8 <8d> 94 41 00 02 00 00 8d 4d f0 8d 45 b4 e8 2c fc ff ff 85 c0 74

I cannot find a method to change "watchdog_thresh" parameter 
("compile-time initialized to 10 and configurable through sysctl of the
same name") at boot time ( commandline 
initrd=initram-alt-p6rel2-9.cpio.lzma console=uart,io,0x240,115200n8 
kernel.watchdog_thresh=20 NOT work) and I patch kernel/watchdog.c 
directly (by idea of kirill@shutemov.name)

--- watchdog.c-orig 2012-10-17 06:50:15.000000000 +0400
+++ watchdog.c 2013-01-29 16:41:51.695990261 +0400
@@ -28,7 +28,7 @@
  #include <linux/perf_event.h>

  int watchdog_enabled = 1;

-int __read_mostly watchdog_thresh = 10;
+int __read_mostly watchdog_thresh = 30;

And it DID BOOT (lzma -9 initramfs on kernel with watchdog_thresh = 30):

[ 0.344345] pci 0000:00:09.0: Firmware left e100 interrupts enabled; 
disabling
[ 0.436961] Unpacking initramfs...
[ 38.907093] sched: RT throttling activated
[ 41.206994] Freeing initrd memory: 15380k freed
[ 41.298015] platform rtc_cmos: registered platform RTC device (no PNP 
device found)

So my questions:

1. Are there a BUG in soft lockup detection mechanizm? Changing 
watchdog_thresh to 30 have a side effect in production - D-state 
userspace processes will be detected slowly. Are there a need to 
detecting soft lockups at boot time? Maybe it need after initramfs boot 
only when userspace processes begin to work?

2. How to change watchdog_thresh parameter at boot without patching 
sources? If it necessary (with it side effects) maybe implement it as 
commandline parameter or config compile time parameter?


With best regards
--
Mike

