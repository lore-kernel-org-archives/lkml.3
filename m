Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163072Ab3DFKKK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 06:10:10 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:32829 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab3DFKKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 06:10:08 -0400
Message-ID: <515FF2D4.2050307@gmail.com>
Date: Sat, 06 Apr 2013 12:03:00 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4] fsfreeze: from uninterruptible to killable waiting
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

with this patch series we try to change the fs freeze behavior in order
to sleep in a killable state instead of sleeping in uninterruptible 
state. The patches are *NOT* tested because but a first review is welcome.
The design is simply:

1) Internal fs operations are not changed from fsfreeze point of view, 
sb_start_intwrite is not changed;

2) sb_start_write and sb_start_pagefault now return a proper error code 
if the process receive SIGKILL and all the functions must manage this 
error and return EINTR or VM_FAULT_RETRY.

Marco Stornelli (4):
  fsfreeze: add new internal __sb_start_write_wait
  fsfreeze: manage kill signal when sb_start_write is called
  fsfreeze: manage kill signal when sb_start_pagefault is called
  fsfreeze: avoid to return zero in __get_user_pages

 fs/btrfs/file.c    |    9 +++++++--
 fs/btrfs/inode.c   |    4 +++-
 fs/buffer.c        |    4 +++-
 fs/cifs/file.c     |    4 +++-
 fs/ext4/inode.c    |    4 +++-
 fs/ext4/mmp.c      |    3 ++-
 fs/ext4/super.c    |    4 +++-
 fs/f2fs/file.c     |    4 +++-
 fs/fuse/file.c     |    4 +++-
 fs/gfs2/file.c     |    4 +++-
 fs/namespace.c     |    8 ++++++--
 fs/nilfs2/file.c   |    4 +++-
 fs/ntfs/file.c     |    4 +++-
 fs/ocfs2/file.c    |    4 +++-
 fs/ocfs2/mmap.c    |    4 +++-
 fs/open.c          |    8 ++++++--
 fs/splice.c        |    4 +++-
 fs/super.c         |   47 ++++++++++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_file.c  |    4 +++-
 include/linux/fs.h |   19 ++++++++++++-------
 mm/filemap.c       |   11 ++++++++---
 mm/filemap_xip.c   |    4 +++-
 mm/memory.c        |    2 +-
 23 files changed, 127 insertions(+), 40 deletions(-)

-- 
1.7.3.4
---

