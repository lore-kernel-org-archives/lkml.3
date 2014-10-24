Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaJXTGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 15:06:11 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:62204 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaJXTGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 15:06:07 -0400
Message-ID: <544AA317.8070609@gmail.com>
Date: Fri, 24 Oct 2014 15:05:59 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
User-Agent: Mozilla/5.0 (X11; FreeBSD amd64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Slow dc3dd in 3.18 on x86
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!  I have an old i686 Pentium 4 that I use for xfstests.  To better keep
integrity, write cache is disabled on an old 60-"megabyte" IDE HDD.  The
PC runs slackware-current, doing a `git pull` of the kernel and
xfs-oss/for-next once or twice a week.

This week, a simple `dc3dd wipe=/dev/sda5` operation had speeds cut from
10-15 MB/s down to less than 1.8 MB/s.  With this method, syncs took so long
that magic SysRq keys were needed to stop the PC.  A bisect let me here:

root@kyhorse:/usr/src/kernel-git/linux# git bisect good
aae7df50190a640e51bfe11c93f94741ac82ff0b is the first bad commit
commit aae7df50190a640e51bfe11c93f94741ac82ff0b
Author: Martin K. Petersen <martin.petersen@oracle.com>
Date:   Fri Sep 26 19:20:05 2014 -0400

     block: Integrity checksum flag
     
     Make the choice of checksum a per-I/O property by introducing a flag
     that can be inspected by the SCSI layer. There are several reasons for
     this:
     
      1. It allows us to switch choice of checksum without unloading and
         reloading the HBA driver.
     
      2. During error recovery we need to be able to tell the HBA that
         checksums read from disk should not be verified and converted to IP
         checksums.
     
      3. For error injection purposes we need to be able to write a bad guard
         tag to storage. Since the storage device only supports T10 CRC we
         need to be able to disable IP checksum conversion on the HBA.
     
     Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
     Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
     Signed-off-by: Jens Axboe <axboe@fb.com>

:040000 040000 9a0fd5dc52f1384280e8cfea63fef7951db9a4d2 2d6ce5012ce8264b82772910060cc97001a30a80 M	block
:040000 040000 2ef62fa822934877285dd0ea6ed4bc154b3fb4e4 e9935ccb2fe0fe62bc0d925c7c4eb3291f227b42 M	drivers
:040000 040000 f4127155cd44a1ad376b1e193263a8eeb6aa267d b158970e89b03396c436dc471d83e8d4c3f96969 M	include

Uh, OK, but I don't use the integrity features at all.  When configuring the kernel,
the "Enable the block layer" section has only CONFIG_LBDAF=y selected in that first-
level menu.  The T10 items aren't configured elsewhere (Cryptographic API, etc.).

Do I need to be setting some config items to "y" to get this boat anchor to zero
partitions at its usual slow rate again?

Should you find such an issue and need a relatively safe test, you can use this
fio job file:

# start of job file:
[global]
filename=/dev/sda5
fill_device=1
bs=64k
numjobs=1
zero_buffers=1

[write]
rw=write
write_bw_log=write
write_iops_log=write
write_lat_log=write
# end of job file.

On this boat anchor, the claimed bandwidth will toggle between 447 kB/s and 512 kB/s
for an affected setup.  IOPS are between 1 and 10 for an affected setup.

Thanks!  If somehow I landed on the wrong commit, let me know, and I'll
try again.

Thanks!

Michael
