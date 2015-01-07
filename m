Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793AbbAGCSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:18:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757714AbbAGCSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:18:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.17 70/73] Btrfs: do not move em to modified list when unpinning
Date: Tue,  6 Jan 2015 18:16:31 -0800
Message-Id: <20150107021559.659821277@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107021557.521276020@linuxfoundation.org>
References: <20150107021557.521276020@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fb.com>

commit a28046956c71985046474283fa3bcd256915fb72 upstream.

We use the modified list to keep track of which extents have been modified so we
know which ones are candidates for logging at fsync() time.  Newly modified
extents are added to the list at modification time, around the same time the
ordered extent is created.  We do this so that we don't have to wait for ordered
extents to complete before we know what we need to log.  The problem is when
something like this happens

log extent 0-4k on inode 1
copy csum for 0-4k from ordered extent into log
sync log
commit transaction
log some other extent on inode 1
ordered extent for 0-4k completes and adds itself onto modified list again
log changed extents
see ordered extent for 0-4k has already been logged
	at this point we assume the csum has been copied
sync log
crash

On replay we will see the extent 0-4k in the log, drop the original 0-4k extent
which is the same one that we are replaying which also drops the csum, and then
we won't find the csum in the log for that bytenr.  This of course causes us to
have errors about not having csums for certain ranges of our inode.  So remove
the modified list manipulation in unpin_extent_cache, any modified extents
should have been added well before now, and we don't want them re-logged.  This
fixes my test that I could reliably reproduce this problem with.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent_map.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -287,8 +287,6 @@ int unpin_extent_cache(struct extent_map
 	if (!em)
 		goto out;
 
-	if (!test_bit(EXTENT_FLAG_LOGGING, &em->flags))
-		list_move(&em->list, &tree->modified_extents);
 	em->generation = gen;
 	clear_bit(EXTENT_FLAG_PINNED, &em->flags);
 	em->mod_start = em->start;


