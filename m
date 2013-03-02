Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab3CBDoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:44:04 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:64375 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3CBDoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:44:02 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v7 0/7] fat (exportfs): support stale_rw and nostale_ro mount option.
Date: Sat,  2 Mar 2013 12:43:52 +0900
Message-Id: <1362195832-20942-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This patch set eliminates the client side ESTALE errors when a FAT partition
exported over NFS has it's dentries evicted from the cache. The idea is to
find the on-disk location_'i_pos' of the dirent of the inode that has been
evicted and use it to rebuild the inode.

Change log
v7:
Assign i_pos = MSDOS_ROOT_INO in fat_read_root() and drop check in fat _getattr().
Remove __packed attribute from struct fat_fid.
Make code in fat_encode_fh() more readable.

v6:
Dummy inode approach to eliminate custom function fat_traverse_cluster().

v5:
Modified  fat_ent_read() arguments so that the custom function 
fat_read_next_clus() can be eliminated.

v(no name):
Define two nfs export_operation structures, one for 'stale_rw' mounts and 
the other for 'nostale_ro'

fat_nfs_get_inode does not hold i_mutex of parent directory. So introduce
fat_lock_build_inode().

v4:                                                                                                                                                                                                  
Instead of assigning i_pos to inode->i_ino, assign it to kstat->ino

v3:
Dropped busy-list approach and made the filesystem read only when
rebuilding evicted inodes, by providing stale_rw and nostale_ro mount options
 
v2:
Introduced a list of busy i_pos values for inodes that are unlinked but
having open file handles. Did this to avoid assigning such i_pos values to new
files created at same location.

v1:
Permanent inode number based approach by assigning i_pos to i_ino.
Added custom function fat_read_next_clus() and  fat_traverse_cluster()
to read disk entries.

Namjae Jeon (7):
  fat: Introduce 2 new values for the -o nfs mount option
  fat: move fat_i_pos_read to fat.h
  fat: introduce a helper fat_get_blknr_offset()
  fat: restructure export_operations
  fat (exportfs): rebuild inode if ilookup() fails
  fat (exportfs): rebuild directory-inode if fat_dget() fails
  Documentation: update nfs option in filesystem/vfat.txt
---
1.7.9.5

