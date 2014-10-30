Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161295AbaJ3VNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 17:13:04 -0400
Received: from smtp.gaealink.net ([108.166.122.24]:36795 "EHLO
	smtp.gaealink.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161050AbaJ3VM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 17:12:59 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Oct 2014 17:12:59 EDT
Message-ID: <5452A809.9020207@julianfamily.org>
Date: Thu, 30 Oct 2014 14:05:13 -0700
From: Joe Julian <joe@julianfamily.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: working around acpi dsdt bug
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a flawed bios and MSI refuses to fix it, so I'm trying to work 
around it. I created a repaired version but, even though grub2 loads it 
via the acpi module, the kernel still uses the hardware version.

Am I doing it wrong?

I'm using the fedora build of 3.16.6 (though I've also tried vanilla 
kernels).

The problem I'm trying to solve is that the MSI dsdt's ATRM method 
overruns its buffer (TVGA) producing an ACPI error:

[    3.135241] ACPI Error: Field [TEMP] at 524288 exceeds Buffer [TVGA] 
size 512000 (bits) (20140424/dsopcode-236)
[    3.135295] ACPI Error: Method parse/execution failed 
[\_SB_.PCI0.VGA_.ATRM] (Node ffff880236c35ca8), AE_AML_BUFFER_LIMIT 
(20140424/psparse-536)
[    3.135359] failed to evaluate ATRM got AE_AML_BUFFER_LIMIT

This causes the radeon driver to fail to get the correct vram ranges 
which, in turn, causes dma failures.

This is the bad ACPI code:

         OperationRegion (REVD, SystemMemory, 0x8D79111D, 0x00010004)
         Field (REVD, AnyAcc, NoLock, Preserve)
         {
             SROM,   32,
             VROM,   524288
         }

         Name (TVGA, Buffer (0xFA00)
         {
              0x00                                             /* . */
         })
         Method (ATRM, 2, Serialized)
         {
             Add (Arg0, Arg1, Local0)
             If (LLessEqual (Local0, SROM))
             {
                 Multiply (Arg1, 0x08, Local1)
                 Multiply (Arg0, 0x08, Local2)
                 Store (VROM, TVGA) /* \_SB_.PCI0.VGA_.TVGA */
                 CreateField (TVGA, Local2, Local1, TEMP)
                 Name (RETB, Buffer (Arg1) {})
                 Store (TEMP, RETB) /* \_SB_.PCI0.VGA_.ATRM.RETB */
                 Return (RETB) /* \_SB_.PCI0.VGA_.ATRM.RETB */
             }
             Else
             {
                 If (LLess (Arg0, SROM))
                 {
                     Subtract (SROM, Arg0, Local3)
                     Multiply (Local3, 0x08, Local1)
                     Multiply (Arg0, 0x08, Local2)
                     Store (VROM, TVGA) /* \_SB_.PCI0.VGA_.TVGA */
                     CreateField (TVGA, Local2, Local1, TEM)
                     Name (RETC, Buffer (Local3) {})
                     Store (TEM, RETC) /* \_SB_.PCI0.VGA_.ATRM.RETC */
                     Return (RETC) /* \_SB_.PCI0.VGA_.ATRM.RETC */
                 }
                 Else
                 {
                     Name (RETD, Buffer (One) {})
                     Return (RETD) /* \_SB_.PCI0.VGA_.ATRM.RETD */
                 }
             }
         }

-----------------------

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.16.6-203.fc20.x86_64 (mockbuild@bkernel02.phx2.fedoraproject.org) (gcc version 4.8.3 20140911 (Red Hat 4.8.3-7) (GCC) ) #1 SMP Sat Oct 25 12:44:32 UTC 2014
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.16.6-203.fc20.x86_64 root=/dev/mapper/fedora-root ro rd.lvm.lv=fedora/swap rd.md=0 rd.dm=0 vconsole.keymap=us rd.luks=0 vconsole.font=latarcyrheb-sun16 rd.lvm.lv=fedora/root systemd.unit=multi-user.target
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000008d330fff] usable
[    0.000000] BIOS-e820: [mem 0x000000008d331000-0x000000008d352fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008d353000-0x000000008dbaefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000008dbaf000-0x000000008eb28fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000008eb29000-0x000000008eb29fff] usable
[    0.000000] BIOS-e820: [mem 0x000000008eb2a000-0x000000008ed2ffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000008ed30000-0x000000008ee7ffff] usable
[    0.000000] BIOS-e820: [mem 0x000000008ee80000-0x000000008f440fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000008f441000-0x000000008f480fff] usable
[    0.000000] BIOS-e820: [mem 0x000000008f481000-0x000000008f7f1fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000008f7f2000-0x000000008f7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100001000-0x000000023effffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0x6732f018-0x6733f057] usable ==> usable
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000000100000-0x000000006732f017] usable
[    0.000000] reserve setup_data: [mem 0x000000006732f018-0x000000006733f057] usable
[    0.000000] reserve setup_data: [mem 0x000000006733f058-0x000000008d330fff] usable
[    0.000000] reserve setup_data: [mem 0x000000008d331000-0x000000008d352fff] ACPI data
[    0.000000] reserve setup_data: [mem 0x000000008d353000-0x000000008dbaefff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x000000008dbaf000-0x000000008eb28fff] reserved
[    0.000000] reserve setup_data: [mem 0x000000008eb29000-0x000000008eb29fff] usable
[    0.000000] reserve setup_data: [mem 0x000000008eb2a000-0x000000008ed2ffff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x000000008ed30000-0x000000008ee7ffff] usable
[    0.000000] reserve setup_data: [mem 0x000000008ee80000-0x000000008f440fff] reserved
[    0.000000] reserve setup_data: [mem 0x000000008f441000-0x000000008f480fff] usable
[    0.000000] reserve setup_data: [mem 0x000000008f481000-0x000000008f7f1fff] reserved
[    0.000000] reserve setup_data: [mem 0x000000008f7f2000-0x000000008f7fffff] usable
[    0.000000] reserve setup_data: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fed80000-0x00000000fed8ffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000100001000-0x000000023effffff] usable
[    0.000000] efi: EFI v2.31 by American Megatrends
[    0.000000] efi:  ACPI=0x8d342000  ACPI 2.0=0x8d342000  SMBIOS=0x8ead6918
[    0.000000] efi: mem00: type=7, attr=0xf, range=[0x0000000000000000-0x0000000000001000) (0MB)
[    0.000000] efi: mem01: type=2, attr=0xf, range=[0x0000000000001000-0x0000000000002000) (0MB)
[    0.000000] efi: mem02: type=7, attr=0xf, range=[0x0000000000002000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem03: type=7, attr=0xf, range=[0x0000000000100000-0x0000000001000000) (15MB)
[    0.000000] efi: mem04: type=2, attr=0xf, range=[0x0000000001000000-0x0000000001100000) (1MB)
[    0.000000] efi: mem05: type=7, attr=0xf, range=[0x0000000001100000-0x0000000002000000) (15MB)
[    0.000000] efi: mem06: type=2, attr=0xf, range=[0x0000000002000000-0x000000000342a000) (20MB)
[    0.000000] efi: mem07: type=7, attr=0xf, range=[0x000000000342a000-0x000000003dece000) (938MB)
[    0.000000] efi: mem08: type=2, attr=0xf, range=[0x000000003dece000-0x0000000040000000) (33MB)
[    0.000000] efi: mem09: type=7, attr=0xf, range=[0x0000000040000000-0x000000006732f000) (627MB)
[    0.000000] efi: mem10: type=2, attr=0xf, range=[0x000000006732f000-0x000000008a038000) (557MB)
[    0.000000] efi: mem11: type=7, attr=0xf, range=[0x000000008a038000-0x000000008a03d000) (0MB)
[    0.000000] efi: mem12: type=2, attr=0xf, range=[0x000000008a03d000-0x000000008a208000) (1MB)
[    0.000000] efi: mem13: type=1, attr=0xf, range=[0x000000008a208000-0x000000008a343000) (1MB)
[    0.000000] efi: mem14: type=7, attr=0xf, range=[0x000000008a343000-0x000000008b4f6000) (17MB)
[    0.000000] efi: mem15: type=4, attr=0xf, range=[0x000000008b4f6000-0x000000008b521000) (0MB)
[    0.000000] efi: mem16: type=7, attr=0xf, range=[0x000000008b521000-0x000000008b540000) (0MB)
[    0.000000] efi: mem17: type=4, attr=0xf, range=[0x000000008b540000-0x000000008b546000) (0MB)
[    0.000000] efi: mem18: type=7, attr=0xf, range=[0x000000008b546000-0x000000008b549000) (0MB)
[    0.000000] efi: mem19: type=4, attr=0xf, range=[0x000000008b549000-0x000000008ccce000) (23MB)
[    0.000000] efi: mem20: type=7, attr=0xf, range=[0x000000008ccce000-0x000000008d02d000) (3MB)
[    0.000000] efi: mem21: type=3, attr=0xf, range=[0x000000008d02d000-0x000000008d2ce000) (2MB)
[    0.000000] efi: mem22: type=7, attr=0xf, range=[0x000000008d2ce000-0x000000008d331000) (0MB)
[    0.000000] efi: mem23: type=9, attr=0xf, range=[0x000000008d331000-0x000000008d353000) (0MB)
[    0.000000] efi: mem24: type=10, attr=0xf, range=[0x000000008d353000-0x000000008d705000) (3MB)
[    0.000000] efi: mem25: type=10, attr=0xf, range=[0x000000008d705000-0x000000008dbaf000) (4MB)
[    0.000000] efi: mem26: type=6, attr=0x800000000000000f, range=[0x000000008dbaf000-0x000000008e7e6000) (12MB)
[    0.000000] efi: mem27: type=6, attr=0x800000000000000f, range=[0x000000008e7e6000-0x000000008ea14000) (2MB)
[    0.000000] efi: mem28: type=6, attr=0x800000000000000f, range=[0x000000008ea14000-0x000000008ea17000) (0MB)
[    0.000000] efi: mem29: type=6, attr=0x800000000000000f, range=[0x000000008ea17000-0x000000008ead8000) (0MB)
[    0.000000] efi: mem30: type=5, attr=0x800000000000000f, range=[0x000000008ead8000-0x000000008eae8000) (0MB)
[    0.000000] efi: mem31: type=5, attr=0x800000000000000f, range=[0x000000008eae8000-0x000000008eb29000) (0MB)
[    0.000000] efi: mem32: type=4, attr=0xf, range=[0x000000008eb29000-0x000000008eb2a000) (0MB)
[    0.000000] efi: mem33: type=10, attr=0xf, range=[0x000000008eb2a000-0x000000008ed30000) (2MB)
[    0.000000] efi: mem34: type=4, attr=0xf, range=[0x000000008ed30000-0x000000008ee80000) (1MB)
[    0.000000] efi: mem35: type=6, attr=0x800000000000000f, range=[0x000000008ee80000-0x000000008f441000) (5MB)
[    0.000000] efi: mem36: type=4, attr=0xf, range=[0x000000008f441000-0x000000008f45a000) (0MB)
[    0.000000] efi: mem37: type=3, attr=0xf, range=[0x000000008f45a000-0x000000008f474000) (0MB)
[    0.000000] efi: mem38: type=4, attr=0xf, range=[0x000000008f474000-0x000000008f475000) (0MB)
[    0.000000] efi: mem39: type=3, attr=0xf, range=[0x000000008f475000-0x000000008f477000) (0MB)
[    0.000000] efi: mem40: type=4, attr=0xf, range=[0x000000008f477000-0x000000008f481000) (0MB)
[    0.000000] efi: mem41: type=6, attr=0x800000000000000f, range=[0x000000008f481000-0x000000008f7f2000) (3MB)
[    0.000000] efi: mem42: type=4, attr=0xf, range=[0x000000008f7f2000-0x000000008f800000) (0MB)
[    0.000000] efi: mem43: type=7, attr=0xf, range=[0x0000000100001000-0x000000023f000000) (5103MB)
[    0.000000] efi: mem44: type=11, attr=0x8000000000000001, range=[0x00000000fec00000-0x00000000fec01000) (0MB)
[    0.000000] efi: mem45: type=11, attr=0x8000000000000001, range=[0x00000000fec10000-0x00000000fec11000) (0MB)
[    0.000000] efi: mem46: type=11, attr=0x8000000000000001, range=[0x00000000fed00000-0x00000000fed01000) (0MB)
[    0.000000] efi: mem47: type=11, attr=0x8000000000000001, range=[0x00000000fed80000-0x00000000fed81000) (0MB)
[    0.000000] efi: mem48: type=11, attr=0x8000000000000001, range=[0x00000000fed81000-0x00000000fed90000) (0MB)
[    0.000000] efi: mem49: type=11, attr=0x8000000000000001, range=[0x00000000ff000000-0x0000000100000000) (16MB)
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Micro-Star International Co., Ltd. GX70 3BE/MS-176K, BIOS E176KAMS.70F 12/02/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x23f000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFF0000000 write-back
[    0.000000]   2 base 00008F800000 mask FFFFFF800000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 000000023f000000 aka 9200M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0x8f800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0x8f800 max_arch_pfn = 0x400000000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03006000, 0x03006fff] PGTABLE
[    0.000000] BRK [0x03007000, 0x03007fff] PGTABLE
[    0.000000] BRK [0x03008000, 0x03008fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x23ee00000-0x23effffff]
[    0.000000]  [mem 0x23ee00000-0x23effffff] page 2M
[    0.000000] BRK [0x03009000, 0x03009fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x23c000000-0x23edfffff]
[    0.000000]  [mem 0x23c000000-0x23edfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x23bffffff]
[    0.000000]  [mem 0x200000000-0x23bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x8d330fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0x8d1fffff] page 2M
[    0.000000]  [mem 0x8d200000-0x8d330fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x8eb29000-0x8eb29fff]
[    0.000000]  [mem 0x8eb29000-0x8eb29fff] page 4k
[    0.000000] BRK [0x0300a000, 0x0300afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x8ed30000-0x8ee7ffff]
[    0.000000]  [mem 0x8ed30000-0x8ee7ffff] page 4k
[    0.000000] BRK [0x0300b000, 0x0300bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x8f441000-0x8f480fff]
[    0.000000]  [mem 0x8f441000-0x8f480fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x8f7f2000-0x8f7fffff]
[    0.000000]  [mem 0x8f7f2000-0x8f7fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100001000-0x1ffffffff]
[    0.000000]  [mem 0x100001000-0x1001fffff] page 4k
[    0.000000]  [mem 0x100200000-0x13fffffff] page 2M
[    0.000000]  [mem 0x140000000-0x1ffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x3dece000-0x3ebd0fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000000008D342000 000024 (v02 MSI_NB)
[    0.000000] ACPI: XSDT 0x000000008D342080 000084 (v01 MSI_NB MEGABOOK 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x000000008D34AB68 00010C (v05 MSI_NB MEGABOOK 01072009 AMI  00010013)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20140424/tbfadt-649)
[    0.000000] ACPI: DSDT 0x000000008D342198 0089CE (v02 MSI_NB MEGABOOK 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 0x000000008DBA5080 000040
[    0.000000] ACPI: APIC 0x000000008D34AC78 000072 (v03 MSI_NB MEGABOOK 01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x000000008D34ACF0 000044 (v01 MSI_NB MEGABOOK 01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x000000008D34AD38 00003C (v01 MSI_NB MEGABOOK 01072009 MSFT 00010013)
[    0.000000] ACPI: MSDM 0x000000008D34AD78 000055 (v03 MSI_NB MEGABOOK 01072009 AMI  00010013)
[    0.000000] ACPI: SLIC 0x000000008D34ADD0 000176 (v01 MSI_NB MEGABOOK 01072009 AMI  00010013)
[    0.000000] ACPI: HPET 0x000000008D34AF48 000038 (v01 MSI_NB MEGABOOK 01072009 AMI  00000005)
[    0.000000] ACPI: MSFF 0x000000008D34AF80 000029 (v01 MSI_NB MEGABOOK 00000010 AMI  00010013)
[    0.000000] ACPI: VFCT 0x000000008D34AFB0 005084 (v01 MSI_NB MEGABOOK 00000001 AMD  31504F47)
[    0.000000] ACPI: SSDT 0x000000008D350038 000A9C (v01 AMD    PUMORI   00000001 AMD  00000001)
[    0.000000] ACPI: SSDT 0x000000008D350AD8 001F6E (v02 AMD    PUMORI   00000001 MSFT 04000000)
[    0.000000] ACPI: CRAT 0x000000008D352A48 0002A8 (v01 AMD    PUMORI   00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000023effffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x23effffff]
[    0.000000]   NODE_DATA [mem 0x23efe5000-0x23eff8fff]
[    0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff880237200000-ffff88023e5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x23effffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009ffff]
[    0.000000]   node   0: [mem 0x00100000-0x8d330fff]
[    0.000000]   node   0: [mem 0x8eb29000-0x8eb29fff]
[    0.000000]   node   0: [mem 0x8ed30000-0x8ee7ffff]
[    0.000000]   node   0: [mem 0x8f441000-0x8f480fff]
[    0.000000]   node   0: [mem 0x8f7f2000-0x8f7fffff]
[    0.000000]   node   0: [mem 0x100001000-0x23effffff]
[    0.000000] On node 0 totalpages: 1885294
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 22 pages reserved
[    0.000000]   DMA zone: 3999 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 8980 pages used for memmap
[    0.000000]   DMA32 zone: 574672 pages, LIFO batch:31
[    0.000000]   Normal zone: 20416 pages used for memmap
[    0.000000]   Normal zone: 1306623 pages, LIFO batch:31
[    0.000000] tboot: non-0 tboot_addr but it is not of type E820_RESERVED
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x05] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 5, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10228210 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x6732f000-0x6732ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x6733f000-0x6733ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x8d331000-0x8d352fff]
[    0.000000] PM: Registered nosave memory: [mem 0x8d353000-0x8dbaefff]
[    0.000000] PM: Registered nosave memory: [mem 0x8dbaf000-0x8eb28fff]
[    0.000000] PM: Registered nosave memory: [mem 0x8eb2a000-0x8ed2ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x8ee80000-0x8f440fff]
[    0.000000] PM: Registered nosave memory: [mem 0x8f481000-0x8f7f1fff]
[    0.000000] PM: Registered nosave memory: [mem 0x8f800000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfec0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec10000-0xfec10fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec11000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed01000-0xfed7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed80000-0xfed8ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed90000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x100000000-0x100000fff]
[    0.000000] e820: [mem 0x8f800000-0xfebfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:1024 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88023ec00000 s86784 r8192 d23808 u524288
[    0.000000] pcpu-alloc: s86784 r8192 d23808 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1855812
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.16.6-203.fc20.x86_64 root=/dev/mapper/fedora-root ro rd.lvm.lv=fedora/swap rd.md=0 rd.dm=0 vconsole.keymap=us rd.luks=0 vconsole.font=latarcyrheb-sun16 rd.lvm.lv=fedora/root systemd.unit=multi-user.target
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Memory: 7296968K/7541176K available (7249K kernel code, 1128K rwdata, 3136K rodata, 1456K init, 1496K bss, 244208K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=1024 to nr_cpu_ids=4.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:65792 nr_irqs:712 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 30408704 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2495.310 MHz processor
[    0.000025] Calibrating delay loop (skipped), value calculated using timer frequency.. 4990.62 BogoMIPS (lpj=2495310)
[    0.000030] pid_max: default: 32768 minimum: 301
[    0.000041] ACPI: Core revision 20140424
[    0.005807] ACPI: All ACPI Tables successfully acquired
[    0.006862] Security Framework initialized
[    0.006875] SELinux:  Initializing.
[    0.006883] SELinux:  Starting in permissive mode
[    0.007580] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.010194] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.011347] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.011364] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.011652] Initializing cgroup subsys memory
[    0.011680] Initializing cgroup subsys devices
[    0.011687] Initializing cgroup subsys freezer
[    0.011692] Initializing cgroup subsys net_cls
[    0.011697] Initializing cgroup subsys blkio
[    0.011702] Initializing cgroup subsys perf_event
[    0.011705] Initializing cgroup subsys net_prio
[    0.011713] Initializing cgroup subsys hugetlb
[    0.011734] [Firmware Info]: CPU: Re-enabling disabled Topology Extensions Support.
[    0.011740] tseg: 008f800000
[    0.011742] CPU: Physical Processor ID: 0
[    0.011744] CPU: Processor Core ID: 0
[    0.011746] mce: CPU supports 7 MCE banks
[    0.011759] Last level iTLB entries: 4KB 512, 2MB 1024, 4MB 512
Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 512, 1GB 0
tlb_flushall_shift: 6
[    0.011857] Freeing SMP alternatives memory: 24K (ffffffff81e88000 - ffffffff81e8e000)
[    0.013804] ftrace: allocating 26727 entries in 105 pages
[    0.022985] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.032985] smpboot: CPU0: AMD A10-5750M APU with Radeon(tm) HD Graphics (fam: 15, model: 13, stepping: 01)
[    0.134703] Performance Events: Fam15h core perfctr, AMD PMU driver.
[    0.134711] ... version:                0
[    0.134714] ... bit width:              48
[    0.134716] ... generic registers:      6
[    0.134718] ... value mask:             0000ffffffffffff
[    0.134720] ... max period:             00007fffffffffff
[    0.134723] ... fixed-purpose events:   0
[    0.134725] ... event mask:             000000000000003f
[    0.136209] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.136302] x86: Booting SMP configuration:
[    0.136305] .... node  #0, CPUs:      #1
[    0.147325] [Firmware Info]: CPU: Re-enabling disabled Topology Extensions Support.
[    0.149543]  #2
[    0.160565] [Firmware Info]: CPU: Re-enabling disabled Topology Extensions Support.
[    0.173757]  #3
[    0.173757] [Firmware Info]: CPU: Re-enabling disabled Topology Extensions Support.
[    0.175860] x86: Booted up 1 node, 4 CPUs
[    0.175869] smpboot: Total of 4 processors activated (19962.48 BogoMIPS)
[    0.176765] devtmpfs: initialized
[    0.180047] PM: Registering ACPI NVS region [mem 0x8d353000-0x8dbaefff] (8765440 bytes)
[    0.180233] PM: Registering ACPI NVS region [mem 0x8eb2a000-0x8ed2ffff] (2121728 bytes)
[    0.181303] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.181307] pinctrl core: initialized pinctrl subsystem
[    0.181344] RTC time: 19:17:36, date: 10/29/14
[    0.181400] NET: Registered protocol family 16
[    0.181551] cpuidle: using governor menu
[    0.181751] ACPI: bus type PCI registered
[    0.181754] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.181838] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.181844] PCI: not using MMCONFIG
[    0.181847] PCI: Using configuration type 1 for base access
[    0.181850] PCI: Using configuration type 1 for extended access
[    0.186328] ACPI: Added _OSI(Module Device)
[    0.186335] ACPI: Added _OSI(Processor Device)
[    0.186338] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.186341] ACPI: Added _OSI(Processor Aggregator Device)
[    0.188351] ACPI Error: No handler for Region [EC__] (ffff880236c23c18) [EmbeddedControl] (20140424/evregion-163)
[    0.188359] ACPI Error: Region EmbeddedControl (ID=3) has no handler (20140424/exfldio-299)
[    0.188368] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SBRG.EC__.EOSV] (Node ffff880236c29fa0), AE_NOT_EXIST (20140424/psparse-536)
[    0.188378] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SBRG.EC__._REG] (Node ffff880236c29fc8), AE_NOT_EXIST (20140424/psparse-536)
[    0.189104] ACPI: Executed 1 blocks of module-level executable AML code
[    0.200289] ACPI: Interpreter enabled
[    0.200298] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140424/hwxface-580)
[    0.200306] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140424/hwxface-580)
[    0.200327] ACPI: (supports S0 S3 S4 S5)
[    0.200330] ACPI: Using IOAPIC for interrupt routing
[    0.200355] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.200419] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.200812] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.232053] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.232065] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.232298] acpi PNP0A03:00: _OSC: platform does not support [PME]
[    0.232519] acpi PNP0A03:00: _OSC: OS now controls [PCIeHotplug AER PCIeCapability]
[    0.233056] PCI host bridge to bus 0000:00
[    0.233060] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.233064] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    0.233068] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    0.233072] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
[    0.233076] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.233079] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.233083] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.233087] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xffffffff]
[    0.233096] pci 0000:00:00.0: [1022:1410] type 00 class 0x060000
[    0.233212] pci 0000:00:01.0: [1002:990b] type 00 class 0x030000
[    0.233222] pci 0000:00:01.0: reg 0x10: [mem 0xc0000000-0xcfffffff pref]
[    0.233227] pci 0000:00:01.0: reg 0x14: [io  0xf000-0xf0ff]
[    0.233233] pci 0000:00:01.0: reg 0x18: [mem 0xfeb00000-0xfeb3ffff]
[    0.233268] pci 0000:00:01.0: supports D1 D2
[    0.233363] pci 0000:00:01.1: [1002:9902] type 00 class 0x040300
[    0.233370] pci 0000:00:01.1: reg 0x10: [mem 0xfeb44000-0xfeb47fff]
[    0.233409] pci 0000:00:01.1: supports D1 D2
[    0.233495] pci 0000:00:03.0: [1022:1413] type 01 class 0x060400
[    0.233538] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.233660] pci 0000:00:10.0: [1022:7814] type 00 class 0x0c0330
[    0.233681] pci 0000:00:10.0: reg 0x10: [mem 0xfeb4a000-0xfeb4bfff 64bit]
[    0.233776] pci 0000:00:10.0: PME# supported from D0 D3hot D3cold
[    0.233841] pci 0000:00:10.0: System wakeup disabled by ACPI
[    0.233900] pci 0000:00:10.1: [1022:7814] type 00 class 0x0c0330
[    0.233921] pci 0000:00:10.1: reg 0x10: [mem 0xfeb48000-0xfeb49fff 64bit]
[    0.234015] pci 0000:00:10.1: PME# supported from D0 D3hot D3cold
[    0.234078] pci 0000:00:10.1: System wakeup disabled by ACPI
[    0.234133] pci 0000:00:11.0: [1022:7800] type 00 class 0x01018f
[    0.234148] pci 0000:00:11.0: reg 0x10: [io  0xf190-0xf197]
[    0.234156] pci 0000:00:11.0: reg 0x14: [io  0xf180-0xf183]
[    0.234164] pci 0000:00:11.0: reg 0x18: [io  0xf170-0xf177]
[    0.234172] pci 0000:00:11.0: reg 0x1c: [io  0xf160-0xf163]
[    0.234181] pci 0000:00:11.0: reg 0x20: [io  0xf150-0xf15f]
[    0.234189] pci 0000:00:11.0: reg 0x24: [mem 0xfeb51000-0xfeb517ff]
[    0.234206] pci 0000:00:11.0: set SATA to AHCI mode
[    0.234309] pci 0000:00:12.0: [1022:7807] type 00 class 0x0c0310
[    0.234323] pci 0000:00:12.0: reg 0x10: [mem 0xfeb50000-0xfeb50fff]
[    0.234426] pci 0000:00:12.0: System wakeup disabled by ACPI
[    0.234477] pci 0000:00:12.2: [1022:7808] type 00 class 0x0c0320
[    0.234493] pci 0000:00:12.2: reg 0x10: [mem 0xfeb4f000-0xfeb4f0ff]
[    0.234562] pci 0000:00:12.2: supports D1 D2
[    0.234564] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.234620] pci 0000:00:12.2: System wakeup disabled by ACPI
[    0.234670] pci 0000:00:13.0: [1022:7807] type 00 class 0x0c0310
[    0.234682] pci 0000:00:13.0: reg 0x10: [mem 0xfeb4e000-0xfeb4efff]
[    0.234776] pci 0000:00:13.0: System wakeup disabled by ACPI
[    0.234835] pci 0000:00:13.2: [1022:7808] type 00 class 0x0c0320
[    0.234852] pci 0000:00:13.2: reg 0x10: [mem 0xfeb4d000-0xfeb4d0ff]
[    0.234921] pci 0000:00:13.2: supports D1 D2
[    0.234922] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.234977] pci 0000:00:13.2: System wakeup disabled by ACPI
[    0.235026] pci 0000:00:14.0: [1022:780b] type 00 class 0x0c0500
[    0.235144] pci 0000:00:14.1: [1022:780c] type 00 class 0x01018a
[    0.235154] pci 0000:00:14.1: reg 0x10: [io  0xf140-0xf147]
[    0.235160] pci 0000:00:14.1: reg 0x14: [io  0xf130-0xf133]
[    0.235166] pci 0000:00:14.1: reg 0x18: [io  0xf120-0xf127]
[    0.235173] pci 0000:00:14.1: reg 0x1c: [io  0xf110-0xf113]
[    0.235179] pci 0000:00:14.1: reg 0x20: [io  0xf100-0xf10f]
[    0.235193] pci 0000:00:14.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.235196] pci 0000:00:14.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.235200] pci 0000:00:14.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.235204] pci 0000:00:14.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.235293] pci 0000:00:14.2: [1022:780d] type 00 class 0x040300
[    0.235312] pci 0000:00:14.2: reg 0x10: [mem 0xfeb40000-0xfeb43fff 64bit]
[    0.235372] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.235465] pci 0000:00:14.3: [1022:780e] type 00 class 0x060100
[    0.235603] pci 0000:00:14.4: [1022:780f] type 01 class 0x060401
[    0.235679] pci 0000:00:14.4: System wakeup disabled by ACPI
[    0.235726] pci 0000:00:14.7: [1022:7806] type 00 class 0x080501
[    0.235739] pci 0000:00:14.7: reg 0x10: [mem 0xfeb4c000-0xfeb4c0ff 64bit]
[    0.235853] pci 0000:00:15.0: [1022:43a0] type 01 class 0x060400
[    0.235920] pci 0000:00:15.0: supports D1 D2
[    0.235977] pci 0000:00:15.0: System wakeup disabled by ACPI
[    0.236026] pci 0000:00:15.1: [1022:43a1] type 01 class 0x060400
[    0.236092] pci 0000:00:15.1: supports D1 D2
[    0.236148] pci 0000:00:15.1: System wakeup disabled by ACPI
[    0.236199] pci 0000:00:18.0: [1022:1400] type 00 class 0x060000
[    0.236289] pci 0000:00:18.1: [1022:1401] type 00 class 0x060000
[    0.236379] pci 0000:00:18.2: [1022:1402] type 00 class 0x060000
[    0.236467] pci 0000:00:18.3: [1022:1403] type 00 class 0x060000
[    0.236557] pci 0000:00:18.4: [1022:1404] type 00 class 0x060000
[    0.236644] pci 0000:00:18.5: [1022:1405] type 00 class 0x060000
[    0.236816] pci 0000:01:00.0: [1002:6801] type 00 class 0x030000
[    0.236832] pci 0000:01:00.0: reg 0x10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.236842] pci 0000:01:00.0: reg 0x18: [mem 0xfea00000-0xfea3ffff 64bit]
[    0.236849] pci 0000:01:00.0: reg 0x20: [io  0xe000-0xe0ff]
[    0.236860] pci 0000:01:00.0: reg 0x30: [mem 0xfea40000-0xfea5ffff pref]
[    0.236921] pci 0000:01:00.0: supports D1 D2
[    0.236923] pci 0000:01:00.0: PME# supported from D1 D2 D3hot
[    0.238705] pci 0000:00:03.0: PCI bridge to [bus 01]
[    0.238718] pci 0000:00:03.0:   bridge window [io  0xe000-0xefff]
[    0.238721] pci 0000:00:03.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.238726] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.238833] pci 0000:00:14.4: PCI bridge to [bus 02] (subtractive decode)
[    0.238844] pci 0000:00:14.4:   bridge window [io  0x0000-0x03af] (subtractive decode)
[    0.238846] pci 0000:00:14.4:   bridge window [io  0x03e0-0x0cf7] (subtractive decode)
[    0.238848] pci 0000:00:14.4:   bridge window [io  0x03b0-0x03df] (subtractive decode)
[    0.238850] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.238852] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.238853] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.238855] pci 0000:00:14.4:   bridge window [mem 0xc0000000-0xffffffff] (subtractive decode)
[    0.238933] pci 0000:03:00.0: [1969:e091] type 00 class 0x020000
[    0.238962] pci 0000:03:00.0: reg 0x10: [mem 0xfe900000-0xfe93ffff 64bit]
[    0.238974] pci 0000:03:00.0: reg 0x18: [io  0xd000-0xd07f]
[    0.239089] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.240704] pci 0000:00:15.0: PCI bridge to [bus 03]
[    0.240717] pci 0000:00:15.0:   bridge window [io  0xd000-0xdfff]
[    0.240722] pci 0000:00:15.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    0.240831] pci 0000:04:00.0: [10ec:8723] type 00 class 0x028000
[    0.240854] pci 0000:04:00.0: reg 0x10: [io  0xc000-0xc0ff]
[    0.240880] pci 0000:04:00.0: reg 0x18: [mem 0xfe800000-0xfe803fff 64bit]
[    0.240987] pci 0000:04:00.0: supports D1 D2
[    0.240989] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.242701] pci 0000:00:15.1: PCI bridge to [bus 04]
[    0.242715] pci 0000:00:15.1:   bridge window [io  0xc000-0xcfff]
[    0.242720] pci 0000:00:15.1:   bridge window [mem 0xfe800000-0xfe8fffff]
[    0.246711] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 5 7 10 11 14 15) *0
[    0.246797] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 5 7 10 11 14 15) *0
[    0.246882] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 5 7 10 11 14 15) *0
[    0.246964] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 5 7 10 11 14 15) *0
[    0.247033] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 5 7 10 11 14 15) *0
[    0.247088] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 7 10 11 14 15) *0
[    0.247143] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 5 7 10 11 14 15) *0
[    0.247197] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 7 10 11 14 15) *0
[    0.247407] ACPI : EC: GPE = 0x3, I/O: command/status = 0x66, data = 0x62
[    0.247538] vgaarb: setting as boot device: PCI:0000:00:01.0
[    0.247542] vgaarb: device added: PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.247553] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
[    0.247557] vgaarb: loaded
[    0.247559] vgaarb: bridge control possible 0000:01:00.0
[    0.247562] vgaarb: no bridge control possible 0000:00:01.0
[    0.247662] SCSI subsystem initialized
[    0.247735] libata version 3.00 loaded.
[    0.247771] ACPI: bus type USB registered
[    0.247800] usbcore: registered new interface driver usbfs
[    0.247815] usbcore: registered new interface driver hub
[    0.247845] usbcore: registered new device driver usb
[    0.247988] PCI: Using ACPI for IRQ routing
[    0.255088] PCI: pci_cache_line_size set to 64 bytes
[    0.255151] e820: reserve RAM buffer [mem 0x6732f018-0x67ffffff]
[    0.255153] e820: reserve RAM buffer [mem 0x8d331000-0x8fffffff]
[    0.255155] e820: reserve RAM buffer [mem 0x8eb2a000-0x8fffffff]
[    0.255157] e820: reserve RAM buffer [mem 0x8ee80000-0x8fffffff]
[    0.255158] e820: reserve RAM buffer [mem 0x8f481000-0x8fffffff]
[    0.255159] e820: reserve RAM buffer [mem 0x8f800000-0x8fffffff]
[    0.255161] e820: reserve RAM buffer [mem 0x23f000000-0x23fffffff]
[    0.255287] NetLabel: Initializing
[    0.255290] NetLabel:  domain hash size = 128
[    0.255292] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.255316] NetLabel:  unlabeled traffic allowed by default
[    0.255400] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.255405] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.257460] Switched to clocksource hpet
[    0.266254] pnp: PnP ACPI init
[    0.266278] ACPI: bus type PNP registered
[    0.266423] system 00:00: [mem 0xe0000000-0xefffffff] has been reserved
[    0.266429] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.266491] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.266540] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.266608] system 00:03: [io  0x04d0-0x04d1] has been reserved
[    0.266613] system 00:03: [io  0x034d-0x034f] has been reserved
[    0.266617] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.266668] pnp 00:04: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.266727] pnp 00:05: Plug and Play ACPI device, IDs ETD0300 PNP0f13 (active)
[    0.270482] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.270487] system 00:06: [io  0x040b] has been reserved
[    0.270491] system 00:06: [io  0x04d6] has been reserved
[    0.270494] system 00:06: [io  0x0c00-0x0c01] has been reserved
[    0.270498] system 00:06: [io  0x0c14] has been reserved
[    0.270502] system 00:06: [io  0x0c50-0x0c51] has been reserved
[    0.270506] system 00:06: [io  0x0c52] has been reserved
[    0.270509] system 00:06: [io  0x0c6c] has been reserved
[    0.270513] system 00:06: [io  0x0c6f] has been reserved
[    0.270516] system 00:06: [io  0x0cd0-0x0cd1] has been reserved
[    0.270520] system 00:06: [io  0x0cd2-0x0cd3] has been reserved
[    0.270523] system 00:06: [io  0x0cd4-0x0cd5] has been reserved
[    0.270527] system 00:06: [io  0x0cd6-0x0cd7] has been reserved
[    0.270531] system 00:06: [io  0x0cd8-0x0cdf] has been reserved
[    0.270535] system 00:06: [io  0x0800-0x089f] could not be reserved
[    0.270539] system 00:06: [io  0x0b20-0x0b3f] has been reserved
[    0.270542] system 00:06: [io  0x0900-0x090f] has been reserved
[    0.270546] system 00:06: [io  0x0910-0x091f] has been reserved
[    0.270550] system 00:06: [io  0xfe00-0xfefe] has been reserved
[    0.270555] system 00:06: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.270559] system 00:06: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.270563] system 00:06: [mem 0xfed80000-0xfed8ffff] has been reserved
[    0.270567] system 00:06: [mem 0xfed61000-0xfed70fff] has been reserved
[    0.270571] system 00:06: [mem 0xfec10000-0xfec10fff] has been reserved
[    0.270576] system 00:06: [mem 0xfed00000-0xfed00fff] could not be reserved
[    0.270580] system 00:06: [mem 0xff000000-0xffffffff] has been reserved
[    0.270585] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.270726] system 00:07: [mem 0x90000000-0xbfffffff] has been reserved
[    0.270731] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.270926] pnp: PnP ACPI: found 8 devices
[    0.270928] ACPI: bus type PNP unregistered
[    0.277812] pci 0000:00:03.0: PCI bridge to [bus 01]
[    0.277818] pci 0000:00:03.0:   bridge window [io  0xe000-0xefff]
[    0.277823] pci 0000:00:03.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.277828] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.277834] pci 0000:00:14.4: PCI bridge to [bus 02]
[    0.277845] pci 0000:00:15.0: PCI bridge to [bus 03]
[    0.277849] pci 0000:00:15.0:   bridge window [io  0xd000-0xdfff]
[    0.277855] pci 0000:00:15.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    0.277863] pci 0000:00:15.1: PCI bridge to [bus 04]
[    0.277867] pci 0000:00:15.1:   bridge window [io  0xc000-0xcfff]
[    0.277872] pci 0000:00:15.1:   bridge window [mem 0xfe800000-0xfe8fffff]
[    0.277881] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
[    0.277883] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
[    0.277884] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df]
[    0.277886] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff]
[    0.277888] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
[    0.277889] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff]
[    0.277891] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xffffffff]
[    0.277893] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.277895] pci_bus 0000:01: resource 1 [mem 0xfea00000-0xfeafffff]
[    0.277896] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.277898] pci_bus 0000:02: resource 4 [io  0x0000-0x03af]
[    0.277900] pci_bus 0000:02: resource 5 [io  0x03e0-0x0cf7]
[    0.277901] pci_bus 0000:02: resource 6 [io  0x03b0-0x03df]
[    0.277903] pci_bus 0000:02: resource 7 [io  0x0d00-0xffff]
[    0.277904] pci_bus 0000:02: resource 8 [mem 0x000a0000-0x000bffff]
[    0.277906] pci_bus 0000:02: resource 9 [mem 0x000c0000-0x000dffff]
[    0.277907] pci_bus 0000:02: resource 10 [mem 0xc0000000-0xffffffff]
[    0.277909] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.277910] pci_bus 0000:03: resource 1 [mem 0xfe900000-0xfe9fffff]
[    0.277912] pci_bus 0000:04: resource 0 [io  0xc000-0xcfff]
[    0.277914] pci_bus 0000:04: resource 1 [mem 0xfe800000-0xfe8fffff]
[    0.277942] NET: Registered protocol family 2
[    0.278203] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    0.278474] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.278745] TCP: Hash tables configured (established 65536 bind 65536)
[    0.278788] TCP: reno registered
[    0.278805] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.278860] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.278963] NET: Registered protocol family 1
[    0.278983] pci 0000:00:01.0: Video device with shadowed ROM
[    0.280240] pci 0000:03:00.0: set MSI_INTX_DISABLE_BUG flag
[    0.280248] PCI: CLS 64 bytes, default 64
[    0.280320] Unpacking initramfs...
[    0.475444] Freeing initrd memory: 13324K (ffff88003dece000 - ffff88003ebd1000)
[    0.475461] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.475466] software IO TLB [mem 0x8603d000-0x8a03d000] (64MB) mapped at [ffff88008603d000-ffff88008a03cfff]
[    0.475780] perf: AMD NB counters detected
[    0.475808] LVT offset 0 assigned for vector 0x400
[    0.475823] perf: AMD IBS detected (0x000000ff)
[    0.476443] AVX version of gcm_enc/dec engaged.
[    0.478967] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    0.479485] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.479513] Initialise system trusted keyring
[    0.479536] audit: initializing netlink subsys (disabled)
[    0.479558] audit: type=2000 audit(1414610256.370:1): initialized
[    0.480037] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.482010] zbud: loaded
[    0.482299] VFS: Disk quotas dquot_6.5.2
[    0.482343] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.482790] msgmni has been set to 14333
[    0.482856] Key type big_key registered
[    0.482860] SELinux:  Registering netfilter hooks
[    0.484087] alg: No test for stdrng (krng)
[    0.484099] NET: Registered protocol family 38
[    0.484107] Key type asymmetric registered
[    0.484111] Asymmetric key parser 'x509' registered
[    0.484159] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.484222] io scheduler noop registered
[    0.484226] io scheduler deadline registered
[    0.484298] io scheduler cfq registered (default)
[    0.484577] pcieport 0000:00:03.0: irq 40 for MSI/MSI-X
[    0.484908] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.484951] pciehp 0000:00:03.0:pcie04: Slot #0 AttnBtn- AttnInd- PwrInd- PwrCtrl- MRL- Interlock- NoCompl+ LLActRep+
[    0.485004] pciehp 0000:00:03.0:pcie04: service driver pciehp loaded
[    0.485009] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.485080] efifb: probing for efifb
[    0.485105] efifb: framebuffer at 0xc0000000, mapped to 0xffffc90010f00000, using 8100k, total 8100k
[    0.485109] efifb: mode is 1920x1080x32, linelength=7680, pages=1
[    0.485112] efifb: scrolling: redraw
[    0.485115] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.489509] Console: switching to colour frame buffer device 240x67
[    0.493488] fb0: EFI VGA frame buffer device
[    0.500219] ACPI: AC Adapter [ADP1] (on-line)
[    0.502447] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:07/PNP0C09:00/PNP0C0D:00/input/input0
[    0.509123] ACPI: Lid Switch [LID0]
[    0.509194] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    0.509227] ACPI: Power Button [PWRB]
[    0.509305] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.509336] ACPI: Power Button [PWRF]
[    0.509439] ACPI: acpi_idle registered with cpuidle
[    0.520652] thermal LNXTHERM:00: registered as thermal_zone0
[    0.520675] ACPI: Thermal Zone [THRM] (63 C)
[    0.520730] GHES: HEST is not enabled!
[    0.520836] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.521514] Non-volatile memory driver v1.3
[    0.521533] Linux agpgart interface v0.103
[    0.521934] ahci 0000:00:11.0: version 3.0
[    0.521940] ahci 0000:00:11.0: enabling device (0005 -> 0007)
[    0.522136] ahci 0000:00:11.0: AHCI 0001.0300 32 slots 2 ports 3 Gbps 0xc impl SATA mode
[    0.522168] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part
[    0.522807] scsi0 : ahci
[    0.522985] scsi1 : ahci
[    0.523127] scsi2 : ahci
[    0.523254] scsi3 : ahci
[    0.523318] ata1: DUMMY
[    0.523329] ata2: DUMMY
[    0.523341] ata3: SATA max UDMA/133 abar m2048@0xfeb51000 port 0xfeb51200 irq 19
[    0.523370] ata4: SATA max UDMA/133 abar m2048@0xfeb51000 port 0xfeb51280 irq 19
[    0.523527] libphy: Fixed MDIO Bus: probed
[    0.523628] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.523657] ehci-pci: EHCI PCI platform driver
[    0.523802] QUIRK: Enable AMD PLL fix
[    0.523819] ehci-pci 0000:00:12.2: EHCI Host Controller
[    0.523891] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus number 1
[    0.523923] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    0.523963] ehci-pci 0000:00:12.2: debug port 1
[    0.524017] ehci-pci 0000:00:12.2: irq 17, io mem 0xfeb4f000
[    0.529350] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    0.529456] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.529483] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.529511] usb usb1: Product: EHCI Host Controller
[    0.530621] usb usb1: Manufacturer: Linux 3.16.6-203.fc20.x86_64 ehci_hcd
[    0.531731] usb usb1: SerialNumber: 0000:00:12.2
[    0.533012] hub 1-0:1.0: USB hub found
[    0.534114] hub 1-0:1.0: 5 ports detected
[    0.535571] ehci-pci 0000:00:13.2: EHCI Host Controller
[    0.536743] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus number 2
[    0.537857] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    0.538991] ehci-pci 0000:00:13.2: debug port 1
[    0.540137] ehci-pci 0000:00:13.2: irq 17, io mem 0xfeb4d000
[    0.547308] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    0.548491] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.549593] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.550715] usb usb2: Product: EHCI Host Controller
[    0.551827] usb usb2: Manufacturer: Linux 3.16.6-203.fc20.x86_64 ehci_hcd
[    0.552947] usb usb2: SerialNumber: 0000:00:13.2
[    0.554236] hub 2-0:1.0: USB hub found
[    0.555336] hub 2-0:1.0: 5 ports detected
[    0.556600] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.557697] ohci-pci: OHCI PCI platform driver
[    0.558936] ohci-pci 0000:00:12.0: OHCI PCI host controller
[    0.560068] ohci-pci 0000:00:12.0: new USB bus registered, assigned bus number 3
[    0.561178] ohci-pci 0000:00:12.0: irq 18, io mem 0xfeb50000
[    0.617345] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.618360] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.619350] usb usb3: Product: OHCI PCI host controller
[    0.620333] usb usb3: Manufacturer: Linux 3.16.6-203.fc20.x86_64 ohci_hcd
[    0.621325] usb usb3: SerialNumber: 0000:00:12.0
[    0.622508] hub 3-0:1.0: USB hub found
[    0.623549] hub 3-0:1.0: 5 ports detected
[    0.624792] ohci-pci 0000:00:13.0: OHCI PCI host controller
[    0.625854] ohci-pci 0000:00:13.0: new USB bus registered, assigned bus number 4
[    0.626836] ohci-pci 0000:00:13.0: irq 18, io mem 0xfeb4e000
[    0.676301] ACPI: Battery Slot [BAT1] (battery present)
[    0.682275] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.683224] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.684160] usb usb4: Product: OHCI PCI host controller
[    0.685088] usb usb4: Manufacturer: Linux 3.16.6-203.fc20.x86_64 ohci_hcd
[    0.686015] usb usb4: SerialNumber: 0000:00:13.0
[    0.687157] hub 4-0:1.0: USB hub found
[    0.688171] hub 4-0:1.0: 5 ports detected
[    0.689258] uhci_hcd: USB Universal Host Controller Interface driver
[    0.690383] xhci_hcd 0000:00:10.0: xHCI Host Controller
[    0.691420] xhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 5
[    0.692560] xhci_hcd 0000:00:10.0: irq 41 for MSI/MSI-X
[    0.692565] xhci_hcd 0000:00:10.0: irq 42 for MSI/MSI-X
[    0.692569] xhci_hcd 0000:00:10.0: irq 43 for MSI/MSI-X
[    0.692573] xhci_hcd 0000:00:10.0: irq 44 for MSI/MSI-X
[    0.692576] xhci_hcd 0000:00:10.0: irq 45 for MSI/MSI-X
[    0.692675] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
[    0.693621] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.694578] usb usb5: Product: xHCI Host Controller
[    0.695538] usb usb5: Manufacturer: Linux 3.16.6-203.fc20.x86_64 xhci_hcd
[    0.696517] usb usb5: SerialNumber: 0000:00:10.0
[    0.697620] hub 5-0:1.0: USB hub found
[    0.698687] hub 5-0:1.0: 2 ports detected
[    0.699735] xhci_hcd 0000:00:10.0: xHCI Host Controller
[    0.700807] xhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 6
[    0.701843] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
[    0.702819] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.703796] usb usb6: Product: xHCI Host Controller
[    0.704764] usb usb6: Manufacturer: Linux 3.16.6-203.fc20.x86_64 xhci_hcd
[    0.705737] usb usb6: SerialNumber: 0000:00:10.0
[    0.706844] hub 6-0:1.0: USB hub found
[    0.707907] hub 6-0:1.0: 2 ports detected
[    0.709076] xhci_hcd 0000:00:10.1: xHCI Host Controller
[    0.710190] xhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 7
[    0.711353] xhci_hcd 0000:00:10.1: irq 46 for MSI/MSI-X
[    0.711359] xhci_hcd 0000:00:10.1: irq 47 for MSI/MSI-X
[    0.711363] xhci_hcd 0000:00:10.1: irq 48 for MSI/MSI-X
[    0.711368] xhci_hcd 0000:00:10.1: irq 49 for MSI/MSI-X
[    0.711371] xhci_hcd 0000:00:10.1: irq 50 for MSI/MSI-X
[    0.711462] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[    0.712435] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.713407] usb usb7: Product: xHCI Host Controller
[    0.714377] usb usb7: Manufacturer: Linux 3.16.6-203.fc20.x86_64 xhci_hcd
[    0.715361] usb usb7: SerialNumber: 0000:00:10.1
[    0.716477] hub 7-0:1.0: USB hub found
[    0.717544] hub 7-0:1.0: 2 ports detected
[    0.718607] xhci_hcd 0000:00:10.1: xHCI Host Controller
[    0.719674] xhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 8
[    0.720722] usb usb8: New USB device found, idVendor=1d6b, idProduct=0003
[    0.721706] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.722685] usb usb8: Product: xHCI Host Controller
[    0.723661] usb usb8: Manufacturer: Linux 3.16.6-203.fc20.x86_64 xhci_hcd
[    0.724642] usb usb8: SerialNumber: 0000:00:10.1
[    0.725796] hub 8-0:1.0: USB hub found
[    0.726866] hub 8-0:1.0: 2 ports detected
[    0.728085] usbcore: registered new interface driver usbserial
[    0.729166] usbcore: registered new interface driver usbserial_generic
[    0.730139] usbserial: USB Serial support registered for generic
[    0.731144] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.743853] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.744913] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.746172] mousedev: PS/2 mouse device common for all mice
[    0.747608] rtc_cmos 00:01: RTC can wake from S4
[    0.748821] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    0.749905] rtc_cmos 00:01: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.751082] device-mapper: uevent: version 1.0.3
[    0.752273] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    0.753882] EFI Variables Facility v0.08 2004-May-17
[    0.760701] hidraw: raw HID events driver (C) Jiri Kosina
[    0.761878] usbcore: registered new interface driver usbhid
[    0.762973] usbhid: USB HID core driver
[    0.764034] drop_monitor: Initializing network drop monitor service
[    0.765123] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.766306] TCP: cubic registered
[    0.767360] Initializing XFRM netlink socket
[    0.767425] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    0.769628] NET: Registered protocol family 10
[    0.770862] mip6: Mobile IPv6
[    0.771966] NET: Registered protocol family 17
[    0.775767] Loading compiled-in X.509 certificates
[    0.777707] Loaded X.509 cert 'Fedora kernel signing key: 02642c464f7245b989a1e346e277bb39f1c1fa2d'
[    0.778857] registered taskstats version 1
[    0.780351]   Magic number: 2:939:294
[    0.781458] ata_device dev2.0: hash matches
[    0.782479]  dev2.0: hash matches
[    0.783506] misc hpet: hash matches
[    0.784629] tty tty27: hash matches
[    0.785756] rtc_cmos 00:01: setting system clock to 2014-10-29 19:17:36 UTC (1414610256)
[    0.786944] PM: Hibernation image not present or could not be loaded.
[    0.982956] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.984211] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.986171] ata3.00: ATAPI: TSSTcorp DVDWBD SN-406AB, TM00, max UDMA/100
[    0.987621] ata4.00: ATA-8: Hitachi HTS727575A9E364, JF4OA0D0, max UDMA/133
[    0.988651] ata4.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    0.991144] ata4.00: configured for UDMA/133
[    0.992471] ata3.00: configured for UDMA/100
[    0.999341] scsi 2:0:0:0: CD-ROM            TSSTcorp DVDWBD SN-406AB  TM00 PQ: 0 ANSI: 5
[    1.020800] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.021861] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.023048] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    1.023137] sr 2:0:0:0: Attached scsi generic sg0 type 5
[    1.024576] scsi 3:0:0:0: Direct-Access     ATA      Hitachi HTS72757 A0D0 PQ: 0 ANSI: 5
[    1.026047] sd 3:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[    1.026111] sd 3:0:0:0: Attached scsi generic sg1 type 0
[    1.028221] sd 3:0:0:0: [sda] 4096-byte physical blocks
[    1.029388] sd 3:0:0:0: [sda] Write Protect is off
[    1.030423] sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.030436] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.076098]  sda: sda1 sda2 sda3 sda4 sda5 sda6 sda7 sda8 sda9
[    1.077935] sd 3:0:0:0: [sda] Attached SCSI disk
[    1.080225] Freeing unused kernel memory: 1456K (ffffffff81d1c000 - ffffffff81e88000)
[    1.081311] Write protecting the kernel read-only data: 12288k
[    1.085883] Freeing unused kernel memory: 932K (ffff880002717000 - ffff880002800000)
[    1.090469] Freeing unused kernel memory: 960K (ffff880002b10000 - ffff880002c00000)
[    1.105045] systemd[1]: systemd 208 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    1.106398] systemd[1]: Running in initial RAM disk.
[    1.111382] systemd[1]: Set hostname to <bunion-ii.julianfamily.org>.
[    1.113177] random: systemd urandom read with 21 bits of entropy available
[    1.147135] systemd[1]: Expecting device dev-mapper-fedora\x2droot.device...
[    1.149798] systemd[1]: Starting -.slice.
[    1.152634] systemd[1]: Created slice -.slice.
[    1.153793] systemd[1]: Starting System Slice.
[    1.156362] systemd[1]: Created slice System Slice.
[    1.157592] systemd[1]: Starting Slices.
[    1.160028] systemd[1]: Reached target Slices.
[    1.161194] systemd[1]: Starting Timers.
[    1.163566] systemd[1]: Reached target Timers.
[    1.164781] systemd[1]: Starting Journal Socket.
[    1.167235] systemd[1]: Listening on Journal Socket.
[    1.168499] systemd[1]: Starting dracut cmdline hook...
[    1.171460] systemd[1]: Started Load Kernel Modules.
[    1.172688] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    1.175665] systemd[1]: Starting Apply Kernel Variables...
[    1.178759] systemd[1]: Starting Setup Virtual Console...
[    1.181694] systemd[1]: Starting Journal Service...
[    1.186456] systemd[1]: Started Journal Service.
[    1.263094] systemd-udevd[217]: starting version 208
[    1.316709] [drm] Initialized drm 1.1.0 20060810
[    1.323610] pata_atiixp 0000:00:14.1: enabling device (0000 -> 0001)
[    1.326484] scsi4 : pata_atiixp
[    1.328077] scsi5 : pata_atiixp
[    1.329610] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf100 irq 14
[    1.331061] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf108 irq 15
[    1.356865] [drm] radeon kernel modesetting enabled.
[    1.358127] VGA switcheroo: detected switching method \_SB_.PCI0.VGA_.ATPX handle
[    1.359378] checking generic (c0000000 7e9000) vs hw (c0000000 10000000)
[    1.359380] fb: switching to radeondrmfb from EFI VGA
[    1.360560] Console: switching to colour dummy device 80x25
[    1.361120] [drm] initializing kernel modesetting (ARUBA 0x1002:0x990B 0x1462:0x10EF).
[    1.361135] [drm] register mmio base: 0xFEB00000
[    1.361138] [drm] register mmio size: 262144
[    1.361144] [drm] ACPI VFCT contains a BIOS for 00:01.0 1002:990b, size 20480
[    1.361155] ATOM BIOS: MSI_176K_Richland_APU
[    1.361219] radeon 0000:00:01.0: VRAM: 768M 0x0000000000000000 - 0x000000002FFFFFFF (768M used)
[    1.361224] radeon 0000:00:01.0: GTT: 1024M 0x0000000030000000 - 0x000000006FFFFFFF
[    1.361228] [drm] Detected VRAM RAM=768M, BAR=256M
[    1.361231] [drm] RAM width 32bits DDR
[    1.361321] [TTM] Zone  kernel: Available graphics memory: 3671148 kiB
[    1.361330] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    1.361333] [TTM] Initializing pool allocator
[    1.361341] [TTM] Initializing DMA pool allocator
[    1.361368] [drm] radeon: 768M of VRAM memory ready
[    1.361371] [drm] radeon: 1024M of GTT memory ready.
[    1.361393] [drm] Loading ARUBA Microcode
[    1.361468] [drm] Internal thermal controller without fan control
[    1.361654] [drm] radeon: dpm initialized
[    1.361811] [drm] GART: num cpu pages 262144, num gpu pages 262144
[    1.376318] [drm] PCIE GART of 1024M enabled (table at 0x0000000000276000).
[    1.376495] radeon 0000:00:01.0: WB enabled
[    1.376503] radeon 0000:00:01.0: fence driver on ring 0 use gpu addr 0x0000000030000c00 and cpu addr 0xffff88003e4b7c00
[    1.377240] radeon 0000:00:01.0: fence driver on ring 5 use gpu addr 0x0000000000075a18 and cpu addr 0xffffc90011c35a18
[    1.377247] radeon 0000:00:01.0: fence driver on ring 1 use gpu addr 0x0000000030000c04 and cpu addr 0xffff88003e4b7c04
[    1.377254] radeon 0000:00:01.0: fence driver on ring 2 use gpu addr 0x0000000030000c08 and cpu addr 0xffff88003e4b7c08
[    1.377261] radeon 0000:00:01.0: fence driver on ring 3 use gpu addr 0x0000000030000c0c and cpu addr 0xffff88003e4b7c0c
[    1.377267] radeon 0000:00:01.0: fence driver on ring 4 use gpu addr 0x0000000030000c10 and cpu addr 0xffff88003e4b7c10
[    1.377274] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    1.377277] [drm] Driver supports precise vblank timestamp query.
[    1.377306] radeon 0000:00:01.0: irq 51 for MSI/MSI-X
[    1.377320] radeon 0000:00:01.0: radeon: using MSI.
[    1.377619] [drm] radeon: irq initialized.
[    1.396998] [drm] ring test on 0 succeeded in 2 usecs
[    1.397013] [drm] ring test on 3 succeeded in 2 usecs
[    1.397022] [drm] ring test on 4 succeeded in 1 usecs
[    1.453063] [drm] ring test on 5 succeeded in 1 usecs
[    1.473069] [drm] UVD initialized successfully.
[    1.474094] [drm] ib test on ring 0 succeeded in 0 usecs
[    1.474647] [drm] ib test on ring 3 succeeded in 0 usecs
[    1.475184] [drm] ib test on ring 4 succeeded in 1 usecs
[    1.475409] tsc: Refined TSC clocksource calibration: 2495.337 MHz
[    1.477496] usb 4-1: new full-speed USB device number 2 using ohci-pci
[    1.496030] [drm] ib test on ring 5 succeeded
[    1.518286] [drm] radeon atom DIG backlight initialized
[    1.518295] [drm] Radeon Display Connectors
[    1.518299] [drm] Connector 0:
[    1.518302] [drm]   LVDS-1
[    1.518305] [drm]   HPD1
[    1.518308] [drm]   DDC: 0x6530 0x6530 0x6534 0x6534 0x6538 0x6538 0x653c 0x653c
[    1.518313] [drm]   Encoders:
[    1.518316] [drm]     LCD1: INTERNAL_UNIPHY2
[    1.518319] [drm]     LCD1: TRAVIS
[    1.518321] [drm] Connector 1:
[    1.518324] [drm]   VGA-1
[    1.518326] [drm]   HPD2
[    1.518330] [drm]   DDC: 0x6540 0x6540 0x6544 0x6544 0x6548 0x6548 0x654c 0x654c
[    1.518351] [drm]   Encoders:
[    1.518354] [drm]     CRT1: INTERNAL_UNIPHY2
[    1.518357] [drm]     CRT1: NUTMEG
[    1.518360] [drm] Connector 2:
[    1.518362] [drm]   DP-1
[    1.518365] [drm]   HPD3
[    1.518368] [drm]   DDC: 0x6550 0x6550 0x6554 0x6554 0x6558 0x6558 0x655c 0x655c
[    1.518372] [drm]   Encoders:
[    1.518375] [drm]     DFP1: INTERNAL_UNIPHY
[    1.518378] [drm] Connector 3:
[    1.518380] [drm]   HDMI-A-1
[    1.518383] [drm]   HPD6
[    1.518386] [drm]   DDC: 0x6580 0x6580 0x6584 0x6584 0x6588 0x6588 0x658c 0x658c
[    1.518390] [drm]   Encoders:
[    1.518393] [drm]     DFP2: INTERNAL_UNIPHY
[    1.639494] usb 4-1: New USB device found, idVendor=13d3, idProduct=3394
[    1.639505] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.639511] usb 4-1: Product: RT Bluetooth Radio
[    1.639515] usb 4-1: Manufacturer: Realtek
[    1.639519] usb 4-1: SerialNumber: 00e04c000001
[    1.674803] psmouse serio1: elantech: assuming hardware version 3 (with firmware version 0x250f01)
[    1.698810] psmouse serio1: elantech: Synaptics capabilities query result 0x18, 0x17, 0x0b.
[    1.777944] random: nonblocking pool is initialized
[    1.788233] input: ETPS/2 Elantech Touchpad as /devices/platform/i8042/serio1/input/input5
[    1.872246] usb 3-4: new full-speed USB device number 2 using ohci-pci
[    2.023152] usb 3-4: New USB device found, idVendor=1770, idProduct=ff00
[    2.023161] usb 3-4: New USB device strings: Mfr=1, Product=1, SerialNumber=1
[    2.023166] usb 3-4: Product: MSI EPF USB
[    2.023169] usb 3-4: Manufacturer: MSI EPF USB
[    2.023172] usb 3-4: SerialNumber: MSI EPF USB
[    2.031440] hid-generic 0003:1770:FF00.0001: hiddev0,hidraw0: USB HID v1.10 Device [MSI EPF USB MSI EPF USB] on usb-0000:00:12.0-4/input0
[    2.038796] [drm] fb mappable at 0xC047A000
[    2.038804] [drm] vram apper at 0xC0000000
[    2.038806] [drm] size 8294400
[    2.038809] [drm] fb depth is 24
[    2.038811] [drm]    pitch is 7680
[    2.039016] fbcon: radeondrmfb (fb0) is primary device
[    2.212701] Console: switching to colour frame buffer device 240x67
[    2.217114] radeon 0000:00:01.0: fb0: radeondrmfb frame buffer device
[    2.217114] radeon 0000:00:01.0: registered panic notifier
[    2.224615] [drm] Initialized radeon 2.39.0 20080528 for 0000:00:01.0 on minor 0
[    2.224776] radeon 0000:01:00.0: enabling device (0000 -> 0003)
[    2.225049] [drm] initializing kernel modesetting (PITCAIRN 0x1002:0x6801 0x1462:0x10F1).
[    2.225102] [drm] register mmio base: 0xFEA00000
[    2.225125] [drm] register mmio size: 262144
[    2.225148] vga_switcheroo: enabled
[    2.225284] ATPX version 1, functions 0x00000003
[    2.474809] Switched to clocksource tsc
[    3.135241] ACPI Error: Field [TEMP] at 524288 exceeds Buffer [TVGA] size 512000 (bits) (20140424/dsopcode-236)
[    3.135295] ACPI Error: Method parse/execution failed [\_SB_.PCI0.VGA_.ATRM] (Node ffff880236c35ca8), AE_AML_BUFFER_LIMIT (20140424/psparse-536)
[    3.135359] failed to evaluate ATRM got AE_AML_BUFFER_LIMIT
[    3.135385] ATOM BIOS: MSI
[    3.135424] [drm] GPU not posted. posting now...
[    3.139750] [drm] Probable bad vram size: 0x03800800
[    3.139772] radeon 0000:01:00.0: VRAM: 2048M 0x0000000000000000 - 0x000000007FFFFFFF (2048M used)
[    3.139803] radeon 0000:01:00.0: GTT: 1024M 0x0000000080000000 - 0x00000000BFFFFFFF
[    3.139830] [drm] Detected VRAM RAM=2048M, BAR=256M
[    3.139847] [drm] RAM width 256bits DDR
[    3.139877] [drm] radeon: 2048M of VRAM memory ready
[    3.139910] [drm] radeon: 1024M of GTT memory ready.
[    3.139950] [drm] Loading PITCAIRN Microcode
[    3.140118] [drm] radeon/PITCAIRN_mc2.bin: 31100 bytes
[    3.140180] [drm] Internal thermal controller without fan control
[    3.140295] [drm] probing gen 2 caps for device 1022:1413 = 700d01/6
[    3.147369] [drm] radeon: dpm initialized
[    3.147402] [drm] GART: num cpu pages 262144, num gpu pages 262144
[    3.149179] [drm] probing gen 2 caps for device 1022:1413 = 700d01/6
[    3.149212] [drm] enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0
[    3.479837] [drm] PCIE GART of 1024M enabled (table at 0x0000000000276000).
[    3.480025] radeon 0000:01:00.0: WB enabled
[    3.480045] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000080000c00 and cpu addr 0xffff880230667c00
[    3.480084] radeon 0000:01:00.0: fence driver on ring 1 use gpu addr 0x0000000080000c04 and cpu addr 0xffff880230667c04
[    3.480124] radeon 0000:01:00.0: fence driver on ring 2 use gpu addr 0x0000000080000c08 and cpu addr 0xffff880230667c08
[    3.480163] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000080000c0c and cpu addr 0xffff880230667c0c
[    3.480203] radeon 0000:01:00.0: fence driver on ring 4 use gpu addr 0x0000000080000c10 and cpu addr 0xffff880230667c10
[    3.481813] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr 0x0000000000075a18 and cpu addr 0xffffc90012735a18
[    3.481850] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    3.481873] [drm] Driver supports precise vblank timestamp query.
[    3.481917] radeon 0000:01:00.0: irq 52 for MSI/MSI-X
[    3.481931] radeon 0000:01:00.0: radeon: using MSI.
[    3.483141] [drm] radeon: irq initialized.
[    3.885461] [drm:r600_ring_test] *ERROR* radeon: ring 0 test failed (scratch(0x850C)=0xCAFEDEAD)
[    3.886629] radeon 0000:01:00.0: disabling GPU acceleration
[    4.087951] [drm] Radeon Display Connectors
[    4.089172] [drm] Connector 0:
[    4.090396] [drm]   VGA-2
[    4.091608] [drm]   DDC: 0x65c0 0x65c0 0x65c4 0x65c4 0x65c8 0x65c8 0x65cc 0x65cc
[    4.092824] [drm]   Encoders:
[    4.094029] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    4.125465] radeon 0000:01:00.0: No connectors reported connected with modes
[    4.126601] [drm] Cannot find any crtc or sizes - going 1024x768
[    4.129953] [drm] fb mappable at 0xD0477000
[    4.131084] [drm] vram apper at 0xD0000000
[    4.132287] [drm] size 3145728
[    4.133466] [drm] fb depth is 24
[    4.134649] [drm]    pitch is 4096
[    4.135939] radeon 0000:01:00.0: fb1: radeondrmfb frame buffer device
[    4.140502] [drm] Initialized radeon 2.39.0 20080528 for 0000:01:00.0 on minor 1
[    5.396153] PM: Starting manual resume from disk
[    5.397352] PM: Hibernation image partition 253:1 present
[    5.397354] PM: Looking for hibernation image.
[    5.397545] PM: Image not found (code -22)
[    5.397547] PM: Hibernation image not present or could not be loaded.
[    5.526506] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[    5.740004] systemd-journald[142]: Received SIGTERM
[    6.494345] audit: type=1404 audit(1414610262.212:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[    6.606280] SELinux: 2048 avtab hash slots, 101275 rules.
[    6.624814] SELinux: 2048 avtab hash slots, 101275 rules.
[    6.656829] SELinux:  8 users, 86 roles, 4853 types, 288 bools, 1 sens, 1024 cats
[    6.656833] SELinux:  83 classes, 101275 rules
[    6.662517] SELinux:  Permission audit_read in class capability2 not defined in policy.
[    6.663629] SELinux: the above unknown classes and permissions will be allowed
[    6.664703] SELinux:  Completing initialization.
[    6.664704] SELinux:  Setting up existing superblocks.
[    6.664712] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    6.664722] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    6.664728] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    6.664765] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    6.664857] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[    6.666061] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    6.667466] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    6.667469] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    6.667474] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    6.667476] SELinux: initialized (dev aio, type aio), not configured for labeling
[    6.667479] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    6.667497] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    6.667504] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    6.667512] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    6.667527] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    6.668042] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[    6.668044] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    6.668052] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    6.668189] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    6.668242] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    6.668249] SELinux: initialized (dev pstore, type pstore), uses genfs_contexts
[    6.668252] SELinux: initialized (dev efivarfs, type efivarfs), uses genfs_contexts
[    6.668272] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    6.668274] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    6.668276] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    6.668285] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    6.668289] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    6.668291] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    6.668292] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    6.668302] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    6.668304] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    6.668307] SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
[    6.668309] SELinux: initialized (dev drm, type drm), not configured for labeling
[    6.668316] SELinux: initialized (dev dm-0, type ext4), uses xattr
[    6.678900] audit: type=1403 audit(1414610262.397:3): policy loaded auid=4294967295 ses=4294967295
[    6.694110] systemd[1]: Successfully loaded SELinux policy in 231.153ms.
[    6.840437] systemd[1]: RTC configured in localtime, applying delta of -420 minutes to system time.
[    6.876801] systemd[1]: Relabelled /dev and /run in 18.398ms.
[    8.506157] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[    9.402503] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    9.402856] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    9.696441] RPC: Registered named UNIX socket transport module.
[    9.697597] RPC: Registered udp transport module.
[    9.698790] RPC: Registered tcp transport module.
[    9.699960] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    9.701481] SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
[    9.956508] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    9.958143] SELinux: initialized (dev nfsd, type nfsd), uses genfs_contexts
[   10.424973] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
[   10.470738] systemd-udevd[472]: starting version 208
[   10.525065] EXT4-fs (dm-0): re-mounted. Opts: (null)
[   11.717426] acpi-cpufreq: overriding BIOS provided _PSD data
[   11.782509] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[   11.783796] piix4_smbus 0000:00:14.0: Auxiliary SMBus Host Controller at 0xb20
[   11.895385] wmi: Mapper loaded
[   11.901982] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   11.926275] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[   11.927928] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:18/LNXVIDEO:00/input/input6
[   11.929748] ACPI: Video Device [VGA1] (multi-head: yes  rom: no  post: no)
[   11.931368] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/LNXVIDEO:01/input/input7
[   11.998756] microcode: CPU0: patch_level=0x06001119
[   12.131298] microcode: CPU1: patch_level=0x06001119
[   12.132982] microcode: CPU2: patch_level=0x06001119
[   12.135950] microcode: CPU3: patch_level=0x06001119
[   12.138941] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   12.422383] sdhci: Secure Digital Host Controller Interface driver
[   12.425010] sdhci: Copyright(c) Pierre Ossman
[   12.500022] sdhci-pci 0000:00:14.7: SDHCI controller found [1022:7806] (rev 0)
[   12.502627] sdhci-pci 0000:00:14.7: enabling device (0000 -> 0002)
[   12.505400] mmc0: no vqmmc regulator found
[   12.506916] mmc0: no vmmc regulator found
[   12.508490] mmc0: SDHCI controller on PCI [0000:00:14.7] using ADMA
[   12.513886] alg: No test for crc32 (crc32-pclmul)
[   12.602296] cfg80211: Calling CRDA to update world regulatory domain
[   12.641348] Bluetooth: Core ver 2.19
[   12.644357] NET: Registered protocol family 31
[   12.645677] Bluetooth: HCI device and connection manager initialized
[   12.646931] Bluetooth: HCI socket layer initialized
[   12.648207] Bluetooth: L2CAP socket layer initialized
[   12.649751] Bluetooth: SCO socket layer initialized
[   12.756997] alx 0000:03:00.0 eth0: Qualcomm Atheros AR816x/AR817x Ethernet [8c:89:a5:0b:c8:be]
[   12.831963] input: MSI WMI hotkeys as /devices/virtual/input/input8
[   12.942625] usbcore: registered new interface driver btusb
[   13.144790] cfg80211: World regulatory domain updated:
[   13.146756] cfg80211:  DFS Master region: unset
[   13.146783] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[   13.151270] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[   13.153695] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[   13.156083] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[   13.158115] cfg80211:   (5170000 KHz - 5250000 KHz @ 160000 KHz), (N/A, 2000 mBm), (N/A)
[   13.160097] cfg80211:   (5250000 KHz - 5330000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[   13.162070] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[   13.164109] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[   13.164159] kvm: Nested Virtualization enabled
[   13.164162] kvm: Nested Paging enabled
[   13.169868] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[   13.245086] snd_hda_intel 0000:00:01.1: enabling device (0000 -> 0002)
[   13.248348] snd_hda_intel 0000:00:01.1: Force to non-snoop mode
[   13.251287] snd_hda_intel 0000:00:01.1: irq 52 for MSI/MSI-X
[   13.268831] rtl8723ae 0000:04:00.0: enabling device (0000 -> 0003)
[   13.286771] rtl8723ae: Using firmware rtlwifi/rtl8723fw_B.bin
[   13.384424] sound hdaudioC1D0: autoconfig: line_outs=1 (0x17/0x0/0x0/0x0/0x0) type:line
[   13.387431] sound hdaudioC1D0:    speaker_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[   13.390320] sound hdaudioC1D0:    hp_outs=1 (0x14/0x0/0x0/0x0/0x0)
[   13.393186] sound hdaudioC1D0:    mono: mono_out=0x0
[   13.396029] sound hdaudioC1D0:    dig-out=0x1e/0x0
[   13.398870] sound hdaudioC1D0:    inputs:
[   13.403029] sound hdaudioC1D0:      Mic=0x18
[   13.406238] sound hdaudioC1D0:      Internal Mic=0x12
[   13.409252] sound hdaudioC1D0:      Line=0x1a
[   13.421024] input: HDA ATI HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.1/sound/card0/input9
[   13.424194] input: HDA ATI HDMI HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:01.1/sound/card0/input10
[   13.436627] input: HD-Audio Generic Mic as /devices/pci0000:00/0000:00:14.2/sound/card1/input11
[   13.440100] input: HD-Audio Generic Line as /devices/pci0000:00/0000:00:14.2/sound/card1/input12
[   13.442815] input: HD-Audio Generic Line Out as /devices/pci0000:00/0000:00:14.2/sound/card1/input13
[   13.444279] input: HD-Audio Generic Headphone as /devices/pci0000:00/0000:00:14.2/sound/card1/input14
[   13.680896] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[   13.681166] rtlwifi: wireless switch is on
[   13.809843] systemd-udevd[508]: renamed network interface wlan0 to wlp4s0
[   13.947413] Adding 7356412k swap on /dev/mapper/fedora-swap.  Priority:-1 extents:1 across:7356412k FS
[   14.745946] systemd-udevd[495]: renamed network interface eth0 to enp3s0
[   15.372275] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
[   15.527489] SELinux: initialized (dev sda6, type ext4), uses xattr
[   15.678058] FAT-fs (sda2): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[   15.681109] SELinux: initialized (dev sda2, type vfat), uses genfs_contexts
[   15.757794] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
[   15.760858] SELinux: initialized (dev dm-2, type ext4), uses xattr
[   15.778434] systemd-journald[450]: Received request to flush runtime journal from PID 1
[   16.386401] audit: type=1305 audit(1414635472.114:4): audit_pid=673 old=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:auditd_t:s0 res=1
[   17.643202] systemd[1]: Received SIGRTMIN+21 from PID 243 (plymouthd).
[   17.683114] systemd[1]: Unit rngd.service entered failed state.
[   17.736042] systemd[1]: Unit mcelog.service entered failed state.
[   23.469899] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   23.469968] Bluetooth: BNEP filters: protocol multicast
[   23.470032] Bluetooth: BNEP socket layer initialized
[   26.355209] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   26.822465] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   28.902325] Ebtables v2.0 registered
[   29.024248] Bridge firewalling registered
[   33.490512] alx 0000:03:00.0: irq 53 for MSI/MSI-X


