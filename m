Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab3JKG2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:28:36 -0400
Received: from mdfmta005.mxout.tch.inty.net ([91.221.169.46]:40632 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756667Ab3JKG2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:28:34 -0400
From: Phillip Lougher <phillip@squashfs.org.uk>
To: linux-kernel@vger.kernel.org
Cc: minchan@kernel.org, Phillip Lougher <phillip@squashfs.org.uk>
Subject: [PATCH 0/3] Squashfs: Directly decompress into the page cache for file data
Date: Fri, 11 Oct 2013 07:19:37 +0100
Message-Id: <1381472381-3825-1-git-send-email-phillip@squashfs.org.uk>
X-Mailer: git-send-email 1.7.10.4
X-MDF-HostID: 18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set introduces an implementation of
squashfs_readpage() that directly decompresses into the
page cache.

It first generalises the decompressors by adding a page handler
abstraction.  This adds helpers to allow the decompressors
to access and process the output buffers in an implementation
independant manner.

It then adds a read_page() implementation for file data that
uses the page handler abstraction to push down the necessary
kmap_atomic/kunmap_atomic operations on the page cache buffers into
the decompressors.  This enables direct copying into the page cache
without using the slow kmap/kunmap calls.

The code detects when multiple threads are racing in
squashfs_readpage() to decompress the same block, and avoids
this regression by falling back to using an intermediate
buffer.

This patch enhances the performance of Squashfs significantly
when multiple processes are accessing the filesystem simultaneously
because it not only reduces memcopying, but it more importantly
eliminates the lock contention on the intermediate buffer.

Using single-threaded decompression.

        dd if=file1 of=/dev/null bs=4096 &
        dd if=file2 of=/dev/null bs=4096 &
        dd if=file3 of=/dev/null bs=4096 &
        dd if=file4 of=/dev/null bs=4096

Before:

629145600 bytes (629 MB) copied, 45.8046 s, 13.7 MB/s

After:

629145600 bytes (629 MB) copied, 9.29414 s, 67.7 MB/s
