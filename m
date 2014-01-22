Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbaAVJwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 04:52:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbaAVJwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 04:52:10 -0500
Date: Wed, 22 Jan 2014 17:52:19 +0800
From: Dave Young <dyoung@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org
Subject: [BUG] sched_clock: wrong printk time stamp
Message-ID: <20140122095219.GA6114@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With today's Linus tree, the printk time is very odd, see below
qemu/efi boot log:
[    0.000000] ACPI: FACS 000000001f9e4000 000040
[    0.000000] ACPI: APIC 000000001f9dd000 000078 (v01 OVMF   OVMFEDK2 20130221 OVMF 00000099)
[    0.000000] ACPI: SSDT 000000001f9db000 000057 (v01 REDHAT OVMF     00000001 INTL 20120913)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Reserving 128MB of memory at 320MB for crashkernel (System RAM: 510MB)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1f801001, boot clock
[ 1592.120520]  [ffffea0000000000-ffffea00007fffff] PMD -> [ffff880013800000-ffff880013ffffff] on node 0
[ 1592.120526] Zone ranges:
[ 1592.121922]   DMA      [mem 0x00001000-0x00ffffff]
[ 1592.124493]   DMA32    [mem 0x01000000-0xffffffff]
[ 1592.127056]   Normal   empty
[ 1592.128581] Movable zone start for each node

The previous normal log:
[    0.000000] ACPI: FACS 000000000d5e4000 000040
[    0.000000] ACPI: APIC 000000000d5dd000 000078 (v01 OVMF   OVMFEDK2 20130221 OVMF 00000099)
[    0.000000] ACPI: SSDT 000000000d5db000 000057 (v01 REDHAT OVMF     00000001 INTL 20120913)
[    0.000000] crashkernel reservation failed - No suitable area found.
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:d401001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[snip]
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] tsc: Detected 2793.268 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 5588.30 BogoMIPS (lpj=9310893)
[    0.010010] pid_max: default: 32768 minimum: 301
[    0.013381] init_memory_mapping: [mem 0x0bd94000-0x0bd95fff]
[    0.016707] init_memory_mapping: [mem 0x0bd96000-0x0bdabfff]
[    0.020019] init_memory_mapping: [mem 0x0bdac000-0x0bdc0fff]
[    0.023206] init_memory_mapping: [mem 0x0d581000-0x0d5b0fff]


I bisected the problem, it results from below commit, probably
local_irq should be still disabled?

-bash-4.2$ git bisect bad
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[ef08f0fff87630d4f67ceb09514d8b444df833f8] sched/clock: Remove local_irq_disable() from the clocks

Note: for the last several build steps I need manually revert
9ea4c380066fbe23fe0da7f4abfabc444f2467f4 or build will fail.

Thanks
Dave
