Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbaHYLK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 07:10:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112AbaHYLKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 07:10:55 -0400
Message-ID: <53FB19BA.5070709@redhat.com>
Date: Mon, 25 Aug 2014 13:10:50 +0200
From: Harald Hoyer <harald@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH] efi_high_alloc: use EFI_ALLOCATE_MAX_ADDRESS
References: <1408715303-2215-1-git-send-email-harald@redhat.com> <20140825103447.GP29733@console-pimps.org>
In-Reply-To: <20140825103447.GP29733@console-pimps.org>
Content-Type: multipart/mixed;
 boundary="------------040803050309020004010301"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040803050309020004010301
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 25.08.2014 12:34, Matt Fleming wrote:
> (Adding linux-efi to Cc)
> 
> On Fri, 22 Aug, at 03:48:23PM, harald@redhat.com wrote:
>> From: Harald Hoyer <harald@redhat.com>
>>
>> On my Lenovo T420s with 4GB memory, efi_high_alloc() was checking the
>> following memory regions:
>>
>> 0x0000000000100000 - 0x0000000020000000
>> 0x0000000020200000 - 0x0000000040000000
>> 0x0000000040200000 - 0x00000000d2c02000
>> 0x00000000d6e9f000 - 0x000000011e600000
>>
>> and decided to allocate 2649 pages at address 0x11dba7000.
>> As I understand this is the physical address and this machine only
>> has 4GB mem!!
>  
> Yeah, but RAM doesn't necessarily start at the physical address
> 0x000000000000. Nor is it necessarily contiguous.
> 
> In other words, it's perfectly legitimate to allocate at physical
> addresses above 0x10000000 if the above memory map tells us RAM lives
> there.

yeah, I thought so, too :)

> 
>> Nevertheless, unpacking of the initramfs later on failed.
>> This was mainly caused by commit 4bf7111f50167133a71c23530ca852a41355e739,
>> which enables loading the initramfs above 4G addresses.
>>
>> With this patch efi_high_alloc() now uses EFI_ALLOCATE_MAX_ADDRESS.
>> This returns 0x00000000d2c02000 on my machine and the resulting
>> address at which the initramfs is loaded is then 0x00000000d21a9000,
>> which seems to work fine.
> 
> Well yeah, that makes sense because you've obviously got a buggy EFI
> firmware that doesn't load things correctly above 4GB. It turns out that
> this is a common bug.
> 
> Can you try the following patch and see whether booting with
> efi=nochunk results in a functioning initramfs? I've had some success
> with disabling the chunking workaround when reading files in the EFI
> boot stub. Also, including a copy of a dmesg would be helpful.
> 

Here we go... dmesg attached, but uncompression failed.


--------------040803050309020004010301
Content-Type: text/plain; charset=UTF-8;
 name="efi-dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="efi-dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.17.0-rc1+ (harald@lenovo) (gcc version 4.9.1 20140813 (Red Hat 4.9.1-7) (GCC) ) #25 SMP Mon Aug 25 12:49:05 CEST 2014
[    0.000000] Command line: initrd=\9e3d4b6532ff41e1ab40d6b4e5609907\3.17.0-0.rc1.git1.2.fc22.1.x86_64\initrd rw root=/dev/sda2 loglevel=7 efi=nochunk
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000057fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000058000-0x0000000000058fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000000059000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x000000003fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040000000-0x00000000401fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040200000-0x00000000da89efff] usable
[    0.000000] BIOS-e820: [mem 0x00000000da89f000-0x00000000dae9efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dae9f000-0x00000000daf9efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000dafff000-0x00000000daffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000f80f8000-0x00000000f80f8fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011e5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0xd6c84018-0xd6c94057] usable ==> usable
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem 0x0000000000000000-0x0000000000057fff] usable
[    0.000000] reserve setup_data: [mem 0x0000000000058000-0x0000000000058fff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x0000000000059000-0x000000000009ffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000020200000-0x000000003fffffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000040000000-0x00000000401fffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000040200000-0x00000000d6c84017] usable
[    0.000000] reserve setup_data: [mem 0x00000000d6c84018-0x00000000d6c94057] usable
[    0.000000] reserve setup_data: [mem 0x00000000d6c94058-0x00000000da89efff] usable
[    0.000000] reserve setup_data: [mem 0x00000000da89f000-0x00000000dae9efff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000dae9f000-0x00000000daf9efff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
[    0.000000] reserve setup_data: [mem 0x00000000dafff000-0x00000000daffffff] usable
[    0.000000] reserve setup_data: [mem 0x00000000f80f8000-0x00000000f80f8fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000011e5fffff] usable
[    0.000000] efi: EFI v2.00 by Lenovo
[    0.000000] efi:  ACPI=0xdaffe000  ACPI 2.0=0xdaffe014  SMBIOS=0xdae9e000 
[    0.000000] efi: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000001000) (0MB)
[    0.000000] efi: mem01: type=2, attr=0xf, range=[0x0000000000001000-0x0000000000007000) (0MB)
[    0.000000] efi: mem02: type=7, attr=0xf, range=[0x0000000000007000-0x000000000004e000) (0MB)
[    0.000000] efi: mem03: type=3, attr=0xf, range=[0x000000000004e000-0x0000000000058000) (0MB)
[    0.000000] efi: mem04: type=10, attr=0xf, range=[0x0000000000058000-0x0000000000059000) (0MB)
[    0.000000] efi: mem05: type=7, attr=0xf, range=[0x0000000000059000-0x000000000005e000) (0MB)
[    0.000000] efi: mem06: type=4, attr=0xf, range=[0x000000000005e000-0x000000000005f000) (0MB)
[    0.000000] efi: mem07: type=3, attr=0xf, range=[0x000000000005f000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem08: type=7, attr=0xf, range=[0x0000000000100000-0x0000000001000000) (15MB)
[    0.000000] efi: mem09: type=2, attr=0xf, range=[0x0000000001000000-0x000000000242c000) (20MB)
[    0.000000] efi: mem10: type=7, attr=0xf, range=[0x000000000242c000-0x0000000020000000) (475MB)
[    0.000000] efi: mem11: type=0, attr=0xf, range=[0x0000000020000000-0x0000000020200000) (2MB)
[    0.000000] efi: mem12: type=7, attr=0xf, range=[0x0000000020200000-0x0000000040000000) (510MB)
[    0.000000] efi: mem13: type=0, attr=0xf, range=[0x0000000040000000-0x0000000040200000) (2MB)
[    0.000000] efi: mem14: type=7, attr=0xf, range=[0x0000000040200000-0x00000000d365b000) (2356MB)
[    0.000000] efi: mem15: type=4, attr=0xf, range=[0x00000000d365b000-0x00000000d367b000) (0MB)
[    0.000000] efi: mem16: type=7, attr=0xf, range=[0x00000000d367b000-0x00000000d368b000) (0MB)
[    0.000000] efi: mem17: type=1, attr=0xf, range=[0x00000000d368b000-0x00000000d5ab7000) (36MB)
[    0.000000] efi: mem18: type=4, attr=0xf, range=[0x00000000d5ab7000-0x00000000d664b000) (11MB)
[    0.000000] efi: mem19: type=7, attr=0xf, range=[0x00000000d664b000-0x00000000d6c83000) (6MB)
[    0.000000] efi: mem20: type=2, attr=0xf, range=[0x00000000d6c83000-0x00000000d6c9f000) (0MB)
[    0.000000] efi: mem21: type=7, attr=0xf, range=[0x00000000d6c9f000-0x00000000d6e88000) (1MB)
[    0.000000] efi: mem22: type=1, attr=0xf, range=[0x00000000d6e88000-0x00000000d6e9f000) (0MB)
[    0.000000] efi: mem23: type=7, attr=0xf, range=[0x00000000d6e9f000-0x00000000d7b03000) (12MB)
[    0.000000] efi: mem24: type=4, attr=0xf, range=[0x00000000d7b03000-0x00000000d7b5b000) (0MB)
[    0.000000] efi: mem25: type=7, attr=0xf, range=[0x00000000d7b5b000-0x00000000d7b78000) (0MB)
[    0.000000] efi: mem26: type=4, attr=0xf, range=[0x00000000d7b78000-0x00000000d7b88000) (0MB)
[    0.000000] efi: mem27: type=7, attr=0xf, range=[0x00000000d7b88000-0x00000000d7b89000) (0MB)
[    0.000000] efi: mem28: type=4, attr=0xf, range=[0x00000000d7b89000-0x00000000d7b8a000) (0MB)
[    0.000000] efi: mem29: type=7, attr=0xf, range=[0x00000000d7b8a000-0x00000000d7b8b000) (0MB)
[    0.000000] efi: mem30: type=4, attr=0xf, range=[0x00000000d7b8b000-0x00000000d7b8c000) (0MB)
[    0.000000] efi: mem31: type=7, attr=0xf, range=[0x00000000d7b8c000-0x00000000d7b8e000) (0MB)
[    0.000000] efi: mem32: type=4, attr=0xf, range=[0x00000000d7b8e000-0x00000000d85ff000) (10MB)
[    0.000000] efi: mem33: type=7, attr=0xf, range=[0x00000000d85ff000-0x00000000d8602000) (0MB)
[    0.000000] efi: mem34: type=4, attr=0xf, range=[0x00000000d8602000-0x00000000d8606000) (0MB)
[    0.000000] efi: mem35: type=7, attr=0xf, range=[0x00000000d8606000-0x00000000d8607000) (0MB)
[    0.000000] efi: mem36: type=4, attr=0xf, range=[0x00000000d8607000-0x00000000d9e9f000) (24MB)
[    0.000000] efi: mem37: type=7, attr=0xf, range=[0x00000000d9e9f000-0x00000000da154000) (2MB)
[    0.000000] efi: mem38: type=3, attr=0xf, range=[0x00000000da154000-0x00000000da89f000) (7MB)
[    0.000000] efi: mem39: type=5, attr=0x800000000000000f, range=[0x00000000da89f000-0x00000000da9c2000) (1MB)
[    0.000000] efi: mem40: type=5, attr=0x800000000000000f, range=[0x00000000da9c2000-0x00000000daa9f000) (0MB)
[    0.000000] efi: mem41: type=6, attr=0x800000000000000f, range=[0x00000000daa9f000-0x00000000daca1000) (2MB)
[    0.000000] efi: mem42: type=6, attr=0x800000000000000f, range=[0x00000000daca1000-0x00000000dad9f000) (0MB)
[    0.000000] efi: mem43: type=0, attr=0xf, range=[0x00000000dad9f000-0x00000000dae21000) (0MB)
[    0.000000] efi: mem44: type=0, attr=0xf, range=[0x00000000dae21000-0x00000000dae9b000) (0MB)
[    0.000000] efi: mem45: type=0, attr=0xf, range=[0x00000000dae9b000-0x00000000dae9c000) (0MB)
[    0.000000] efi: mem46: type=0, attr=0xf, range=[0x00000000dae9c000-0x00000000dae9f000) (0MB)
[    0.000000] efi: mem47: type=10, attr=0xf, range=[0x00000000dae9f000-0x00000000daede000) (0MB)
[    0.000000] efi: mem48: type=10, attr=0xf, range=[0x00000000daede000-0x00000000daf9f000) (0MB)
[    0.000000] efi: mem49: type=9, attr=0xf, range=[0x00000000daf9f000-0x00000000dafdd000) (0MB)
[    0.000000] efi: mem50: type=9, attr=0xf, range=[0x00000000dafdd000-0x00000000dafff000) (0MB)
[    0.000000] efi: mem51: type=4, attr=0xf, range=[0x00000000dafff000-0x00000000db000000) (0MB)
[    0.000000] efi: mem52: type=7, attr=0xf, range=[0x0000000100000000-0x000000011dba7000) (475MB)
[    0.000000] efi: mem53: type=2, attr=0xf, range=[0x000000011dba7000-0x000000011e600000) (10MB)
[    0.000000] efi: mem54: type=11, attr=0x8000000000000001, range=[0x00000000f80f8000-0x00000000f80f9000) (0MB)
[    0.000000] efi: mem55: type=11, attr=0x8000000000000001, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: LENOVO 4174BH4/4174BH4, BIOS 8CET58WW (1.38 ) 07/18/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x11e600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FE0000000 write-back
[    0.000000]   4 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   5 base 0DB000000 mask FFF000000 uncachable
[    0.000000]   6 base 100000000 mask FE0000000 write-back
[    0.000000]   7 base 11F000000 mask FFF000000 uncachable
[    0.000000]   8 base 11E800000 mask FFF800000 uncachable
[    0.000000]   9 base 11E600000 mask FFFE00000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xdb000 max_arch_pfn = 0x400000000
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] reserving inaccessible SNB gfx pages
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02008000, 0x02008fff] PGTABLE
[    0.000000] BRK [0x02009000, 0x02009fff] PGTABLE
[    0.000000] BRK [0x0200a000, 0x0200afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11d800000-0x11d9fffff]
[    0.000000]  [mem 0x11d800000-0x11d9fffff] page 2M
[    0.000000] BRK [0x0200b000, 0x0200bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11d7fffff]
[    0.000000]  [mem 0x11c000000-0x11d7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x3fffffff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x40200000-0xda89efff]
[    0.000000]  [mem 0x40200000-0xda7fffff] page 2M
[    0.000000]  [mem 0xda800000-0xda89efff] page 4k
[    0.000000] BRK [0x0200c000, 0x0200cfff] PGTABLE
[    0.000000] BRK [0x0200d000, 0x0200dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xdafff000-0xdaffffff]
[    0.000000]  [mem 0xdafff000-0xdaffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x11da00000-0x11e5fffff]
[    0.000000]  [mem 0x11da00000-0x11e5fffff] page 2M
[    0.000000] RAMDISK: [mem 0x11dba7000-0x11e5fffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000DAFFE014 000024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 0x00000000DAFFE120 0000AC (v01 LENOVO TP-8C    00001380 PTEC 00000002)
[    0.000000] ACPI: FACP 0x00000000DAFE8000 0000F4 (v04 LENOVO TP-8C    00001380 PTL  00000002)
[    0.000000] ACPI: DSDT 0x00000000DAFEB000 00E55F (v01 LENOVO TP-8C    00001380 INTL 20061109)
[    0.000000] ACPI: FACS 0x00000000DAF2D000 000040
[    0.000000] ACPI: SLIC 0x00000000DAFFD000 000176 (v01 LENOVO TP-8C    00001380 PTEC 00000001)
[    0.000000] ACPI: SSDT 0x00000000DAFFC000 000249 (v01 LENOVO TP-SSDT2 00000200 INTL 20061109)
[    0.000000] ACPI: SSDT 0x00000000DAFFB000 000033 (v01 LENOVO TP-SSDT1 00000100 INTL 20061109)
[    0.000000] ACPI: SSDT 0x00000000DAFFA000 000797 (v01 LENOVO SataAhci 00001000 INTL 20061109)
[    0.000000] ACPI: HPET 0x00000000DAFE7000 000038 (v01 LENOVO TP-8C    00001380 PTL  00000002)
[    0.000000] ACPI: APIC 0x00000000DAFE6000 000098 (v01 LENOVO TP-8C    00001380 PTL  00000002)
[    0.000000] ACPI: MCFG 0x00000000DAFE5000 00003C (v01 LENOVO TP-8C    00001380 PTL  00000002)
[    0.000000] ACPI: ECDT 0x00000000DAFE4000 000052 (v01 LENOVO TP-8C    00001380 PTL  00000002)
[    0.000000] ACPI: ASF! 0x00000000DAFEA000 0000A5 (v32 LENOVO TP-8C    00001380 PTL  00000002)
[    0.000000] ACPI: TCPA 0x00000000DAFE3000 000032 (v02 PTL    LENOVO   06040000 LNVO 00000001)
[    0.000000] ACPI: SSDT 0x00000000DAFE2000 000A77 (v01 PmRef  Cpu0Ist  00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x00000000DAFE1000 000996 (v01 PmRef  CpuPm    00003000 INTL 20061109)
[    0.000000] ACPI: DMAR 0x00000000DAFE0000 0000E8 (v01 INTEL  SNB      00000001 INTL 00000001)
[    0.000000] ACPI: UEFI 0x00000000DAFDF000 00003E (v01 LENOVO TP-8C    00001380 PTL  00000002)
[    0.000000] ACPI: UEFI 0x00000000DAFDE000 000042 (v01 PTL    COMBUF   00000001 PTL  00000001)
[    0.000000] ACPI: UEFI 0x00000000DAFDD000 000292 (v01 LENOVO TP-8C    00001380 PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011e5fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11e5fffff]
[    0.000000]   NODE_DATA [mem 0x11db93000-0x11dba6fff]
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff880119000000-ffff88011cffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x11e5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00057fff]
[    0.000000]   node   0: [mem 0x00059000-0x0009ffff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x3fffffff]
[    0.000000]   node   0: [mem 0x40200000-0xda89efff]
[    0.000000]   node   0: [mem 0xdafff000-0xdaffffff]
[    0.000000]   node   0: [mem 0x100000000-0x11e5fffff]
[    0.000000] On node 0 totalpages: 1018430
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 158 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13907 pages used for memmap
[    0.000000]   DMA32 zone: 890016 pages, LIFO batch:31
[    0.000000]   Normal zone: 1944 pages used for memmap
[    0.000000]   Normal zone: 124416 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xdba00000-0xdf9fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00058000-0x00058fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x40000000-0x401fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd6c84000-0xd6c84fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd6c94000-0xd6c94fff]
[    0.000000] PM: Registered nosave memory: [mem 0xda89f000-0xdae9efff]
[    0.000000] PM: Registered nosave memory: [mem 0xdae9f000-0xdaf9efff]
[    0.000000] PM: Registered nosave memory: [mem 0xdaf9f000-0xdaffefff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb000000-0xdb9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdba00000-0xdf9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfa00000-0xf80f7fff]
[    0.000000] PM: Registered nosave memory: [mem 0xf80f8000-0xf80f8fff]
[    0.000000] PM: Registered nosave memory: [mem 0xf80f9000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xffffffff]
[    0.000000] e820: [mem 0xdfa00000-0xf80f7fff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88011d600000 s88192 r8192 d22400 u262144
[    0.000000] pcpu-alloc: s88192 r8192 d22400 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1002357
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: initrd=\9e3d4b6532ff41e1ab40d6b4e5609907\3.17.0-0.rc1.git1.2.fc22.1.x86_64\initrd rw root=/dev/sda2 loglevel=7 efi=nochunk
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] Memory: 3857352K/4073720K available (7412K kernel code, 1186K rwdata, 3228K rodata, 1440K init, 1460K bss, 216368K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-7.
[    0.000000] NR_IRQS:4352 nr_irqs:488 0
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2591.557 MHz processor
[    0.000033] Calibrating delay loop (skipped), value calculated using timer frequency.. 5183.11 BogoMIPS (lpj=2591557)
[    0.000038] pid_max: default: 32768 minimum: 301
[    0.000047] ACPI: Core revision 20140724
[    0.010286] ACPI: All ACPI Tables successfully acquired
[    0.012072] Security Framework initialized
[    0.012081] SELinux:  Initializing.
[    0.012088] SELinux:  Starting in permissive mode
[    0.012411] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.013394] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.013853] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.013860] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.014066] Initializing cgroup subsys memory
[    0.014074] Initializing cgroup subsys devices
[    0.014078] Initializing cgroup subsys freezer
[    0.014080] Initializing cgroup subsys net_cls
[    0.014083] Initializing cgroup subsys blkio
[    0.014086] Initializing cgroup subsys perf_event
[    0.014089] Initializing cgroup subsys net_prio
[    0.014092] Initializing cgroup subsys hugetlb
[    0.014114] Disabled fast string operations
[    0.014117] CPU: Physical Processor ID: 0
[    0.014118] CPU: Processor Core ID: 0
[    0.014123] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.014128] mce: CPU supports 7 MCE banks
[    0.014139] CPU0: Thermal monitoring enabled (TM1)
[    0.014148] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.014264] Freeing SMP alternatives memory: 28K (ffffffff81e92000 - ffffffff81e99000)
[    0.017160] ftrace: allocating 27086 entries in 106 pages
[    0.029222] dmar: Host address width 36
[    0.029227] dmar: DRHD base: 0x000000fed90000 flags: 0x0
[    0.029233] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.029236] dmar: DRHD base: 0x000000fed91000 flags: 0x1
[    0.029240] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.029242] dmar: RMRR base: 0x000000dacd5000 end: 0x000000dacebfff
[    0.029245] dmar: RMRR base: 0x000000db800000 end: 0x000000df9fffff
[    0.029316] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.029318] HPET id 0 under DRHD base 0xfed91000
[    0.029319] HPET id 0 under DRHD base 0xfed91000
[    0.029321] HPET id 0 under DRHD base 0xfed91000
[    0.029322] HPET id 0 under DRHD base 0xfed91000
[    0.029323] HPET id 0 under DRHD base 0xfed91000
[    0.029325] HPET id 0 under DRHD base 0xfed91000
[    0.029326] HPET id 0 under DRHD base 0xfed91000
[    0.029328] HPET id 0 under DRHD base 0xfed91000
[    0.029329] Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.029639] Enabled IRQ remapping in x2apic mode
[    0.029642] Enabling x2apic
[    0.029643] Enabled x2apic
[    0.029649] Switched APIC routing to cluster x2apic.
[    0.030116] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.040116] smpboot: CPU0: Intel(R) Core(TM) i5-2540M CPU @ 2.60GHz (fam: 06, model: 2a, stepping: 07)
[    0.040126] TSC deadline timer enabled
[    0.040148] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, full-width counters, Intel PMU driver.
[    0.040169] ... version:                3
[    0.040170] ... bit width:              48
[    0.040172] ... generic registers:      4
[    0.040173] ... value mask:             0000ffffffffffff
[    0.040175] ... max period:             0000ffffffffffff
[    0.040176] ... fixed-purpose events:   3
[    0.040178] ... event mask:             000000070000000f
[    0.041606] x86: Booting SMP configuration:
[    0.041609] .... node  #0, CPUs:      #1
[    0.052635] Disabled fast string operations
[    0.054841] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.054936]  #2
[    0.065961] Disabled fast string operations
[    0.068146]  #3
[    0.079171] Disabled fast string operations
[    0.081281] x86: Booted up 1 node, 4 CPUs
[    0.081288] smpboot: Total of 4 processors activated (20732.45 BogoMIPS)
[    0.084356] devtmpfs: initialized
[    0.086544] PM: Registering ACPI NVS region [mem 0x00058000-0x00058fff] (4096 bytes)
[    0.086548] PM: Registering ACPI NVS region [mem 0xdae9f000-0xdaf9efff] (1048576 bytes)
[    0.087338] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.087343] pinctrl core: initialized pinctrl subsystem
[    0.087380] RTC time: 11:02:38, date: 08/25/14
[    0.087457] NET: Registered protocol family 16
[    0.087590] cpuidle: using governor menu
[    0.087651] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.087654] ACPI: bus type PCI registered
[    0.087656] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.087894] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.087898] PCI: not using MMCONFIG
[    0.087900] PCI: Using configuration type 1 for base access
[    0.091593] ACPI: Added _OSI(Module Device)
[    0.091596] ACPI: Added _OSI(Processor Device)
[    0.091598] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.091600] ACPI: Added _OSI(Processor Aggregator Device)
[    0.092849] ACPI : EC: EC description table is found, configuring boot EC
[    0.096295] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.105689] ACPI: Dynamic OEM Table Load:
[    0.105700] ACPI: SSDT 0xFFFF880117133000 0008C0 (v01 PmRef  Cpu0Cst  00003001 INTL 20061109)
[    0.108474] ACPI: Dynamic OEM Table Load:
[    0.108482] ACPI: SSDT 0xFFFF880117112C00 000303 (v01 PmRef  ApIst    00003000 INTL 20061109)
[    0.110413] ACPI: Dynamic OEM Table Load:
[    0.110420] ACPI: SSDT 0xFFFF880117140200 000119 (v01 PmRef  ApCst    00003000 INTL 20061109)
[    0.112784] ACPI: Interpreter enabled
[    0.112791] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140724/hwxface-580)
[    0.112796] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
[    0.112809] ACPI: (supports S0 S3 S4 S5)
[    0.112811] ACPI: Using IOAPIC for interrupt routing
[    0.112824] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.114616] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI motherboard resources
[    0.114716] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.117219] ACPI: Power Resource [PUBS] (on)
[    0.117927] acpi PNP0C0A:01: ACPI dock station (docks/bays count: 1)
[    0.118683] acpi LNXIOBAY:00: ACPI dock station (docks/bays count: 2)
[    0.120669] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.120724] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.120776] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.120828] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.120879] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.120930] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.120981] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.121032] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.121110] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.121116] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.121251] acpi PNP0A08:00: _OSC: platform does not support [PCIeCapability]
[    0.121320] acpi PNP0A08:00: _OSC: not requesting control; platform does not support [PCIeCapability]
[    0.121324] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
[    0.121327] acpi PNP0A08:00: _OSC: platform willing to grant [PCIeHotplug PME AER]
[    0.121329] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
[    0.121356] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.121475] PCI host bridge to bus 0000:00
[    0.121479] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.121481] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.121484] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.121486] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.121488] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfebfffff]
[    0.121491] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
[    0.121499] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
[    0.121575] pci 0000:00:02.0: [8086:0126] type 00 class 0x030000
[    0.121584] pci 0000:00:02.0: reg 0x10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.121590] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.121593] pci 0000:00:02.0: reg 0x20: [io  0x4000-0x403f]
[    0.121686] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.121709] pci 0000:00:16.0: reg 0x10: [mem 0xf1625000-0xf162500f 64bit]
[    0.121784] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.121858] pci 0000:00:19.0: [8086:1502] type 00 class 0x020000
[    0.121875] pci 0000:00:19.0: reg 0x10: [mem 0xf1600000-0xf161ffff]
[    0.121884] pci 0000:00:19.0: reg 0x14: [mem 0xf162b000-0xf162bfff]
[    0.121892] pci 0000:00:19.0: reg 0x18: [io  0x4080-0x409f]
[    0.121954] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.121985] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.122030] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.122051] pci 0000:00:1a.0: reg 0x10: [mem 0xf162a000-0xf162a3ff]
[    0.122140] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.122176] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.122219] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.122236] pci 0000:00:1b.0: reg 0x10: [mem 0xf1620000-0xf1623fff 64bit]
[    0.122313] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.122350] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.122394] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.122522] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.122604] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
[    0.122741] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.122824] pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
[    0.122963] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.123005] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.123047] pci 0000:00:1c.4: [8086:1c18] type 01 class 0x060400
[    0.123183] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.123227] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.123272] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.123294] pci 0000:00:1d.0: reg 0x10: [mem 0xf1629000-0xf16293ff]
[    0.123386] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.123418] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.123460] pci 0000:00:1f.0: [8086:1c4f] type 00 class 0x060100
[    0.123623] pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
[    0.123641] pci 0000:00:1f.2: reg 0x10: [io  0x40a8-0x40af]
[    0.123648] pci 0000:00:1f.2: reg 0x14: [io  0x40b4-0x40b7]
[    0.123656] pci 0000:00:1f.2: reg 0x18: [io  0x40a0-0x40a7]
[    0.123664] pci 0000:00:1f.2: reg 0x1c: [io  0x40b0-0x40b3]
[    0.123672] pci 0000:00:1f.2: reg 0x20: [io  0x4060-0x407f]
[    0.123679] pci 0000:00:1f.2: reg 0x24: [mem 0xf1628000-0xf16287ff]
[    0.123724] pci 0000:00:1f.2: PME# supported from D3hot
[    0.123785] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.123801] pci 0000:00:1f.3: reg 0x10: [mem 0xf1624000-0xf16240ff 64bit]
[    0.123821] pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefbf]
[    0.123968] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.124190] pci 0000:03:00.0: [8086:4238] type 00 class 0x028000
[    0.124384] pci 0000:03:00.0: reg 0x10: [mem 0xf1500000-0xf1501fff 64bit]
[    0.125086] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.127474] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.127484] pci 0000:00:1c.1:   bridge window [mem 0xf1500000-0xf15fffff]
[    0.127595] acpiphp: Slot [1] registered
[    0.127828] pci 0000:05:00.0: [1180:e822] type 00 class 0x088000
[    0.127850] pci 0000:05:00.0: MMC controller base frequency changed to 50Mhz.
[    0.127877] pci 0000:05:00.0: reg 0x10: [mem 0xf0d00000-0xf0d000ff]
[    0.128090] pci 0000:05:00.0: supports D1 D2
[    0.128091] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.130669] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.130674] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    0.130679] pci 0000:00:1c.3:   bridge window [mem 0xf0d00000-0xf14fffff]
[    0.130688] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.130842] pci 0000:0d:00.0: [1033:0194] type 00 class 0x0c0330
[    0.130871] pci 0000:0d:00.0: reg 0x10: [mem 0xf0c00000-0xf0c01fff 64bit]
[    0.131017] pci 0000:0d:00.0: PME# supported from D0 D3hot D3cold
[    0.132474] pci 0000:00:1c.4: PCI bridge to [bus 0d]
[    0.132491] pci 0000:00:1c.4:   bridge window [mem 0xf0c00000-0xf0cfffff]
[    0.133557] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.133613] ACPI : EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.133709] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.133714] vgaarb: loaded
[    0.133715] vgaarb: bridge control possible 0000:00:02.0
[    0.133785] SCSI subsystem initialized
[    0.133832] libata version 3.00 loaded.
[    0.133862] ACPI: bus type USB registered
[    0.133878] usbcore: registered new interface driver usbfs
[    0.133888] usbcore: registered new interface driver hub
[    0.133908] usbcore: registered new device driver usb
[    0.134003] PCI: Using ACPI for IRQ routing
[    0.135940] PCI: pci_cache_line_size set to 64 bytes
[    0.136387] e820: reserve RAM buffer [mem 0x00058000-0x0005ffff]
[    0.136389] e820: reserve RAM buffer [mem 0xd6c84018-0xd7ffffff]
[    0.136390] e820: reserve RAM buffer [mem 0xda89f000-0xdbffffff]
[    0.136391] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
[    0.136393] e820: reserve RAM buffer [mem 0x11e600000-0x11fffffff]
[    0.136504] NetLabel: Initializing
[    0.136506] NetLabel:  domain hash size = 128
[    0.136508] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.136519] NetLabel:  unlabeled traffic allowed by default
[    0.136563] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.136569] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.139604] Switched to clocksource hpet
[    0.145154] pnp: PnP ACPI init
[    0.145502] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.145506] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.145509] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.145511] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.145514] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.145516] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    0.145518] system 00:00: [mem 0x000d4000-0x000d7fff] has been reserved
[    0.145521] system 00:00: [mem 0x000d8000-0x000dbfff] has been reserved
[    0.145523] system 00:00: [mem 0x000dc000-0x000dffff] has been reserved
[    0.145525] system 00:00: [mem 0x000e0000-0x000e3fff] has been reserved
[    0.145528] system 00:00: [mem 0x000e4000-0x000e7fff] has been reserved
[    0.145530] system 00:00: [mem 0x000e8000-0x000ebfff] has been reserved
[    0.145532] system 00:00: [mem 0x000ec000-0x000effff] has been reserved
[    0.145535] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.145537] system 00:00: [mem 0x00100000-0xdf9fffff] could not be reserved
[    0.145540] system 00:00: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.145544] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.145664] system 00:01: [io  0x0400-0x047f] could not be reserved
[    0.145667] system 00:01: [io  0x0500-0x057f] has been reserved
[    0.145669] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.145671] system 00:01: [io  0x15e0-0x15ef] has been reserved
[    0.145674] system 00:01: [io  0x1600-0x167f] has been reserved
[    0.145677] system 00:01: [mem 0xf8000000-0xfbffffff] could not be reserved
[    0.145679] system 00:01: [mem 0x00000000-0x00000fff] could not be reserved
[    0.145682] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.145684] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.145686] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.145689] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.145691] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.145694] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.145697] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.145740] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.145761] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.145780] pnp 00:04: Plug and Play ACPI device, IDs LEN0015 PNP0f13 (active)
[    0.146198] pnp: PnP ACPI: found 5 devices
[    0.152673] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
[    0.152676] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
[    0.152678] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 02] add_size 200000
[    0.152716] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.152718] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.152720] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.152724] pci 0000:00:1c.0: BAR 14: assigned [mem 0xdfa00000-0xdfbfffff]
[    0.152729] pci 0000:00:1c.0: BAR 15: assigned [mem 0xdfc00000-0xdfdfffff 64bit pref]
[    0.152733] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.152736] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.152740] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.152748] pci 0000:00:1c.0:   bridge window [mem 0xdfa00000-0xdfbfffff]
[    0.152754] pci 0000:00:1c.0:   bridge window [mem 0xdfc00000-0xdfdfffff 64bit pref]
[    0.152763] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.152771] pci 0000:00:1c.1:   bridge window [mem 0xf1500000-0xf15fffff]
[    0.152783] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.152787] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    0.152794] pci 0000:00:1c.3:   bridge window [mem 0xf0d00000-0xf14fffff]
[    0.152800] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.152810] pci 0000:00:1c.4: PCI bridge to [bus 0d]
[    0.152817] pci 0000:00:1c.4:   bridge window [mem 0xf0c00000-0xf0cfffff]
[    0.152831] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.152832] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.152834] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.152835] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfebfffff]
[    0.152837] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed4bfff]
[    0.152838] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.152840] pci_bus 0000:02: resource 1 [mem 0xdfa00000-0xdfbfffff]
[    0.152841] pci_bus 0000:02: resource 2 [mem 0xdfc00000-0xdfdfffff 64bit pref]
[    0.152843] pci_bus 0000:03: resource 1 [mem 0xf1500000-0xf15fffff]
[    0.152844] pci_bus 0000:05: resource 0 [io  0x3000-0x3fff]
[    0.152845] pci_bus 0000:05: resource 1 [mem 0xf0d00000-0xf14fffff]
[    0.152847] pci_bus 0000:05: resource 2 [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.152848] pci_bus 0000:0d: resource 1 [mem 0xf0c00000-0xf0cfffff]
[    0.152877] NET: Registered protocol family 2
[    0.153048] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    0.153136] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.153230] TCP: Hash tables configured (established 32768 bind 32768)
[    0.153261] TCP: reno registered
[    0.153270] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.153287] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.153342] NET: Registered protocol family 1
[    0.153357] pci 0000:00:02.0: Boot video device
[    0.154879] PCI: CLS 64 bytes, default 64
[    0.154933] Unpacking initramfs...
[    0.160990] Initramfs unpacking failed: junk in compressed archive
[    0.163436] Freeing initrd memory: 10596K (ffff88011dba7000 - ffff88011e600000)
[    0.163472] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.163475] software IO TLB [mem 0xcf65b000-0xd365b000] (64MB) mapped at [ffff8800cf65b000-ffff8800d365afff]
[    0.163703] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    0.164099] AVX version of gcm_enc/dec engaged.
[    0.164102] AES CTR mode by8 optimization enabled
[    0.164728] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    0.165187] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.165222] Initialise system trusted keyring
[    0.165240] audit: initializing netlink subsys (disabled)
[    0.165256] audit: type=2000 audit(1408964558.153:1): initialized
[    0.165587] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.167051] zpool: loaded
[    0.167215] VFS: Disk quotas dquot_6.5.2
[    0.167251] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.167580] msgmni has been set to 7663
[    0.167651] Key type big_key registered
[    0.167654] SELinux:  Registering netfilter hooks
[    0.168545] alg: No test for stdrng (krng)
[    0.168556] NET: Registered protocol family 38
[    0.168563] Key type asymmetric registered
[    0.168566] Asymmetric key parser 'x509' registered
[    0.168612] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.168656] io scheduler noop registered
[    0.168659] io scheduler deadline registered
[    0.168690] io scheduler cfq registered (default)
[    0.168778] pcieport 0000:00:1c.0: enabling device (0000 -> 0003)
[    0.169199] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.169216] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.169263] efifb: probing for efifb
[    0.169276] efifb: framebuffer at 0xe0000000, mapped to 0xffffc90004800000, using 1200k, total 1200k
[    0.169279] efifb: mode is 640x480x32, linelength=2560, pages=1
[    0.169281] efifb: scrolling: redraw
[    0.169283] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.170020] Console: switching to colour frame buffer device 80x30
[    0.171063] fb0: EFI VGA frame buffer device
[    0.171470] intel_idle: MWAIT substates: 0x21120
[    0.171471] intel_idle: v0.4 model 0x2A
[    0.171472] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.172087] ACPI: AC Adapter [AC] (on-line)
[    0.172622] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.173771] ACPI: Lid Switch [LID]
[    0.174215] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    0.175064] ACPI: Sleep Button [SLPB]
[    0.175524] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.176386] ACPI: Power Button [PWRF]
[    0.178056] thermal LNXTHERM:00: registered as thermal_zone0
[    0.178486] ACPI: Thermal Zone [THM0] (56 C)
[    0.178948] GHES: HEST is not enabled!
[    0.179492] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.180728] Non-volatile memory driver v1.3
[    0.181186] Linux agpgart interface v0.103
[    0.181799] ahci 0000:00:1f.2: version 3.0
[    0.181914] ahci 0000:00:1f.2: irq 26 for MSI/MSI-X
[    0.181960] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    0.192644] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x13 impl SATA mode
[    0.192880] ACPI: Battery Slot [BAT0] (battery present)
[    0.193941] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pio slum part ems sxs apst 
[    0.199165] scsi host0: ahci
[    0.199822] scsi host1: ahci
[    0.200406] scsi host2: ahci
[    0.200982] scsi host3: ahci
[    0.201539] scsi host4: ahci
[    0.202085] scsi host5: ahci
[    0.202493] ata1: SATA max UDMA/133 abar m2048@0xf1628000 port 0xf1628100 irq 26
[    0.203241] ata2: SATA max UDMA/133 abar m2048@0xf1628000 port 0xf1628180 irq 26
[    0.204021] ata3: DUMMY
[    0.204392] ata4: DUMMY
[    0.204761] ata5: SATA max UDMA/133 abar m2048@0xf1628000 port 0xf1628300 irq 26
[    0.205510] ata6: DUMMY
[    0.205965] libphy: Fixed MDIO Bus: probed
[    0.206416] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.206808] ehci-pci: EHCI PCI platform driver
[    0.207265] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    0.207692] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.208438] ehci-pci 0000:00:1a.0: debug port 2
[    0.212702] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    0.212716] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf162a000
[    0.218593] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.218973] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.219331] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.220071] usb usb1: Product: EHCI Host Controller
[    0.220465] usb usb1: Manufacturer: Linux 3.17.0-rc1+ ehci_hcd
[    0.220876] usb usb1: SerialNumber: 0000:00:1a.0
[    0.221405] hub 1-0:1.0: USB hub found
[    0.221820] hub 1-0:1.0: 3 ports detected
[    0.222382] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    0.222819] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.223566] ehci-pci 0000:00:1d.0: debug port 2
[    0.227864] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    0.227876] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf1629000
[    0.233588] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.233985] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.234371] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.235136] usb usb2: Product: EHCI Host Controller
[    0.235520] usb usb2: Manufacturer: Linux 3.17.0-rc1+ ehci_hcd
[    0.235912] usb usb2: SerialNumber: 0000:00:1d.0
[    0.236397] hub 2-0:1.0: USB hub found
[    0.236779] hub 2-0:1.0: 3 ports detected
[    0.237243] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.237633] ohci-pci: OHCI PCI platform driver
[    0.238020] uhci_hcd: USB Universal Host Controller Interface driver
[    0.238468] xhci_hcd 0000:0d:00.0: xHCI Host Controller
[    0.238908] xhci_hcd 0000:0d:00.0: new USB bus registered, assigned bus number 3
[    0.239842] xhci_hcd 0000:0d:00.0: irq 27 for MSI/MSI-X
[    0.239850] xhci_hcd 0000:0d:00.0: irq 28 for MSI/MSI-X
[    0.239854] xhci_hcd 0000:0d:00.0: irq 29 for MSI/MSI-X
[    0.239857] xhci_hcd 0000:0d:00.0: irq 30 for MSI/MSI-X
[    0.239860] xhci_hcd 0000:0d:00.0: irq 31 for MSI/MSI-X
[    0.239984] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    0.240381] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.241172] usb usb3: Product: xHCI Host Controller
[    0.241587] usb usb3: Manufacturer: Linux 3.17.0-rc1+ xhci_hcd
[    0.241999] usb usb3: SerialNumber: 0000:0d:00.0
[    0.242506] hub 3-0:1.0: USB hub found
[    0.242916] hub 3-0:1.0: 2 ports detected
[    0.243379] xhci_hcd 0000:0d:00.0: xHCI Host Controller
[    0.243822] xhci_hcd 0000:0d:00.0: new USB bus registered, assigned bus number 4
[    0.244653] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    0.245067] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.245868] usb usb4: Product: xHCI Host Controller
[    0.246276] usb usb4: Manufacturer: Linux 3.17.0-rc1+ xhci_hcd
[    0.246695] usb usb4: SerialNumber: 0000:0d:00.0
[    0.247199] hub 4-0:1.0: USB hub found
[    0.247629] hub 4-0:1.0: 2 ports detected
[    0.248147] usbcore: registered new interface driver usbserial
[    0.248562] usbcore: registered new interface driver usbserial_generic
[    0.248972] usbserial: USB Serial support registered for generic
[    0.249392] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.253533] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.253937] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.254426] mousedev: PS/2 mouse device common for all mice
[    0.255049] rtc_cmos 00:02: RTC can wake from S4
[    0.255582] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.256000] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.256841] device-mapper: uevent: version 1.0.3
[    0.257325] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    0.258237] Intel P-state driver initializing.
[    0.258685] Intel pstate controlling: cpu 0
[    0.259125] Intel pstate controlling: cpu 1
[    0.259539] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    0.260418] Intel pstate controlling: cpu 2
[    0.261657] Intel pstate controlling: cpu 3
[    0.264035] EFI Variables Facility v0.08 2004-May-17
[    0.286575] hidraw: raw HID events driver (C) Jiri Kosina
[    0.286994] usbcore: registered new interface driver usbhid
[    0.287320] usbhid: USB HID core driver
[    0.287681] drop_monitor: Initializing network drop monitor service
[    0.288078] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.288449] TCP: cubic registered
[    0.288778] Initializing XFRM netlink socket
[    0.289170] NET: Registered protocol family 10
[    0.289696] mip6: Mobile IPv6
[    0.290004] NET: Registered protocol family 17
[    0.290876] Loading compiled-in X.509 certificates
[    0.291968] Loaded X.509 cert 'Magrathea: Glacier signing key: 0e98bcbef2d487a15bbb50ab56a3f100c59c5e4d'
[    0.292624] registered taskstats version 1
[    0.293802]   Magic number: 10:19:25
[    0.295154] rtc_cmos 00:02: setting system clock to 2014-08-25 11:02:38 UTC (1408964558)
[    0.297806] PM: Hibernation image not present or could not be loaded.
[    0.510613] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.512311] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    0.512320] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    0.514613] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    0.517080] ata1.00: ATA-8: INTEL SSDSA2BW160G3L, 4PC1LE04, max UDMA/133
[    0.518213] ata1.00: 312581808 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    0.519931] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    0.519939] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    0.522174] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    0.524632] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    0.526072] ata1.00: configured for UDMA/133
[    0.527610] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2BW16 LE04 PQ: 0 ANSI: 5
[    0.531115] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    0.531231] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.536289] sd 0:0:0:0: [sda] Write Protect is off
[    0.537902] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.537946] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.545393]  sda: sda1 sda2 sda3 sda4 sda5
[    0.547398] sd 0:0:0:0: [sda] Attached SCSI disk


--------------040803050309020004010301--
