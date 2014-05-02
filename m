Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbaEBVIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 17:08:20 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:46599 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaEBVIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 17:08:18 -0400
Date: Fri, 2 May 2014 23:08:13 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140502210813.GB32527@tucsk.piliscsaba.szeredi.hu>
References: <20140429191015.GK18016@ZenIV.linux.org.uk>
 <20140429211851.GA32204@dastard>
 <20140429214842.GL18016@ZenIV.linux.org.uk>
 <CA+55aFwcWcyRpwv3us9BbnsjUEfEr1mRjz4RWbcy_tSnZjc_Sw@mail.gmail.com>
 <20140429232013.GM18016@ZenIV.linux.org.uk>
 <20140430023142.GN18016@ZenIV.linux.org.uk>
 <CA+55aFypNxsjJTq_rc2Jx4p_3scJo2VWdt=e8n-9eJ-ZQphnpQ@mail.gmail.com>
 <20140430091515.GB3113@tucsk.piliscsaba.szeredi.hu>
 <20140502055127.GH18016@ZenIV.linux.org.uk>
 <CAELBmZC9g91+8B6HsnbmwWJBmiYXgMW6QfdREJYyd8EP5RpRpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAELBmZC9g91+8B6HsnbmwWJBmiYXgMW6QfdREJYyd8EP5RpRpQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's more of the "delete from shrink list not owned by us" in select parent.
Proposed patch appended.

And I'm not sure what umount_collect() is supposed to do.  Can other shrinkers
still be active at that point?  That would present other problems, no?

Also somewhat related is the question: how check_submounts_and_drop() could be
guaranteed correctness (timely removal of all unsed dentries) in the presence of
other shrinkers?

Thanks,
Miklos
----


From: Miklos Szeredi <mszeredi@suse.cz>
Subject: dcache: select_collect(): don't remove from shrink list

Shrink lists are not protected by any lock, so don't remove from an unknown
one.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/dcache.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1241,18 +1241,19 @@ static enum d_walk_ret select_collect(vo
 	 * loop in shrink_dcache_parent() might not make any progress
 	 * and loop forever.
 	 */
-	if (dentry->d_lockref.count) {
-		dentry_lru_del(dentry);
-	} else if (!(dentry->d_flags & DCACHE_SHRINK_LIST)) {
-		/*
-		 * We can't use d_lru_shrink_move() because we
-		 * need to get the global LRU lock and do the
-		 * LRU accounting.
-		 */
+	if (dentry->d_flags & (DCACHE_SHRINK_LIST | DCACHE_LRU_LIST) ==
+							DCACHE_LRU_LIST) {
 		d_lru_del(dentry);
-		d_shrink_add(dentry, &data->dispose);
-		data->found++;
-		ret = D_WALK_NORETRY;
+		if (!dentry->d_lockref.count) {
+			/*
+			 * We can't use d_lru_shrink_move() because we
+			 * need to get the global LRU lock and do the
+			 * LRU accounting.
+			 */
+			d_shrink_add(dentry, &data->dispose);
+			data->found++;
+			ret = D_WALK_NORETRY;
+		}
 	}
 	/*
 	 * We can return to the caller if we have found some (this
