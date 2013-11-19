Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab3KSIQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 03:16:57 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:43066 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3KSIQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 03:16:55 -0500
X-AuditID: 9c930179-b7b6eae000007f2a-89-528b1e756723
Date: Tue, 19 Nov 2013 17:17:19 +0900
From: Minchan Kim <minchan@kernel.org>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Squashfs: Directly decompress into the page cache
 for file data (V3)
Message-ID: <20131119081719.GX4407@bbox>
References: <1384406059-28567-1-git-send-email-phillip@squashfs.org.uk>
 <1384406059-28567-4-git-send-email-phillip@squashfs.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384406059-28567-4-git-send-email-phillip@squashfs.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 05:14:18AM +0000, Phillip Lougher wrote:
> This introduces an implementation of squashfs_readpage_block()
> that directly decompresses into the page cache.
> 
> This uses the previously added page handler abstraction to push
> down the necessary kmap_atomic/kunmap_atomic operations on the
> page cache buffers into the decompressors.  This enables
> direct copying into the page cache without using the slow
> kmap/kunmap calls.
> 
> The code detects when multiple threads are racing in
> squashfs_readpage() to decompress the same block, and avoids
> this regression by falling back to using an intermediate
> buffer.
> 
> This patch enhances the performance of Squashfs significantly
> when multiple processes are accessing the filesystem simultaneously
> because it not only reduces memcopying, but it more importantly
> eliminates the lock contention on the intermediate buffer.
> 
> Using single-thread decompression.
> 
>         dd if=file1 of=/dev/null bs=4096 &
>         dd if=file2 of=/dev/null bs=4096 &
>         dd if=file3 of=/dev/null bs=4096 &
>         dd if=file4 of=/dev/null bs=4096
> 
> Before:
> 
> 629145600 bytes (629 MB) copied, 45.8046 s, 13.7 MB/s
> 
> After:
> 
> 629145600 bytes (629 MB) copied, 9.29414 s, 67.7 MB/s
> 
> V3:
>   * Kconfig: fix mempcpy typo
>   * squashfs_readpage_block(): Do not zero pages on decompress error
>   * squashfs_read_cache(): free page in caller not here
>   * page_actor.c: add comment regarding sleeping
>   * page_actor.c: optimise code slightly
> 
> Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reviewed-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
