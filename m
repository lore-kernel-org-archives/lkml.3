Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab3JIX0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 19:26:54 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:45802 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983Ab3JIX0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 19:26:52 -0400
X-Originating-IP: 173.246.103.110
Date: Wed, 9 Oct 2013 16:26:44 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Jens Axboe <axboe@kernel.dk>,
        Karel Zak <kzak@redhat.com>, Matt Fleming <matt.fleming@intel.com>
Subject: Regression parsing GPT (EFI) partition tables
Message-ID: <20131009232642.GA12776@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When testing ChromeOS with a 3.12 kernel from git, I encountered a
regression introduced between 3.11 to 3.12: at boot time, the kernel
failed to find any partitions on the USB disk I booted from, which uses
a GPT partition table with 12 partitions.  This prevented the system
from booting.

Reverting all the patches to block/partitions/efi.c between 3.11 and
3.12 allowed the system to detect partitions again.  The patches I
reverted:

6b02fa5 partitions/efi: loosen check fot pmbr size in lba
b4bc4a1 block/partitions/efi.c: consistently use pr_foo()
70f637e partitions/efi: some style cleanups
aa054bc partitions/efi: compare first and last usable LBAs
27a7c64 partitions/efi: account for pmbr size in lba
b05ebbb partitions/efi: detect hybrid MBRs
3e69ac3 partitions/efi: do not require gpt partition to begin at sector 1
33afd7a partitions/efi: check pmbr record's starting lba
c2ebdc2 partitions/efi: use lba-aware partition records

I haven't yet attempted to find out if reverting a subset of those patches
fixes the problem, though I'd strongly suspect the commits that introduce
strictness checks for the partition layout and fail when those checks don't
pass.  Most likely ChromeOS's partition layout tripped one of those checks.

Here's the partition layout:

$ gdisk -l /dev/sdc
GPT fdisk (gdisk) version 0.8.7

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sdc: 31293440 sectors, 14.9 GiB
Logical sector size: 512 bytes
Disk identifier (GUID): 44F4ACFD-546C-E04C-A788-6782FCBDDB3E
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 4956062
Partitions will be aligned on 1-sector boundaries
Total free space is 167801 sectors (81.9 MiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1         2826240         4923391   1024.0 MiB  0700  STATE
   2           20480           53247   16.0 MiB    7F00  KERN-A
   3          286720         2826239   1.2 GiB     7F01  ROOT-A
   4           53248           86015   16.0 MiB    7F00  KERN-B
   5          282624          286719   2.0 MiB     7F01  ROOT-B
   6           16448           16448   512 bytes   7F00  KERN-C
   7           16449           16449   512 bytes   7F01  ROOT-C
   8           86016          118783   16.0 MiB    0700  OEM
   9           16450           16450   512 bytes   7F02  reserved
  10           16451           16451   512 bytes   7F02  reserved
  11              64           16447   8.0 MiB     FFFF  RWFW
  12          249856          282623   16.0 MiB    EF00  EFI-SYSTEM


Also note that ChromeOS USB disks typically only have one valid GPT, at the
beginning of the disk, since they're imaged from a file and nothing moves the
secondary GPT from the end of the image to the end of the disk.  Partitioning
tools, and the kernel, typically gripe about this; for instance, dmesg from a
3.10 kernel when I plug in a ChromeOS USB disk:

GPT:Primary header thinks Alt. header is not at the end of the disk.
GPT:4956095 != 31293439
GPT:Alternate GPT header not at the end of the disk.
GPT:4956095 != 31293439

I can easily supply additional information about ChromeOS images and their
partition tables.

- Josh Triplett
