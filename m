Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaHSIPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:15:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbaHSIPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:15:42 -0400
Date: Tue, 19 Aug 2014 16:16:58 +0800
From: Dave Young <dyoung@redhat.com>
To: lv.zheng@intel.com
Cc: matt.fleming@intel.com, linux-efi@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@acpica.org, lenb@kernel.org, rafael.j.wysocki@intel.com,
        robert.moore@intel.com
Subject: kernel boot fail with efi earlyprintk (bisected)
Message-ID: <20140819081658.GA1795@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

3.16 kernel boot fail with earlyprintk=efi on my laptop.
It keeps scrolling at the bottom line of screen.

Bisected, the first bad commit is below:
commit 86dfc6f339886559d80ee0d4bd20fe5ee90450f0
Author: Lv Zheng <lv.zheng@intel.com>
Date:   Fri Apr 4 12:38:57 2014 +0800

    ACPICA: Tables: Fix table checksums verification before installation.


I did some debugging by enabling both serial and efi earlyprintk, below is
some debug dmesg, seems early_ioremap fails in scroll up function due to
no free slot, but I'm still not sure if the debug info is right or not.

[  256.174623] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  256.183352] reboot: Restarting system
[  256.188450] reboot: machine restart
[    0.000000] Linux version 3.17.0-rc1+ (dyoung@dhcp-16-198.nay.redhat.com) (gcc version 4.8.1 20130603 (Red Hat 4.8.1-1) (GC4
[    0.000000] Command line: BOOT_IMAGE=/bzImage selinux=0 root=UUID=29296957-5ac6-40c2-a20d-b43d38a1d29d ro crashkernel=256M i
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000db41dfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db41e000-0x00000000db71afff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000db71b000-0x00000000db82ffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000db830000-0x00000000db9e0fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000db9e1000-0x00000000dbaf4fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dbaf5000-0x00000000dbaf5fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dbaf6000-0x00000000dbb7bfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000dbb7c000-0x00000000dbffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f7ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000041fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] bootconsole [earlyefi0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000000100000-0x00000000d5552017] usable
[    0.000000] reserve setup_data: [mem 0x00000000d5552018-0x00000000d5561057] usable
[    0.000000] reserve setup_data: [mem 0x00000000d5561058-0x00000000d5562017] usable
[    0.000000] reserve setup_data: [mem 0x00000000d5562018-0x00000000d5578c57] usable
[    0.000000] reserve setup_data: [mem 0x00000000d5578c58-0x00000000d5579017] usable
[    0.000000] reserve setup_data: [mem 0x00000000d5579018-0x00000000d5593457] usable
[    0.000000] reserve setup_data: [mem 0x00000000d5593458-0x00000000d5594017] usable
[    0.000000] reserve setup_data: [mem 0x00000000d5594018-0x00000000d559d057] usable
[    0.000000] reserve setup_data: [mem 0x00000000d559d058-0x00000000db41dfff] usable
[    0.000000] reserve setup_data: [mem 0x00000000db41e000-0x00000000db71afff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000db71b000-0x00000000db82ffff] ACPI data
[    0.000000] reserve setup_data: [mem 0x00000000db830000-0x00000000db9e0fff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x00000000db9e1000-0x00000000dbaf4fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000dbaf5000-0x00000000dbaf5fff] usable
[    0.000000] reserve setup_data: [mem 0x00000000dbaf6000-0x00000000dbb7bfff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x00000000dbb7c000-0x00000000dbffffff] usable
[    0.000000] reserve setup_data: [mem 0x00000000f0000000-0x00000000f7ffffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000041fffffff] usable
[    0.000000] efi: EFI v2.31 by American Megatrends
[    0.000000] efi:  ACPI 2.0=0xdb752000  SMBIOS=0xdbab4b98  ACPI=0xdb752000  MPS=0xf4bd0 
[    0.000000] efi: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000008000) (0MB)
[    0.000000] efi: mem01: type=2, attr=0xf, range=[0x0000000000008000-0x0000000000009000) (0MB)
[    0.000000] efi: mem02: type=7, attr=0xf, range=[0x0000000000009000-0x000000000003f000) (0MB)
[    0.000000] efi: mem03: type=4, attr=0xf, range=[0x000000000003f000-0x0000000000050000) (0MB)
[    0.000000] efi: mem04: type=3, attr=0xf, range=[0x0000000000050000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem05: type=3, attr=0xf, range=[0x0000000000100000-0x0000000000110000) (0MB)
[    0.000000] efi: mem06: type=7, attr=0xf, range=[0x0000000000110000-0x0000000001000000) (14MB)
[    0.000000] efi: mem07: type=2, attr=0xf, range=[0x0000000001000000-0x0000000001100000) (1MB)
[    0.000000] efi: mem08: type=7, attr=0xf, range=[0x0000000001100000-0x0000000002000000) (15MB)
[    0.000000] efi: mem09: type=2, attr=0xf, range=[0x0000000002000000-0x0000000003678000) (22MB)
[    0.000000] efi: mem10: type=7, attr=0xf, range=[0x0000000003678000-0x000000003e1b0000) (939MB)
[    0.000000] efi: mem11: type=2, attr=0xf, range=[0x000000003e1b0000-0x0000000040000000) (30MB)
[    0.000000] efi: mem12: type=7, attr=0xf, range=[0x0000000040000000-0x0000000096b1e000) (1387MB)
[    0.000000] efi: mem13: type=2, attr=0xf, range=[0x0000000096b1e000-0x00000000cc5d3000) (858MB)
[    0.000000] efi: mem14: type=4, attr=0xf, range=[0x00000000cc5d3000-0x00000000cc78c000) (1MB)
[    0.000000] efi: mem15: type=7, attr=0xf, range=[0x00000000cc78c000-0x00000000cc81f000) (0MB)
[    0.000000] efi: mem16: type=4, attr=0xf, range=[0x00000000cc81f000-0x00000000cd0f1000) (8MB)
[    0.000000] efi: mem17: type=7, attr=0xf, range=[0x00000000cd0f1000-0x00000000cd0f2000) (0MB)
[    0.000000] efi: mem18: type=4, attr=0xf, range=[0x00000000cd0f2000-0x00000000cd0f3000) (0MB)
[    0.000000] efi: mem19: type=7, attr=0xf, range=[0x00000000cd0f3000-0x00000000cd0f9000) (0MB)
[    0.000000] efi: mem20: type=4, attr=0xf, range=[0x00000000cd0f9000-0x00000000cd0fa000) (0MB)
[    0.000000] efi: mem21: type=7, attr=0xf, range=[0x00000000cd0fa000-0x00000000cd112000) (0MB)
[    0.000000] efi: mem22: type=4, attr=0xf, range=[0x00000000cd112000-0x00000000cd113000) (0MB)
[    0.000000] efi: mem23: type=7, attr=0xf, range=[0x00000000cd113000-0x00000000cd117000) (0MB)
[    0.000000] efi: mem24: type=4, attr=0xf, range=[0x00000000cd117000-0x00000000cd118000) (0MB)
[    0.000000] efi: mem25: type=7, attr=0xf, range=[0x00000000cd118000-0x00000000cd1e1000) (0MB)
[    0.000000] efi: mem26: type=4, attr=0xf, range=[0x00000000cd1e1000-0x00000000cd1f6000) (0MB)
[    0.000000] efi: mem27: type=7, attr=0xf, range=[0x00000000cd1f6000-0x00000000cd242000) (0MB)
[    0.000000] efi: mem28: type=4, attr=0xf, range=[0x00000000cd242000-0x00000000cd243000) (0MB)
[    0.000000] efi: mem29: type=7, attr=0xf, range=[0x00000000cd243000-0x00000000cd28f000) (0MB)
[    0.000000] efi: mem30: type=4, attr=0xf, range=[0x00000000cd28f000-0x00000000cd31e000) (0MB)
[    0.000000] efi: mem31: type=7, attr=0xf, range=[0x00000000cd31e000-0x00000000cd321000) (0MB)
[    0.000000] efi: mem32: type=4, attr=0xf, range=[0x00000000cd321000-0x00000000cd322000) (0MB)
[    0.000000] efi: mem33: type=7, attr=0xf, range=[0x00000000cd322000-0x00000000cd323000) (0MB)
[    0.000000] efi: mem34: type=4, attr=0xf, range=[0x00000000cd323000-0x00000000cd324000) (0MB)
[    0.000000] efi: mem35: type=7, attr=0xf, range=[0x00000000cd324000-0x00000000cd40f000) (0MB)
[    0.000000] efi: mem36: type=4, attr=0xf, range=[0x00000000cd40f000-0x00000000cd424000) (0MB)
[    0.000000] efi: mem37: type=7, attr=0xf, range=[0x00000000cd424000-0x00000000cd527000) (1MB)
[    0.000000] efi: mem38: type=4, attr=0xf, range=[0x00000000cd527000-0x00000000cd528000) (0MB)
[    0.000000] efi: mem39: type=7, attr=0xf, range=[0x00000000cd528000-0x00000000cd548000) (0MB)
[    0.000000] efi: mem40: type=4, attr=0xf, range=[0x00000000cd548000-0x00000000cd549000) (0MB)
[    0.000000] efi: mem41: type=7, attr=0xf, range=[0x00000000cd549000-0x00000000cd54e000) (0MB)
[    0.000000] efi: mem42: type=4, attr=0xf, range=[0x00000000cd54e000-0x00000000cd550000) (0MB)
[    0.000000] efi: mem43: type=7, attr=0xf, range=[0x00000000cd550000-0x00000000cd63d000) (0MB)
[    0.000000] efi: mem44: type=4, attr=0xf, range=[0x00000000cd63d000-0x00000000cd652000) (0MB)
[    0.000000] efi: mem45: type=7, attr=0xf, range=[0x00000000cd652000-0x00000000cd777000) (1MB)
[    0.000000] efi: mem46: type=4, attr=0xf, range=[0x00000000cd777000-0x00000000cd778000) (0MB)
[    0.000000] efi: mem47: type=7, attr=0xf, range=[0x00000000cd778000-0x00000000cd77d000) (0MB)
[    0.000000] efi: mem48: type=4, attr=0xf, range=[0x00000000cd77d000-0x00000000cd77f000) (0MB)
[    0.000000] efi: mem49: type=7, attr=0xf, range=[0x00000000cd77f000-0x00000000cd86c000) (0MB)
[    0.000000] efi: mem50: type=4, attr=0xf, range=[0x00000000cd86c000-0x00000000cd881000) (0MB)
[    0.000000] efi: mem51: type=7, attr=0xf, range=[0x00000000cd881000-0x00000000cd9bb000) (1MB)
[    0.000000] efi: mem52: type=4, attr=0xf, range=[0x00000000cd9bb000-0x00000000cd9bc000) (0MB)
[    0.000000] efi: mem53: type=7, attr=0xf, range=[0x00000000cd9bc000-0x00000000cd9bf000) (0MB)
[    0.000000] efi: mem54: type=4, attr=0xf, range=[0x00000000cd9bf000-0x00000000cd9c0000) (0MB)
[    0.000000] efi: mem55: type=7, attr=0xf, range=[0x00000000cd9c0000-0x00000000cd9cb000) (0MB)
[    0.000000] efi: mem56: type=4, attr=0xf, range=[0x00000000cd9cb000-0x00000000cd9cc000) (0MB)
[    0.000000] efi: mem57: type=7, attr=0xf, range=[0x00000000cd9cc000-0x00000000cdb0c000) (1MB)
[    0.000000] efi: mem58: type=4, attr=0xf, range=[0x00000000cdb0c000-0x00000000cdb0d000) (0MB)
[    0.000000] efi: mem59: type=7, attr=0xf, range=[0x00000000cdb0d000-0x00000000cdbd7000) (0MB)
[    0.000000] efi: mem60: type=4, attr=0xf, range=[0x00000000cdbd7000-0x00000000cdc02000) (0MB)
[    0.000000] efi: mem61: type=7, attr=0xf, range=[0x00000000cdc02000-0x00000000cdc0a000) (0MB)
[    0.000000] efi: mem62: type=4, attr=0xf, range=[0x00000000cdc0a000-0x00000000cdc0b000) (0MB)
[    0.000000] efi: mem63: type=7, attr=0xf, range=[0x00000000cdc0b000-0x00000000cdc0e000) (0MB)
[    0.000000] efi: mem64: type=4, attr=0xf, range=[0x00000000cdc0e000-0x00000000cdc0f000) (0MB)
[    0.000000] efi: mem65: type=7, attr=0xf, range=[0x00000000cdc0f000-0x00000000cde37000) (2MB)
[    0.000000] efi: mem66: type=4, attr=0xf, range=[0x00000000cde37000-0x00000000cde38000) (0MB)
[    0.000000] efi: mem67: type=7, attr=0xf, range=[0x00000000cde38000-0x00000000cde39000) (0MB)
[    0.000000] efi: mem68: type=4, attr=0xf, range=[0x00000000cde39000-0x00000000cde62000) (0MB)
[    0.000000] efi: mem69: type=7, attr=0xf, range=[0x00000000cde62000-0x00000000cdf0c000) (0MB)
[    0.000000] efi: mem70: type=4, attr=0xf, range=[0x00000000cdf0c000-0x00000000ce13f000) (2MB)
[    0.000000] efi: mem71: type=7, attr=0xf, range=[0x00000000ce13f000-0x00000000ce163000) (0MB)
[    0.000000] efi: mem72: type=4, attr=0xf, range=[0x00000000ce163000-0x00000000ce1e3000) (0MB)
[    0.000000] efi: mem73: type=7, attr=0xf, range=[0x00000000ce1e3000-0x00000000ce200000) (0MB)
[    0.000000] efi: mem74: type=4, attr=0xf, range=[0x00000000ce200000-0x00000000ce201000) (0MB)
[    0.000000] efi: mem75: type=7, attr=0xf, range=[0x00000000ce201000-0x00000000ce220000) (0MB)
[    0.000000] efi: mem76: type=4, attr=0xf, range=[0x00000000ce220000-0x00000000cf095000) (14MB)
[    0.000000] efi: mem77: type=7, attr=0xf, range=[0x00000000cf095000-0x00000000cf099000) (0MB)
[    0.000000] efi: mem78: type=4, attr=0xf, range=[0x00000000cf099000-0x00000000cf611000) (5MB)
[    0.000000] efi: mem79: type=7, attr=0xf, range=[0x00000000cf611000-0x00000000d5550000) (95MB)
[    0.000000] efi: mem80: type=2, attr=0xf, range=[0x00000000d5550000-0x00000000d559e000) (0MB)
[    0.000000] efi: mem81: type=7, attr=0xf, range=[0x00000000d559e000-0x00000000d559f000) (0MB)
[    0.000000] efi: mem82: type=2, attr=0xf, range=[0x00000000d559f000-0x00000000d5768000) (1MB)
[    0.000000] efi: mem83: type=1, attr=0xf, range=[0x00000000d5768000-0x00000000d589d000) (1MB)
[    0.000000] efi: mem84: type=7, attr=0xf, range=[0x00000000d589d000-0x00000000d8af4000) (50MB)
[    0.000000] efi: mem85: type=4, attr=0xf, range=[0x00000000d8af4000-0x00000000d8b21000) (0MB)
[    0.000000] efi: mem86: type=7, attr=0xf, range=[0x00000000d8b21000-0x00000000d8b32000) (0MB)
[    0.000000] efi: mem87: type=4, attr=0xf, range=[0x00000000d8b32000-0x00000000d9f01000) (19MB)
[    0.000000] efi: mem88: type=7, attr=0xf, range=[0x00000000d9f01000-0x00000000da65c000) (7MB)
[    0.000000] efi: mem89: type=3, attr=0xf, range=[0x00000000da65c000-0x00000000db41e000) (13MB)
[    0.000000] efi: mem90: type=0, attr=0xf, range=[0x00000000db41e000-0x00000000db4b7000) (0MB)
[    0.000000] efi: mem91: type=0, attr=0xf, range=[0x00000000db4b7000-0x00000000db71b000) (2MB)
[    0.000000] efi: mem92: type=9, attr=0xf, range=[0x00000000db71b000-0x00000000db752000) (0MB)
[    0.000000] efi: mem93: type=9, attr=0xf, range=[0x00000000db752000-0x00000000db830000) (0MB)
[    0.000000] efi: mem94: type=10, attr=0xf, range=[0x00000000db830000-0x00000000db90c000) (0MB)
[    0.000000] efi: mem95: type=10, attr=0xf, range=[0x00000000db90c000-0x00000000db9e1000) (0MB)
[    0.000000] efi: mem96: type=6, attr=0x800000000000000f, range=[0x00000000db9e1000-0x00000000dba08000) (0MB)
[    0.000000] efi: mem97: type=6, attr=0x800000000000000f, range=[0x00000000dba08000-0x00000000dbaa7000) (0MB)
[    0.000000] efi: mem98: type=6, attr=0x800000000000000f, range=[0x00000000dbaa7000-0x00000000dbaaa000) (0MB)
[    0.000000] efi: mem99: type=6, attr=0x800000000000000f, range=[0x00000000dbaaa000-0x00000000dbab6000) (0MB)
[    0.000000] efi: mem100: type=5, attr=0x800000000000000f, range=[0x00000000dbab6000-0x00000000dbac2000) (0MB)
[    0.000000] efi: mem101: type=5, attr=0x800000000000000f, range=[0x00000000dbac2000-0x00000000dbaf5000) (0MB)
[    0.000000] efi: mem102: type=4, attr=0xf, range=[0x00000000dbaf5000-0x00000000dbaf6000) (0MB)
[    0.000000] efi: mem103: type=10, attr=0xf, range=[0x00000000dbaf6000-0x00000000dbb7c000) (0MB)
[    0.000000] efi: mem104: type=4, attr=0xf, range=[0x00000000dbb7c000-0x00000000dbcce000) (1MB)
[    0.000000] efi: mem105: type=3, attr=0xf, range=[0x00000000dbcce000-0x00000000dbf72000) (2MB)
[    0.000000] efi: mem106: type=4, attr=0xf, range=[0x00000000dbf72000-0x00000000dbf76000) (0MB)
[    0.000000] efi: mem107: type=3, attr=0xf, range=[0x00000000dbf76000-0x00000000dbf7a000) (0MB)
[    0.000000] efi: mem108: type=4, attr=0xf, range=[0x00000000dbf7a000-0x00000000dbf87000) (0MB)
[    0.000000] efi: mem109: type=3, attr=0xf, range=[0x00000000dbf87000-0x00000000dbf99000) (0MB)
[    0.000000] efi: mem110: type=4, attr=0xf, range=[0x00000000dbf99000-0x00000000dc000000) (0MB)
[    0.000000] efi: mem111: type=7, attr=0xf, range=[0x0000000100000000-0x0000000420000000) (12800MB)
[    0.000000] efi: mem112: type=11, attr=0x8000000000000001, range=[0x00000000f0000000-0x00000000f8000000) (128MB)
[    0.000000] efi: mem113: type=11, attr=0x8000000000000001, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
[    0.000000] efi: mem114: type=11, attr=0x8000000000000001, range=[0x00000000ff000000-0x0000000100000000) (16MB)
[    0.000000] SMBIOS 2.7 present.
[    0.000000] e820: last_pfn = 0x420000 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xdc000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f4bc0-0x000f4bcf] mapped at [ffff8800000f4bc0]
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000] init_memory_mapping: [mem 0x41fe00000-0x41fffffff]
[    0.000000] init_memory_mapping: [mem 0x41c000000-0x41fdfffff]
[    0.000000] init_memory_mapping: [mem 0x400000000-0x41bffffff]
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdb41dfff]
[    0.000000] init_memory_mapping: [mem 0xdbaf5000-0xdbaf5fff]
[    0.000000] init_memory_mapping: [mem 0xdbb7c000-0xdbffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000] RAMDISK: [mem 0x3e1b0000-0x3e982fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000DB752000 000024 (v02 HPQOEM)
[    0.000000] ACPI: XSDT 0x00000000DB752088 00008C (v01 HPQOEM SLIC-WKS 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000DB759590 00010C (v05 HPQOEM SLIC-WKS 01072009 AMI  00010013)
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at mm/early_ioremap.c:116 __early_ioremap+0x90/0x1c4()
[    0.000000] __early_ioremap(ed00c800, 00000c80) not found slot
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.17.0-rc1+ #204
[    0.000000] Hardware name: Hewlett-Packard HP Z420 Workstation/1589, BIOS J61 v03.15 05/09/2013
[    0.000000]  0000000000000000 ffffffff8173b970 ffffffff814bb919 ffffffff8173b9b8
[    0.000000]  ffffffff8173b9a8 ffffffff810638c9 ffffffff8184ee81 ffffffffff538000
[    0.000000]  0000000000000c80 0000000000000003 0000000000000c80 ffffffff8173ba08
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff814bb919>] dump_stack+0x4e/0x7a
[    0.000000]  [<ffffffff810638c9>] warn_slowpath_common+0x75/0x8e
[    0.000000]  [<ffffffff8184ee81>] ? __early_ioremap+0x90/0x1c4
[    0.000000]  [<ffffffff81063929>] warn_slowpath_fmt+0x47/0x49
[    0.000000]  [<ffffffff8184ee81>] __early_ioremap+0x90/0x1c4
[    0.000000]  [<ffffffff8124cf4d>] ? sprintf+0x46/0x48
[    0.000000]  [<ffffffff8184f169>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff814ae4f0>] early_efi_map+0x24/0x26
[    0.000000]  [<ffffffff81060985>] early_efi_scroll_up+0x6d/0xc0
[    0.000000]  [<ffffffff81060b88>] early_efi_write+0x1b0/0x214
[    0.000000]  [<ffffffff8109ec3a>] call_console_drivers.constprop.21+0x73/0x7e
[    0.000000]  [<ffffffff8109fab4>] console_unlock+0x151/0x3b2
[    0.000000]  [<ffffffff810a01b4>] ? vprintk_emit+0x49f/0x532
[    0.000000]  [<ffffffff810a0236>] vprintk_emit+0x521/0x532
[    0.000000]  [<ffffffff8109fce6>] ? console_unlock+0x383/0x3b2
[    0.000000]  [<ffffffff814b6f01>] printk+0x4f/0x51
[    0.000000]  [<ffffffff81292f9c>] acpi_os_vprintf+0x2b/0x2d
[    0.000000]  [<ffffffff81292fe1>] acpi_os_printf+0x43/0x45
[    0.000000]  [<ffffffff812bc44c>] acpi_info+0x5c/0x63
[    0.000000]  [<ffffffff8183cdfa>] ? __acpi_map_table+0x13/0x18
[    0.000000]  [<ffffffff814afc88>] ? acpi_os_map_iomem+0x21/0x147
[    0.000000]  [<ffffffff812b7e59>] acpi_tb_print_table_header+0x177/0x186
[    0.000000]  [<ffffffff812b79da>] acpi_tb_install_table_with_override+0x4b/0x62
[    0.000000]  [<ffffffff812b7b80>] acpi_tb_install_standard_table+0xd9/0x215
[    0.000000]  [<ffffffff8184f169>] ? early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8183cdfa>] ? __acpi_map_table+0x13/0x18
[    0.000000]  [<ffffffff81857545>] acpi_tb_parse_root_table+0x16e/0x1b4
[    0.000000]  [<ffffffff818575e2>] acpi_initialize_tables+0x57/0x59
[    0.000000]  [<ffffffff8185591d>] acpi_table_init+0x50/0xce
[    0.000000]  [<ffffffff8183cea2>] acpi_boot_table_init+0x1e/0x85
[    0.000000]  [<ffffffff81834638>] setup_arch+0x9b7/0xcc4
[    0.000000]  [<ffffffff81830b3e>] start_kernel+0x94/0x42d
[    0.000000]  [<ffffffff81830120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff818304a2>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81830597>] x86_64_start_kernel+0xf3/0x100
[    0.000000] ---[ end trace 48732c7db414b8fe ]---
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at mm/early_ioremap.c:116 __early_ioremap+0x90/0x1c4()
[    0.000000] __early_ioremap(ed00c800, 00000c80) not found slot
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Tainted: G        W      3.17.0-rc1+ #204
[    0.000000] Hardware name: Hewlett-Packard HP Z420 Workstation/1589, BIOS J61 v03.15 05/09/2013
[    0.000000]  0000000000000000 ffffffff8173b970 ffffffff814bb919 ffffffff8173b9b8
[    0.000000]  ffffffff8173b9a8 ffffffff810638c9 ffffffff8184ee81 ffffffffff538000
[    0.000000]  0000000000000c80 0000000000000003 0000000000000c80 ffffffff8173ba08
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff814bb919>] dump_stack+0x4e/0x7a
[    0.000000]  [<ffffffff810638c9>] warn_slowpath_common+0x75/0x8e
[    0.000000]  [<ffffffff8184ee81>] ? __early_ioremap+0x90/0x1c4
[    0.000000]  [<ffffffff81063929>] warn_slowpath_fmt+0x47/0x49
[    0.000000]  [<ffffffff8184ee81>] __early_ioremap+0x90/0x1c4
[    0.000000]  [<ffffffff8184f169>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff814ae4f0>] early_efi_map+0x24/0x26
[    0.000000]  [<ffffffff81060985>] early_efi_scroll_up+0x6d/0xc0
[    0.000000]  [<ffffffff81060b88>] early_efi_write+0x1b0/0x214
[    0.000000]  [<ffffffff8109ec3a>] call_console_drivers.constprop.21+0x73/0x7e
[    0.000000]  [<ffffffff8109fb5d>] console_unlock+0x1fa/0x3b2
[    0.000000]  [<ffffffff810a0236>] vprintk_emit+0x521/0x532
[    0.000000]  [<ffffffff8109fce6>] ? console_unlock+0x383/0x3b2
[    0.000000]  [<ffffffff814b6f01>] printk+0x4f/0x51
[    0.000000]  [<ffffffff81292f9c>] acpi_os_vprintf+0x2b/0x2d
[    0.000000]  [<ffffffff81292fe1>] acpi_os_printf+0x43/0x45
[    0.000000]  [<ffffffff812bc44c>] acpi_info+0x5c/0x63
[    0.000000]  [<ffffffff8183cdfa>] ? __acpi_map_table+0x13/0x18
[    0.000000]  [<ffffffff814afc88>] ? acpi_os_map_iomem+0x21/0x147
[    0.000000]  [<ffffffff812b7e59>] acpi_tb_print_table_header+0x177/0x186
[    0.000000]  [<ffffffff812b79da>] acpi_tb_install_table_with_override+0x4b/0x62
[    0.000000]  [<ffffffff812b7b80>] acpi_tb_install_standard_table+0xd9/0x215
[    0.000000]  [<ffffffff8184f169>] ? early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff8183cdfa>] ? __acpi_map_table+0x13/0x18
[    0.000000]  [<ffffffff81857545>] acpi_tb_parse_root_table+0x16e/0x1b4
[    0.000000]  [<ffffffff818575e2>] acpi_initialize_tables+0x57/0x59
[    0.000000]  [<ffffffff8185591d>] acpi_table_init+0x50/0xce
[    0.000000]  [<ffffffff8183cea2>] acpi_boot_table_init+0x1e/0x85
[    0.000000]  [<ffffffff81834638>] setup_arch+0x9b7/0xcc4
[    0.000000]  [<ffffffff81830b3e>] start_kernel+0x94/0x42d
[    0.000000]  [<ffffffff81830120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff818304a2>] x86_64_start_reservations+0x2a/0x2c
** 7 printk messages dropped ** [    0.000000] Hardware name: Hewlett-Packard HP Z420 Workstation/1589, BIOS J61 v03.15 05/09/3
** 87 printk messages dropped ** [    0.000000] Hardware name: Hewlett-Packard HP Z420 Workstation/1589, BIOS J61 v03.15 05/093


Thanks
Dave
