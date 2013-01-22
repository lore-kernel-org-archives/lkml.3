Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab3AVPVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 10:21:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56123 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab3AVPVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 10:21:14 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86 e820: only void usable memory areas in memmap=exactmap case
Date: Tue, 22 Jan 2013 16:21:01 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-24-desktop; KDE/4.6.0; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, ddutile@redhat.com,
        vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com,
        tglx@linutronix.de, khalid@gonehiking.org, horms@verge.net.au
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local> <1824463.EWDqkMLC4N@hammer82.arch.suse.de> <CAE9FiQUgqRLO4O4HFBC_D5o8TQhnouEaDNq82wdwuu57=OsoZQ@mail.gmail.com>
In-Reply-To: <CAE9FiQUgqRLO4O4HFBC_D5o8TQhnouEaDNq82wdwuu57=OsoZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201301221621.02175.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 15, 2013 05:45:43 AM Yinghai Lu wrote:
> On Mon, Jan 14, 2013 at 4:54 PM, Thomas Renninger <trenn@suse.de> wrote:
...
> > From what I can see the patch looks fine, but above part should
> > simply be left out.
> 
> then, I would like to rename it to resetusablemap instead.
> 
> like attached.

I tried this one out on linux-x86-tip tree on the mm2 branch
This one already had your patch:
x86, mm: Let "memmap=" take more entries one time
and I additionally added:
x86 e820: Check for exactmap appearance when parsing first memmap option
and the one you posted one mail earlier:
x86 e820: Introduce memmap=resetusablemap for kdump usage

I just re-posted your 2 patches also adding some kernel-parameter
documention, subject:
[PATCH 0/2] Only parse exactmap once, introduce memmap=resetusablemap

I adjusted kexec tools to identify the kernel version from the kernel
it loads.
I posted these patches separately, subject (google should find it
pretty soon):
[PATCH 0/3] Make use of new memmap= kernel parameter syntax

for those who are interested in these to:
  - make use of comma separated memmap= option
    Let "memmap=" take more entries one time
  - Do not pass unusable (ACPI or whatever reserved mem) via memmap=x#y
  - Do use memmap=resetusablemap instead of memmap=exactmap
in case the kernel to load is of version 3.9 or newer.
Otherwise there is no change.

Unfortunately I cannot see a proper way to backport this.
The only way may be to:
  - In the backported kernel inverse the condition to prefer resetusablemap
    over exactmap
  - In kexec pass both to older kernels: memmap=exactmap memmap=resetusablemap
    and all the ACPI reservation memmap= params


I tried this on a somewhat quicker booting machine with quite some more
memmap= params passed by kexec. I reset the machine hard when it started
kdump:
Copying data                       : [ 20 %]
as I expect that if it comes that far, things work. In both cases the
kernel was dumped:

kexec using new resetusablemap syntax (with kexec debug enabled):
===================================
./build/sbin/kexec -d -p /boot/vmlinuz-3.7.0-rc6-default+ --append="root=/dev/disk/by-id/ata-Hitachi_HDS721016CLA382_JPAB40HM2KUK6B-part6 console=tty0 
console=ttyS0,57600 sysrq_always_enabled panic=100 ignore_loglevel resume=/dev/disk/by-id/ata-Hitachi_HDS721016CLA382_JPAB40HM2KUK6B-part2 apic=verbose debug 
vga=normal elevator=deadline sysrq=yes reset_devices irqpoll maxcpus=1  " --initrd=/boot/initrd-3.7.0-rc6-default+-kdump...

Kernel release: 3.7.0-rc6-d in long format: 0x30700
...
root=/dev/disk/by-id/ata-Hitachi_HDS721016CLA382_JPAB40HM2KUK6B-part6 console=tty0 console=ttyS0,57600 sysrq_always_enabled panic=100 ignore_loglevel 
resume=/dev/disk/by-id/ata-Hitachi_HDS721016CLA382_JPAB40HM2KUK6B-part2 apic=verbose debug vga=normal elevator=deadline sysrq=yes reset_devices irqpoll maxcpus=1   
memmap=resetusablemap,559K@64K,261560K@638976K elfcorehdr=900536K
...
===================================

important parts of crash kernel log with new syntax:
===================================
[48023.711213] RIP  [<ffffffff812f368d>] sysrq_handle_crash+0xd/0x20
[48023.724765]  RSP <ffff88042411fe90>
[48023.732539] CR2: 0000000000000000
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.0-rc6-default+ (trenn@ett) (gcc version 4.5.1 20101208 [gcc-4_5-branch revision 167585] (SUSE Linux) ) #2 SMP Tue Jan 22 01:43:26 
CET 2013
[    0.000000] Command line: root=/dev/disk/by-id/ata-Hitachi_HDS721016CLA382_JPAB40HM2KUK6B-part6 console=tty0 console=ttyS0,57600 sysrq_always_enabled panic=100 
ignore_loglevel resume=/dev/disk/by-id/ata-Hitachi_HDS721016CLA382_JPAB40HM2KUK6B-part2 apic=verbose debug vga=normal elevator=deadline sysrq=yes reset_devices 
irqpoll maxcpus=1   memmap=resetusablemap,559K@64K,261560K@638976K elfcorehdr=900536K
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009bbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009bc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000b93dafff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b93db000-0x00000000b9454fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000b9455000-0x00000000bb155fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bb156000-0x00000000bb166fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bb167000-0x00000000bb3d7fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bb3d8000-0x00000000bb6d8fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bb6d9000-0x00000000bd9fcfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bd9fd000-0x00000000bdbfcfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bdbfd000-0x00000000bdcdcfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bdcdd000-0x00000000bdde6fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bdde7000-0x00000000bde8ffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bde90000-0x00000000bde90fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bde91000-0x00000000bdf07fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bdf08000-0x00000000bdf08fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bdf09000-0x00000000bdf0afff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bdf0b000-0x00000000bdf0bfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bdf0c000-0x00000000bdf0cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bdf0d000-0x00000000bdf23fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bdf24000-0x00000000bdfb0fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bdfb1000-0x00000000bdffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000be000000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed19000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffa20000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000083fffffff] usable
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] e820: last_pfn = 0x840000 max_arch_pfn = 0x400000000
[    0.000000] e820: remove [mem 0x00000000-0xfffffffffffffffe] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: user-defined physical RAM map:
[    0.000000] user: [mem 0x0000000000010000-0x000000000009bbff] usable
[    0.000000] user: [mem 0x000000000009bc00-0x000000000009ffff] reserved
[    0.000000] user: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] user: [mem 0x0000000027000000-0x0000000036f6dfff] usable
[    0.000000] user: [mem 0x00000000b93db000-0x00000000b9454fff] ACPI data
[    0.000000] user: [mem 0x00000000bb156000-0x00000000bb166fff] reserved
[    0.000000] user: [mem 0x00000000bb3d8000-0x00000000bb6d8fff] ACPI NVS
[    0.000000] user: [mem 0x00000000bd9fd000-0x00000000bdbfcfff] ACPI NVS
[    0.000000] user: [mem 0x00000000bdcdd000-0x00000000bdde6fff] reserved
[    0.000000] user: [mem 0x00000000bdde7000-0x00000000bde8ffff] ACPI NVS
[    0.000000] user: [mem 0x00000000bde90000-0x00000000bde90fff] ACPI data
[    0.000000] user: [mem 0x00000000bde91000-0x00000000bdf07fff] ACPI NVS
[    0.000000] user: [mem 0x00000000bdf08000-0x00000000bdf08fff] ACPI data
[    0.000000] user: [mem 0x00000000bdf09000-0x00000000bdf0afff] ACPI NVS
[    0.000000] user: [mem 0x00000000bdf0b000-0x00000000bdf0bfff] ACPI data
[    0.000000] user: [mem 0x00000000bdf0c000-0x00000000bdf0cfff] ACPI NVS
[    0.000000] user: [mem 0x00000000bdf0d000-0x00000000bdf23fff] ACPI data
[    0.000000] user: [mem 0x00000000bdf24000-0x00000000bdfb0fff] ACPI NVS
[    0.000000] user: [mem 0x00000000be000000-0x00000000cfffffff] reserved
[    0.000000] user: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] user: [mem 0x00000000fed19000-0x00000000fed19fff] reserved
[    0.000000] user: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] user: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] user: [mem 0x00000000ffa20000-0x00000000ffffffff] reserved
[    0.000000] DMI 2.6 present.
...
[    2.370015] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
[    2.390823] PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E820

===================================
===================================

kexec using old exactmap syntax (with kexec debug enabled):
===================================
./build/sbin/kexec -d -p /boot/vmlinuz-3.7.0-rc6-default+ --append="root=/dev/disk/by-id/ata-Hitachi_HDS721016CLA382_JPAB40HM2KUK6B-part6 console=tty0 
console=ttyS0,57600 sysrq_always_enabled panic=100 ignore_loglevel resume=/dev/disk/by-id/ata-Hitachi_HDS721016CLA382_JPAB40HM2KUK6B-part2 apic=verbose debug 
vga=normal elevator=deadline sysrq=yes reset_devices irqpoll maxcpus=1  " --initrd=/boot/initrd-3.7.0-rc6-default+-kdump

...
root=/dev/disk/by-id/ata-Hitachi_HDS721016CLA382_JPAB40HM2KUK6B-part6 console=tty0 console=ttyS0,57600 sysrq_always_enabled panic=100 igno
re_loglevel resume=/dev/disk/by-id/ata-Hitachi_HDS721016CLA382_JPAB40HM2KUK6B-part2 apic=verbose debug vga=normal elevator=deadline sysrq=
yes reset_devices irqpoll maxcpus=1   memmap=exactmap memmap=559K@64K memmap=261560K@638976K elfcorehdr=900536K memmap=488K#3034988K memma
p=3076K#3067744K memmap=2048K#3106804K memmap=676K#3110812K memmap=4K#3111488K memmap=476K#3111492K memmap=4K#3111968K memmap=8K#3111972K 
memmap=4K#3111980K memmap=4K#3111984K memmap=92K#3111988K memmap=564K#3112080K
===================================

important parts of crash kernel log with old syntax
(compare unnecessary memmap=x#y additions and the
resulting broken e820 user defined map):
===================================
[  856.564790] RIP  [<ffffffff812f368d>] sysrq_handle_crash+0xd/0x20
[  856.578345]  RSP <ffff880424197e90>
[  856.586124] CR2: 0000000000000000
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.0-rc6-default+ (trenn@ett) (gcc version 4.5.1 20101208 [gcc-4_5-branch revision 167585] (SUSE Linux) ) #2 SMP Tue Jan 22 01:43:26 
CET 2013
[    0.000000] Command line: root=/dev/disk/by-id/ata-Hitachi_HDS721016CLA382_JPAB40HM2KUK6B-part6 console=tty0 console=ttyS0,57600 sysrq_always_enabled panic=100 
ignore_loglevel resume=/dev/disk/by-id/ata-Hitachi_HDS721016CLA382_JPAB40HM2KUK6B-part2 apic=verbose debug vga=normal elevator=deadline sysrq=yes reset_devices 
irqpoll maxcpus=1   memmap=exactmap memmap=559K@64K memmap=261560K@638976K elfcorehdr=900536K memmap=488K#3034988K memmap=3076K#3067744K memmap=2048K#3106804K 
memmap=676K#3110812K memmap=4K#3111488K memmap=476K#3111492K memmap=4K#3111968K memmap=8K#3111972K memmap=4K#3111980K memmap=4K#3111984K memmap=92K#3111988K 
memmap=564K#3112080K
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009bbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009bc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000b93dafff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b93db000-0x00000000b9454fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000b9455000-0x00000000bb155fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bb156000-0x00000000bb166fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bb167000-0x00000000bb3d7fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bb3d8000-0x00000000bb6d8fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bb6d9000-0x00000000bd9fcfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bd9fd000-0x00000000bdbfcfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bdbfd000-0x00000000bdcdcfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bdcdd000-0x00000000bdde6fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bdde7000-0x00000000bde8ffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bde90000-0x00000000bde90fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bde91000-0x00000000bdf07fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bdf08000-0x00000000bdf08fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bdf09000-0x00000000bdf0afff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bdf0b000-0x00000000bdf0bfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bdf0c000-0x00000000bdf0cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bdf0d000-0x00000000bdf23fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bdf24000-0x00000000bdfb0fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bdfb1000-0x00000000bdffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000be000000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed19000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffa20000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000083fffffff] usable
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] e820: last_pfn = 0x840000 max_arch_pfn = 0x400000000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: user-defined physical RAM map:
[    0.000000] user: [mem 0x0000000000010000-0x000000000009bbff] usable
[    0.000000] user: [mem 0x0000000027000000-0x0000000036f6dfff] usable
[    0.000000] user: [mem 0x00000000b93db000-0x00000000b9454fff] ACPI data
[    0.000000] user: [mem 0x00000000bb3d8000-0x00000000bb6d8fff] ACPI data
[    0.000000] user: [mem 0x00000000bd9fd000-0x00000000bdbfcfff] ACPI data
[    0.000000] user: [mem 0x00000000bdde7000-0x00000000bdfb0fff] ACPI data
[    0.000000] DMI 2.6 present.
...
[    2.264005] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
[    2.284811] PCI: not using MMCONFIG
===================================

     Thomas
