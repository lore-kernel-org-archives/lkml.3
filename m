Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab3FDXji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:39:38 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58079 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751951Ab3FDXjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 19:39:32 -0400
From: Joe Perches <joe@perches.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] jfs: Update jfs_error
Date: Tue,  4 Jun 2013 16:39:15 -0700
Message-Id: <13f9c67a27664b1e8264886127145745c71e43b2.1370388945.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1370388945.git.joe@perches.com>
References: <cover.1370388945.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a more current logging style.

Add __printf format and argument verification.

Remove embedded function names from formats.
Add %pf, __builtin_return_address(0) to jfs_error.
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
 fs/jfs/jfs_dmap.c       | 70 +++++++++++++++++++------------------------------
 fs/jfs/jfs_dtree.c      | 37 +++++++++++++-------------
 fs/jfs/jfs_extent.c     |  2 +-
 fs/jfs/jfs_imap.c       | 69 ++++++++++++++++++++----------------------------
 fs/jfs/jfs_metapage.c   |  5 ++--
 fs/jfs/jfs_superblock.h |  1 +
 fs/jfs/jfs_txnmgr.c     |  2 +-
 fs/jfs/jfs_xtree.c      | 62 +++++++++++++++++++++----------------------
 fs/jfs/namei.c          |  2 +-
 fs/jfs/resize.c         |  2 +-
 fs/jfs/super.c          | 22 +++++++++-------
 fs/jfs/xattr.c          |  4 +--
 12 files changed, 126 insertions(+), 152 deletions(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 9a55f53..370d7b6 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -346,8 +346,7 @@ int dbFree(struct inode *ip, s64 blkno, s64 nblocks)
 		printk(KERN_ERR "blkno = %Lx, nblocks = %Lx\n",
 		       (unsigned long long) blkno,
 		       (unsigned long long) nblocks);
-		jfs_error(ip->i_sb,
-			  "dbFree: block to be freed is outside the map");
+		jfs_error(ip->i_sb, "block to be freed is outside the map\n");
 		return -EIO;
 	}
 
@@ -384,7 +383,7 @@ int dbFree(struct inode *ip, s64 blkno, s64 nblocks)
 
 		/* free the blocks. */
 		if ((rc = dbFreeDmap(bmp, dp, blkno, nb))) {
-			jfs_error(ip->i_sb, "dbFree: error in block map\n");
+			jfs_error(ip->i_sb, "error in block map\n");
 			release_metapage(mp);
 			IREAD_UNLOCK(ipbmap);
 			return (rc);
@@ -441,8 +440,7 @@ dbUpdatePMap(struct inode *ipbmap,
 		printk(KERN_ERR "blkno = %Lx, nblocks = %Lx\n",
 		       (unsigned long long) blkno,
 		       (unsigned long long) nblocks);
-		jfs_error(ipbmap->i_sb,
-			  "dbUpdatePMap: blocks are outside the map");
+		jfs_error(ipbmap->i_sb, "blocks are outside the map\n");
 		return -EIO;
 	}
 
@@ -726,7 +724,7 @@ int dbAlloc(struct inode *ip, s64 hint, s64 nblocks, s64 * results)
 
 	/* the hint should be within the map */
 	if (hint >= mapSize) {
-		jfs_error(ip->i_sb, "dbAlloc: the hint is outside the map");
+		jfs_error(ip->i_sb, "the hint is outside the map\n");
 		return -EIO;
 	}
 
@@ -1057,8 +1055,7 @@ static int dbExtend(struct inode *ip, s64 blkno, s64 nblocks, s64 addnblocks)
 	bmp = sbi->bmap;
 	if (lastblkno < 0 || lastblkno >= bmp->db_mapsize) {
 		IREAD_UNLOCK(ipbmap);
-		jfs_error(ip->i_sb,
-			  "dbExtend: the block is outside the filesystem");
+		jfs_error(ip->i_sb, "the block is outside the filesystem\n");
 		return -EIO;
 	}
 
@@ -1134,8 +1131,7 @@ static int dbAllocNext(struct bmap * bmp, struct dmap * dp, s64 blkno,
 	u32 mask;
 
 	if (dp->tree.leafidx != cpu_to_le32(LEAFIND)) {
-		jfs_error(bmp->db_ipbmap->i_sb,
-			  "dbAllocNext: Corrupt dmap page");
+		jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
 		return -EIO;
 	}
 
@@ -1265,8 +1261,7 @@ dbAllocNear(struct bmap * bmp,
 	s8 *leaf;
 
 	if (dp->tree.leafidx != cpu_to_le32(LEAFIND)) {
-		jfs_error(bmp->db_ipbmap->i_sb,
-			  "dbAllocNear: Corrupt dmap page");
+		jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
 		return -EIO;
 	}
 
@@ -1381,8 +1376,7 @@ dbAllocAG(struct bmap * bmp, int agno, s64 nblocks, int l2nb, s64 * results)
 	 */
 	if (l2nb > bmp->db_agl2size) {
 		jfs_error(bmp->db_ipbmap->i_sb,
-			  "dbAllocAG: allocation request is larger than the "
-			  "allocation group size");
+			  "allocation request is larger than the allocation group size\n");
 		return -EIO;
 	}
 
@@ -1417,7 +1411,7 @@ dbAllocAG(struct bmap * bmp, int agno, s64 nblocks, int l2nb, s64 * results)
 			       (unsigned long long) blkno,
 			       (unsigned long long) nblocks);
 			jfs_error(bmp->db_ipbmap->i_sb,
-				  "dbAllocAG: dbAllocCtl failed in free AG");
+				  "dbAllocCtl failed in free AG\n");
 		}
 		return (rc);
 	}
@@ -1433,8 +1427,7 @@ dbAllocAG(struct bmap * bmp, int agno, s64 nblocks, int l2nb, s64 * results)
 	budmin = dcp->budmin;
 
 	if (dcp->leafidx != cpu_to_le32(CTLLEAFIND)) {
-		jfs_error(bmp->db_ipbmap->i_sb,
-			  "dbAllocAG: Corrupt dmapctl page");
+		jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmapctl page\n");
 		release_metapage(mp);
 		return -EIO;
 	}
@@ -1475,7 +1468,7 @@ dbAllocAG(struct bmap * bmp, int agno, s64 nblocks, int l2nb, s64 * results)
 			}
 			if (n == 4) {
 				jfs_error(bmp->db_ipbmap->i_sb,
-					  "dbAllocAG: failed descending stree");
+					  "failed descending stree\n");
 				release_metapage(mp);
 				return -EIO;
 			}
@@ -1515,8 +1508,7 @@ dbAllocAG(struct bmap * bmp, int agno, s64 nblocks, int l2nb, s64 * results)
 				       &blkno))) {
 				if (rc == -ENOSPC) {
 					jfs_error(bmp->db_ipbmap->i_sb,
-						  "dbAllocAG: control page "
-						  "inconsistent");
+						  "control page inconsistent\n");
 					return -EIO;
 				}
 				return (rc);
@@ -1528,7 +1520,7 @@ dbAllocAG(struct bmap * bmp, int agno, s64 nblocks, int l2nb, s64 * results)
 		rc = dbAllocCtl(bmp, nblocks, l2nb, blkno, results);
 		if (rc == -ENOSPC) {
 			jfs_error(bmp->db_ipbmap->i_sb,
-				  "dbAllocAG: unable to allocate blocks");
+				  "unable to allocate blocks\n");
 			rc = -EIO;
 		}
 		return (rc);
@@ -1587,8 +1579,7 @@ static int dbAllocAny(struct bmap * bmp, s64 nblocks, int l2nb, s64 * results)
 	 */
 	rc = dbAllocCtl(bmp, nblocks, l2nb, blkno, results);
 	if (rc == -ENOSPC) {
-		jfs_error(bmp->db_ipbmap->i_sb,
-			  "dbAllocAny: unable to allocate blocks");
+		jfs_error(bmp->db_ipbmap->i_sb, "unable to allocate blocks\n");
 		return -EIO;
 	}
 	return (rc);
@@ -1652,8 +1643,7 @@ s64 dbDiscardAG(struct inode *ip, int agno, s64 minlen)
 	range_cnt = min_t(u64, max_ranges + 1, 32 * 1024);
 	totrim = kmalloc(sizeof(struct range2trim) * range_cnt, GFP_NOFS);
 	if (totrim == NULL) {
-		jfs_error(bmp->db_ipbmap->i_sb,
-			  "dbDiscardAG: no memory for trim array");
+		jfs_error(bmp->db_ipbmap->i_sb, "no memory for trim array\n");
 		IWRITE_UNLOCK(ipbmap);
 		return 0;
 	}
@@ -1682,8 +1672,7 @@ s64 dbDiscardAG(struct inode *ip, int agno, s64 minlen)
 			nblocks = 1 << l2nb;
 		} else {
 			/* Trim any already allocated blocks */
-			jfs_error(bmp->db_ipbmap->i_sb,
-				"dbDiscardAG: -EIO");
+			jfs_error(bmp->db_ipbmap->i_sb, "-EIO\n");
 			break;
 		}
 
@@ -1761,7 +1750,7 @@ static int dbFindCtl(struct bmap * bmp, int l2nb, int level, s64 * blkno)
 
 		if (dcp->leafidx != cpu_to_le32(CTLLEAFIND)) {
 			jfs_error(bmp->db_ipbmap->i_sb,
-				  "dbFindCtl: Corrupt dmapctl page");
+				  "Corrupt dmapctl page\n");
 			release_metapage(mp);
 			return -EIO;
 		}
@@ -1782,7 +1771,7 @@ static int dbFindCtl(struct bmap * bmp, int l2nb, int level, s64 * blkno)
 		if (rc) {
 			if (lev != level) {
 				jfs_error(bmp->db_ipbmap->i_sb,
-					  "dbFindCtl: dmap inconsistent");
+					  "dmap inconsistent\n");
 				return -EIO;
 			}
 			return -ENOSPC;
@@ -1906,7 +1895,7 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 		if (dp->tree.stree[ROOT] != L2BPERDMAP) {
 			release_metapage(mp);
 			jfs_error(bmp->db_ipbmap->i_sb,
-				  "dbAllocCtl: the dmap is not all free");
+				  "the dmap is not all free\n");
 			rc = -EIO;
 			goto backout;
 		}
@@ -1953,7 +1942,7 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 			 * to indicate that we have leaked blocks.
 			 */
 			jfs_error(bmp->db_ipbmap->i_sb,
-				  "dbAllocCtl: I/O Error: Block Leakage.");
+				  "I/O Error: Block Leakage\n");
 			continue;
 		}
 		dp = (struct dmap *) mp->data;
@@ -1965,8 +1954,7 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 			 * to indicate that we have leaked blocks.
 			 */
 			release_metapage(mp);
-			jfs_error(bmp->db_ipbmap->i_sb,
-				  "dbAllocCtl: Block Leakage.");
+			jfs_error(bmp->db_ipbmap->i_sb, "Block Leakage\n");
 			continue;
 		}
 
@@ -2263,8 +2251,7 @@ static void dbAllocBits(struct bmap * bmp, struct dmap * dp, s64 blkno,
 			for (; nwords > 0; nwords -= nw) {
 				if (leaf[word] < BUDMIN) {
 					jfs_error(bmp->db_ipbmap->i_sb,
-						  "dbAllocBits: leaf page "
-						  "corrupt");
+						  "leaf page corrupt\n");
 					break;
 				}
 
@@ -2536,8 +2523,7 @@ dbAdjCtl(struct bmap * bmp, s64 blkno, int newval, int alloc, int level)
 	dcp = (struct dmapctl *) mp->data;
 
 	if (dcp->leafidx != cpu_to_le32(CTLLEAFIND)) {
-		jfs_error(bmp->db_ipbmap->i_sb,
-			  "dbAdjCtl: Corrupt dmapctl page");
+		jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmapctl page\n");
 		release_metapage(mp);
 		return -EIO;
 	}
@@ -2638,8 +2624,7 @@ dbAdjCtl(struct bmap * bmp, s64 blkno, int newval, int alloc, int level)
 			assert(level == bmp->db_maxlevel);
 			if (bmp->db_maxfreebud != oldroot) {
 				jfs_error(bmp->db_ipbmap->i_sb,
-					  "dbAdjCtl: the maximum free buddy is "
-					  "not the old root");
+					  "the maximum free buddy is not the old root\n");
 			}
 			bmp->db_maxfreebud = dcp->stree[ROOT];
 		}
@@ -3481,7 +3466,7 @@ int dbExtendFS(struct inode *ipbmap, s64 blkno,	s64 nblocks)
 	p = BMAPBLKNO + nbperpage;	/* L2 page */
 	l2mp = read_metapage(ipbmap, p, PSIZE, 0);
 	if (!l2mp) {
-		jfs_error(ipbmap->i_sb, "dbExtendFS: L2 page could not be read");
+		jfs_error(ipbmap->i_sb, "L2 page could not be read\n");
 		return -EIO;
 	}
 	l2dcp = (struct dmapctl *) l2mp->data;
@@ -3646,8 +3631,7 @@ int dbExtendFS(struct inode *ipbmap, s64 blkno,	s64 nblocks)
 		}
 	}			/* for each L1 in a L2 */
 
-	jfs_error(ipbmap->i_sb,
-		  "dbExtendFS: function has not returned as expected");
+	jfs_error(ipbmap->i_sb, "function has not returned as expected\n");
 errout:
 	if (l0mp)
 		release_metapage(l0mp);
@@ -3717,7 +3701,7 @@ void dbFinalizeBmap(struct inode *ipbmap)
 		}
 		if (bmp->db_agpref >= bmp->db_numag) {
 			jfs_error(ipbmap->i_sb,
-				  "cannot find ag with average freespace");
+				  "cannot find ag with average freespace\n");
 		}
 	}
 
diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index 0ddbece..c89424e 100644
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
+			jfs_error((IP)->i_sb,				\
+				  "DT_GETPAGE: dtree page corrupt\n");	\
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
+			jfs_error(sb, "stack overrun!\n");
 			BT_STACK_DUMP(btstack);
 			rc = -EIO;
 			goto out;
@@ -3252,8 +3252,7 @@ int jfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 				/* Sanity Check */
 				if (d_namleft == 0) {
 					jfs_error(ip->i_sb,
-						  "JFS:Dtree error: ino = "
-						  "%ld, bn=%Ld, index = %d",
+						  "JFS:Dtree error: ino = %ld, bn=%lld, index = %d\n",
 						  (long)ip->i_ino,
 						  (long long)bn,
 						  i);
@@ -3373,7 +3372,7 @@ static int dtReadFirst(struct inode *ip, struct btstack * btstack)
 		 */
 		if (BT_STACK_FULL(btstack)) {
 			DT_PUTPAGE(mp);
-			jfs_error(ip->i_sb, "dtReadFirst: btstack overrun");
+			jfs_error(ip->i_sb, "btstack overrun\n");
 			BT_STACK_DUMP(btstack);
 			return -EIO;
 		}
diff --git a/fs/jfs/jfs_extent.c b/fs/jfs/jfs_extent.c
index e5fe850..2ae7d59 100644
--- a/fs/jfs/jfs_extent.c
+++ b/fs/jfs/jfs_extent.c
@@ -388,7 +388,7 @@ int extHint(struct inode *ip, s64 offset, xad_t * xp)
 
 	if ((rc == 0) && xlen) {
 		if (xlen != nbperpage) {
-			jfs_error(ip->i_sb, "extHint: corrupt xtree");
+			jfs_error(ip->i_sb, "corrupt xtree\n");
 			rc = -EIO;
 		}
 		XADaddress(xp, xaddr);
diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
index f7e042b..f321986 100644
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -386,7 +386,7 @@ int diRead(struct inode *ip)
 	dp += rel_inode;
 
 	if (ip->i_ino != le32_to_cpu(dp->di_number)) {
-		jfs_error(ip->i_sb, "diRead: i_ino != di_number");
+		jfs_error(ip->i_sb, "i_ino != di_number\n");
 		rc = -EIO;
 	} else if (le32_to_cpu(dp->di_nlink) == 0)
 		rc = -ESTALE;
@@ -625,7 +625,7 @@ int diWrite(tid_t tid, struct inode *ip)
 	if (!addressPXD(&(jfs_ip->ixpxd)) ||
 	    (lengthPXD(&(jfs_ip->ixpxd)) !=
 	     JFS_IP(ipimap)->i_imap->im_nbperiext)) {
-		jfs_error(ip->i_sb, "diWrite: ixpxd invalid");
+		jfs_error(ip->i_sb, "ixpxd invalid\n");
 		return -EIO;
 	}
 
@@ -893,8 +893,7 @@ int diFree(struct inode *ip)
 	if (iagno >= imap->im_nextiag) {
 		print_hex_dump(KERN_ERR, "imap: ", DUMP_PREFIX_ADDRESS, 16, 4,
 			       imap, 32, 0);
-		jfs_error(ip->i_sb,
-			  "diFree: inum = %d, iagno = %d, nextiag = %d",
+		jfs_error(ip->i_sb, "inum = %d, iagno = %d, nextiag = %d\n",
 			  (uint) inum, iagno, imap->im_nextiag);
 		return -EIO;
 	}
@@ -930,15 +929,14 @@ int diFree(struct inode *ip)
 	mask = HIGHORDER >> bitno;
 
 	if (!(le32_to_cpu(iagp->wmap[extno]) & mask)) {
-		jfs_error(ip->i_sb,
-			  "diFree: wmap shows inode already free");
+		jfs_error(ip->i_sb, "wmap shows inode already free\n");
 	}
 
 	if (!addressPXD(&iagp->inoext[extno])) {
 		release_metapage(mp);
 		IREAD_UNLOCK(ipimap);
 		AG_UNLOCK(imap, agno);
-		jfs_error(ip->i_sb, "diFree: invalid inoext");
+		jfs_error(ip->i_sb, "invalid inoext\n");
 		return -EIO;
 	}
 
@@ -950,7 +948,7 @@ int diFree(struct inode *ip)
 		release_metapage(mp);
 		IREAD_UNLOCK(ipimap);
 		AG_UNLOCK(imap, agno);
-		jfs_error(ip->i_sb, "diFree: numfree > numinos");
+		jfs_error(ip->i_sb, "numfree > numinos\n");
 		return -EIO;
 	}
 	/*
@@ -1199,7 +1197,7 @@ int diFree(struct inode *ip)
 	 * for the inode being freed.
 	 */
 	if (iagp->pmap[extno] != 0) {
-		jfs_error(ip->i_sb, "diFree: the pmap does not show inode free");
+		jfs_error(ip->i_sb, "the pmap does not show inode free\n");
 	}
 	iagp->wmap[extno] = 0;
 	PXDlength(&iagp->inoext[extno], 0);
@@ -1518,8 +1516,7 @@ int diAlloc(struct inode *pip, bool dir, struct inode *ip)
 					release_metapage(mp);
 					AG_UNLOCK(imap, agno);
 					jfs_error(ip->i_sb,
-						  "diAlloc: can't find free bit "
-						  "in wmap");
+						  "can't find free bit in wmap\n");
 					return -EIO;
 				}
 
@@ -1660,7 +1657,7 @@ diAllocAG(struct inomap * imap, int agno, bool dir, struct inode *ip)
 	numinos = imap->im_agctl[agno].numinos;
 
 	if (numfree > numinos) {
-		jfs_error(ip->i_sb, "diAllocAG: numfree > numinos");
+		jfs_error(ip->i_sb, "numfree > numinos\n");
 		return -EIO;
 	}
 
@@ -1811,8 +1808,7 @@ static int diAllocIno(struct inomap * imap, int agno, struct inode *ip)
 	if (!iagp->nfreeinos) {
 		IREAD_UNLOCK(imap->im_ipimap);
 		release_metapage(mp);
-		jfs_error(ip->i_sb,
-			  "diAllocIno: nfreeinos = 0, but iag on freelist");
+		jfs_error(ip->i_sb, "nfreeinos = 0, but iag on freelist\n");
 		return -EIO;
 	}
 
@@ -1824,7 +1820,7 @@ static int diAllocIno(struct inomap * imap, int agno, struct inode *ip)
 			IREAD_UNLOCK(imap->im_ipimap);
 			release_metapage(mp);
 			jfs_error(ip->i_sb,
-				  "diAllocIno: free inode not found in summary map");
+				  "free inode not found in summary map\n");
 			return -EIO;
 		}
 
@@ -1839,7 +1835,7 @@ static int diAllocIno(struct inomap * imap, int agno, struct inode *ip)
 	if (rem >= EXTSPERSUM) {
 		IREAD_UNLOCK(imap->im_ipimap);
 		release_metapage(mp);
-		jfs_error(ip->i_sb, "diAllocIno: no free extent found");
+		jfs_error(ip->i_sb, "no free extent found\n");
 		return -EIO;
 	}
 	extno = (sword << L2EXTSPERSUM) + rem;
@@ -1850,7 +1846,7 @@ static int diAllocIno(struct inomap * imap, int agno, struct inode *ip)
 	if (rem >= INOSPEREXT) {
 		IREAD_UNLOCK(imap->im_ipimap);
 		release_metapage(mp);
-		jfs_error(ip->i_sb, "diAllocIno: free inode not found");
+		jfs_error(ip->i_sb, "free inode not found\n");
 		return -EIO;
 	}
 
@@ -1936,7 +1932,7 @@ static int diAllocExt(struct inomap * imap, int agno, struct inode *ip)
 		IREAD_LOCK(imap->im_ipimap, RDWRLOCK_IMAP);
 		if ((rc = diIAGRead(imap, iagno, &mp))) {
 			IREAD_UNLOCK(imap->im_ipimap);
-			jfs_error(ip->i_sb, "diAllocExt: error reading iag");
+			jfs_error(ip->i_sb, "error reading iag\n");
 			return rc;
 		}
 		iagp = (struct iag *) mp->data;
@@ -1948,8 +1944,7 @@ static int diAllocExt(struct inomap * imap, int agno, struct inode *ip)
 		if (sword >= SMAPSZ) {
 			release_metapage(mp);
 			IREAD_UNLOCK(imap->im_ipimap);
-			jfs_error(ip->i_sb,
-				  "diAllocExt: free ext summary map not found");
+			jfs_error(ip->i_sb, "free ext summary map not found\n");
 			return -EIO;
 		}
 		if (~iagp->extsmap[sword])
@@ -1962,7 +1957,7 @@ static int diAllocExt(struct inomap * imap, int agno, struct inode *ip)
 	if (rem >= EXTSPERSUM) {
 		release_metapage(mp);
 		IREAD_UNLOCK(imap->im_ipimap);
-		jfs_error(ip->i_sb, "diAllocExt: free extent not found");
+		jfs_error(ip->i_sb, "free extent not found\n");
 		return -EIO;
 	}
 	extno = (sword << L2EXTSPERSUM) + rem;
@@ -2081,8 +2076,7 @@ static int diAllocBit(struct inomap * imap, struct iag * iagp, int ino)
 		if (bmp)
 			release_metapage(bmp);
 
-		jfs_error(imap->im_ipimap->i_sb,
-			  "diAllocBit: iag inconsistent");
+		jfs_error(imap->im_ipimap->i_sb, "iag inconsistent\n");
 		return -EIO;
 	}
 
@@ -2189,7 +2183,7 @@ static int diNewExt(struct inomap * imap, struct iag * iagp, int extno)
 	/* better have free extents.
 	 */
 	if (!iagp->nfreeexts) {
-		jfs_error(imap->im_ipimap->i_sb, "diNewExt: no free extents");
+		jfs_error(imap->im_ipimap->i_sb, "no free extents\n");
 		return -EIO;
 	}
 
@@ -2261,7 +2255,7 @@ static int diNewExt(struct inomap * imap, struct iag * iagp, int extno)
 			}
 			if (ciagp == NULL) {
 				jfs_error(imap->im_ipimap->i_sb,
-					  "diNewExt: ciagp == NULL");
+					  "ciagp == NULL\n");
 				rc = -EIO;
 				goto error_out;
 			}
@@ -2498,7 +2492,7 @@ diNewIAG(struct inomap * imap, int *iagnop, int agno, struct metapage ** mpp)
 			IWRITE_UNLOCK(ipimap);
 			IAGFREE_UNLOCK(imap);
 			jfs_error(imap->im_ipimap->i_sb,
-				  "diNewIAG: ipimap->i_size is wrong");
+				  "ipimap->i_size is wrong\n");
 			return -EIO;
 		}
 
@@ -2758,8 +2752,7 @@ diUpdatePMap(struct inode *ipimap,
 	iagno = INOTOIAG(inum);
 	/* make sure that the iag is contained within the map */
 	if (iagno >= imap->im_nextiag) {
-		jfs_error(ipimap->i_sb,
-			  "diUpdatePMap: the iag is outside the map");
+		jfs_error(ipimap->i_sb, "the iag is outside the map\n");
 		return -EIO;
 	}
 	/* read the iag */
@@ -2788,13 +2781,13 @@ diUpdatePMap(struct inode *ipimap,
 		 */
 		if (!(le32_to_cpu(iagp->wmap[extno]) & mask)) {
 			jfs_error(ipimap->i_sb,
-				  "diUpdatePMap: inode %ld not marked as "
-				  "allocated in wmap!", inum);
+				  "inode %ld not marked as allocated in wmap!\n",
+				  inum);
 		}
 		if (!(le32_to_cpu(iagp->pmap[extno]) & mask)) {
 			jfs_error(ipimap->i_sb,
-				  "diUpdatePMap: inode %ld not marked as "
-				  "allocated in pmap!", inum);
+				  "inode %ld not marked as allocated in pmap!\n",
+				  inum);
 		}
 		/* update the bitmap for the extent of the freed inode */
 		iagp->pmap[extno] &= cpu_to_le32(~mask);
@@ -2809,15 +2802,13 @@ diUpdatePMap(struct inode *ipimap,
 		if (!(le32_to_cpu(iagp->wmap[extno]) & mask)) {
 			release_metapage(mp);
 			jfs_error(ipimap->i_sb,
-				  "diUpdatePMap: the inode is not allocated in "
-				  "the working map");
+				  "the inode is not allocated in the working map\n");
 			return -EIO;
 		}
 		if ((le32_to_cpu(iagp->pmap[extno]) & mask) != 0) {
 			release_metapage(mp);
 			jfs_error(ipimap->i_sb,
-				  "diUpdatePMap: the inode is not free in the "
-				  "persistent map");
+				  "the inode is not free in the persistent map\n");
 			return -EIO;
 		}
 		/* update the bitmap for the extent of the allocated inode */
@@ -2909,8 +2900,7 @@ int diExtendFS(struct inode *ipimap, struct inode *ipbmap)
 		iagp = (struct iag *) bp->data;
 		if (le32_to_cpu(iagp->iagnum) != i) {
 			release_metapage(bp);
-			jfs_error(ipimap->i_sb,
-				  "diExtendFs: unexpected value of iagnum");
+			jfs_error(ipimap->i_sb, "unexpected value of iagnum\n");
 			return -EIO;
 		}
 
@@ -2986,8 +2976,7 @@ int diExtendFS(struct inode *ipimap, struct inode *ipbmap)
 
 	if (xnuminos != atomic_read(&imap->im_numinos) ||
 	    xnumfree != atomic_read(&imap->im_numfree)) {
-		jfs_error(ipimap->i_sb,
-			  "diExtendFs: numinos or numfree incorrect");
+		jfs_error(ipimap->i_sb, "numinos or numfree incorrect\n");
 		return -EIO;
 	}
 
diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
index de87794..f14f54f 100644
--- a/fs/jfs/jfs_metapage.c
+++ b/fs/jfs/jfs_metapage.c
@@ -649,7 +649,7 @@ struct metapage *__get_metapage(struct inode *inode, unsigned long lblock,
 	if (mp) {
 		if (mp->logical_size != size) {
 			jfs_error(inode->i_sb,
-				  "__get_metapage: mp->logical_size != size");
+				  "get_mp->logical_size != size\n");
 			jfs_err("logical_size = %d, size = %d",
 				mp->logical_size, size);
 			dump_stack();
@@ -660,8 +660,7 @@ struct metapage *__get_metapage(struct inode *inode, unsigned long lblock,
 		if (test_bit(META_discard, &mp->flag)) {
 			if (!new) {
 				jfs_error(inode->i_sb,
-					  "__get_metapage: using a "
-					  "discarded metapage");
+					  "using a discarded metapage\n");
 				discard_metapage(mp);
 				goto unlock;
 			}
diff --git a/fs/jfs/jfs_superblock.h b/fs/jfs/jfs_superblock.h
index 884fc21..04847b8 100644
--- a/fs/jfs/jfs_superblock.h
+++ b/fs/jfs/jfs_superblock.h
@@ -108,6 +108,7 @@ struct jfs_superblock {
 
 extern int readSuper(struct super_block *, struct buffer_head **);
 extern int updateSuper(struct super_block *, uint);
+__printf(2, 3)
 extern void jfs_error(struct super_block *, const char *, ...);
 extern int jfs_mount(struct super_block *);
 extern int jfs_mount_rw(struct super_block *, int);
diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
index 5fcc02e..564c4f2 100644
--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -2684,7 +2684,7 @@ void txAbort(tid_t tid, int dirty)
 	 * mark filesystem dirty
 	 */
 	if (dirty)
-		jfs_error(tblk->sb, "txAbort");
+		jfs_error(tblk->sb, "\n");
 
 	return;
 }
diff --git a/fs/jfs/jfs_xtree.c b/fs/jfs/jfs_xtree.c
index 6c50871..5ad7748 100644
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
+			jfs_error((IP)->i_sb,				\
+				  "XT_GETPAGE: xtree page corrupt\n");	\
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
+			jfs_error(ip->i_sb, "stack overrun!\n");
 			XT_PUTPAGE(mp);
 			return -EIO;
 		}
@@ -1385,7 +1386,7 @@ int xtExtend(tid_t tid,		/* transaction id */
 
 	if (cmp != 0) {
 		XT_PUTPAGE(mp);
-		jfs_error(ip->i_sb, "xtExtend: xtSearch did not find extent");
+		jfs_error(ip->i_sb, "xtSearch did not find extent\n");
 		return -EIO;
 	}
 
@@ -1393,7 +1394,7 @@ int xtExtend(tid_t tid,		/* transaction id */
 	xad = &p->xad[index];
 	if ((offsetXAD(xad) + lengthXAD(xad)) != xoff) {
 		XT_PUTPAGE(mp);
-		jfs_error(ip->i_sb, "xtExtend: extension is not contiguous");
+		jfs_error(ip->i_sb, "extension is not contiguous\n");
 		return -EIO;
 	}
 
@@ -1552,7 +1553,7 @@ printf("xtTailgate: nxoff:0x%lx nxlen:0x%x nxaddr:0x%lx\n",
 
 	if (cmp != 0) {
 		XT_PUTPAGE(mp);
-		jfs_error(ip->i_sb, "xtTailgate: couldn't find extent");
+		jfs_error(ip->i_sb, "couldn't find extent\n");
 		return -EIO;
 	}
 
@@ -1560,8 +1561,7 @@ printf("xtTailgate: nxoff:0x%lx nxlen:0x%x nxaddr:0x%lx\n",
 	nextindex = le16_to_cpu(p->header.nextindex);
 	if (index != nextindex - 1) {
 		XT_PUTPAGE(mp);
-		jfs_error(ip->i_sb,
-			  "xtTailgate: the entry found is not the last entry");
+		jfs_error(ip->i_sb, "the entry found is not the last entry\n");
 		return -EIO;
 	}
 
@@ -1734,7 +1734,7 @@ int xtUpdate(tid_t tid, struct inode *ip, xad_t * nxad)
 
 	if (cmp != 0) {
 		XT_PUTPAGE(mp);
-		jfs_error(ip->i_sb, "xtUpdate: Could not find extent");
+		jfs_error(ip->i_sb, "Could not find extent\n");
 		return -EIO;
 	}
 
@@ -1758,7 +1758,7 @@ int xtUpdate(tid_t tid, struct inode *ip, xad_t * nxad)
 	    (nxoff + nxlen > xoff + xlen)) {
 		XT_PUTPAGE(mp);
 		jfs_error(ip->i_sb,
-			  "xtUpdate: nXAD in not completely contained within XAD");
+			  "nXAD in not completely contained within XAD\n");
 		return -EIO;
 	}
 
@@ -1907,7 +1907,7 @@ int xtUpdate(tid_t tid, struct inode *ip, xad_t * nxad)
 
 	if (xoff >= nxoff) {
 		XT_PUTPAGE(mp);
-		jfs_error(ip->i_sb, "xtUpdate: xoff >= nxoff");
+		jfs_error(ip->i_sb, "xoff >= nxoff\n");
 		return -EIO;
 	}
 /* #endif _JFS_WIP_COALESCE */
@@ -2048,14 +2048,13 @@ int xtUpdate(tid_t tid, struct inode *ip, xad_t * nxad)
 
 		if (cmp != 0) {
 			XT_PUTPAGE(mp);
-			jfs_error(ip->i_sb, "xtUpdate: xtSearch failed");
+			jfs_error(ip->i_sb, "xtSearch failed\n");
 			return -EIO;
 		}
 
 		if (index0 != index) {
 			XT_PUTPAGE(mp);
-			jfs_error(ip->i_sb,
-				  "xtUpdate: unexpected value of index");
+			jfs_error(ip->i_sb, "unexpected value of index\n");
 			return -EIO;
 		}
 	}
@@ -3650,7 +3649,7 @@ s64 xtTruncate(tid_t tid, struct inode *ip, s64 newsize, int flag)
       getChild:
 	/* save current parent entry for the child page */
 	if (BT_STACK_FULL(&btstack)) {
-		jfs_error(ip->i_sb, "stack overrun in xtTruncate!");
+		jfs_error(ip->i_sb, "stack overrun!\n");
 		XT_PUTPAGE(mp);
 		return -EIO;
 	}
@@ -3751,8 +3750,7 @@ s64 xtTruncate_pmap(tid_t tid, struct inode *ip, s64 committed_size)
 
 		if (cmp != 0) {
 			XT_PUTPAGE(mp);
-			jfs_error(ip->i_sb,
-				  "xtTruncate_pmap: did not find extent");
+			jfs_error(ip->i_sb, "did not find extent\n");
 			return -EIO;
 		}
 	} else {
@@ -3851,7 +3849,7 @@ s64 xtTruncate_pmap(tid_t tid, struct inode *ip, s64 committed_size)
       getChild:
 	/* save current parent entry for the child page */
 	if (BT_STACK_FULL(&btstack)) {
-		jfs_error(ip->i_sb, "stack overrun in xtTruncate_pmap!");
+		jfs_error(ip->i_sb, "stack overrun!\n");
 		XT_PUTPAGE(mp);
 		return -EIO;
 	}
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 3b91a7a..eb9799b 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -1176,7 +1176,7 @@ static int jfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 				if (!S_ISDIR(old_ip->i_mode) && new_ip)
 					IWRITE_UNLOCK(new_ip);
 				jfs_error(new_ip->i_sb,
-					  "jfs_rename: new_ip->i_nlink != 0");
+					  "new_ip->i_nlink != 0\n");
 				return -EIO;
 			}
 			tblk = tid_to_tblock(tid);
diff --git a/fs/jfs/resize.c b/fs/jfs/resize.c
index 8d0c1c7..90b3bc2 100644
--- a/fs/jfs/resize.c
+++ b/fs/jfs/resize.c
@@ -530,7 +530,7 @@ int jfs_extendfs(struct super_block *sb, s64 newLVSize, int newLogSize)
 	goto resume;
 
       error_out:
-	jfs_error(sb, "jfs_extendfs");
+	jfs_error(sb, "\n");
 
       resume:
 	/*
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 788e0a9..6669aa2 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -92,16 +92,20 @@ static void jfs_handle_error(struct super_block *sb)
 	/* nothing is done for continue beyond marking the superblock dirty */
 }
 
-void jfs_error(struct super_block *sb, const char * function, ...)
+void jfs_error(struct super_block *sb, const char *fmt, ...)
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
+			jfs_error(sb, "lmLogShutdown failed\n");
 
 			/* let operations fail rather than hang */
 			txResume(sb);
@@ -646,12 +650,12 @@ static int jfs_unfreeze(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY)) {
 		rc = updateSuper(sb, FM_MOUNT);
 		if (rc) {
-			jfs_error(sb, "jfs_unfreeze: updateSuper failed");
+			jfs_error(sb, "updateSuper failed\n");
 			goto out;
 		}
 		rc = lmLogInit(log);
 		if (rc)
-			jfs_error(sb, "jfs_unfreeze: lmLogInit failed");
+			jfs_error(sb, "lmLogInit failed\n");
 out:
 		txResume(sb);
 	}
diff --git a/fs/jfs/xattr.c b/fs/jfs/xattr.c
index 42d67f9..51cc4bc 100644
--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -382,7 +382,7 @@ static int ea_read(struct inode *ip, struct jfs_ea_list *ealist)
 
 	nbytes = sizeDXD(&ji->ea);
 	if (!nbytes) {
-		jfs_error(sb, "ea_read: nbytes is 0");
+		jfs_error(sb, "nbytes is 0\n");
 		return -EIO;
 	}
 
@@ -482,7 +482,7 @@ static int ea_get(struct inode *inode, struct ea_buffer *ea_buf, int min_size)
 		current_blocks = 0;
 	} else {
 		if (!(ji->ea.flag & DXD_EXTENT)) {
-			jfs_error(sb, "ea_get: invalid ea.flag)");
+			jfs_error(sb, "invalid ea.flag\n");
 			return -EIO;
 		}
 		current_blocks = (ea_size + sb->s_blocksize - 1) >>
-- 
1.8.1.2.459.gbcd45b4.dirty

