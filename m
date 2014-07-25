Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935158AbaGYRhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:37:24 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:52978 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935053AbaGYRhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:37:19 -0400
Date: Fri, 25 Jul 2014 13:37:19 -0400 (EDT)
From: Abhijith Das <adas@redhat.com>
To: linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>
Message-ID: <1717400531.13456321.1406309839199.JavaMail.zimbra@redhat.com>
In-Reply-To: <1106785262.13440918.1406308542921.JavaMail.zimbra@redhat.com>
Subject: [RFC] readdirplus implementations: xgetdents vs dirreadahead
 syscalls
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.6]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - GC36 (Linux)/8.0.6_GA_5922)
Thread-Topic: readdirplus implementations: xgetdents vs dirreadahead syscalls
Thread-Index: Ij9KLOPKGNTymO4OtMCyOnVUdGfO5A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The topic of a readdirplus-like syscall had come up for discussion at last year's
LSF/MM collab summit. I wrote a couple of syscalls with their GFS2 implementations
to get at a directory's entries as well as stat() info on the individual inodes.
I'm presenting these patches and some early test results on a single-node GFS2
filesystem.

1. dirreadahead() - This patchset is very simple compared to the xgetdents() system
call below and scales very well for large directories in GFS2. dirreadahead() is
designed to be called prior to getdents+stat operations. In it's current form, it
only speeds up stat() operations by caching the relevant inodes. Support can be
added in the future to cache extended attribute blocks as well. This works by first
collecting all the inode numbers of the directory's entries (subject to a numeric
or memory cap). This list is sorted by inode disk block order and passed on to
workqueues to perform lookups on the inodes asynchronously to bring them into the
cache.

2. xgetdents() - I had posted a version of this patchset some time last year and
it is largely unchanged - I just ported it to the latest upstream kernel. It
allows the user to request a combination of entries, stat and xattrs (keys/values)
for a directory. The stat portion is based on David Howells' xstat patchset he
had posted last year as well. I've included the relevant vfs bits in my patchset.
xgetdents() in GFS2 works in two phases. In the first phase, it collects all the
dirents by reading the directory in question. In phase two, it reads in inode
blocks and xattr blocks (if requested) for each entry after sorting the disk
accesses in block order. All of the intermediate data is stored in a buffer backed
by a vector of pages and is eventually transferred to the user supplied buffer.

Both syscalls perform significantly better than a simple getdents+stat with a cold
cache. The main advantage lies in being able to sort disk accesses for a bunch of
inodes in advance compared to seeking all over the disk for inodes one entry at a
time.

This graph (https://www.dropbox.com/s/fwi1ovu7mzlrwuq/speed-graph.png) shows the
time taken to get directory entries and their respective stat info by 3 different
sets of syscalls:

1) getdents+stat ('ls -l', basically) - Solid blue line
2) xgetdents with various buffer size and num_entries limits - Dotted lines
   Eg: v16384 d10000 means a limit of 16384 pages for the scratch buffer and
   a maximum of 10000 entries to collect at a time.
3) dirreadahead+getdents+stat with various num_entries limits - Dash-dot lines
   Eg: d10000 implies that it would fire off a max of 10000 inode lookups during
   each syscall.

numfiles:                      10000     50000     100000    500000
--------------------------------------------------------------------
getdents+stat                   1.4s      220s       514s     2441s
xgetdents                       1.2s       43s        75s     1710s
dirreadahead+getdents+stat      1.1s        5s        68s      391s

Here is a seekwatcher graph from a test run on a directory of 50000 files. 
(https://www.dropbox.com/s/fma8d4jzh7365lh/50000-combined.png) The comparison is
between getdents+stat and xgetdents. The first set of plots is of getdents+stat,
followed by xgetdents() with steadily increasing buffer sizes (256 to 262144) and
num_entries (100 to 1000000) limits. One can see the effect of ordering the disk
reads in the Disk IO portion of the graphs and the corresponding effect on seeks,
throughput and overall time taken.

This second seekwatcher graph similarly shows the dirreadahead()+getdents()+stat()
syscall-combo for a 500000-file directory with increasing num_entries (100 to
1000000) limits versus getdents+stat.
(https://www.dropbox.com/s/rrhvamu99th3eae/500000-ra_combined_new.png)
The corresponding getdents+stat baseline for this run is at the top of the series
of graphs.

I'm posting these two patchsets shortly for comments.

Cheers!
--Abhi

Red Hat Filesystems
