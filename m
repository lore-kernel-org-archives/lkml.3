Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab3EGXYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 19:24:10 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:32825 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab3EGXYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 19:24:08 -0400
MIME-Version: 1.0
Date: Tue, 7 May 2013 16:24:05 -0700
Message-ID: <CAEsagEhu3pND5j410mQM=AMEQZ-1WOG0qdKys0pfFv0-jkLs8g@mail.gmail.com>
Subject: Tux3 Report: Faster than tmpfs, what?
From: Daniel Phillips <daniel.raymond.phillips@gmail.com>
To: linux-kernel@vger.kernel.org, tux3@tux3.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When something sounds to good to be true, it usually is. But not always. Today
Hirofumi posted some nigh on unbelievable dbench results that show Tux3
beating tmpfs. To put this in perspective, we normally regard tmpfs as
unbeatable because it is just a thin shim between the standard VFS mechanisms
that every filesystem must use, and the swap device. Our usual definition of
successful optimization is that we end up somewhere between Ext4 and Tmpfs,
or in other words, faster than Ext4. This time we got an excellent surprise.

The benchmark:

    dbench -t 30 -c client2.txt 1 & (while true; do sync; sleep 4; done)

Configuration:

    KVM with two CPUs and 4 GB memory running on a Sandy Bridge four core host
    at 3.4 GHz with 8 GB of memory. Spinning disk. (Disk drive details
to follow.)

Summary of results:

    tmpfs: Throughput 1489.00 MB/sec max_latency=1.758 ms
    tux3:  Throughput 1546.81 MB/sec max_latency=12.950 ms
    ext4:  Throughput 1017.84 MB/sec max_latency=1441.585 ms

Tux3 edged out Tmpfs and stomped Ext4 righteously. What is going on?
Simple: Tux3 has a frontend/backend design that runs on two CPUs. This
allows handing off some of the work of unlink and delete to the kernel tux3d,
which runs asynchronously from the dbench task. All Tux3 needs to do in the
dbench context is set a flag in the deleted inode and add it to a dirty
list. The remaining work like truncating page cache pages is handled by the
backend tux3d. The effect is easily visible in the dbench details below
(See the Unlink and Deltree lines).

It is hard to overstate how pleased we are with these results. Particularly
after our first dbench tests a couple of days ago were embarrassing: more than
five times slower than Ext4. The issue turned out to be inefficient inode
allocation. Hirofumi changed the horribly slow itable btree search to a
simple "allocate the next inode number" counter, and shazam! The slowpoke
became a superstar. Now, this comes with a caveat: the code  that produces
this benchmark currently relies on this benchmark-specific hack to speed up
inode number allocation. However, we are pretty sure that our production inode
allocation algorithm will have insignificant additional overhead versus this
temporary hack. If only because "allocate the next inode number" is nearly
always the best strategy.

With directory indexing now considered a solved problem, the only big
issue we feel needs to be addressed before offering Tux3 for merge is
allocation. For now we use the same overly simplistic strategy to allocate
both disk blocks and inode numbers, which is trivially easy to defeat to
generate horrible benchmark numbers on spinning disk. So the next round
of work, which I hope will only take a few weeks, consists of improving
these allocators to at least a somewhat respectable level.

For inode number allocation, I have proposed a strategy that looks a lot
like Ext2/3/4 inode bitmaps. Tux3's twist is that these bitmaps are just
volatile cache objects, never transferred to disk. According to me, the
overhead of allocating from these bitmaps will hardly affect today's
benchmark numbers at all, but that remains to be proven.

Detailed dbench results:

tux3:
    Operation      Count    AvgLat    MaxLat
    ----------------------------------------
    NTCreateX    1477980     0.003    12.944
    Close        1085650     0.001     0.307
    Rename         62579     0.006     0.288
    Unlink        298496     0.002     0.345
    Deltree           38     0.083     0.157
    Mkdir             19     0.001     0.002
    Qpathinfo    1339597     0.002     0.468
    Qfileinfo     234761     0.000     0.231
    Qfsinfo       245654     0.001     0.259
    Sfileinfo     120379     0.001     0.342
    Find          517948     0.005     0.352
    WriteX        736964     0.007     0.520
    ReadX        2316653     0.002     0.499
    LockX           4812     0.002     0.207
    UnlockX         4812     0.001     0.221
    Throughput 1546.81 MB/sec  1 clients  1 procs  max_latency=12.950 ms

tmpfs:
    Operation      Count    AvgLat    MaxLat
    ----------------------------------------
    NTCreateX    1423080     0.004     1.155
    Close        1045354     0.001     0.578
    Rename         60260     0.007     0.470
    Unlink        287392     0.004     0.607
    Deltree           36     0.651     1.352
    Mkdir             18     0.001     0.002
    Qpathinfo    1289893     0.002     0.575
    Qfileinfo     226045     0.000     0.346
    Qfsinfo       236518     0.001     0.383
    Sfileinfo     115924     0.001     0.405
    Find          498705     0.007     0.614
    WriteX        709522     0.005     0.679
    ReadX        2230794     0.002     1.271
    LockX           4634     0.002     0.021
    UnlockX         4634     0.001     0.324
    Throughput 1489 MB/sec  1 clients  1 procs  max_latency=1.758 ms

ext4:
    Operation      Count    AvgLat    MaxLat
    ----------------------------------------
    NTCreateX     988446     0.005    29.226
    Close         726028     0.001     0.247
    Rename         41857     0.011     0.238
    Unlink        199651     0.022  1441.552
    Deltree           24     1.517     3.358
    Mkdir             12     0.002     0.002
    Qpathinfo     895940     0.003    15.849
    Qfileinfo     156970     0.001     0.429
    Qfsinfo       164303     0.001     0.210
    Sfileinfo      80501     0.002     1.037
    Find          346400     0.010     2.885
    WriteX        492615     0.009    13.676
    ReadX        1549654     0.002     0.808
    LockX           3220     0.002     0.015
    UnlockX         3220     0.001     0.010
    Throughput 1017.84 MB/sec  1 clients  1 procs  max_latency=1441.585 ms

Apologies for the formatting. I will get back to a real mailer soon.

Regards,

Daniel
