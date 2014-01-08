Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbaAHP0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 10:26:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136AbaAHP0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 10:26:47 -0500
Message-ID: <52CD6E33.400@redhat.com>
Date: Wed, 08 Jan 2014 23:26:43 +0800
From: Baoquan <bhe@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130621 Thunderbird/17.0.7
MIME-Version: 1.0
To: linux-acpi@vger.kernel.org
CC: zhangyanfei@cn.fujitsu.com, tangchen@cn.fujitsu.com, vgoyal@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        dyoung@redhat.com
Subject: kdump failed because of hotplug memory adding in kdump kernel
Content-Type: multipart/mixed;
 boundary="------------030102050109050006060709"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030102050109050006060709
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


Hi,

There's a bug found on intel machine which is numa with hotplug memory.
In this machine, numa is on in 1st kernel, but off in 2nd kernel. when
reserve 512M memory even more memory, kdump always failed. The error log
has been added as attachment, you can check it.

>From log, it can be seen clearly hotplug memory caused this, and we set
the memory_device_handler as null to skip the hotplug memory adding,
kdump is successfull.

Below is personal analysis:
-------------------------
>From ACPI code, In 1st kernel init, bios/efi will detect hardware and
form E820 table, meanwhile ACPI is prepared too. Then E820 is built and
passed to 2nd kernel. However, during initialization, acpi table init
call acpi_os_get_root_pointer(), this function will check whether
acpi_rsdp is ready. If not, it will check whether rsdp can be fetched
from efi. Finally, it will try EBDA or area between E0000 and FFFFF
directly. The 3rd is the case of this bug.  Once rsdp is got ,it will
initialize all ACPI tables, and build namespace tree which includes
hotplug memory ns object. That's why hotplug memory can be found.  So
in acpi_bus_scan trigger the memory_device_handler is matched and
acpi_memory_device_add is called.


Now questions:
1)If acpi tables are handled like acpi_os_get_root_pointer() doing,
acpi regions are passed to 2nd kernel by memmap=xx#yy, but where are
they used?  I can see these regions are added into E820 in kdump kernel.

If acpi regions passed from 1st kernel by memmap=xx#yy are not used, and
acpi is detected always like this, I guess there must be something wrong
with it.

2)if we disable memory hotplug in second kernel and if first kernel
reserved a memory in hotplug memory region, will second kerenl still see
that memroy?

Please help check this.

Baoquan
Thanks


--------------030102050109050006060709
Content-Type: text/plain; charset=UTF-8;
 name="error_all.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="error_all.log"

intel-s3e36-01 login: [ 3581.710973] SysRq : Trigger a crash
[ 3581.714909] BUG: unable to handle kernel NULL pointer dereference at           (null)
[ 3581.723668] IP: [<ffffffff81355d46>] sysrq_handle_crash+0x16/0x20
[ 3581.730490] PGD 104e9e5067 PUD 10531fb067 PMD 0 
[ 3581.735674] Oops: 0002 [#1] SMP 
[ 3581.739295] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle
 bridge stp llc ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables sg iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm crc32c_intel igb ptp i7core_edac
 ioatdma pps_core pcspkr lpc_ich microcode i2c_i801 mfd_core edac_core dca shpchp ipmi_si ipmi_msghandler acpi_cpufreq mperf nfsd auth_rpcgss nfs_acl lockd sunrpc xfs libcrc32c
 sd_mod sr_mod crc_t10dif cdrom crct10dif_common ata_generic pata_acpi mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm drm ata_piix libata i2c_core me
garaid_sas dm_mirror dm_region_hash dm_log dm_mod
[ 3581.813366] CPU: 10 PID: 3900 Comm: bash Not tainted 3.10.0-59.el7.x86_64 #1
[ 3581.821231] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS QSSC-S4R.QCI.01.00.S001.032520101647 03/25/2010
[ 3581.831614] task: ffff88084f1cc0e0 ti: ffff88084f22c000 task.ti: ffff88084f22c000
[ 3581.839963] RIP: 0010:[<ffffffff81355d46>]  [<ffffffff81355d46>] sysrq_handle_crash+0x16/0x20
[ 3581.849489] RSP: 0018:ffff88084f22de88  EFLAGS: 00010082
[ 3581.855414] RAX: 000000000000000f RBX: ffffffff81951540 RCX: ffff88105fc50000
[ 3581.863375] RDX: 0000000000000000 RSI: ffff88105fc4e3e8 RDI: 0000000000000063
[ 3581.871336] RBP: ffff88084f22de88 R08: 0000000000000096 R09: 0000000000000718
[ 3581.879296] R10: 0000000000000717 R11: 0000000000000003 R12: 0000000000000063
[ 3581.887256] R13: 0000000000000246 R14: 0000000000000007 R15: 0000000000000000
[ 3581.895217] FS:  00007fc64e83e740(0000) GS:ffff88105fc40000(0000) knlGS:0000000000000000
[ 3581.904243] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3581.910654] CR2: 0000000000000000 CR3: 000000105302e000 CR4: 00000000000007e0
[ 3581.918613] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 3581.926573] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 3581.934534] Stack:
[ 3581.936781]  ffff88084f22dec0 ffffffff813564a2 0000000000000002 00007fc64e843000
[ 3581.945082]  ffff88084f22df50 0000000000000002 0000000000000000 ffff88084f22ded8
[ 3581.953384]  ffffffff8135697f ffff8820538a0600 ffff88084f22def8 ffffffff812023ad
[ 3581.961683] Call Trace:
[ 3581.964418]  [<ffffffff813564a2>] __handle_sysrq+0xa2/0x170
[ 3581.970638]  [<ffffffff8135697f>] write_sysrq_trigger+0x2f/0x40
[ 3581.977249]  [<ffffffff812023ad>] proc_reg_write+0x3d/0x80
[ 3581.983375]  [<ffffffff8119ee7d>] vfs_write+0xbd/0x1e0
[ 3581.989110]  [<ffffffff8119f849>] SyS_write+0x49/0xa0
[ 3581.994753]  [<ffffffff815c6319>] system_call_fastpath+0x16/0x1b
[ 3582.001452] Code: 65 34 75 e5 4c 89 ef e8 f9 f7 ff ff eb db 0f 1f 80 00 00 00 00 66 66 66 66 90 55 c7 05 10 13 57 00 01 00 00 00 48 89 e5 0f ae f8 <c6> 04 25 00 00 00 00 01 
5d c3 66 66 66 66 90 55 31 c0 c7 05 6e 
[ 3582.023271] RIP  [<ffffffff81355d46>] sysrq_handle_crash+0x16/0x20
[ 3582.030178]  RSP <ffff88084f22de88>
[ 3582.034066] CR2: 0000000000000000
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.10.0-59.el7.x86_64 (mockbuild@x86-017.build.eng.bos.redhat.com) (gcc version 4.8.2 20131106 (Red Hat 4.8.2-3) (GCC) ) #1 SMP Thu Dec 5 00:33:07 E
ST 2013
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.10.0-59.el7.x86_64 root=/dev/mapper/rhel_intel--s3e36--01-root ro rd.lvm.lv=rhel_intel-s3e36-01/swap vconsole.font=latarcyrhe
b-sun16 console=ttyS0,115200n81 vconsole.keymap=us rd.lvm.lv=rhel_intel-s3e36-01/root LANG=en_US.UTF-8 irqpoll nr_cpus=1 reset_devices cgroup_disable=memory mce=off numa=off ud
ev.children-max=2 panic=10 rootflags=nofail memmap=exactmap memmap=616K@4K memmap=138624K@753664K elfcorehdr=892288K memmap=2132K#1978716K memmap=3820K#1980848K memmap=56K#1985
144K memmap=116K#1985288K memmap=16K#1985456K memmap=128K#1985492K memmap=188K#1985752K memmap=5900K#1986200K memmap=2048K#1992100K memmap=1292K#1994148K memmap=588K#1995632K m
emmap=576K#1996240K memmap=31684K#1997240K memmap=1248K#2029884K memmap=288K#2031132K memmap=192K#2031420K
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009afff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009b000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000078c56fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000078c57000-0x0000000078e6bfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000078e6c000-0x0000000079226fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079227000-0x000000007929dfff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007929e000-0x00000000792abfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000792ac000-0x00000000792c1fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000792c2000-0x00000000792defff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000792df000-0x00000000792ebfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000792ec000-0x00000000792effff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000792f0000-0x00000000792f4fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000792f5000-0x0000000079314fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079315000-0x0000000079335fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000079336000-0x0000000079364fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079365000-0x00000000793a5fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000793a6000-0x0000000079968fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079969000-0x0000000079b68fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000079b69000-0x0000000079cabfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079cac000-0x0000000079cdbfff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000079cdc000-0x0000000079d6efff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079d6f000-0x0000000079d73fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000079d74000-0x0000000079e03fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079e04000-0x0000000079e6dfff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000079e6e000-0x000000007bd5efff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bd5f000-0x000000007be4efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007be4f000-0x000000007bf86fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bf87000-0x000000007bfcefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007bfcf000-0x000000007bffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bfff000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fc000000-0x00000000fcffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000207fffffff] usable
[    0.000000] e820: last_pfn = 0x2080000 max_arch_pfn = 0x400000000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: user-defined physical RAM map:
[    0.000000] user: [mem 0x0000000000001000-0x000000000009afff] usable
[    0.000000] user: [mem 0x000000002e000000-0x000000003675ffff] usable
[    0.000000] user: [mem 0x0000000078c57000-0x0000000079226fff] ACPI data
[    0.000000] user: [mem 0x000000007929e000-0x00000000792abfff] ACPI data
[    0.000000] user: [mem 0x00000000792c2000-0x00000000792defff] ACPI data
[    0.000000] user: [mem 0x00000000792ec000-0x00000000792effff] ACPI data
[    0.000000] user: [mem 0x00000000792f5000-0x0000000079314fff] ACPI data
[    0.000000] user: [mem 0x0000000079336000-0x0000000079364fff] ACPI data
[    0.000000] user: [mem 0x00000000793a6000-0x0000000079cabfff] ACPI data
[    0.000000] user: [mem 0x0000000079cdc000-0x0000000079d6efff] ACPI data
[    0.000000] user: [mem 0x0000000079d74000-0x0000000079e03fff] ACPI data
[    0.000000] user: [mem 0x0000000079e6e000-0x000000007bd5efff] ACPI data
[    0.000000] user: [mem 0x000000007be4f000-0x000000007bffefff] ACPI data
[    0.000000] SMBIOS 2.5 present.
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x36760 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] x2apic enabled by BIOS, switching to x2apic ops
[    0.000000] found SMP MP-table at [mem 0x000fdd50-0x000fdd5f] mapped at [ffff8800000fdd50]
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000] init_memory_mapping: [mem 0x36400000-0x365fffff]
[    0.000000] init_memory_mapping: [mem 0x34000000-0x363fffff]
[    0.000000] init_memory_mapping: [mem 0x2e000000-0x33ffffff]
[    0.000000] init_memory_mapping: [mem 0x36600000-0x3675ffff]
[    0.000000] RAMDISK: [mem 0x3449a000-0x34ffefff]
[    0.000000] ACPI: RSDP 00000000000f0410 00024 (v02 QUANTA)
[    0.000000] ACPI: XSDT 000000007bffe120 000BC (v01 QUANTA QSSC-S4R 00000000      01000013)
[    0.000000] ACPI: FACP 000000007bffd000 000F4 (v04 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: DSDT 000000007bfe3000 19FC5 (v02 QUANTA QSSC-S4R 00000003 MSFT 0100000D)
[    0.000000] ACPI: FACS 000000007bf87000 00040
[    0.000000] ACPI: APIC 000000007bfe2000 003E4 (v02 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: MSCT 000000007bfe1000 00090 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: MCFG 000000007bfe0000 0003C (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: HPET 000000007bfdf000 00038 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: SLIT 000000007bfde000 0003C (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: SRAT 000000007bfdd000 00930 (v02 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: SPCR 000000007bfdc000 00050 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: WDDT 000000007bfdb000 00040 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: SSDT 000000007bf4a000 3CFA4 (v02 QUANTA QSSC-S4R 00004000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000007bfda000 00174 (v02 QUANTA QSSC-S4R 00004000 INTL 20061109)
[    0.000000] ACPI: PMCT 000000007bfd9000 00060 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: MIGT 000000007bfd8000 00040 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: TCPA 000000007bfd5000 00032 (v00 QUANTA QSSC-S4R 00000000      00000000)
[    0.000000] ACPI: HEST 000000007bfd4000 000A8 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: BERT 000000007bfd3000 00030 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: ERST 000000007bfd2000 00230 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: EINJ 000000007bfd1000 00130 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: DMAR 000000007bfd0000 00350 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] Setting APIC routing to cluster x2apic.
[    0.000000] NUMA turned off
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000003675ffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x3675ffff]
[    0.000000]   NODE_DATA [mem 0x36739000-0x3675ffff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009afff]
[    0.000000]   node   0: [mem 0x2e000000-0x3675ffff]
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 almost reached. Keeping one slot for boot cpu.  Processor 0/0x0 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x40] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 almost reached. Keeping one slot for boot cpu.  Processor 1/0x40 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x20] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 almost reached. Keeping one slot for boot cpu.  Processor 2/0x20 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0x60] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 almost reached. Keeping one slot for boot cpu.  Processor 3/0x60 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 almost reached. Keeping one slot for boot cpu.  Processor 4/0x2 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0x42] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 almost reached. Keeping one slot for boot cpu.  Processor 5/0x42 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x22] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 almost reached. Keeping one slot for boot cpu.  Processor 6/0x22 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0x62] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 almost reached. Keeping one slot for boot cpu.  Processor 7/0x62 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 almost reached. Keeping one slot for boot cpu.  Processor 8/0x4 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0x44] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 almost reached. Keeping one slot for boot cpu.  Processor 9/0x44 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0x64] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 11/0x64 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 12/0x6 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0x46] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 13/0x46 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x26] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 14/0x26 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0x66] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 15/0x66 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x10] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 16/0x10 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0x50] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 17/0x50 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x30] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 18/0x30 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0x70] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 19/0x70 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x12] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 20/0x12 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0x52] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 21/0x52 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x32] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 22/0x32 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0x72] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 23/0x72 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x14] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 24/0x14 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0x54] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 25/0x54 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x34] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 26/0x34 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0x74] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 27/0x74 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x16] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 28/0x16 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x2e] lapic_id[0x56] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 29/0x56 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x36] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 30/0x36 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x3e] lapic_id[0x76] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 31/0x76 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 32/0x1 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x41] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 33/0x41 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x21] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 34/0x21 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0x61] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 35/0x61 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 36/0x3 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0x43] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 37/0x43 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x23] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 38/0x23 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0x63] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 39/0x63 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 40/0x5 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0x45] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 41/0x45 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 42/0x25 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0x65] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 43/0x65 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 44/0x7 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x47] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 45/0x47 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x27] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 46/0x27 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0x67] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 47/0x67 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x11] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 48/0x11 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0x51] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 49/0x51 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x31] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 50/0x31 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0x71] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 51/0x71 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 52/0x13 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0x53] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 53/0x53 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x33] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 54/0x33 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0x73] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 55/0x73 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x15] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 56/0x15 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0x55] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 57/0x55 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x35] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 58/0x35 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0x75] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 59/0x75 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x17] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 60/0x17 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x2f] lapic_id[0x57] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 61/0x57 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x37] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 62/0x37 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x3f] lapic_id[0x77] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 63/0x77 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x10] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x11] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x12] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x13] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x14] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x15] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x16] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x17] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x18] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x19] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x20] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x21] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x22] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x23] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x24] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x25] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x26] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x27] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x28] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x29] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x30] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x31] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x32] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x33] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x34] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x35] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x36] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x37] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x38] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x39] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3f] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec04000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec04000, GSI 48-71
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a401 base: 0xfed00000
[    0.000000] smpboot: 64 Processors exceeds NR_CPUS limit of 1
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x0009b000-0x2dffffff]
[    0.000000] e820: [mem 0x7bfff000-0xffffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:5120 nr_cpumask_bits:1 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880036400000 s86784 r8192 d23808 u2097152
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 34243
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.10.0-59.el7.x86_64 root=/dev/mapper/rhel_intel--s3e36--01-root ro rd.lvm.lv=rhel_intel-s3e36-01/swap vconsole.font=lat
arcyrheb-sun16 console=ttyS0,115200n81 vconsole.keymap=us rd.lvm.lv=rhel_intel-s3e36-01/root LANG=en_US.UTF-8 irqpoll nr_cpus=1 reset_devices cgroup_disable=memory mce=off numa
=off udev.children-max=2 panic=10 rootflags=nofail memmap=exactmap memmap=616K@4K memmap=138624K@753664K elfcorehdr=892288K memmap=2132K#1978716K memmap=3820K#1980848K memmap=5
6K#1985144K memmap=116K#1985288K memmap=16K#1985456K memmap=128K#1985492K memmap=188K#1985752K memmap=5900K#1986200K memmap=2048K#1992100K memmap=1292K#1994148K memmap=588K#199
5632K memmap=576K#1996240K memmap=31684K#1997240K memmap=1248K#2029884K memmap=288K#2031132K memmap=192K#2031420K
[    0.000000] Misrouted IRQ fixup and polling support enabled
[    0.000000] This may significantly impact system performance
[    0.000000] Disabling memory control group subsystem
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 106808k/892288k available (5930k kernel code, 753048k absent, 32432k reserved, 4048k data, 1568k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU restricting CPUs from NR_CPUS=5120 to nr_cpu_ids=1.
[    0.000000]  Experimental no-CBs for all CPUs
[    0.000000]  Experimental no-CBs CPUs: 0.
[    0.000000] NR_IRQS:327936 nr_irqs:256 16
[    0.000000] Spurious LAPIC timer interrupt on cpu 0
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [ttyS0] enabled
[    0.001000] tsc: Fast TSC calibration using PIT
[    0.002000] tsc: Detected 1994.878 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 3989.75 BogoMIPS (lpj=1994878)
[    0.011869] pid_max: default: 32768 minimum: 301
[    0.017058] Security Framework initialized
[    0.021650] SELinux:  Initializing.
[    0.025656] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.033523] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.041246] Mount-cache hash table entries: 256
[    0.046584] Initializing cgroup subsys memory
[    0.051471] Initializing cgroup subsys devices
[    0.056437] Initializing cgroup subsys freezer
[    0.061403] Initializing cgroup subsys net_cls
[    0.066368] Initializing cgroup subsys blkio
[    0.071140] Initializing cgroup subsys perf_event
[    0.076398] Initializing cgroup subsys hugetlb
[    0.081410] CPU: Physical Processor ID: 1
[    0.085892] CPU: Processor Core ID: 2
[    0.089998] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.089998] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.089998] tlb_flushall_shift: 6
[    0.113505] Freeing SMP alternatives: 24k freed
[    0.120091] ACPI: Core revision 20130517
[    0.169680] ACPI: All ACPI Tables successfully acquired
[    0.175575] ftrace: allocating 23282 entries in 91 pages
[    0.197400] dmar: Host address width 48
[    0.201689] dmar: DRHD base: 0x000000fd800000 flags: 0x0
[    0.207628] dmar: IOMMU 0: reg_base_addr fd800000 ver 1:0 cap c90780106f0462 ecap f020fe
[    0.216662] dmar: DRHD base: 0x000000fd000000 flags: 0x1
[    0.222599] dmar: IOMMU 1: reg_base_addr fd000000 ver 1:0 cap c90780106f0462 ecap f020fe
[    0.231632] dmar: RMRR base: 0x0000007be29000 end: 0x0000007be2bfff
[    0.238631] dmar: RMRR base: 0x0000007be16000 end: 0x0000007be16fff
[    0.245628] dmar: RMRR base: 0x0000007be13000 end: 0x0000007be13fff
[    0.252627] dmar: RMRR base: 0x0000007be10000 end: 0x0000007be10fff
[    0.259626] dmar: RMRR base: 0x0000007be0d000 end: 0x0000007be0dfff
[    0.266623] dmar: RMRR base: 0x0000007be0a000 end: 0x0000007be0afff
[    0.273621] dmar: RMRR base: 0x0000007be07000 end: 0x0000007be07fff
[    0.280620] dmar: RMRR base: 0x0000007be04000 end: 0x0000007be04fff
[    0.287618] dmar: RMRR base: 0x0000007be01000 end: 0x0000007be01fff
[    0.294617] dmar: ATSR flags: 0x0
[    0.298320] dmar: ATSR flags: 0x0
[    0.302023] dmar: RHSA base: 0x000000fd000000 proximity domain: 0x0
[    0.309021] dmar: RHSA base: 0x000000fd800000 proximity domain: 0x2
[    0.316167] IOAPIC id 10 under DRHD base  0xfd800000 IOMMU 0
[    0.322477] IOAPIC id 8 under DRHD base  0xfd000000 IOMMU 1
[    0.328689] IOAPIC id 9 under DRHD base  0xfd000000 IOMMU 1
[    0.335769] Enabled IRQ remapping in x2apic mode
[    0.341736] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.358437] smpboot: CPU0: Intel(R) Xeon(R) CPU           X7550  @ 2.00GHz (fam: 06, model: 2e, stepping: 06)
[    0.471371] Performance Events: PEBS fmt1+, 16-deep LBR, Nehalem events, Broken BIOS detected, complain to your hardware vendor.
[    0.484321] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 38d is b0)
[    0.492860] Intel PMU driver.
[    0.496167] perf_event_intel: CPU erratum AAJ80 worked around
[    0.502574] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.510243] ... version:                3
[    0.514713] ... bit width:              48
[    0.519280] ... generic registers:      4
[    0.523749] ... value mask:             0000ffffffffffff
[    0.529671] ... max period:             000000007fffffff
[    0.535595] ... fixed-purpose events:   3
[    0.540064] ... event mask:             000000070000000f
[    0.547679] Brought up 1 CPUs
[    0.550982] smpboot: Total of 1 processors activated (3989.75 BogoMIPS)
[    0.558451] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.572156] devtmpfs: initialized
[    0.578417] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.586148] NET: Registered protocol family 16
[    0.591483] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.599928] ACPI: bus type PCI registered
[    0.604400] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.611678] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
[    0.622062] PCI: not using MMCONFIG
[    0.625950] PCI: Using configuration type 1 for base access
[    0.633153] bio: create slab <bio-0> at 0
[    0.637739] ACPI: Added _OSI(Module Device)
[    0.642400] ACPI: Added _OSI(Processor Device)
[    0.647355] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.652605] ACPI: Added _OSI(Processor Aggregator Device)
[    0.712584] ACPI Error: Field [CPB3] at 96 exceeds Buffer [NULL] size 64 (bits) (20130517/dsopcode-236)
[    0.723083] ACPI Error: Method parse/execution failed [\_SB_._OSC] (Node ffff8800339112a8), AE_AML_BUFFER_LIMIT (20130517/psparse-536)
[    0.744246] ACPI: Interpreter enabled
[    0.748340] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130517/hwxface-571)
[    0.758647] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20130517/hwxface-571)
[    0.768953] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S4_] (20130517/hwxface-571)
[    0.779264] ACPI: (supports S0 S1 S5)
[    0.783338] ACPI: Using IOAPIC for interrupt routing
[    0.788888] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
[    0.802516] [Firmware Info]: PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] not reserved in ACPI motherboard resources
[    0.814256] PCI: not using MMCONFIG
[    0.818176] HEST: Table parsing has been initialized.
[    0.823813] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.835832] ACPI: No dock devices found.
[    0.863843] ACPI: PCI Root Bridge [IOH0] (domain 0000 [bus 00-7f])
[    0.870745] acpi PNP0A08:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    0.878486] acpi PNP0A08:00: _OSC: not requesting OS control; OS requires [ExtendedConfig ASPM ClockPM MSI]
[    0.889789] acpi PNP0A08:00: ignoring host bridge window [mem 0x000c4000-0x000cbfff] (conflicts with Video ROM [mem 0x000c0000-0x000c7fff])
[    0.903760] acpi PNP0A08:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.916738] PCI host bridge to bus 0000:00
[    0.921310] pci_bus 0000:00: root bus resource [bus 00-7f]
[    0.927428] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.934321] pci_bus 0000:00: root bus resource [io  0x1000-0x9fff]
[    0.941215] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.948884] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfedfffff]
[    0.956553] pci_bus 0000:00: root bus resource [mem 0x90000000-0xcfffffff]
[    0.964228] pci_bus 0000:00: root bus resource [mem 0xfc000000000-0xfc07fffffff]
[    0.972732] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.979203] pci 0000:00:02.0: System wakeup disabled by ACPI
[    0.985836] pci 0000:00:05.0: System wakeup disabled by ACPI
[    0.992307] pci 0000:00:07.0: System wakeup disabled by ACPI
[    0.998779] pci 0000:00:09.0: System wakeup disabled by ACPI
[    1.005249] pci 0000:00:0a.0: System wakeup disabled by ACPI
[    1.015605] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    1.022118] pci 0000:00:1a.1: System wakeup disabled by ACPI
[    1.028625] pci 0000:00:1a.2: System wakeup disabled by ACPI
[    1.035180] pci 0000:00:1a.7: System wakeup disabled by ACPI
[    1.041672] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    1.048159] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    1.054671] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    1.061179] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    1.067685] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    1.074227] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    1.080686] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    1.087116] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH6 ACPI/GPIO/TCO
[    1.095950] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    1.103912] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 000f)
[    1.112348] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
[    1.120795] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0600 (mask 001f)
[    1.132897] pci 0000:00:01.0: PCI bridge to [bus 01-03]
[    1.141888] pci 0000:00:02.0: PCI bridge to [bus 04-06]
[    1.150877] pci 0000:00:03.0: PCI bridge to [bus 07]
[    1.156635] acpiphp: Slot [1] registered
[    1.161156] pci 0000:00:05.0: PCI bridge to [bus 08-0a]
[    1.167198] acpiphp: Slot [2] registered
[    1.171722] pci 0000:00:07.0: PCI bridge to [bus 0b-0d]
[    1.177732] pci 0000:00:09.0: PCI bridge to [bus 0e]
[    1.183459] pci 0000:00:0a.0: PCI bridge to [bus 0f]
[    1.189096] pci 0000:00:1c.0: PCI bridge to [bus 10]
[    1.196849] pci 0000:00:1c.4: PCI bridge to [bus 11]
[    1.202466] pci 0000:00:1e.0: PCI bridge to [bus 12] (subtractive decode)
[    1.210539] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    1.220075] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    1.229603] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    1.239129] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    1.248658] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    1.258191] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    1.267721] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    1.277251] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    1.286991] ACPI: PCI Root Bridge [IOH1] (domain 0000 [bus 80-f7])
[    1.293887] acpi PNP0A08:01: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    1.301549] acpi PNP0A08:01: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.308949] acpi PNP0A08:01: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    1.321835] PCI host bridge to bus 0000:80
[    1.326407] pci_bus 0000:80: root bus resource [bus 80-f7]
[    1.332524] pci_bus 0000:80: root bus resource [io  0xa000-0xffff]
[    1.339417] pci_bus 0000:80: root bus resource [mem 0xd0000000-0xfbffffff]
[    1.347087] pci_bus 0000:80: root bus resource [mem 0xfc080000000-0xfc0ffffffff]
[    1.355432] pci 0000:80:00.0: System wakeup disabled by ACPI
[    1.361882] pci 0000:80:01.0: System wakeup disabled by ACPI
[    1.368325] pci 0000:80:03.0: System wakeup disabled by ACPI
[    1.374775] pci 0000:80:07.0: System wakeup disabled by ACPI
[    1.381216] pci 0000:80:09.0: System wakeup disabled by ACPI
[    1.390765] pci 0000:80:00.0: PCI bridge to [bus 81]
[    1.396495] pci 0000:80:01.0: PCI bridge to [bus 82]
[    1.402208] pci 0000:80:03.0: PCI bridge to [bus 83]
[    1.407944] acpiphp: Slot [6] registered
[    1.412466] pci 0000:80:07.0: PCI bridge to [bus 84-86]
[    1.418508] acpiphp: Slot [7] registered
[    1.423024] pci 0000:80:09.0: PCI bridge to [bus 87-89]
[    1.429270] ACPI: PCI Root Bridge [PRB3] (domain 0000 [bus fc])
[    1.435877] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    1.443547] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.450932] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    1.463765] PCI host bridge to bus 0000:fc
[    1.468324] pci_bus 0000:fc: root bus resource [bus fc]
[    1.476390] ACPI: PCI Root Bridge [PRB2] (domain 0000 [bus fd])
[    1.482999] acpi PNP0A03:01: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    1.490670] acpi PNP0A03:01: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.498056] acpi PNP0A03:01: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    1.510880] PCI host bridge to bus 0000:fd
[    1.515447] pci_bus 0000:fd: root bus resource [bus fd]
[    1.523521] ACPI: PCI Root Bridge [PRB1] (domain 0000 [bus fe])
[    1.530128] acpi PNP0A03:02: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    1.537801] acpi PNP0A03:02: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.545186] acpi PNP0A03:02: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    1.558016] PCI host bridge to bus 0000:fe
[    1.562586] pci_bus 0000:fe: root bus resource [bus fe]
[    1.570568] ACPI: PCI Root Bridge [PRB0] (domain 0000 [bus ff])
[    1.577174] acpi PNP0A03:03: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    1.584836] acpi PNP0A03:03: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.592222] acpi PNP0A03:03: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    1.605045] PCI host bridge to bus 0000:ff
[    1.609615] pci_bus 0000:ff: root bus resource [bus ff]
[    1.632117] System RAM resource [mem 0x01000000-0x7bffffff] cannot be added
[    1.639892] init_memory_mapping: [mem 0x100000000-0x87fffffff]
[    1.717793] swapper/0: page allocation failure: order:9, mode:0x84d0
[    1.724884] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-59.el7.x86_64 #1
[    1.732842] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS QSSC-S4R.QCI.01.00.S001.032520101647 03/25/2010
[    1.743224]  0000000000000000 ffff8800339878c8 ffffffff815b64ad ffff880033987950
[    1.751513]  ffffffff8113a980 ffff88003673ab28 00000000000001fe 0000000000000001
[    1.759804]  ffff880000000040 ffffffff810bc28a 0000000000000000 0000000000000200
[    1.768096] Call Trace:                                                                                                                                            [348/1928]
[    1.770834]  [<ffffffff815b64ad>] dump_stack+0x19/0x1b
[    1.776561]  [<ffffffff8113a980>] warn_alloc_failed+0xf0/0x160
[    1.783076]  [<ffffffff810bc28a>] ? on_each_cpu_mask+0x2a/0x60
[    1.789581]  [<ffffffff8113e92f>] __alloc_pages_nodemask+0x7ff/0xa00
[    1.796672]  [<ffffffff815ada2c>] vmemmap_alloc_block+0x62/0xba
[    1.803274]  [<ffffffff815ada99>] vmemmap_alloc_block_buf+0x15/0x3b
[    1.810263]  [<ffffffff815ab8a6>] vmemmap_populate+0xb4/0x21b
[    1.816673]  [<ffffffff815adecd>] sparse_mem_map_populate+0x27/0x35
[    1.823665]  [<ffffffff815ad8bf>] sparse_add_one_section+0x7a/0x185
[    1.830659]  [<ffffffff8159b74f>] __add_pages+0xaf/0x240
[    1.836588]  [<ffffffff81047359>] arch_add_memory+0x59/0xd0
[    1.842804]  [<ffffffff8159ba89>] add_memory+0xb9/0x1b0
[    1.848638]  [<ffffffff8132dd2c>] acpi_memory_device_add+0x18d/0x26d
[    1.855728]  [<ffffffff81303b91>] acpi_bus_device_attach+0x7d/0xcd
[    1.862625]  [<ffffffff8131d92d>] acpi_ns_walk_namespace+0xc8/0x17f
[    1.869616]  [<ffffffff81303b14>] ? acpi_bus_type_and_status+0x90/0x90
[    1.876896]  [<ffffffff81303b14>] ? acpi_bus_type_and_status+0x90/0x90
[    1.884177]  [<ffffffff8131de1c>] acpi_walk_namespace+0x95/0xc5
[    1.890780]  [<ffffffff81304866>] acpi_bus_scan+0x8b/0x9d
[    1.896805]  [<ffffffff81a14a15>] acpi_scan_init+0x63/0x160
[    1.903021]  [<ffffffff81a14830>] acpi_init+0x25d/0x2a6
[    1.908849]  [<ffffffff81a145d3>] ? acpi_sleep_proc_init+0x2a/0x2a
[    1.915746]  [<ffffffff810020e2>] do_one_initcall+0xe2/0x190
[    1.922063]  [<ffffffff819d70c4>] kernel_init_freeable+0x17c/0x207
[    1.928957]  [<ffffffff819d68d0>] ? do_early_param+0x88/0x88
[    1.935270]  [<ffffffff81599750>] ? rest_init+0x80/0x80
[    1.941099]  [<ffffffff8159975e>] kernel_init+0xe/0x180
[    1.946931]  [<ffffffff815c626c>] ret_from_fork+0x7c/0xb0
[    1.952952]  [<ffffffff81599750>] ? rest_init+0x80/0x80
[    1.958779] Mem-Info:
[    1.961310] Node 0 DMA per-cpu:
[    1.964824] CPU    0: hi:    0, btch:   1 usd:   0
[    1.970165] Node 0 DMA32 per-cpu:
[    1.973870] CPU    0: hi:   42, btch:   7 usd:   0
[    1.979213] active_anon:0 inactive_anon:0 isolated_anon:0
[    1.979213]  active_file:0 inactive_file:0 isolated_file:0
[    1.979213]  unevictable:0 dirty:0 writeback:0 unstable:0
[    1.979213]  free:2840 slab_reclaimable:13 slab_unreclaimable:2030
[    1.979213]  mapped:0 shmem:0 pagetables:0 bounce:0
[    1.979213]  free_cma:0
[    2.012368] Node 0 DMA free:528kB min:0kB low:0kB high:0kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB i[307/1928]
le):0kB present:616kB managed:528kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstabl
e:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[    2.054935] lowmem_reserve[]: 0 0 0 0
[    2.059066] Node 0 DMA32 free:10832kB min:0kB low:0kB high:0kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolate
d(file):0kB present:138624kB managed:106280kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:52kB slab_unreclaimable:8120kB kernel_stack:160kB pageta
bles:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[    2.103184] lowmem_reserve[]: 0 0 0 0
[    2.107317] Node 0 DMA: 0*4kB 0*8kB 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 528kB
[    2.120688] Node 0 DMA32: 8*4kB (UEM) 6*8kB (EM) 6*16kB (EM) 5*32kB (EM) 4*64kB (UM) 4*128kB (EM) 6*256kB (UEM) 6*512kB (UEM) 5*1024kB (EM) 0*2048kB 0*4096kB = 10832kB
[    2.137594] 0 total pagecache pages
[    2.141483] 0 pages in swap cache
[    2.145177] Swap cache stats: add 0, delete 0, find 0/0
[    2.151002] Free swap  = 0kB
[    2.154212] Total swap = 0kB
[    2.211525] 1441791 pages RAM
[    2.214838] 1408779 pages reserved
[    2.218629] 0 pages shared
[    2.221644] 2301 pages non-shared
[    2.225341] vmemmap: falling back to regular page backing
[    2.242967] swapper/0: page allocation failure: order:9, mode:0x84d0
[    2.250056] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-59.el7.x86_64 #1
[    2.258015] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS QSSC-S4R.QCI.01.00.S001.032520101647 03/25/2010
[    2.268396]  0000000000000000 ffff8800339878c8 ffffffff815b64ad ffff880033987950
[    2.276684]  ffffffff8113a980 ffff88003673ab00 0000000000000009 00000000000084d0
[    2.284971]  ffff880033987950 ffffffff815b2177 ffff8800367396c0 0000000000000000
[    2.293259] Call Trace:                                                                                                                                            [281/1928]
[    2.295998]  [<ffffffff815b64ad>] dump_stack+0x19/0x1b
[    2.301733]  [<ffffffff8113a980>] warn_alloc_failed+0xf0/0x160
[    2.308239]  [<ffffffff815b2177>] ? __alloc_pages_direct_compact+0x185/0x196
[    2.316103]  [<ffffffff8113e92f>] __alloc_pages_nodemask+0x7ff/0xa00
[    2.323195]  [<ffffffff815ada2c>] vmemmap_alloc_block+0x62/0xba
[    2.329797]  [<ffffffff815ada99>] vmemmap_alloc_block_buf+0x15/0x3b
[    2.336788]  [<ffffffff815ab8a6>] vmemmap_populate+0xb4/0x21b
[    2.343196]  [<ffffffff815adecd>] sparse_mem_map_populate+0x27/0x35
[    2.350186]  [<ffffffff815ad8bf>] sparse_add_one_section+0x7a/0x185
[    2.357181]  [<ffffffff8159b74f>] __add_pages+0xaf/0x240
[    2.363110]  [<ffffffff81047359>] arch_add_memory+0x59/0xd0
[    2.369326]  [<ffffffff8159ba89>] add_memory+0xb9/0x1b0
[    2.375159]  [<ffffffff8132dd2c>] acpi_memory_device_add+0x18d/0x26d
[    2.382249]  [<ffffffff81303b91>] acpi_bus_device_attach+0x7d/0xcd
[    2.389146]  [<ffffffff8131d92d>] acpi_ns_walk_namespace+0xc8/0x17f
[    2.396135]  [<ffffffff81303b14>] ? acpi_bus_type_and_status+0x90/0x90
[    2.403415]  [<ffffffff81303b14>] ? acpi_bus_type_and_status+0x90/0x90
[    2.410695]  [<ffffffff8131de1c>] acpi_walk_namespace+0x95/0xc5
[    2.417297]  [<ffffffff81304866>] acpi_bus_scan+0x8b/0x9d
[    2.423323]  [<ffffffff81a14a15>] acpi_scan_init+0x63/0x160
[    2.429539]  [<ffffffff81a14830>] acpi_init+0x25d/0x2a6
[    2.435366]  [<ffffffff81a145d3>] ? acpi_sleep_proc_init+0x2a/0x2a
[    2.442263]  [<ffffffff810020e2>] do_one_initcall+0xe2/0x190
[    2.448579]  [<ffffffff819d70c4>] kernel_init_freeable+0x17c/0x207
[    2.455472]  [<ffffffff819d68d0>] ? do_early_param+0x88/0x88
[    2.461785]  [<ffffffff81599750>] ? rest_init+0x80/0x80
[    2.467612]  [<ffffffff8159975e>] kernel_init+0xe/0x180
[    2.473444]  [<ffffffff815c626c>] ret_from_fork+0x7c/0xb0
[    2.479464]  [<ffffffff81599750>] ? rest_init+0x80/0x80
[    2.485290] Mem-Info:
[    2.487822] Node 0 DMA per-cpu:
[    2.491336] CPU    0: hi:    0, btch:   1 usd:   0
[    2.496676] Node 0 DMA32 per-cpu:
[    2.500381] CPU    0: hi:   42, btch:   7 usd:   0
[    2.505724] active_anon:0 inactive_anon:0 isolated_anon:0
[    2.505724]  active_file:0 inactive_file:0 isolated_file:0
[    2.505724]  unevictable:0 dirty:0 writeback:0 unstable:0
[    2.505724]  free:2324 slab_reclaimable:13 slab_unreclaimable:2033
[    2.505724]  mapped:0 shmem:0 pagetables:0 bounce:0
[    2.505724]  free_cma:0
[    2.538880] Node 0 DMA free:528kB min:0kB low:0kB high:0kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB i[240/1928]
le):0kB present:616kB managed:528kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstabl
e:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[    2.581447] lowmem_reserve[]: 0 0 0 0
[    2.585581] Node 0 DMA32 free:8768kB min:0kB low:0kB high:0kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated
(file):0kB present:138624kB managed:106280kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:52kB slab_unreclaimable:8132kB kernel_stack:160kB pagetab
les:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[    2.629602] lowmem_reserve[]: 0 0 0 0
[    2.633735] Node 0 DMA: 0*4kB 0*8kB 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 528kB
[    2.647101] Node 0 DMA32: 6*4kB (M) 7*8kB (UM) 5*16kB (UM) 5*32kB (UM) 4*64kB (UM) 4*128kB (UM) 4*256kB (M) 5*512kB (UM) 4*1024kB (M) 0*2048kB 0*4096kB = 8768kB
[    2.663328] 0 total pagecache pages
[    2.667218] 0 pages in swap cache
[    2.670913] Swap cache stats: add 0, delete 0, find 0/0
[    2.676738] Free swap  = 0kB
[    2.679948] Total swap = 0kB
[    2.740555] 1474559 pages RAM
[    2.743866] 1441547 pages reserved
[    2.747656] 0 pages shared
[    2.750671] 2817 pages non-shared
[    2.765958] swapper/0: page allocation failure: order:9, mode:0x84d0
[    2.773040] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-59.el7.x86_64 #1
[    2.780990] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS QSSC-S4R.QCI.01.00.S001.032520101647 03/25/2010
[    2.791371]  0000000000000000 ffff8800339878c8 ffffffff815b64ad ffff880033987950
[    2.799663]  ffffffff8113a980 ffff88003673ab28 00000000000001fe 0000000000000001
[    2.807950]  ffff880000000040 ffffffff810bc28a 0000000000000000 0000000000000200
[    2.816240] Call Trace:
[    2.818978]  [<ffffffff815b64ad>] dump_stack+0x19/0x1b
[    2.824715]  [<ffffffff8113a980>] warn_alloc_failed+0xf0/0x160
[    2.831227]  [<ffffffff810bc28a>] ? on_each_cpu_mask+0x2a/0x60
[    2.837732]  [<ffffffff8113e92f>] __alloc_pages_nodemask+0x7ff/0xa00
[    2.844826]  [<ffffffff815ada2c>] vmemmap_alloc_block+0x62/0xba
[    2.851428]  [<ffffffff815ada99>] vmemmap_alloc_block_buf+0x15/0x3b
[    2.858420]  [<ffffffff815ab8a6>] vmemmap_populate+0xb4/0x21b
[    2.864830]  [<ffffffff815adecd>] sparse_mem_map_populate+0x27/0x35
[    2.871820]  [<ffffffff815ad8bf>] sparse_add_one_section+0x7a/0x185
[    2.878815]  [<ffffffff8159b74f>] __add_pages+0xaf/0x240
[    2.884747]  [<ffffffff81047359>] arch_add_memory+0x59/0xd0
[    2.890962]  [<ffffffff8159ba89>] add_memory+0xb9/0x1b0
[    2.896795]  [<ffffffff8132dd2c>] acpi_memory_device_add+0x18d/0x26d
[    2.903886]  [<ffffffff81303b91>] acpi_bus_device_attach+0x7d/0xcd
[    2.910783]  [<ffffffff8131d92d>] acpi_ns_walk_namespace+0xc8/0x17f
[    2.917774]  [<ffffffff81303b14>] ? acpi_bus_type_and_status+0x90/0x90
[    2.925054]  [<ffffffff81303b14>] ? acpi_bus_type_and_status+0x90/0x90
[    2.932334]  [<ffffffff8131de1c>] acpi_walk_namespace+0x95/0xc5
[    2.938937]  [<ffffffff81304866>] acpi_bus_scan+0x8b/0x9d
[    2.944962]  [<ffffffff81a14a15>] acpi_scan_init+0x63/0x160
[    2.951176]  [<ffffffff81a14830>] acpi_init+0x25d/0x2a6
[    2.957004]  [<ffffffff81a145d3>] ? acpi_sleep_proc_init+0x2a/0x2a
[    2.963901]  [<ffffffff810020e2>] do_one_initcall+0xe2/0x190
[    2.970217]  [<ffffffff819d70c4>] kernel_init_freeable+0x17c/0x207
[    2.977111]  [<ffffffff819d68d0>] ? do_early_param+0x88/0x88
[    2.983424]  [<ffffffff81599750>] ? rest_init+0x80/0x80
[    2.989252]  [<ffffffff8159975e>] kernel_init+0xe/0x180
[    2.995082]  [<ffffffff815c626c>] ret_from_fork+0x7c/0xb0
[    3.001103]  [<ffffffff81599750>] ? rest_init+0x80/0x80
[    3.006930] Mem-Info:
[    3.009462] Node 0 DMA per-cpu:
[    3.012974] CPU    0: hi:    0, btch:   1 usd:   0
[    3.018313] Node 0 DMA32 per-cpu:
[    3.022021] CPU    0: hi:   42, btch:   7 usd:   0
[    3.027364] active_anon:0 inactive_anon:0 isolated_anon:0
[    3.027364]  active_file:0 inactive_file:0 isolated_file:0
[    3.027364]  unevictable:0 dirty:0 writeback:0 unstable:0
[    3.027364]  free:1811 slab_reclaimable:13 slab_unreclaimable:2033
[    3.027364]  mapped:0 shmem:0 pagetables:0 bounce:0
[    3.027364]  free_cma:0
[    3.060519] Node 0 DMA free:528kB min:0kB low:0kB high:0kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(fi
le):0kB present:616kB managed:528kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstabl
e:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[    3.103088] lowmem_reserve[]: 0 0 0 0
[    3.107221] Node 0 DMA32 free:6716kB min:0kB low:0kB high:0kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated
(file):0kB present:138624kB managed:106280kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:52kB slab_unreclaimable:8132kB kernel_stack:160kB pagetab
les:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[    3.151235] lowmem_reserve[]: 0 0 0 0
[    3.155368] Node 0 DMA: 0*4kB 0*8kB 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 528kB
[    3.168736] Node 0 DMA32: 5*4kB (M) 5*8kB (UM) 4*16kB (M) 4*32kB (M) 3*64kB (M) 3*128kB (UM) 5*256kB (UM) 5*512kB (UM) 2*1024kB (M) 0*2048kB 0*4096kB = 6716kB
[    3.184765] 0 total pagecache pages
[    3.188654] 0 pages in swap cache
[    3.192348] Swap cache stats: add 0, delete 0, find 0/0
[    3.198173] Free swap  = 0kB
[    3.201383] Total swap = 0kB
[    3.262727] 1507327 pages RAM
[    3.266041] 1474315 pages reserved
[    3.269831] 0 pages shared
[    3.272846] 3330 pages non-shared
[    3.288156] swapper/0: page allocation failure: order:9, mode:0x84d0
[    3.295246] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-59.el7.x86_64 #1
[    3.303204] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS QSSC-S4R.QCI.01.00.S001.032520101647 03/25/2010
[    3.313585]  0000000000000000 ffff8800339878c8 ffffffff815b64ad ffff880033987950
[    3.321880]  ffffffff8113a980 ffff88003673ab28 00000000000001fe 0000000000000001
[    3.330167]  ffff880000000040 ffffffff810bc28a 0000000000000000 0000000000000200
[    3.338457] Call Trace:
[    3.341195]  [<ffffffff815b64ad>] dump_stack+0x19/0x1b
[    3.346924]  [<ffffffff8113a980>] warn_alloc_failed+0xf0/0x160
[    3.353437]  [<ffffffff810bc28a>] ? on_each_cpu_mask+0x2a/0x60
[    3.359943]  [<ffffffff8113e92f>] __alloc_pages_nodemask+0x7ff/0xa00
[    3.367035]  [<ffffffff815ada2c>] vmemmap_alloc_block+0x62/0xba
[    3.373639]  [<ffffffff815ada99>] vmemmap_alloc_block_buf+0x15/0x3b
[    3.380630]  [<ffffffff815ab8a6>] vmemmap_populate+0xb4/0x21b
[    3.387040]  [<ffffffff815adecd>] sparse_mem_map_populate+0x27/0x35
[    3.394032]  [<ffffffff815ad8bf>] sparse_add_one_section+0x7a/0x185
[    3.401027]  [<ffffffff8159b74f>] __add_pages+0xaf/0x240
[    3.406956]  [<ffffffff81047359>] arch_add_memory+0x59/0xd0
[    3.413172]  [<ffffffff8159ba89>] add_memory+0xb9/0x1b0
[    3.419004]  [<ffffffff8132dd2c>] acpi_memory_device_add+0x18d/0x26d
[    3.426094]  [<ffffffff81303b91>] acpi_bus_device_attach+0x7d/0xcd
[    3.432992]  [<ffffffff8131d92d>] acpi_ns_walk_namespace+0xc8/0x17f
[    3.439982]  [<ffffffff81303b14>] ? acpi_bus_type_and_status+0x90/0x90
[    3.447262]  [<ffffffff81303b14>] ? acpi_bus_type_and_status+0x90/0x90
[    3.454543]  [<ffffffff8131de1c>] acpi_walk_namespace+0x95/0xc5
[    3.461145]  [<ffffffff81304866>] acpi_bus_scan+0x8b/0x9d
[    3.467170]  [<ffffffff81a14a15>] acpi_scan_init+0x63/0x160
[    3.473386]  [<ffffffff81a14830>] acpi_init+0x25d/0x2a6
[    3.479215]  [<ffffffff81a145d3>] ? acpi_sleep_proc_init+0x2a/0x2a
[    3.486112]  [<ffffffff810020e2>] do_one_initcall+0xe2/0x190
[    3.492428]  [<ffffffff819d70c4>] kernel_init_freeable+0x17c/0x207
[    3.499321]  [<ffffffff819d68d0>] ? do_early_param+0x88/0x88
[    3.505634]  [<ffffffff81599750>] ? rest_init+0x80/0x80
[    3.511461]  [<ffffffff8159975e>] kernel_init+0xe/0x180
[    3.517293]  [<ffffffff815c626c>] ret_from_fork+0x7c/0xb0
[    3.523314]  [<ffffffff81599750>] ? rest_init+0x80/0x80
[    3.529141] Mem-Info:
[    3.531673] Node 0 DMA per-cpu:
[    3.535186] CPU    0: hi:    0, btch:   1 usd:   0
[    3.540528] Node 0 DMA32 per-cpu:
[    3.544233] CPU    0: hi:   42, btch:   7 usd:   0
[    3.549579] active_anon:0 inactive_anon:0 isolated_anon:0
[    3.549579]  active_file:0 inactive_file:0 isolated_file:0
[    3.549579]  unevictable:0 dirty:0 writeback:0 unstable:0
[    3.549579]  free:1297 slab_reclaimable:13 slab_unreclaimable:2034
[    3.549579]  mapped:0 shmem:0 pagetables:0 bounce:0
[    3.549579]  free_cma:0
[    3.582736] Node 0 DMA free:528kB min:0kB low:0kB high:0kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(fi
le):0kB present:616kB managed:528kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstabl
e:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[    3.625305] lowmem_reserve[]: 0 0 0 0
[    3.629436] Node 0 DMA32 free:4660kB min:0kB low:0kB high:0kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated
(file):0kB present:138624kB managed:106280kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:52kB slab_unreclaimable:8136kB kernel_stack:160kB pagetab
les:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[    3.673455] lowmem_reserve[]: 0 0 0 0
[    3.677588] Node 0 DMA: 0*4kB 0*8kB 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 528kB
[    3.690954] Node 0 DMA32: 3*4kB (M) 5*8kB (UM) 4*16kB (UM) 4*32kB (UM) 3*64kB (UM) 1*128kB (M) 4*256kB (UM) 4*512kB (UM) 1*1024kB (M) 0*2048kB 0*4096kB = 4660kB
[    3.707181] 0 total pagecache pages
[    3.711070] 0 pages in swap cache
[    3.714765] Swap cache stats: add 0, delete 0, find 0/0
[    3.720592] Free swap  = 0kB
[    3.723802] Total swap = 0kB
[    3.786851] 1540095 pages RAM
[    3.790163] 1507083 pages reserved
[    3.793954] 0 pages shared
[    3.796970] 3844 pages non-shared
[    3.811616] swapper/0: page allocation failure: order:9, mode:0x84d0
[    3.818707] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-59.el7.x86_64 #1
[    3.826658] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS QSSC-S4R.QCI.01.00.S001.032520101647 03/25/2010
[    3.837039]  0000000000000000 ffff8800339878c8 ffffffff815b64ad ffff880033987950
[    3.845331]  ffffffff8113a980 ffff88003673ab00 0000000000000009 00000000000084d0
[    3.853620]  ffff880033987950 ffffffff815b209e 0000000000000000 0000000000000200
[    3.861917] Call Trace:
[    3.864657]  [<ffffffff815b64ad>] dump_stack+0x19/0x1b                                                                                                              [82/1928]
[    3.870395]  [<ffffffff8113a980>] warn_alloc_failed+0xf0/0x160
[    3.876902]  [<ffffffff815b209e>] ? __alloc_pages_direct_compact+0xac/0x196
[    3.884670]  [<ffffffff8113e92f>] __alloc_pages_nodemask+0x7ff/0xa00
[    3.891752]  [<ffffffff815ada2c>] vmemmap_alloc_block+0x62/0xba
[    3.898353]  [<ffffffff815ada99>] vmemmap_alloc_block_buf+0x15/0x3b
[    3.905344]  [<ffffffff815ab8a6>] vmemmap_populate+0xb4/0x21b
[    3.911754]  [<ffffffff815adecd>] sparse_mem_map_populate+0x27/0x35
[    3.918744]  [<ffffffff815ad8bf>] sparse_add_one_section+0x7a/0x185
[    3.925739]  [<ffffffff8159b74f>] __add_pages+0xaf/0x240
[    3.931670]  [<ffffffff81047359>] arch_add_memory+0x59/0xd0
[    3.937885]  [<ffffffff8159ba89>] add_memory+0xb9/0x1b0
[    3.943717]  [<ffffffff8132dd2c>] acpi_memory_device_add+0x18d/0x26d
[    3.950805]  [<ffffffff81303b91>] acpi_bus_device_attach+0x7d/0xcd
[    3.957703]  [<ffffffff8131d92d>] acpi_ns_walk_namespace+0xc8/0x17f
[    3.964694]  [<ffffffff81303b14>] ? acpi_bus_type_and_status+0x90/0x90
[    3.971974]  [<ffffffff81303b14>] ? acpi_bus_type_and_status+0x90/0x90
[    3.979254]  [<ffffffff8131de1c>] acpi_walk_namespace+0x95/0xc5
[    3.985858]  [<ffffffff81304866>] acpi_bus_scan+0x8b/0x9d
[    3.991885]  [<ffffffff81a14a15>] acpi_scan_init+0x63/0x160
[    3.998098]  [<ffffffff81a14830>] acpi_init+0x25d/0x2a6
[    4.003927]  [<ffffffff81a145d3>] ? acpi_sleep_proc_init+0x2a/0x2a
[    4.010824]  [<ffffffff810020e2>] do_one_initcall+0xe2/0x190
[    4.017141]  [<ffffffff819d70c4>] kernel_init_freeable+0x17c/0x207
[    4.024034]  [<ffffffff819d68d0>] ? do_early_param+0x88/0x88
[    4.030347]  [<ffffffff81599750>] ? rest_init+0x80/0x80
[    4.036173]  [<ffffffff8159975e>] kernel_init+0xe/0x180
[    4.042003]  [<ffffffff815c626c>] ret_from_fork+0x7c/0xb0
[    4.048015]  [<ffffffff81599750>] ? rest_init+0x80/0x80
[    4.053840] Mem-Info:
[    4.056371] Node 0 DMA per-cpu:
[    4.059884] CPU    0: hi:    0, btch:   1 usd:   0
[    4.065224] Node 0 DMA32 per-cpu:
[    4.068927] CPU    0: hi:   42, btch:   7 usd:   0
[    4.074270] active_anon:0 inactive_anon:0 isolated_anon:0
[    4.074270]  active_file:0 inactive_file:0 isolated_file:0
[    4.074270]  unevictable:0 dirty:0 writeback:0 unstable:0
[    4.074270]  free:784 slab_reclaimable:13 slab_unreclaimable:2034
[    4.074270]  mapped:0 shmem:0 pagetables:0 bounce:0
[    4.074270]  free_cma:0
[    4.107330] Node 0 DMA free:528kB min:0kB low:0kB high:0kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(fi
le):0kB present:616kB managed:528kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstabl
e:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[    4.149899] lowmem_reserve[]: 0 0 0 0
[    4.154032] Node 0 DMA32 free:2608kB min:0kB low:0kB high:0kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated
(file):0kB present:138624kB managed:106280kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:52kB slab_unreclaimable:8136kB kernel_stack:160kB pagetab
les:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[    4.198052] lowmem_reserve[]: 0 0 0 0
[    4.202185] Node 0 DMA: 0*4kB 0*8kB 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 528kB
[    4.215553] Node 0 DMA32: 2*4kB (M) 3*8kB (M) 3*16kB (UM) 3*32kB (UM) 2*64kB (UM) 0*128kB 3*256kB (UM) 3*512kB (UM) 0*1024kB 0*2048kB 0*4096kB = 2608kB
[    4.230889] 0 total pagecache pages
[    4.234778] 0 pages in swap cache
[    4.238472] Swap cache stats: add 0, delete 0, find 0/0
[    4.244297] Free swap  = 0kB
[    4.247506] Total swap = 0kB
[    4.311351] 1572863 pages RAM
[    4.314662] 1539851 pages reserved
[    4.318453] 0 pages shared
[    4.321468] 4357 pages non-shared
[    4.336111] swapper/0: page allocation failure: order:9, mode:0x84d0
[    4.343200] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-59.el7.x86_64 #1
[    4.351158] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS QSSC-S4R.QCI.01.00.S001.032520101647 03/25/2010
[    4.361539]  0000000000000000 ffff8800339878c8 ffffffff815b64ad ffff880033987950
[    4.369828]  ffffffff8113a980 ffff88003673ab00 0000000000000009 00000000000084d0
[    4.378118]  ffff880033987950 ffffffff815b209e 0000000000000000 0000000000000200
[    4.386406] Call Trace:                                                                                                                                             [17/1928]
[    4.389145]  [<ffffffff815b64ad>] dump_stack+0x19/0x1b
[    4.394882]  [<ffffffff8113a980>] warn_alloc_failed+0xf0/0x160
[    4.401389]  [<ffffffff815b209e>] ? __alloc_pages_direct_compact+0xac/0x196
[    4.409156]  [<ffffffff8113e92f>] __alloc_pages_nodemask+0x7ff/0xa00
[    4.416239]  [<ffffffff815ada2c>] vmemmap_alloc_block+0x62/0xba
[    4.422841]  [<ffffffff815ada99>] vmemmap_alloc_block_buf+0x15/0x3b
[    4.429831]  [<ffffffff815ab8a6>] vmemmap_populate+0xb4/0x21b
[    4.436239]  [<ffffffff815adecd>] sparse_mem_map_populate+0x27/0x35
[    4.443230]  [<ffffffff815ad8bf>] sparse_add_one_section+0x7a/0x185
[    4.450226]  [<ffffffff8159b74f>] __add_pages+0xaf/0x240
[    4.456155]  [<ffffffff81047359>] arch_add_memory+0x59/0xd0
[    4.462370]  [<ffffffff8159ba89>] add_memory+0xb9/0x1b0
[    4.468204]  [<ffffffff8132dd2c>] acpi_memory_device_add+0x18d/0x26d
[    4.475293]  [<ffffffff81303b91>] acpi_bus_device_attach+0x7d/0xcd
[    4.482190]  [<ffffffff8131d92d>] acpi_ns_walk_namespace+0xc8/0x17f
[    4.489181]  [<ffffffff81303b14>] ? acpi_bus_type_and_status+0x90/0x90
[    4.496461]  [<ffffffff81303b14>] ? acpi_bus_type_and_status+0x90/0x90
[    4.503742]  [<ffffffff8131de1c>] acpi_walk_namespace+0x95/0xc5
[    4.510346]  [<ffffffff81304866>] acpi_bus_scan+0x8b/0x9d
[    4.516372]  [<ffffffff81a14a15>] acpi_scan_init+0x63/0x160
[    4.522587]  [<ffffffff81a14830>] acpi_init+0x25d/0x2a6
[    4.528415]  [<ffffffff81a145d3>] ? acpi_sleep_proc_init+0x2a/0x2a
[    4.535312]  [<ffffffff810020e2>] do_one_initcall+0xe2/0x190
[    4.541629]  [<ffffffff819d70c4>] kernel_init_freeable+0x17c/0x207
[    4.548523]  [<ffffffff819d68d0>] ? do_early_param+0x88/0x88
[    4.554836]  [<ffffffff81599750>] ? rest_init+0x80/0x80
[    4.560662]  [<ffffffff8159975e>] kernel_init+0xe/0x180
[    4.566492]  [<ffffffff815c626c>] ret_from_fork+0x7c/0xb0
[    4.572505]  [<ffffffff81599750>] ? rest_init+0x80/0x80
[    4.578331] Mem-Info:
[    4.580864] Node 0 DMA per-cpu:
[    4.584377] CPU    0: hi:    0, btch:   1 usd:   0
[    4.589719] Node 0 DMA32 per-cpu:
[    4.593423] CPU    0: hi:   42, btch:   7 usd:   0
[    4.598766] active_anon:0 inactive_anon:0 isolated_anon:0
[    4.598766]  active_file:0 inactive_file:0 isolated_file:0
[    4.598766]  unevictable:0 dirty:0 writeback:0 unstable:0
[    4.598766]  free:270 slab_reclaimable:13 slab_unreclaimable:2035
[    4.598766]  mapped:0 shmem:0 pagetables:0 bounce:0
[    4.598766]  free_cma:0
[    4.631817] Node 0 DMA free:528kB min:0kB low:0kB high:0kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(fi
le):0kB present:616kB managed:528kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstabl
e:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[    4.674387] lowmem_reserve[]: 0 0 0 0
[    4.678520] Node 0 DMA32 free:552kB min:0kB low:0kB high:0kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(
file):0kB present:138624kB managed:106280kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:52kB slab_unreclaimable:8140kB kernel_stack:160kB pagetabl
es:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[    4.722436] lowmem_reserve[]: 0 0 0 0
[    4.726569] Node 0 DMA: 0*4kB 0*8kB 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 528kB
[    4.739935] Node 0 DMA32: 2*4kB (M) 2*8kB (M) 3*16kB (UM) 1*32kB (M) 1*64kB (U) 1*128kB (U) 1*256kB (M) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 552kB
[    4.754783] 0 total pagecache pages
[    4.758672] 0 pages in swap cache
[    4.762366] Swap cache stats: add 0, delete 0, find 0/0
[    4.768193] Free swap  = 0kB
[    4.771403] Total swap = 0kB
[    4.836714] 1605631 pages RAM
[    4.840027] 1572619 pages reserved
[    4.843818] 0 pages shared
[    4.846832] 4871 pages non-shared



--------------030102050109050006060709
Content-Type: text/plain; charset=UTF-8;
 name="disable-acpi-mem-hotplug-for-exactmap.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="disable-acpi-mem-hotplug-for-exactmap.patch"

---
 arch/x86/include/asm/e820.h    |    1 +
 arch/x86/kernel/e820.c         |    2 ++
 drivers/acpi/acpi_memhotplug.c |    4 ++++
 3 files changed, 7 insertions(+)

Index: linux/arch/x86/include/asm/e820.h
===================================================================
--- linux.orig/arch/x86/include/asm/e820.h
+++ linux/arch/x86/include/asm/e820.h
@@ -69,6 +69,7 @@ static inline bool is_ISA_range(u64 s, u
 {
 	return s >= ISA_START_ADDRESS && e <= ISA_END_ADDRESS;
 }
+extern bool use_exactmap;
 
 #endif /* __ASSEMBLY__ */
 #include <linux/ioport.h>
Index: linux/arch/x86/kernel/e820.c
===================================================================
--- linux.orig/arch/x86/kernel/e820.c
+++ linux/arch/x86/kernel/e820.c
@@ -838,6 +838,7 @@ static int __init parse_memopt(char *p)
 }
 early_param("mem", parse_memopt);
 
+bool use_exactmap;
 static int __init parse_memmap_one(char *p)
 {
 	char *oldp;
@@ -857,6 +858,7 @@ static int __init parse_memmap_one(char
 #endif
 		e820.nr_map = 0;
 		userdef = 1;
+		use_exactmap = true;
 		return 0;
 	}
 
Index: linux/drivers/acpi/acpi_memhotplug.c
===================================================================
--- linux.orig/drivers/acpi/acpi_memhotplug.c
+++ linux/drivers/acpi/acpi_memhotplug.c
@@ -363,5 +363,9 @@ static void acpi_memory_device_remove(st
 
 void __init acpi_memory_hotplug_init(void)
 {
+#ifdef CONFIG_X86
+	if (use_exactmap)
+		return;
+#endif
 	acpi_scan_add_handler_with_hotplug(&memory_device_handler, "memory");
 }

--------------030102050109050006060709--
