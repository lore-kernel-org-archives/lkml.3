Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934146Ab3BSSvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:51:54 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:43220 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934097Ab3BSSvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:51:47 -0500
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] dcache: make Oracle more scalable on large systems
Date: Tue, 19 Feb 2013 13:50:55 -0500
Message-Id: <1361299859-27056-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was found that the Oracle database software issues a lot of call
to the seq_path() kernel function which translates a (dentry, mnt)
pair to an absolute path. The seq_path() function will eventually
take the following two locks:

1. dentry->d_lock (spinlock) from dget()/dput()
2. rename_lock    (seqlock)  from d_path()

With a lot of database activities, the spinning of the 2 locks takes
a major portion of the kernel time and slow down the database software.

This set of patches were designed to minimize the locking overhead of
this code path and improve Oracle performance on systems with a large
number of CPUs.

The current kernel takes the dentry->d_lock lock whenever it wants to
increment or decrement the d_count reference count. However, nothing
big will really happen until the reference count goes all the way to 1
or 0.  Actually, we don't need to take the lock when reference count
is bigger than 1. Instead, atomic cmpxchg() function can be used to
increment or decrement the count in these situations. For safety,
other reference count update operations have to be changed to use
atomic instruction as well.

The rename_lock is a sequence lock. The d_path() function takes the
writer lock because it needs to traverse different dentries through
pointers to get the full path name. Hence it can't tolerate changes
in those pointers. But taking the writer lock also prevent multiple
d_path() calls to proceed concurrently.

A solution is to introduce a new lock type where there will be a
second type of reader which can block the writers - the sequence
read/write lock (seqrwlock). The d_path() and related functions will
then be changed to take the reader lock instead of the writer lock.
This will allow multiple d_path() operations to proceed concurrently.

Performance testing was done using the Oracle SLOB benchmark with the
latest 11.2.0.3 release of Oracle on a 3.8-rc3 kernel. Database files
were put in a tmpfs partition to minimize physical I/O overhead. Huge
pages were used with 30GB of SGA. The test machine was an 8-socket,
80-core HP Proliant DL980 with 1TB of memory and hyperthreading off.
The tests were run 5 times and the averages were taken.

The patch only has a slight positive impact on logical read
performance. The impact on write (redo size) performance, however,
is much greater. The redo size is a proxy of how much database write
has happened. So a larger value means a higher transaction rate.

+---------+---------+-------------+------------+----------+
| Readers | Writers | Redo Size   | Redo Size  | % Change |
|	  |	    | w/o patch   | with patch |	  |
|	  |	    |   (MB/s)    |   (MB/s)   |	  |
+---------+---------+-------------+------------+----------+
|    8	  |   64    |    802      |    903     |  12.6%	  |
|   32	  |   64    |    798      |    892     |  11.8%	  |
|   80	  |   64    |    658      |    714     |   8.5%	  |
|  128	  |   64    |    748      |    907     |  21.3%	  |
+---------+---------+-------------+------------+----------+

The table below shows the %system and %user times reported by Oracle's
AWR tool as well as the %time spent in the spinlocking code in kernel
with (inside parenthesis) and without (outside parenthesis) the patch.

+---------+---------+------------+------------+------------+
| Readers | Writers |  % System  |   % User   | % spinlock |
+---------+---------+------------+------------+------------+
|   32	  |    0    |  0.3(0.3)  | 39.0(39.0) |  6.3(17.4) |
|   80	  |    0    |  0.7(0.7)  | 97.4(94.2) |  2.9(31.7) |
|  128	  |    0    |  1.4(1.4)  | 34.4(32.2) | 43.5(62.2) |
|   32	  |   64    |  3.8(3.5)  | 55.4(53.6) |  9.1(35.0) |
|   80	  |   64    |  3.0(2.9)  | 94.4(93.9) |  4.5(38.8) |
|  128	  |   64    |  4.7(4.3)  | 38.2(40.3) | 34.8(58.7) |
+---------+---------+------------+------------+------------+

The following tests with multiple threads were also run on kernels with
and without the patch on both DL980 and a PC with 4-core i5 processor:

1. find $HOME -size 0b
2. cat /proc/*/maps /proc/*/numa_maps
3. git diff

For both the find-size and cat-maps tests, the performance difference
with hot cache was within a few percentage points and hence within
the margin of error. Single-thread performance was slightly worse,
but multithread performance was generally a bit better. Apparently,
reference count update isn't a significant factor in those tests. Their
perf traces indicates that there was less spinlock content in
functions like dput(), but the function itself ran a little bit longer
on average.

The git-diff test showed no difference in performance. There is a
slight increase in system time compensated by a slight decrease in
user time.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>

Waiman Long (4):
  dcache: Don't take unncessary lock in d_count update
  dcache: introduce a new sequence read/write lock type
  dcache: change rename_lock to a sequence read/write lock
  dcache: don't need to take d_lock in prepend_path()

 fs/autofs4/waitq.c        |    6 +-
 fs/ceph/mds_client.c      |    4 +-
 fs/cifs/dir.c             |    4 +-
 fs/dcache.c               |  113 +++++++++++++++++++------------------
 fs/namei.c                |    2 +-
 fs/nfs/namespace.c        |    6 +-
 include/linux/dcache.h    |  109 ++++++++++++++++++++++++++++++++++--
 include/linux/seqrwlock.h |  138 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/auditsc.c          |    5 +-
 9 files changed, 315 insertions(+), 72 deletions(-)
 create mode 100644 include/linux/seqrwlock.h

