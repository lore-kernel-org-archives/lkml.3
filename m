Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab3HEToM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:44:12 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34674 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab3HEToK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:44:10 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-mm@kvack.org, linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [RFC 0/3] Add madvise(..., MADV_WILLWRITE)
Date: Mon,  5 Aug 2013 12:43:58 -0700
Message-Id: <cover.1375729665.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My application fallocates and mmaps (shared, writable) a lot (several
GB) of data at startup.  Those mappings are mlocked, and they live on
ext4.  The first write to any given page is slow because
ext4_da_get_block_prep can block.  This means that, to get decent
performance, I need to write something to all of these pages at
startup.  This, in turn, causes a giant IO storm as several GB of
zeros get pointlessly written to disk.

This series is an attempt to add madvise(..., MADV_WILLWRITE) to
signal to the kernel that I will eventually write to the referenced
pages.  It should cause any expensive operations that happen on the
first write to happen immediately, but it should not result in
dirtying the pages.

madvice(addr, len, MADV_WILLWRITE) returns the number of bytes that
the operation succeeded on or a negative error code if there was an
actual failure.  A return value of zero signifies that the kernel
doesn't know how to "willwrite" the range and that userspace should
implement a fallback.

For now, it only works on shared writable ext4 mappings.  Eventually
it should support other filesystems as well as private pages (it
should COW the pages but not cause swap IO) and anonymous pages (it
should COW the zero page if applicable).

The implementation leaves much to be desired.  In particular, it
generates dirty buffer heads on a clean page, and this scares me.

Thoughts?

Andy Lutomirski (3):
  mm: Add MADV_WILLWRITE to indicate that a range will be written to
  fs: Add block_willwrite
  ext4: Implement willwrite for the delalloc case

 fs/buffer.c                            | 57 ++++++++++++++++++++++++++++++++++
 fs/ext4/ext4.h                         |  2 ++
 fs/ext4/file.c                         |  1 +
 fs/ext4/inode.c                        | 22 +++++++++++++
 include/linux/buffer_head.h            |  3 ++
 include/linux/mm.h                     | 12 +++++++
 include/uapi/asm-generic/mman-common.h |  3 ++
 mm/madvise.c                           | 28 +++++++++++++++--
 8 files changed, 126 insertions(+), 2 deletions(-)

-- 
1.8.3.1

