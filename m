Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab3APBrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 20:47:52 -0500
Received: from mail.palosanto.com ([201.234.196.171]:39913 "EHLO
	pbx.palosanto.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab3APBrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 20:47:51 -0500
Message-ID: <50F606A8.2080804@palosanto.com>
Date: Tue, 15 Jan 2013 20:47:20 -0500
From: =?ISO-8859-1?Q?Alex_Villac=EDs_Lasso?= <a_villacis@palosanto.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Use of memmap= to forcibly recover memory in 3GB-4GB range - is this
 safe?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a Foxconn mainboard that supports 64-bit CPUs and DDR2 memory up 
to 4GB. Two days ago I bought memory to max out the memory capacity. 
When I booted up the system with my new memory sticks, I found out that 
the system only presented around 3200 MB of usable memory to the kernel. 
I believe this is a common complaint. I know about "memory remapping" 
options in the BIOS, and I already checked that there is no such option 
present in my mainboard BIOS utility. In addition, I do not trust myself 
with flashing the BIOS for an update.

Here is a bit of the startup dmesg log for my system:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0-rc3 (alex@karlalex.palosanto.com) 
(gcc version 4.6.3 20120306 (Red Hat 4.6.3-2) (GCC) ) #16 SMP PREEMPT 
Mon Jan 14 22:20:34 ECT 2013
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.8.0-rc3 
root=UUID=4837c784-4583-4efc-8a40-260819368469 ro rd.md=0 rd.lvm=0 
rd.dm=0 quiet SYSFONT=latarcyrheb-sun16 rhgb rd.luks=0 LANG=es_ES.UTF-8 
KEYTABLE=es zcache drm_kms_helper.edid_firmware=edid/1280x1024.bin
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cf58ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cf590000-0x00000000cf5e2fff] 
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cf5e3000-0x00000000cf5effff] 
ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cf5f0000-0x00000000cf5fffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000ffffffff] 
reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: OEM OEM/G31MVP, BIOS 6.00 PG 09/11/2008
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x130000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-F7FFF uncachable
[    0.000000]   F8000-FBFFF write-through
[    0.000000]   FC000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 100000000 mask FE0000000 write-back
[    0.000000]   1 base 120000000 mask FF0000000 write-back
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 base 0C0000000 mask FF0000000 write-back
[    0.000000]   5 base 0CF700000 mask FFFF00000 uncachable
[    0.000000]   6 base 0CF800000 mask FFF800000 uncachable
[    0.000000]   7 base 0CF600000 mask FFFF00000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 4GB, range: 512MB, type WB
[    0.000000] reg 1, base: 4608MB, range: 256MB, type WB
[    0.000000] reg 2, base: 0GB, range: 2GB, type WB
[    0.000000] reg 3, base: 2GB, range: 1GB, type WB
[    0.000000] reg 4, base: 3GB, range: 256MB, type WB
[    0.000000] reg 5, base: 3319MB, range: 1MB, type UC
[    0.000000] reg 6, base: 3320MB, range: 8MB, type UC
[    0.000000] reg 7, base: 3318MB, range: 1MB, type UC
[    0.000000] total RAM covered: 4086M

While examining this output, I noticed something. If the BIOS is 
supposed to be unable to remap memory out of the 3GB-4GB range into the 
4GB+ range, then why does it set up the MTRR ranges so that they cover a 
bit beyond 4GB?

[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 4GB, range: 512MB, type WB
[    0.000000] reg 1, base: 4608MB, range: 256MB, type WB

This suggests to me that in my particular mainboard, the mainboard is 
perfectly capable of remapping past 4GB, and in fact the memory always 
gets remapped, and the absence of this region in the e820 memory map is 
in fact a BIOS limitation, the one that is supposed to be removed by an 
update. So I thought, if the BIOS won't place the extra 768 MB of memory 
in the e820 map, maybe a memmap=768MB@4GB parameter will allow the 
kernel to use this memory despite the BIOS not reporting it.

Of course, I could be horribly wrong. Therefore, this email.

I added the memmap parameter, and got this startup:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0-rc3 (alex@karlalex.palosanto.com) 
(gcc version 4.6.3 20120306 (Red Hat 4.6.3-2) (GCC) ) #16 SMP PREEMPT 
Mon Jan 14 22:20:34 ECT 2013
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.8.0-rc3 
root=UUID=4837c784-4583-4efc-8a40-260819368469 ro rd.md=0 rd.lvm=0 
rd.dm=0 quiet SYSFONT=latarcyrheb-sun16 rhgb rd.luks=0 LANG=es_ES.UTF-8 
KEYTABLE=es zcache drm_kms_helper.edid_firmware=edid/1280x1024.bin 
memmap=768M@4G
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cf58ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cf590000-0x00000000cf5e2fff] 
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cf5e3000-0x00000000cf5effff] 
ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cf5f0000-0x00000000cf5fffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000ffffffff] 
reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: user-defined physical RAM map:
[    0.000000] user: [mem 0x0000000000000000-0x000000000009f3ff] usable
[    0.000000] user: [mem 0x000000000009f400-0x000000000009ffff] reserved
[    0.000000] user: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] user: [mem 0x0000000000100000-0x00000000cf58ffff] usable
[    0.000000] user: [mem 0x00000000cf590000-0x00000000cf5e2fff] ACPI NVS
[    0.000000] user: [mem 0x00000000cf5e3000-0x00000000cf5effff] ACPI data
[    0.000000] user: [mem 0x00000000cf5f0000-0x00000000cf5fffff] reserved
[    0.000000] user: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] user: [mem 0x00000000fec00000-0x00000000ffffffff] reserved
[    0.000000] user: [mem 0x0000000100000000-0x000000012fffffff] usable
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: OEM OEM/G31MVP, BIOS 6.00 PG 09/11/2008
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x130000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-F7FFF uncachable
[    0.000000]   F8000-FBFFF write-through
[    0.000000]   FC000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 100000000 mask FE0000000 write-back
[    0.000000]   1 base 120000000 mask FF0000000 write-back
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 base 0C0000000 mask FF0000000 write-back
[    0.000000]   5 base 0CF700000 mask FFFF00000 uncachable
[    0.000000]   6 base 0CF800000 mask FFF800000 uncachable
[    0.000000]   7 base 0CF600000 mask FFFF00000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 4GB, range: 512MB, type WB
[    0.000000] reg 1, base: 4608MB, range: 256MB, type WB
[    0.000000] reg 2, base: 0GB, range: 2GB, type WB
[    0.000000] reg 3, base: 2GB, range: 1GB, type WB
[    0.000000] reg 4, base: 3GB, range: 256MB, type WB
[    0.000000] reg 5, base: 3319MB, range: 1MB, type UC
[    0.000000] reg 6, base: 3320MB, range: 8MB, type UC
[    0.000000] reg 7, base: 3318MB, range: 1MB, type UC
[    0.000000] total RAM covered: 4086M

The system boots, apparently normally, and I can see the additional 
"memory" in all system reports. However, I cannot quite shake the 
feeling that this "memory" might be in fact an illusion, and an attempt 
to use it will wrap around to the bottom of the memory and corrupt 
anything there. Or worse.

Some tests that I have tried:
1) I have tried to occupy as much memory as possible, by starting two 
virtual machines, plus one instance of eclipse, a browser, and a 
bittorrent client, while running the graphical desktop. I have seen the 
free memory (as reported by "top") fall to under 200 Mb with no apparent 
instability, so this should prove that the extra memory is real, right?
2) I have recompiled the kernel to support the memtest parameter. When 
using it, the extra memory segment appears to be as healthy as other 
areas of memory. However this might only mean that it is wrapping into 
healthy low RAM.

Is my reasoning sane? Is there a way to know, once and for all, whether 
the extra "memory" is real and safe to use or not?
