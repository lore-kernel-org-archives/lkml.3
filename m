Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaCLU1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 16:27:49 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:5574 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751230AbaCLU1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 16:27:47 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnIWAF7CIFNbskZu/2dsb2JhbABagwY7qTGYeQICgR8XdIJGAQwTDQ8jGIECJBOHfQG1T51QjlyEPwSYRAGSLYE/gW88
Date: Wed, 12 Mar 2014 21:29:18 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>
Subject: [PATCH v2] BEFS: Logging clean-up
Message-Id: <20140312212918.fadbc4a191d84f100c45adb5@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-All printk(KERN_foo converted to pr_foo().
-Add pr_fmt and remove redundant prefixes.
-Convert befs_() to va_format (based on patch by Joe Perches).
-Remove non standard %Lu.
-Use __func__ for all debugging.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/befs/Makefile     |   2 +-
 fs/befs/befs.h       |   3 ++
 fs/befs/btree.c      |  89 +++++++++++++++++++++---------------------
 fs/befs/datastream.c |  87 ++++++++++++++++++++++--------------------
 fs/befs/debug.c      |  74 ++++++++++++-----------------------
 fs/befs/inode.c      |  10 +++--
 fs/befs/io.c         |  24 ++++++------
 fs/befs/linuxvfs.c   | 106 ++++++++++++++++++++++++++-------------------------
 8 files changed, 193 insertions(+), 202 deletions(-)

diff --git a/fs/befs/Makefile b/fs/befs/Makefile
index 2f370bd..8b9f666 100644
--- a/fs/befs/Makefile
+++ b/fs/befs/Makefile
@@ -3,5 +3,5 @@
 #
  
 obj-$(CONFIG_BEFS_FS) += befs.o
-
+ccflags-$(CONFIG_BEFS_DEBUG)    += -DDEBUG
 befs-objs := datastream.o btree.o super.o inode.o debug.o io.o linuxvfs.o
diff --git a/fs/befs/befs.h b/fs/befs/befs.h
index b266428..3a7813a 100644
--- a/fs/befs/befs.h
+++ b/fs/befs/befs.h
@@ -88,8 +88,11 @@ enum befs_err {
 
 /****************************/
 /* debug.c */
+__printf(2, 3)
 void befs_error(const struct super_block *sb, const char *fmt, ...);
+__printf(2, 3)
 void befs_warning(const struct super_block *sb, const char *fmt, ...);
+__printf(2, 3)
 void befs_debug(const struct super_block *sb, const char *fmt, ...);
 
 void befs_dump_super_block(const struct super_block *sb, befs_super_block *);
diff --git a/fs/befs/btree.c b/fs/befs/btree.c
index 74e397d..88db3c8 100644
--- a/fs/befs/btree.c
+++ b/fs/befs/btree.c
@@ -137,7 +137,7 @@ befs_bt_read_super(struct super_block *sb, befs_data_stream * ds,
 	struct buffer_head *bh = NULL;
 	befs_disk_btree_super *od_sup = NULL;
 
-	befs_debug(sb, "---> befs_btree_read_super()");
+	befs_debug(sb, "---> %s", __func__);
 
 	bh = befs_read_datastream(sb, ds, 0, NULL);
 
@@ -162,11 +162,11 @@ befs_bt_read_super(struct super_block *sb, befs_data_stream * ds,
 		goto error;
 	}
 
-	befs_debug(sb, "<--- befs_btree_read_super()");
+	befs_debug(sb, "<--- %s", __func__);
 	return BEFS_OK;
 
       error:
-	befs_debug(sb, "<--- befs_btree_read_super() ERROR");
+	befs_debug(sb, "<--- %s ERROR", __func__);
 	return BEFS_ERR;
 }
 
@@ -195,16 +195,16 @@ befs_bt_read_node(struct super_block *sb, befs_data_stream * ds,
 {
 	uint off = 0;
 
-	befs_debug(sb, "---> befs_bt_read_node()");
+	befs_debug(sb, "---> %s", __func__);
 
 	if (node->bh)
 		brelse(node->bh);
 
 	node->bh = befs_read_datastream(sb, ds, node_off, &off);
 	if (!node->bh) {
-		befs_error(sb, "befs_bt_read_node() failed to read "
-			   "node at %Lu", node_off);
-		befs_debug(sb, "<--- befs_bt_read_node() ERROR");
+		befs_error(sb, "%s failed to read "
+			   "node at %llu", __func__, node_off);
+		befs_debug(sb, "<--- %s ERROR", __func__);
 
 		return BEFS_ERR;
 	}
@@ -221,7 +221,7 @@ befs_bt_read_node(struct super_block *sb, befs_data_stream * ds,
 	node->head.all_key_length =
 	    fs16_to_cpu(sb, node->od_node->all_key_length);
 
-	befs_debug(sb, "<--- befs_btree_read_node()");
+	befs_debug(sb, "<--- %s", __func__);
 	return BEFS_OK;
 }
 
@@ -252,7 +252,7 @@ befs_btree_find(struct super_block *sb, befs_data_stream * ds,
 	befs_off_t node_off;
 	int res;
 
-	befs_debug(sb, "---> befs_btree_find() Key: %s", key);
+	befs_debug(sb, "---> %s Key: %s", __func__, key);
 
 	if (befs_bt_read_super(sb, ds, &bt_super) != BEFS_OK) {
 		befs_error(sb,
@@ -274,7 +274,7 @@ befs_btree_find(struct super_block *sb, befs_data_stream * ds,
 	node_off = bt_super.root_node_ptr;
 	if (befs_bt_read_node(sb, ds, this_node, node_off) != BEFS_OK) {
 		befs_error(sb, "befs_btree_find() failed to read "
-			   "node at %Lu", node_off);
+			   "node at %llu", node_off);
 		goto error_alloc;
 	}
 
@@ -285,7 +285,7 @@ befs_btree_find(struct super_block *sb, befs_data_stream * ds,
 		/* if no match, go to overflow node */
 		if (befs_bt_read_node(sb, ds, this_node, node_off) != BEFS_OK) {
 			befs_error(sb, "befs_btree_find() failed to read "
-				   "node at %Lu", node_off);
+				   "node at %llu", node_off);
 			goto error_alloc;
 		}
 	}
@@ -298,11 +298,11 @@ befs_btree_find(struct super_block *sb, befs_data_stream * ds,
 	kfree(this_node);
 
 	if (res != BEFS_BT_MATCH) {
-		befs_debug(sb, "<--- befs_btree_find() Key %s not found", key);
+		befs_debug(sb, "<--- %s Key %s not found", __func__, key);
 		*value = 0;
 		return BEFS_BT_NOT_FOUND;
 	}
-	befs_debug(sb, "<--- befs_btree_find() Found key %s, value %Lu",
+	befs_debug(sb, "<--- %s Found key %s, value %llu", __func__,
 		   key, *value);
 	return BEFS_OK;
 
@@ -310,7 +310,7 @@ befs_btree_find(struct super_block *sb, befs_data_stream * ds,
 	kfree(this_node);
       error:
 	*value = 0;
-	befs_debug(sb, "<--- befs_btree_find() ERROR");
+	befs_debug(sb, "<--- %s ERROR", __func__);
 	return BEFS_ERR;
 }
 
@@ -343,7 +343,7 @@ befs_find_key(struct super_block *sb, befs_btree_node * node,
 	char *thiskey;
 	fs64 *valarray;
 
-	befs_debug(sb, "---> befs_find_key() %s", findkey);
+	befs_debug(sb, "---> %s %s", __func__, findkey);
 
 	*value = 0;
 
@@ -355,7 +355,7 @@ befs_find_key(struct super_block *sb, befs_btree_node * node,
 
 	eq = befs_compare_strings(thiskey, keylen, findkey, findkey_len);
 	if (eq < 0) {
-		befs_debug(sb, "<--- befs_find_key() %s not found", findkey);
+		befs_debug(sb, "<--- %s %s not found", __func__, findkey);
 		return BEFS_BT_NOT_FOUND;
 	}
 
@@ -373,8 +373,8 @@ befs_find_key(struct super_block *sb, befs_btree_node * node,
 					  findkey_len);
 
 		if (eq == 0) {
-			befs_debug(sb, "<--- befs_find_key() found %s at %d",
-				   thiskey, mid);
+			befs_debug(sb, "<--- %s found %s at %d",
+				   __func__, thiskey, mid);
 
 			*value = fs64_to_cpu(sb, valarray[mid]);
 			return BEFS_BT_MATCH;
@@ -388,7 +388,7 @@ befs_find_key(struct super_block *sb, befs_btree_node * node,
 		*value = fs64_to_cpu(sb, valarray[mid + 1]);
 	else
 		*value = fs64_to_cpu(sb, valarray[mid]);
-	befs_debug(sb, "<--- befs_find_key() found %s at %d", thiskey, mid);
+	befs_debug(sb, "<--- %s found %s at %d", __func__, thiskey, mid);
 	return BEFS_BT_PARMATCH;
 }
 
@@ -428,7 +428,7 @@ befs_btree_read(struct super_block *sb, befs_data_stream * ds,
 
 	uint key_sum = 0;
 
-	befs_debug(sb, "---> befs_btree_read()");
+	befs_debug(sb, "---> %s", __func__);
 
 	if (befs_bt_read_super(sb, ds, &bt_super) != BEFS_OK) {
 		befs_error(sb,
@@ -452,7 +452,7 @@ befs_btree_read(struct super_block *sb, befs_data_stream * ds,
 		kfree(this_node);
 		*value = 0;
 		*keysize = 0;
-		befs_debug(sb, "<--- befs_btree_read() Tree is EMPTY");
+		befs_debug(sb, "<--- %s Tree is EMPTY", __func__);
 		return BEFS_BT_EMPTY;
 	} else if (res == BEFS_ERR) {
 		goto error_alloc;
@@ -467,7 +467,8 @@ befs_btree_read(struct super_block *sb, befs_data_stream * ds,
 			*keysize = 0;
 			*value = 0;
 			befs_debug(sb,
-				   "<--- befs_btree_read() END of keys at %Lu",
+				   "<--- %s END of keys at %llu", __func__,
+				   (unsigned long long)
 				   key_sum + this_node->head.all_key_count);
 			brelse(this_node->bh);
 			kfree(this_node);
@@ -478,8 +479,8 @@ befs_btree_read(struct super_block *sb, befs_data_stream * ds,
 		node_off = this_node->head.right;
 
 		if (befs_bt_read_node(sb, ds, this_node, node_off) != BEFS_OK) {
-			befs_error(sb, "befs_btree_read() failed to read "
-				   "node at %Lu", node_off);
+			befs_error(sb, "%s failed to read node at %llu",
+				  __func__, (unsigned long long)node_off);
 			goto error_alloc;
 		}
 	}
@@ -492,11 +493,13 @@ befs_btree_read(struct super_block *sb, befs_data_stream * ds,
 
 	keystart = befs_bt_get_key(sb, this_node, cur_key, &keylen);
 
-	befs_debug(sb, "Read [%Lu,%d]: keysize %d", node_off, cur_key, keylen);
+	befs_debug(sb, "Read [%llu,%d]: keysize %d",
+		   (long long unsigned int)node_off, (int)cur_key,
+		   (int)keylen);
 
 	if (bufsize < keylen + 1) {
-		befs_error(sb, "befs_btree_read() keybuf too small (%u) "
-			   "for key of size %d", bufsize, keylen);
+		befs_error(sb, "%s keybuf too small (%u) "
+			   "for key of size %d", __func__, bufsize, keylen);
 		brelse(this_node->bh);
 		goto error_alloc;
 	};
@@ -506,13 +509,13 @@ befs_btree_read(struct super_block *sb, befs_data_stream * ds,
 	*keysize = keylen;
 	keybuf[keylen] = '\0';
 
-	befs_debug(sb, "Read [%Lu,%d]: Key \"%.*s\", Value %Lu", node_off,
+	befs_debug(sb, "Read [%llu,%d]: Key \"%.*s\", Value %llu", node_off,
 		   cur_key, keylen, keybuf, *value);
 
 	brelse(this_node->bh);
 	kfree(this_node);
 
-	befs_debug(sb, "<--- befs_btree_read()");
+	befs_debug(sb, "<--- %s", __func__);
 
 	return BEFS_OK;
 
@@ -522,7 +525,7 @@ befs_btree_read(struct super_block *sb, befs_data_stream * ds,
       error:
 	*keysize = 0;
 	*value = 0;
-	befs_debug(sb, "<--- befs_btree_read() ERROR");
+	befs_debug(sb, "<--- %s ERROR", __func__);
 	return BEFS_ERR;
 }
 
@@ -547,26 +550,26 @@ befs_btree_seekleaf(struct super_block *sb, befs_data_stream * ds,
 		    befs_off_t * node_off)
 {
 
-	befs_debug(sb, "---> befs_btree_seekleaf()");
+	befs_debug(sb, "---> %s", __func__);
 
 	if (befs_bt_read_node(sb, ds, this_node, *node_off) != BEFS_OK) {
-		befs_error(sb, "befs_btree_seekleaf() failed to read "
-			   "node at %Lu", *node_off);
+		befs_error(sb, "%s failed to read "
+			   "node at %llu", __func__, *node_off);
 		goto error;
 	}
-	befs_debug(sb, "Seekleaf to root node %Lu", *node_off);
+	befs_debug(sb, "Seekleaf to root node %llu", *node_off);
 
 	if (this_node->head.all_key_count == 0 && befs_leafnode(this_node)) {
-		befs_debug(sb, "<--- befs_btree_seekleaf() Tree is EMPTY");
+		befs_debug(sb, "<--- %s Tree is EMPTY", __func__);
 		return BEFS_BT_EMPTY;
 	}
 
 	while (!befs_leafnode(this_node)) {
 
 		if (this_node->head.all_key_count == 0) {
-			befs_debug(sb, "befs_btree_seekleaf() encountered "
-				   "an empty interior node: %Lu. Using Overflow "
-				   "node: %Lu", *node_off,
+			befs_debug(sb, "%s encountered "
+				   "an empty interior node: %llu. Using Overflow "
+				   "node: %llu", __func__, *node_off,
 				   this_node->head.overflow);
 			*node_off = this_node->head.overflow;
 		} else {
@@ -574,19 +577,19 @@ befs_btree_seekleaf(struct super_block *sb, befs_data_stream * ds,
 			*node_off = fs64_to_cpu(sb, valarray[0]);
 		}
 		if (befs_bt_read_node(sb, ds, this_node, *node_off) != BEFS_OK) {
-			befs_error(sb, "befs_btree_seekleaf() failed to read "
-				   "node at %Lu", *node_off);
+			befs_error(sb, "%s failed to read "
+				   "node at %llu", __func__, *node_off);
 			goto error;
 		}
 
-		befs_debug(sb, "Seekleaf to child node %Lu", *node_off);
+		befs_debug(sb, "Seekleaf to child node %llu", *node_off);
 	}
-	befs_debug(sb, "Node %Lu is a leaf node", *node_off);
+	befs_debug(sb, "Node %llu is a leaf node", *node_off);
 
 	return BEFS_OK;
 
       error:
-	befs_debug(sb, "<--- befs_btree_seekleaf() ERROR");
+	befs_debug(sb, "<--- %s ERROR", __func__);
 	return BEFS_ERR;
 }
 
diff --git a/fs/befs/datastream.c b/fs/befs/datastream.c
index 59096b5..c467beb 100644
--- a/fs/befs/datastream.c
+++ b/fs/befs/datastream.c
@@ -52,26 +52,25 @@ befs_read_datastream(struct super_block *sb, befs_data_stream * ds,
 	befs_block_run run;
 	befs_blocknr_t block;	/* block coresponding to pos */
 
-	befs_debug(sb, "---> befs_read_datastream() %Lu", pos);
+	befs_debug(sb, "---> %s %llu", __func__, pos);
 	block = pos >> BEFS_SB(sb)->block_shift;
 	if (off)
 		*off = pos - (block << BEFS_SB(sb)->block_shift);
 
 	if (befs_fblock2brun(sb, ds, block, &run) != BEFS_OK) {
 		befs_error(sb, "BeFS: Error finding disk addr of block %lu",
-			   block);
-		befs_debug(sb, "<--- befs_read_datastream() ERROR");
+			   (unsigned long)block);
+		befs_debug(sb, "<--- %s ERROR", __func__);
 		return NULL;
 	}
 	bh = befs_bread_iaddr(sb, run);
 	if (!bh) {
 		befs_error(sb, "BeFS: Error reading block %lu from datastream",
-			   block);
+			   (unsigned long)block);
 		return NULL;
 	}
 
-	befs_debug(sb, "<--- befs_read_datastream() read data, starting at %Lu",
-		   pos);
+	befs_debug(sb, "<--- %s read data, starting at %llu", __func__, pos);
 
 	return bh;
 }
@@ -106,7 +105,8 @@ befs_fblock2brun(struct super_block *sb, befs_data_stream * data,
 	} else {
 		befs_error(sb,
 			   "befs_fblock2brun() was asked to find block %lu, "
-			   "which is not mapped by the datastream\n", fblock);
+			   "which is not mapped by the datastream\n",
+			   (unsigned long)fblock);
 		err = BEFS_ERR;
 	}
 	return err;
@@ -128,14 +128,14 @@ befs_read_lsymlink(struct super_block * sb, befs_data_stream * ds, void *buff,
 	befs_off_t bytes_read = 0;	/* bytes readed */
 	u16 plen;
 	struct buffer_head *bh = NULL;
-	befs_debug(sb, "---> befs_read_lsymlink() length: %Lu", len);
+	befs_debug(sb, "---> %s length: %llu", __func__, len);
 
 	while (bytes_read < len) {
 		bh = befs_read_datastream(sb, ds, bytes_read, NULL);
 		if (!bh) {
 			befs_error(sb, "BeFS: Error reading datastream block "
-				   "starting from %Lu", bytes_read);
-			befs_debug(sb, "<--- befs_read_lsymlink() ERROR");
+				   "starting from %llu", bytes_read);
+			befs_debug(sb, "<--- %s ERROR", __func__);
 			return bytes_read;
 
 		}
@@ -146,7 +146,8 @@ befs_read_lsymlink(struct super_block * sb, befs_data_stream * ds, void *buff,
 		bytes_read += plen;
 	}
 
-	befs_debug(sb, "<--- befs_read_lsymlink() read %u bytes", bytes_read);
+	befs_debug(sb, "<--- %s read %u bytes", __func__, (unsigned int)
+		   bytes_read);
 	return bytes_read;
 }
 
@@ -169,7 +170,7 @@ befs_count_blocks(struct super_block * sb, befs_data_stream * ds)
 	befs_blocknr_t metablocks;	/* FS metadata blocks */
 	befs_sb_info *befs_sb = BEFS_SB(sb);
 
-	befs_debug(sb, "---> befs_count_blocks()");
+	befs_debug(sb, "---> %s", __func__);
 
 	datablocks = ds->size >> befs_sb->block_shift;
 	if (ds->size & (befs_sb->block_size - 1))
@@ -206,7 +207,7 @@ befs_count_blocks(struct super_block * sb, befs_data_stream * ds)
 	}
 
 	blocks = datablocks + metablocks;
-	befs_debug(sb, "<--- befs_count_blocks() %u blocks", blocks);
+	befs_debug(sb, "<--- %s %u blocks", __func__, (unsigned int)blocks);
 
 	return blocks;
 }
@@ -251,11 +252,11 @@ befs_find_brun_direct(struct super_block *sb, befs_data_stream * data,
 	befs_blocknr_t max_block =
 	    data->max_direct_range >> BEFS_SB(sb)->block_shift;
 
-	befs_debug(sb, "---> befs_find_brun_direct(), find %lu", blockno);
+	befs_debug(sb, "---> %s, find %lu", __func__, (unsigned long)blockno);
 
 	if (blockno > max_block) {
-		befs_error(sb, "befs_find_brun_direct() passed block outside of"
-			   "direct region");
+		befs_error(sb, "%s passed block outside of direct region",
+			   __func__);
 		return BEFS_ERR;
 	}
 
@@ -267,13 +268,14 @@ befs_find_brun_direct(struct super_block *sb, befs_data_stream * data,
 			run->start = array[i].start + offset;
 			run->len = array[i].len - offset;
 
-			befs_debug(sb, "---> befs_find_brun_direct(), "
-				   "found %lu at direct[%d]", blockno, i);
+			befs_debug(sb, "---> %s, "
+				   "found %lu at direct[%d]", __func__,
+				   (unsigned long)blockno, i);
 			return BEFS_OK;
 		}
 	}
 
-	befs_debug(sb, "---> befs_find_brun_direct() ERROR");
+	befs_debug(sb, "---> %s ERROR", __func__);
 	return BEFS_ERR;
 }
 
@@ -316,7 +318,7 @@ befs_find_brun_indirect(struct super_block *sb,
 	befs_blocknr_t indirblockno = iaddr2blockno(sb, &indirect);
 	int arraylen = befs_iaddrs_per_block(sb);
 
-	befs_debug(sb, "---> befs_find_brun_indirect(), find %lu", blockno);
+	befs_debug(sb, "---> %s, find %lu", __func__, (unsigned long)blockno);
 
 	indir_start_blk = data->max_direct_range >> BEFS_SB(sb)->block_shift;
 	search_blk = blockno - indir_start_blk;
@@ -325,10 +327,9 @@ befs_find_brun_indirect(struct super_block *sb,
 	for (i = 0; i < indirect.len; i++) {
 		indirblock = befs_bread(sb, indirblockno + i);
 		if (indirblock == NULL) {
-			befs_debug(sb,
-				   "---> befs_find_brun_indirect() failed to "
-				   "read disk block %lu from the indirect brun",
-				   indirblockno + i);
+			befs_debug(sb, "---> %s failed to read "
+				   "disk block %lu from the indirect brun",
+				   __func__, (unsigned long)indirblockno + i);
 			return BEFS_ERR;
 		}
 
@@ -348,9 +349,10 @@ befs_find_brun_indirect(struct super_block *sb,
 
 				brelse(indirblock);
 				befs_debug(sb,
-					   "<--- befs_find_brun_indirect() found "
-					   "file block %lu at indirect[%d]",
-					   blockno, j + (i * arraylen));
+					   "<--- %s found file block "
+					   "%lu at indirect[%d]", __func__,
+					   (unsigned long)blockno,
+					   j + (i * arraylen));
 				return BEFS_OK;
 			}
 			sum += len;
@@ -360,10 +362,10 @@ befs_find_brun_indirect(struct super_block *sb,
 	}
 
 	/* Only fallthrough is an error */
-	befs_error(sb, "BeFS: befs_find_brun_indirect() failed to find "
-		   "file block %lu", blockno);
+	befs_error(sb, "BeFS: %s failed to find "
+		   "file block %lu", __func__, (unsigned long)blockno);
 
-	befs_debug(sb, "<--- befs_find_brun_indirect() ERROR");
+	befs_debug(sb, "<--- %s ERROR", __func__);
 	return BEFS_ERR;
 }
 
@@ -444,7 +446,7 @@ befs_find_brun_dblindirect(struct super_block *sb,
 	size_t diblklen = iblklen * befs_iaddrs_per_block(sb)
 	    * BEFS_DBLINDIR_BRUN_LEN;
 
-	befs_debug(sb, "---> befs_find_brun_dblindirect() find %lu", blockno);
+	befs_debug(sb, "---> %s find %lu", __func__, (unsigned long)blockno);
 
 	/* First, discover which of the double_indir->indir blocks
 	 * contains pos. Then figure out how much of pos that
@@ -460,8 +462,9 @@ befs_find_brun_dblindirect(struct super_block *sb,
 	dbl_which_block = dblindir_indx / befs_iaddrs_per_block(sb);
 	if (dbl_which_block > data->double_indirect.len) {
 		befs_error(sb, "The double-indirect index calculated by "
-			   "befs_read_brun_dblindirect(), %d, is outside the range "
-			   "of the double-indirect block", dblindir_indx);
+			   "%s, %d, is outside the range "
+			   "of the double-indirect block", __func__,
+			   dblindir_indx);
 		return BEFS_ERR;
 	}
 
@@ -469,10 +472,10 @@ befs_find_brun_dblindirect(struct super_block *sb,
 	    befs_bread(sb, iaddr2blockno(sb, &data->double_indirect) +
 					dbl_which_block);
 	if (dbl_indir_block == NULL) {
-		befs_error(sb, "befs_read_brun_dblindirect() couldn't read the "
-			   "double-indirect block at blockno %lu",
-			   iaddr2blockno(sb,
-					 &data->double_indirect) +
+		befs_error(sb, "%s couldn't read the "
+			   "double-indirect block at blockno %lu", __func__,
+			   (unsigned long)
+			   iaddr2blockno(sb, &data->double_indirect) +
 			   dbl_which_block);
 		brelse(dbl_indir_block);
 		return BEFS_ERR;
@@ -489,16 +492,16 @@ befs_find_brun_dblindirect(struct super_block *sb,
 	which_block = indir_indx / befs_iaddrs_per_block(sb);
 	if (which_block > indir_run.len) {
 		befs_error(sb, "The indirect index calculated by "
-			   "befs_read_brun_dblindirect(), %d, is outside the range "
-			   "of the indirect block", indir_indx);
+			   "%s, %d, is outside the range "
+			   "of the indirect block", __func__, indir_indx);
 		return BEFS_ERR;
 	}
 
 	indir_block =
 	    befs_bread(sb, iaddr2blockno(sb, &indir_run) + which_block);
 	if (indir_block == NULL) {
-		befs_error(sb, "befs_read_brun_dblindirect() couldn't read the "
-			   "indirect block at blockno %lu",
+		befs_error(sb, "%s couldn't read the indirect block "
+			   "at blockno %lu", __func__, (unsigned long)
 			   iaddr2blockno(sb, &indir_run) + which_block);
 		brelse(indir_block);
 		return BEFS_ERR;
@@ -519,7 +522,7 @@ befs_find_brun_dblindirect(struct super_block *sb,
 	run->len -= offset;
 
 	befs_debug(sb, "Found file block %lu in double_indirect[%d][%d],"
-		   " double_indirect_leftover = %lu",
+		   " double_indirect_leftover = %lu", (unsigned long)
 		   blockno, dblindir_indx, indir_indx, dblindir_leftover);
 
 	return BEFS_OK;
diff --git a/fs/befs/debug.c b/fs/befs/debug.c
index 622e737..4de7cff 100644
--- a/fs/befs/debug.c
+++ b/fs/befs/debug.c
@@ -10,6 +10,7 @@
  * debug functions
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #ifdef __KERNEL__
 
 #include <stdarg.h>
@@ -23,43 +24,30 @@
 
 #include "befs.h"
 
-#define ERRBUFSIZE 1024
-
 void
 befs_error(const struct super_block *sb, const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
-	char *err_buf = kmalloc(ERRBUFSIZE, GFP_KERNEL);
-	if (err_buf == NULL) {
-		printk(KERN_ERR "could not allocate %d bytes\n", ERRBUFSIZE);
-		return;
-	}
 
 	va_start(args, fmt);
-	vsnprintf(err_buf, ERRBUFSIZE, fmt, args);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	pr_err("(%s): %pV\n", sb->s_id, &vaf);
 	va_end(args);
-
-	printk(KERN_ERR "BeFS(%s): %s\n", sb->s_id, err_buf);
-	kfree(err_buf);
 }
 
 void
 befs_warning(const struct super_block *sb, const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
-	char *err_buf = kmalloc(ERRBUFSIZE, GFP_KERNEL);
-	if (err_buf == NULL) {
-		printk(KERN_ERR "could not allocate %d bytes\n", ERRBUFSIZE);
-		return;
-	}
 
 	va_start(args, fmt);
-	vsnprintf(err_buf, ERRBUFSIZE, fmt, args);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	pr_warn("(%s): %pV\n", sb->s_id, &vaf);
 	va_end(args);
-
-	printk(KERN_WARNING "BeFS(%s): %s\n", sb->s_id, err_buf);
-
-	kfree(err_buf);
 }
 
 void
@@ -67,25 +55,13 @@ befs_debug(const struct super_block *sb, const char *fmt, ...)
 {
 #ifdef CONFIG_BEFS_DEBUG
 
+	struct va_format vaf;
 	va_list args;
-	char *err_buf = NULL;
-
-	if (BEFS_SB(sb)->mount_opts.debug) {
-		err_buf = kmalloc(ERRBUFSIZE, GFP_KERNEL);
-		if (err_buf == NULL) {
-			printk(KERN_ERR "could not allocate %d bytes\n",
-				ERRBUFSIZE);
-			return;
-		}
-
-		va_start(args, fmt);
-		vsnprintf(err_buf, ERRBUFSIZE, fmt, args);
-		va_end(args);
-
-		printk(KERN_DEBUG "BeFS(%s): %s\n", sb->s_id, err_buf);
-
-		kfree(err_buf);
-	}
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	pr_debug("(%s): %pV\n", sb->s_id, &vaf);
+	va_end(args);
 
 #endif				//CONFIG_BEFS_DEBUG
 }
@@ -109,9 +85,9 @@ befs_dump_inode(const struct super_block *sb, befs_inode * inode)
 	befs_debug(sb, "  gid %u", fs32_to_cpu(sb, inode->gid));
 	befs_debug(sb, "  mode %08x", fs32_to_cpu(sb, inode->mode));
 	befs_debug(sb, "  flags %08x", fs32_to_cpu(sb, inode->flags));
-	befs_debug(sb, "  create_time %Lu",
+	befs_debug(sb, "  create_time %llu",
 		   fs64_to_cpu(sb, inode->create_time));
-	befs_debug(sb, "  last_modified_time %Lu",
+	befs_debug(sb, "  last_modified_time %llu",
 		   fs64_to_cpu(sb, inode->last_modified_time));
 
 	tmp_run = fsrun_to_cpu(sb, inode->parent);
@@ -137,7 +113,7 @@ befs_dump_inode(const struct super_block *sb, befs_inode * inode)
 				   tmp_run.allocation_group, tmp_run.start,
 				   tmp_run.len);
 		}
-		befs_debug(sb, "  max_direct_range %Lu",
+		befs_debug(sb, "  max_direct_range %llu",
 			   fs64_to_cpu(sb,
 				       inode->data.datastream.
 				       max_direct_range));
@@ -147,7 +123,7 @@ befs_dump_inode(const struct super_block *sb, befs_inode * inode)
 			   tmp_run.allocation_group,
 			   tmp_run.start, tmp_run.len);
 
-		befs_debug(sb, "  max_indirect_range %Lu",
+		befs_debug(sb, "  max_indirect_range %llu",
 			   fs64_to_cpu(sb,
 				       inode->data.datastream.
 				       max_indirect_range));
@@ -158,12 +134,12 @@ befs_dump_inode(const struct super_block *sb, befs_inode * inode)
 			   tmp_run.allocation_group, tmp_run.start,
 			   tmp_run.len);
 
-		befs_debug(sb, "  max_double_indirect_range %Lu",
+		befs_debug(sb, "  max_double_indirect_range %llu",
 			   fs64_to_cpu(sb,
 				       inode->data.datastream.
 				       max_double_indirect_range));
 
-		befs_debug(sb, "  size %Lu",
+		befs_debug(sb, "  size %llu",
 			   fs64_to_cpu(sb, inode->data.datastream.size));
 	}
 
@@ -191,8 +167,8 @@ befs_dump_super_block(const struct super_block *sb, befs_super_block * sup)
 	befs_debug(sb, "  block_size %u", fs32_to_cpu(sb, sup->block_size));
 	befs_debug(sb, "  block_shift %u", fs32_to_cpu(sb, sup->block_shift));
 
-	befs_debug(sb, "  num_blocks %Lu", fs64_to_cpu(sb, sup->num_blocks));
-	befs_debug(sb, "  used_blocks %Lu", fs64_to_cpu(sb, sup->used_blocks));
+	befs_debug(sb, "  num_blocks %llu", fs64_to_cpu(sb, sup->num_blocks));
+	befs_debug(sb, "  used_blocks %llu", fs64_to_cpu(sb, sup->used_blocks));
 
 	befs_debug(sb, "  magic2 %08x", fs32_to_cpu(sb, sup->magic2));
 	befs_debug(sb, "  blocks_per_ag %u",
@@ -206,8 +182,8 @@ befs_dump_super_block(const struct super_block *sb, befs_super_block * sup)
 	befs_debug(sb, "  log_blocks %u, %hu, %hu",
 		   tmp_run.allocation_group, tmp_run.start, tmp_run.len);
 
-	befs_debug(sb, "  log_start %Ld", fs64_to_cpu(sb, sup->log_start));
-	befs_debug(sb, "  log_end %Ld", fs64_to_cpu(sb, sup->log_end));
+	befs_debug(sb, "  log_start %lld", fs64_to_cpu(sb, sup->log_start));
+	befs_debug(sb, "  log_end %lld", fs64_to_cpu(sb, sup->log_end));
 
 	befs_debug(sb, "  magic3 %08x", fs32_to_cpu(sb, sup->magic3));
 
diff --git a/fs/befs/inode.c b/fs/befs/inode.c
index 94c17f9..fa4b718 100644
--- a/fs/befs/inode.c
+++ b/fs/befs/inode.c
@@ -25,7 +25,8 @@ befs_check_inode(struct super_block *sb, befs_inode * raw_inode,
 	/* check magic header. */
 	if (magic1 != BEFS_INODE_MAGIC1) {
 		befs_error(sb,
-			   "Inode has a bad magic header - inode = %lu", inode);
+			   "Inode has a bad magic header - inode = %lu",
+			   (unsigned long)inode);
 		return BEFS_BAD_INODE;
 	}
 
@@ -34,8 +35,8 @@ befs_check_inode(struct super_block *sb, befs_inode * raw_inode,
 	 */
 	if (inode != iaddr2blockno(sb, &ino_num)) {
 		befs_error(sb, "inode blocknr field disagrees with vfs "
-			   "VFS: %lu, Inode %lu",
-			   inode, iaddr2blockno(sb, &ino_num));
+			   "VFS: %lu, Inode %lu", (unsigned long)
+			   inode, (unsigned long)iaddr2blockno(sb, &ino_num));
 		return BEFS_BAD_INODE;
 	}
 
@@ -44,7 +45,8 @@ befs_check_inode(struct super_block *sb, befs_inode * raw_inode,
 	 */
 
 	if (!(flags & BEFS_INODE_IN_USE)) {
-		befs_error(sb, "inode is not used - inode = %lu", inode);
+		befs_error(sb, "inode is not used - inode = %lu",
+			   (unsigned long)inode);
 		return BEFS_BAD_INODE;
 	}
 
diff --git a/fs/befs/io.c b/fs/befs/io.c
index ddef98a..0408a3d 100644
--- a/fs/befs/io.c
+++ b/fs/befs/io.c
@@ -30,9 +30,9 @@ befs_bread_iaddr(struct super_block *sb, befs_inode_addr iaddr)
 	befs_blocknr_t block = 0;
 	befs_sb_info *befs_sb = BEFS_SB(sb);
 
-	befs_debug(sb, "---> Enter befs_read_iaddr() "
-		   "[%u, %hu, %hu]",
-		   iaddr.allocation_group, iaddr.start, iaddr.len);
+	befs_debug(sb, "---> Enter %s "
+		   "[%u, %hu, %hu]", __func__, iaddr.allocation_group,
+		   iaddr.start, iaddr.len);
 
 	if (iaddr.allocation_group > befs_sb->num_ags) {
 		befs_error(sb, "BEFS: Invalid allocation group %u, max is %u",
@@ -42,20 +42,21 @@ befs_bread_iaddr(struct super_block *sb, befs_inode_addr iaddr)
 
 	block = iaddr2blockno(sb, &iaddr);
 
-	befs_debug(sb, "befs_read_iaddr: offset = %lu", block);
+	befs_debug(sb, "%s: offset = %lu", __func__, (unsigned long)block);
 
 	bh = sb_bread(sb, block);
 
 	if (bh == NULL) {
-		befs_error(sb, "Failed to read block %lu", block);
+		befs_error(sb, "Failed to read block %lu",
+			   (unsigned long)block);
 		goto error;
 	}
 
-	befs_debug(sb, "<--- befs_read_iaddr()");
+	befs_debug(sb, "<--- %s", __func__);
 	return bh;
 
       error:
-	befs_debug(sb, "<--- befs_read_iaddr() ERROR");
+	befs_debug(sb, "<--- %s ERROR", __func__);
 	return NULL;
 }
 
@@ -64,20 +65,21 @@ befs_bread(struct super_block *sb, befs_blocknr_t block)
 {
 	struct buffer_head *bh = NULL;
 
-	befs_debug(sb, "---> Enter befs_read() %Lu", block);
+	befs_debug(sb, "---> Enter %s %lu", __func__, (unsigned long)block);
 
 	bh = sb_bread(sb, block);
 
 	if (bh == NULL) {
-		befs_error(sb, "Failed to read block %lu", block);
+		befs_error(sb, "Failed to read block %lu",
+			   (unsigned long)block);
 		goto error;
 	}
 
-	befs_debug(sb, "<--- befs_read()");
+	befs_debug(sb, "<--- %s", __func__);
 
 	return bh;
 
       error:
-	befs_debug(sb, "<--- befs_read() ERROR");
+	befs_debug(sb, "<--- %s ERROR", __func__);
 	return NULL;
 }
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 845d2d6..5ce8fcc 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -5,6 +5,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
@@ -131,26 +133,28 @@ befs_get_block(struct inode *inode, sector_t block,
 	ulong disk_off;
 
 	befs_debug(sb, "---> befs_get_block() for inode %lu, block %ld",
-		   inode->i_ino, block);
+		   (unsigned long)inode->i_ino, (long)block);
 
 	if (block < 0) {
 		befs_error(sb, "befs_get_block() was asked for a block "
 			   "number less than zero: block %ld in inode %lu",
-			   block, inode->i_ino);
+			   (long)block, (unsigned long)inode->i_ino);
 		return -EIO;
 	}
 
 	if (create) {
 		befs_error(sb, "befs_get_block() was asked to write to "
-			   "block %ld in inode %lu", block, inode->i_ino);
+			   "block %ld in inode %lu", (long)block,
+			   (unsigned long)inode->i_ino);
 		return -EPERM;
 	}
 
 	res = befs_fblock2brun(sb, ds, block, &run);
 	if (res != BEFS_OK) {
 		befs_error(sb,
-			   "<--- befs_get_block() for inode %lu, block "
-			   "%ld ERROR", inode->i_ino, block);
+			   "<--- %s for inode %lu, block %ld ERROR",
+			   __func__, (unsigned long)inode->i_ino,
+			   (long)block);
 		return -EFBIG;
 	}
 
@@ -158,8 +162,9 @@ befs_get_block(struct inode *inode, sector_t block,
 
 	map_bh(bh_result, inode->i_sb, disk_off);
 
-	befs_debug(sb, "<--- befs_get_block() for inode %lu, block %ld, "
-		   "disk address %lu", inode->i_ino, block, disk_off);
+	befs_debug(sb, "<--- %s for inode %lu, block %ld, disk address %lu",
+		  __func__, (unsigned long)inode->i_ino, (long)block,
+		  (unsigned long)disk_off);
 
 	return 0;
 }
@@ -176,15 +181,15 @@ befs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 	char *utfname;
 	const char *name = dentry->d_name.name;
 
-	befs_debug(sb, "---> befs_lookup() "
-		   "name %s inode %ld", dentry->d_name.name, dir->i_ino);
+	befs_debug(sb, "---> %s name %s inode %ld", __func__,
+		   dentry->d_name.name, dir->i_ino);
 
 	/* Convert to UTF-8 */
 	if (BEFS_SB(sb)->nls) {
 		ret =
 		    befs_nls2utf(sb, name, strlen(name), &utfname, &utfnamelen);
 		if (ret < 0) {
-			befs_debug(sb, "<--- befs_lookup() ERROR");
+			befs_debug(sb, "<--- %s ERROR", __func__);
 			return ERR_PTR(ret);
 		}
 		ret = befs_btree_find(sb, ds, utfname, &offset);
@@ -195,12 +200,12 @@ befs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 	}
 
 	if (ret == BEFS_BT_NOT_FOUND) {
-		befs_debug(sb, "<--- befs_lookup() %s not found",
+		befs_debug(sb, "<--- %s %s not found", __func__,
 			   dentry->d_name.name);
 		return ERR_PTR(-ENOENT);
 
 	} else if (ret != BEFS_OK || offset == 0) {
-		befs_warning(sb, "<--- befs_lookup() Error");
+		befs_warning(sb, "<--- %s Error", __func__);
 		return ERR_PTR(-ENODATA);
 	}
 
@@ -210,7 +215,7 @@ befs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 
 	d_add(dentry, inode);
 
-	befs_debug(sb, "<--- befs_lookup()");
+	befs_debug(sb, "<--- %s", __func__);
 
 	return NULL;
 }
@@ -228,26 +233,25 @@ befs_readdir(struct file *file, struct dir_context *ctx)
 	char keybuf[BEFS_NAME_LEN + 1];
 	const char *dirname = file->f_path.dentry->d_name.name;
 
-	befs_debug(sb, "---> befs_readdir() "
-		   "name %s, inode %ld, ctx->pos %Ld",
-		   dirname, inode->i_ino, ctx->pos);
+	befs_debug(sb, "---> %s name %s, inode %ld, ctx->pos %lld",
+		  __func__, dirname, inode->i_ino, ctx->pos);
 
 more:
 	result = befs_btree_read(sb, ds, ctx->pos, BEFS_NAME_LEN + 1,
 				 keybuf, &keysize, &value);
 
 	if (result == BEFS_ERR) {
-		befs_debug(sb, "<--- befs_readdir() ERROR");
+		befs_debug(sb, "<--- %s ERROR", __func__);
 		befs_error(sb, "IO error reading %s (inode %lu)",
 			   dirname, inode->i_ino);
 		return -EIO;
 
 	} else if (result == BEFS_BT_END) {
-		befs_debug(sb, "<--- befs_readdir() END");
+		befs_debug(sb, "<--- %s END", __func__);
 		return 0;
 
 	} else if (result == BEFS_BT_EMPTY) {
-		befs_debug(sb, "<--- befs_readdir() Empty directory");
+		befs_debug(sb, "<--- %s Empty directory", __func__);
 		return 0;
 	}
 
@@ -260,7 +264,7 @@ more:
 		result =
 		    befs_utf2nls(sb, keybuf, keysize, &nlsname, &nlsnamelen);
 		if (result < 0) {
-			befs_debug(sb, "<--- befs_readdir() ERROR");
+			befs_debug(sb, "<--- %s ERROR", __func__);
 			return result;
 		}
 		if (!dir_emit(ctx, nlsname, nlsnamelen,
@@ -277,7 +281,7 @@ more:
 	ctx->pos++;
 	goto more;
 
-	befs_debug(sb, "<--- befs_readdir() pos %Ld", ctx->pos);
+	befs_debug(sb, "<--- %s pos %lld", __func__, ctx->pos);
 
 	return 0;
 }
@@ -321,7 +325,7 @@ static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
 	struct inode *inode;
 	long ret = -EIO;
 
-	befs_debug(sb, "---> befs_read_inode() " "inode = %lu", ino);
+	befs_debug(sb, "---> %s inode = %lu", __func__, ino);
 
 	inode = iget_locked(sb, ino);
 	if (!inode)
@@ -428,7 +432,7 @@ static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
 	}
 
 	brelse(bh);
-	befs_debug(sb, "<--- befs_read_inode()");
+	befs_debug(sb, "<--- %s", __func__);
 	unlock_new_inode(inode);
 	return inode;
 
@@ -437,7 +441,7 @@ static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
 
       unacquire_none:
 	iget_failed(inode);
-	befs_debug(sb, "<--- befs_read_inode() - Bad inode");
+	befs_debug(sb, "<--- %s - Bad inode", __func__);
 	return ERR_PTR(ret);
 }
 
@@ -454,11 +458,9 @@ befs_init_inodecache(void)
 						SLAB_MEM_SPREAD),
 					      init_once);
 	if (befs_inode_cachep == NULL) {
-		printk(KERN_ERR "befs_init_inodecache: "
-		       "Couldn't initialize inode slabcache\n");
+		pr_err("%s: Couldn't initialize inode slabcache\n", __func__);
 		return -ENOMEM;
 	}
-
 	return 0;
 }
 
@@ -544,16 +546,16 @@ befs_utf2nls(struct super_block *sb, const char *in,
 	 */
 	int maxlen = in_len + 1;
 
-	befs_debug(sb, "---> utf2nls()");
+	befs_debug(sb, "---> %s", __func__);
 
 	if (!nls) {
-		befs_error(sb, "befs_utf2nls called with no NLS table loaded");
+		befs_error(sb, "%s called with no NLS table loaded", __func__);
 		return -EINVAL;
 	}
 
 	*out = result = kmalloc(maxlen, GFP_NOFS);
 	if (!*out) {
-		befs_error(sb, "befs_utf2nls() cannot allocate memory");
+		befs_error(sb, "%s cannot allocate memory", __func__);
 		*out_len = 0;
 		return -ENOMEM;
 	}
@@ -575,14 +577,14 @@ befs_utf2nls(struct super_block *sb, const char *in,
 	result[o] = '\0';
 	*out_len = o;
 
-	befs_debug(sb, "<--- utf2nls()");
+	befs_debug(sb, "<--- %s", __func__);
 
 	return o;
 
       conv_err:
 	befs_error(sb, "Name using character set %s contains a character that "
 		   "cannot be converted to unicode.", nls->charset);
-	befs_debug(sb, "<--- utf2nls()");
+	befs_debug(sb, "<--- %s", __func__);
 	kfree(result);
 	return -EILSEQ;
 }
@@ -623,16 +625,17 @@ befs_nls2utf(struct super_block *sb, const char *in,
 	 * in special cases */
 	int maxlen = (3 * in_len) + 1;
 
-	befs_debug(sb, "---> nls2utf()\n");
+	befs_debug(sb, "---> %s\n", __func__);
 
 	if (!nls) {
-		befs_error(sb, "befs_nls2utf called with no NLS table loaded.");
+		befs_error(sb, "%s called with no NLS table loaded.",
+			   __func__);
 		return -EINVAL;
 	}
 
 	*out = result = kmalloc(maxlen, GFP_NOFS);
 	if (!*out) {
-		befs_error(sb, "befs_nls2utf() cannot allocate memory");
+		befs_error(sb, "%s cannot allocate memory", __func__);
 		*out_len = 0;
 		return -ENOMEM;
 	}
@@ -653,14 +656,14 @@ befs_nls2utf(struct super_block *sb, const char *in,
 	result[o] = '\0';
 	*out_len = o;
 
-	befs_debug(sb, "<--- nls2utf()");
+	befs_debug(sb, "<--- %s", __func__);
 
 	return i;
 
       conv_err:
 	befs_error(sb, "Name using charecter set %s contains a charecter that "
 		   "cannot be converted to unicode.", nls->charset);
-	befs_debug(sb, "<--- nls2utf()");
+	befs_debug(sb, "<--- %s", __func__);
 	kfree(result);
 	return -EILSEQ;
 }
@@ -715,8 +718,8 @@ parse_options(char *options, befs_mount_options * opts)
 			if (option >= 0)
 				uid = make_kuid(current_user_ns(), option);
 			if (!uid_valid(uid)) {
-				printk(KERN_ERR "BeFS: Invalid uid %d, "
-						"using default\n", option);
+				pr_err("Invalid uid %d, "
+				       "using default\n", option);
 				break;
 			}
 			opts->uid = uid;
@@ -729,8 +732,8 @@ parse_options(char *options, befs_mount_options * opts)
 			if (option >= 0)
 				gid = make_kgid(current_user_ns(), option);
 			if (!gid_valid(gid)) {
-				printk(KERN_ERR "BeFS: Invalid gid %d, "
-						"using default\n", option);
+				pr_err("Invalid gid %d, "
+				       "using default\n", option);
 				break;
 			}
 			opts->gid = gid;
@@ -740,8 +743,8 @@ parse_options(char *options, befs_mount_options * opts)
 			kfree(opts->iocharset);
 			opts->iocharset = match_strdup(&args[0]);
 			if (!opts->iocharset) {
-				printk(KERN_ERR "BeFS: allocation failure for "
-						"iocharset string\n");
+				pr_err("allocation failure for "
+				       "iocharset string\n");
 				return 0;
 			}
 			break;
@@ -749,8 +752,8 @@ parse_options(char *options, befs_mount_options * opts)
 			opts->debug = 1;
 			break;
 		default:
-			printk(KERN_ERR "BeFS: Unrecognized mount option \"%s\" "
-					"or missing value\n", p);
+			pr_err("Unrecognized mount option \"%s\" "
+			       "or missing value\n", p);
 			return 0;
 		}
 	}
@@ -793,8 +796,7 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_fs_info = kmalloc(sizeof (*befs_sb), GFP_KERNEL);
 	if (sb->s_fs_info == NULL) {
-		printk(KERN_ERR
-		       "BeFS(%s): Unable to allocate memory for private "
+		pr_err("(%s): Unable to allocate memory for private "
 		       "portion of superblock. Bailing.\n", sb->s_id);
 		goto unacquire_none;
 	}
@@ -806,7 +808,7 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
 		goto unacquire_priv_sbp;
 	}
 
-	befs_debug(sb, "---> befs_fill_super()");
+	befs_debug(sb, "---> %s", __func__);
 
 #ifndef CONFIG_BEFS_RW
 	if (!(sb->s_flags & MS_RDONLY)) {
@@ -854,7 +856,7 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
 		goto unacquire_priv_sbp;
 
 	if( befs_sb->num_blocks > ~((sector_t)0) ) {
-		befs_error(sb, "blocks count: %Lu "
+		befs_error(sb, "blocks count: %llu "
 			"is larger than the host can use",
 			befs_sb->num_blocks);
 		goto unacquire_priv_sbp;
@@ -924,7 +926,7 @@ befs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	struct super_block *sb = dentry->d_sb;
 	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 
-	befs_debug(sb, "---> befs_statfs()");
+	befs_debug(sb, "---> %s", __func__);
 
 	buf->f_type = BEFS_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
@@ -937,7 +939,7 @@ befs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_fsid.val[1] = (u32)(id >> 32);
 	buf->f_namelen = BEFS_NAME_LEN;
 
-	befs_debug(sb, "<--- befs_statfs()");
+	befs_debug(sb, "<--- %s", __func__);
 
 	return 0;
 }
@@ -963,7 +965,7 @@ init_befs_fs(void)
 {
 	int err;
 
-	printk(KERN_INFO "BeFS version: %s\n", BEFS_VERSION);
+	pr_info("version: %s\n", BEFS_VERSION);
 
 	err = befs_init_inodecache();
 	if (err)
-- 
1.8.1.4

