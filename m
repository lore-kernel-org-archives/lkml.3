Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab3AMRyh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:54:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34966 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755303Ab3AMRp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:27 -0500
Message-Id: <20130113174259.796403049@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:14 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Weston Andros Adamson <dros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 19/49] NFSv4: Add ACCESS operation to OPEN compound
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weston Andros Adamson <dros@netapp.com>

commit 6168f62cbde8dcf4f58255794efbcdb8df603959 upstream.

The OPEN operation has no way to differentiate an open for read and an
open for execution - both look like read to the server. This allowed
users to read files that didn't have READ access but did have EXEC access,
which is obviously wrong.

This patch adds an ACCESS call to the OPEN compound to handle the
difference between OPENs for reading and execution.  Since we're going
through the trouble of calling ACCESS, we check all possible access bits
and cache the results hopefully avoiding an ACCESS call in the future.

Signed-off-by: Weston Andros Adamson <dros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
[bwh: Backported to 3.2:
 - Adjust context
 - #include <linux/export.h> in fs/nfs/dir.c]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -35,6 +35,7 @@
 #include <linux/sched.h>
 #include <linux/kmemleak.h>
 #include <linux/xattr.h>
+#include <linux/export.h>
 
 #include "delegation.h"
 #include "iostat.h"
@@ -2219,7 +2220,7 @@ found:
 	nfs_access_free_entry(entry);
 }
 
-static void nfs_access_add_cache(struct inode *inode, struct nfs_access_entry *set)
+void nfs_access_add_cache(struct inode *inode, struct nfs_access_entry *set)
 {
 	struct nfs_access_entry *cache = kmalloc(sizeof(*cache), GFP_KERNEL);
 	if (cache == NULL)
@@ -2245,6 +2246,20 @@ static void nfs_access_add_cache(struct
 		spin_unlock(&nfs_access_lru_lock);
 	}
 }
+EXPORT_SYMBOL_GPL(nfs_access_add_cache);
+
+void nfs_access_set_mask(struct nfs_access_entry *entry, u32 access_result)
+{
+	entry->mask = 0;
+	if (access_result & NFS4_ACCESS_READ)
+		entry->mask |= MAY_READ;
+	if (access_result &
+	    (NFS4_ACCESS_MODIFY | NFS4_ACCESS_EXTEND | NFS4_ACCESS_DELETE))
+		entry->mask |= MAY_WRITE;
+	if (access_result & (NFS4_ACCESS_LOOKUP|NFS4_ACCESS_EXECUTE))
+		entry->mask |= MAY_EXEC;
+}
+EXPORT_SYMBOL_GPL(nfs_access_set_mask);
 
 static int nfs_do_access(struct inode *inode, struct rpc_cred *cred, int mask)
 {
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -98,6 +98,8 @@ static int nfs4_map_errors(int err)
 		return -EINVAL;
 	case -NFS4ERR_SHARE_DENIED:
 		return -EACCES;
+	case -NFS4ERR_ACCESS:
+		return -EACCES;
 	default:
 		dprintk("%s could not handle NFSv4 error %d\n",
 				__func__, -err);
@@ -827,6 +829,9 @@ static struct nfs4_opendata *nfs4_openda
 	p->o_arg.fh = NFS_FH(dir);
 	p->o_arg.open_flags = flags;
 	p->o_arg.fmode = fmode & (FMODE_READ|FMODE_WRITE);
+	/* ask server to check for all possible rights as results are cached */
+	p->o_arg.access = NFS4_ACCESS_READ | NFS4_ACCESS_MODIFY |
+			  NFS4_ACCESS_EXTEND | NFS4_ACCESS_EXECUTE;
 	p->o_arg.clientid = server->nfs_client->cl_clientid;
 	p->o_arg.id = sp->so_owner_id.id;
 	p->o_arg.name = &dentry->d_name;
@@ -1608,6 +1613,39 @@ static int _nfs4_recover_proc_open(struc
 	return status;
 }
 
+static int nfs4_opendata_access(struct rpc_cred *cred,
+				struct nfs4_opendata *opendata,
+				struct nfs4_state *state, fmode_t fmode)
+{
+	struct nfs_access_entry cache;
+	u32 mask;
+
+	/* access call failed or for some reason the server doesn't
+	 * support any access modes -- defer access call until later */
+	if (opendata->o_res.access_supported == 0)
+		return 0;
+
+	mask = 0;
+	if (fmode & FMODE_READ)
+		mask |= MAY_READ;
+	if (fmode & FMODE_WRITE)
+		mask |= MAY_WRITE;
+	if (fmode & FMODE_EXEC)
+		mask |= MAY_EXEC;
+
+	cache.cred = cred;
+	cache.jiffies = jiffies;
+	nfs_access_set_mask(&cache, opendata->o_res.access_result);
+	nfs_access_add_cache(state->inode, &cache);
+
+	if ((mask & ~cache.mask & (MAY_READ | MAY_WRITE | MAY_EXEC)) == 0)
+		return 0;
+
+	/* even though OPEN succeeded, access is denied. Close the file */
+	nfs4_close_state(state, fmode);
+	return -NFS4ERR_ACCESS;
+}
+
 /*
  * Note: On error, nfs4_proc_open will free the struct nfs4_opendata
  */
@@ -1794,6 +1832,10 @@ static int _nfs4_do_open(struct inode *d
 	if (server->caps & NFS_CAP_POSIX_LOCK)
 		set_bit(NFS_STATE_POSIX_LOCKS, &state->flags);
 
+	status = nfs4_opendata_access(cred, opendata, state, fmode);
+	if (status != 0)
+		goto err_opendata_put;
+
 	if (opendata->o_arg.open_flags & O_EXCL) {
 		nfs4_exclusive_attrset(opendata, sattr);
 
@@ -1826,7 +1868,7 @@ static struct nfs4_state *nfs4_do_open(s
 	struct nfs4_state *res;
 	int status;
 
-	fmode &= FMODE_READ|FMODE_WRITE;
+	fmode &= FMODE_READ|FMODE_WRITE|FMODE_EXEC;
 	do {
 		status = _nfs4_do_open(dir, dentry, fmode, flags, sattr, cred, &res);
 		if (status == 0)
@@ -2550,13 +2592,7 @@ static int _nfs4_proc_access(struct inod
 
 	status = nfs4_call_sync(server->client, server, &msg, &args.seq_args, &res.seq_res, 0);
 	if (!status) {
-		entry->mask = 0;
-		if (res.access & NFS4_ACCESS_READ)
-			entry->mask |= MAY_READ;
-		if (res.access & (NFS4_ACCESS_MODIFY | NFS4_ACCESS_EXTEND | NFS4_ACCESS_DELETE))
-			entry->mask |= MAY_WRITE;
-		if (res.access & (NFS4_ACCESS_LOOKUP|NFS4_ACCESS_EXECUTE))
-			entry->mask |= MAY_EXEC;
+		nfs_access_set_mask(entry, res.access);
 		nfs_refresh_inode(inode, res.fattr);
 	}
 	nfs_free_fattr(res.fattr);
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -422,6 +422,7 @@ static int nfs4_stat_to_errno(int);
 				encode_putfh_maxsz + \
 				encode_savefh_maxsz + \
 				encode_open_maxsz + \
+				encode_access_maxsz + \
 				encode_getfh_maxsz + \
 				encode_getattr_maxsz + \
 				encode_restorefh_maxsz + \
@@ -431,6 +432,7 @@ static int nfs4_stat_to_errno(int);
 				decode_putfh_maxsz + \
 				decode_savefh_maxsz + \
 				decode_open_maxsz + \
+				decode_access_maxsz + \
 				decode_getfh_maxsz + \
 				decode_getattr_maxsz + \
 				decode_restorefh_maxsz + \
@@ -447,11 +449,13 @@ static int nfs4_stat_to_errno(int);
 					encode_sequence_maxsz + \
 					encode_putfh_maxsz + \
 					encode_open_maxsz + \
+					encode_access_maxsz + \
 					encode_getattr_maxsz)
 #define NFS4_dec_open_noattr_sz	(compound_decode_hdr_maxsz + \
 					decode_sequence_maxsz + \
 					decode_putfh_maxsz + \
 					decode_open_maxsz + \
+					decode_access_maxsz + \
 					decode_getattr_maxsz)
 #define NFS4_enc_open_downgrade_sz \
 				(compound_encode_hdr_maxsz + \
@@ -2296,6 +2300,7 @@ static void nfs4_xdr_enc_open(struct rpc
 	encode_savefh(xdr, &hdr);
 	encode_open(xdr, args, &hdr);
 	encode_getfh(xdr, &hdr);
+	encode_access(xdr, args->access, &hdr);
 	encode_getfattr(xdr, args->bitmask, &hdr);
 	encode_restorefh(xdr, &hdr);
 	encode_getfattr(xdr, args->bitmask, &hdr);
@@ -2334,6 +2339,7 @@ static void nfs4_xdr_enc_open_noattr(str
 	encode_sequence(xdr, &args->seq_args, &hdr);
 	encode_putfh(xdr, args->fh, &hdr);
 	encode_open(xdr, args, &hdr);
+	encode_access(xdr, args->access, &hdr);
 	encode_getfattr(xdr, args->bitmask, &hdr);
 	encode_nops(&hdr);
 }
@@ -4110,7 +4116,7 @@ out_overflow:
 	return -EIO;
 }
 
-static int decode_access(struct xdr_stream *xdr, struct nfs4_accessres *access)
+static int decode_access(struct xdr_stream *xdr, u32 *supported, u32 *access)
 {
 	__be32 *p;
 	uint32_t supp, acc;
@@ -4124,8 +4130,8 @@ static int decode_access(struct xdr_stre
 		goto out_overflow;
 	supp = be32_to_cpup(p++);
 	acc = be32_to_cpup(p);
-	access->supported = supp;
-	access->access = acc;
+	*supported = supp;
+	*access = acc;
 	return 0;
 out_overflow:
 	print_overflow_msg(__func__, xdr);
@@ -5738,7 +5744,7 @@ static int nfs4_xdr_dec_access(struct rp
 	status = decode_putfh(xdr);
 	if (status != 0)
 		goto out;
-	status = decode_access(xdr, res);
+	status = decode_access(xdr, &res->supported, &res->access);
 	if (status != 0)
 		goto out;
 	decode_getfattr(xdr, res->fattr, res->server,
@@ -6116,6 +6122,7 @@ static int nfs4_xdr_dec_open(struct rpc_
 	status = decode_getfh(xdr, &res->fh);
 	if (status)
 		goto out;
+	decode_access(xdr, &res->access_supported, &res->access_result);
 	if (decode_getfattr(xdr, res->f_attr, res->server,
 				!RPC_IS_ASYNC(rqstp->rq_task)) != 0)
 		goto out;
@@ -6170,6 +6177,7 @@ static int nfs4_xdr_dec_open_noattr(stru
 	status = decode_open(xdr, res);
 	if (status)
 		goto out;
+	decode_access(xdr, &res->access_supported, &res->access_result);
 	decode_getfattr(xdr, res->f_attr, res->server,
 			!RPC_IS_ASYNC(rqstp->rq_task));
 out:
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -356,6 +356,8 @@ extern int nfs_refresh_inode(struct inod
 extern int nfs_post_op_update_inode(struct inode *inode, struct nfs_fattr *fattr);
 extern int nfs_post_op_update_inode_force_wcc(struct inode *inode, struct nfs_fattr *fattr);
 extern int nfs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
+extern void nfs_access_add_cache(struct inode *, struct nfs_access_entry *);
+extern void nfs_access_set_mask(struct nfs_access_entry *, u32);
 extern int nfs_permission(struct inode *, int);
 extern int nfs_open(struct inode *, struct file *);
 extern int nfs_release(struct inode *, struct file *);
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -311,6 +311,7 @@ struct nfs_openargs {
 	struct nfs_seqid *	seqid;
 	int			open_flags;
 	fmode_t			fmode;
+	u32			access;
 	__u64                   clientid;
 	__u64                   id;
 	union {
@@ -343,6 +344,8 @@ struct nfs_openres {
 	__u64			maxsize;
 	__u32			attrset[NFS4_BITMAP_SIZE];
 	struct nfs4_sequence_res	seq_res;
+	__u32			access_supported;
+	__u32			access_result;
 };
 
 /*


