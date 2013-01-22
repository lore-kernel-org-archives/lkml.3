Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab3AVKEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 05:04:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855Ab3AVKEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 05:04:49 -0500
Date: Tue, 22 Jan 2013 11:04:47 +0100
From: Jan Kara <jack@suse.cz>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Bonggil Bak <bgbak@samsung.com>
Subject: Re: [PATCH] udf: add extent cache support in case of file reading
Message-ID: <20130122100447.GA31140@quack.suse.cz>
References: <1358561834-8108-1-git-send-email-linkinjeon@gmail.com>
 <20130121110442.GF5588@quack.suse.cz>
 <CAKYAXd-_chC9zFtC7A=puo9AgQSAD5JbkF=y=ZYP5vS7bO7-dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <CAKYAXd-_chC9zFtC7A=puo9AgQSAD5JbkF=y=ZYP5vS7bO7-dg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 22-01-13 09:45:09, Namjae Jeon wrote:
> 2013/1/21, Jan Kara <jack@suse.cz>:
> > @@ -2222,6 +2219,8 @@ int udf_read_extent_cache(struct inode *inode, loff_t
> > bcount,
> >  		*lbcount = iinfo->cached_extent.lstart;
> >  		memcpy(pos, &iinfo->cached_extent.epos,
> >  		       sizeof(struct extent_position));
> > +		if (pos->bh)
> > +			get_bh(pos->bh);
> >  		spin_unlock(&iinfo->i_extent_cache_lock);
> >  		return 1;
> >  	} else
> >   This is the most important - we should give buffer reference to pos->bh.
> > Caller will eventually free it right?
> This change is not required as we give buffer reference to pos->bh at
> the time of cache update.
> When we start reading a file, first we try to read the cache which
> will lead to cache miss.
> So, we would really access the pos->bh in udf_update_extent_cache for
> the first time, and this is where the buffer reference is incremented.
> Calling get_bh at 2 places will eventually lead to mem leak.
> Let me know your opinion.
  Yes, udf_update_extent_cache() gets its own reference to bh but that is
dropped in udf_clear_extent_cache(). So I think udf_read_extent_cache()
needs to get a reference to the caller (as the caller will eventually free
the bh via brelse(epos.bh) e.g. in udf_extend_file(). Also I realized
udf_update_extent_cache() needs to first clear the cache if it is valid.
Otherwise it just overwrites bh pointer and reference is leaked. Is it
clearer now?

  I've also changed locking of udf_clear_extent_cache() so that
i_extent_cache_lock is always taken for that function - it makes the
locking rules obvious at the first sight.

  Attached is the patch I currently carry.

								Honza
  
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--C7zPtVaVf+AK4Oqc
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-udf-add-extent-cache-support-in-case-of-file-reading.patch"

>From 99600051b04bc4ec8bd4d16a8bf993ca54042db6 Mon Sep 17 00:00:00 2001
From: Namjae Jeon <namjae.jeon@samsung.com>
Date: Sat, 19 Jan 2013 11:17:14 +0900
Subject: [PATCH] udf: add extent cache support in case of file reading

This patch implements extent caching in case of file reading.
While reading a file, currently, UDF reads metadata serially
which takes a lot of time depending on the number of extents present
in the file. Caching last accessd extent improves metadata read time.
Instead of reading file metadata from start, now we read from
the cached extent.

This patch considerably improves the time spent by CPU in kernel mode.
For example, while reading a 10.9 GB file using dd:
Time before applying patch:
11677022208 bytes (10.9GB) copied, 1529.748921 seconds, 7.3MB/s
real    25m 29.85s
user    0m 12.41s
sys     15m 34.75s

Time after applying patch:
11677022208 bytes (10.9GB) copied, 1469.338231 seconds, 7.6MB/s
real    24m 29.44s
user    0m 15.73s
sys     3m 27.61s

[JK: Fix bh refcounting issues, simplify initialization]

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Signed-off-by: Bonggil Bak <bgbak@samsung.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c   |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 fs/udf/super.c   |    2 +
 fs/udf/udf_i.h   |   16 ++++++++++
 fs/udf/udfdecl.h |    5 ---
 4 files changed, 98 insertions(+), 11 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index cbae1ed..7a12e48 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -67,6 +67,74 @@ static void udf_update_extents(struct inode *,
 			       struct extent_position *);
 static int udf_get_block(struct inode *, sector_t, struct buffer_head *, int);
 
+static void __udf_clear_extent_cache(struct inode *inode)
+{
+	struct udf_inode_info *iinfo = UDF_I(inode);
+
+	if (iinfo->cached_extent.lstart != -1) {
+		brelse(iinfo->cached_extent.epos.bh);
+		iinfo->cached_extent.lstart = -1;
+	}
+}
+
+/* Invalidate extent cache */
+static void udf_clear_extent_cache(struct inode *inode)
+{
+	struct udf_inode_info *iinfo = UDF_I(inode);
+
+	spin_lock(&iinfo->i_extent_cache_lock);
+	__udf_clear_extent_cache(inode);
+	spin_unlock(&iinfo->i_extent_cache_lock);
+}
+
+/* Return contents of extent cache */
+static int udf_read_extent_cache(struct inode *inode, loff_t bcount,
+				 loff_t *lbcount, struct extent_position *pos)
+{
+	struct udf_inode_info *iinfo = UDF_I(inode);
+	int ret = 0;
+
+	spin_lock(&iinfo->i_extent_cache_lock);
+	if ((iinfo->cached_extent.lstart <= bcount) &&
+	    (iinfo->cached_extent.lstart != -1)) {
+		/* Cache hit */
+		*lbcount = iinfo->cached_extent.lstart;
+		memcpy(pos, &iinfo->cached_extent.epos,
+		       sizeof(struct extent_position));
+		if (pos->bh)
+			get_bh(pos->bh);
+		ret = 1;
+	}
+	spin_unlock(&iinfo->i_extent_cache_lock);
+	return ret;
+}
+
+/* Add extent to extent cache */
+static void udf_update_extent_cache(struct inode *inode, loff_t estart,
+				    struct extent_position *pos, int next_epos)
+{
+	struct udf_inode_info *iinfo = UDF_I(inode);
+
+	spin_lock(&iinfo->i_extent_cache_lock);
+	/* Invalidate previously cached extent */
+	__udf_clear_extent_cache(inode);
+	if (pos->bh)
+		get_bh(pos->bh);
+	memcpy(&iinfo->cached_extent.epos, pos,
+	       sizeof(struct extent_position));
+	iinfo->cached_extent.lstart = estart;
+	if (next_epos)
+		switch (iinfo->i_alloc_type) {
+		case ICBTAG_FLAG_AD_SHORT:
+			iinfo->cached_extent.epos.offset -=
+			sizeof(struct short_ad);
+			break;
+		case ICBTAG_FLAG_AD_LONG:
+			iinfo->cached_extent.epos.offset -=
+			sizeof(struct long_ad);
+		}
+	spin_unlock(&iinfo->i_extent_cache_lock);
+}
 
 void udf_evict_inode(struct inode *inode)
 {
@@ -90,6 +158,7 @@ void udf_evict_inode(struct inode *inode)
 	}
 	kfree(iinfo->i_ext.i_data);
 	iinfo->i_ext.i_data = NULL;
+	udf_clear_extent_cache(inode);
 	if (want_delete) {
 		udf_free_inode(inode);
 	}
@@ -105,6 +174,7 @@ static void udf_write_failed(struct address_space *mapping, loff_t to)
 		truncate_pagecache(inode, to, isize);
 		if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB) {
 			down_write(&iinfo->i_data_sem);
+			udf_clear_extent_cache(inode);
 			udf_truncate_extents(inode);
 			up_write(&iinfo->i_data_sem);
 		}
@@ -372,7 +442,7 @@ static int udf_get_block(struct inode *inode, sector_t block,
 		iinfo->i_next_alloc_goal++;
 	}
 
-
+	udf_clear_extent_cache(inode);
 	phys = inode_getblk(inode, block, &err, &new);
 	if (!phys)
 		goto abort;
@@ -1171,6 +1241,7 @@ set_size:
 	} else {
 		if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 			down_write(&iinfo->i_data_sem);
+			udf_clear_extent_cache(inode);
 			memset(iinfo->i_ext.i_data + iinfo->i_lenEAttr + newsize,
 			       0x00, bsize - newsize -
 			       udf_file_entry_alloc_offset(inode));
@@ -1184,6 +1255,7 @@ set_size:
 		if (err)
 			return err;
 		down_write(&iinfo->i_data_sem);
+		udf_clear_extent_cache(inode);
 		truncate_setsize(inode, newsize);
 		udf_truncate_extents(inode);
 		up_write(&iinfo->i_data_sem);
@@ -2156,11 +2228,12 @@ int8_t inode_bmap(struct inode *inode, sector_t block,
 	struct udf_inode_info *iinfo;
 
 	iinfo = UDF_I(inode);
-	pos->offset = 0;
-	pos->block = iinfo->i_location;
-	pos->bh = NULL;
+	if (!udf_read_extent_cache(inode, bcount, &lbcount, pos)) {
+		pos->offset = 0;
+		pos->block = iinfo->i_location;
+		pos->bh = NULL;
+	}
 	*elen = 0;
-
 	do {
 		etype = udf_next_aext(inode, pos, eloc, elen, 1);
 		if (etype == -1) {
@@ -2170,7 +2243,8 @@ int8_t inode_bmap(struct inode *inode, sector_t block,
 		}
 		lbcount += *elen;
 	} while (lbcount <= bcount);
-
+	/* update extent cache */
+	udf_update_extent_cache(inode, lbcount - *elen, pos, 1);
 	*offset = (bcount + *elen - lbcount) >> blocksize_bits;
 
 	return etype;
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 186adbf..da8ce9f 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -134,6 +134,8 @@ static struct inode *udf_alloc_inode(struct super_block *sb)
 	ei->i_next_alloc_goal = 0;
 	ei->i_strat4096 = 0;
 	init_rwsem(&ei->i_data_sem);
+	ei->cached_extent.lstart = -1;
+	spin_lock_init(&ei->i_extent_cache_lock);
 
 	return &ei->vfs_inode;
 }
diff --git a/fs/udf/udf_i.h b/fs/udf/udf_i.h
index bb8309d..b5cd8ed 100644
--- a/fs/udf/udf_i.h
+++ b/fs/udf/udf_i.h
@@ -1,6 +1,19 @@
 #ifndef _UDF_I_H
 #define _UDF_I_H
 
+struct extent_position {
+	struct buffer_head *bh;
+	uint32_t offset;
+	struct kernel_lb_addr block;
+};
+
+struct udf_ext_cache {
+	/* Extent position */
+	struct extent_position epos;
+	/* Start logical offset in bytes */
+	loff_t lstart;
+};
+
 /*
  * The i_data_sem and i_mutex serve for protection of allocation information
  * of a regular files and symlinks. This includes all extents belonging to
@@ -35,6 +48,9 @@ struct udf_inode_info {
 		__u8		*i_data;
 	} i_ext;
 	struct rw_semaphore	i_data_sem;
+	struct udf_ext_cache cached_extent;
+	/* Spinlock for protecting extent cache */
+	spinlock_t i_extent_cache_lock;
 	struct inode vfs_inode;
 };
 
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index de038da..be7dabb 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -113,11 +113,6 @@ struct ustr {
 	uint8_t u_len;
 };
 
-struct extent_position {
-	struct buffer_head *bh;
-	uint32_t offset;
-	struct kernel_lb_addr block;
-};
 
 /* super.c */
 
-- 
1.7.1


--C7zPtVaVf+AK4Oqc--
