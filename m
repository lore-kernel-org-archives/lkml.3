Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaIXKPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:15:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10104 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbaIXKPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:15:18 -0400
X-AuditID: cbfee61b-f79d76d0000024d6-f8-542299aebc78
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 0/6 v2] f2fs: support inline dir
Date: Wed, 24 Sep 2014 18:14:15 +0800
Message-id: <003b01cfd7e0$6ce35e40$46aa1ac0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac/X34HEdqiOG/QvRN2rPdQfeaubKw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jQd31M5VCDJ7vZLG4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxpZN3YwF
	DdIVl27NYG5g7BTpYuTkkBAwkdj3spUJwhaTuHBvPVsXIxeHkMB0Rom5J3rZIZwfjBKzV/5j
	BKliE1CRWN7xH6xDRMBLYtL+EywgNrOAh0Rjx3dWEFtYwEri2ueXYPUsAqoS8w/NB7N5BSwl
	1h/dzgxhC0r8mHwPqldLYv3O40wQtrzE5jVvmSEuUpDYcfY1I8QuPYldf2awQ9SIS2w8cotl
	AqPALCSjZiEZNQvJqFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECA7qZ9I7GFc1
	WBxiFOBgVOLhnSCuFCLEmlhWXJl7iFGCg1lJhPdVD1CINyWxsiq1KD++qDQntfgQozQHi5I4
	78FW60AhgfTEktTs1NSC1CKYLBMHp1QD4+IrDdZ/W5maO9m0m6+eaUw1TsjdoZvF32Ae5q2p
	4Xh8xp0fZ9Zr7AyVVmS+cZY/58ZeJlf9SfudMoRtvl64EZs7R+XjlsM9Qi9esOvUqnGaWDSY
	3V3KrdOy45ZW0bUjk5k/acx+P7vghMYKB4ZH7ScLlqZ6TLq18tefiLd63+6prTn/qbTruxJL
	cUaioRZzUXEiAAnPe75mAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are large space in f2fs inode, so last inline data patch set have made
f2fs to acquire the ability of storing data of small file (less than ~3.4k)
directly in inode block, but not support inline dir. In this patch, we make
f2fs to support inline dir.

Layout:
Inline dir layout is the same as inline data layout,
a. i_addr[0] are reserved space for converting from inline dir to regular one
when out-of-space occur in inline dentry.
b. i_addr[1..872] will be used as storing space of inline dentry.
c. i_addr[873..922] are reserved for inline xattr.

Size:
Since our max size of inline dir space is limit to MAX_INLINE_DATA (3488 bytes), 
we introduce inline dentry struct fit for available space, then our dentry slot
number in inline dentry reduce to 182, less than normal dentry block's 214.

Process:
In inline dir mode, our dir entries will be lookuped/stored/deleted in the
inline dentry space of inode, util there are no more space to store new added
dir entry, in this case we will convert inline dentry to normal 0-index dentry
block and disable inline dir mode for this inode.

Benefit points:
a) space saving
   1) Test with fsstress with special arguments, it can save about 7% space.
   time fsstress -c -p 20 -n 500 -l 10 -d /mnt/f2fs -w -f chown=0 -f creat=10
   -f dwrite=0 -f fdatasync=0 -f fsync=0 -f link=10 -f mkdir=10 -f mknod=10
   -f rename=0 -f rmdir=0 -f symlink=10 -f truncate=0 -f unlink=0 -f write=10 -S
		Dev		1K-blocks  Used    Available Use% Mounted on
   empty	/dev/sdb        20969472  1134600  19691512   6% /mnt/f2fs
   based	/dev/sdb        20969472  2331676  18494436  12% /mnt/f2fs
   patched	/dev/sdb        20969472  2247480  18578632  11% /mnt/f2fs
   2) Test with storing kernel src, it can save less than 1.4% space.
   empty	/dev/sdb        20969472  1134600  19691512   6% /mnt/f2fs
   based	/dev/sdb        20969472  1934656  18891456  10% /mnt/f2fs
   patched	/dev/sdb        20969472  1923400  18902712  10% /mnt/f2fs

b) performance
   Test with fsstress shows cost time reduce about 5%.
   time fsstress -d /mnt/f2fs -l 5 -n 1000 -p 20 -c -r
   based	135.652 s
   patched	129.256 s  (mount -o inline_dentry)

v2:
 o introduce f2fs_drop_nlink from f2fs_delete_entry to reuse code in
   f2fs_delete_inline_entry.
 o remove kmap/kunmap for inode page pointed out by Jaegeuk Kim.
 o introduce a new mount option inline_dentry for inline dir pointed out by
   Jaegeuk Kim.
 o rebase to last dev of f2fs (20140924).
 o retest performance/space-gain for inline dir excluding influence of inline
   data.

Chao Yu (6):
  f2fs: add infra struct and helper for inline dir
  f2fs: add a new mount option for inline dir
  f2fs: export dir operations for inline dir
  f2fs: add key function to handle inline dir
  f2fs: enable inline dir handling
  f2fs: update f2fs documentation for inline dir support

 Documentation/filesystems/f2fs.txt |   4 +
 fs/f2fs/dir.c                      | 103 +++++++----
 fs/f2fs/f2fs.h                     |  40 ++++-
 fs/f2fs/file.c                     |   2 +-
 fs/f2fs/inline.c                   | 347 +++++++++++++++++++++++++++++++++++++
 fs/f2fs/namei.c                    |  38 ++--
 fs/f2fs/recovery.c                 |   5 +-
 fs/f2fs/super.c                    |   7 +
 include/linux/f2fs_fs.h            |  19 ++
 9 files changed, 512 insertions(+), 53 deletions(-)

-- 
2.0.1.474.g72c7794


