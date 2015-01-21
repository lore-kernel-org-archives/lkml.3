Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbbAUPNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:13:10 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:44925 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbbAUPNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:13:05 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: david@fromorbit.com, tytso@mit.edu
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com,
        bfoster@redhat.com, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v9 0/11] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
Date: Thu, 22 Jan 2015 00:11:55 +0900
Message-Id: <1421853126-4505-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

In continuation of the work of making the process of non linear editing of
media files faster, we introduce here the new flag FALLOC_FL_INSERT_RANGE
for fallocate.

This flag will work opposite to the FALLOC_FL_COLLAPSE_RANGE flag.
As such, specifying FALLOC_FL_INSERT_RANGE flag will create new space inside file
by inserting a hole within the range specified by offset and len. 
User can write new data in this space. e.g. ads.
Like collapse range, currently we have the limitation that offset and len should
be block size aligned for both XFS and Ext4.

The semantics of the flag are :
1) It creates space within file by inserting a hole of  len bytes starting
   at offset byte without overwriting any existing data. All the data blocks
   from offset to EOF are shifted towards right to make hole space.
2) It should be used exclusively. No other fallocate flag in combination.
3) Offset and length supplied to fallocate should be fs block size aligned
   in case of xfs and ext4.
4) Insert range does not work for the case when offset is overlapping/beyond
   i_size. If the user wants to insert space at the end of file they are
   advised to use either ftruncate(2) or fallocate(2) with mode 0.
5) It increses the size of file by len bytes.


Namjae Jeon (11):
 fs: Add support FALLOC_FL_INSERT_RANGE for fallocate
 xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate
 ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate
 xfsprogs: xfs_io: add finsert command for insert range via fallocate
 xfstests: generic/039: Standard insert range tests
 xfstests: generic/040: Delayed allocation insert range
 xfstests: generic/041: Multi insert range tests
 xfstests: generic/042: Delayed allocation multi insert
 xfstests: generic/043: Test multiple fallocate insert/collapse range calls
 xfstests: fsstress: Add fallocate insert range operation
 xfstests: fsx: Add fallocate insert range operation
-- 
1.7.9.5

