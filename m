Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936019Ab3DKCpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 22:45:25 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:51218 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764241Ab3DKCpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 22:45:24 -0400
MIME-Version: 1.0
Date: Thu, 11 Apr 2013 10:45:23 +0800
Message-ID: <CAF=P+AjJWefhpXBV+ugPczupvQgXy1vcH4m70hjtEPPJwsky9Q@mail.gmail.com>
Subject: mm/slab: extremly high slab cache problem
From: lulu he <loloseed@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: liuhao@jike.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'am not used to ask but I have followed every piece of information I
could not find solution, so I'am trying here for help.

On one of my server, I have some memory/disk KV service,
Memory KV behave like memcached, ask for a big trunk of memory(10GB)
when initialized,
Disk Kv behave like leveldbd, its random read and sequential write,
and it frequently reads a lot files.
Memory are all alloced using libc malloc.

My KV server process do not consume a lot of memory as below (since
lack of memory, I have killed memory KV, leaving only disk KV, but
free memory still goes down):

:~$top
PR NI VIRT RES SHR S %CPU %MEM TIME+ COMMAND
20 0 5030m 3.9g 2772 S 8 6.1 10430:52 tair_server
20 0 4833m 3.9g 4560 S 8 6.1 10171:07 tair_server
20 0 4844m 3.9g 3844 S 38 6.1 10073:32 tair_server
20 0 4765m 3.8g 4144 S 8 6.0 10552:39 tair_server
20 0 2941m 2.4g 9.8m S 0 3.8 256:45.70 tair_server
20 0 2953m 2.4g 12m S 1 3.7 276:54.64 tair_server

BUT, my memory are gone.
$free -m
             total       used       free     shared    buffers     cached
Mem:         64552      57778       6774          0         16        326
-/+ buffers/cache:      57435       7117
Swap:            0          0          0


I can see slab consume lots of my memory, and it's unreclaimable.
$cat /proc/meminfo
MemTotal:       66101892 kB
MemFree:         6816228 kB
Buffers:           17024 kB
Cached:           456640 kB
SwapCached:            0 kB
Active:         19697712 kB
Inactive:        3197312 kB
Active(anon):   19546504 kB
Inactive(anon):  2875632 kB
Active(file):     151208 kB
Inactive(file):   321680 kB
Unevictable:          48 kB
Mlocked:               0 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:              6612 kB
Writeback:            72 kB
AnonPages:      22421152 kB
Mapped:            54408 kB
Shmem:               332 kB
Slab:           28870400 kB
SReclaimable:     213344 kB
SUnreclaim:     28657056 kB
KernelStack:       30000 kB
PageTables:        62776 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    33050944 kB
Committed_AS:   37517224 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      388624 kB
VmallocChunk:   34324313700 kB
HardwareCorrupted:     0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        5696 kB
DirectMap2M:     2082816 kB
DirectMap1G:    65011712 kB

Here is the slab info.
$slabtop -s c
 OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
69842766 69838389  38%    0.19K 1663025       42  13304200K kmalloc-192
69314912 69314796  38%    0.12K 2166091       32   8664364K kmalloc-128
70866624 70866323  39%    0.06K 1107291       64   4429164K kmalloc-64
69299968 69299592  38%    0.03K 541406      128   2165624K kmalloc-32
128388  72434  56%    0.99K   4230       32    135360K ext4_inode_cache
208782  94112  45%    0.19K   4971       42     39768K dentry


I don't who and why consume such lots memory, and how to solve this.
Can this be an interval kernel error?
OR it's a glibc problem, it do'not return memory back to system, due
to frequently disk read?

thanks in advance, any help will be appreciated.


--
loloseed
