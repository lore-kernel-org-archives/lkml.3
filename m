Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab3KRWEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 17:04:08 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:58576 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3KRWEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 17:04:05 -0500
From: Elena Ufimtseva <ufimtseva@gmail.com>
To: xen-devel@lists.xenproject.org
Cc: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, akpm@linux-foundation.org,
        tangchen@cn.fujitsu.com, wency@cn.fujitsu.com, ian.campbell@citrix.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com,
        linux-kernel@vger.kernel.org, Elena Ufimtseva <ufimtseva@gmail.com>
Subject: [PATCH RESEND v2 0/2] xen: vnuma introduction for pv guest
Date: Mon, 18 Nov 2013 16:58:40 -0500
Message-Id: <1384811922-14642-1-git-send-email-ufimtseva@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen vnuma introduction.

The patchset introduces vnuma to paravirtualized Xen guests
runnning as domU.
Xen subop hypercall is used to retreive vnuma topology information.
Bases on the retreived topology from Xen, NUMA number of nodes,
memory ranges, distance table and cpumask is being set.
If initialization is incorrect, sets 'dummy' node and unsets
nodemask. vNUMA topology is constructed by Xen toolstack.

Example of vnuma enabled pv domain dmesg:

[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009ffff]
[    0.000000]   node   0: [mem 0x00100000-0xffffffff]
[    0.000000]   node   1: [mem 0x100000000-0x1ffffffff]
[    0.000000]   node   2: [mem 0x200000000-0x2ffffffff]
[    0.000000]   node   3: [mem 0x300000000-0x3ffffffff]
[    0.000000] On node 0 totalpages: 1048479
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3999 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 1044480 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 1048576
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
[    0.000000] On node 2 totalpages: 1048576
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
[    0.000000] On node 3 totalpages: 1048576
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
[    0.000000] SFI: Simple Firmware Interface v0.81 http://simplefirmware.org
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] No local APIC present
[    0.000000] APIC: disable apic facility
[    0.000000] APIC: switched to apic NOOP
[    0.000000] nr_irqs_gsi: 16
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] e820: cannot find a gap in the 32bit address range
[    0.000000] e820: PCI devices with unassigned 32bit BARs may break!
[    0.000000] e820: [mem 0x400100000-0x4004fffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on Xen
[    0.000000] Xen version: 4.4-unstable (preserve-AD)
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:4
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff8800ffc00000 s85376 r8192 d21120 u2097152
[    0.000000] pcpu-alloc: s85376 r8192 d21120 u2097152 alloc=1*2097152


numactl output:
root@heatpipe:~# numactl --hardware
available: 4 nodes (0-3)
node 0 cpus: 0
node 0 size: 4031 MB
node 0 free: 3997 MB
node 1 cpus: 1
node 1 size: 4039 MB
node 1 free: 4022 MB
node 2 cpus: 2
node 2 size: 4039 MB
node 2 free: 4023 MB
node 3 cpus: 3
node 3 size: 3975 MB
node 3 free: 3963 MB
node distances:
node   0   1   2   3
  0:  10  20  20  20
  1:  20  10  20  20
  2:  20  20  10  20
  3:  20  20  20  10

Current patchset is available at https://git.gitorious.org/xenvnuma/linuxvnuma.git:v4
				 git@gitorious.org:xenvnuma/linuxvnuma.git:v4
Xen patchset is available at: https://git.gitorious.org/xenvnuma/xenvnuma.git:v3

TODO
*       dom0, pvh and hvm vnuma support;
*       multiple memory ranges per node support;
*       benchmarking;

Elena Ufimtseva (2):
  xen: vnuma support for PV guests running as domU
  Subject: [PATCH RESEND v2 2/2] xen: enable vnuma for PV guest

 arch/x86/include/asm/xen/vnuma.h |   12 ++++
 arch/x86/mm/numa.c               |    3 +
 arch/x86/xen/Makefile            |    2 +-
 arch/x86/xen/setup.c             |    6 +-
 arch/x86/xen/vnuma.c             |  127 ++++++++++++++++++++++++++++++++++++++
 include/xen/interface/memory.h   |   43 +++++++++++++
 6 files changed, 191 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/vnuma.h
 create mode 100644 arch/x86/xen/vnuma.c

-- 
1.7.10.4

