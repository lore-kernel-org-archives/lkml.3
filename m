Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167AbaAEM5t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 07:57:49 -0500
Received: from mail-out1.informatik.tu-muenchen.de ([131.159.0.8]:53758 "EHLO
	smtp1.informatik.tu-muenchen.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751050AbaAEM5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 07:57:48 -0500
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Jan 2014 07:57:48 EST
MIME-Version: 1.0
Date: Sun, 5 Jan 2014 13:48:23 +0100
Message-ID: <CAGz0_-2WsqMQLqyoPJ4ncoMJ7-XhYYt_cns7Mzq0CET0=1R4SQ@mail.gmail.com>
Subject: Linux 3.12 spreads memory allocation across all NUMA nodes instead of
 local allocation?
From: Andreas Hollmann <hollmann@in.tum.de>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

it seems that my system (4-socket system) is
interleaving pages across all numa nodes.

The default should be local allocation on the current
node? (If I'm not wrong.)

I tried this out using the stream benchmark and pinned
a single thread to a single cpu with taskset. The memory
should be allocated on the numa node local to the CPU.
Instead the memory allocation is spread across all
numa nodes.

numa_balancing is disabled. It is however not possible
to detect it directly in user space. There is no sys entry.

Can I configure the default memory policy or is there
something wrong in the Kernel? I've never seen this
behavior as  default before and I'm aware that you
enforce this allocation policy by using numactl --interleave=.

The system I'm using is a 4-Socket WestmereEX
system with 10 cores per socket in total 80 logical
CPUs and 256 GB memory.

Configuration:

$ cat /proc/cmdline
BOOT_IMAGE=/boot/vmlinuz-linux
root=UUID=294db3db-d278-4b20-9199-f5ac6926efaf rw console=tty0
console=ttyS0,115200 numa_balancing=disable nomodeset quiet

$ uname -a
Linux inwest 3.12.6-1-ARCH #1 SMP PREEMPT Fri Dec 20 19:39:00 CET 2013
x86_64 GNU/Linux

Here is how i produced the output:

wget www.cs.virginia.edu/stream/FTP/Code/stream.c
gcc -mcmodel=medium -O -DSTREAM_ARRAY_SIZE=100000000 stream.c -o stream.100M

taskset -c 0 ./stream.100M 1> /dev/null & watch -n 1 numastat -cp $!

Per-node process memory usage (in MBs) for PID 2055 (stream.100M)
         Node 0 Node 1 Node 2 Node 3 Total
         ------ ------ ------ ------ -----
Huge          0      0      0      0     0
Heap        576    576    569    568  2289
Stack         0      0      0      0     0
Private       0      0      0      0     0
-------  ------ ------ ------ ------ -----
Total       576    576    569    568  2289

numactl -l taskset -c 0 ./stream.100M 1> /dev/null & watch -n 1 numastat -cp $!

Per-node process memory usage (in MBs) for PID 2333 (stream.100M)
         Node 0 Node 1 Node 2 Node 3 Total
         ------ ------ ------ ------ -----
Huge          0      0      0      0     0
Heap        576    573    568    572  2289
Stack         0      0      0      0     0
Private       0      0      0      0     0
-------  ------ ------ ------ ------ -----
Total       576    573    568    572  2289

numactl -m 0 taskset -c 0 ./stream.100M 1> /dev/null & watch -n 1
numastat -cp $!

Per-node process memory usage (in MBs) for PID 2394 (stream.100M)
         Node 0 Node 1 Node 2 Node 3 Total
         ------ ------ ------ ------ -----
Huge          0      0      0      0     0
Heap       2289      0      0      0  2289
Stack         0      0      0      0     0
Private       0      0      0      0     0
-------  ------ ------ ------ ------ -----
Total      2289      0      0      0  2289

---

$ numactl -s 0 taskset -c 0 ./stream.100M
policy: default
preferred node: current
physcpubind: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44
45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67
68 69 70 71 72 73 74 75 76 77 78 79
cpubind: 0 1 2 3
nodebind: 0 1 2 3
membind: 0 1 2 3

Thanks,
Andreas
