Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933634Ab3AOWwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:52:20 -0500
Received: from mail.kernel.org ([198.145.19.201]:46716 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933617Ab3AOWwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:52:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 109/171] GFS2: Test bufdata with buffer locked and gfs2_log_lock held
Date: Tue, 15 Jan 2013 14:44:34 -0800
Message-Id: <20130115224321.245102503@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Marzinski <bmarzins@redhat.com>

commit 96e5d1d3adf56f1c7eeb07258f6a1a0a7ae9c489 upstream.

In gfs2_trans_add_bh(), gfs2 was testing if a there was a bd attached to the
buffer without having the gfs2_log_lock held. It was then assuming it would
stay attached for the rest of the function. However, without either the log
lock being held of the buffer locked, __gfs2_ail_flush() could detach bd at any
time.  This patch moves the locking before the test.  If there isn't a bd
already attached, gfs2 can safely allocate one and attach it before locking.
There is no way that the newly allocated bd could be on the ail list,
and thus no way for __gfs2_ail_flush() to detach it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/lops.c  |   18 ++++--------------
 fs/gfs2/trans.c |    8 ++++++++
 2 files changed, 12 insertions(+), 14 deletions(-)

--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -258,16 +258,14 @@ static void buf_lo_add(struct gfs2_sbd *
 	struct gfs2_meta_header *mh;
 	struct gfs2_trans *tr;
 
-	lock_buffer(bd->bd_bh);
-	gfs2_log_lock(sdp);
 	if (!list_empty(&bd->bd_list_tr))
-		goto out;
+		return;
 	tr = current->journal_info;
 	tr->tr_touched = 1;
 	tr->tr_num_buf++;
 	list_add(&bd->bd_list_tr, &tr->tr_list_buf);
 	if (!list_empty(&le->le_list))
-		goto out;
+		return;
 	set_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
 	set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
 	gfs2_meta_check(sdp, bd->bd_bh);
@@ -278,9 +276,6 @@ static void buf_lo_add(struct gfs2_sbd *
 	sdp->sd_log_num_buf++;
 	list_add(&le->le_list, &sdp->sd_log_le_buf);
 	tr->tr_num_buf_new++;
-out:
-	gfs2_log_unlock(sdp);
-	unlock_buffer(bd->bd_bh);
 }
 
 static void buf_lo_before_commit(struct gfs2_sbd *sdp)
@@ -611,11 +606,9 @@ static void databuf_lo_add(struct gfs2_s
 	struct address_space *mapping = bd->bd_bh->b_page->mapping;
 	struct gfs2_inode *ip = GFS2_I(mapping->host);
 
-	lock_buffer(bd->bd_bh);
-	gfs2_log_lock(sdp);
 	if (tr) {
 		if (!list_empty(&bd->bd_list_tr))
-			goto out;
+			return;
 		tr->tr_touched = 1;
 		if (gfs2_is_jdata(ip)) {
 			tr->tr_num_buf++;
@@ -623,7 +616,7 @@ static void databuf_lo_add(struct gfs2_s
 		}
 	}
 	if (!list_empty(&le->le_list))
-		goto out;
+		return;
 
 	set_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
 	set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
@@ -635,9 +628,6 @@ static void databuf_lo_add(struct gfs2_s
 	} else {
 		list_add_tail(&le->le_list, &sdp->sd_log_le_ordered);
 	}
-out:
-	gfs2_log_unlock(sdp);
-	unlock_buffer(bd->bd_bh);
 }
 
 static void gfs2_check_magic(struct buffer_head *bh)
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -145,14 +145,22 @@ void gfs2_trans_add_bh(struct gfs2_glock
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	struct gfs2_bufdata *bd;
 
+	lock_buffer(bh);
+	gfs2_log_lock(sdp);
 	bd = bh->b_private;
 	if (bd)
 		gfs2_assert(sdp, bd->bd_gl == gl);
 	else {
+		gfs2_log_unlock(sdp);
+		unlock_buffer(bh);
 		gfs2_attach_bufdata(gl, bh, meta);
 		bd = bh->b_private;
+		lock_buffer(bh);
+		gfs2_log_lock(sdp);
 	}
 	lops_add(sdp, &bd->bd_le);
+	gfs2_log_unlock(sdp);
+	unlock_buffer(bh);
 }
 
 void gfs2_trans_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)


