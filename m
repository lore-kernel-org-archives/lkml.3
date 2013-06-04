Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368Ab3FDFWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 01:22:46 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60430 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751498Ab3FDFWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 01:22:38 -0400
From: Joe Perches <joe@perches.com>
To: Dave Kleikamp <shaggy@kernel.org>
Cc: jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] jfs: Convert jfs_error to jfs_sb_err
Date: Mon,  3 Jun 2013 22:22:35 -0700
Message-Id: <76a131f2845ec3f75dd80be6808e513ae3ea4255.1370323137.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a more current logging style.

Rename function jfs_error to jfs_sb_err.
Add __printf format and argument verification.

Remove embedded function names from formats.
Add %pf, __builtin_return_address(0) to jfs_sb_err.
Add newlines to formats for kernel style consistency.
(One format already had an erroneous newline)
Coalesce formats and align arguments.

Object size reduced ~1KiB.

$ size fs/jfs/built-in.o*
   text	   data	    bss	    dec	    hex	filename
 201891	  35488	  63936	 301315	  49903	fs/jfs/built-in.o.new
 202821	  35488	  64192	 302501	  49da5	fs/jfs/built-in.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/jfs/jfs_dmap.c       | 94 ++++++++++++++++++++-----------------------------
 fs/jfs/jfs_dtree.c      | 45 ++++++++++++-----------
 fs/jfs/jfs_extent.c     |  2 +-
 fs/jfs/jfs_imap.c       | 89 +++++++++++++++++++++-------------------------
 fs/jfs/jfs_metapage.c   |  9 +++--
 fs/jfs/jfs_superblock.h |  3 +-
 fs/jfs/jfs_txnmgr.c     |  2 +-
 fs/jfs/jfs_xtree.c      | 64 ++++++++++++++++-----------------
 fs/jfs/namei.c          |  4 +--
 fs/jfs/resize.c         |  2 +-
 fs/jfs/super.c          | 22 +++++++-----
 fs/jfs/xattr.c          |  4 +--
 12 files changed, 158 insertions(+), 182 deletions(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 9a55f53..7eafc30 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -346,8 +346,7 @@ int dbFree(struct inode *ip, s64 blkno, s64 nblocks)
 		printk(KERN_ERR "blkno = %Lx, nblocks = %Lx\n",
 		       (unsigned long long) blkno,
 		       (unsigned long long) nblocks);
-		jfs_error(ip->i_sb,
-			  "dbFree: block to be freed is outside the map");
+		jfs_sb_err(ip->i_sb, "block to be freed is outside the map\n");
 		return -EIO;
 	}
 
@@ -384,7 +383,7 @@ int dbFree(struct inode *ip, s64 blkno, s64 nblocks)
 
 		/* free the blocks. */
 		if ((rc = dbFreeDmap(bmp, dp, blkno, nb))) {
-			jfs_error(ip->i_sb, "dbFree: error in block map\n");
+			jfs_sb_err(ip->i_sb, "error in block map\n");
 			release_metapage(mp);
 			IREAD_UNLOCK(ipbmap);
 			return (rc);
@@ -441,8 +440,7 @@ dbUpdatePMap(struct inode *ipbmap,
 		printk(KERN_ERR "blkno = %Lx, nblocks = %Lx\n",
 		       (unsigned long long) blkno,
 		       (unsigned long long) nblocks);
-		jfs_error(ipbmap->i_sb,
-			  "dbUpdatePMap: blocks are outside the map");
+		jfs_sb_err(ipbmap->i_sb, "blocks are outside the map\n");
 		return -EIO;
 	}
 
@@ -726,7 +724,7 @@ int dbAlloc(struct inode *ip, s64 hint, s64 nblocks, s64 * results)
 
 	/* the hint should be within the map */
 	if (hint >= mapSize) {
-		jfs_error(ip->i_sb, "dbAlloc: the hint is outside the map");
+		jfs_sb_err(ip->i_sb, "the hint is outside the map\n");
 		return -EIO;
 	}
 
@@ -1057,8 +1055,7 @@ static int dbExtend(struct inode *ip, s64 blkno, s64 nblocks, s64 addnblocks)
 	bmp = sbi->bmap;
 	if (lastblkno < 0 || lastblkno >= bmp->db_mapsize) {
 		IREAD_UNLOCK(ipbmap);
-		jfs_error(ip->i_sb,
-			  "dbExtend: the block is outside the filesystem");
+		jfs_sb_err(ip->i_sb, "the block is outside the filesystem\n");
 		return -EIO;
 	}
 
@@ -1134,8 +1131,7 @@ static int dbAllocNext(struct bmap * bmp, struct dmap * dp, s64 blkno,
 	u32 mask;
 
 	if (dp->tree.leafidx != cpu_to_le32(LEAFIND)) {
-		jfs_error(bmp->db_ipbmap->i_sb,
-			  "dbAllocNext: Corrupt dmap page");
+		jfs_sb_err(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
 		return -EIO;
 	}
 
@@ -1265,8 +1261,7 @@ dbAllocNear(struct bmap * bmp,
 	s8 *leaf;
 
 	if (dp->tree.leafidx != cpu_to_le32(LEAFIND)) {
-		jfs_error(bmp->db_ipbmap->i_sb,
-			  "dbAllocNear: Corrupt dmap page");
+		jfs_sb_err(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
 		return -EIO;
 	}
 
@@ -1380,9 +1375,8 @@ dbAllocAG(struct bmap * bmp, int agno, s64 nblocks, int l2nb, s64 * results)
 	 * allocation group size.
 	 */
 	if (l2nb > bmp->db_agl2size) {
-		jfs_error(bmp->db_ipbmap->i_sb,
-			  "dbAllocAG: allocation request is larger than the "
-			  "allocation group size");
+		jfs_sb_err(bmp->db_ipbmap->i_sb,
+			   "allocation request is larger than the allocation group size\n");
 		return -EIO;
 	}
 
@@ -1416,8 +1410,8 @@ dbAllocAG(struct bmap * bmp, int agno, s64 nblocks, int l2nb, s64 * results)
 			printk(KERN_ERR "blkno = %Lx, blocks = %Lx\n",
 			       (unsigned long long) blkno,
 			       (unsigned long long) nblocks);
-			jfs_error(bmp->db_ipbmap->i_sb,
-				  "dbAllocAG: dbAllocCtl failed in free AG");
+			jfs_sb_err(bmp->db_ipbmap->i_sb,
+				   "dbAllocCtl failed in free AG\n");
 		}
 		return (rc);
 	}
@@ -1433,8 +1427,7 @@ dbAllocAG(struct bmap * bmp, int agno, s64 nblocks, int l2nb, s64 * results)
 	budmin = dcp->budmin;
 
 	if (dcp->leafidx != cpu_to_le32(CTLLEAFIND)) {
-		jfs_error(bmp->db_ipbmap->i_sb,
-			  "dbAllocAG: Corrupt dmapctl page");
+		jfs_sb_err(bmp->db_ipbmap->i_sb, "Corrupt dmapctl page\n");
 		release_metapage(mp);
 		return -EIO;
 	}
@@ -1474,8 +1467,8 @@ dbAllocAG(struct bmap * bmp, int agno, s64 nblocks, int l2nb, s64 * results)
 				}
 			}
 			if (n == 4) {
-				jfs_error(bmp->db_ipbmap->i_sb,
-					  "dbAllocAG: failed descending stree");
+				jfs_sb_err(bmp->db_ipbmap->i_sb,
+					   "failed descending stree\n");
 				release_metapage(mp);
 				return -EIO;
 			}
@@ -1514,9 +1507,8 @@ dbAllocAG(struct bmap * bmp, int agno, s64 nblocks, int l2nb, s64 * results)
 			     dbFindCtl(bmp, l2nb, bmp->db_aglevel - 1,
 				       &blkno))) {
 				if (rc == -ENOSPC) {
-					jfs_error(bmp->db_ipbmap->i_sb,
-						  "dbAllocAG: control page "
-						  "inconsistent");
+					jfs_sb_err(bmp->db_ipbmap->i_sb,
+						   "control page inconsistent\n");
 					return -EIO;
 				}
 				return (rc);
@@ -1527,8 +1519,8 @@ dbAllocAG(struct bmap * bmp, int agno, s64 nblocks, int l2nb, s64 * results)
 		 */
 		rc = dbAllocCtl(bmp, nblocks, l2nb, blkno, results);
 		if (rc == -ENOSPC) {
-			jfs_error(bmp->db_ipbmap->i_sb,
-				  "dbAllocAG: unable to allocate blocks");
+			jfs_sb_err(bmp->db_ipbmap->i_sb,
+				   "unable to allocate blocks\n");
 			rc = -EIO;
 		}
 		return (rc);
@@ -1587,8 +1579,7 @@ static int dbAllocAny(struct bmap * bmp, s64 nblocks, int l2nb, s64 * results)
 	 */
 	rc = dbAllocCtl(bmp, nblocks, l2nb, blkno, results);
 	if (rc == -ENOSPC) {
-		jfs_error(bmp->db_ipbmap->i_sb,
-			  "dbAllocAny: unable to allocate blocks");
+		jfs_sb_err(bmp->db_ipbmap->i_sb, "unable to allocate blocks\n");
 		return -EIO;
 	}
 	return (rc);
@@ -1652,8 +1643,7 @@ s64 dbDiscardAG(struct inode *ip, int agno, s64 minlen)
 	range_cnt = min_t(u64, max_ranges + 1, 32 * 1024);
 	totrim = kmalloc(sizeof(struct range2trim) * range_cnt, GFP_NOFS);
 	if (totrim == NULL) {
-		jfs_error(bmp->db_ipbmap->i_sb,
-			  "dbDiscardAG: no memory for trim array");
+		jfs_sb_err(bmp->db_ipbmap->i_sb, "no memory for trim array\n");
 		IWRITE_UNLOCK(ipbmap);
 		return 0;
 	}
@@ -1682,8 +1672,7 @@ s64 dbDiscardAG(struct inode *ip, int agno, s64 minlen)
 			nblocks = 1 << l2nb;
 		} else {
 			/* Trim any already allocated blocks */
-			jfs_error(bmp->db_ipbmap->i_sb,
-				"dbDiscardAG: -EIO");
+			jfs_sb_err(bmp->db_ipbmap->i_sb, "-EIO\n");
 			break;
 		}
 
@@ -1760,8 +1749,8 @@ static int dbFindCtl(struct bmap * bmp, int l2nb, int level, s64 * blkno)
 		budmin = dcp->budmin;
 
 		if (dcp->leafidx != cpu_to_le32(CTLLEAFIND)) {
-			jfs_error(bmp->db_ipbmap->i_sb,
-				  "dbFindCtl: Corrupt dmapctl page");
+			jfs_sb_err(bmp->db_ipbmap->i_sb,
+				   "Corrupt dmapctl page\n");
 			release_metapage(mp);
 			return -EIO;
 		}
@@ -1781,8 +1770,8 @@ static int dbFindCtl(struct bmap * bmp, int l2nb, int level, s64 * blkno)
 		 */
 		if (rc) {
 			if (lev != level) {
-				jfs_error(bmp->db_ipbmap->i_sb,
-					  "dbFindCtl: dmap inconsistent");
+				jfs_sb_err(bmp->db_ipbmap->i_sb,
+					   "dmap inconsistent\n");
 				return -EIO;
 			}
 			return -ENOSPC;
@@ -1905,8 +1894,8 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 		 */
 		if (dp->tree.stree[ROOT] != L2BPERDMAP) {
 			release_metapage(mp);
-			jfs_error(bmp->db_ipbmap->i_sb,
-				  "dbAllocCtl: the dmap is not all free");
+			jfs_sb_err(bmp->db_ipbmap->i_sb,
+				   "the dmap is not all free\n");
 			rc = -EIO;
 			goto backout;
 		}
@@ -1952,8 +1941,8 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 			/* could not back out.  mark the file system
 			 * to indicate that we have leaked blocks.
 			 */
-			jfs_error(bmp->db_ipbmap->i_sb,
-				  "dbAllocCtl: I/O Error: Block Leakage.");
+			jfs_sb_err(bmp->db_ipbmap->i_sb,
+				   "I/O Error: Block Leakage\n");
 			continue;
 		}
 		dp = (struct dmap *) mp->data;
@@ -1965,8 +1954,7 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 			 * to indicate that we have leaked blocks.
 			 */
 			release_metapage(mp);
-			jfs_error(bmp->db_ipbmap->i_sb,
-				  "dbAllocCtl: Block Leakage.");
+			jfs_sb_err(bmp->db_ipbmap->i_sb, "Block Leakage\n");
 			continue;
 		}
 
@@ -2262,9 +2250,8 @@ static void dbAllocBits(struct bmap * bmp, struct dmap * dp, s64 blkno,
 			 */
 			for (; nwords > 0; nwords -= nw) {
 				if (leaf[word] < BUDMIN) {
-					jfs_error(bmp->db_ipbmap->i_sb,
-						  "dbAllocBits: leaf page "
-						  "corrupt");
+					jfs_sb_err(bmp->db_ipbmap->i_sb,
+						   "leaf page corrupt\n");
 					break;
 				}
 
@@ -2536,8 +2523,7 @@ dbAdjCtl(struct bmap * bmp, s64 blkno, int newval, int alloc, int level)
 	dcp = (struct dmapctl *) mp->data;
 
 	if (dcp->leafidx != cpu_to_le32(CTLLEAFIND)) {
-		jfs_error(bmp->db_ipbmap->i_sb,
-			  "dbAdjCtl: Corrupt dmapctl page");
+		jfs_sb_err(bmp->db_ipbmap->i_sb, "Corrupt dmapctl page\n");
 		release_metapage(mp);
 		return -EIO;
 	}
@@ -2637,9 +2623,8 @@ dbAdjCtl(struct bmap * bmp, s64 blkno, int newval, int alloc, int level)
 			 */
 			assert(level == bmp->db_maxlevel);
 			if (bmp->db_maxfreebud != oldroot) {
-				jfs_error(bmp->db_ipbmap->i_sb,
-					  "dbAdjCtl: the maximum free buddy is "
-					  "not the old root");
+				jfs_sb_err(bmp->db_ipbmap->i_sb,
+					   "the maximum free buddy is not the old root\n");
 			}
 			bmp->db_maxfreebud = dcp->stree[ROOT];
 		}
@@ -3481,7 +3466,7 @@ int dbExtendFS(struct inode *ipbmap, s64 blkno,	s64 nblocks)
 	p = BMAPBLKNO + nbperpage;	/* L2 page */
 	l2mp = read_metapage(ipbmap, p, PSIZE, 0);
 	if (!l2mp) {
-		jfs_error(ipbmap->i_sb, "dbExtendFS: L2 page could not be read");
+		jfs_sb_err(ipbmap->i_sb, "L2 page could not be read\n");
 		return -EIO;
 	}
 	l2dcp = (struct dmapctl *) l2mp->data;
@@ -3646,8 +3631,7 @@ int dbExtendFS(struct inode *ipbmap, s64 blkno,	s64 nblocks)
 		}
 	}			/* for each L1 in a L2 */
 
-	jfs_error(ipbmap->i_sb,
-		  "dbExtendFS: function has not returned as expected");
+	jfs_sb_err(ipbmap->i_sb, "function has not returned as expected\n");
 errout:
 	if (l0mp)
 		release_metapage(l0mp);
@@ -3716,8 +3700,8 @@ void dbFinalizeBmap(struct inode *ipbmap)
 				break;
 		}
 		if (bmp->db_agpref >= bmp->db_numag) {
-			jfs_error(ipbmap->i_sb,
-				  "cannot find ag with average freespace");
+			jfs_sb_err(ipbmap->i_sb,
+				   "cannot find ag with average freespace\n");
 		}
 	}
 
diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index 0ddbece..63797e7 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -124,21 +124,21 @@ struct dtsplit {
 #define DT_PAGE(IP, MP) BT_PAGE(IP, MP, dtpage_t, i_dtroot)
 
 /* get page buffer for specified block address */
-#define DT_GETPAGE(IP, BN, MP, SIZE, P, RC)\
-{\
-	BT_GETPAGE(IP, BN, MP, dtpage_t, SIZE, P, RC, i_dtroot)\
-	if (!(RC))\
-	{\
-		if (((P)->header.nextindex > (((BN)==0)?DTROOTMAXSLOT:(P)->header.maxslot)) ||\
-		    ((BN) && ((P)->header.maxslot > DTPAGEMAXSLOT)))\
-		{\
-			BT_PUTPAGE(MP);\
-			jfs_error((IP)->i_sb, "DT_GETPAGE: dtree page corrupt");\
-			MP = NULL;\
-			RC = -EIO;\
-		}\
-	}\
-}
+#define DT_GETPAGE(IP, BN, MP, SIZE, P, RC)				\
+do {									\
+	BT_GETPAGE(IP, BN, MP, dtpage_t, SIZE, P, RC, i_dtroot);	\
+	if (!(RC)) {							\
+		if (((P)->header.nextindex >				\
+		     (((BN) == 0) ? DTROOTMAXSLOT : (P)->header.maxslot)) || \
+		    ((BN) && ((P)->header.maxslot > DTPAGEMAXSLOT))) {	\
+			BT_PUTPAGE(MP);					\
+			jfs_sb_err((IP)->i_sb,				\
+				   "DT_GETPAGE: dtree page corrupt\n"); \
+			MP = NULL;					\
+			RC = -EIO;					\
+		}							\
+	}								\
+} while (0)
 
 /* for consistency */
 #define DT_PUTPAGE(MP) BT_PUTPAGE(MP)
@@ -776,7 +776,7 @@ int dtSearch(struct inode *ip, struct component_name * key, ino_t * data,
 			/* Something's corrupted, mark filesystem dirty so
 			 * chkdsk will fix it.
 			 */
-			jfs_error(sb, "stack overrun in dtSearch!");
+			jfs_sb_err(sb, "stack overrun!\n");
 			BT_STACK_DUMP(btstack);
 			rc = -EIO;
 			goto out;
@@ -3251,12 +3251,11 @@ int jfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 				d_namleft -= len;
 				/* Sanity Check */
 				if (d_namleft == 0) {
-					jfs_error(ip->i_sb,
-						  "JFS:Dtree error: ino = "
-						  "%ld, bn=%Ld, index = %d",
-						  (long)ip->i_ino,
-						  (long long)bn,
-						  i);
+					jfs_sb_err(ip->i_sb,
+						   "JFS:Dtree error: ino = %ld, bn=%lld, index = %d\n",
+						   (long)ip->i_ino,
+						   (long long)bn,
+						   i);
 					goto skip_one;
 				}
 				len = min(d_namleft, DTSLOTDATALEN);
@@ -3373,7 +3372,7 @@ static int dtReadFirst(struct inode *ip, struct btstack * btstack)
 		 */
 		if (BT_STACK_FULL(btstack)) {
 			DT_PUTPAGE(mp);
-			jfs_error(ip->i_sb, "dtReadFirst: btstack overrun");
+			jfs_sb_err(ip->i_sb, "btstack overrun\n");
 			BT_STACK_DUMP(btstack);
 			return -EIO;
 		}
diff --git a/fs/jfs/jfs_extent.c b/fs/jfs/jfs_extent.c
index e5fe850..2616a4e 100644
--- a/fs/jfs/jfs_extent.c
+++ b/fs/jfs/jfs_extent.c
@@ -388,7 +388,7 @@ int extHint(struct inode *ip, s64 offset, xad_t * xp)
 
 	if ((rc == 0) && xlen) {
 		if (xlen != nbperpage) {
-			jfs_error(ip->i_sb, "extHint: corrupt xtree");
+			jfs_sb_err(ip->i_sb, "corrupt xtree\n");
 			rc = -EIO;
 		}
 		XADaddress(xp, xaddr);
diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
index f7e042b..fe27d01 100644
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -386,7 +386,7 @@ int diRead(struct inode *ip)
 	dp += rel_inode;
 
 	if (ip->i_ino != le32_to_cpu(dp->di_number)) {
-		jfs_error(ip->i_sb, "diRead: i_ino != di_number");
+		jfs_sb_err(ip->i_sb, "i_ino != di_number\n");
 		rc = -EIO;
 	} else if (le32_to_cpu(dp->di_nlink) == 0)
 		rc = -ESTALE;
@@ -625,7 +625,7 @@ int diWrite(tid_t tid, struct inode *ip)
 	if (!addressPXD(&(jfs_ip->ixpxd)) ||
 	    (lengthPXD(&(jfs_ip->ixpxd)) !=
 	     JFS_IP(ipimap)->i_imap->im_nbperiext)) {
-		jfs_error(ip->i_sb, "diWrite: ixpxd invalid");
+		jfs_sb_err(ip->i_sb, "ixpxd invalid\n");
 		return -EIO;
 	}
 
@@ -893,9 +893,8 @@ int diFree(struct inode *ip)
 	if (iagno >= imap->im_nextiag) {
 		print_hex_dump(KERN_ERR, "imap: ", DUMP_PREFIX_ADDRESS, 16, 4,
 			       imap, 32, 0);
-		jfs_error(ip->i_sb,
-			  "diFree: inum = %d, iagno = %d, nextiag = %d",
-			  (uint) inum, iagno, imap->im_nextiag);
+		jfs_sb_err(ip->i_sb, "inum = %d, iagno = %d, nextiag = %d\n",
+			   (uint) inum, iagno, imap->im_nextiag);
 		return -EIO;
 	}
 
@@ -930,15 +929,14 @@ int diFree(struct inode *ip)
 	mask = HIGHORDER >> bitno;
 
 	if (!(le32_to_cpu(iagp->wmap[extno]) & mask)) {
-		jfs_error(ip->i_sb,
-			  "diFree: wmap shows inode already free");
+		jfs_sb_err(ip->i_sb, "wmap shows inode already free\n");
 	}
 
 	if (!addressPXD(&iagp->inoext[extno])) {
 		release_metapage(mp);
 		IREAD_UNLOCK(ipimap);
 		AG_UNLOCK(imap, agno);
-		jfs_error(ip->i_sb, "diFree: invalid inoext");
+		jfs_sb_err(ip->i_sb, "invalid inoext\n");
 		return -EIO;
 	}
 
@@ -950,7 +948,7 @@ int diFree(struct inode *ip)
 		release_metapage(mp);
 		IREAD_UNLOCK(ipimap);
 		AG_UNLOCK(imap, agno);
-		jfs_error(ip->i_sb, "diFree: numfree > numinos");
+		jfs_sb_err(ip->i_sb, "numfree > numinos\n");
 		return -EIO;
 	}
 	/*
@@ -1199,7 +1197,7 @@ int diFree(struct inode *ip)
 	 * for the inode being freed.
 	 */
 	if (iagp->pmap[extno] != 0) {
-		jfs_error(ip->i_sb, "diFree: the pmap does not show inode free");
+		jfs_sb_err(ip->i_sb, "the pmap does not show inode free\n");
 	}
 	iagp->wmap[extno] = 0;
 	PXDlength(&iagp->inoext[extno], 0);
@@ -1517,9 +1515,8 @@ int diAlloc(struct inode *pip, bool dir, struct inode *ip)
 					IREAD_UNLOCK(ipimap);
 					release_metapage(mp);
 					AG_UNLOCK(imap, agno);
-					jfs_error(ip->i_sb,
-						  "diAlloc: can't find free bit "
-						  "in wmap");
+					jfs_sb_err(ip->i_sb,
+						   "can't find free bit in wmap\n");
 					return -EIO;
 				}
 
@@ -1660,7 +1657,7 @@ diAllocAG(struct inomap * imap, int agno, bool dir, struct inode *ip)
 	numinos = imap->im_agctl[agno].numinos;
 
 	if (numfree > numinos) {
-		jfs_error(ip->i_sb, "diAllocAG: numfree > numinos");
+		jfs_sb_err(ip->i_sb, "numfree > numinos\n");
 		return -EIO;
 	}
 
@@ -1811,8 +1808,7 @@ static int diAllocIno(struct inomap * imap, int agno, struct inode *ip)
 	if (!iagp->nfreeinos) {
 		IREAD_UNLOCK(imap->im_ipimap);
 		release_metapage(mp);
-		jfs_error(ip->i_sb,
-			  "diAllocIno: nfreeinos = 0, but iag on freelist");
+		jfs_sb_err(ip->i_sb, "nfreeinos = 0, but iag on freelist\n");
 		return -EIO;
 	}
 
@@ -1823,8 +1819,8 @@ static int diAllocIno(struct inomap * imap, int agno, struct inode *ip)
 		if (sword >= SMAPSZ) {
 			IREAD_UNLOCK(imap->im_ipimap);
 			release_metapage(mp);
-			jfs_error(ip->i_sb,
-				  "diAllocIno: free inode not found in summary map");
+			jfs_sb_err(ip->i_sb,
+				   "free inode not found in summary map\n");
 			return -EIO;
 		}
 
@@ -1839,7 +1835,7 @@ static int diAllocIno(struct inomap * imap, int agno, struct inode *ip)
 	if (rem >= EXTSPERSUM) {
 		IREAD_UNLOCK(imap->im_ipimap);
 		release_metapage(mp);
-		jfs_error(ip->i_sb, "diAllocIno: no free extent found");
+		jfs_sb_err(ip->i_sb, "no free extent found\n");
 		return -EIO;
 	}
 	extno = (sword << L2EXTSPERSUM) + rem;
@@ -1850,7 +1846,7 @@ static int diAllocIno(struct inomap * imap, int agno, struct inode *ip)
 	if (rem >= INOSPEREXT) {
 		IREAD_UNLOCK(imap->im_ipimap);
 		release_metapage(mp);
-		jfs_error(ip->i_sb, "diAllocIno: free inode not found");
+		jfs_sb_err(ip->i_sb, "free inode not found\n");
 		return -EIO;
 	}
 
@@ -1936,7 +1932,7 @@ static int diAllocExt(struct inomap * imap, int agno, struct inode *ip)
 		IREAD_LOCK(imap->im_ipimap, RDWRLOCK_IMAP);
 		if ((rc = diIAGRead(imap, iagno, &mp))) {
 			IREAD_UNLOCK(imap->im_ipimap);
-			jfs_error(ip->i_sb, "diAllocExt: error reading iag");
+			jfs_sb_err(ip->i_sb, "error reading iag\n");
 			return rc;
 		}
 		iagp = (struct iag *) mp->data;
@@ -1948,8 +1944,8 @@ static int diAllocExt(struct inomap * imap, int agno, struct inode *ip)
 		if (sword >= SMAPSZ) {
 			release_metapage(mp);
 			IREAD_UNLOCK(imap->im_ipimap);
-			jfs_error(ip->i_sb,
-				  "diAllocExt: free ext summary map not found");
+			jfs_sb_err(ip->i_sb,
+				   "free ext summary map not found\n");
 			return -EIO;
 		}
 		if (~iagp->extsmap[sword])
@@ -1962,7 +1958,7 @@ static int diAllocExt(struct inomap * imap, int agno, struct inode *ip)
 	if (rem >= EXTSPERSUM) {
 		release_metapage(mp);
 		IREAD_UNLOCK(imap->im_ipimap);
-		jfs_error(ip->i_sb, "diAllocExt: free extent not found");
+		jfs_sb_err(ip->i_sb, "free extent not found\n");
 		return -EIO;
 	}
 	extno = (sword << L2EXTSPERSUM) + rem;
@@ -2081,8 +2077,7 @@ static int diAllocBit(struct inomap * imap, struct iag * iagp, int ino)
 		if (bmp)
 			release_metapage(bmp);
 
-		jfs_error(imap->im_ipimap->i_sb,
-			  "diAllocBit: iag inconsistent");
+		jfs_sb_err(imap->im_ipimap->i_sb, "iag inconsistent\n");
 		return -EIO;
 	}
 
@@ -2189,7 +2184,7 @@ static int diNewExt(struct inomap * imap, struct iag * iagp, int extno)
 	/* better have free extents.
 	 */
 	if (!iagp->nfreeexts) {
-		jfs_error(imap->im_ipimap->i_sb, "diNewExt: no free extents");
+		jfs_sb_err(imap->im_ipimap->i_sb, "no free extents\n");
 		return -EIO;
 	}
 
@@ -2260,8 +2255,8 @@ static int diNewExt(struct inomap * imap, struct iag * iagp, int extno)
 				ciagp = (struct iag *) cmp->data;
 			}
 			if (ciagp == NULL) {
-				jfs_error(imap->im_ipimap->i_sb,
-					  "diNewExt: ciagp == NULL");
+				jfs_sb_err(imap->im_ipimap->i_sb,
+					   "ciagp == NULL\n");
 				rc = -EIO;
 				goto error_out;
 			}
@@ -2497,8 +2492,8 @@ diNewIAG(struct inomap * imap, int *iagnop, int agno, struct metapage ** mpp)
 		if (ipimap->i_size >> L2PSIZE != imap->im_nextiag + 1) {
 			IWRITE_UNLOCK(ipimap);
 			IAGFREE_UNLOCK(imap);
-			jfs_error(imap->im_ipimap->i_sb,
-				  "diNewIAG: ipimap->i_size is wrong");
+			jfs_sb_err(imap->im_ipimap->i_sb,
+				   "ipimap->i_size is wrong\n");
 			return -EIO;
 		}
 
@@ -2758,8 +2753,7 @@ diUpdatePMap(struct inode *ipimap,
 	iagno = INOTOIAG(inum);
 	/* make sure that the iag is contained within the map */
 	if (iagno >= imap->im_nextiag) {
-		jfs_error(ipimap->i_sb,
-			  "diUpdatePMap: the iag is outside the map");
+		jfs_sb_err(ipimap->i_sb, "the iag is outside the map\n");
 		return -EIO;
 	}
 	/* read the iag */
@@ -2787,14 +2781,14 @@ diUpdatePMap(struct inode *ipimap,
 		 * of last reference release;
 		 */
 		if (!(le32_to_cpu(iagp->wmap[extno]) & mask)) {
-			jfs_error(ipimap->i_sb,
-				  "diUpdatePMap: inode %ld not marked as "
-				  "allocated in wmap!", inum);
+			jfs_sb_err(ipimap->i_sb,
+				   "inode %ld not marked as allocated in wmap!\n",
+				   inum);
 		}
 		if (!(le32_to_cpu(iagp->pmap[extno]) & mask)) {
-			jfs_error(ipimap->i_sb,
-				  "diUpdatePMap: inode %ld not marked as "
-				  "allocated in pmap!", inum);
+			jfs_sb_err(ipimap->i_sb,
+				   "inode %ld not marked as allocated in pmap!\n",
+				   inum);
 		}
 		/* update the bitmap for the extent of the freed inode */
 		iagp->pmap[extno] &= cpu_to_le32(~mask);
@@ -2808,16 +2802,14 @@ diUpdatePMap(struct inode *ipimap,
 		 */
 		if (!(le32_to_cpu(iagp->wmap[extno]) & mask)) {
 			release_metapage(mp);
-			jfs_error(ipimap->i_sb,
-				  "diUpdatePMap: the inode is not allocated in "
-				  "the working map");
+			jfs_sb_err(ipimap->i_sb,
+				   "the inode is not allocated in the working map\n");
 			return -EIO;
 		}
 		if ((le32_to_cpu(iagp->pmap[extno]) & mask) != 0) {
 			release_metapage(mp);
-			jfs_error(ipimap->i_sb,
-				  "diUpdatePMap: the inode is not free in the "
-				  "persistent map");
+			jfs_sb_err(ipimap->i_sb,
+				   "the inode is not free in the persistent map\n");
 			return -EIO;
 		}
 		/* update the bitmap for the extent of the allocated inode */
@@ -2909,8 +2901,8 @@ int diExtendFS(struct inode *ipimap, struct inode *ipbmap)
 		iagp = (struct iag *) bp->data;
 		if (le32_to_cpu(iagp->iagnum) != i) {
 			release_metapage(bp);
-			jfs_error(ipimap->i_sb,
-				  "diExtendFs: unexpected value of iagnum");
+			jfs_sb_err(ipimap->i_sb,
+				   "unexpected value of iagnum\n");
 			return -EIO;
 		}
 
@@ -2986,8 +2978,7 @@ int diExtendFS(struct inode *ipimap, struct inode *ipbmap)
 
 	if (xnuminos != atomic_read(&imap->im_numinos) ||
 	    xnumfree != atomic_read(&imap->im_numfree)) {
-		jfs_error(ipimap->i_sb,
-			  "diExtendFs: numinos or numfree incorrect");
+		jfs_sb_err(ipimap->i_sb, "numinos or numfree incorrect\n");
 		return -EIO;
 	}
 
diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
index de87794..612f108 100644
--- a/fs/jfs/jfs_metapage.c
+++ b/fs/jfs/jfs_metapage.c
@@ -648,8 +648,8 @@ struct metapage *__get_metapage(struct inode *inode, unsigned long lblock,
 	mp = page_to_mp(page, page_offset);
 	if (mp) {
 		if (mp->logical_size != size) {
-			jfs_error(inode->i_sb,
-				  "__get_metapage: mp->logical_size != size");
+			jfs_sb_err(inode->i_sb,
+				   "get_mp->logical_size != size\n");
 			jfs_err("logical_size = %d, size = %d",
 				mp->logical_size, size);
 			dump_stack();
@@ -659,9 +659,8 @@ struct metapage *__get_metapage(struct inode *inode, unsigned long lblock,
 		lock_metapage(mp);
 		if (test_bit(META_discard, &mp->flag)) {
 			if (!new) {
-				jfs_error(inode->i_sb,
-					  "__get_metapage: using a "
-					  "discarded metapage");
+				jfs_sb_err(inode->i_sb,
+					   "using a discarded metapage\n");
 				discard_metapage(mp);
 				goto unlock;
 			}
diff --git a/fs/jfs/jfs_superblock.h b/fs/jfs/jfs_superblock.h
index 884fc21..cd68c0a 100644
--- a/fs/jfs/jfs_superblock.h
+++ b/fs/jfs/jfs_superblock.h
@@ -108,7 +108,8 @@ struct jfs_superblock {
 
 extern int readSuper(struct super_block *, struct buffer_head **);
 extern int updateSuper(struct super_block *, uint);
-extern void jfs_error(struct super_block *, const char *, ...);
+__printf(2, 3)
+extern void jfs_sb_err(struct super_block *, const char *, ...);
 extern int jfs_mount(struct super_block *);
 extern int jfs_mount_rw(struct super_block *, int);
 extern int jfs_umount(struct super_block *);
diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
index 5fcc02e..3accf33 100644
--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -2684,7 +2684,7 @@ void txAbort(tid_t tid, int dirty)
 	 * mark filesystem dirty
 	 */
 	if (dirty)
-		jfs_error(tblk->sb, "txAbort");
+		jfs_sb_err(tblk->sb, "\n");
 
 	return;
 }
diff --git a/fs/jfs/jfs_xtree.c b/fs/jfs/jfs_xtree.c
index 6c50871..22d4e9f 100644
--- a/fs/jfs/jfs_xtree.c
+++ b/fs/jfs/jfs_xtree.c
@@ -64,22 +64,23 @@
 
 /* get page buffer for specified block address */
 /* ToDo: Replace this ugly macro with a function */
-#define XT_GETPAGE(IP, BN, MP, SIZE, P, RC)\
-{\
-	BT_GETPAGE(IP, BN, MP, xtpage_t, SIZE, P, RC, i_xtroot)\
-	if (!(RC))\
-	{\
-		if ((le16_to_cpu((P)->header.nextindex) < XTENTRYSTART) ||\
-		    (le16_to_cpu((P)->header.nextindex) > le16_to_cpu((P)->header.maxentry)) ||\
-		    (le16_to_cpu((P)->header.maxentry) > (((BN)==0)?XTROOTMAXSLOT:PSIZE>>L2XTSLOTSIZE)))\
-		{\
-			jfs_error((IP)->i_sb, "XT_GETPAGE: xtree page corrupt");\
-			BT_PUTPAGE(MP);\
-			MP = NULL;\
-			RC = -EIO;\
-		}\
-	}\
-}
+#define XT_GETPAGE(IP, BN, MP, SIZE, P, RC)				\
+do {									\
+	BT_GETPAGE(IP, BN, MP, xtpage_t, SIZE, P, RC, i_xtroot);	\
+	if (!(RC)) {							\
+		if ((le16_to_cpu((P)->header.nextindex) < XTENTRYSTART) || \
+		    (le16_to_cpu((P)->header.nextindex) >		\
+		     le16_to_cpu((P)->header.maxentry)) ||		\
+		    (le16_to_cpu((P)->header.maxentry) >		\
+		     (((BN) == 0) ? XTROOTMAXSLOT : PSIZE >> L2XTSLOTSIZE))) { \
+			jfs_sb_err((IP)->i_sb,				\
+				   "XT_GETPAGE: xtree page corrupt\n"); \
+			BT_PUTPAGE(MP);					\
+			MP = NULL;					\
+			RC = -EIO;					\
+		}							\
+	}								\
+} while (0)
 
 /* for consistency */
 #define XT_PUTPAGE(MP) BT_PUTPAGE(MP)
@@ -499,7 +500,7 @@ static int xtSearch(struct inode *ip, s64 xoff,	s64 *nextp,
 
 		/* push (bn, index) of the parent page/entry */
 		if (BT_STACK_FULL(btstack)) {
-			jfs_error(ip->i_sb, "stack overrun in xtSearch!");
+			jfs_sb_err(ip->i_sb, "stack overrun!\n");
 			XT_PUTPAGE(mp);
 			return -EIO;
 		}
@@ -1385,7 +1386,7 @@ int xtExtend(tid_t tid,		/* transaction id */
 
 	if (cmp != 0) {
 		XT_PUTPAGE(mp);
-		jfs_error(ip->i_sb, "xtExtend: xtSearch did not find extent");
+		jfs_sb_err(ip->i_sb, "xtSearch did not find extent\n");
 		return -EIO;
 	}
 
@@ -1393,7 +1394,7 @@ int xtExtend(tid_t tid,		/* transaction id */
 	xad = &p->xad[index];
 	if ((offsetXAD(xad) + lengthXAD(xad)) != xoff) {
 		XT_PUTPAGE(mp);
-		jfs_error(ip->i_sb, "xtExtend: extension is not contiguous");
+		jfs_sb_err(ip->i_sb, "extension is not contiguous\n");
 		return -EIO;
 	}
 
@@ -1552,7 +1553,7 @@ printf("xtTailgate: nxoff:0x%lx nxlen:0x%x nxaddr:0x%lx\n",
 
 	if (cmp != 0) {
 		XT_PUTPAGE(mp);
-		jfs_error(ip->i_sb, "xtTailgate: couldn't find extent");
+		jfs_sb_err(ip->i_sb, "couldn't find extent\n");
 		return -EIO;
 	}
 
@@ -1560,8 +1561,7 @@ printf("xtTailgate: nxoff:0x%lx nxlen:0x%x nxaddr:0x%lx\n",
 	nextindex = le16_to_cpu(p->header.nextindex);
 	if (index != nextindex - 1) {
 		XT_PUTPAGE(mp);
-		jfs_error(ip->i_sb,
-			  "xtTailgate: the entry found is not the last entry");
+		jfs_sb_err(ip->i_sb, "the entry found is not the last entry\n");
 		return -EIO;
 	}
 
@@ -1734,7 +1734,7 @@ int xtUpdate(tid_t tid, struct inode *ip, xad_t * nxad)
 
 	if (cmp != 0) {
 		XT_PUTPAGE(mp);
-		jfs_error(ip->i_sb, "xtUpdate: Could not find extent");
+		jfs_sb_err(ip->i_sb, "Could not find extent\n");
 		return -EIO;
 	}
 
@@ -1757,8 +1757,8 @@ int xtUpdate(tid_t tid, struct inode *ip, xad_t * nxad)
 	if ((xoff > nxoff) ||
 	    (nxoff + nxlen > xoff + xlen)) {
 		XT_PUTPAGE(mp);
-		jfs_error(ip->i_sb,
-			  "xtUpdate: nXAD in not completely contained within XAD");
+		jfs_sb_err(ip->i_sb,
+			   "nXAD in not completely contained within XAD\n");
 		return -EIO;
 	}
 
@@ -1907,7 +1907,7 @@ int xtUpdate(tid_t tid, struct inode *ip, xad_t * nxad)
 
 	if (xoff >= nxoff) {
 		XT_PUTPAGE(mp);
-		jfs_error(ip->i_sb, "xtUpdate: xoff >= nxoff");
+		jfs_sb_err(ip->i_sb, "xoff >= nxoff\n");
 		return -EIO;
 	}
 /* #endif _JFS_WIP_COALESCE */
@@ -2048,14 +2048,13 @@ int xtUpdate(tid_t tid, struct inode *ip, xad_t * nxad)
 
 		if (cmp != 0) {
 			XT_PUTPAGE(mp);
-			jfs_error(ip->i_sb, "xtUpdate: xtSearch failed");
+			jfs_sb_err(ip->i_sb, "xtSearch failed\n");
 			return -EIO;
 		}
 
 		if (index0 != index) {
 			XT_PUTPAGE(mp);
-			jfs_error(ip->i_sb,
-				  "xtUpdate: unexpected value of index");
+			jfs_sb_err(ip->i_sb, "unexpected value of index\n");
 			return -EIO;
 		}
 	}
@@ -3650,7 +3649,7 @@ s64 xtTruncate(tid_t tid, struct inode *ip, s64 newsize, int flag)
       getChild:
 	/* save current parent entry for the child page */
 	if (BT_STACK_FULL(&btstack)) {
-		jfs_error(ip->i_sb, "stack overrun in xtTruncate!");
+		jfs_sb_err(ip->i_sb, "stack overrun!\n");
 		XT_PUTPAGE(mp);
 		return -EIO;
 	}
@@ -3751,8 +3750,7 @@ s64 xtTruncate_pmap(tid_t tid, struct inode *ip, s64 committed_size)
 
 		if (cmp != 0) {
 			XT_PUTPAGE(mp);
-			jfs_error(ip->i_sb,
-				  "xtTruncate_pmap: did not find extent");
+			jfs_sb_err(ip->i_sb, "did not find extent\n");
 			return -EIO;
 		}
 	} else {
@@ -3851,7 +3849,7 @@ s64 xtTruncate_pmap(tid_t tid, struct inode *ip, s64 committed_size)
       getChild:
 	/* save current parent entry for the child page */
 	if (BT_STACK_FULL(&btstack)) {
-		jfs_error(ip->i_sb, "stack overrun in xtTruncate_pmap!");
+		jfs_sb_err(ip->i_sb, "stack overrun!\n");
 		XT_PUTPAGE(mp);
 		return -EIO;
 	}
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 3b91a7a..d835090 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -1175,8 +1175,8 @@ static int jfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 				mutex_unlock(&JFS_IP(new_dir)->commit_mutex);
 				if (!S_ISDIR(old_ip->i_mode) && new_ip)
 					IWRITE_UNLOCK(new_ip);
-				jfs_error(new_ip->i_sb,
-					  "jfs_rename: new_ip->i_nlink != 0");
+				jfs_sb_err(new_ip->i_sb,
+					   "new_ip->i_nlink != 0\n");
 				return -EIO;
 			}
 			tblk = tid_to_tblock(tid);
diff --git a/fs/jfs/resize.c b/fs/jfs/resize.c
index 8d0c1c7..2d21f3a 100644
--- a/fs/jfs/resize.c
+++ b/fs/jfs/resize.c
@@ -530,7 +530,7 @@ int jfs_extendfs(struct super_block *sb, s64 newLVSize, int newLogSize)
 	goto resume;
 
       error_out:
-	jfs_error(sb, "jfs_extendfs");
+	jfs_sb_err(sb, "\n");
 
       resume:
 	/*
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 788e0a9..54b45c8 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -92,16 +92,20 @@ static void jfs_handle_error(struct super_block *sb)
 	/* nothing is done for continue beyond marking the superblock dirty */
 }
 
-void jfs_error(struct super_block *sb, const char * function, ...)
+void jfs_sb_err(struct super_block *sb, const char *fmt, ...)
 {
-	static char error_buf[256];
+	struct va_format vaf;
 	va_list args;
 
-	va_start(args, function);
-	vsnprintf(error_buf, sizeof(error_buf), function, args);
-	va_end(args);
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
 
-	pr_err("ERROR: (device %s): %s\n", sb->s_id, error_buf);
+	pr_err("ERROR: (device %s): %pf: %pV\n",
+	       sb->s_id, __builtin_return_address(0), &vaf);
+
+	va_end(args);
 
 	jfs_handle_error(sb);
 }
@@ -617,7 +621,7 @@ static int jfs_freeze(struct super_block *sb)
 		txQuiesce(sb);
 		rc = lmLogShutdown(log);
 		if (rc) {
-			jfs_error(sb, "jfs_freeze: lmLogShutdown failed");
+			jfs_sb_err(sb, "lmLogShutdown failed\n");
 
 			/* let operations fail rather than hang */
 			txResume(sb);
@@ -646,12 +650,12 @@ static int jfs_unfreeze(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY)) {
 		rc = updateSuper(sb, FM_MOUNT);
 		if (rc) {
-			jfs_error(sb, "jfs_unfreeze: updateSuper failed");
+			jfs_sb_err(sb, "updateSuper failed\n");
 			goto out;
 		}
 		rc = lmLogInit(log);
 		if (rc)
-			jfs_error(sb, "jfs_unfreeze: lmLogInit failed");
+			jfs_sb_err(sb, "lmLogInit failed\n");
 out:
 		txResume(sb);
 	}
diff --git a/fs/jfs/xattr.c b/fs/jfs/xattr.c
index 42d67f9..f0b2859 100644
--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -382,7 +382,7 @@ static int ea_read(struct inode *ip, struct jfs_ea_list *ealist)
 
 	nbytes = sizeDXD(&ji->ea);
 	if (!nbytes) {
-		jfs_error(sb, "ea_read: nbytes is 0");
+		jfs_sb_err(sb, "nbytes is 0\n");
 		return -EIO;
 	}
 
@@ -482,7 +482,7 @@ static int ea_get(struct inode *inode, struct ea_buffer *ea_buf, int min_size)
 		current_blocks = 0;
 	} else {
 		if (!(ji->ea.flag & DXD_EXTENT)) {
-			jfs_error(sb, "ea_get: invalid ea.flag)");
+			jfs_sb_err(sb, "invalid ea.flag\n");
 			return -EIO;
 		}
 		current_blocks = (ea_size + sb->s_blocksize - 1) >>
-- 
1.8.1.2.459.gbcd45b4.dirty

