Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933748AbaICWKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:10:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45652 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933684AbaICWIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:08:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Liu Bo <bo.li.liu@oracle.com>,
        Martin Steigerwald <martin@lichtvoll.de>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.14 64/88] Btrfs: fix compressed write corruption on enospc
Date: Wed,  3 Sep 2014 15:05:38 -0700
Message-Id: <20140903220517.872923762@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220515.958924632@linuxfoundation.org>
References: <20140903220515.958924632@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Bo <bo.li.liu@oracle.com>

commit ce62003f690dff38d3164a632ec69efa15c32cbf upstream.

When failing to allocate space for the whole compressed extent, we'll
fallback to uncompressed IO, but we've forgotten to redirty the pages
which belong to this compressed extent, and these 'clean' pages will
simply skip 'submit' part and go to endio directly, at last we got data
corruption as we write nothing.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Tested-By: Martin Steigerwald <martin@lichtvoll.de>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -701,6 +701,18 @@ retry:
 				unlock_extent(io_tree, async_extent->start,
 					      async_extent->start +
 					      async_extent->ram_size - 1);
+
+				/*
+				 * we need to redirty the pages if we decide to
+				 * fallback to uncompressed IO, otherwise we
+				 * will not submit these pages down to lower
+				 * layers.
+				 */
+				extent_range_redirty_for_io(inode,
+						async_extent->start,
+						async_extent->start +
+						async_extent->ram_size - 1);
+
 				goto retry;
 			}
 			goto out_free;


