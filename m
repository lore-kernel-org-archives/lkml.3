Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751029AbaHICpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 22:45:19 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28520 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaHICpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 22:45:18 -0400
X-AuditID: cbfee61b-f79f86d00000144c-bf-53e58b3cef52
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 0/5] f2fs: support inline dir
Date: Sat, 09 Aug 2014 10:44:31 +0800
Message-id: <00be01cfb37b$f3ba83f0$db2f8bd0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+yudd/nhOGTjwASamr6U3ynIeIcg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jQV2b7qfBBgvb5C2u7Wtksniyfhaz
	xaVF7haXd81hc2Dx2LSqk81j94LPTB59W1YxenzeJBfAEsVlk5Kak1mWWqRvl8CVsfjib+aC
	FpGKe39uszYwtvB3MXJySAiYSLx5fYsJwhaTuHBvPVsXIxeHkMB0Ronby2awgSSEBH4wSvz5
	GAViswmoSCzv+A/WICLgJTFp/wkWEJtZwEOiseM7K4gtLGAusaLrE1gNi4CqxKnPz5hBbF4B
	S4n73cuhbEGJH5PvQfVqSWze1sQKYctLbF7zlhniIAWJHWdfM0Ls0pOYeWEJO0SNuMTGI7dY
	JjAKzEIyahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOCQfia9g3FV
	g8UhRgEORiUe3hU2T4OFWBPLiitzDzFKcDArifAurAQK8aYkVlalFuXHF5XmpBYfYpTmYFES
	5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYHQqWDTzROM1vUadIEEz8YqSF33mzsaZze2cN/Y9
	eTTZqTvX89Lz28YfJNMZZz1n3mzDOWWpxOL85qbXnP7L5okaLsvc3xm4KnLx6W+qmzjWPVm+
	uqdQT6Pde+UjGZVpF5beOhhlyVQkqG56piWucE/AHQ/VZXLTPVbvnvjJ6P7cTL6rE373rlFi
	Kc5INNRiLipOBABhJLuyZQIAAA==
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
   1) Test with fsstress with special arguments, it can save about 3% space.
   time fsstress -c -p 20 -n 500 -l 10 -d /mnt/f2fs -w -f chown=0 -f creat=10
   -f dwrite=0 -f fdatasync=0 -f fsync=0 -f link=10 -f mkdir=10 -f mknod=10
   -f rename=0 -f rmdir=0 -f symlink=10 -f truncate=0 -f unlink=0 -f write=10 -S
   based	/dev/sdb        20969472  2234136  18591976  11% /mnt/f2fs
   patched	/dev/sdb        20969472  2303120  18522992  12% /mnt/f2fs
   2) Test with storing kernel src, it can save less than 1% space.

b) performance
   Test with fsstress shows cost time reduce 21%.
   time fsstress -d /mnt/f2fs -l 5 -n 1000 -p 20 -c -r
   based	168.503 s  (inline data)
   patched	132.840 s  (inline data + inline dir)

Chao Yu (5):
  f2fs: add infra macro and sturct for inline dir
  f2fs: export dir operations for inline dir
  f2fs: add key function to handle inline dir
  f2fs: enable inline dir handling
  f2fs: update f2fs documentation

 Documentation/filesystems/f2fs.txt |   5 +-
 fs/f2fs/dir.c                      |  48 +++--
 fs/f2fs/f2fs.h                     |  18 +-
 fs/f2fs/inline.c                   | 388 +++++++++++++++++++++++++++++++++++++
 fs/f2fs/namei.c                    |   8 +-
 fs/f2fs/recovery.c                 |   2 +-
 include/linux/f2fs_fs.h            |  18 ++
 7 files changed, 469 insertions(+), 18 deletions(-)

-- 
2.0.1.474.g72c7794


