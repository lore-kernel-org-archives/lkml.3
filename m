Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965152AbaGPOUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:20:35 -0400
Received: from smtp25.services.sfr.fr ([93.17.128.119]:8546 "EHLO
	smtp25.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934376AbaGPOU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:20:27 -0400
X-Greylist: delayed 655 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jul 2014 10:20:27 EDT
Authentication-Results: sfrmc.priv.atos.fr; dkim=none (no signature);
	dkim-adsp=none (no policy) header.from=mpeg.blue@free.fr
X-SFR-UUID: 20140716140927597.91F36700007F@msfrf2511.sfr.fr
Message-ID: <53C687B1.30809@free.fr>
Date: Wed, 16 Jul 2014 16:09:53 +0200
From: Mason <mpeg.blue@free.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:29.0) Gecko/20100101
	Firefox/29.0 SeaMonkey/2.26.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: After unlinking a large file on ext4, the process stalls for a long
 time
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I'm using Linux (3.1.10 at the moment) on a embedded system similar in
spec to a desktop PC from 15 years ago (256 MB RAM, 800-MHz CPU, USB).

I need to be able to create large files (50-1000 GB) "as fast as possible".
These files are created on an external hard disk drive, connected over
Hi-Speed USB (typical throughput 30 MB/s).

Sparse files were not an acceptable solution (because the space must be
reserved, and the operation must fail if the space is unavailable).
And filling the file with zeros was too slow (typically 35 s/GB).

Someone mentioned fallocate on an ext4 partition.

So I create an ext4 partition with
$ mkfs.ext4 -m 0 -i 1024000 -O ^has_journal,^huge_file /dev/sda1
(Using e2fsprogs-1.42.10 if it matters)

And mount with "typical" mount options
$ mount -t ext4 /dev/sda1 /mnt/hdd -o noexec,noatime
/dev/sda1 on /mnt/hdd type ext4 (rw,noexec,noatime,barrier=1)

I wrote a small test program to create a large file, then immediately
unlink it.

My problem is that, while file creation is "fast enough" (4 seconds
for a 300 GB file) and unlink is "immediate", the process hangs
while it waits (I suppose) for the OS to actually complete the
operation (almost two minutes for a 300 GB file).

I also note that the (weak) CPU is pegged, so perhaps this problem
does not occur on a desktop workstation?

/tmp # time ./foo /mnt/hdd/xxx 5
posix_fallocate(fd, 0, size_in_GiB << 30): 0 [68 ms]
unlink(filename): 0 [0 ms]
0.00user 1.86system 0:01.92elapsed 97%CPU (0avgtext+0avgdata 528maxresident)k
0inputs+0outputs (0major+168minor)pagefaults 0swaps

/tmp # time ./foo /mnt/hdd/xxx 10
posix_fallocate(fd, 0, size_in_GiB << 30): 0 [141 ms]
unlink(filename): 0 [0 ms]
0.00user 3.71system 0:03.83elapsed 96%CPU (0avgtext+0avgdata 528maxresident)k
0inputs+0outputs (0major+168minor)pagefaults 0swaps

/tmp # time ./foo /mnt/hdd/xxx 100
posix_fallocate(fd, 0, size_in_GiB << 30): 0 [1882 ms]
unlink(filename): 0 [0 ms]
0.00user 37.12system 0:38.93elapsed 95%CPU (0avgtext+0avgdata 528maxresident)k
0inputs+0outputs (0major+168minor)pagefaults 0swaps

/tmp # time ./foo /mnt/hdd/xxx 300
posix_fallocate(fd, 0, size_in_GiB << 30): 0 [3883 ms]
unlink(filename): 0 [0 ms]
0.00user 111.38system 1:55.04elapsed 96%CPU (0avgtext+0avgdata 528maxresident)k
0inputs+0outputs (0major+168minor)pagefaults 0swaps


QUESTIONS:

1) Did I provide enough information for someone to reproduce?

2) Is this expected behavior?

3) Are there knobs I can tweak (at FS creation, or at mount time)
to improve the performance of file unlinking?
(Maybe there is a safety/performance trade-off?


My test program:

#define _FILE_OFFSET_BITS 64
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <time.h>

#define BENCH(op) do { \
  struct timespec t0; clock_gettime(CLOCK_MONOTONIC, &t0); \
  int err = op; \
  struct timespec t1; clock_gettime(CLOCK_MONOTONIC, &t1); \
  int ms = (t1.tv_sec-t0.tv_sec)*1000 + (t1.tv_nsec-t0.tv_nsec)/1000000; \
  printf("%s: %d [%d ms]\n", #op, err, ms); } while(0)

int main(int argc, char **argv)
{
  if (argc != 3) { puts("Usage: prog filename size"); return 42; }

  char *filename = argv[1];
  int fd = open(filename, O_CREAT | O_EXCL | O_WRONLY, 0600);
  if (fd < 0) { perror("open"); return 1; }

  long long size_in_GiB = atoi(argv[2]);
  BENCH(posix_fallocate(fd, 0, size_in_GiB << 30));
  BENCH(unlink(filename));
  return 0;
}


-- 
Regards.
