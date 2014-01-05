Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaAEUjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 15:39:39 -0500
Received: from fieldses.org ([174.143.236.118]:52440 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbaAEUjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 15:39:35 -0500
Date: Sun, 5 Jan 2014 15:39:34 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: Re: [PATCH v3 1/6] locks: consolidate common code in the
 flock_to_posix_lock routines
Message-ID: <20140105203934.GD22918@fieldses.org>
References: <1386703055-22308-1-git-send-email-jlayton@redhat.com>
 <1386703055-22308-2-git-send-email-jlayton@redhat.com>
 <20131210212253.GC20831@fieldses.org>
 <20131210232204.GD20831@fieldses.org>
 <20131211061856.615c39ba@tlielax.poochiereds.net>
 <20131211143724.GA29300@fieldses.org>
 <20131211151931.GC29300@fieldses.org>
 <20131211140741.292028e8@tlielax.poochiereds.net>
 <20131211225616.GA3483@fieldses.org>
 <20131212054406.4360d79e@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212054406.4360d79e@tlielax.poochiereds.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ugh, I screwed up one more when rewriting flock{64}_to_posix_lock, an
off-by-one error caused by not noticing that the "end" offset of a lock
is at start + len - 1, not start + len. 

(So for example, a 1-byte lock starting at offset 5 is recorded as
(fl_start, fl_end) == (5, 5), not (5,6)....)

This actually causes "cthon -l" fails as it attempts a lock with
(start, len) == (1, OFFSET_MAX).

--b.

diff --git a/fs/locks.c b/fs/locks.c
index 9523b89..f017280 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -365,16 +365,17 @@ static int flock64_to_posix_lock(struct file *filp, struct file_lock *fl,
 	fl->fl_start += l->l_start;
 	if (fl->fl_start < 0)
 		return -EINVAL;
-	if (l->l_len > 0 && l->l_len - 1 > OFFSET_MAX - fl->fl_start)
-		return -EOVERFLOW;
-	if (fl->fl_start + l->l_len < 0)
-		return -EINVAL;
 
 	/* POSIX-1996 leaves the case l->l_len < 0 undefined;
 	   POSIX-2001 defines it. */
-	if (l->l_len > 0)
+	if (l->l_len > 0) {
+		if (l->l_len - 1 > OFFSET_MAX - fl->fl_start)
+			return -EOVERFLOW;
 		fl->fl_end = fl->fl_start + l->l_len - 1;
-	else if (l->l_len < 0) {
+
+	} else if (l->l_len < 0) {
+		if (fl->fl_start + l->l_len < 0)
+			return -EINVAL;
 		fl->fl_end = fl->fl_start - 1;
 		fl->fl_start += l->l_len;
 	} else
